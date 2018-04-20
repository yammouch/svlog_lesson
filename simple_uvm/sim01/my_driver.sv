`include "uvm_macros.svh"
import uvm_pkg::*;

class my_driver extends uvm_driver #(my_packet);
  uvm_analysis_port #(my_packet) drvr2sb_port;
  virtual my_dut_if vif;

  `uvm_component_utils(my_driver)

  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drvr2sb_port = new("drvr2sb_port", this);
    if(!uvm_config_db#(virtual my_dut_if)::get(this, "", "vif", vif))
      uvm_report_fatal( "NOVIF", { "virtual interface must be set for:"
                                 , get_full_name(), ".vif" });
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    do begin
      seq_item_port.get_next_item(req);
      @(posedge vif.clk);
      vif.operand_a  <= req.operand_a;
      vif.operand_b  <= req.operand_b;
      vif.data_in_en <= 1'b1;
      drvr2sb_port.write(req);
      seq_item_port.item_done();
      @(posedge vif.clk); vif.data_in_en <= 1'b0;
      @(posedge vif.clk);
    end while(seq_item_port.has_do_available());

    phase.drop_objection(this);
  endtask

endclass
