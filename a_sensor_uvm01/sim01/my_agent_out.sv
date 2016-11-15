class my_agent_out extends uvm_agent;
  uvm_analysis_port #(my_packet) rcvr2sb_port;
  my_monitor mon;

  `uvm_component_utils(my_agent_out)

  function new(string name = "my_agent_out", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = my_monitor::type_id::create("mon", this);
  endfunction
endclass
