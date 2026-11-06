onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sync_fifo_tb/clk
add wave -noupdate /sync_fifo_tb/reset
add wave -noupdate /sync_fifo_tb/w_enb
add wave -noupdate /sync_fifo_tb/r_enb
add wave -noupdate /sync_fifo_tb/din
add wave -noupdate /sync_fifo_tb/dout
add wave -noupdate /sync_fifo_tb/full
add wave -noupdate /sync_fifo_tb/empty
add wave -noupdate /sync_fifo_tb/expected_dout
add wave -noupdate /sync_fifo_tb/head
add wave -noupdate /sync_fifo_tb/tail
add wave -noupdate /sync_fifo_tb/used
add wave -noupdate /sync_fifo_tb/errors
add wave -noupdate /sync_fifo_tb/cycles
add wave -noupdate /sync_fifo_tb/reads
add wave -noupdate /sync_fifo_tb/writes
add wave -noupdate /sync_fifo_tb/blocked_reads
add wave -noupdate /sync_fifo_tb/blocked_writes
add wave -noupdate /sync_fifo_tb/simultaneous
add wave -noupdate /sync_fifo_tb/i
add wave -noupdate /sync_fifo_tb/seed
add wave -noupdate /sync_fifo_tb/random_control
add wave -noupdate /sync_fifo_tb/random_data
add wave -noupdate /sync_fifo_tb/take_read
add wave -noupdate /sync_fifo_tb/take_write
add wave -noupdate /sync_fifo_tb/step/do_reset
add wave -noupdate /sync_fifo_tb/step/request_write
add wave -noupdate /sync_fifo_tb/step/request_read
add wave -noupdate /sync_fifo_tb/step/value
add wave -noupdate /sync_fifo_tb/DUT/clk
add wave -noupdate /sync_fifo_tb/DUT/reset
add wave -noupdate /sync_fifo_tb/DUT/w_enb
add wave -noupdate /sync_fifo_tb/DUT/r_enb
add wave -noupdate /sync_fifo_tb/DUT/din
add wave -noupdate /sync_fifo_tb/DUT/dout
add wave -noupdate /sync_fifo_tb/DUT/empty
add wave -noupdate /sync_fifo_tb/DUT/full
add wave -noupdate /sync_fifo_tb/DUT/wptr
add wave -noupdate /sync_fifo_tb/DUT/rptr
add wave -noupdate /sync_fifo_tb/DUT/count
add wave -noupdate /sync_fifo_tb/DUT/clog2/clog2
add wave -noupdate /sync_fifo_tb/DUT/clog2/value
add wave -noupdate /sync_fifo_tb/DUT/clog2/temp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {11220300 ps}
