`timescale 1ns/1ns

interface intf(input sig_i);

event kick;
time t_meas;

always @(kick) begin
  t_meas = $time;
  @(posedge sig_i) t_meas = $time - t_meas;
end

endinterface

module tb;

reg [1:0] sig;
virtual intf v_intf[1:0];

for (genvar i = 0; i < 2; i = i+1) begin: gen_intf
  intf i_intf(.sig_i(sig[i]));
  initial begin v_intf[i] = gen_intf[i].i_intf; end
end

initial begin
  sig = 2'b00;
  #1us;
  for (int i = 0; i < 2; i = i+1) -> v_intf[i].kick;
  #1us;
  sig = 2'b01;
  #1us;
  sig = 2'b11;
  #1us;
  for (int i = 0; i < 2; i = i+1) begin
    $display("v_intf[i].t_meas = %d", v_intf[i].t_meas);
  end

  #1; $finish;
end

endmodule
