Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity alu_tb is

end;


architecture archi of alu_tb is 

signal op1,op2,res : Std_Logic_Vector(31 downto 0);
signal cmd: Std_Logic_Vector(1 downto 0):= "00";
signal cin: std_logic := '0'; 
signal vdd,vss: bit;
begin
 
my_ALU: entity work.ALU
port map (
    op1 => op1,
    op2 => op2,
    cin => cin,
    vdd => vdd,
    vss => vss, 
    res => res,
    cmd => cmd);

-- process is

-- 	begin
-- 	op1 <= "0110";
-- 	op2 <= "0101";
-- 	WAIT for 1 ns;
-- 	assert(s = "1011")
-- 	report "resultat incorret" 
-- 	severity ERROR;
-- 	a <= "0000";
-- 	wait for 1 ns;
-- wait;
-- end process;

cmd <= "01" after 100 ns, "10" after 200 ns, "11" after 300 ns, "00" after 400 ns;
op1 <= "00110011001100110000000000011111";
op2 <= "00110011001100001111000000011111";

end archi;


