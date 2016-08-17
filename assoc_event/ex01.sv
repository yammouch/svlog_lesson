module ex01;

event ea[string];
event e1;

always @(ea["FOO"])
  $display("FOO");

always @(e1)
  $display("e1");

initial begin
  -> ea["FOO"];
  -> e1;
  #1ms;
  $finish;
end

endmodule
