module pbus(input [31:0] DIN);

event ev;
reg [31:0] received [];

task burst_read(input [31:0] n);
begin
  $display("N = %d.", n);
  received.delete();
  repeat (n) begin
    $display("DIN = %08X", DIN);
    @(ev) received.push_back(DIN);
  end
end
endtask

endmodule


module tb;

reg [31:0] DIN;

pbus pbus(.DIN(DIN));

integer i;

initial begin
  $display("Beginning."); #10ns;
  fork
    pbus.burst_read(4);
    begin
      #10ns DIN = 32'd1; #10ns -> pbus.ev;
      #10ns DIN = 32'd2; #10ns -> pbus.ev;
      #10ns DIN = 32'd3; #10ns -> pbus.ev;
      #10ns DIN = 32'd4; #10ns -> pbus.ev;
    end
  join
  for (i = 0; i < 4; i = i+1)
    $display("i: %d  received: %08X", i, pbus.received[i]);
  $finish;
end

endmodule
