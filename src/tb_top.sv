`include "uvm_pkg.sv"

import uvm_pkg::*;

`include "components/compression_decompression_interface.sv"


`include "design/compression_decompression.sv"


module tb_top(input wire clk, input wire reset);

    
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

initial begin
    uvm_config_db#(virtual comp_if #(8))::set(null, "uvm_test_top", "cd1_if", cd1_if);
    `uvm_info("tb_top", "Interface Registered", UVM_NONE)
end


endmodule