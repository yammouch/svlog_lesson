`timescale 1ns/1ps

module ex01;
initial begin
  fork : escape
    repeat (10) begin
      #100 $display("thread A: %d", $time);
    end
    begin
      #550 $display("thread B: %d", $time);
      disable escape;
    end
  join
end
endmodule
