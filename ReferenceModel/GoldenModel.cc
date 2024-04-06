#include <systemc>
#include <stdio.h>  
#include <stdlib.h> 
#include <time.h>
#include <vector>

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
    sc_port<sc_signal_in_if<sc_dt::sc_lv<2>>> command; 

    //data_in, 80bit bus used to input data that is going to be compressed
    sc_port<sc_signal_in_if<sc_dt::sc_lv<80>>> data_in;

    //compressed_in, 8bit bus used to input search for decompression
    sc_port<sc_signal_in_if<sc_dt::sc_lv<COMPRESSED_IN_WIDTH>>> compressed_in;

    //output ports

    //compressed_out, 8bit bus used to output compression result
    sc_port<sc_signal_out_if<sc_dt::sc_lv<COMPRESSED_IN_WIDTH>>> compressed_out;

    //decompressed_out, 80bit bus used to output decompression result
    sc_port<sc_signal_out_if<sc_dt::sc_lv<80>>> decompressed_out;

    //response, used to show if the current output is a valid compression result, decompression result, invalid, or is an error
    sc_port<sc_signal_out_if<sc_dt::sc_lv<2>>> response;

    //index buffer

    int index_buffer;
    


    

    SC_CTOR(Compressor){
        SC_THREAD(Behavior);
    }

    void Behavior(){
        std::vector<sc_dt::sc_lv<80>> table (std::pow(2, COMPRESSED_IN_WIDTH));

        for(int i = 0; i < std::pow(2, COMPRESSED_IN_WIDTH); i++){
                table[i] = sc_dt::sc_lv<80>(nZeroString(80).c_str());
        }
        
        bool search_flag = false;

        int temp;

        int x = 0;


        int sum = 0;

        index_buffer = 0;
        
        response->write("00");

        while (true) {
            wait(clk->posedge_event());
            if (reset->read()){
                //RESET
                for(int i = 0; i < std::pow(2, COMPRESSED_IN_WIDTH); i++){
                    table[i] = sc_dt::sc_lv<80>(nZeroString(80).c_str());
                }
                index_buffer = 0;

                response->write("00");
                continue;
            }

            if(index_buffer >= std::pow(2, COMPRESSED_IN_WIDTH) - 1){
                //ERROR
                std::cout << "ERROR : MEMORY FULL" << std::endl;
                response->write("11");
                continue;
            }

            if (command->read() == sc_dt::sc_lv<2>("11")){
                //ERROR
                std::cout << "ERROR : COMMAND is 11" << std::endl;
                response->write("11");
                continue;
            }

            if(command->read() == sc_dt::sc_lv<2>("00")){
                //NO OPERATION
                std::cout << "NO OPERATION" << std::endl;
                response->write("00");
                continue;
            }


            if (command->read() == sc_dt::sc_lv<2>("10")){
                //DECOMPRESSION
                std::cout << "DECOMPRESSION : ";
                
                //check if input is already registered

                
                if (compressed_in->read().to_int() <= index_buffer ){
                    // VALID DECOMPRESSION
                    std::cout << "VALID" << std::endl;

                    decompressed_out -> write(table[compressed_in->read().to_int()]);
                    response -> write("01");

                }else{
                    std::cout << "ERROR : " << compressed_in->read().to_int() << " > " << index_buffer << std::endl;
                    response -> write("11");
                }
            }
                
            else if (command->read() == sc_dt::sc_lv<2>("01")){
                //COMPRESSION
                std::cout << "COMPRESSION VALID ";

                response -> write("10");

                search_flag = false;
                for(int i = 0; i <= index_buffer; i++){
                    for (int j = 0; j < 80; j++){
                        if (table[i] != data_in->read())
                            break;
                            
                        if (j == 79){
                            search_flag = true;
                        }
                    }
                    std::cout << " FOUND :  " << search_flag << " on iteration : " << i << std::endl;

                    std::cout << "INDEX BUFFER : " << index_buffer << std::endl; 

                    if (search_flag){
                    temp = i;
                        
                    }else{
                        temp = index_buffer + 1;

                        table[index_buffer] = ( data_in->read());

                        std::cout << "table entry number : " << index_buffer << " : " << table[index_buffer] << std::endl;
                        
                        index_buffer = temp; 
                    }

                    compressed_out->write(temp);
                    break;   
                }
            }
        }
    }
    
};

int sc_main(int, char *[]){

    //initialize random seed
    srand(time(NULL));
    
    //compressor inputs
    sc_signal<bool> reset;
    sc_signal<bool> clk;
    sc_signal<sc_dt::sc_lv<2>> command;
    sc_signal<sc_dt::sc_lv<80>> data_in;
    sc_signal<sc_dt::sc_lv<COMPRESSED_IN_WIDTH>> compressed_in;

    //compressor outputs
    sc_signal<sc_dt::sc_lv<COMPRESSED_IN_WIDTH>> compressed_out;
    sc_signal<sc_dt::sc_lv<80>> decompressed_out;
    sc_signal<sc_dt::sc_lv<2>> response;

    Driver D1("driver");

    Compressor C1 ("compressor");

    Reporter R1 ("reporter");

    sc_trace_file* file = sc_create_vcd_trace_file("trace");

    //binding the Driver's ports
    D1.clk(clk);
    D1.reset(reset);
    D1.command(command);
    D1.data_in(data_in);
    D1.compressed_in(compressed_in);

    //binding the Compressor's ports
    C1.clk(clk);
    C1.reset(reset);
    C1.command(command);
    C1.response(response);
    C1.data_in(data_in);
    C1.decompressed_out(decompressed_out);
    C1.compressed_in(compressed_in);
    C1.compressed_out(compressed_out);

    //binding Reporter's ports
    R1.clk(clk);    
    R1.reset(reset);
    R1.response(response);
    R1.command(response);
    R1.data_in(data_in);
    R1.decompressed_out(decompressed_out);
    R1.compressed_in(compressed_in);
    R1.compressed_out(compressed_out);


    //Trace Signals
    sc_trace(file, clk, "clk");
    sc_trace(file, reset, "reset");
    sc_trace(file, response, "response");
    sc_trace(file, command, "command");
    sc_trace(file, compressed_in, "compressed_in");
    sc_trace(file, compressed_out, "compressed_out");
    sc_trace(file, data_in, "data_in");
    sc_trace(file, decompressed_out, "decompressed_out");
        
    
  
    
    sc_start(100000, SC_NS);
    sc_close_vcd_trace_file(file); // close trace file
    return 0;
}



