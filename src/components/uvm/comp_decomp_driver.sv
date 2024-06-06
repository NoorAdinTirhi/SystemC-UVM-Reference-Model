
class comp_decomp_driver extends uvm_driver#(comp_decomp_seq_item);


    virtual comp_if vif;
    `uvm_component_utils(comp_decomp_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        // build_phase(uvm_build_phase::get());
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual comp_if)::get(this, "", "cd1_if", vif))
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name()})
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.item_done();
        end
    endtask: run_phase


    virtual task drive();
        @(posedge vif.clk);
        vif.data_in = {req.data_in_hi, req.data_in_lo};
        vif.compressed_in = req.compressed_in;
        vif.reset = req.reset;
        vif.command = req.command;
    endtask
        
endclass