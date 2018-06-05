class c00;

  rand real a, b;

  //constraint c1 {
  //  (-1.3 <= a && a <= -1.1) || a == 0.0;
  //  
  //}
  //constraint c1 {
  //  a == 0.0               && 2.3 <= b && b <= 2.5 ||
  //  -1.3 <= a && a <= -1.1 && 1.1 <= b && b <= 1.3;
  //}
  constraint c1 {
    -1.3 <= a && a <= -1.1 || a == 0.0;
    //a inside {0.0, [-1.3:-1-1]};
    if (a < -0.6) 1.1 <= b && b <= 1.3;
    else          2.3 <= b && b <= 2.5;
    solve a before b;
  }

endclass

module ex05;

  c00 i_c00;

  initial begin
    i_c00 = new();
    
    repeat (20) begin
      if (!i_c00.randomize()) begin
        $display("i_c00.randomize() failed.");
      end
      $display("%f %f", i_c00.a, i_c00.b);
    end
  end

endmodule
