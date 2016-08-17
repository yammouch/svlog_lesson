module dut2;

reg [2:0] addr1;

covergroup address_cov;
  ADDRESS2: coverpoint addr1;
endgroup

address_cov my_cov = new();

function cov_sample;
input [2:0] a1;
begin
  addr1 = a1;
  my_cov.sample();
end
endfunction

endmodule
