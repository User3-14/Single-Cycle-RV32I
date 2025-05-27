onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath/clk
add wave -noupdate /datapath/reset
add wave -noupdate -radix decimal /datapath/Program_Counter/pc_value
add wave -noupdate -radix hexadecimal /datapath/Instruction_Memory/instr
add wave -noupdate -radix decimal /datapath/Instruction_Decode/rs1_addr
add wave -noupdate -radix decimal /datapath/Instruction_Decode/rs2_addr
add wave -noupdate -radix decimal /datapath/Instruction_Decode/rd_addr
add wave -noupdate -radix decimal /datapath/Instruction_Decode/immediate
add wave -noupdate /datapath/Main_Control_Unit/ALU_op
add wave -noupdate /datapath/Main_Control_Unit/ALU_src
add wave -noupdate /datapath/Main_Control_Unit/reg_write
add wave -noupdate /datapath/Main_Control_Unit/mem_write
add wave -noupdate /datapath/Main_Control_Unit/mem_to_reg
add wave -noupdate /datapath/Main_Control_Unit/branch
add wave -noupdate /datapath/Main_Control_Unit/offset
add wave -noupdate -radix decimal /datapath/AL_Unit/A
add wave -noupdate -radix decimal /datapath/AL_Unit/B
add wave -noupdate -radix decimal /datapath/AL_Unit/R
add wave -noupdate -radix hexadecimal /datapath/Register_File/registers
add wave -noupdate -radix hexadecimal /datapath/DataMemory/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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