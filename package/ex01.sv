package p01;

  class c01;
    logic d01;
  endclass : c01

endpackage : p01

module ex01;

  import p01::*;

  c01 i_c01;

  initial begin
    i_c01 = new();
    i_c01.d01 = 1'b0;
    $display(i_c01.d01);
    i_c01.d01 = 1'b1;
    $display(i_c01.d01);
  end

endmodule : ex01
