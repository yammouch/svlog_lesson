`include "uvm_macros.svh"
import uvm_pkg::*;

class my_monitor extends uvm_monitor;
  virtual my_dut_if vif;
  uvm_analysis_port #(my_packet) rcvr2sb_port;
  my_packet pkt;

  `uvm_component_utils(my_monitor)

  function new(string name = "my_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // *::type_id::create does not pass compile.
    //rcvr2sb_port = uvm_analysis_port#(my_packet)::type_id::create(
    // "rcvr2sb_port", this);
    rcvr2sb_port = new("rcvr2sb_port", this);
    if (!uvm_config_db#(virtual my_dut_if)::get(this, "", "vif", vif))
      uvm_report_fatal( "NOVIF", { "virtual interface must be set for:"
                                 , get_full_name(), ".vif" });
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      repeat (64*64) @(negedge vif.data_out_valid);
      pkt = new(); pkt.sense_value = 1.0 * $signed(vif.data_out) / (1 << 15);
      rcvr2sb_port.write(pkt);
    end
  endtask
endclass
