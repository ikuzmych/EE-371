onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/CLOCK_50
add wave -noupdate /DE1_SoC_testbench/dut/systemclock
add wave -noupdate {/DE1_SoC_testbench/dut/KEY[1]}
add wave -noupdate {/DE1_SoC_testbench/dut/KEY[0]}
add wave -noupdate /DE1_SoC_testbench/dut/x0
add wave -noupdate /DE1_SoC_testbench/dut/y0
add wave -noupdate /DE1_SoC_testbench/dut/x1
add wave -noupdate /DE1_SoC_testbench/dut/y1
add wave -noupdate /DE1_SoC_testbench/dut/x
add wave -noupdate /DE1_SoC_testbench/dut/y
add wave -noupdate /DE1_SoC_testbench/dut/pixel_color
add wave -noupdate /DE1_SoC_testbench/dut/done
add wave -noupdate /DE1_SoC_testbench/dut/reset
add wave -noupdate /DE1_SoC_testbench/dut/start
add wave -noupdate /DE1_SoC_testbench/dut/ps
add wave -noupdate /DE1_SoC_testbench/dut/ns
add wave -noupdate /DE1_SoC_testbench/dut/lines/error
add wave -noupdate /DE1_SoC_testbench/dut/lines/e2
add wave -noupdate /DE1_SoC_testbench/dut/lines/dx
add wave -noupdate /DE1_SoC_testbench/dut/lines/dy
add wave -noupdate /DE1_SoC_testbench/dut/lines/sx
add wave -noupdate /DE1_SoC_testbench/dut/lines/sy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13 ps} 0}
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
WaveRestoreZoom {0 ps} {528 ps}
