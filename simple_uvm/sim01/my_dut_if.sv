interface my_dut_if();

reg         rstx;
wire        clk;
reg   [2:0] operand_a;
reg   [2:0] operand_b;
reg         data_in_en;
wire  [3:0] sum;
wire        data_out_en;

tb_clk_gen cg(.clk(clk));

endinterface
