

class comp_decomp_sequencer extends uvm_sequencer#(comp_decomp_seq_item, comp_decomp_seq_item);
    `uvm_component_utils(comp_decomp_sequencer)

    function new(string name = "comp_decomp_sequencer", uvm_component parent);
        `uvm_info(get_type_name(), "Constructor", UVM_NONE)
        super.new(name, parent);
    endfunction
endclass