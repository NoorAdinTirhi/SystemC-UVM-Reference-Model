#include <systemc>
#include <stdio.h>  
#include <stdlib.h> 
#include <time.h>

#include "constants.h"
#include "includes.h"
#include "Driver.cc"
#include "Reporter.cc"




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

        table.reserve(std::pow(2, COMPRESSED_IN_WIDTH));
        
        bool search_flag = false;

        int sum = 0;
        for(int i = 0; i < std::pow(2, COMPRESSED_IN_WIDTH); i++){
            table[i].reserve(80);
            for (int j = 0; j < 80; j++){
                table[i][j] = false;
            }
        }
        index_buffer.write(0);
        for (int i = 0; i < 2; i++){
            response[i]->write(false);
        }

        while (true) {
            wait(clk->posedge_event());
            if (reset->read()){
                //RESET
                for(int i = 0; i < std::pow(2, COMPRESSED_IN_WIDTH); i++){
                    for (int j = 0; j < 80; j++){
                        table[i][j] = false;
                    }
                }
                index_buffer.write(0);

                for (int i = 0; i < 2; i++){
                    response[i]->write(false);
                }
                continue;
            }

            if(index_buffer.read() >= std::pow(2, COMPRESSED_IN_WIDTH)){
                //ERROR
                response[0] -> write(1);
                response[0] -> write(1);
                continue;
            }

            if (command[0]->read() == 1 && command[1]->read() == 1){
                //ERROR
                std::cout << "ERROR" << std::endl;
                response[0]->write(1);
                response[1]->write(1);
                continue;
            }

            if(command[0]->read() == 0 && command[1]->read() == 0){
                //NO OPERATION
                std::cout << "NO OPERATION" << std::endl;
                response[0]->write(0);
                response[1]->write(0);
                continue;
            }

            if (command[0]->read() == 1 && command[1]->read() == 0){
                //DECOMPRESSION
                std::cout << "DECOMPRESSION : ";
                
                //check if input is already registered

                sum = 0;
                for (int i = 0; i < COMPRESSED_IN_WIDTH; i++){
                    sum += (compressed_in[i] -> read()) ? std::pow(2,i) : 0;
                }
                if (sum < index_buffer.read() ){
                    // VALID DECOMPRESSION
                    std::cout << "VALID" << std::endl;
                    for (int j = 0; j < 80; j++){
                        decompressed_out[j] -> write(table[boolArrtoInt(compressed_in)][j]);
                    }
                    response[0] -> write(1);
                    response[1] -> write(0);
                }else{
                    std::cout << "ERROR" << std::endl;
                    response[0] -> write(1);
                    response[1] -> write(1);
                }
            }
                
            else if (command[0]->read() == 0 && command[1]->read() == 1){
                //COMPRESSION
                std::cout << "COMPRESSION VALID " << std::endl;
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
                        temp = intToBoolArr(index_buffer.read() + 1);
                        for(int j = 0; j < 80; j++)
                            table[index_buffer.read() + 1][j] = data_in[j]->read();
                        index_buffer.write(index_buffer.read() + 1);
                        
                    }
                    for (int j = 0; j < COMPRESSED_IN_WIDTH; j ++ )
                        compressed_out[j]->write(temp[j]);
                    
                    response[0] -> write(0);
                    response[1] -> write(1);
                    break;   
                }
            }
        }
    }
    
};

int sc_main(int, char *[]){

    //initialize random seed
    srand(5);
    
    //compressor inputs
    sc_signal<bool> clk;
    sc_signal<bool> reset;
    std::vector<sc_signal<bool>> command(2);
    std::vector<sc_signal<bool>> data_in(80);
    std::vector<sc_signal<bool>> compressed_in(COMPRESSED_IN_WIDTH);

    //compressor outputs
    std::vector<sc_signal<bool>> compressed_out(COMPRESSED_IN_WIDTH);
    std::vector<sc_signal<bool>> decompressed_out(80);
    std::vector<sc_signal<bool>> response(2);

    Driver D1("driver");

    Compressor C1 ("compressor");

    Reporter R1 ("reporter");

    sc_trace_file* file = sc_create_vcd_trace_file("trace");

    //binding the modules' ports
    D1.clk(clk);
    C1.clk(clk);
    R1.clk(clk);

    D1.reset(reset);
    C1.reset(reset);
    
    for(int i = 0; i < 2; i++){
        D1.command(command[i]);
        C1.command(command[i]);
        C1.response(response[i]);
        R1.response(response[i]);
    }
        
    for(int i = 0; i < 80; i++){
        D1.data_in(data_in[i]);
        C1.data_in(data_in[i]);
        C1.decompressed_out(decompressed_out[i]);
        R1.decompressed_out(decompressed_out[i]);
    }
        
    for(int i = 0; i < COMPRESSED_IN_WIDTH; i ++){
        D1.compressed_in(compressed_in[i]);
        C1.compressed_in(compressed_in[i]);
        C1.compressed_out(compressed_out[i]);
        R1.compressed_out(compressed_out[i]);
    }
    
    sc_trace(file, clk, "clk");
    sc_trace(file, reset, "reset");
    for (int i = 0; i < 2; i++)
        sc_trace(file, response[i], "response");
    for (int i = 0; i < 2; i++)
        sc_trace(file, command[i], "command");
    for (int i = 0; i < COMPRESSED_IN_WIDTH; i++)
        sc_trace(file, compressed_in[i], "compressed_in");
    for (int i = 0; i < COMPRESSED_IN_WIDTH; i++)
        sc_trace(file, compressed_out[i], "compressed_out");
    for (int i = 0; i < 80; i++)
        sc_trace(file, data_in[i], "data_in");
    for (int i = 0; i < 80; i++)
        sc_trace(file, decompressed_out[i], "decompressed_out");
    
  
    
    sc_start(1000, SC_NS);
    sc_close_vcd_trace_file(file); // close trace file
    return 0;
}



