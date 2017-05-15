module tb;

task t01;
output [3:0] ret [$];
  ret.push_back(4'h9);
endtask

logic [3:0] q [$];

initial begin
  q.delete;
  t01(q);
  $display(q.size);
  $display(q[0]);
end

endmodule
