`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;
  my_agent_in   agi;
  my_agent_out  ago;
  my_scoreboard sbd;

  `uvm_component_utils(my_env)

  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agi = my_agent_in::type_id::create("agi", this);
    ago = my_agent_out::type_id::create("ago", this);
    sbd = my_scoreboard::type_id::create("sbd", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agi.drv.drvr2sb_port.connect(sbd.drvr2sb_port);
    ago.mon.rcvr2sb_port.connect(sbd.rcvr2sb_port);
  endfunction
endclass
