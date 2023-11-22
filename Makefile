all: exe

exe: exe.vhdl exe_tb.vhdl
	ghdl -a -v Shifter.vhdl
	ghdl -a -v ALU.vhdl
	ghdl -a -v fifo_72b.vhdl
	ghdl -a -v exe.vhdl
	ghdl -a -v exe_tb.vhdl
	ghdl -e -v exe_tb
	ghdl -r exe_tb --vcd=exe.vcd

reg: reg.vhdl reg_tb.vhdl
	ghdl -a -v reg.vhdl
	ghdl -a -v reg_tb.vhdl
	ghdl -e -v reg_tb
	ghdl -r reg_tb --vcd=reg.vcd

clean:
	rm -f exe_tb
	rm -f exe.vcd
	rm -f reg_tb
	rm -f reg.vcd
	rm -f work-obj93.cf

.PHONY: all clean
