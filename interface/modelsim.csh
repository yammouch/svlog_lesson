# amsenv h

rm -rf foo
vlib foo
vlog -work foo ex01.sv
vsim foo.tb -voptargs=+acc -wlf ex01.wlf <<!
  add wave -r /*
  run -all
  quit -f
!
