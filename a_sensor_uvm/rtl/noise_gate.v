module noise_gate(
 clk,
 rstx,
 data_is_signed,
 thre_up,
 thre_lo,
 bypass,
 clear,
 data_in_valid,
 data_in,
 data_out_valid,
 data_out
);

parameter BW = 3;

input           clk;
input           rstx;
input           data_is_signed;
input    [BW:0] thre_up;
input    [BW:0] thre_lo;
input           bypass;
input           clear;
input           data_in_valid;
input  [BW-1:0] data_in;
output          data_out_valid;
output [BW-1:0] data_out;

reg data_out_valid;
always @(posedge clk or negedge rstx)
  if (~rstx)      data_out_valid <= 1'b0;
  else if (clear) data_out_valid <= 1'b0;
  else            data_out_valid <= data_in_valid;

wire [BW:0] data_in_offset = {data_is_signed ^ data_in[BW-1], data_in};

reg [BW-1:0] data_out;
always @(posedge clk or negedge rstx)
  if (~rstx)         data_out <= {BW{1'b0}};
  else if (clear)    data_out <= {BW{1'b0}};
  else if
   ( ( data_in_offset >= {data_is_signed ^ thre_up[BW], thre_up[BW-1:0]}
     | data_in_offset <= {data_is_signed ^ thre_lo[BW], thre_lo[BW-1:0]}
     | bypass )
   & data_in_valid ) data_out <= data_in;

endmodule
