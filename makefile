
verilate1 : alu.sv
	verilator --cc alu.sv

verilate2 : obj_dir/Valu.h obj_dir/Valu___024unit.h env.cpp alu.sv
	verilator -Wall --trace --cc alu.sv --exe env.cpp

compile : obj_dir/Valu.mk
	make -C obj_dir -f Valu.mk

clean : 
	rm -rf obj_dir

run : obj_dir/Valu
	./obj_dir/Valu

all : verilate1 verilate2 compile run
