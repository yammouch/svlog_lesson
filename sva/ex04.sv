module ex02;

  logic rstx0, rstx1;
  logic d0;

  property p0;
    @(rstx0 or rstx1 or d0) disable iff (!rstx0 || !rstx1) d0;
  endproperty

  assert property (p0);

  initial begin
    {rstx0, rstx1, d0} = 3'b000; #1ms;
    {rstx0, rstx1, d0} = 3'b010; #1ms;
    {rstx0, rstx1, d0} = 3'b000; #1ms;
    {rstx0, rstx1, d0} = 3'b100; #1ms;
    {rstx0, rstx1, d0} = 3'b000; #1ms;
    {rstx0, rstx1, d0} = 3'b100; #1ms;
    {rstx0, rstx1, d0} = 3'b110; #1ms;
    {rstx0, rstx1, d0} = 3'b100; #1ms;
    {rstx0, rstx1, d0} = 3'b101; #1ms;
    {rstx0, rstx1, d0} = 3'b111; #1ms;
    {rstx0, rstx1, d0} = 3'b101; #1ms;
    {rstx0, rstx1, d0} = 3'b111; #1ms;
    {rstx0, rstx1, d0} = 3'b110; #1ms;
    {rstx0, rstx1, d0} = 3'b111; #1ms;
    {rstx0, rstx1, d0} = 3'b101; #1ms;
  end

endmodule
