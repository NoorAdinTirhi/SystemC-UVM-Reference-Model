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
        SC_THREAD(scheduelReset);
    }

    void drive(){
        while(true){
            clk->write(false);
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
    void scheduelReset(){
        int i = 1;
        reset->write(false);
        while (true)
        {
            std::cout << "TIME FRACTION : " << abs((sc_time_stamp() - sc_time(11000, SC_NS)* i)/sc_time(11000, SC_NS))  << std::endl;
            if (abs((sc_time_stamp() - sc_time(11000, SC_NS)* i)/sc_time(11000, SC_NS)) < 0.1 ){
                reset->write(true);
                i++;
            }else{
                reset->write(false);
            }
            wait(10, SC_NS);
        }
        
    }



};

