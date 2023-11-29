library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity decod_tb is
end entity ;

architecture archi of decod_tb is
    signal dec_op1			:  Std_Logic_Vector(31 downto 0); -- first alu input
    signal dec_op2			:  Std_Logic_Vector(31 downto 0); -- shifter input
    signal dec_exe_dest		:  Std_Logic_Vector(3 downto 0); -- Rd destination
    signal dec_exe_wb		:  Std_Logic; -- Rd destination write back
    signal dec_flag_wb		:  Std_Logic; -- CSPR modifiy
    
        -- Decod to mem via exec
    signal dec_mem_data		:  Std_Logic_Vector(31 downto 0); -- data to MEM
    signal dec_mem_dest		:  Std_Logic_Vector(3 downto 0); -- @ of MEM
    signal dec_pre_index 	:  Std_logic; -- say if we do pre index or no []!
    
    signal dec_mem_lw		:  Std_Logic; -- type of memory access
    signal dec_mem_lb		:  Std_Logic;
    signal dec_mem_sw		:  Std_Logic;
    signal dec_mem_sb		:  Std_Logic;
    
        -- Shifter command
    signal dec_shift_lsl	:  Std_Logic; --meme signaux que dans exe
    signal dec_shift_lsr	:  Std_Logic;
    signal dec_shift_asr	:  Std_Logic;
    signal dec_shift_ror	:  Std_Logic;
    signal dec_shift_rrx	:  Std_Logic;
    signal dec_shift_val	:  Std_Logic_Vector(4 downto 0);
    signal dec_cy			:  Std_Logic;
    
        -- Alu operand selection
    signal dec_comp_op1	 	:  Std_Logic;
    signal dec_comp_op2		:  Std_Logic;
    signal dec_alu_cy 		:  Std_Logic;
    
        -- Exec Synchro
    signal dec2exe_full	:  Std_Logic; --fifo en entree dec/exe
    signal exe_pop			:  Std_logic;
    signal dec2exe_push 	:  std_logic ;
    
        -- Alu command
    signal dec_alu_add		:  Std_Logic;
    signal dec_alu_and		:  Std_Logic;
    signal dec_alu_or		:  Std_Logic;
    signal dec_alu_xor		:  Std_Logic;
    
        -- Exe Write Back to reg
    signal exe_res			:   Std_Logic_Vector(31 downto 0);
    
    signal exe_c			:   Std_Logic;
    signal exe_v			:   Std_Logic;
    signal exe_n			:   Std_Logic;
    signal exe_z			:   Std_Logic;
    
    signal exe_dest			:   Std_Logic_Vector(3 downto 0); -- Rd destination
    signal exe_wb           :   Std_Logic; -- Rd destination write back
    signal exe_flag_wb		:   Std_Logic; -- CSPR modifiy
    
        -- Ifetch  terface
    signal dec_pc 			:  	Std_Logic_Vector(31 downto 0) ; -- pc
    signal if_ir 			:   Std_Logic_Vector(31 downto 0) ; -- 32 bits to decode
    signal if_flush			: 	Std_Logic ;
    
        -- Ifetch synchro : fifo dec2if et if2dec
    signal dec2if_empty		:  	Std_Logic; -- si la fifo qui recup pc est vide
    signal if_pop 			:   Std_Logic; -- pop de la fifo dec2if
    
    signal if2dec_empty		:   Std_Logic; -- si la fifo qui envoie l'inst est vide
    signal dec_pop 			:  	Std_Logic; -- 
    
        -- Mem Write back to reg
    signal mem_res 			:   Std_Logic_Vector(31 downto 0);
    signal mem_dest			:   Std_Logic_Vector(3 downto 0);
    signal mem_wb 			:   Std_Logic; 
        -- global  terface
    signal ck		 		:   Std_Logic;
    signal reset_n 			:   Std_Logic;
    signal vdd 				:   bit;
    signal vss 				:   bit;

begin

my_decod: entity work.Decod 
PORT MAP(	
-- Exec  operands
dec_op1         => dec_op1,
dec_op2         => dec_op2,
dec_exe_dest    => dec_exe_dest,
dec_exe_wb      => dec_exe_wb,
dec_flag_wb     => dec_flag_wb,

-- Decod to mem via exec
dec_mem_data    => dec_mem_data,
dec_mem_dest    => dec_mem_dest,
dec_pre_index   => dec_pre_index,

dec_mem_lw      => dec_mem_lw,
dec_mem_lb      => dec_mem_lb,
dec_mem_sw      => dec_mem_sw,
dec_mem_sb      => dec_mem_sb,

-- Shifter command
dec_shift_lsl   => dec_shift_lsl,
dec_shift_lsr   => dec_shift_lsr,
dec_shift_asr   => dec_shift_asr,
dec_shift_ror   => dec_shift_ror,
dec_shift_rrx   => dec_shift_rrx,
dec_shift_val   => dec_shift_val,
dec_cy          => dec_cy,

-- Alu operand selection
dec_comp_op1    => dec_comp_op1,
dec_comp_op2    => dec_comp_op2,
dec_alu_cy      => dec_alu_cy,


-- Exe Write Back to reg
exe_res         => exe_res,
exe_pop         => exe_pop,
exe_c           => exe_c,
exe_v           => exe_v,
exe_n           => exe_n,
exe_z           => exe_z,

exe_dest        => exe_dest,
exe_wb          => exe_wb,
exe_flag_wb     => exe_flag_wb,

-- Ifetch interface
dec_pc          => dec_pc,
if_ir           => if_ir,

-- Ifetch synchro : fifo dec2if et if2dec
dec2if_empty    => dec2if_empty,
if_pop          => if_pop,

if2dec_empty    => if2dec_empty,
dec_pop         => dec_pop,

-- Mem Write back to reg
mem_res         => mem_res,
mem_dest        => mem_dest,
mem_wb          => mem_wb,

-- global interface
ck              => ck,
reset_n         => reset_n,
vdd             => vdd,
vss             => vss
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

--always
reset_n		<= '0' , '1' after 10 ns;
vdd <= '1';
vss <= '0';

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
    
    exe_pop <= '1';   -- vers fifo_72b
    exe_c <= '0';     -- vers reg
    exe_z <= '0';     -- vers reg
    exe_n <= '0';     -- vers reg
    exe_v <= '0';     -- vers reg  
    exe_flag_wb <= '0'; -- vers reg

    if_ir <= X"e1a04001";

    if2dec_empty <= '1';  -- depuis ifc
    if_pop <= '1';        --depuis ifc 

    exe_res <= rand_slv(32);    --vers reg wdata1
    exe_dest  <= rand_slv(4);   -- vers reg wadr1 
    exe_wb <= '1';              -- vers reg wen1
    exe_pop <= '0';

    mem_res <= rand_slv(32);    --vers reg wdata2  
    mem_dest  <= rand_slv(4);   --vers reg wadr2
    mem_wb  <= '1';             --vers reg wen2
    



end process test_process;


end archi;