//-------------------------------------------------------------------------
//						Compression Decompression Interface
//-------------------------------------------------------------------------

interface comp_if #(parameter  DATA_WIDTH = 8)(input logic clk);
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    logic [DATA_WIDTH-1:0] compressed_in;
    logic [DATA_WIDTH-1:0] compressed_out;
    logic [DATA_WIDTH-1:0] decompressed_out;
    logic [1:0] command;
    logic [1:0] response;
    logic reset;
    
    //Driver modport
    modport driverMod (
        input data_in,
        input compressed_in,
        input command,
        input reset,
        output compressed_out,
        output decompressed_out,
        output response
    );
    
    //Monitor modport
    modport monitorMod (
        output data_in,
        output compressed_in,
        output command,
        output reset,
        input compressed_out,
        input decompressed_out,
        input response
        
    );

    
endinterface