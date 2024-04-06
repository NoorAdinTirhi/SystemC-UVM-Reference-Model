bin : GoldenModel.cc Driver.cc Reporter.cc includes.h constants.h
	clang++  -I$(SYSTEMC_HOME)/include  -L$(SYSTEMC_LIBDIR) -lsystemc -lm -o  bin GoldenModel.cc

run : bin
	./bin

bin_test : test.cc
	clang++  -I$(SYSTEMC_HOME)/include  -L$(SYSTEMC_LIBDIR) -lsystemc -lm -o  bin_test test.cc

run_test : bin_test
	./bin_test

 
clean :
	rm bin
	rm trace.vcd
	rm bin_test