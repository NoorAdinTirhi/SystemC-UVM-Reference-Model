// `include "uvm_pkg.sv"

// import uvm_pkg::*;

`include "components/compression_decompression_interface.sv"

`include "design/compression_decompression.sv"

export "DPI-C" function getReset;
export "DPI-C" function getCommand;
export "DPI-C" function getData_in;
export "DPI-C" function getCompressed_in;
export "DPI-C" function getCompressed_out;
export "DPI-C" function getDeCompressed_out;
export "DPI-C" function getResponse;


module tb_top(input wire clk);

    comp_if #(8) cd1_if;

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


    

    // initial begin
    //     uvm_config_db#(virtual comp_if #(8))::set(null, "uvm_test_top", "cd1_if", cd1_if);
    //     `uvm_info("tb_top", "Interface Registered", UVM_NONE)
    // end

    function byte getReset();
        return cd1_if.reset;
    endfunction

    function byte getCommand;
        return cd1_if.command;
    endfunction

    function byte unsigned getData_in;
        return cd1_if.data_in;
    endfunction


endmodule