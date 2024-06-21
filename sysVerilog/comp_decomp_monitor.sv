
class comp_decomp_monitor extends uvm_monitor;;
    
    virtual comp_if dut_if;
  	virtual comp_if ref_if;
  
  	

  	uvm_analysis_port#(dut_ref_seq_item) item_collected_port;

    dut_ref_seq_item collected;
  
  	covergroup coverage;
      
  	  option.per_instance = 1;
  	    
      command_cp : coverpoint collected.command{
        bins nop = {0};
        bins comp = {1};
        bins decomp = {2};
        bins err = {3};
      }
      
      compressed_in_cp : coverpoint collected.compressed_in{
        bins less_than_ir = {[0:127]};
        bins more_than_ir = {[128: 255]};
        bins gteq_zero = {[255: 74]};
      }
      
      data_in_cp : coverpoint {collected.data_in_hi, collected.data_in_lo, collected.command}{
        bins zero = {1};
      }
      
      decompression_compressed_in : cross compressed_in_cp, command_cp {
        bins compressed_in_cps = binsof(command_cp) intersect{2};
      }
      
      
  	endgroup
  
  
  
    `uvm_component_utils(comp_decomp_monitor)


    function new(string name = "comp_decomp_monitor", uvm_component parent);
        super.new(name, parent);
        collected = new();
      	coverage = new();
        item_collected_port = new("item_collected_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      	if(!uvm_config_db#(virtual comp_if)::get(this, "", "ref_if", ref_if))
            	`uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name()})
        if(!uvm_config_db#(virtual comp_if)::get(this, "", "dut_if", dut_if))
            	`uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name()})
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(posedge dut_if.clk);
          	#1;
            collected.data_in_lo = 			dut_if.data_in[63:0];
            collected.data_in_hi = 			dut_if.data_in[79:64];
            collected.compressed_in = 		dut_if.compressed_in;
            collected.reset = 				dut_if.reset;
            collected.command = 			dut_if.command;
          
          	coverage.sample();
          
            collected.dut_compressed_out = 		dut_if.compressed_out;
            collected.dut_decompressed_out_lo = dut_if.decompressed_out[63:0];
            collected.dut_decompressed_out_hi = dut_if.decompressed_out[79:64];
            collected.dut_response = 			dut_if.response;
          

			collected.ref_compressed_out = 		ref_if.compressed_out;
			collected.ref_decompressed_out_lo = ref_if.decompressed_out[63:0];
			collected.ref_decompressed_out_hi = ref_if.decompressed_out[79:64];
			collected.ref_response = 			ref_if.response;
          	
          
            item_collected_port.write(collected);
          
          	
        end
    endtask
endclass //comp_decomp_monitor extends uvm_monitor;