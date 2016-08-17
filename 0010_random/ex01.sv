program ex01;
  class Aclass;
    rand bit [2:0] abc;
    constraint a_const {
      abc >= 2;
      abc <= 5;
    }
  endclass
  initial begin
    Aclass i_aclass = new();
    repeat (8) begin
      i_aclass.randomize();
      $write(" %d", i_aclass.abc);
    end
  end
endprogram
