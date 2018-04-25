// does not pass compile

program dut(input a, output b);

  assign a = ~b;

endprogram

program ex03;

  logic a;

  dut i_dut(.a(a), .b());

  initial begin
    a = 1'b0;
    $display(i_dut.b);
    a = 1'b1;
    $display(i_dut.b);
  end

endprogram
