module ex02;

  logic d0;

  property p0;
    @(d0) d0 == 1'b1;
  endproperty

  assert property (p0);

  initial begin
    d0 = 1'b0; #1ms;
    d0 = 1'b1; #1ms;
    d0 = 1'b0; #1ms;
    d0 = 1'b1; #1ms;
  end

endmodule
