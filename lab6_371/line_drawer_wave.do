onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /line_drawer_testbench/clk
add wave -noupdate /line_drawer_testbench/reset
add wave -noupdate /line_drawer_testbench/x0
add wave -noupdate /line_drawer_testbench/y0
add wave -noupdate /line_drawer_testbench/dut/slope
add wave -noupdate /line_drawer_testbench/dut/x1
add wave -noupdate /line_drawer_testbench/dut/y1
add wave -noupdate /line_drawer_testbench/done
add wave -noupdate /line_drawer_testbench/start
add wave -noupdate /line_drawer_testbench/dut/x
add wave -noupdate /line_drawer_testbench/dut/y
add wave -noupdate -radix unsigned /line_drawer_testbench/dut/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {170 ps} 0}
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
WaveRestoreZoom {0 ps} {1612 ps}
