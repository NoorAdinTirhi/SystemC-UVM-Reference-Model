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
  
  	
  	
  	//dynamic memory to be used as stack or queue for testing
  	static bit [79:0] prev_data_in[$];
  	//used to see last returned address
  	static bit   [7:0] last_address = 0;
  

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
  
  //contraints
  constraint compression_only {command == 'b01;}	
  
  constraint decompression_only {command == 'b10;}
  
  constraint iterate_address{compressed_in == last_address;}
  
  constraint data_in_exists{queue_contains(prev_data_in, {data_in_hi, data_in_lo});}
  
  constraint new_data_in{!queue_contains(prev_data_in, {data_in_hi, data_in_lo});}
    
  constraint invalid_decompression{command == 'b10; compressed_in >= last_address; compressed_in dist {last_address := 5, [128:256] := 20};}
  
  constraint valid_decompression{command == 'b10; compressed_in < 128;}
  
  constraint data_in_zero{data_in_hi == 0; data_in_lo == 0;}
  
  
  function void post_randomize();
    if(command == 'b01)begin
    	last_address++;
      prev_data_in.push_front({this.data_in_hi, this.data_in_lo});
    end    
  endfunction
  
  function void pre_randomize();
    if(decompression_only.constraint_mode() && iterate_address.constraint_mode()) begin
      last_address--;
    end
  endfunction
  
  function bit queue_contains(bit [79:0] queue[$], bit [79:0] key);
    foreach(queue[i])
      if(queue[i] == key)
        return 1;
   	return 0;
  endfunction
  
endclass 




class dut_ref_seq_item extends uvm_sequence_item;
    
  bit [63:0] 	data_in_lo;
  bit [15:0]  data_in_hi;
  bit [7:0] 	compressed_in;
  bit [1:0]  	command;
  bit 			  reset;
  
  bit [7:0]  	dut_compressed_out;
  bit [63:0]  dut_decompressed_out_lo;
  bit [15:0]  dut_decompressed_out_hi;
  bit [1:0]  	dut_response;
  
  bit [7:0]  	ref_compressed_out;
  bit [63:0]  ref_decompressed_out_lo;
  bit [15:0]  ref_decompressed_out_hi;
  bit [1:0]  	ref_response;

  `uvm_object_utils_begin(dut_ref_seq_item)
  	`uvm_field_int(data_in_lo, UVM_ALL_ON)
  	`uvm_field_int(data_in_hi, UVM_ALL_ON)
  	`uvm_field_int(compressed_in, UVM_ALL_ON)
  	`uvm_field_int(reset, UVM_ALL_ON)
  	`uvm_field_int(command, UVM_ALL_ON)
  
  	`uvm_field_int(dut_compressed_out, UVM_ALL_ON)
  	`uvm_field_int(dut_decompressed_out_lo, UVM_ALL_ON)
  	`uvm_field_int(dut_decompressed_out_hi, UVM_ALL_ON)
  	`uvm_field_int(dut_response, UVM_ALL_ON)
  
  	`uvm_field_int(ref_compressed_out, UVM_ALL_ON)
  	`uvm_field_int(ref_decompressed_out_lo, UVM_ALL_ON)
  	`uvm_field_int(ref_decompressed_out_hi, UVM_ALL_ON)
  	`uvm_field_int(ref_response, UVM_ALL_ON)
  `uvm_object_utils_end

    function new(string name = "comp_decomp_seq_item");
        super.new(name);
    endfunction //new()
  
  function void failed_compression;
    `uvm_warning("FAILED VECTOR", $sformatf("data_in : 0x%0h", {this.data_in_hi,this.data_in_lo}))
    `uvm_warning("FAILED VECTOR", $sformatf("DUT compressed_out : 0x%0h", this.dut_compressed_out))
    `uvm_warning("FAILED VECTOR", $sformatf("DUT response : 0x%0b", this.dut_response))
    `uvm_warning("FAILED VECTOR", $sformatf("REF compressed_out : 0x%0h", this.ref_compressed_out))
    `uvm_warning("FAILED VECTOR", $sformatf("REF response : 0x%0b", this.ref_response))
  endfunction
  
  function void failed_decompression;
    `uvm_warning("FAILED VECTOR", $sformatf("compressed_in : 0x%0h", this.compressed_in))
    `uvm_warning("FAILED VECTOR", $sformatf("DUT decompressed_out : 0x%0h", {this.dut_decompressed_out_hi,this.dut_decompressed_out_lo}))
    `uvm_warning("FAILED VECTOR", $sformatf("DUT response : 0x%0b", this.dut_response))
    `uvm_warning("FAILED VECTOR", $sformatf("REF decompressed_out : 0x%0h", {this.ref_decompressed_out_hi,this.ref_decompressed_out_lo}))
    `uvm_warning("FAILED VECTOR", $sformatf("REF response : 0x%0b", this.ref_response))
  endfunction

endclass //packet

