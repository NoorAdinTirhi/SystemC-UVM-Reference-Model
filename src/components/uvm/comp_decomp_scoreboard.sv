
class comp_decomp_scoreboard extends uvm_scoreboard;

    comp_decomp_seq_item packet_queue[$];

    uvm_analysis_imp#(comp_decomp_seq_item, comp_decomp_scoreboard) item_collected_export;
    `uvm_component_utils(comp_decomp_scoreboard);

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
    endfunction

    virtual function void write(comp_decomp_seq_item pkt);
        pkt.print();
        pkt_qu.push_back(pkt);
    endfunction : write

    virtual task run_phase(uvm_phase phase);
        comp_decomp_seq_item pkt;
        forever begin
            wait(packet_queue.size() > 0);
            pkt = packet_queue.pop_front();

            if (pkt.command == 2'b00)begin
                `uvm_info(get_type_name(),$sformatf("------ :: NOP      :: ------"),UVM_LOW);
                if (pkt.response != getResponse()) begin
                    `uvm_warning(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b00", pkt.response))
                end

            end else if (pkt.command == 2'b01) begin
                `uvm_info(get_type_name(),$sformatf("------ ::  COMPRESSION  :: ------"),UVM_LOW);
                if (pkt.response != getResponse()) begin
                    `uvm_warning(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b01", pkt.response))
                end
                if (pkt.compressed_out != getCompressed_out()) begin
                    `uvm_warning(get_type_name, $sformatf("INCORRECT COMPRESSION: 0b%0b, EXCPECTED 0b%0b", pkt.compressed_out, getCompressed_out()))
                end

            end else if (pkt.command == 2'b10) begin
                `uvm_info(get_type_name(),$sformatf("------ :: DECOMPRESSION :: ------"),UVM_LOW);
                if (pkt.response != getResponse()) begin
                    `uvm_warning(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b10", pkt.response))
                end
                if (pkt.decompressed_out != getDecompressed_out()) begin
                    `uvm_warning(get_type_name, $sformatf("INCORRECT COMPRESSION:  0x%0h, EXCPECTED 0x%0h", pkt.decompressed_out, getDecompressed_out()))
                end

            end else if (pkt.command == 2'b11) begin
                if (pkt.response != getResponse()) begin
                    `uvm_warning(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b11", pkt.response))
                end
            end
        end  
    endtask

    function bit check_ref();
        
    endfunction


endclass
