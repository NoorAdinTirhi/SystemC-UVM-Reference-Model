using namespace sc_core;

SC_MODULE(Reporter) {


    sc_port<sc_signal_in_if<bool>> clk;

    sc_port<sc_signal_in_if<bool>> reset;

    sc_port<sc_signal_in_if<sc_dt::sc_lv<2>>> command; 

    sc_port<sc_signal_in_if<sc_dt::sc_lv<80>>> data_in;

    sc_port<sc_signal_in_if<sc_dt::sc_lv<COMPRESSED_IN_WIDTH>>> compressed_in;

    sc_port<sc_signal_in_if<sc_dt::sc_lv<COMPRESSED_IN_WIDTH>>> compressed_out;

    sc_port<sc_signal_in_if<sc_dt::sc_lv<80>>> decompressed_out;

    sc_port<sc_signal_in_if<sc_dt::sc_lv<2>>> response;

    SC_CTOR(Reporter) {
        SC_THREAD(print);
    }

    void print(){
        while(true){
            wait(clk->posedge_event());
            wait(SC_ZERO_TIME);
            
            std::cout << "Time : " << sc_time_stamp() << std::endl\
                << "reset  : ";
            
            std::cout << reset -> read();

            std::cout << std::endl << "command  : ";

            std::cout <<  command -> read();

            std::cout << std::endl << "data_in  : ";

            std::cout << data_in -> read();
            
            std::cout << std::endl << "compressed_in  : ";

            std::cout << compressed_in -> read();
            
            std::cout << std::endl << "compressed_out  : ";

            std::cout << compressed_out -> read();

            std::cout << std::endl << "decompressed_out  : ";

            std::cout << decompressed_out->read();

            std::cout << std::endl << "response  : ";

            std::cout << response->read();

            std::cout<< std::endl<< std::endl<< "####################################################" << std::endl<< std::endl;
        }
    }


};



