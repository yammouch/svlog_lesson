module tb_top;

reg din;

dut i_dut(.din(din), .dout());

initial begin
  din = 1'b1; #1;
  din = 1'bx; #1;
  $finish;
end

endmodule
