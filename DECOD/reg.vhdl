library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
	port(
	-- Write Port 1 prioritaire
		wdata1		: in Std_Logic_Vector(31 downto 0);
		wadr1			: in Std_Logic_Vector(3 downto 0);
		wen1			: in Std_Logic;

	-- Write Port 2 non prioritaire
		wdata2		: in Std_Logic_Vector(31 downto 0);
		wadr2			: in Std_Logic_Vector(3 downto 0);
		wen2			: in Std_Logic;

	-- Write CSPR Port
		wcry			: in Std_Logic;
		wzero			: in Std_Logic;
		wneg			: in Std_Logic;
		wovr			: in Std_Logic;
		cspr_wb		: in Std_Logic;
		
	-- Read Port 1 32 bits
		reg_rd1		: out Std_Logic_Vector(31 downto 0);
		radr1			: in Std_Logic_Vector(3 downto 0);
		reg_v1		: out Std_Logic;

	-- Read Port 2 32 bits
		reg_rd2		: out Std_Logic_Vector(31 downto 0);
		radr2			: in Std_Logic_Vector(3 downto 0);
		reg_v2		: out Std_Logic;

	-- Read Port 3 32 bits
		reg_rd3		: out Std_Logic_Vector(31 downto 0);
		radr3			: in Std_Logic_Vector(3 downto 0);
		reg_v3		: out Std_Logic;

	-- read CSPR Port
		reg_cry		: out Std_Logic;
		reg_zero		: out Std_Logic;
		reg_neg		: out Std_Logic;
		reg_cznv		: out Std_Logic;
		reg_ovr		: out Std_Logic;
		reg_vv		: out Std_Logic;
		
	-- Invalidate Port 
		inval_adr1	: in Std_Logic_Vector(3 downto 0);
		inval1		: in Std_Logic;

		inval_adr2	: in Std_Logic_Vector(3 downto 0);
		inval2		: in Std_Logic;

		inval_czn	: in Std_Logic;
		inval_ovr	: in Std_Logic;

	-- PC
		reg_pc		: out Std_Logic_Vector(31 downto 0);
		reg_pcv		: out Std_Logic;
		inc_pc		: in Std_Logic;
	
	-- global interface
		ck				: in Std_Logic;
		reset_n		: in Std_Logic;
		vdd			: in bit;
		vss			: in bit);
end Reg;

architecture Behavior OF Reg is
type reg_array is array (0 to 15) of std_logic_vector(31 downto 0);
signal reg_var: reg_array;
signal c,z,n,v,vv,cznv,pcv: std_logic;
signal valid_reg: std_logic_vector(15 downto 0);
begin
process (ck,reset_n)
	variable pc_int: integer;
	variable pc_33_bits: std_logic_vector(32 downto 0);

begin
if rising_edge(ck) then
	if (reset_n = '0') then
		for i in 0 to 15 loop
			reg_var(i)<= X"00000000";
		end loop;
		c <= '0';
		z <= '0';
		n <= '0';
		v <= '0';
		pcv <= '1';
		cznv <= '1';
		vv <= '1';
		valid_reg <= X"FFFF";
	else 

	---------------------------------------------------- pc --------------------------------------------
		if (pcv = '1') then
			if ((inval1 ='1' and inval_adr1 = x"F") or (inval2 ='1' and inval_adr2 = x"F")) then
				pcv <= '0';
			end if;
		else
			if ((wen1 = '1' and wadr1 = x"F") or (wen2 = '1' and wadr2 = x"F")) then
				pcv <= '1';
			end if;
		end if;

		--write data	
		if (inc_pc = '1' ) then 
			pc_int := to_integer(signed(reg_var(15)));				--convert to unsigned
			pc_int := pc_int + 4;									--add 4
			pc_33_bits := std_logic_vector(to_signed(pc_int, 33));	--convert to std_vector
			reg_var(15) <= pc_33_bits(31 downto 0); 				--new pc
			pcv <= '1';
		end if;	

	---------------------------------------------- czn ------------------------------------
		if (cznv = '1') then
			if (inval_czn ='1') then
				cznv <= '0';
			end if;
		else
			if (inval_czn ='0') then
				if (cspr_wb = '1') then	--cspar_wb enable les flags si =1
					cznv <= '1';
				end if;
			end if;
		end if;

		--write data czn
		if (cznv = '0') then
			if (cspr_wb = '1') then
					c <= wcry;
					z <= wzero;
					n <= wneg;
			end if;
		end if;
---------------------------------------------- ovr ------------------------------------
		if (vv = '1') then
			if (inval_ovr ='1') then
				vv <= '0';
			end if;
		else
			if (inval_ovr ='0') then
				if (cspr_wb = '1') then
					vv <= '1';
				end if;
			end if;
		end if;
	
		--write data v
		if (vv = '0') then
			if (cspr_wb = '1') then
					v <= wovr;	
			end if;
		end if;
	------------------------------------------------- regs ----------------------------------------
		-- si c'est la meme addrese on prend la 1er qui correspond a exec sinon on prend les deux
		-- si inval=1 on invalide 
			
		if (wadr1=wadr2) then 
			if(inval1 = '1') then
				valid_reg(to_integer(unsigned(inval_adr1))) <= '0';
			end if;

			--write data
			if((wen1 = '1') and (valid_reg(to_integer(unsigned(wadr1))) = '1'))then
				reg_var(to_integer(unsigned(wadr1))) <= wdata1;
				valid_reg(to_integer(unsigned(inval_adr1))) <= '1';
			end if;
			
		else 
			if(inval1 = '1') then
				valid_reg(to_integer(unsigned(inval_adr1))) <= '0';
			end if;

			if(inval2 = '1') then
				valid_reg(to_integer(unsigned(inval_adr2))) <= '0';
			end if;

			--write data
			if((wen1 = '1') and (valid_reg(to_integer(unsigned(wadr1)))='1'))then
				reg_var(to_integer(unsigned(wadr1))) <= wdata1;
				valid_reg(to_integer(unsigned(inval_adr1))) <= '1';
			end if;

			if((wen2 = '1') and (valid_reg(to_integer(unsigned(wadr2)))='1')) then
				reg_var(to_integer(unsigned(wadr2))) <= wdata2;
				valid_reg(to_integer(unsigned(inval_adr2))) <= '1';
			end if;
		end if;	
	end if;
end if;
end process;


reg_rd1 <= reg_var(to_integer(unsigned(radr1)));
reg_rd2 <= reg_var(to_integer(unsigned(radr2)));
reg_rd3 <= reg_var(to_integer(unsigned(radr3)));
reg_pc  <= reg_var(15);

reg_v1	<= valid_reg(to_integer(unsigned(radr1)));
reg_v2	<= valid_reg(to_integer(unsigned(radr2)));
reg_v3	<= valid_reg(to_integer(unsigned(radr3)));
reg_pcv <= pcv;

reg_cry	<= 	c;
reg_zero<= 	z;
reg_neg	<=  n;
reg_cznv<= 	cznv;
reg_ovr	<= v;
reg_vv	<= vv;
 

end Behavior;


