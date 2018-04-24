# imc -exec imc.tcl
merge * -overwrite -out test_all 
load -run test_all
report -type -html -overwrite -uncovered -out cov_report *
