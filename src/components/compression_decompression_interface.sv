//-------------------------------------------------------------------------
//						Compression Decompression Interface
//-------------------------------------------------------------------------

interface comp_if #(parameter  DATA_WIDTH = 8);
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    logic [DATA_WIDTH-1:0] compressed_in;
    logic [DATA_WIDTH-1:0] compressed_out;
    logic [DATA_WIDTH-1:0] decompressed_out;
    logic [1:0] command;
    logic [1:0] response;
    
    //Driver modport
    modport driverMon (
        input data_in,
        input compressed_in,
        input command,
        output compressed_out,
        output decompressed_out,
        output response
    );
    
    //Monitor modport
    modport monitorMon (
        output data_in,
        output compressed_in,
        output command,
        input compressed_out,
        input decompressed_out,
        input response
        
    );
    
endinterface