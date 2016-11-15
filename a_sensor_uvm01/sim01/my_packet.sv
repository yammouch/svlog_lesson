class my_packet extends uvm_sequence_item;
  rand real sense_value;

  `uvm_object_utils(my_packet)

  constraint input_range { -1.0 <= sense_value && sense_value <= 1.0; }
endclass
