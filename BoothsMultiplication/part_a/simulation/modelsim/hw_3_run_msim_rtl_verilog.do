transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/ee314/hw_3/part_a {C:/ee314/hw_3/part_a/booth's_algorithm.v}

