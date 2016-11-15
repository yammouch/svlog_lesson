module adc_be(
 clk,
 rstx,
 cic_order,
 decim_ratio,
 clear_cic,
 coeff_1_a1,
 coeff_1_a2,
 clear_iir_stg1,
 coeff_2_a1,
 clear_iir_stg2,
 bypass_stg2,
 scale,
 clear_scale_mult,
 bypass_noise_gate,
 clear_noise_gate,
 data_in,
 data_out_valid,
 data_out
);

input         clk;
input         rstx;
input   [2:0] cic_order;
input   [2:0] decim_ratio;
input         clear_cic;
input   [9:0] coeff_1_a1;
input   [7:0] coeff_1_a2;
input         clear_iir_stg1;
input   [7:0] coeff_2_a1;
input         clear_iir_stg2;
input         bypass_stg2;
input  [21:0] scale;
input         clear_scale_mult;
input         bypass_noise_gate;
input         clear_noise_gate;
input         data_in;
output        data_out_valid;
output [15:0] data_out;

wire        cic_out_valid;
wire [29:0] cic_out;
cic_filter cic(
 .clk            (clk),
 .rstx           (rstx),
 .clear          (clear_cic),
 .order          (cic_order),
 .decim_ratio    (decim_ratio),
 .data_in        (data_in),
 .data_out_valid (cic_out_valid),
 .data_out       (cic_out)
);

wire        stg1_out_valid;
wire [33:0] stg1_out;
iir2 #(
 .CPR        ( 7),
 .CDY        ( 2),
 .BW_MUL_CNT ( 4), 
 .DPR        (27),
 .DDY        ( 4)
) iir_stg1 (
 .clk            (clk),
 .rstx           (rstx),
 .is_1st_order   (1'b0),
 .clear          (clear_iir_stg1),
 .coeff_a1       (coeff_1_a1),
 .coeff_a2       ({ {2{coeff_1_a2[7]}}, coeff_1_a2 }),
 .data_in_valid  (cic_out_valid),
 .data_in        ({ {3{cic_out[28]}}, cic_out, 6'd0 }),
 .data_out_valid (stg1_out_valid),
 .data_out       (stg1_out)
);

wire        stg2_out_valid;
wire [23:0] stg2_out;
iir2 #(
 .CPR        ( 7),
 .CDY        ( 0),
 .BW_MUL_CNT ( 4), 
 .DPR        (15),
 .DDY        ( 6)
) iir_stg2 (
 .clk            (clk),
 .rstx           (rstx),
 .is_1st_order   (1'b1),
 .clear          (clear_iir_stg2),
 .coeff_a1       (coeff_2_a1),
 .coeff_a2       (8'd0),
 .data_in_valid  (stg1_out_valid),
 .data_in        (stg1_out[33:5]),
 .data_out_valid (stg2_out_valid),
 .data_out       (stg2_out)
);

wire        prod_valid;
wire [55:0] prod;
mult #(
 .BW_CNT   ( 6),
 .BW_MCAND (34), 
 .BW_MLIER (22)
) mult_scale (
 .clk             (clk),
 .rstx            (rstx),
 .mcand_is_signed (1'b1),
 .mlier_is_signed (1'b1),
 .clear           (clear_scale_mult),
 .start           (stg2_out_valid),
 .mcand           ( bypass_stg2
                  ? stg1_out
                  : { {2{stg2_out[23]}}, stg2_out, 8'd0 } ),
 .mlier           (scale),
 .prod            (prod),
 .prod_valid      (prod_valid)
);

wire [55:0] noise_gate_out;
noise_gate #( .BW(56) ) noise_gate (
 .clk             (clk),
 .rstx            (rstx),
 .data_is_signed  (1'b1),
 .thre_up         ({  26'd1, 31'd0}),
 .thre_lo         ({-26'sd1, 31'd0}),
 .bypass          (bypass_noise_gate),
 .clear           (clear_noise_gate),
 .data_in_valid   (prod_valid),
 .data_in         (prod),
 .data_out_valid  (data_out_valid),
 .data_out        (noise_gate_out)
);

wire [23:0] prod_round;
round #(.BW_IN(56), .BW_OUT(24)) round (
 .data_is_signed (1'b1),
 .data_in        (noise_gate_out),
 .data_out       (prod_round)
);

clip #(.BW_IN(24), .BW_OUT(16)) clip (
 .data_in_is_signed  (1'b1),
 .data_out_is_signed (1'b1),
 .data_in            (prod_round),
 .data_out           (data_out)
);

endmodule
