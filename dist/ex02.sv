class C00;
rand logic [1:0] val;
constraint c0 {
  val dist { [2'b00:2'b01] := 1
           , 2'b10         := 2
           , 2'b11         := 5 };
}
endclass

program ex02;
C00 c00;
int vals[];

initial begin
  c00 = new;
  vals = new[4];
  repeat (100) begin
    void'( c00.randomize() with { val dist { 2'b00 := 1
                                           , 2'b01 := 2
                                           , 2'b10 := 3
                                           , 2'b11 := 4 }; } );
    vals[c00.val] += 1;
  end
  for (int i = 0; i < 4; i += 1) $display(vals[i]);
end
endprogram
