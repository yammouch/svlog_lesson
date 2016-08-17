module ex01;

reg   re;
wire  wi;
logic lo;

assign wi = re;

initial begin
  $deposit(re, 1'b1);
  $display(re, wi, lo);
  re = 1'b0;
  $display(re, wi, lo);
  re = 1'b1;
  $display(re, wi, lo);
  re = 1'b0;
  $display(re, wi, lo);

  $deposit(wi, 1'b1);
  $display(re, wi, lo);
  re = 1'b0;
  $display(re, wi, lo);
  re = 1'b1;
  $display(re, wi, lo);
  re = 1'b0;
  $display(re, wi, lo);
end

endmodule
