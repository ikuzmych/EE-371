onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/CLOCK_50
add wave -noupdate /DE1_SoC_testbench/SW
add wave -noupdate /DE1_SoC_testbench/HEX0
add wave -noupdate /DE1_SoC_testbench/HEX1
add wave -noupdate {/DE1_SoC_testbench/KEY[3]}
add wave -noupdate {/DE1_SoC_testbench/KEY[0]}
add wave -noupdate -radix unsigned /DE1_SoC_testbench/dut/countOnes/result
add wave -noupdate -label task_1_ps /DE1_SoC_testbench/dut/countOnes/ps
add wave -noupdate -label task_2_ps /DE1_SoC_testbench/dut/algorithm/ps
add wave -noupdate {/DE1_SoC_testbench/LEDR[9]}
add wave -noupdate {/DE1_SoC_testbench/LEDR[0]}
add wave -noupdate /DE1_SoC_testbench/dut/algorithm/Found
add wave -noupdate /DE1_SoC_testbench/dut/algorithm/Done
add wave -noupdate /DE1_SoC_testbench/dut/algorithm/Start
add wave -noupdate -radix unsigned /DE1_SoC_testbench/dut/algorithm/Loc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {374 ps} 0}
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
WaveRestoreZoom {0 ps} {3780 ps}
