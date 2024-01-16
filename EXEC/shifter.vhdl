library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter is
    port(
    shift_lsl : in Std_Logic;
    shift_lsr : in Std_Logic;
    shift_asr : in Std_Logic;
    shift_ror : in Std_Logic;
    shift_rrx : in Std_Logic;
    shift_val : in Std_Logic_Vector(4 downto 0);
    din : in Std_Logic_Vector(31 downto 0);
    cin : in Std_Logic;
    dout : out Std_Logic_Vector(31 downto 0);
    cout : out Std_Logic;
    -- global interface
    vdd : in bit;
    vss : in bit);
end Shifter;

architecture archi of Shifter is
signal temp_shift_val: integer;
signal zeros : Std_Logic_Vector(31 downto 0) := (others => '0');

begin
    temp_shift_val <= to_integer (unsigned(shift_val));
    process(din,temp_shift_val,shift_lsl,shift_lsr,shift_asr,shift_ror,shift_rrx)
    variable temp: Std_Logic_Vector(31 downto 0);
    begin

        
        if temp_shift_val = 0 then
            temp:=din;
        else
            if shift_lsl = '1' then
                temp := din((31-temp_shift_val) downto 0) & zeros(temp_shift_val-1 downto 0);
            elsif shift_lsr = '1' then
                temp := zeros(temp_shift_val-1 downto 0) & din(31 downto temp_shift_val);
            elsif shift_asr = '1' then 
                if din(31) = '1' then
                temp := not zeros(temp_shift_val-1 downto 0) & din(31 downto temp_shift_val);
                else
                temp := zeros(temp_shift_val-1 downto 0) & din(31 downto temp_shift_val);
                end if;
            elsif shift_ror = '1' then
                temp := din(temp_shift_val-1 downto 0) & din(31  downto temp_shift_val);
            elsif shift_rrx = '1' then
                if temp_shift_val = 0 then
                    temp := cin & din(31  downto temp_shift_val);
                else 
                    temp := din(temp_shift_val-2 downto 0) & cin & din(31  downto temp_shift_val);
                end if ;
                
            end if;
        end if;
            
    dout <= temp;
    cout <= temp(0);
    end process;
end;