vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../NCSSK.srcs/sources_1/ip/mult_gen_1/mult_gen_1_sim_netlist.v" \


vlog -work xil_defaultlib \
"glbl.v"
