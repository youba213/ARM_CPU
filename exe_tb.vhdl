library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exe_tb is
end exe_tb;

architecture archi of exe_tb is
signal dec_op1,dec_op2,exe_res: std_logic_vector(31 downto 0);
signal dec2exe_empty,dec_pre_index,dec_shift_lsl,dec_shift_lsr,dec_shift_asr,dec_shift_ror,dec_shift_rrx,dec_cy,
       dec_comp_op1,dec_comp_op2,dec_alu_cy: std_logic;
signal dec_shift_val: std_logic_vector(4 downto 0);
signal dec_alu_cmd: std_logic_vector(1 downto 0);

signal exe_mem_adr,exe_mem_data,dec_mem_data: std_logic_vector(31 downto 0);
signal exe_mem_dest,exe_dest,dec_mem_dest,dec_exe_dest: std_logic_vector(3 downto 0);
signal dec_exe_wb,dec_flag_wb,dec_mem_lw,dec_mem_lb,dec_mem_sw,dec_mem_sb,mem_pop,exe_flag_wb,exe2mem_empty,
       exe_c,exe_v,exe_n,exe_mem_lw,exe_mem_lb,exe_mem_sw,exe_mem_sb,exe_z,exe_wb,ck,reset_n,exe_pop:std_logic;
signal vdd, vss: BIT;
begin
    my_exe: entity work.exe
    port map (
    dec2exe_empty   => dec2exe_empty,
    exe_pop         => exe_pop,
    dec_op1         => dec_op1,
    dec_op2         => dec_op2,
    dec_exe_dest    => dec_exe_dest,
    dec_exe_wb      => dec_exe_wb,
    dec_flag_wb     => dec_flag_wb,
    dec_mem_data    => dec_mem_data,
    dec_mem_dest    => dec_mem_dest,
    dec_pre_index   => dec_pre_index,
    dec_mem_lw      => dec_mem_lw,
    dec_mem_lb      => dec_mem_lb,
    dec_mem_sw      => dec_mem_sw,
    dec_mem_sb      => dec_mem_sb,
    dec_shift_lsl   => dec_shift_lsl,
    dec_shift_lsr   => dec_shift_lsr,
    dec_shift_asr   => dec_shift_asr,
    dec_shift_ror   => dec_shift_ror,
    dec_shift_rrx   => dec_shift_rrx,
    dec_shift_val   => dec_shift_val,
    dec_cy          => dec_cy,
    dec_comp_op1    => dec_comp_op1,
    dec_comp_op2    => dec_comp_op2,
    dec_alu_cy      => dec_alu_cy,
    dec_alu_cmd     => dec_alu_cmd,
    exe_res         => exe_res,
    exe_c           => exe_c,
    exe_v           => exe_v,
    exe_n           => exe_n,
    exe_z           => exe_z,
    exe_dest        => exe_dest,
    exe_wb          => exe_wb,
    exe_flag_wb     => exe_flag_wb,
    exe_mem_adr     => exe_mem_adr,
    exe_mem_data    => exe_mem_data,
    exe_mem_dest    => exe_mem_dest,
    exe_mem_lw      => exe_mem_lw,
    exe_mem_lb      => exe_mem_lb,
    exe_mem_sw      => exe_mem_sw,
    exe_mem_sb      => exe_mem_sb,
    exe2mem_empty   => exe2mem_empty,
    mem_pop         => mem_pop,
    ck              => ck, 
    reset_n         => reset_n,
    vdd             => vdd,
    vss             => vss
    );

    
process is
    begin
    -- Initialize inputs
    dec2exe_empty   <=  '0';
    dec_op1         <= x"00000001";
    dec_op2         <= x"00000001";
    dec_exe_dest    <=  x"0";
    dec_exe_wb      <=  '0';
    dec_flag_wb	    <=  '0';
    dec_mem_data    <=  x"00000001";
    dec_mem_dest    <= x"2";
    dec_pre_index   <=  '1';
    dec_mem_lw      <=  '1';
    dec_mem_lb      <=  '0';
    dec_mem_sw      <=  '0';
    dec_mem_sb      <=  '0';
    dec_shift_lsl   <=  '1';
    dec_shift_lsr   <=  '0';
    dec_shift_asr   <=  '0';
    dec_shift_ror   <=  '0';
    dec_shift_rrx   <=  '0';
    dec_shift_val   <=  "00000";
    dec_cy          <=  '0';
    dec_comp_op1    <=  '0';
    dec_comp_op2    <=  '0';
    dec_alu_cy      <=  '0';
    dec_alu_cmd     <=  "00";
    ck              <=  '0';
    reset_n         <= '1';
    vdd             <= '1';
    vss             <= '0';


    wait for 10 ns;
    dec_alu_cmd     <=  "00";
    dec_shift_lsl   <=  '0';
    dec_shift_lsr   <=  '1';
    dec_shift_val   <=  "00000";
    ck              <= not ck ;

    wait for 10 ns;
    dec_shift_lsl   <=  '1';
    dec_shift_lsr   <=  '0';
    dec_shift_val   <=  "00000";
    ck              <= not ck;

    wait for 10 ns;
    dec_alu_cmd     <=  "00";
    dec_shift_lsl   <=  '0';
    dec_shift_lsr   <=  '1';
    dec_shift_val   <=  "00000";
    ck              <= not ck ;
    wait;
end process;
end archi;