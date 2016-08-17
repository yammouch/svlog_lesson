module tb;

reg [63:0] foo;

initial begin
  integer i;
  for (i = 0; i < 8; i++) begin
    foo[i*8+7:i*8] = 8'h30 + i;
  end
  display("%X", foo);
end

endmodule
