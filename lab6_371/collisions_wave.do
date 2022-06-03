onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /collisions_testbench/clk
add wave -noupdate /collisions_testbench/reset
add wave -noupdate -radix unsigned /collisions_testbench/x
add wave -noupdate -radix unsigned /collisions_testbench/y
add wave -noupdate -radix unsigned /collisions_testbench/dut/circleX
add wave -noupdate -radix unsigned /collisions_testbench/dut/circleY
add wave -noupdate -radix unsigned /collisions_testbench/paddleXLeft
add wave -noupdate -radix unsigned /collisions_testbench/paddleXRight
add wave -noupdate /collisions_testbench/lose
add wave -noupdate -radix unsigned /collisions_testbench/score
add wave -noupdate /collisions_testbench/sw
add wave -noupdate /collisions_testbench/dut/collisionTrue
add wave -noupdate -radix unsigned /collisions_testbench/dut/currentSlope
add wave -noupdate /collisions_testbench/dut/ps
add wave -noupdate /collisions_testbench/dut/ns
add wave -noupdate /collisions_testbench/dut/start
add wave -noupdate /collisions_testbench/dut/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27222 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {25946 ps} {27260 ps}
