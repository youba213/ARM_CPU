all: exe_tb

exe_tb: exe.vhdl exe_tb.vhdl
	ghdl -a -v Shifter.vhdl
	ghdl -a -v ALU.vhdl
	ghdl -a -v fifo_72b.vhdl
	ghdl -a -v exe.vhdl
	ghdl -a -v exe_tb.vhdl
	ghdl -e -v exe_tb
	ghdl -r exe_tb --vcd=exe.vcd

clean:
	rm -f exe_tb
	rm -f exe.vcd
	rm -f work-obj93.cf

.PHONY: all clean
