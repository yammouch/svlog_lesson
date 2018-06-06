module ex02;

  logic d0, d1;

  property p0;
    @* d0 == d1;
  endproperty

  assert property (p0);

  task test1(input [1:0] data);
    {d1, d0} = data;
    #1ms;
  endtask

  initial begin
    test1(2'b00);
    test1(2'b01);
    test1(2'b11);
    test1(2'b10);
  end

endmodule
