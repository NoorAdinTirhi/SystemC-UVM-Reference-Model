`include "components/uvm/comp_decomp_env.sv"
`include "components/uvm/comp_decomp_sequence.sv"

class comp_decomp_test extends uvm_test;
    
    `uvm_component_utils(comp_decomp_test)

    comp_decomp_env env;
    comp_decomp_sequence seq;


    function new (string name = "comp_decomp_test", uvm_component parent=null);
        super.new(name,parent);
        `uvm_info(get_type_name(), "Creating test", UVM_NONE);
        // build_phase(uvm_build_phase::get());
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = comp_decomp_env::type_id::create("env", this);
        seq = comp_decomp_sequence::type_id::create("seq");
    endfunction : build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        print();
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
          seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask

    

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
    endfunction

endclass //comp_decomp_env extends uvm_tests