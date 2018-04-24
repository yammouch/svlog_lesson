# amsenv a1
# source /tools/.ius152isr28rc

set testname = test1

cat > ${testname}_dump.tcl <<!
database ${testname}.shm
probe \
 -create top -shm -depth all \
 -all -tasks -functions -dynamic -uvm -packed 4k -unpacked 16k -ports \
 -memories -waveform -database ${testname}.shm
probe \
 -create uvm_pkg::uvm_top -shm -depth all \
 -all -tasks -functions -dynamic -uvm -packed 4k -unpacked 16k -ports \
 -memories -waveform -database ${testname}.shm
probe \
 -create \$uvm:{uvm_test_top} -shm -depth all \
 -all -tasks -functions -dynamic -uvm -packed 4k -unpacked 16k -ports \
 -memories -waveform -database ${testname}.shm
run
!
#set UVM_HOME = /programs/cds/INCISIV10.2USR3/tools.lnx86/uvm-1.1/uvm_lib/uvm_sv
#set UVM_HOME = /programs/cds/INCISIVE15.2ISR28/tools.lnx86/methodology/UVM/CDNS-1.2-ML/sv
#set UVM_HOME = /programs/cds/INCISIVE15.2ISR28/tools.lnx86/methodology/UVM/CDNS-1.1d/sv
#set UVM_HOME = /programs/cds/INCISIVE15.2ISR28/tools.lnx86/methodology/UVM/CDNS-1.2/sv
# +incdir+${UVM_HOME}/src \
# ${UVM_HOME}/src/uvm_pkg.sv \

irun \
 -uvm \
 -input ${testname}_dump.tcl \
 -coverage ALL \
 -covtest ${testname} \
 -covoverwrite \
 +access+r \
 +UVM_TESTNAME=test1 \
 +UVM_CONFIG_DB_TRACE \
 tb_clk_gen.sv \
 my_dut_if.sv \
 my_packet.sv \
 my_sequencer.sv \
 my_sequence.sv \
 my_scoreboard.sv \
 my_subscriber.sv \
 my_monitor.sv \
 my_driver.sv \
 my_agent.sv \
 my_env.sv \
 test1.sv \
 dut.v \
 top.sv
