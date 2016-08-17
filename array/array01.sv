module tb;

logic [15:0] ar [];
int i;

initial begin
  i = 255;
  $display("%X", i[2:1]);
  $display(ar.size());
  ar = new[4];
  $display(ar.size());
  ar = { {7'h01, 9'h101}, 16'h0002, 16'h0003, 16'h0004 };
  for (i = 0; i < ar.size(); i++)
    $display("%X", ar[i]);
  ar[1][2:0] = ~0;
  for (i = 0; i < ar.size(); i++)
    $display("%X", ar[i]);
  $display(ar.size());
  $finish;
end

endmodule
