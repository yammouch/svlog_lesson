module dsm2(
 input      clk,
 input      rstx,
 input real data_in,
 output     data_out);

real i1_reg, i1, i2, data_out_dcd;
always @* i1 = data_in - data_out_dcd + i1_reg;
always @(posedge clk or negedge rstx)
  if (~rstx) i1_reg <= 0.0;
  else       i1_reg <= i1;
always @(posedge clk or negedge rstx)
  if (~rstx) i2 <= 0.0;
  else       i2 <= i1 - data_out_dcd + i2;

assign data_out = (i2 < 0.0 ? 1'b0 : 1'b1);
always @* data_out_dcd = (data_out ? 1.0 : -1.0);

endmodule
