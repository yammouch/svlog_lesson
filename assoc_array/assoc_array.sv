// % amsenv a34 b75
// % irun -sv assoc_array.sv
program assoc_array;

task test1;
int vals [int];
begin
$display(vals.exists(50));
vals[50] = 1;
$display(vals.exists(50));
$display(vals[50]);
vals[50]++;
$display(vals[50]);
vals[50]++;
$display(vals[50]);
end
endtask

initial begin
  test1;
  $finish;
end

endprogram
