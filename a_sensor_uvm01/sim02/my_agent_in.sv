`include "uvm_macros.svh"
import uvm_pkg::*;

class my_agent_in extends uvm_agent;
  my_driver    drv;
  my_sequencer seqr;

  `uvm_component_utils(my_agent_in)

  function new(string name = "my_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = my_driver::type_id::create("drv", this);
    seqr = my_sequencer::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
