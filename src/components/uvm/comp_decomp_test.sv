`include "components/uvm/comp_decomp_env.sv"

class comp_decomp_test extends uvm_test;
    
    `uvm_component_utils(comp_decomp_test)

    comp_decomp_env env;


    

    virtual function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "build_phase", UVM_NONE)
        super.build_phase(phase);
        env = comp_decomp_env::type_id::create("env", this);
    endfunction : build_phase

    function new (string name = "comp_decomp_test", uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(), "Constructor", UVM_NONE)
        build_phase(uvm_build_phase::get());
    endfunction

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
    endfunction

endclass //comp_decomp_env extends uvm_tests