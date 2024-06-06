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

        if (messageQueue == -1)
        {
            perror("msgget");
            exit(1);
        }

        while(true){
            wait(clk->posedge_event());
            wait(SC_ZERO_TIME);

            rMessage.reset = reset->read();
            rMessage.command = command->read().to_uint();
            rMessage.compressed_in = compressed_in->read().to_uint();
            rMessage.compressed_out = compressed_out->read().to_uint();
            rMessage.response = response->read().to_uint();
            for (int i = 0; i < 10; i++)
                    rMessage.data_in[i] = data_in->read().range(7+i*8, i*8).to_int();
            for (int i = 0; i < 10; i++)
                    rMessage.decompressed_out[i] = decompressed_out->read().range(7+i*8, i*8).to_int();

            // cout << "command : " << static_cast<unsigned>(rMessage.command) << endl;
            // cout << "compressed in : "<< static_cast<unsigned>(rMessage.compressed_in) << endl;
            // cout << "compressed out : "<< static_cast<unsigned>(rMessage.compressed_out) << endl;
            // cout << "response : " << static_cast<unsigned>(rMessage.response) << endl;
            
            // cout << "data_in : ";
            // for (int i = 0; i < 10; i++)
            //     cout <<  static_cast<unsigned>(rMessage.data_in[i]) << " ";
            // cout << endl <<"decompressed_out : ";
            // for (int i = 0; i < 10; i++)
            //     cout << static_cast<unsigned>(rMessage.decompressed_out[i]) << " ";
            // cout << endl;

            if (msgsnd(messageQueue, &rMessage, sizeof(rMessage), 0) == -1)
            {
                perror("reporter send message: error");
                exit(1);
            };
        }
    }


};



