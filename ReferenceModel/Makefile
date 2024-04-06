bin : GoldenModel.cc Driver.cc Reporter.cc includes.h constants.h
	g++  -I$(SYSTEMC_HOME)/include  -L$(SYSTEMC_LIBDIR) -lsystemc -lm -o  bin GoldenModel.cc

trace.vcd : bin
	./bin

run : trace.vcd
	gtkwave trace.vcd
 
clean :
	rm bin