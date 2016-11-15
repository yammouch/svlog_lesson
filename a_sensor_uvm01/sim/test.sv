class test1 extends uvm_test;
  my_env t_env;

  `uvm_component_utils(test1)

  function new(string name = "test1", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t_env = my_env::type_id::create("t_env", this);
  endfunction
endclass
