interface i00;
  reg foo = 1'b0;
endinterface

module m00;
  i00 i00_0();
  initial begin
    $display(i00_0.foo);
  end
endmodule
