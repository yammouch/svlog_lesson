`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequence extends uvm_sequence #(my_packet);
  my_packet pkt;

  `uvm_sequence_utils(my_sequence, my_sequencer)

  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  task body();
    repeat (16) begin
      pkt = my_packet::type_id::create("pkt");
      wait_for_grant();
      void'(pkt.randomize());
      send_request(pkt);
      wait_for_item_done();
    end
  endtask
endclass
