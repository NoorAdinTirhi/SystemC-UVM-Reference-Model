class comp_decomp_sequence extends uvm_sequence#(comp_decomp_seq_item);

    `uvm_object_utils(comp_decomp_sequence)

    function new(string name = "comp_decomp_sequence");
        super.new(name);
    endfunction

    `uvm_declare_p_sequencer(comp_decomp_sequencer)

    virtual task body();
        repeat(10) begin
            comp_decomp_seq_item item;
            packet = comp_decomp_seq_item::type_id::create("packet");
            wait_for_grant();
            packet.randomize();
            send_request(packet);
            wait_for_item_done();
        end
    endtask

endclass