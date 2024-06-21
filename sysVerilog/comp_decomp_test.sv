`include "comp_decomp_seq_item.sv"
`include "comp_decomp_env.sv"
`include "comp_decomp_sequence.sv"

class parent_test extends uvm_test;
    
    `uvm_component_utils(parent_test)

    comp_decomp_env env;
    


    function new (string name = "parent_test", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = comp_decomp_env::type_id::create("env", this);
    endfunction : build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        print();
    endfunction    

    function void report_phase(uvm_phase phase);
        uvm_report_server svr;

        super.report_phase(phase);

        svr = uvm_report_server::get_server();

        if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
            `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
            `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
            `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        end else begin   
            `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
            `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
            `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        end
      
      `uvm_info(get_type_name(), $sformatf("Coverage Percentage : %0.2f%% ",env.agent.monitor.coverage.get_inst_coverage()), UVM_NONE)
    endfunction

endclass 


class pseudo_random_test extends parent_test;
  
  	`uvm_component_utils(pseudo_random_test)
  	comp_decomp_sequence seq;
  
 	function new (string name = "pseudo_random_test", uvm_component parent=null);
       	super.new(name,parent);
    endfunction
 
  	virtual function void build_phase(uvm_phase phase);
       	super.build_phase(phase);
       	seq = comp_decomp_sequence::type_id::create("seq");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
          seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
  
endclass

class decomp_after_comp_test extends parent_test;
  
  	`uvm_component_utils(decomp_after_comp_test)
  	decomp_after_comp_seq seq;
  
 	function new (string name = "decomp_after_comp_test", uvm_component parent=null);
       	super.new(name,parent);
    endfunction
 
  	virtual function void build_phase(uvm_phase phase);
       	super.build_phase(phase);
      	seq = decomp_after_comp_seq::type_id::create("decomp_after_comp_seq");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
          seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
  
endclass

class index_buffer_OF_test extends parent_test;
  
  	`uvm_component_utils(index_buffer_OF_test)
  	index_buffer_OF_seq seq;
  
 	function new (string name = "index_buffer_OF_test", uvm_component parent=null);
       	super.new(name,parent);
    endfunction
 
  	virtual function void build_phase(uvm_phase phase);
       	super.build_phase(phase);
      	seq = index_buffer_OF_seq::type_id::create("index_buffer_OF_seq");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
          seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
  
endclass

class invalid_decompression_test extends parent_test;
  
  	`uvm_component_utils(invalid_decompression_test)
  	invalid_decompression_sequence seq;
  
 	function new (string name = "invalid_decompression_test", uvm_component parent=null);
       	super.new(name,parent);
    endfunction
 
  	virtual function void build_phase(uvm_phase phase);
       	super.build_phase(phase);
      	seq = invalid_decompression_sequence::type_id::create("invalid_decompression_sequence");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
          seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
  
endclass

class data_in_zero_test extends parent_test;
  
  	`uvm_component_utils(data_in_zero_test)
  	data_in_zero_sequence seq;
  
 	function new (string name = "data_in_zero_test", uvm_component parent=null);
       	super.new(name,parent);
    endfunction
 
  	virtual function void build_phase(uvm_phase phase);
       	super.build_phase(phase);
      	seq = data_in_zero_sequence::type_id::create("data_in_zero_sequence");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
          seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
  
endclass

class all_comb_test extends parent_test;
  
  	`uvm_component_utils(all_comb_test)
  	comp_decomp_sequence c1;
  	decomp_after_comp_seq c2;
  	index_buffer_OF_seq c3;
  	invalid_decompression_sequence c4;
  	data_in_zero_sequence c5;
  
 	function new (string name = "all_comb_test", uvm_component parent=null);
       	super.new(name,parent);
    endfunction
 
  	virtual function void build_phase(uvm_phase phase);
       	super.build_phase(phase);
      	c1 = comp_decomp_sequence::type_id::create("comp_decomp_sequence");
      	c2 = decomp_after_comp_seq::type_id::create("decomp_after_comp_seq");
      	c3 = index_buffer_OF_seq::type_id::create("index_buffer_OF_seq");
      	c4 = invalid_decompression_sequence::type_id::create("invalid_decompression_sequence");
      	c5 = data_in_zero_sequence::type_id::create("data_in_zero_sequence");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
      
        phase.raise_objection(this);
          c1.start(env.agent.sequencer);
      
          c2.start(env.agent.sequencer);
      
          c3.start(env.agent.sequencer);
      
          c4.start(env.agent.sequencer);
      
          c5.start(env.agent.sequencer);
        phase.drop_objection(this);
      
    endtask
  
endclass