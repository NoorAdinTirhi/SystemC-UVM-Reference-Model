#include <systemc>
#include <stdio.h>  
#include <stdlib.h> 
#include <time.h>
#include <vector>

#include "utils.h"
#include "../includes.h"
#include "Driver.cc"
#include "Reporter.cc"




using namespace sc_core;

//Compressor Module
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
        //hash table, maps compressed bits to data bits
        std::vector<sc_dt::sc_lv<80>> table (std::pow(2, COMPRESSED_IN_WIDTH));


        for(int i = 0; i < std::pow(2, COMPRESSED_IN_WIDTH); i++){
                table[i] = sc_dt::sc_lv<80>(nZeroString(80).c_str());
        }
        
        //temp variables used for calculations
        bool search_flag = false;

        int temp;

        int x = 0;


        int sum = 0;

        index_buffer = 0;
        
        response->write("00");


        // always loop equivelant, similar to behavioral programming
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
                response->write("11");
                continue;
            }

            if (command->read() == sc_dt::sc_lv<2>("11")){
                //ERROR
                response->write("11");
                continue;
            }

            if(command->read() == sc_dt::sc_lv<2>("00")){
                //NO OPERATION
                response->write("00");
                continue;
            }


            if (command->read() == sc_dt::sc_lv<2>("10")){
                //DECOMPRESSION
                
                //check if input is already registered
                if (compressed_in->read().to_int() <= index_buffer ){

                    // VALID DECOMPRESSION
                    decompressed_out -> write(table[compressed_in->read().to_int()]);
                    response -> write("10");

                }else{
                    response -> write("11");

                }
            }
                
            else if (command->read() == sc_dt::sc_lv<2>("01")){
                //COMPRESSION
                response -> write("01");

                search_flag = false;
                for(int i = 0; i <= index_buffer; i++){
                    if (table[i] == data_in->read()){
                        temp = i;

                    }else{

                        table[index_buffer] = ( data_in->read());
                        temp = index_buffer++;

                    }
            
                    compressed_out->write(temp);
                    break;   
                }
            }
        }
    }
    
};

// this is where the 3 modules' ports are connected
// Driver->Compressor->Reporter
int sc_main(int, char *[]){

    sc_report_handler::set_actions(SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_,
                                   SC_DO_NOTHING);

    //initialize random seed
    int seed = time(NULL);
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
    R1.command(command);
    R1.data_in(data_in);
    R1.decompressed_out(decompressed_out);
    R1.compressed_in(compressed_in);
    R1.compressed_out(compressed_out);

    sc_start(INT_MAX, SC_NS);

    return 0;
}



