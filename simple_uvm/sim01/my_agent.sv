`include "uvm_macros.svh"
import uvm_pkg::*;

class my_agent extends uvm_agent;
  my_driver    drv;
  my_sequencer seqr;
  uvm_analysis_port #(my_packet) rcvr2sb_port;
  my_monitor mon;

  `uvm_component_utils(my_agent)

  function new(string name = "my_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = my_driver::type_id::create("drv", this);
    mon  = my_monitor::type_id::create("mon", this);
    seqr = my_sequencer::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
