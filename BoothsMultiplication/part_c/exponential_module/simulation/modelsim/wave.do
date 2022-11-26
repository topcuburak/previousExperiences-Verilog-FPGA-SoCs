onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tpsba/product
add wave -noupdate -radix decimal /tpsba/out_exp_x
add wave -noupdate /tpsba/inp_exp_x
add wave -noupdate -radix decimal /tpsba/count_exp_sin_cos
add wave -noupdate -radix decimal /tpsba/count
add wave -noupdate /tpsba/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 199
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
WaveRestoreZoom {2662 ps} {3327 ps}
