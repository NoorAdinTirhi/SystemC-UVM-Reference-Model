#include <systemc>
#include <stdio.h>  
#include <stdlib.h> 
#include <time.h>   

using namespace sc_core;

SC_MODULE(Driver) {
    int compressed_in_width = 8;
    int randomNumber;
    sc_port<sc_signal_out_if<bool>> clk;
    sc_port<sc_signal_out_if<bool>> reset;
    sc_port<sc_signal_out_if<bool>, 2, SC_ALL_BOUND> command; 
    sc_port<sc_signal_out_if<bool>, 80, SC_ALL_BOUND> data_in;
    sc_port<sc_signal_out_if<bool>, 8, SC_ALL_BOUND> compressed_in;

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

            for (int i = 0; i < 8; i++){
                compressed_in[i]->write(rand()%2 == 0);
            }
            wait(5, SC_NS);
            clk->write(true);
            wait(5, SC_NS);

        }
    }


};


SC_MODULE(Receiver){
    sc_port<sc_signal_in_if<bool>> clk;
    sc_port<sc_signal_in_if<bool>> reset;
    sc_port<sc_signal_in_if<bool>, 2, SC_ALL_BOUND> command; 
    sc_port<sc_signal_in_if<bool>, 80, SC_ALL_BOUND> data_in;
    sc_port<sc_signal_in_if<bool>, 8, SC_ALL_BOUND> compressed_in;

    SC_CTOR(Receiver){
        SC_THREAD(printer);
    }

    void printer(){
        while(true){
            std::cout << sc_time_stamp() << std::endl\
                        << " clk           : " << clk -> read() << std::endl\
                        << " command       : " << command[0] -> read() << command[1] -> read() << std::endl\
                        << " data_in       : ";

            for (int i = 0; i < 80; i++){
                std::cout << data_in[i] -> read();
            }
            std::cout << std::endl;
            
            std::cout << " compressed_in : ";
            for (int i = 0; i< 8; i++){
                std::cout << compressed_in[i] -> read();
            } 
            std::cout << std::endl;
            wait(clk->posedge_event());
        }
    }
};

// int sc_main(int, char *[]){
//     srand(time(NULL));


//     Driver D1("driver");
//     Receiver R1 ("receiver");

//     sc_signal<bool> clk;
//     sc_signal<bool> reset;
//     std::vector<sc_signal<bool>> command(2);
//     std::vector<sc_signal<bool>> data_in(80);
//     std::vector<sc_signal<bool>> compressed_in(8);


//     D1.clk(clk);
//     R1.clk(clk);

//     D1.reset(reset);
//     R1.reset(reset);

//     for(int i = 0; i < 2; i++){
//         D1.command(command[i]);
//         R1.command(command[i]);
//     }
//     for(int i = 0; i < 80; i++){
//         D1.data_in(data_in[i]);
//         R1.data_in(data_in[i]);
//     }
//     for(int i = 0; i < 8; i++){
//         D1.compressed_in(compressed_in[i]);
//         R1.compressed_in(compressed_in[i]);
//     }

    
//     sc_start(1000, SC_NS);
//     return 0;
// }
