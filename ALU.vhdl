Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Alu is
	port ( 	op1 : in Std_Logic_Vector(31 downto 0);
		op2 : in Std_Logic_Vector(31 downto 0);
		cin : in Std_Logic;
		cmd : in Std_Logic_Vector(1 downto 0);
		res : out Std_Logic_Vector(31 downto 0);
		cout : out Std_Logic;
		z : out Std_Logic;
		n : out Std_Logic;
		v : out Std_Logic;
		vdd : in bit;
		vss : in bit);
end Alu;

architecture Archi of ALU is 
signal result: Std_Logic_Vector(31 downto 0);
begin 

	process (cmd,op1,op2)
	begin
	case cmd is

		when "00" => 	
			if cin = '1' then
				result <= Std_Logic_Vector(unsigned(op1) + unsigned(op2) + 1);
			else result <= Std_Logic_Vector(unsigned(op1) + unsigned(op2) + 0);
			end if;
		when "01" => result <= op1 and op2;
		when "10" => result <= op1 or op2;
		when others => result <= op1 xor op2;
	end case;

	-- if result(32) = '1' then
	-- 	v <= '1' ;
	-- else
	-- 	v <= '0' ;
	-- end if ;

	if result = X"00000000" then
		z <= '1';
	else
		z <= '0';
	end if;
	if result(31) = '1' then 
		n <= '1' ;
	else
		n <= '0' ;
	end if;

end process; 
res <= result;

end Archi;

-- cmd = '00'  	addition
-- cmd = '01'	and
-- cmd = '10'	or
-- cmd = '11'	xor

