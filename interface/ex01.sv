// > source /tools/.ius132isr12rc
// > irun +access+r -input ex01.tcl ex01.sv

interface m01_m02;
reg  s_a;
wire s_b;
endinterface

module m01 (sig);
m01_m02 sig;

initial begin
  sig.s_a = 1'b0;
  #1s;
  sig.s_a = 1'b1;
  #1s;
  sig.s_a = 1'b0;
end

endmodule

module m02 (sig);
m01_m02 sig;

assign sig.s_b = ~sig.s_a;

endmodule

module tb;

m01_m02 ssss();

m01 i01(.sig(ssss));
m02 i02(.sig(ssss));

initial begin
  #3s;
  $finish;
end

endmodule
