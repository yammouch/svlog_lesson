`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequence_ramp extends uvm_sequence #(my_packet);
  my_packet pkt;
  real sense_value;

  `uvm_sequence_utils(my_sequence_ramp, my_sequencer)

  function new(string name = "my_sequence_ramp");
    super.new(name);
  endfunction

  task body();
    for (sense_value = -1.0; sense_value <= 1.0; sense_value += 0.2) begin
      pkt = my_packet::type_id::create("pkt");
      wait_for_grant();
      pkt.sense_value = sense_value;
      send_request(pkt);
      wait_for_item_done();
    end
  endtask
endclass
