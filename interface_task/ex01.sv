interface testif(reg RT);
task toggle(input din);
  RT = din;
endtask
endinterface

module ex01;

wire RT;
testif i_testif(.RT(RT));

initial begin
  #10us;
  i_testif.toggle(1'b1);
  #10us;
  $finish;
end
endmodule
