module ex04;

  real val;

  initial begin
    val = urandom_range_real(-1.0, 1.0);
    $display(val);
  end

endmodule
