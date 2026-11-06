if {![file exists work]} {vlib work}
vmap work work
vlog sync_fifo.v sync_fifo_tb.v
vsim -voptargs=+acc work.sync_fifo_tb
onfinish stop
view wave
add wave -r sim:/sync_fifo_tb/*
run -all
wave zoom full
