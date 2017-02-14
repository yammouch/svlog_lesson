`timescale 1ns/1ns

module checker(input [1:0] sig_i);

event kick[1:0];
time t_meas[1:0];

for (genvar i = 0; i < 2; i = i+1) begin
  always @(kick[i]) begin
    t_meas[i] = $time;
    @(posedge sig_i[i]) t_meas[i] = $time - t_meas[i];
  end
end

endmodule


module tb;

reg [1:0] sig;

checker i_checker(.sig_i(sig));

initial begin
  sig = 2'b00;
  #1us;
  for (int i = 0; i < 2; i = i+1) -> i_checker.kick[i];
  #1us;
  sig = 2'b01;
  #1us;
  sig = 2'b11;
  #1us;
  for (int i = 0; i < 2; i = i+1) begin
    $display("i_checker.t_meas[i] = %d", i_checker.t_meas[i]);
  end

  #1; $finish;
end

endmodule
