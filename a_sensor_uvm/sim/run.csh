#amsenv a34 b75
#set UVM_HOME = /programs/cds/INCISIV10.2USR3/tools.lnx86/uvm-1.1/uvm_lib/uvm_sv

set testname = test1

#cat > intermediate/${testname}_dump.tcl <<!
#database result/${testname}.shm
cat > ${testname}_dump.tcl <<!
database ${testname}.shm
probe \
 -create top -shm -depth all \
 -all -tasks -functions -uvm -packed 4k -unpacked 16k -ports \
 -memories -waveform -database ${testname}.shm
probe \
 -create uvm_pkg::uvm_top -shm -depth all -uvm -waveform -database ${testname}.shm
#probe \
# -create cdns_uvm_pkg:: -shm -depth all \
# -all -tasks -functions -uvm -packed 4k -unpacked 16k -ports \
# -memories -waveform -database ${testname}.shm
#probe \
# -create uvm_pkg:: -shm -depth all \
# -all -tasks -functions -uvm -packed 4k -unpacked 16k -ports \
# -memories -waveform -database ${testname}.shm
run
!

irun \
 -uvm \
 +access+r \
 +UVM_TESTNAME=${testname} \
 -input ${testname}_dump.tcl \
# -gui \
# +UVM_CONFIG_DB_TRACE \
# +incdir+${UVM_HOME}/src \
# ${UVM_HOME}/src/uvm_pkg.sv \
 tb_clk_gen.sv \
 dsm2.sv \
 ../rtl/adc_be.v \
 ../rtl/cic_filter.v \
 ../rtl/clip.v \
 ../rtl/iir2.v \
 ../rtl/mult.v \
 ../rtl/noise_gate.v \
 ../rtl/round.v \
 top.sv

