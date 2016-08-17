class Aclass;

  class Aclass2;
    int foo;
  endclass

  Aclass2 ac2;

  function make_ac2;
    ac2 = new;
  endfunction

endclass

module ex01;

  Aclass ac;

  initial begin
    ac = new;
    ac.make_ac2;
    ac.ac2.foo = 10;
    $display(ac.ac2.foo);
  end

endmodule
