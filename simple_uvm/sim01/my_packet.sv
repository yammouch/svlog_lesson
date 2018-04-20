`include "uvm_macros.svh"
import uvm_pkg::*;

class my_packet extends uvm_sequence_item;
  rand logic [2:0] operand_a;
  rand logic [2:0] operand_b;
       logic [3:0] sum;

  `uvm_object_utils(my_packet)

  constraint input_range { operand_a <= 3'd6; }

  function void post_randomize();
    sum = {1'd0, operand_a} + {1'd0, operand_b};
  endfunction
endclass
