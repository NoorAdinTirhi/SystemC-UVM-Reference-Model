`include "referenceModel.sv"
`include "comp_decomp_if.sv"

`include "comp_decomp_test.sv"

module tb_top();
  
	logic clk = 0;
  
  string tests[$] = {"pseudo_random_test", "decomp_after_comp_test", "index_buffer_OF_test", "invalid_decompression_test", "data_in_zero_test", "all_comb_test"};
  
  	always #5 clk = ~clk;
  
  	comp_if #(8) dut_if(clk);

  	compression_decompression dut(clk,
                                  dut_if.reset,
                                  dut_if.command,
                                  dut_if.data_in,
                                  dut_if.compressed_in,
                                  
                                  dut_if.compressed_out,
                               	  dut_if.decompressed_out,
                                  dut_if.response);	
  
  	comp_if #(8) ref_if(clk);
    
   	referenceModel ref1(clk,
						ref_if.reset,
						ref_if.command,
						ref_if.data_in,
						ref_if.compressed_in,
						ref_if.compressed_out,
						ref_if.decompressed_out,
                        ref_if.response);
  
  
  
  	initial begin
      uvm_config_db#(virtual comp_if #(8))::set(uvm_root::get(), "*", "dut_if", dut_if);
      `uvm_info("tb_top", "DUT Interface Registered", UVM_NONE)
      
      
      uvm_config_db#(virtual comp_if #(8))::set(uvm_root::get(), "*", "ref_if", ref_if);
      `uvm_info("tb_top", "REF Interface Registered", UVM_NONE)
    end
  
  	initial begin
      run_test(tests[5]);
      #20
      $finish();
    end
  	
  
endmodule
