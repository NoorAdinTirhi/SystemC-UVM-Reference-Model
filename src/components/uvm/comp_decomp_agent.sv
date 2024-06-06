`include "components/uvm/comp_decomp_seq_item.sv"
`include "components/uvm/comp_decomp_sequencer.sv"
`include "components/uvm/comp_decomp_driver.sv"
`include "components/uvm/comp_decomp_monitor.sv"

class comp_decomp_agent extends uvm_agent;
    
    comp_decomp_driver driver;
    comp_decomp_sequencer sequencer;
    comp_decomp_monitor monitor;

    `uvm_component_utils(comp_decomp_agent)

    function new (string name, uvm_component parent);
        `uvm_info(get_type_name(), "Constructor", UVM_NONE)
        super.new(name, parent);
        build_phase(uvm_build_phase::get());
    endfunction: new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Build_phase", UVM_NONE)
        super.build_phase(phase);

        sequencer = comp_decomp_sequencer::type_id::create("sequencer", this);
        monitor = comp_decomp_monitor::type_id::create("monitor", this);
        driver = comp_decomp_driver::type_id::create("driver", this);
        connect_phase(uvm_connect_phase::get());
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Connect_Phase", UVM_NONE)
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass