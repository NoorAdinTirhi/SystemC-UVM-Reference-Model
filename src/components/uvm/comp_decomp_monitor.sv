
class comp_decomp_monitor extends uvm_monitor;;
    
    virtual comp_if vif;

    uvm_analysis_port#(comp_decomp_seq_item) item_collected_port;

    comp_decomp_seq_item collected;
    `uvm_component_utils(comp_decomp_monitor)


    function new(string name = "comp_decomp_monitor", uvm_component parent);
        super.new(name, parent);
        collected = new();
        item_collected_port = new("item_collected_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(comp_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name()})
    endfunction

    virtual task run_phase(uvm_phase);
        forever begin
            @(posedge vif.clk);
            collected.data_in = vif.data_in;
            collected.compressed_in = vif.compressed_in;
            collected.compressed_out = vif.compressed_out;
            collected.decompressed_out = vif.decompressed_out;
            collected.command = vif.command;
            collected.response = vif.response;
            collected.reset = vif.reset;
            item_collected_port.write(collected);
        end
    endtask
endclass //comp_decomp_monitor extends uvm_monitor;