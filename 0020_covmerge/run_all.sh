# > source run_all.sh
amsenv a34 b75
rm -rf cov_work cov_report
irun -coverage b -covdut dut -covtest test01 test01.sv dut.v
irun -coverage b -covdut dut -covtest test02 test02.sv dut.v
iccr iccr.cmd
