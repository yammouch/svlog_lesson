module tb_top;

reg [2:0] addr1, addr2;

covergroup address_cov;
  ADDRESS1: coverpoint addr1 {
    option.auto_bin_max = 8;
  }
  ADDRESS2: coverpoint addr2 {
    bins a2[] = {[0:7]};
  }
  CRS_ADDR: cross ADDRESS1, ADDRESS2;
endgroup

address_cov my_cov = new();

initial begin
  addr1 = 0;
  for (int i = 0; i < 8; i++) begin
    addr2 = i;
    my_cov.sample();
  end
  $finish;
end

endmodule
