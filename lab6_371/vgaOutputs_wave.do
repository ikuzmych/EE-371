onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vgaOutputs_testbench/clk
add wave -noupdate /vgaOutputs_testbench/reset
add wave -noupdate /vgaOutputs_testbench/moveLeft
add wave -noupdate /vgaOutputs_testbench/moveRight
add wave -noupdate /vgaOutputs_testbench/lose
add wave -noupdate -radix decimal /vgaOutputs_testbench/x
add wave -noupdate -radix decimal /vgaOutputs_testbench/y
add wave -noupdate -radix decimal /vgaOutputs_testbench/xCirclePosition
add wave -noupdate -radix decimal /vgaOutputs_testbench/yCirclePosition
add wave -noupdate -radix decimal /vgaOutputs_testbench/r
add wave -noupdate -radix decimal /vgaOutputs_testbench/g
add wave -noupdate -radix decimal /vgaOutputs_testbench/b
add wave -noupdate -radix decimal /vgaOutputs_testbench/x_paddle1_left
add wave -noupdate -radix decimal /vgaOutputs_testbench/x_paddle1_right
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
