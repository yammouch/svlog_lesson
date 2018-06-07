module clog2;

  integer val;

  initial begin
    for (val = 1; val <= 5; val = val+1) begin
      $display("$clog2(%d) = %d", val, $clog2(val));
    end
  end

endmodule
