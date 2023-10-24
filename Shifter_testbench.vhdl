library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Shifter_testbench is
end Shifter_testbench;

architecture TB_ARCH of Shifter_testbench is
    signal shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, cin, cout: STD_LOGIC;
    signal din, dout: STD_LOGIC_VECTOR(31 downto 0);
    signal shift_val : STD_LOGIC_VECTOR(4 downto 0);
    signal vdd, vss: BIT;

begin
    my_shifter: entity work.Shifter
    port map (
        shift_lsl => shift_lsl,
        shift_lsr => shift_lsr, 
        shift_asr => shift_asr,
        shift_ror => shift_ror,
        shift_rrx => shift_rrx,
        shift_val => shift_val,
        din => din,
        cin => cin,
        dout => dout,
        cout => cout,
        vdd => vdd,
        vss => vss
    );
process is
begin
    -- Initialize inputs
    shift_lsl <= '1';
    shift_lsr <= '0';
    shift_asr <= '0';
    shift_ror <= '0';
    shift_rrx <= '0';
    shift_val <= "00011";  -- No shift
    din <= "01010101010101010101010101010101"; -- Example input data
    cin <= '0';
    vdd <= '1';
    vss <= '0';

    -- Test LSL
    -- wait for 10 ns;
    --shift_lsl <= '1';
    --hift_val <= "00001";  -- Shift by 2 bits

    -- Test LSR
    wait for 10 ns;
    shift_lsl <= '0';
    shift_lsr <= '1';
    shift_val <= "00011";  -- Shift by 2 bits

    -- Test ASR
    wait for 10 ns;
    shift_lsr <= '0';
    shift_asr <= '1';
    shift_val <= "00011";  -- Shift by 2 bits
    vdd <= '1';
    vss <= '0';
    wait for 10 ns;
    shift_asr <= '0';
    shift_ror <= '1';
    shift_val <= "00011";  -- Shift by 2 bits

    wait for 10 ns;
    shift_ror <= '0';
    shift_rrx <= '1';
    shift_val <= "00011";  -- Shift by 2 bits

    wait for 10 ns;
    shift_rrx <= '0';
    shift_val <= "00000";  -- Shift by 2 bits
    wait;
end process;

end TB_ARCH;
