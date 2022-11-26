onerror {exit -code 1}
vlib work
vlog -work work hw_2.vo
vlog -work work Waveform5.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.hw_2_vlg_vec_tst -voptargs="+acc"
vcd file -direction hw_2.msim.vcd
vcd add -internal hw_2_vlg_vec_tst/*
vcd add -internal hw_2_vlg_vec_tst/i1/*
run -all
quit -f
