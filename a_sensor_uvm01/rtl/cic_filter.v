module cic_filter(
 clk,
 rstx,
 clear,
 data_in,
 decim_ratio,
 order,
 data_out,
 data_out_valid
);

localparam BW = 6'd30,
           BWBW = 'd6;

input           clk;
input           rstx;
input           clear;
input           data_in;
input     [2:0] decim_ratio;
input     [2:0] order;
output [BW-1:0] data_out;
output          data_out_valid;

reg [6:0] cnt;
wire cnt_eq_0 = (cnt == 7'd0);
always @ (posedge clk or negedge rstx)
  if (~rstx) cnt <= 7'd127;
  else if (clear)
    cnt <= {4'd0, order - 3'd1};
  else if (cnt_eq_0)
    case (decim_ratio)
    3'd0: cnt <= 7'd3;
    3'd1: cnt <= 7'd3;
    3'd2: cnt <= 7'd3;
    3'd3: cnt <= 7'd7;
    3'd4: cnt <= 7'd15;
    3'd5: cnt <= 7'd31;
    3'd6: cnt <= 7'd63;
    3'd7: cnt <= 7'd127;
    default: cnt <= 7'dx;
    endcase
  else cnt <= cnt - 7'd1;

reg [3:0] din_sel, reg_clr;
always @ (*)
  case (order)
  3'd4: begin din_sel = 4'b1000; reg_clr = 4'b0000; end
  3'd3: begin din_sel = 4'b0100; reg_clr = 4'b1000; end
  3'd2: begin din_sel = 4'b0010; reg_clr = 4'b1100; end
  3'd1: begin din_sel = 4'b0001; reg_clr = 4'b1110; end
  3'd7: begin din_sel = 4'b0000; reg_clr = 4'b1111; end // abnormal
  3'd6: begin din_sel = 4'b0000; reg_clr = 4'b1111; end // abnormal
  3'd5: begin din_sel = 4'b0000; reg_clr = 4'b1111; end // abnormal
  3'd0: begin din_sel = 4'b0000; reg_clr = 4'b1111; end // abnormal
  default: begin din_sel = 4'bxxxx; reg_clr = 4'bxxxx; end
  endcase

wire clr1 = reg_clr[0] | clear;
wire clr2 = reg_clr[1] | clear;
wire clr3 = reg_clr[2] | clear;
wire clr4 = reg_clr[3] | clear;

wire [5:0] shamt_pre = order * decim_ratio;
wire [5:0] shamt = BW - { {(BWBW-2){1'b0}}, 2'd2 } - shamt_pre;
wire [BW-1:0] din_dcd = data_in ? {{(BW-1){1'b0}}, 1'b1} : {(BW){1'b1}};
wire [BW-1:0] din_scaled = din_dcd << shamt;
wire [BW-1:0] mask = {BW{1'b1}} << shamt;

reg [BW-1:0] i1, i2, i3, i4;
always @ (posedge clk or negedge rstx)
  if (~rstx)     i4 <= {BW{1'b0}};
  else if (clr4) i4 <= {BW{1'b0}};
  else           i4 <= (i4 + (din_sel[3] ? din_scaled : {BW{1'b0}})) & mask;
always @ (posedge clk or negedge rstx)
  if (~rstx)     i3 <= {BW{1'b0}};
  else if (clr3) i3 <= {BW{1'b0}};
  else           i3 <= (i3 + (din_sel[2] ? din_scaled : i4)) & mask;
always @ (posedge clk or negedge rstx)
  if (~rstx)     i2 <= {BW{1'b0}};
  else if (clr2) i2 <= {BW{1'b0}};
  else           i2 <= (i2 + (din_sel[1] ? din_scaled : i3)) & mask;
always @ (posedge clk or negedge rstx)
  if (~rstx)     i1 <= {BW{1'b0}};
  else if (clr1) i1 <= {BW{1'b0}};
  else           i1 <= ( (cnt_eq_0   ? {BW{1'b0}} : i1)
                       + (din_sel[0] ? din_scaled : i2) )
                     & mask;

reg [BW-1:0] d1, d2, d3, d4;
wire [BW-1:0] d1_d2 = d1    - d2;
wire [BW-1:0] d2_d3 = d1_d2 - d3;
always @ (posedge clk or negedge rstx)
  if (~rstx)         d1 <= {BW{1'b0}};
  else if (clr1)     d1 <= {BW{1'b0}};
  else if (cnt_eq_0) d1 <= i1 & mask;
always @ (posedge clk or negedge rstx)
  if (~rstx)         d2 <= {BW{1'b0}};
  else if (clr2)     d2 <= {BW{1'b0}};
  else if (cnt_eq_0) d2 <= d1 & mask;
always @ (posedge clk or negedge rstx)
  if (~rstx)         d3 <= {BW{1'b0}};
  else if (clr3)     d3 <= {BW{1'b0}};
  else if (cnt_eq_0) d3 <= d1_d2 & mask;
always @ (posedge clk or negedge rstx)
  if (~rstx)         d4 <= {BW{1'b0}};
  else if (clr4)     d4 <= {BW{1'b0}};
  else if (cnt_eq_0) d4 <= d2_d3 & mask;

reg data_out_valid;
always @ (posedge clk or negedge rstx)
  if (~rstx)      data_out_valid <= 1'b0;
  else if (clear) data_out_valid <= 1'b0;
  else            data_out_valid <= cnt_eq_0;

reg [BW-1:0] data_out;
always @ (*)
  case (order)
  3'd4: data_out = d2_d3 - d4;
  3'd3: data_out = d2_d3;
  3'd2: data_out = d1_d2;
  3'd1: data_out = d1;
  3'd7: data_out = {BW{1'b0}}; // abnormal
  3'd6: data_out = {BW{1'b0}}; // abnormal
  3'd5: data_out = {BW{1'b0}}; // abnormal
  3'd0: data_out = {BW{1'b0}}; // abnormal
  default: data_out = {BW{1'bx}};
  endcase

endmodule
