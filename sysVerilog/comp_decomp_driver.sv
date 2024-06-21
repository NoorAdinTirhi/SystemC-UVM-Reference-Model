
class comp_decomp_driver extends uvm_driver#(comp_decomp_seq_item);


    virtual comp_if dut_if;
  	virtual comp_if ref_if;
    `uvm_component_utils(comp_decomp_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      if(!uvm_config_db#(virtual comp_if)::get(this, "", "dut_if", dut_if))
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name()})
      if(!uvm_config_db#(virtual comp_if)::get(this, "", "ref_if", ref_if))
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
      @(posedge dut_if.clk);
      
        dut_if.data_in = {req.data_in_hi, req.data_in_lo};
        dut_if.compressed_in = req.compressed_in;
        dut_if.reset = req.reset;
        dut_if.command = req.command;
      
      	ref_if.data_in = {req.data_in_hi, req.data_in_lo};
      	ref_if.compressed_in = req.compressed_in;
      	ref_if.reset = req.reset;
      	ref_if.command = req.command;
      
    endtask
        
endclass