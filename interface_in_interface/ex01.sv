interface i0(
 input  din,
 output dout
);
assign dout = ~din;
endinterface

interface i1;
reg d_in;
wire d_out;
i0 i_i0 (.din(d_in), .dout(d_out));
endinterface

interface i2;
i1 i_i1 ();
initial begin
  i_i1.d_in = 1'b0; #1ms;
  i_i1.d_in = 1'b1; #1ms;
end
endinterface
