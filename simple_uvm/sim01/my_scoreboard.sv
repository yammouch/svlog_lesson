`include "uvm_macros.svh"
import uvm_pkg::*;

class my_scoreboard extends uvm_scoreboard;
  `uvm_analysis_imp_decl(_rcvd_pkt)
  `uvm_analysis_imp_decl(_sent_pkt)

  my_packet que_rcvd[$];
  my_packet que_sent[$];

  uvm_analysis_imp_rcvd_pkt #(my_packet, my_scoreboard) rcvr2sb_port;
  uvm_analysis_imp_sent_pkt #(my_packet, my_scoreboard) drvr2sb_port;

  `uvm_component_utils(my_scoreboard)

  function new(string name = "my_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    rcvr2sb_port = new("rcvr2sb_port", this);
    drvr2sb_port = new("drvr2sb_port", this);
  endfunction

  function void write_rcvd_pkt(input my_packet pkt);
    que_rcvd.push_back(pkt);
  endfunction

  function void write_sent_pkt(input my_packet pkt);
    que_sent.push_back(pkt);
  endfunction

  function void check;
    if (que_sent.size != que_rcvd.size) begin
      uvm_report_error("LENNMT",
        $sformatf( "Lengthes differ in %s, sent: %d, received: %d"
                 , get_full_name(), que_sent.size, que_rcvd.size) );
    end else begin
      for (int i = 0; i < que_sent.size; i = i+1) begin
        if (que_sent[i].sum != que_rcvd[i].sum) begin
          uvm_report_error("VALNMT",
            $sformatf(
             "Values differ in %s, sent: %d + %d = %d, received: %d"
             , get_full_name(), que_sent[i].operand_a, que_sent[i].operand_b
             , que_sent[i].sum, que_rcvd[i].sum) );
        end
      end
    end
  endfunction
endclass
