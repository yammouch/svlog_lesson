interface ex03_01(input din, output dout);
  assign dout = din;
endinterface

module ex03;

  logic [1:0] d0;

  ex03_01 i0(.din(d0[0]), .dout());
  ex03_01 i1(.din(d0[1]), .dout());

  initial begin
    d0 = 2'b00; repeat (4) begin
      #1us;
      d0 = d0 + 2'd1;
    end
    #1us;
  end

endmodule
