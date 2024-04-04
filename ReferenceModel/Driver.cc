using namespace sc_core;

SC_MODULE(Driver) {
    int compressed_in_width = 8;
    int randomNumber;
    sc_port<sc_signal_out_if<bool>> clk;
    sc_port<sc_signal_out_if<bool>> reset;
    sc_port<sc_signal_out_if<bool>, 2, SC_ALL_BOUND> command; 
    sc_port<sc_signal_out_if<bool>, 80, SC_ALL_BOUND> data_in;
    sc_port<sc_signal_out_if<bool>, COMPRESSED_IN_WIDTH, SC_ALL_BOUND> compressed_in;

    SC_CTOR(Driver) {
        SC_THREAD(drive);
    }

    void drive(){
        while(true){
            clk->write(false);
            reset->write(false);
            for (int i = 0; i < 2; i++){
                command[i]->write(rand()%2 == 0) ;
            }
            for (int i = 0; i < 80; i++){
                data_in[i]->write(rand()%2 == 0);
            }

            for (int i = 0; i < COMPRESSED_IN_WIDTH; i++){
                compressed_in[i]->write(rand()%2 == 0);
            }
            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);

        }
    }


};

