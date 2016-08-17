# > source run_all.sh
amsenv a34 b75
rm -rf cov_work cov_report
irun -coverage b:e:f:t:u -covtest test01 test01.sv
irun -coverage a -covtest test02 test02.sv
imc imc.cmd
