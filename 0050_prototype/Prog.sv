// irun
//	-sv
//	Class01.sv
//	Class02.sv
//	Prog.sv

module Prog;

  Class02 class02;

  initial begin
    class02 = new();
    class02.method02();
    $finish;
  end

endmodule
