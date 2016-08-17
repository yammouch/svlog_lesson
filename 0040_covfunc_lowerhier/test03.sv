`timescale 1ns/1ps

module tb_top;

dut  i_dut();
dut2 i_dut2();

initial begin
  #1;
  for (int i = 2; i < 8; i++) begin
    for (int j = 2; j < 8; j++) begin
      i_dut.cov_sample(i, j);
    end
  end
  for (int i = 0; i < 8; i++) begin
    i_dut2.cov_sample(i);
  end
  $finish;
end

endmodule
