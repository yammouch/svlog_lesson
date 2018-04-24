`include "uvm_macros.svh"
import uvm_pkg::*;

class my_subscriber extends uvm_subscriber #(my_packet);

  `uvm_component_utils(my_subscriber)

  logic [2:0] operand_a;
  logic [2:0] operand_b;

  covergroup operand_cov;
    OP1: coverpoint operand_a {
     ignore_bins ig = {7};
    }
    OP2: coverpoint operand_b;
    CRS: cross OP1, OP2;
  endgroup

  function new(string name = "my_subscriber", uvm_component parent = null);
    super.new(name, parent);
    operand_cov = new();
  endfunction

  function void write(my_packet t);
    operand_a = t.operand_a;
    operand_b = t.operand_b;
    operand_cov.sample();
  endfunction

endclass
