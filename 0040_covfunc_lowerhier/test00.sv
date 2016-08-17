// dummy testbench to which all duts are merged for coverage metrics.

`timescale 1ns/1ps

module tb_top;

dut  i_dut();
dut2 i_dut2();

initial begin
  $finish;
end

endmodule
