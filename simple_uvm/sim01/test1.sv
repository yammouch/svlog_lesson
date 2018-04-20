`include "uvm_macros.svh"
import uvm_pkg::*;

class test1 extends uvm_test;
  my_env t_env;
  virtual my_dut_if vif;
  my_sequence seq;

  `uvm_component_utils(test1)

  function new(string name = "test1", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t_env = my_env::type_id::create("t_env", this);
    if (!uvm_config_db#(virtual my_dut_if)::get(this, "", "vif", vif))
      uvm_report_fatal( "NOVIF", { "virtual interface must be set for:"
                                 , get_full_name(), ".vif" });
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = my_sequence::type_id::create("seq", this);
    repeat (8) @(posedge vif.clk);
    seq.start(t_env.agi.seqr);

    phase.drop_objection(this);
  endtask
endclass
