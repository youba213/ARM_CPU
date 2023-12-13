LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.math_real.ALL;

entity Reg_tb is
end Reg_tb;

architecture archi OF Reg_tb is
signal wdata1, wdata2, reg_rd1, reg_rd2, reg_rd3, reg_pc:Std_Logic_Vector(31 downto 0);
signal wadr1, wadr2, radr1, radr2, radr3, inval_adr1, inval_adr2:Std_Logic_Vector(3 downto 0);
signal wen1, wen2, wcry, wzero, wneg, wovr, cspr_wb, reg_v1, reg_v2, reg_v3, reg_cry, reg_zero, reg_neg,
       reg_cznv, reg_ovr, reg_vv, inval1, inval2, inval_czn, inval_ovr, reg_pcv, inc_pc, ck, reset_n :Std_Logic;
signal vdd, vss: bit;
begin
    my_reg : ENTITY work.reg
    PORT MAP(
		wdata1		 =>     wdata1,
		wadr1		 =>	    wadr1,
		wen1		 =>	    wen1,
		wdata2		 =>     wdata2,
		wadr2		 =>	    wadr2,
		wen2		 =>	    wen2,
		wcry		 =>	    wcry,
        wzero		 =>	    wzero,
		wneg		 =>	    wneg,
		wovr		 =>	    wovr,
		cspr_wb		 =>     cspr_wb,
		reg_rd1		 =>     reg_rd1,
		radr1		 =>	    radr1,
		reg_v1		 =>     reg_v1,
		reg_rd2		 =>     reg_rd2,
		radr2		 =>	    radr2,
		reg_v2		 =>     reg_v2,
		reg_rd3		 =>     reg_rd3,
		radr3		 =>	    radr3,
		reg_v3		 =>     reg_v3,
		reg_cry		 =>     reg_cry,
		reg_zero	 =>	    reg_zero,
		reg_neg		 =>     reg_neg,
		reg_cznv	 =>	    reg_cznv,
		reg_ovr		 =>     reg_ovr,
		reg_vv		 =>     reg_vv,
		inval_adr1	 =>     inval_adr1,
		inval1		 =>     inval1,
		inval_adr2	 =>     inval_adr2,
		inval2		 =>     inval2,
		inval_czn	 =>     inval_czn,
		inval_ovr	 =>     inval_ovr,
		reg_pc		 =>     reg_pc,
		reg_pcv		 =>     reg_pcv,
		inc_pc		 =>     inc_pc,
		ck			 =>	    ck,
		reset_n		 =>     reset_n,
		vdd			 =>     vdd,
		vss			 =>     vss
    );

ck_process: process
    VARIABLE count : INTEGER := 0;
BEGIN
        ck <= '0';
        WAIT FOR 5 ns;
        ck <= '1';
        WAIT FOR 5 ns;
        count := count + 1;
        IF count >= 20 THEN
            WAIT;
        END IF;
end process;
------------------------------------------- allways --------------------------

    wen1        <= '1';  -- write enable 
    wen2	    <= '1';

-- Write CSPR Port
    wcry	    <= '1';
    wzero	    <= '0';
    wneg	    <= '1';
    wovr	    <= '0';
    cspr_wb		<= '1';
    
-- Invalidate Port 
    inval_adr1	<= X"1";
    inval1		<= '1';

    inval_adr2	<= X"2";
    inval2		<= '1';

    inval_czn	<= '1';
    inval_ovr	<= '1';

-- PC
    inc_pc		<= '1';

-- global interface
    vdd         <= '1';
    vss         <= '0';
    reset_n		<= '0' , '1' after 10 ns;
------------------------------------------------------------------


test_process: process(ck)
	
variable seed1,seed2: integer := 999; -- Exemple de valeur initiale
impure function rand_slv(len : integer) return std_logic_vector is
    variable r : real;
    variable slv : std_logic_vector(len - 1 downto 0);
  begin
    for i in slv'range loop
        uniform(seed1, seed2, r);
        if r > 0.5 then
        slv(i) := '1';
        else
        slv(i) := '0';
        end if;
    end loop;
    return slv;
  end function;
begin
IF rising_edge(ck) THEN

    wdata1 <= rand_slv(32);
    wdata2 <= rand_slv(32);
    wadr1  <= rand_slv(4);
    wadr2  <= rand_slv(4);
    radr1  <= wadr1;
    radr2  <= wadr2;
    radr3  <= rand_slv(4);
    
end if;

end process test_process;




end archi;


