interface tb_clk_gen(
 output reg clk
);

reg en;

time period_hi;
time period_lo;

initial begin
  period_hi = 500ns; // 1MHz
  period_lo = 500ns;
  clk       = 1'b0;
end

always @(en) begin
  while (en == 1'b1) begin
    clk = 1'b1; #(period_hi);
    clk = 1'b0; #(period_lo);
  end
end

endinterface
