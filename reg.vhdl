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
signal c,z,n,ovr,ovr_valid,czn_valid: std_logic;
signal bits_valid: std_logic_vector(15 downto 0);

write_regs: process (ck,reset_n)
	variable reg_var: reg_array;

if raising_edge(ck) then
	if (reset_n = '0') then
		for i in 0 to 15 loop:
			reg_var(i)= X"00000000";
		end loop;
		c <= '0';
		z <= '0';
		n <= '0';
		ovr <= '0';
		czn_valid <= '1';
		ovr_valid <= '1';
		bits_valid <= X"FFFF";
	else
		if (wadr1=wadr2) then 
			reg_var(unsigned(wadr1)) = wdata1;
			valid_var(unsigned(wadr1)) = '1';
		else 
			reg_var(unsigned(wadr1)) = wdata1;
			valid_var(unsigned(wadr1)) = '1';
			reg_var(unsigned(wadr2)) = wdata2;
			valid_var(unsigned(wadr2)) = '1';
		end if;
		if(inval1)
		valid_var (unsigned(inval_adr1)) = '0';
		valid_var (unsigned(inval_adr2)) = '0';

	end

end process



end Behavior;


