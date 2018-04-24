`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;
  my_agent      ag;
  my_scoreboard sbd;

  `uvm_component_utils(my_env)

  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag  = my_agent::type_id::create("ag", this);
    sbd = my_scoreboard::type_id::create("sbd", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ag.drv.drvr2sb_port.connect(sbd.drvr2sb_port);
    ag.mon.rcvr2sb_port.connect(sbd.rcvr2sb_port);
  endfunction
endclass
