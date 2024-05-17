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

    typedef logic[79:0] logic_arr_t;
    // import DPI-C function to get reference model;
    import "DPI-C" function byte getReset();
    import "DPI-C" function byte getCommand();
    import "DPI-C" function int getWordData_in(int wi);
    import "DPI-C" function byte getCompressed_in();
    import "DPI-C" function byte getCompressed_out();
    import "DPI-C" function int getWordDecompressed_out(int wi);
    import "DPI-C" function byte getResponse();

    function logic_arr_t getData_in();
        logic_arr_t data;
        for (int i = 0; i < 80; i++) begin
            data[i] = getWordData_in(i/32);
        end
        return data;
    endfunction

    function logic_arr_t getDecompressed_out();
        logic_arr_t data;
        for (int i = 0; i < 80; i++) begin
            data[i] = getWordDecompressed_out(i/32);
        end
        return data;
    endfunction
    

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
        command = 2'b01;
        compressed_in = 8'b11110000;
        data_in = 80'b1000000000000000000000000011010100000000000001001100000000000000000000000001011;   
    end
    //TODO: fix getWordData_in in include file
    //TODO: fix getWordDecompressed_out in include file
    always @(posedge clk) begin
        $display("reset : ", getReset());
        $display("command : ", getCommand());
        $display("data_in : ", getData_in());
        $display("compressed_in : ", getCompressed_in());
        $display("compressed_out : ", getCompressed_out());
        $display("decompressed_out : ", getDecompressed_out());
        $display("response : ", getResponse());
        $display("---------------------------------------------------");
    end


    

    // initial begin
    //     uvm_config_db#(virtual comp_if #(8))::set(null, "uvm_test_top", "cd1_if", cd1_if);
    //     `uvm_info("tb_top", "Interface Registered", UVM_NONE)
    // end



endmodule