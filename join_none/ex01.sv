`timescale 1ms/1us

module ex01;

task t1;
fork
  begin
    #100ms;
    $display("t1 : %d ms", $time);
  end
join_none
endtask

event ev_dmy;

initial begin
  t1;
  #50ms;
  $display("main : %d ms", $time);
end

endmodule
