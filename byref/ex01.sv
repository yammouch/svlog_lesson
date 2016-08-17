module ex01;

//task automatic t1(ref logic sig, input frc);
task t1(ref logic sig, input frc);
  //if (frc) force sig = 1'b1;
  //else     release sig;
  $display(sig);
endtask

reg  a;
wire b;

assign b = ~a;

initial begin
  $dumpfile("ex01.vcd");
  $dumpvars;
  #1ms a = 1'b1;
  #1ms t1(b, 1'b1);
  #1ms t1(b, 1'b0);
  #1ms a = 1'b0;
  #1ms $finish;
end

endmodule
