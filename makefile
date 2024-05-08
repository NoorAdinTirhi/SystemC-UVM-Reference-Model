
verilate1 : alu.sv
	verilator --cc alu.sv

verilate2 : obj_dir/Valu.h obj_dir/Valu___024unit.h env.cpp alu.sv
	verilator -Wall --trace --cc alu.sv --exe env.cpp

compile : obj_dir/Valu.mk
	make -C obj_dir -f Valu.mk

clean : 
	rm -rf obj_dir
	rm trace.vcd waveform.vcd
	make -C ReferenceModel clean

run : obj_dir/Valu ReferenceModel/bin
	./obj_dir/Valu

ReferenceModel/bin :
	make -C ReferenceModel bin

all : verilate1 verilate2 compile run
