// % amsenv a34 b75
// % irun -coverage u -covdut ex03 ex03.sv
// % iccr
// > report_html -module -all * -output hoge

module ex03;

reg [2:0] addr1, addr2;

covergroup address_cov;
  ADDRESS1: coverpoint addr1 {
    bins low  = {0, 3};
    bins high = {4, 7};
  }
  ADDRESS2: coverpoint addr2 {
    bins min = {0};
    bins max = {7};
    bins mid = default;
  }
endgroup

address_cov my_cov = new();

initial begin
  addr1 = 0; addr2 = 0; my_cov.sample();
  addr1 = 0; addr2 = 3; my_cov.sample();
  addr1 = 4; addr2 = 7; my_cov.sample();
  $finish;
end

endmodule
