module dut(
 input            clk,
 input            rstx,
 input      [2:0] operand_a,
 input      [2:0] operand_b,
 input            data_in_en,
 output reg [3:0] sum,
 output reg       data_out_en);

always @(posedge clk or negedge rstx)
  if (!rstx) sum <= 4'd0;
  else       sum <= {1'd0, operand_a} + {1'd0, operand_b};

always @(posedge clk or negedge rstx)
  if (!rstx) data_out_en <= 1'b0;
  else       data_out_en <= data_in_en;

endmodule
