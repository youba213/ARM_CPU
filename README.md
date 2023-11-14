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
