class comp_decomp_sequence extends uvm_sequence#(comp_decomp_seq_item);

    `uvm_object_utils(comp_decomp_sequence)

    function new(string name = "comp_decomp_sequence");
        super.new(name);
    endfunction

    `uvm_declare_p_sequencer(comp_decomp_sequencer)

    virtual task body();
        repeat(10) begin
            comp_decomp_seq_item item;
            req = comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
            req.randomize();
            send_request(req);
            wait_for_item_done();
        end
    endtask

endclass