LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY exe_tb IS
END exe_tb;

ARCHITECTURE archi OF exe_tb IS
    SIGNAL dec_op1, dec_op2, exe_res, exe_mem_adr, exe_mem_data, dec_mem_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dec2exe_empty, dec_pre_index, dec_shift_lsl, dec_shift_lsr, dec_shift_asr, dec_shift_ror, dec_shift_rrx, dec_cy,
    dec_comp_op1, dec_comp_op2, dec_alu_cy, dec_exe_wb, dec_flag_wb, dec_mem_lw, dec_mem_lb, dec_mem_sw, dec_mem_sb, mem_pop,
    exe_flag_wb, exe2mem_empty, exe_c, exe_v, exe_n, exe_mem_lw, exe_mem_lb, exe_mem_sw, exe_mem_sb, exe_z, exe_wb, ck, reset_n, exe_pop : STD_LOGIC;
    SIGNAL dec_shift_val : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL exe_mem_dest, exe_dest, dec_mem_dest, dec_exe_dest : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL dec_alu_cmd : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL vdd, vss : BIT;
BEGIN
    my_exe : ENTITY work.exe
        PORT MAP(
            dec2exe_empty => dec2exe_empty,
            exe_pop => exe_pop,
            dec_op1 => dec_op1,
            dec_op2 => dec_op2,
            dec_exe_dest => dec_exe_dest,
            dec_exe_wb => dec_exe_wb,
            dec_flag_wb => dec_flag_wb,
            dec_mem_data => dec_mem_data,
            dec_mem_dest => dec_mem_dest,
            dec_pre_index => dec_pre_index,
            dec_mem_lw => dec_mem_lw,
            dec_mem_lb => dec_mem_lb,
            dec_mem_sw => dec_mem_sw,
            dec_mem_sb => dec_mem_sb,
            dec_shift_lsl => dec_shift_lsl,
            dec_shift_lsr => dec_shift_lsr,
            dec_shift_asr => dec_shift_asr,
            dec_shift_ror => dec_shift_ror,
            dec_shift_rrx => dec_shift_rrx,
            dec_shift_val => dec_shift_val,
            dec_cy => dec_cy,
            dec_comp_op1 => dec_comp_op1,
            dec_comp_op2 => dec_comp_op2,
            dec_alu_cy => dec_alu_cy,
            dec_alu_cmd => dec_alu_cmd,
            exe_res => exe_res,
            exe_c => exe_c,
            exe_v => exe_v,
            exe_n => exe_n,
            exe_z => exe_z,
            exe_dest => exe_dest,
            exe_wb => exe_wb,
            exe_flag_wb => exe_flag_wb,
            exe_mem_adr => exe_mem_adr,
            exe_mem_data => exe_mem_data,
            exe_mem_dest => exe_mem_dest,
            exe_mem_lw => exe_mem_lw,
            exe_mem_lb => exe_mem_lb,
            exe_mem_sw => exe_mem_sw,
            exe_mem_sb => exe_mem_sb,
            exe2mem_empty => exe2mem_empty,
            mem_pop => mem_pop,
            ck => ck,
            reset_n => reset_n,
            vdd => vdd,
            vss => vss
        );

    ck_process : PROCESS
    VARIABLE count : INTEGER := 0;
    BEGIN
        ck <= '0';
        WAIT FOR 5 ns;
        ck <= '1';
        WAIT FOR 5 ns;
    count := count + 1;
    if count >= 20 then
        wait;
    end if;
    END PROCESS ck_process;

    --always:
    dec2exe_empty <= '0'; --fifo flag 
    dec_exe_dest <= x"0"; --rd DISTENATION REGESTER
    dec_exe_wb <= '0';
    dec_flag_wb <= '0';

    dec_mem_data <= x"00000000";
    dec_mem_dest <= x"0";
    dec_mem_lw <= '0';
    dec_mem_lb <= '0';
    dec_mem_sw <= '0';
    dec_mem_sb <= '0';
    mem_pop <= '1';
    reset_n <= '1';
    vdd <= '1';
    vss <= '0';
    
    procedure UNIFORM(variable SEED1, SEED2 : inout POSITIVE;
                      variable X : out REAL);
    test_process : PROCESS (ck)
    BEGIN
        IF rising_edge(ck) THEN

            dec_op1 <= x"00000002";
            dec_op2 <= x"00000002";

            dec_pre_index <= '1';

            dec_shift_lsl <= '1';
            dec_shift_lsr <= '0';
            dec_shift_asr <= '0';
            dec_shift_ror <= '0';
            dec_shift_rrx <= '0';
            dec_shift_val <= "00000";
            dec_cy <= '0';
            dec_comp_op1 <= '0';
            dec_comp_op2 <= '0';
            dec_alu_cy <= '0';
            dec_alu_cmd <= "00";
            report "__________________________________________________";
        END IF;
    END PROCESS test_process;

    
END archi;