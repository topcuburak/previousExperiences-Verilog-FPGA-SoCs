onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hw_2/clk
add wave -noupdate /hw_2/start
add wave -noupdate /hw_2/inp_1
add wave -noupdate /hw_2/out_1
add wave -noupdate /hw_2/Start
add wave -noupdate /hw_2/DR
add wave -noupdate /hw_2/AC
add wave -noupdate /hw_2/IR
add wave -noupdate /hw_2/TR
add wave -noupdate /hw_2/PC
add wave -noupdate /hw_2/AR
add wave -noupdate /hw_2/OUTR
add wave -noupdate /hw_2/INPR
add wave -noupdate /hw_2/SC
add wave -noupdate /hw_2/D
add wave -noupdate /hw_2/mem_ram
add wave -noupdate /hw_2/Indirect
add wave -noupdate /hw_2/E
add wave -noupdate /hw_2/FGI
add wave -noupdate /hw_2/FGO
add wave -noupdate /hw_2/IEN
add wave -noupdate /hw_2/IRQ
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5599 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 124
configure wave -valuecolwidth 40
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
WaveRestoreZoom {6027 ps} {6683 ps}
