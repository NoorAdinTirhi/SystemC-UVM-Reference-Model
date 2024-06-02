class comp_decomp_seq_item extends uvm_sequence_item;
    
    rand bit [63:0] data_in_lo;
    rand bit [15:0] data_in_hi;
    rand bit [7:0] compressed_in;
    rand bit [1:0] command;
    bit reset;
    bit [7:0] compressed_out;
    bit [63:0] decompressed_out_lo;
    bit [15:0] decompressed_out_hi;
    bit [1:0] response;

    `uvm_object_utils_begin(comp_decomp_seq_item)
        `uvm_field_int(data_in_lo, UVM_ALL_ON)
        `uvm_field_int(data_in_hi, UVM_ALL_ON)
        `uvm_field_int(compressed_in, UVM_ALL_ON)
        `uvm_field_int(compressed_out, UVM_ALL_ON)
        `uvm_field_int(decompressed_out_lo, UVM_ALL_ON)
        `uvm_field_int(decompressed_out_hi, UVM_ALL_ON)
        `uvm_field_int(command, UVM_ALL_ON)
        `uvm_field_int(response, UVM_ALL_ON)
        `uvm_field_int(reset, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "comp_decomp_seq_item");
        super.new(name);
    endfunction //new()

endclass //packet