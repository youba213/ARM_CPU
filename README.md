# ARM_CPU
##private:
token: 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

##public:
ghdl -a -v exe.vhdl
ghdl -a -v exe_tb.vhdl
ghdl -e -v exe_tb
ghdl -r exe_tb --vcd=exe.vcd
gtkwav  exe.vcd

#Required package on linux:
ghdl
make
gtkwave

## problemes rencontres 
alignement d'un end if a coute tres cher 

https://community.arm.com/arm-community-blogs/b/architectures-and-processors-blog/posts/condition-codes-1-condition-flags-and-codes

FETCH:
T1: rester sur fetch tant que not(dec2if_empty) and if2dec_empty ;
T2: passer a run si not(if2dec_empty)

RUN: 
T1: rester sur run tant que 
    if2dec_empty or
    dec2exe_full or
    not(condv) 
T2: 
    not(cond)