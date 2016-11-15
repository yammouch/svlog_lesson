module clip(
 data_in_is_signed,
 data_out_is_signed,
 data_in,
 data_out,
);

parameter BW_IN  = 'd5;
parameter BW_OUT = 'd3;

input               data_in_is_signed;
input               data_out_is_signed;
input  [BW_IN -1:0] data_in;
output [BW_OUT-1:0] data_out;

// data_in  i4 i3 i2 i1 i0
// data_out       o2 o1 o0
wire all1 = (data_in[BW_IN-1:BW_OUT] == {(BW_IN-BW_OUT){1'b1}});
wire all0 = (data_in[BW_IN-1:BW_OUT] == {(BW_IN-BW_OUT){1'b0}});
reg clip_up, clip_lo;
always @*
  case ({data_in_is_signed, data_out_is_signed})
  2'b00: begin
    clip_up = ~all0;
    clip_lo = 1'b0; end
  2'b01: begin
    clip_up = ~all0 | data_in[BW_OUT-1];
    clip_lo = 1'b0; end
  2'b10: begin
    clip_up = ~data_in[BW_IN-1] & ~all0;
    clip_lo =  data_in[BW_IN-1]; end
  2'b11: begin
    clip_up = ~data_in[BW_IN-1] & ( ~all0 |  data_in[BW_OUT-1] );
    clip_lo =  data_in[BW_IN-1] & ( ~all1 | ~data_in[BW_OUT-1] ); end
  endcase

assign data_out = clip_up | clip_lo
                ? {clip_up ^ data_out_is_signed, {(BW_OUT-1){clip_up}}}
                : data_in[BW_OUT-1:0];
 
endmodule
