SIM_NAME ?= tb_top
# COMPILE_ARGS += -DUVM_NO_DPI
# COMPILE_ARGS += --prefix $(SIM_NAME) -o $(SIM_NAME)
# COMPILE_ARGS += $(addprefix +incdir+, $(VERILOG_INCLUDE_DIRS))
UVM_TEST ?= comp_decomp_test

EXTRA_ARGS += --timescale 1ns/1ps --error-limit 100
WARNING_ARGS += -Wno-lint \
	-Wno-style \
	-Wno-SYMRSVDWORD \
	 \
	-Wno-ZERODLY \
	-Wno-IGNOREDRETURN \
	-Wno-CONSTRAINTIGN \
	-Wno-WIDTH \
	-Wno-PINMISSING\
	-Wno-SELRANGE 

COMPILE_ARGS += -DUVM_NO_DPI
# COMPILE_ARGS += --prefix $(SIM_NAME) -o $(SIM_NAME)
# COMPILE_ARGS += $(addprefix +incdir+, $(VERILOG_INCLUDE_DIRS))

verilate1 : src/tb_top.sv
	verilator --cc --timing -I${UVM_HOME}/src -Isrc ${WARNING_ARGS} ${COMPILE_ARGS} --top tb_top src/tb_top.sv


verilate2 : obj_dir/Vtb_top.h  src/env.cpp src/tb_top.sv
	verilator ${WARNING_ARGS} ${COMPILE_ARGS} -I${UVM_HOME}/src -Isrc --trace --timing --cc --top tb_top src/tb_top.sv --exe src/env.cpp

compile : obj_dir/Vtb_top.mk
	make -j16 -C obj_dir -f Vtb_top.mk

clean : 
	rm -rf obj_dir
	rm trace.vcd waveform.vcd
	make -C src/ReferenceModel clean

run : obj_dir/Vtb_top src/ReferenceModel/bin
	obj_dir/Vtb_top

src/ReferenceModel/bin :
	make -C src/ReferenceModel bin

all : verilate1 verilate2 compile
