
class comp_decomp_scoreboard extends uvm_scoreboard;

    dut_ref_seq_item packet_queue[$];

  uvm_analysis_imp#(dut_ref_seq_item, comp_decomp_scoreboard) item_collected_export;
    `uvm_component_utils(comp_decomp_scoreboard);

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
    endfunction

    virtual function void write(dut_ref_seq_item pkt);
      packet_queue.push_back(pkt);
    endfunction : write

    virtual task run_phase(uvm_phase phase);
        dut_ref_seq_item pkt;
        forever begin
           wait(packet_queue.size() > 0);
          	pkt = packet_queue.pop_front();
          if (pkt.reset)begin
            `uvm_info(get_type_name(),$sformatf("------ :: RESET      :: ------"),UVM_LOW);
            if (pkt.ref_response != pkt.dut_response) begin
                    `uvm_error(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b%0b", pkt.dut_response, pkt.dut_response))
                end
          end else begin
            if (pkt.command == 2'b00)begin
                `uvm_info(get_type_name(),$sformatf("------ :: NOP      :: ------"),UVM_LOW);
              if (pkt.ref_response != pkt.dut_response) begin
                    `uvm_error(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b%0b", pkt.dut_response, pkt.dut_response))
                end

            end else if (pkt.command == 2'b01) begin
              `uvm_info(get_type_name(),$sformatf("------ ::  COMPRESSION  :: ------|| data_in = 0x%0h", {pkt.data_in_hi, pkt.data_in_lo}),UVM_LOW);
              
               if (pkt.dut_response != pkt.ref_response) begin
               	`uvm_error(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b%0b", pkt.dut_response, pkt.ref_response))
               end else if (pkt.dut_compressed_out != pkt.ref_compressed_out && pkt.dut_response == 2'b01) begin
                `uvm_error(get_type_name, $sformatf("INCORRECT COMPRESSION: %0d, EXCPECTED %0d", pkt.dut_compressed_out, pkt.ref_compressed_out))
              end
              	
              
            end else if (pkt.command == 2'b10) begin
              
              `uvm_info(get_type_name(),$sformatf("------ :: DECOMPRESSION :: ------|| compressed_in = %0d", pkt.compressed_in),UVM_LOW);
              
              
              if (pkt.dut_response != pkt.ref_response) begin
                `uvm_error(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b%0b", pkt.dut_response, pkt.ref_response))
                
              end else if ((pkt.dut_decompressed_out_lo != pkt.ref_decompressed_out_lo || pkt.dut_decompressed_out_hi != pkt.ref_decompressed_out_hi) && pkt.dut_response == 2'b10) begin
                `uvm_error(get_type_name, $sformatf("INCORRECT DECOMPRESSION:  0x%0h, EXCPECTED 0x%0h",{ pkt.dut_decompressed_out_hi,pkt.dut_decompressed_out_lo},{ pkt.ref_decompressed_out_hi,pkt.ref_decompressed_out_lo}))
              end
              
              
         

            end else if (pkt.command == 2'b11) begin
              if (pkt.dut_response != pkt.ref_response) begin
                    `uvm_error(get_type_name, $sformatf("INCORRECT RESPONSE:  0b%0b, EXCPECTED 0b11", pkt.dut_response))
                pkt.print();
                end
            end 
          
         	 if (pkt.ref_response == 'b11)
            	`uvm_warning(get_type_name, "REF RESPONSE IS ERROR")
          end
          	
       
        end  
    endtask


endclass
