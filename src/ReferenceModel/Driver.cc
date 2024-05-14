
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

        std::cout << "Driver sees : " << messageQueue << std::endl;

        if (messageQueue == -1){
            perror("msgget");
            exit(1);
        }

        std::string commandStr;
        std::string dataStr;
        std::string compressedStr;

        while(true){
            msgrcv(messageQueue, &dMessage, sizeof(dMessage), 1, 0);

            clk->write(false);

            commandStr = std::string(dMessage.command);
            dataStr = std::string(dMessage.data_in);
            compressedStr = std::string(dMessage.compressed_in);

            command->write(sc_dt::sc_lv<2>(commandStr.c_str()));

            data_in->write(sc_dt::sc_lv<80>(dataStr.c_str())    );

            compressed_in->write(sc_dt::sc_lv<COMPRESSED_IN_WIDTH>(compressedStr.c_str()));

            reset->write(dMessage.reset);

            wait(SC_ZERO_TIME);

            // std::cout << "Driver: " << "cmprssd  " << "cmd " << "data_in" << std::endl; 
            std::cout << "Driver: " << compressed_in->read().to_string() << " " << command->read()  << "  " << data_in->read()  << std::endl;

            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);
        }
    }
};
