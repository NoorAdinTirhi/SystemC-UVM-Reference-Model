// Learn with Examples, 2020, MIT license
#include <systemc>
#include <vector> // used to define a vector of ports
using namespace sc_core;

SC_MODULE(WRITER) {
  sc_port<sc_signal_out_if<sc_dt::sc_lv <16>>> output;
  

   
  SC_CTOR(WRITER){
    SC_THREAD(write);
  }
  void write(){
    output->write("110111000101");
  }
};
SC_MODULE(READER) {
  sc_in<sc_dt::sc_lv <16>> input;
  SC_CTOR(READER){
    SC_THREAD(print);
  }
  void print(){
    std::cout << input.read() << std::endl;
  }
};

int sc_main(int, char*[]) {

  sc_signal< sc_dt::sc_lv <16>> wires;

  WRITER W1("writer");

  READER R1("reader");

  W1.output(wires);
  R1.input(wires);


  
}
