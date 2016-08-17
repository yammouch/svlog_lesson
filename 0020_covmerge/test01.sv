`timescale 1ns/1ps

module tb_top;

reg din;

dut i_dut(.din(din), .dout());

initial begin
  din = 1'b0; #1
  din = 1'bx; #1
  $finish;
end

endmodule
