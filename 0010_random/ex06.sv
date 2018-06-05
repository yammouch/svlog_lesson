class c00;

  rand logic tg_not_sa;
  rand real a, b;

  constraint c1 {
    tg_not_sa  -> -1.3 <= a && a <= -1.1 && 1.1 <= b && b <= 1.3;
    !tg_not_sa -> a == 0.0               && 2.3 <= b && b <= 2.5;
    solve tg_not_sa before a;
    solve tg_not_sa before b;
  }

endclass

module ex06;

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
