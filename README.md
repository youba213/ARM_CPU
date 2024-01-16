# ARM_CPU
./main_tb Test/test_add --vcd=test.vcd
arm-linux-gnu-objdump -d Test/test_add  Mon ficher test en arm avec les adresses
 
```
mkdir /dsk/l1/misc/ferhoune/Arm
./main_tb Test/test_add --vcd=/dsk/l1/misc/ferhoune/Arm/test_add.vcd
gtkwave /dsk/l1/misc/ferhoune/Arm/test_add.vcd
```

## public:

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

./main_tb Test/test_add
