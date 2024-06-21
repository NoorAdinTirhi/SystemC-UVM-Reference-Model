class comp_decomp_sequence extends uvm_sequence#(comp_decomp_seq_item);

    `uvm_object_utils(comp_decomp_sequence)

    function new(string name = "comp_decomp_sequence");
        super.new(name);
    endfunction

    `uvm_declare_p_sequencer(comp_decomp_sequencer)

    virtual task body();
      repeat(128) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
            req.randomize();
        	req.reset<=0;
            send_request(req);
            wait_for_item_done();
        end
   
  	//reset and run again
    req <= comp_decomp_seq_item::type_id::create("req");
    wait_for_grant();
    req.constraint_mode(0);
    req.randomize();
    req.reset<=1;
    send_request(req);
    wait_for_item_done();
  
      repeat(128) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
            req.randomize();
        	req.reset<=0;
            send_request(req);
            wait_for_item_done();
        end
    endtask
endclass


class decomp_after_comp_seq extends uvm_sequence#(comp_decomp_seq_item);

    `uvm_object_utils(decomp_after_comp_seq)

    function new(string name = "decomp_after_comp_seq");
        super.new(name);
    endfunction

    `uvm_declare_p_sequencer(comp_decomp_sequencer)

    virtual task body();
      //reset and run 
      req <= comp_decomp_seq_item::type_id::create("req");
      wait_for_grant();
      req.constraint_mode(0);
      req.randomize();
      req.reset<=1;
      send_request(req);
      wait_for_item_done();
      
      repeat(254) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
        	req.compression_only.constraint_mode(1);
            req.randomize();
        	req.reset <= 0;
            send_request(req);
            wait_for_item_done();
      end
     
      repeat(254) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
        	req.decompression_only.constraint_mode(1);
        	req.iterate_address.constraint_mode(1);
            req.randomize();
        	req.reset<=0;
            send_request(req);
            wait_for_item_done();
        end
    endtask

endclass

class  index_buffer_OF_seq extends uvm_sequence#(comp_decomp_seq_item);

    `uvm_object_utils(index_buffer_OF_seq)

    function new(string name = "index_buffer_OF_seq");
        super.new(name);
    endfunction

    `uvm_declare_p_sequencer(comp_decomp_sequencer)

    virtual task body();
      //reset and run 
      req <= comp_decomp_seq_item::type_id::create("req");
      wait_for_grant();
      req.constraint_mode(0);
      req.randomize();
      req.reset<=1;
      send_request(req);
      wait_for_item_done();
      //after 255 compressions, any extra compression should not be allowed
      // last txn does not get passed to scoreboard for some reason
      repeat(258) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
        	req.compression_only.constraint_mode(1);
        	req.new_data_in.constraint_mode(1);
            req.randomize();
        	req.reset <= 0;
            send_request(req);
            wait_for_item_done();
      end// further commands will produce errors, unless reset
      //try a small number of commandsit_for_item_done();
     
    endtask

endclass

class  invalid_decompression_sequence extends uvm_sequence#(comp_decomp_seq_item);

    `uvm_object_utils(invalid_decompression_sequence)

    function new(string name = "invalid_decompression_sequence");
        super.new(name);
    endfunction

    `uvm_declare_p_sequencer(comp_decomp_sequencer)

    virtual task body();
      //reset and run 
      req <= comp_decomp_seq_item::type_id::create("req");
      wait_for_grant();
      req.constraint_mode(0);
      req.reset<=1;
      send_request(req);
      wait_for_item_done();
      
      repeat(128) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
        	req.compression_only.constraint_mode(1);
        	req.new_data_in.constraint_mode(1);
            req.randomize();
        	req.reset <= 0;
            send_request(req);
            wait_for_item_done();
      end
      
      repeat(129) begin
        req <= comp_decomp_seq_item::type_id::create("req");
        wait_for_grant();
        req.constraint_mode(0);
        req.invalid_decompression.constraint_mode(1);
        req.randomize();
        req.reset = 0;
        send_request(req);
        wait_for_item_done();
      end
     
    endtask

endclass

class  data_in_zero_sequence extends uvm_sequence#(comp_decomp_seq_item);

    `uvm_object_utils(data_in_zero_sequence)

    function new(string name = "data_in_zero_sequence");
        super.new(name);
    endfunction

    `uvm_declare_p_sequencer(comp_decomp_sequencer)

    virtual task body();
      //reset and run 
      req <= comp_decomp_seq_item::type_id::create("req");
      wait_for_grant();
      req.constraint_mode(0);
      req.reset<=1;
      send_request(req);
      wait_for_item_done();
 
      
      repeat(74) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
        	req.compression_only.constraint_mode(1);
        	req.new_data_in.constraint_mode(1);
            req.randomize();
        	req.reset <= 0;
            send_request(req);
            wait_for_item_done();
      end
      
      req <= comp_decomp_seq_item::type_id::create("req");
      wait_for_grant();
      req.constraint_mode(0);
      req.compression_only.constraint_mode(1);
      req.data_in_zero.constraint_mode(1);
      req.randomize();
      req.reset <= 0;
      send_request(req);
      wait_for_item_done();
      
      repeat(53) begin
            req <= comp_decomp_seq_item::type_id::create("req");
            wait_for_grant();
        	req.constraint_mode(0);
        	req.compression_only.constraint_mode(1);
        	req.new_data_in.constraint_mode(1);
            req.randomize();
        	req.reset <= 0;
            send_request(req);
            wait_for_item_done();
      end
      
      repeat(129) begin
        req <= comp_decomp_seq_item::type_id::create("req");
        wait_for_grant();
        req.constraint_mode(0);
        req.valid_decompression.constraint_mode(1);
        req.randomize();
        req.reset = 0;
        send_request(req);
        wait_for_item_done();
      end
     
    endtask

endclass





