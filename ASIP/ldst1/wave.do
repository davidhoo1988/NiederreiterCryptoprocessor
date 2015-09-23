onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /ldst_top_tb/clk
add wave -noupdate -format Logic /ldst_top_tb/rst_b
add wave -noupdate -format Logic /ldst_top_tb/ldst_o_sel
add wave -noupdate -format Logic /ldst_top_tb/ldst_t_sel
add wave -noupdate -format Literal /ldst_top_tb/ldst_typ_sel
add wave -noupdate -format Literal /ldst_top_tb/ldst_o_dat
add wave -noupdate -format Literal /ldst_top_tb/ldst_t_dat
add wave -noupdate -format Literal /ldst_top_tb/ldst_r_dat
add wave -noupdate -format Logic /ldst_top_tb/uut/clk
add wave -noupdate -format Logic /ldst_top_tb/uut/rst_b
add wave -noupdate -format Logic -itemcolor Red /ldst_top_tb/uut/ldst_o_sel
add wave -noupdate -format Logic -itemcolor Red /ldst_top_tb/uut/ldst_t_sel
add wave -noupdate -format Literal -itemcolor Red /ldst_top_tb/uut/ldst_typ_sel
add wave -noupdate -format Literal /ldst_top_tb/uut/ldst_o_dat
add wave -noupdate -format Literal /ldst_top_tb/uut/ldst_t_dat
add wave -noupdate -format Literal -itemcolor Orchid -radix hexadecimal /ldst_top_tb/uut/ldst_r_dat
add wave -noupdate -format Literal -itemcolor Orchid -radix hexadecimal /ldst_top_tb/uut/i_mem_dat
add wave -noupdate -format Literal -itemcolor Orchid -radix hexadecimal /ldst_top_tb/uut/o_mem_dat
add wave -noupdate -format Logic /ldst_top_tb/uut/dat_mem_rw
add wave -noupdate -format Logic /ldst_top_tb/uut/dat_mem_en_b
add wave -noupdate -format Literal /ldst_top_tb/uut/dat_mem_addr
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/clk
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/rst_b
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/ldst_o_sel
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/ldst_t_sel
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/ldst_o_bas_sel
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_typ_sel
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_o_dat
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_o_bas_dat
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_t_dat
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_r_dat
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/i_mem_dat
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/dat_mem_rw
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/dat_mem_en_b
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/dat_mem_addr
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/o_mem_dat
add wave -noupdate -format Literal -itemcolor Blue /ldst_top_tb/uut/Uldst/trg_typ_reg
add wave -noupdate -format Literal -itemcolor Blue -radix hexadecimal /ldst_top_tb/uut/Uldst/trg_reg
add wave -noupdate -format Literal -itemcolor Blue -radix hexadecimal /ldst_top_tb/uut/Uldst/st_o_reg
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_o_bias_reg
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_addr_bias
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/ld_dat_sel
add wave -noupdate -format Logic /ldst_top_tb/uut/Uldst/ld_dat_sel1
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/counter
add wave -noupdate -format Literal /ldst_top_tb/uut/Uldst/ldst_addr
add wave -noupdate -format Literal /ldst_top_tb/uut/Usingle_ram/addr
add wave -noupdate -format Logic /ldst_top_tb/uut/Usingle_ram/clk
add wave -noupdate -format Literal /ldst_top_tb/uut/Usingle_ram/din
add wave -noupdate -format Literal /ldst_top_tb/uut/Usingle_ram/dout
add wave -noupdate -format Logic /ldst_top_tb/uut/Usingle_ram/en
add wave -noupdate -format Logic /ldst_top_tb/uut/Usingle_ram/we
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {197 ns} 0}
configure wave -namecolwidth 302
configure wave -valuecolwidth 245
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
WaveRestoreZoom {175 ns} {215 ns}
