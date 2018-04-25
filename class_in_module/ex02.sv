program ex02;

  logic a;

  class C00;
    task t1();
      a = 1'b1;
    endtask
  endclass

  C00 c00;

  initial begin
    a = 1'b0;
    c00 = new();
    $display(a);
    c00.t1();
    $display(a);
  end

endprogram
