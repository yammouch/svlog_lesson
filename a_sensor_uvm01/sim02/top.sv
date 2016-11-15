`include "uvm_macros.svh"
import uvm_pkg::*;

module top;

  wire dsm_out;
  my_dut_if my_dut_if();

  tb_clk_gen i_clk(
   .clk    (my_dut_if.clk),
   .clk_en (my_dut_if.clk_en)
  );
  dsm2 i_dsm2(
   .clk      (my_dut_if.clk),
   .rstx     (my_dut_if.rstx_dsm),
   .data_in  (my_dut_if.data_in),
   .data_out (dsm_out)
  );

  adc_be my_dut(
   .clk               (my_dut_if.clk),
   .rstx              (my_dut_if.rstx),
   .cic_order         (my_dut_if.cic_order),
   .decim_ratio       (my_dut_if.decim_ratio),
   .clear_cic         (my_dut_if.clear_cic),
   .coeff_1_a1        (my_dut_if.coeff_1_a1),
   .coeff_1_a2        (my_dut_if.coeff_1_a2),
   .clear_iir_stg1    (my_dut_if.clear_iir_stg1),
   .coeff_2_a1        (my_dut_if.coeff_2_a1),
   .clear_iir_stg2    (my_dut_if.clear_iir_stg2),
   .bypass_stg2       (my_dut_if.bypass_stg2),
   .scale             (my_dut_if.scale),
   .clear_scale_mult  (my_dut_if.clear_scale_mult),
   .data_in           (dsm_out),
   .bypass_noise_gate (my_dut_if.bypass_noise_gate),
   .clear_noise_gate  (my_dut_if.clear_noise_gate),
   .data_out_valid    (my_dut_if.data_out_valid),
   .data_out          (my_dut_if.data_out)
  );

  initial begin
    uvm_config_db#(virtual my_dut_if)::set
    ( uvm_root::get(), "*", "vif", my_dut_if);
    uvm_config_db#(uvm_object_wrapper)::set
    ( uvm_root::get(), "*.t_env.agi.seqr.run_phase", "default_sequence"
    , my_sequence_ramp::type_id::get() );

    $shm_open;
    $shm_probe(top, "ASCTFM");
    run_test();
  end

endmodule
