using namespace sc_core;

SC_MODULE(Reporter) {
    sc_port<sc_signal_in_if<bool>> clk;

    sc_port<sc_signal_in_if<bool>, COMPRESSED_IN_WIDTH, SC_ALL_BOUND> compressed_out;

    sc_port<sc_signal_in_if<bool>, 80, SC_ALL_BOUND> decompressed_out;

    sc_port<sc_signal_in_if<bool>, 2, SC_ALL_BOUND> response;

    SC_CTOR(Reporter) {
        SC_THREAD(print);
    }

    void print(){
        while(true){
            wait(clk->posedge_event());
            wait(SC_ZERO_TIME);

            std::cout << "Time : " << sc_time_stamp() << std::endl\
                << "compressed out  : ";
            for (int  i = COMPRESSED_IN_WIDTH-1; i > -1; i--)
                std::cout << compressed_out[i] -> read();

            std::cout << std::endl << "decompressed_out  : ";

            for (int i = 79; i > -1; i--)
                std::cout << decompressed_out[i] -> read();
            
            std::cout << std::endl << "response  : ";

            for (int i = 1; i > -1; i--)
                std::cout << response[i] -> read();
            
            std::cout << std::endl << std::endl  << "####################################################" << std::endl << std::endl;


        }
    }


};



