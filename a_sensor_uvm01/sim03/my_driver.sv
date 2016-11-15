`include "uvm_macros.svh"
import uvm_pkg::*;

class my_driver extends uvm_driver #(my_packet);
  uvm_analysis_port #(my_packet) drvr2sb_port;
  virtual my_dut_if vif;

  `uvm_component_utils(my_driver)

  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // *::type_id::create does not pass compile.
    //drvr2sb_port = uvm_analysis_port#(my_packet)::type_id::create(
    // "drvr2sb_port", this);
    drvr2sb_port = new("drvr2sb_port", this);
    if(!uvm_config_db#(virtual my_dut_if)::get(this, "", "vif", vif))
      uvm_report_fatal( "NOVIF", { "virtual interface must be set for:"
                                 , get_full_name(), ".vif" });
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    init();
    while(seq_item_port.has_do_available()) begin
      seq_item_port.get_next_item(req);
      @(posedge vif.clk) vif.data_in <= req.sense_value;
      drvr2sb_port.write(req);
      seq_item_port.item_done();
      repeat(64*64-1) @(posedge vif.clk);
      // waits 64 decimation, 64 data out for settling
    end

    phase.drop_objection(this);
  endtask

  task init();
    vif.rstx              = 1'b0;
    vif.cic_order         = 3'd3;
    vif.cic_order         = 3'd3;
    vif.decim_ratio       = 3'd6;
    vif.clear_cic         = 1'b1;
    vif.coeff_1_a1        = $rtoi( 0.94109 * (1 <<  7)); // cutoff 0.275*Nyquist
    vif.coeff_1_a2        = $rtoi(-0.44906 * (1 <<  7));
    vif.clear_iir_stg1    = 1'b1;
    vif.coeff_2_a1        = $rtoi( 0.36892 * (1 <<  7));
    vif.clear_iir_stg2    = 1'b1;
    vif.bypass_stg2       = 1'b0;
    vif.scale             = $rtoi( 0.04007 * (1 << 25));
    vif.clear_scale_mult  = 1'b1;
    vif.bypass_noise_gate = 1'b0;
    vif.clear_noise_gate  = 1'b1;
    vif.rstx_dsm          = 1'b0; #1us;

    vif.rstx   = 1'b1; #1us;
    vif.clk_en = 1'b1;

    @(posedge vif.clk) begin
      vif.clear_cic        <= 1'b0;
      vif.clear_iir_stg1   <= 1'b0;
      vif.clear_iir_stg2   <= 1'b0;
      vif.clear_scale_mult <= 1'b0;
      vif.clear_noise_gate <= 1'b0;
      vif.rstx_dsm         <= 1'b1;
    end
  endtask

endclass
