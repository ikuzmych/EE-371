onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/CLOCK_50
add wave -noupdate /DE1_SoC_testbench/dut/lines/x0
add wave -noupdate /DE1_SoC_testbench/dut/lines/y0
add wave -noupdate /DE1_SoC_testbench/dut/lines/x1
add wave -noupdate /DE1_SoC_testbench/dut/lines/y1
add wave -noupdate /DE1_SoC_testbench/dut/lines/done
add wave -noupdate /DE1_SoC_testbench/dut/lines/x
add wave -noupdate /DE1_SoC_testbench/dut/lines/y
add wave -noupdate /DE1_SoC_testbench/KEY
add wave -noupdate {/DE1_SoC_testbench/SW[0]}
add wave -noupdate {/DE1_SoC_testbench/LEDR[9]}
add wave -noupdate /DE1_SoC_testbench/dut/x0
add wave -noupdate /DE1_SoC_testbench/dut/y0
add wave -noupdate /DE1_SoC_testbench/dut/x1
add wave -noupdate /DE1_SoC_testbench/dut/y1
add wave -noupdate /DE1_SoC_testbench/dut/x
add wave -noupdate /DE1_SoC_testbench/dut/y
add wave -noupdate /DE1_SoC_testbench/dut/white
add wave -noupdate /DE1_SoC_testbench/dut/black
add wave -noupdate /DE1_SoC_testbench/dut/moveRight
add wave -noupdate /DE1_SoC_testbench/dut/moveLeft
add wave -noupdate /DE1_SoC_testbench/dut/moveDown
add wave -noupdate /DE1_SoC_testbench/dut/moveUp
add wave -noupdate /DE1_SoC_testbench/dut/in
add wave -noupdate /DE1_SoC_testbench/dut/reset
add wave -noupdate /DE1_SoC_testbench/dut/done
add wave -noupdate /DE1_SoC_testbench/dut/doneMoving
add wave -noupdate /DE1_SoC_testbench/dut/ps
add wave -noupdate /DE1_SoC_testbench/dut/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {230 ps} 0}
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
WaveRestoreZoom {0 ps} {1055 ps}
