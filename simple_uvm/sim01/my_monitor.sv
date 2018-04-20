`include "uvm_macros.svh"
import uvm_pkg::*;

class my_monitor extends uvm_monitor;
  virtual my_dut_if vif;
  uvm_analysis_port #(my_packet) rcvr2sb_port;

  `uvm_component_utils(my_monitor)

  function new(string name = "my_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rcvr2sb_port = new("rcvr2sb_port", this);
    if (!uvm_config_db#(virtual my_dut_if)::get(this, "", "vif", vif))
      uvm_report_fatal( "NOVIF", { "virtual interface must be set for:"
                                 , get_full_name(), ".vif" });
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(negedge vif.clk);
      if (vif.data_out_en) begin
        my_packet pkt;
        pkt = new();
        pkt.sum = vif.sum;
        rcvr2sb_port.write(pkt);
      end
    end
  endtask
endclass
