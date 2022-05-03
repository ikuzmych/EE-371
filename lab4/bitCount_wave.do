onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bitCount_testbench/clk
add wave -noupdate /bitCount_testbench/reset
add wave -noupdate /bitCount_testbench/s
add wave -noupdate /bitCount_testbench/A
add wave -noupdate /bitCount_testbench/dut/Q
add wave -noupdate -radix unsigned /bitCount_testbench/result
add wave -noupdate /bitCount_testbench/done
add wave -noupdate /bitCount_testbench/dut/ps
add wave -noupdate /bitCount_testbench/dut/ns
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
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
