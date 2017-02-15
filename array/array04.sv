module tb;

task receives_queue_small(logic [7:0] q [$]);
  integer i;
  for (i = 0; i < q.size(); i++)
    $write(" %b", q[i]);
  $write("\n");
endtask

task receives_queue(logic [7:0] q [$]);
  integer i;
  // processes in 4-byte unit
  // q.size == 1, 0
  // q.size == 2, 0-1
  // q.size == 3, 0-2
  // q.size == 4, 0-3
  // q.size == 5, 0-3 4
  // q.size == 6, 0-3 4-5
  // q.size == 7, 0-3 4-6
  // q.size == 8, 0-3 4-7
  // q.size == 9, 0-3 4-7 8
  i = 0; while (i < (q.size() - 1) / 4) begin
    receives_queue_small(q[i*4:i*4+3]);
    i = i+1;
  end
  receives_queue_small(q[i*4:$]);
endtask

logic [7:0] q [$];
integer i, j;

initial begin
  for (i = 1; i < 12; i++) begin
    q.delete();
    j = 0; repeat (i) begin
      q.push_back(j);
      j++;
    end
    $write("i: %d , q.size: %d\n", i, q.size());
    receives_queue(q);
  end
end

endmodule
