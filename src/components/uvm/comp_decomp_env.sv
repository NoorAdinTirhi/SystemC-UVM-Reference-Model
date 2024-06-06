`include "components/uvm/comp_decomp_agent.sv"
`include "components/uvm/comp_decomp_scoreboard.sv"

class comp_decomp_env extends uvm_env;

    comp_decomp_agent agent;
    comp_decomp_scoreboard scb;

    `uvm_component_utils(comp_decomp_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        // build_phase(uvm_build_phase::get());
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = comp_decomp_agent::type_id::create("agent", this);
        scb = comp_decomp_scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.item_collected_port.connect(scb.item_collected_export);
    endfunction

endclass //comp_decomp_env extends uvm_env