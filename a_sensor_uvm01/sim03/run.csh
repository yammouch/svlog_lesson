amsenv a34 b75
set UVM_HOME = /programs/cds/INCISIV10.2USR3/tools.lnx86/uvm-1.1/uvm_lib/uvm_sv
irun \
 -uvm \
 +access+r \
 +UVM_TESTNAME=test1 \
 +UVM_CONFIG_DB_TRACE \
 +incdir+${UVM_HOME}/src \
 ${UVM_HOME}/src/uvm_pkg.sv \
 tb_clk_gen.sv \
 dsm2.sv \
 my_dut_if.sv \
 my_packet.sv \
 my_sequencer.sv \
 my_sequence_ramp.sv \
 my_scoreboard.sv \
 my_monitor.sv \
 my_agent_out.sv \
 my_driver.sv \
 my_agent_in.sv \
 my_env.sv \
 test1.sv \
 ../rtl/adc_be.v \
 ../rtl/cic_filter.v \
 ../rtl/clip.v \
 ../rtl/iir2.v \
 ../rtl/mult.v \
 ../rtl/noise_gate.v \
 ../rtl/round.v \
 top.sv

