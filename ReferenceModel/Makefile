bin : GoldenModel.cc Driver.cc Reporter.cc ../includes.h utils.h
	g++  -I$(SYSTEMC_HOME)/include  -L$(SYSTEMC_LIBDIR) -lsystemc -lm -o  bin GoldenModel.cc

run : bin
	./bin

run_tofile : bin
	./bin > signals.log

bin_test : test.cc
	g++  -I$(SYSTEMC_HOME)/include  -L$(SYSTEMC_LIBDIR) -lsystemc -lm -o  bin_test test.cc

run_test : bin_test
	./bin_test

 
clean :
	rm *bin*
	rm *.vcd
	