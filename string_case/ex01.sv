module ex01;

task t1(input string str);
case (str)
"FOO": $display("foo");
"BAR": $display("bar");
endcase
endtask

initial begin
  t1("BAR");
  t1("FOO");
  t1("BACA");
end

endmodule
