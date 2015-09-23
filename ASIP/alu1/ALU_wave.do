onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/clk
add wave -noupdate /alu_tb/rst_b
add wave -noupdate /alu_tb/alu_o_sel
add wave -noupdate /alu_tb/alu_t_sel
add wave -noupdate /alu_tb/alu_o_dat
add wave -noupdate /alu_tb/alu_t_dat
add wave -noupdate /alu_tb/alu_typ_sel
add wave -noupdate /alu_tb/alu_r_dat
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /alu_tb/uut/my_ALU_InvGenerator/my_Inv_Ctrl/counter
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/alu_o_sel
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/inv_in
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/muxA_in
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/muxB_in
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/exp_in
add wave -noupdate -color Yellow /alu_tb/uut/my_ALU_InvGenerator/operandA_out
add wave -noupdate -color Yellow /alu_tb/uut/my_ALU_InvGenerator/operandB_out
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/product_in
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/inv_out
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/mux0_ctrl
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/exp_ctrl
add wave -noupdate /alu_tb/uut/my_ALU_InvGenerator/reg_ctrl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {687 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 148
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
configure wave -timelineunits ns
update
WaveRestoreZoom {169 ns} {233 ns}
