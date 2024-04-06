
using namespace sc_core;

SC_MODULE(Driver) {
    int compressed_in_width = 8;
    int randomNumber;
    sc_port<sc_signal_out_if<bool>> clk;
    sc_port<sc_signal_out_if<bool>> reset;
    sc_port<sc_signal_out_if<sc_dt::sc_lv<2>>>  command; 
    sc_port<sc_signal_out_if<sc_dt::sc_lv<80>>> data_in;
    sc_port<sc_signal_out_if<sc_dt::sc_lv<COMPRESSED_IN_WIDTH>>>  compressed_in;

    SC_CTOR(Driver) {
        SC_THREAD(drive);
        SC_THREAD(scheduelReset);
    }

    void drive(){
        std::string commandString = "";
        std::string data_inString = "";
        std::string compressed_inString = "";

        while(true){
            clk->write(false);

            commandString = "";
            data_inString = "";
            compressed_inString = "";

            for (int i = 0; i < 2; i++){
                commandString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            // command->write(commandString.c_str());
            command->write("01");

            for (int i = 0; i < 80; i++){
                data_inString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            data_in->write(data_inString.c_str());
            for (int i = 0; i < 8; i++){
                compressed_inString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            compressed_in->write(compressed_inString.c_str());

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
