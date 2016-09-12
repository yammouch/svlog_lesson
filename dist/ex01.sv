class C00;
rand logic [1:0] val;
constraint c0 {
  val dist { [2'b00:2'b01] := 1
           , 2'b10         := 2
           , 2'b11         := 5 };
}
endclass

class C01;
rand logic [1:0] val;
constraint c0 {
  val dist { [2'b00:2'b01] :/ 1
           , 2'b10         := 2
           , 2'b11         := 5 };
}
endclass

program ex01;
C00 c00;
C01 c01;
int vals[];

initial begin
  c00 = new;
  vals = new[4];
  repeat (100) begin
    void'(c00.randomize());
    vals[c00.val] += 1;
  end
  for (int i = 0; i < 4; i += 1) $display(vals[i]);

  c01 = new;
  vals = new[4];
  repeat (100) begin
    void'(c01.randomize());
    vals[c01.val] += 1;
  end
  for (int i = 0; i < 4; i += 1) $display(vals[i]);
end
endprogram
