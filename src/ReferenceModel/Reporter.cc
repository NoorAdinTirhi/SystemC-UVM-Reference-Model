using namespace sc_core;

// Reporter Module prints out Compressor output
// Purely for the Reference Model Demo

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

        messageFromReporter rMessage;

        rMessage.mesg_type = 1;

        int ipc_key = ftok(FTOK_PATH, RSEED + 1);

        int messageQueue = msgget(ipc_key, 0666 | IPC_CREAT);

        std::cout << "Reporter sees : " << messageQueue << std::endl;

        if (messageQueue == -1)
        {
            perror("msgget");
            exit(1);
        }

        while(true){
            wait(clk->posedge_event());
            wait(SC_ZERO_TIME);

            rMessage.reset = reset->read();

            strncpy(rMessage.compressed_out, compressed_out->read().to_string().c_str(), COMPRESSED_IN_WIDTH);
            strncpy(rMessage.decompressed_out, decompressed_out->read().to_string().c_str(), 80);
            strncpy(rMessage.command, command->read().to_string().c_str(), 2);
            strncpy(rMessage.compressed_in, compressed_in->read().to_string().c_str(), COMPRESSED_IN_WIDTH);
            strncpy(rMessage.response, response->read().to_string().c_str(), 2);
            strncpy (rMessage.data_in, data_in->read().to_string().c_str(), 80);

            /*std::cout << "Time : " << sc_time_stamp() << std::endl\
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

            std::cout<< std::endl<< std::endl<< "####################################################" << std::endl<< std::endl;*/

            if (msgsnd(messageQueue, &rMessage, sizeof(rMessage), 0) == -1)
            {
                perror("person painter send :");
                exit(1);
            };
        }
    }


};



