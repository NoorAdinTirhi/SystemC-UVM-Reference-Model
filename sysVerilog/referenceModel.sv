// Code your design here
module referenceModel(
  	input logic        clk,
    input logic        reset,
    input logic [ 1:0] command,
    input logic [79:0] data_in,       // 80 bit Input Data to be compressed
    input logic [ 7:0] compressed_in, // 8 bit Input Data to be decompressed

    // Output Ports
    output logic [ 7:0] compressed_out,    // 8 Output Output compressed data
    output logic [79:0] decompressed_out,
  	output logic [ 1:0] response);
  
  	reg [79:0] hash_table [255:0];
  	int index_buffer;
  	bit search_flag;
  	always @(posedge clk, posedge reset) begin
  	  search_flag = 0;
  	  if (reset)begin
        for(int i = 0; i <= 255; i++)begin
  	      hash_table[i] = 0;
  	    end
  	    index_buffer = 0;
  	    response = 0;
  	  end else begin
  	    if (command == 'b11)
  	      response = 'b11;
  	    else if (command == 'b00)
  	      response = 'b00;
  	    else if (command == 'b10)begin
        	if (compressed_in < index_buffer)begin
  	    	    decompressed_out = hash_table[compressed_in];
  	    	    response = 'b10;
  	    	end else begin
  	    	    response = 'b11;
            end
  	    end else if (command == 'b01) begin
  	      response = 'b01;
          if (index_buffer >= 256)
  	      	response = 'b11;
  	      for(int i = 0; i < index_buffer; i++)begin
  	        if(hash_table[i] == data_in)begin
  	        	compressed_out = i;
  	          search_flag = 1;
  	          break;
  	        end end
  	      if (!search_flag) begin
  	        hash_table[index_buffer] = data_in;
  	        compressed_out = index_buffer;
            index_buffer=index_buffer+1;
  	      end end end end
endmodule