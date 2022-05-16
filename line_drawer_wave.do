onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /line_drawer_testbench/clk
add wave -noupdate -radix binary /line_drawer_testbench/reset
add wave -noupdate /line_drawer_testbench/start
add wave -noupdate -radix decimal /line_drawer_testbench/x0
add wave -noupdate -radix decimal /line_drawer_testbench/y0
add wave -noupdate -radix decimal /line_drawer_testbench/x1
add wave -noupdate -radix decimal /line_drawer_testbench/y1
add wave -noupdate -radix binary /line_drawer_testbench/done
add wave -noupdate -radix decimal /line_drawer_testbench/x
add wave -noupdate -radix decimal /line_drawer_testbench/y
add wave -noupdate -radix decimal /line_drawer_testbench/dut/error
add wave -noupdate -radix decimal /line_drawer_testbench/dut/e2
add wave -noupdate -radix decimal /line_drawer_testbench/dut/dx
add wave -noupdate -radix decimal /line_drawer_testbench/dut/dy
add wave -noupdate -radix decimal /line_drawer_testbench/dut/sx
add wave -noupdate -radix decimal /line_drawer_testbench/dut/sy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {590 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 149
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
WaveRestoreZoom {120 ps} {1140 ps}
