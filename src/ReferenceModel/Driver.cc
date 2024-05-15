
using namespace sc_core;

//Driver Module will stimulate the reference model
//Purely for the Reference Model Demo

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

        messageToDriver dMessage;
        dMessage.mesg_type = 1;
        
        int ipc_key = ftok(FTOK_PATH, DSEED+1);

        int messageQueue = msgget(ipc_key, 0666 | IPC_CREAT);

        sc_dt::sc_lv<80> data_in_temp;

        std::cout << "Driver sees : " << messageQueue << std::endl;

        if (messageQueue == -1){
            perror("msgget");
            exit(1);
        }

        while(true){
            msgrcv(messageQueue, &dMessage, sizeof(dMessage), 1, 0);

            clk->write(false);


            command->write(static_cast<unsigned>(dMessage.command));

            for (int i = 0; i < 10; i++){
                for(int j = 0; j < 8; j++){
                    data_in_temp.bit(j + i * 8) =  (static_cast<int>(dMessage.data_in[i]) >> j) & 1;
                }
            }

            data_in->write(data_in_temp);

            compressed_in->write(static_cast<unsigned>(dMessage.compressed_in));

            reset->write(dMessage.reset);

            wait(SC_ZERO_TIME);

            // std::cout << "Driver: " << "cmprssd  " << "cmd " << "data_in" << std::endl; 
            // std::cout << "Driver: " << compressed_in->read() << " " << command->read()  << "  " << data_in->read()  << std::endl;

            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);
        }
    }
};
