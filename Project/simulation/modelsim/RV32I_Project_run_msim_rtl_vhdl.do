transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {C:/Local/Studies/ITCE364/Project/RV32I Single Cycle/Project/Components/RegisterFile.vhd}

