onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/MAX10_CLK1_50
add wave -noupdate /cpu/rst
add wave -noupdate -radix binary /cpu/AddrRA
add wave -noupdate -radix binary /cpu/AddrRB
add wave -noupdate -radix binary /cpu/AddrRDest
add wave -noupdate -radix binary /cpu/A
add wave -noupdate -radix binary /cpu/B
add wave -noupdate -radix binary /cpu/R
add wave -noupdate -radix binary /cpu/PC_out
add wave -noupdate -radix binary /cpu/PC_Load
add wave -noupdate -expand -label {Contributors: PC_Load} -group {Contributors: sim:/cpu/PC_Load} /cpu/Decode_1/Op
add wave -noupdate -expand -label {Contributors: PC_Load} -group {Contributors: sim:/cpu/PC_Load} /cpu/Decode_1/Status
add wave -noupdate -radix binary /cpu/RegA
add wave -noupdate -radix binary /cpu/RegB
add wave -noupdate -radix binary /cpu/ROM_out
add wave -noupdate -radix binary /cpu/Status
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {311 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 287
configure wave -valuecolwidth 265
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {780 ns}
