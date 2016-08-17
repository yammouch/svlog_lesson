module tb;

reg [7:0] foo [16];
integer i;

initial begin
  //foo[0:3] = { 8'h30, 8'h31, 8'h32, 8'h33 };
  foo[0:3] = { 'h30, 'h31, 'h32, 'h33 };
  //foo[4:7] = { 32'h43424140 };

  for (i = 0; i < 8; i++)
    $display("%X", foo[i]);
  //$display("%s", foo);
end

endmodule
