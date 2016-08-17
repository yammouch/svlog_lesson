module dut;

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

function cov_sample;
input [2:0] a1;
input [2:0] a2;
begin
  addr1 = a1;
  addr2 = a2;
  my_cov.sample();
end
endfunction

endmodule
