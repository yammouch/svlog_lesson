module dut(din, dout);

input  din;
output dout;
reg    dout;

always @* begin
  if      (din == 1'b0) dout = 1'b1;
  else if (din == 1'b1) dout = 1'b0;
  else                  dout = 1'bx;
end

endmodule
