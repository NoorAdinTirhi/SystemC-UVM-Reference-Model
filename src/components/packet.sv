class packet;
    
    rand bit [79:0] data_in;
    rand bit [7:0] compressed_in;
    rand bit [7:0] compressed_out;
    rand bit [79:0] decompressed_out;
    rand bit [1:0] command;
    rand bit [1:0] response;
    rand bit reset;

    function new();
        data_in = 80'b0;
        compressed_in = 8'b0;
        compressed_out = 8'b0;
        decompressed_out = 80'b0;
        command = 2'b0;
        response = 2'b0;
        reset = 1'b0;
    endfunction //new()

endclass //packet