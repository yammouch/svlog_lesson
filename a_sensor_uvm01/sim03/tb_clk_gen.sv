`timescale 1ps/1ps

module tb_clk_gen(
 output reg clk,
 input      clk_en
);

integer period_hi;
integer period_lo;

initial begin
  period_hi = 500_000; // 500ns 1MHz
  period_lo = 500_000; // 500ns
  clk       = 1'b0;
end

always @(clk_en) begin
  while (clk_en == 1'b1) begin
    clk = 1'b1; #(period_hi);
    clk = 1'b0; #(period_lo);
  end
end

endmodule
