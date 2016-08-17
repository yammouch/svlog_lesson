module tb;

reg [63:0] foo;
//reg [ 7:0] bar [0:7];
reg [5:0] bar00;

initial begin
  foo = "abc";
  $display("%X", foo);
  //bar = "ABC";
  //$display("%X", bar);
  bar00 = "a";
  $display("%X", bar00);
end

endmodule
