onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /collisions_testbench/clk
add wave -noupdate /collisions_testbench/reset
add wave -noupdate -radix decimal /collisions_testbench/x
add wave -noupdate -radix decimal /collisions_testbench/y
add wave -noupdate -radix decimal /collisions_testbench/paddleXLeft
add wave -noupdate -radix decimal /collisions_testbench/paddleXRight
add wave -noupdate -radix binary /collisions_testbench/lose
add wave -noupdate -radix decimal /collisions_testbench/dut/drawCircle/x0
add wave -noupdate -radix decimal /collisions_testbench/dut/drawCircle/y0
add wave -noupdate /collisions_testbench/dut/drawCircle/x1
add wave -noupdate /collisions_testbench/dut/drawCircle/y1
add wave -noupdate -radix decimal /collisions_testbench/dut/drawCircle/slope
add wave -noupdate -radix binary /collisions_testbench/dut/drawCircle/start
add wave -noupdate -radix decimal /collisions_testbench/dut/drawCircle/x
add wave -noupdate -radix decimal /collisions_testbench/dut/drawCircle/y
add wave -noupdate /collisions_testbench/dut/check
add wave -noupdate -radix decimal /collisions_testbench/dut/paddlePositionChecker
add wave -noupdate -radix decimal /collisions_testbench/dut/ranges/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43130 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {36386 ps} {46888 ps}
