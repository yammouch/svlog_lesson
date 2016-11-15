interface my_dut_if();
  reg         clk_en;
  wire        clk;
  reg         rstx;
  reg         rstx_dsm;
  reg   [2:0] cic_order;
  reg   [2:0] decim_ratio;
  reg         clear_cic;
  reg   [9:0] coeff_1_a1;
  reg   [7:0] coeff_1_a2;
  reg         clear_iir_stg1;
  reg   [7:0] coeff_2_a1;
  reg         clear_iir_stg2;
  reg         bypass_stg2;
  reg  [21:0] scale;
  reg         clear_scale_mult;
  reg         bypass_noise_gate;
  reg         clear_noise_gate;
  real        data_in;
  wire        data_out_valid;
  wire [15:0] data_out;
endinterface

class my_packet extends uvm_sequence_item;
  rand real sense_value;

  `uvm_object_utils(my_packet)

  constraint input_range { -1.0 <= sense_value && sense_value <= 1.0; }
endclass

class my_sequencer extends uvm_sequencer #(my_packet);
  `uvm_sequencer_utils(my_sequencer)

  function new(string name = "my_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_update_sequence_lib_and_item(my_packet);
  endfunction
endclass

class my_sequence_ramp extends uvm_sequence #(my_packet);
  my_packet pkt;
  real sense_value;

  `uvm_sequence_utils(my_sequence_ramp, my_sequencer)

  function new(string name = "my_sequence_ramp");
    super.new(name);
  endfunction

  task body();
    for (sense_value = -1.0; sense_value <= 1.0; sense_value += 0.2) begin
      pkt = my_packet::type_id::create("pkt");
      wait_for_grant();
      pkt.sense_value = sense_value;
      send_request(pkt);
      wait_for_item_done();
    end
  endtask
endclass

class my_scoreboard extends uvm_scoreboard;
  `uvm_analysis_imp_decl(_rcvd_pkt)
  `uvm_analysis_imp_decl(_sent_pkt)

  my_packet que_rcvd[$];
  my_packet que_sent[$];

  uvm_analysis_imp_rcvd_pkt #(my_packet, my_scoreboard) rcvr2sb_port;
  uvm_analysis_imp_sent_pkt #(my_packet, my_scoreboard) drvr2sb_port;

  `uvm_component_utils(my_scoreboard)

  function new(string name = "my_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // *::type_id::create does not pass compile
    //rcvr2sb_port = uvm_analysis_imp_rcvd_pkt::type_id::create(
    // "rcvr2sb_port", this);
    rcvr2sb_port = new("rcvr2sb_port", this);
    //drvr2sb_port = uvm_analysis_imp_sent_pkt::type_id::create(
    // "drvr2sb_port", this);
    drvr2sb_port = new("drvr2sb_port", this);
  endfunction

  function void write_rcvd_pkt(input my_packet pkt);
    que_rcvd.push_back(pkt);
  endfunction

  function void write_sent_pkt(input my_packet pkt);
    que_sent.push_back(pkt);
  endfunction
endclass

class my_monitor extends uvm_monitor;
  virtual my_dut_if vif;
  uvm_analysis_port #(my_packet) rcvr2sb_port;
  my_packet pkt;

  `uvm_component_utils(my_monitor)

  function new(string name = "my_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // *::type_id::create does not pass compile.
    //rcvr2sb_port = uvm_analysis_port#(my_packet)::type_id::create(
    // "rcvr2sb_port", this);
    rcvr2sb_port = new("rcvr2sb_port", this);
    if (!uvm_config_db#(virtual my_dut_if)::get(this, "", "vif", vif))
      uvm_report_fatal( "NOVIF", { "virtual interface must be set for:"
                                 , get_full_name(), ".vif" });
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      repeat (64*64) @(negedge vif.data_out_valid);
      pkt = new(); pkt.sense_value = 1.0 * $signed(vif.data_out) / (1 << 15);
      rcvr2sb_port.write(pkt);
    end
  endtask
endclass

class my_agent_out extends uvm_agent;
  uvm_analysis_port #(my_packet) rcvr2sb_port;
  my_monitor mon;

  `uvm_component_utils(my_agent_out)

  function new(string name = "my_agent_out", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = my_monitor::type_id::create("mon", this);
  endfunction
endclass

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

class my_agent_in extends uvm_agent;
  my_driver    drv;
  my_sequencer seqr;

  `uvm_component_utils(my_agent_in)

  function new(string name = "my_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = my_driver::type_id::create("drv", this);
    seqr = my_sequencer::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass

class my_env extends uvm_env;
  my_agent_in   agi;
  my_agent_out  ago;
  my_scoreboard sbd;

  `uvm_component_utils(my_env)

  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agi = my_agent_in::type_id::create("agi", this);
    ago = my_agent_out::type_id::create("ago", this);
    sbd = my_scoreboard::type_id::create("sbd", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agi.drv.drvr2sb_port.connect(sbd.drvr2sb_port);
    ago.mon.rcvr2sb_port.connect(sbd.rcvr2sb_port);
  endfunction
endclass
