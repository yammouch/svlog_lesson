module ex01;

logic rhs, lhs, cond;

initial begin

  cond = 1'b0;
  rhs = 1'bz;
  lhs = (cond == 1'b1) ? 1'b1 : rhs;
  $display(lhs);

end

endmodule
