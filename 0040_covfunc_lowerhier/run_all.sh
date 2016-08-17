# > source run_all.sh
amsenv a34 b75
rm -rf cov_work cov_report
irun -coverage b:e:f:t:u -covtest test00 -covdut dut -covdut dut2 test00.sv dut.sv dut2.sv
irun -coverage b:e:f:t:u -covtest test01 -covdut dut test01.sv dut.sv
irun -coverage a -covtest test02 -covdut dut test02.sv dut.sv
irun -coverage a -covtest test03 -covdut dut -covdut dut2 test03.sv dut.sv dut2.sv
imc -batch imc.cmd
