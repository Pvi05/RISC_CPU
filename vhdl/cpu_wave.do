onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/rst
add wave -noupdate /cpu/MAX10_CLK1_50
add wave -noupdate /cpu/A
add wave -noupdate /cpu/B
add wave -noupdate /cpu/R
add wave -noupdate /cpu/AddrRA
add wave -noupdate /cpu/AddrRB
add wave -noupdate /cpu/AddrRDest
add wave -noupdate /cpu/RegA
add wave -noupdate /cpu/RegB
add wave -noupdate /cpu/RegDest
add wave -noupdate -expand -label {Contributors: RegA} -group {Contributors: sim:/cpu/RegA} /cpu/Rf_1/AddrRA
add wave -noupdate -expand -label {Contributors: RegA} -group {Contributors: sim:/cpu/RegA} /cpu/Rf_1/PC
add wave -noupdate -expand -label {Contributors: RegA} -group {Contributors: sim:/cpu/RegA} -childformat {{/cpu/Rf_1/registers(13) -radix unsigned}} -expand -subitemconfig {/cpu/Rf_1/registers(13) {-height 15 -radix unsigned}} /cpu/Rf_1/registers
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
