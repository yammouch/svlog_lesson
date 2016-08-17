`timescale 1ns/1ps

module tb_top;

dut i_dut();

initial begin
  #1;
  for (int i = 0; i < 8; i++) begin
    i_dut.cov_sample(i, 0);
  end
  $finish;
end

endmodule
