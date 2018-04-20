`include "uvm_macros.svh"
import uvm_pkg::*;

module top;

  my_dut_if my_dut_if();

  dut my_dut(
   .clk         (my_dut_if.clk),
   .rstx        (my_dut_if.rstx),
   .operand_a   (my_dut_if.operand_a),
   .operand_b   (my_dut_if.operand_b),
   .data_in_en  (my_dut_if.data_in_en),
   .sum         (my_dut_if.sum),
   .data_out_en (my_dut_if.data_out_en)
  );

  initial begin
    uvm_config_db#(virtual my_dut_if)::set
    ( uvm_root::get(), "*", "vif", my_dut_if);

    run_test();
  end

endmodule
