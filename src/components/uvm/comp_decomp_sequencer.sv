

class comp_decomp_sequencer extends uvm_sequencer#(comp_decomp_seq_item,comp_decomp_seq_item);
    `uvm_component_utils(comp_decomp_sequencer)

    function new(string name = "comp_decomp_sequencer", uvm_component parent);
        super.new(name, parent);
        // super.build_phase(uvm_build_phase::get());
    endfunction
endclass