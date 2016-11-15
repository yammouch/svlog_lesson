module iir2(
 clk,
 rstx,
 is_1st_order,
 clear,
 coeff_a1,
 coeff_a2,
 data_in_valid,
 data_in,
 data_out_valid,
 data_out
);

parameter CPR        =  'd8,
          CDY        =  'd1,
          BW_MUL_CNT =  'd4,
          DPR        = 'd25,
          DDY        =  'd4;

input                  clk;
input                  rstx;
input                  is_1st_order;
input                  clear;
input      [CDY+CPR:0] coeff_a1;
input      [CDY+CPR:0] coeff_a2;
input                  data_in_valid;
input  [DDY+DPR+CPR:0] data_in;
output                 data_out_valid;
output   [DDY+DPR+2:0] data_out;

reg data_out_valid;
always @(posedge clk or negedge rstx)
  if (~rstx)      data_out_valid <= 1'b0;
  else if (clear) data_out_valid <= 1'b0;
  else            data_out_valid <= data_in_valid;

reg [DDY+DPR:0] zinv1, zinv2;
wire [DDY+DPR+CDY+CPR+1:0] prod1, prod2;
wire prod_valid;

mult #(
 .BW_CNT   (BW_MUL_CNT),
 .BW_MCAND (DDY+DPR+1), 
 .BW_MLIER (CDY+CPR+1) )
mult_a1 (
 .clk             (clk),
 .rstx            (rstx),
 .mcand_is_signed (1'b1),
 .mlier_is_signed (1'b1),
 .clear           (clear),
 .start           (data_out_valid),
 .mcand           (zinv1),
 .mlier           (coeff_a1),
 .prod            (prod1),
 .prod_valid      ()
);

mult #(
 .BW_CNT   (BW_MUL_CNT),
 .BW_MCAND (DDY+DPR+1), 
 .BW_MLIER (CDY+CPR+1) )
mult_a2 (
 .clk             (clk),
 .rstx            (rstx),
 .mcand_is_signed (1'b1),
 .mlier_is_signed (1'b1),
 .clear           (clear),
 .start           (data_out_valid),
 .mcand           (zinv2),
 .mlier           (coeff_a2),
 .prod            (prod2),
 .prod_valid      ()
);

wire [DDY+DPR+CDY+CPR+2:0] zinv0 =
   { {(CDY+2){data_in[DDY+DPR+CPR]}}, data_in }
 + ( is_1st_order 
   ?   { prod1[DDY+DPR+CDY+CPR+1], prod1 }
   :   { prod1[DDY+DPR+CDY+CPR+1], prod1 }
     + { prod2[DDY+DPR+CDY+CPR+1], prod2 } );

wire [DDY+DPR+CDY+3:0] zinv0_round;
round #(
 .BW_IN  (DDY+DPR+CDY+CPR+3),
 .BW_OUT (DDY+DPR+CDY+4)
) round (
 .data_is_signed (1'b1),
 .data_in        (zinv0),
 .data_out       (zinv0_round)
);

wire [DDY+DPR:0] zinv0_clip;
clip #(
 .BW_IN  (DDY+DPR+CDY+4),
 .BW_OUT (DDY+DPR+1)
) clip (
 .data_in_is_signed  (1'b1),
 .data_out_is_signed (1'b1),
 .data_in            (zinv0_round),
 .data_out           (zinv0_clip)
);

always @(posedge clk or negedge rstx)
  if (~rstx) begin
    zinv2 <= {(DDY+DPR+1){1'b0}}; zinv1 <= {(DDY+DPR+1){1'b0}};
  end else if (clear) begin
    zinv2 <= {(DDY+DPR+1){1'b0}}; zinv1 <= {(DDY+DPR+1){1'b0}};
  end else if (data_in_valid) begin
    zinv2 <= zinv1; zinv1 <= zinv0_clip;
  end

reg [DDY+DPR+2:0] data_out;
always @(posedge clk or negedge rstx)
  if (~rstx)
    data_out <= {(DDY+DPR+3){1'b0}};
  else if (clear)
    data_out <= {(DDY+DPR+3){1'b0}};
  else if (data_in_valid)
    data_out <= { {2{zinv0_clip[DDY+DPR]}}, zinv0_clip }
              + ( is_1st_order
                ? { {2{zinv1[DDY+DPR]}}, zinv1 }
                :   {    zinv1[DDY+DPR]  , zinv1, 1'b0 }
                  + { {2{zinv2[DDY+DPR]}}, zinv2 } );

endmodule
