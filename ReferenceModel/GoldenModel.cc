#include <systemc>
#include <stdio.h>  
#include <stdlib.h> 
#include <time.h>


#include "Driver.cc"
#include "Reporter.cc"
#include "constants.h"
#include "includes.h"



using namespace sc_core;

SC_MODULE(Compressor){
    //input ports

    //clock and reset
    sc_port<sc_signal_in_if<bool>> clk;
    sc_port<sc_signal_in_if<bool>> reset;

    //command pair, used for deciding compression,decompression or nop
    sc_port<sc_signal_in_if<bool>, 2, SC_ALL_BOUND> command; 

    //data_in, 80bit bus used to input data that is going to be compressed
    sc_port<sc_signal_in_if<bool>, 80, SC_ALL_BOUND> data_in;

    //compressed_in, 8bit bus used to input search for decompression
    sc_port<sc_signal_in_if<bool>, COMPRESSED_IN_WIDTH, SC_ALL_BOUND> compressed_in;

    //output ports

    //compressed_out, 8bit bus used to output compression result
    sc_port<sc_signal_out_if<bool>, COMPRESSED_IN_WIDTH, SC_ALL_BOUND> compressed_out;

    //decompressed_out, 80bit bus used to output decompression result
    sc_port<sc_signal_out_if<bool>, 80, SC_ALL_BOUND> decompressed_out;

    //response, used to show if the current output is a valid compression result, decompression result, invalid, or is an error
    sc_port<sc_signal_out_if<bool>, 2, SC_ALL_BOUND> response;

    //index buffer

    sc_buffer<int> index_buffer;

    std::vector <std::vector<bool>> table;
    

    SC_CTOR(Compressor){
        SC_THREAD(Behavior);
    }

    void Behavior(){
        bool search_flag = false;
        for(int i = 0; i < std::pow(2, COMPRESSED_IN_WIDTH); i++){
            for (int j = 0; j < 80; j++){
                table[i][j] = false;
            }
        }
        index_buffer.write(0);
        for (int i = 0; i < 2; i++){
            response[i]->write(false);
        }
        wait(SC_ZERO_TIME);

        while (true) {
            if (reset->read()){
                for(int i = 0; i < std::pow(2, COMPRESSED_IN_WIDTH); i++){
                    for (int j = 0; j < 80; j++){
                        table[i][j] = false;
                    }
                }
                index_buffer.write(0);
                for (int i = 0; i < 2; i++){
                    response[i]->write(false);
                }
            }else if (index_buffer.read() < std::pow(2, COMPRESSED_IN_WIDTH)){
                if (command[0]->read() == 1 && command[1]->read() == 0){

                    //DECOMPRESSION
                    std::cout << "DECOMPRESSION" << std::endl;

                    
                    //check if input is already registered

                    if (boolArrtoInt(compressed_in) < index_buffer.read()){
                        for (int j = 0; j < 80; j++){
                            decompressed_out[j] -> write(table[boolArrtoInt(compressed_in)][j]);
                        }
                        response[0] -> write(1);
                        response[1] -> write(0);
                    }else{
                        //ERROR
                        response[0] -> write(1);
                        response[1] -> write(1);
                    }
                    

                }else if (command[0]->read() == 0 && command[1]->read() == 1){

                    //COMPRESSION
                    std::cout << "COMPRESSION" << std::endl;

                    std::vector<bool> temp;

                    search_flag = false;
                    for(int i = 0; i < index_buffer.read(); i++){
                        for (int j = 0; j < 80; j++){
                            if (table[i][j] != data_in[j]->read())
                                break;
                                
                            if (j == 79){
                                search_flag = true;
                            }
                        }

                        if (search_flag){
                            temp = intToBoolArr(i);
                        }else{
                            temp = intToBoolArr(index_buffer.read());
                            index_buffer.write(index_buffer.read() + 1);
                        }

                        for (int j = 0; j < COMPRESSED_IN_WIDTH; j ++ ){
                            compressed_out[j]->write(temp[j]);
                        }
                        response[0] -> write(0);
                        response[1] -> write(1);
                        break;   
                    }


                }else if (command[0]->read() == 1 && command[1]->read() == 1){

                    //ERROR
                    std::cout << "ERROR" << std::endl;

                    response[0]->write(0);
                    response[1]->write(0);

                }else{

                    //NO OPERATION
                    std::cout << "NO OPERATION" << std::endl;

                    response[0]->write(0);
                    response[1]->write(0);
                }

            }else{
                response[0] -> write(1);
                response[0] -> write(1);
            }
            wait(clk->posedge_event());
        }
    }
    
};

int sc_main(int, char *[]){
    

    sc_signal<bool> clk;
    sc_signal<bool> reset;
    std::vector<sc_signal<bool>> command(2);
    std::vector<sc_signal<bool>> data_in(80);
    std::vector<sc_signal<bool>> compressed_in(8);



    
    sc_start(1000, SC_NS);
    return 0;
}
