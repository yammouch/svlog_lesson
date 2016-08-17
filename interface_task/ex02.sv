interface testif;
reg RT;
task toggle(input din);
  RT = din;
endtask
endinterface

class test1;
  virtual testif vif;
  function new(input virtual testif tif);
    vif = tif;
  endfunction

  task run;
    #10us;
    vif.toggle(1'b1);
    #10us;
  endtask
endclass

module tb;

wire RT;
testif i_testif();
assign RT = i_testif.RT;

test1 t1 = new(i_testif);

initial begin
  t1.run();
  $finish;
end
endmodule
