// % amsenv a34 b75
// % irun +access+r ex02.sv
`timescale 1ns/1ns

program ex02;

reg       clk;
reg  [2:0] a_data;
wire [2:0] b_data;

clocking ccc @(posedge clk);
input  #1 a_data;
output #1 b_data;
endclocking

initial begin
  $shm_open("ex02.shm");
  $shm_probe(ex02, "ASCTMF");
  clk = 1'b0;
  a_data     = 3'd0;
  ccc.b_data <= 3'd7; #5;
  clk = 1'b1; #5;
  clk = 1'b0; #5;
  a_data     = 3'd1;
  ccc.b_data <= 3'd6;
  clk = 1'b1; #5;
  $finish;
end

endprogram
