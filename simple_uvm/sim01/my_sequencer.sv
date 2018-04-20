class my_sequencer extends uvm_sequencer #(my_packet);
  `uvm_sequencer_utils(my_sequencer)

  function new(string name = "my_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_update_sequence_lib_and_item(my_packet);
  endfunction
endclass
