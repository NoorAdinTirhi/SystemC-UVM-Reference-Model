// `include "uvm_pkg.sv"

// import uvm_pkg::*;

`include "components/compression_decompression_interface.sv"

`include "design/compression_decompression.sv"




module tb_top(input wire clk,
               output logic reset,
               output logic [1:0]  command,
               output logic [79:0] data_in,
               output logic [7:0]  compressed_in,
               output logic [7:0]  compressed_out,
               output logic [79:0] decompressed_out,
               output logic [1:0]  response
               );

    typedef byte byte_arr_t[9:0];
    // import DPI-C function to get reference model;
    // import "DPI-C" function byte getReset();
    // import "DPI-C" function byte getCommand();
    // import "DPI-C" function byte_arr_t getData_in();
    // import "DPI-C" function byte getCompressed_in();
    // import "DPI-C" function byte getCompressed_out();
    // import "DPI-C" function byte_arr_t getDeCompressed_out();
    // import "DPI-C" function byte getResponse();

    comp_if #(8) cd1_if();

    compression_decompression cd1 (
        .clk (clk),
        .reset(reset),
        .command (cd1_if.command),
        .data_in (cd1_if.data_in),
        .compressed_in (cd1_if.compressed_in),
        .compressed_out (cd1_if.compressed_out),
        .decompressed_out (cd1_if.decompressed_out),
        .response (cd1_if.response)
    );

    always @(posedge clk) begin
        command = 2'b01;
        compressed_in = 8'b11110000;
        data_in = 80'b000000000000000000000000001101010000000000000000000000000010011000000000000000000000000000100101;
        
    end


    

    // initial begin
    //     uvm_config_db#(virtual comp_if #(8))::set(null, "uvm_test_top", "cd1_if", cd1_if);
    //     `uvm_info("tb_top", "Interface Registered", UVM_NONE)
    // end



endmodule