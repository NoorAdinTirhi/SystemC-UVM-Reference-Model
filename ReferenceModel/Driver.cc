
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
    }

    void drive(){
        std::string commandString = "";
        std::string data_inString = "";
        std::string compressed_inString = "";

        //Random Drive
        while(sc_time_stamp() < sc_time(20000, SC_NS)){
            clk->write(false);

            commandString = "";
            data_inString = "";
            compressed_inString = "";

            for (int i = 0; i < 2; i++){
                commandString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            command->write(commandString.c_str());

            for (int i = 0; i < 80; i++){
                data_inString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            data_in->write(data_inString.c_str());
            for (int i = 0; i < COMPRESSED_IN_WIDTH; i++){
                compressed_inString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            compressed_in->write(compressed_inString.c_str());

            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);
        }

        //RESET, so tests don't affect each other
        clk->write(false);
        reset->write(true);
        wait(5, SC_NS);
        clk->write(true);
        wait(5, SC_NS);
        reset->write(false);

        //Compression
        command -> write("01");
        while (sc_time_stamp() < sc_time(22500, SC_NS)){
            clk->write(false);
            data_inString = "";
            for (int i = 0; i < 80; i++){
                data_inString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            data_in->write(data_inString.c_str());
            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);
        }

        //Decompression
        command->write("10");
        int decompressedPointer = 0;
        while (sc_time_stamp() < sc_time(25000, SC_NS)){
            clk->write(false);
            compressed_in->write(sc_dt::sc_lv<COMPRESSED_IN_WIDTH>(decompressedPointer++));
            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);
        }

        //RESET, so tests don't affect each other
        clk->write(false);
        reset->write(true);
        wait(5, SC_NS);
        clk->write(true);
        wait(5, SC_NS);
        reset->write(false);

        //Mixed
        //Compression and Decompression
        decompressedPointer = 0;
        while (sc_time_stamp() < sc_time(30000, SC_NS)){
            clk->write(false);

            data_inString = "";
            for (int i = 0; i < 80; i++){
                data_inString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            data_in->write(data_inString.c_str());

            command->write("01");

            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);
            clk->write(false);

            data_inString = "";
            for (int i = 0; i < 80; i++){
                data_inString.append(std::to_string((rand()%2 == 0)?1:0));
            }
            data_in->write(data_inString.c_str());

            compressed_in->write(decompressedPointer++);
            command->write("10");

            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);
            clk->write(false);

        }
    }



};
