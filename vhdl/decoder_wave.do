onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /decode_tb/CLK_PERIOD
add wave -noupdate /decode_tb/rst
add wave -noupdate /decode_tb/clk
add wave -noupdate /decode_tb/Instr
add wave -noupdate /decode_tb/SelR
add wave -noupdate /decode_tb/AddrRA
add wave -noupdate /decode_tb/AddrRB
add wave -noupdate /decode_tb/AddrRDest
add wave -noupdate /decode_tb/RegA
add wave -noupdate /decode_tb/RegB
add wave -noupdate /decode_tb/RegDest
add wave -noupdate /decode_tb/A
add wave -noupdate /decode_tb/B
add wave -noupdate /decode_tb/En_Fetch
add wave -noupdate /decode_tb/En_R
add wave -noupdate /decode_tb/En_RAM
add wave -noupdate /decode_tb/En_sp
add wave -noupdate /decode_tb/PC_load
add wave -noupdate /decode_tb/PC_mux
add wave -noupdate /decode_tb/RAM_rw
add wave -noupdate /decode_tb/Status
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {552 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 38
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
WaveRestoreZoom {337 ns} {1392 ns}
