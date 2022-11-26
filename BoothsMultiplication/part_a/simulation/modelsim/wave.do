onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /hw_3/product
add wave -noupdate /hw_3/Multiplicand
add wave -noupdate /hw_3/Multiplier
add wave -noupdate /hw_3/clk
add wave -noupdate /hw_3/bit_range
add wave -noupdate /hw_3/A
add wave -noupdate /hw_3/Q
add wave -noupdate /hw_3/M
add wave -noupdate /hw_3/Q_1
add wave -noupdate /hw_3/count
add wave -noupdate /hw_3/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {2550 ps} {3550 ps}
