bin : GoldenModel.cc Driver.cc Reporter.cc includes.h constants.h
	clang++  -I$(SYSTEMC_HOME)/include  -L$(SYSTEMC_LIBDIR) -lsystemc -lm -o  bin GoldenModel.cc

run : bin
	./bin 



clean :
	rm bin