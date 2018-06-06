module ex01;

  logic d0, d1;

  task test1(input [1:0] data);
    {d1, d0} = data;
    #1ms;
    assert (d0 == d1);
  endtask

  initial begin
    test1(2'b00);
    test1(2'b01);
    test1(2'b11);
    test1(2'b10);
  end

endmodule
