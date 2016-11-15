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
