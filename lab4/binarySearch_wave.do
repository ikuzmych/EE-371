onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /binarySearch_testbench/clk
add wave -noupdate /binarySearch_testbench/Reset
add wave -noupdate /binarySearch_testbench/Start
add wave -noupdate -radix unsigned /binarySearch_testbench/A
add wave -noupdate -radix unsigned /binarySearch_testbench/Loc
add wave -noupdate /binarySearch_testbench/Found
add wave -noupdate /binarySearch_testbench/Done
add wave -noupdate -radix unsigned /binarySearch_testbench/dut/L
add wave -noupdate -radix unsigned /binarySearch_testbench/dut/R
add wave -noupdate -radix unsigned /binarySearch_testbench/dut/currRamOut
add wave -noupdate /binarySearch_testbench/dut/ps
add wave -noupdate /binarySearch_testbench/dut/ns
add wave -noupdate /binarySearch_testbench/dut/ramOutHold
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {1 ns}
