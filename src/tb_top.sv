`include "uvm_pkg.sv"

import uvm_pkg::*;

`include "components/packet.sv"

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

    `include "components/DPICommunication.sv"
    

    comp_if #(8) cd1_if(clk);

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

    //assign all interface signals to the top module outputs
    assign reset = cd1_if.reset;
    assign command = cd1_if.command;
    assign data_in = cd1_if.data_in;
    assign compressed_in = cd1_if.compressed_in;
    assign compressed_out = cd1_if.compressed_out;
    assign decompressed_out = cd1_if.decompressed_out;
    assign response = cd1_if.response;

    always @(posedge clk) begin
        $display("reset : 0b%0b", getReset());
        $display("command : 0b%0b", getCommand());
        $display("data_in : 0x%0h", getData_in());
        $display("compressed_in : 0b%0b", getCompressed_in());
        $display("compressed_out : 0b%0b", getCompressed_out());
        $display("decompressed_out : 0x%0h", getDecompressed_out());
        $display("response : 0b%0b", getResponse());
        $display("---------------------------------------------------");
    end

    initial begin
        uvm_config_db#(virtual comp_if #(8))::set(null, "uvm_test_top", "cd1_if", cd1_if);
        `uvm_info("tb_top", "Interface Registered", UVM_NONE)
    end



endmodule