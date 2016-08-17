cat > $1_dump.tcl <<!
database $1.shm
probe \
 -create tb -shm -depth all \
 -all -tasks -functions -uvm -packed 4k -unpacked 16 -ports \
 -waveform -database $1.shm
run
!

irun \
 -sv \
 -input $1_dump.tcl \
 +access+r \
 $1.sv
