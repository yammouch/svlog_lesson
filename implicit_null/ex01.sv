class Ccc;
endclass

module ex01;

  function automatic Ccc fn(int i);
    Ccc ccc = new;
    if (i > 0) begin
      return ccc;
    end
  endfunction

  initial begin
    $display(fn(1));
    $display(fn(0));
  end

endmodule
