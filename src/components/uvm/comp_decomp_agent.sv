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
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor = comp_decomp_monitor::type_id::create("monitor", this);
        driver = comp_decomp_driver::type_id::create("driver", this);
        sequencer = comp_decomp_sequencer::type_id::create("sequencer", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        
    endfunction

endclass