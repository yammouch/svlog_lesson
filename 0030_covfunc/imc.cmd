merge * -out test_all 
load -run test_all
report -type -html -uncovered -out cov_report *
