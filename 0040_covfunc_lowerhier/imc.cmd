#merge_config -source dut2 -target dut2
merge * -out test_all 
load -run test_all
report -type -html -uncovered -out cov_report *
