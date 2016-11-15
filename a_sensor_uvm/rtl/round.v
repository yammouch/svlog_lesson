module round(
 data_is_signed,
 data_in,
 data_out,
);

// data_in     i4 i3 i2 i1 i0
// +)             i2
// --------------------------
// data_out o2 o1 o0

parameter BW_IN  = 'd5;
parameter BW_OUT = 'd3;

input               data_is_signed;
input  [BW_IN -1:0] data_in;
output [BW_OUT-1:0] data_out;

assign data_out = { data_is_signed & data_in[BW_IN-1] // sign extension
                  , data_in[BW_IN-1:BW_IN-BW_OUT+1] }
                + { {(BW_OUT-1){1'b0}}
                  , data_in[BW_IN-BW_OUT] };

endmodule
