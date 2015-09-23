#vdel -all
vlib work
vlog -f ./run.f
vsim -vopt -voptargs=+acc work.ldst_top_tb