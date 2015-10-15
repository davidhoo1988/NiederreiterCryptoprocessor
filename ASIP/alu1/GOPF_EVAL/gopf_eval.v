module GOPF_EVAL (
	//input
	clk,
	rst_b,
	start,
	sigma_poly,
	
	//output
	eval_r_dat,
	eval_done,
	
	//output to MUL_ARRAY
	mul1_o_out,
	mul2_o_out,
	mul3_o_out,
	mul4_o_out,
	mul5_o_out,
	mul6_o_out,
	mul7_o_out,
	mul8_o_out,
	mul9_o_out,

	mul1_t_out,
	mul2_t_out,
	mul3_t_out,
	mul4_t_out,
	mul5_t_out,
	mul6_t_out,
	mul7_t_out,
	mul8_t_out,
	mul9_t_out,	

	mul1_add_out,
	mul2_add_out,
	mul3_add_out,
	mul4_add_out,
	mul5_add_out,
	mul6_add_out,
	mul7_add_out,
	mul8_add_out,
	mul9_add_out,

	//input from MAC_ARRAY
	mul1_r_dat,
	mul2_r_dat,
	mul3_r_dat,
	mul4_r_dat,
	mul5_r_dat,
	mul6_r_dat,
	mul7_r_dat,
	mul8_r_dat,
	mul9_r_dat
);

parameter m = 16,
		  poly_len = 144,
		  block_size = 10;

//----------------------------------------------------------
// Ports Declaration
//---------------------------------------------------------- 
input wire 						clk, rst_b;
input wire 						start;
input wire 	[0:poly_len] 		sigma_poly;

output wire [0:poly_len-1] 			eval_r_dat;
output reg 							eval_done;

output wire [0:m-1]		mul1_o_out,	mul2_o_out,	mul3_o_out,
						mul4_o_out,	mul5_o_out,	mul6_o_out,
						mul7_o_out,	mul8_o_out,	mul9_o_out;

output wire [0:m-1]		mul1_t_out,	mul2_t_out,	mul3_t_out,
						mul4_t_out,	mul5_t_out,	mul6_t_out,
						mul7_t_out,	mul8_t_out,	mul9_t_out;	

output wire [0:m-1] 	mul1_add_out, mul2_add_out, mul3_add_out,
						mul4_add_out, mul5_add_out, mul6_add_out,
						mul7_add_out, mul8_add_out, mul9_add_out;

input wire 	[0:m-1]		mul1_r_dat,	mul2_r_dat,	mul3_r_dat,
						mul4_r_dat,	mul5_r_dat,	mul6_r_dat,
						mul7_r_dat,	mul8_r_dat,	mul9_r_dat;
						
				
			
					


//----------------------------------------------------------
//  signal Declaration
//----------------------------------------------------------	
reg 	   counter_en;
reg [1:0]	counter;
reg [15:0] index;

reg [1:0]  start_buffer;


reg [0:m*block_size-1] 	sigma_poly_reg;
reg [0:poly_len-1] 		eval_r_reg;

reg [15:0] tmp_reg;

wire [0:m-1] 	constmul_o_out;
wire [0:m-1] 	constmul_r_dat;		

always @(posedge clk or negedge rst_b) begin
	if (!rst_b) 
		eval_done <= 0;
	else 
		if (index == 16'd65535 && counter == 2'd2)
			eval_done <= 1'd1;
		else
			eval_done <= 1'd0;	
end

always @(posedge clk or negedge rst_b) begin
	if (!rst_b) begin
		start_buffer <= 2'd0;
	end
	else begin
		start_buffer <= {start_buffer[1:0],start};
	end
end	

always @(posedge clk or negedge rst_b) begin
	if (!rst_b) begin
		counter_en <= 0;
	end
	else begin
		if (start_buffer == 2'b01 || eval_done) //rise, disable counter
			counter_en <= 0;
		else if (start_buffer == 2'b10) // fall, enable counter
			counter_en <= 1;
		else
			counter_en <= counter_en;		
	end
end	

always @(posedge clk) begin
	if (counter_en && counter != 2'd2)
		counter <= counter+1'd1;
	else
		counter <= 0;	 
end

always @(posedge clk or negedge rst_b) begin
	if (!rst_b)
		index <= 16'd0;	
	else if (counter_en && counter == 2'd2)	
		index <= index + 1'd1;
	else if (!counter_en)
		index <= 16'd0;
	else	
		index <= index;	
end



//first stagte pipeline
always @(posedge clk or negedge rst_b) begin
	if (!rst_b) begin
		sigma_poly_reg <= 0;
	end
	else begin
		if (start) 
			sigma_poly_reg <= {sigma_poly,15'b0};
		else if (counter == 2'd1 && index != 16'd0) //if not first time, update sigma list
			sigma_poly_reg <= {sigma_poly_reg[0:15],mul1_r_dat,mul2_r_dat,mul3_r_dat,mul4_r_dat,mul5_r_dat,mul6_r_dat,mul7_r_dat,mul8_r_dat,mul9_r_dat};	
		else 
			sigma_poly_reg <= sigma_poly_reg;
	end
end

//second stage pipeline
always @(posedge clk or negedge rst_b) begin
	if (!rst_b)
		tmp_reg <= 0;
	else if (counter == 2'd1 && index == 16'd0)
		tmp_reg <= sigma_poly_reg[0:15]^sigma_poly_reg[16:31]^sigma_poly_reg[32:47]^sigma_poly_reg[48:63]^sigma_poly_reg[64:79]^sigma_poly_reg[80:95]^sigma_poly_reg[96:111]^sigma_poly_reg[112:127]^sigma_poly_reg[128:143]^sigma_poly_reg[144:159];	
	else if (counter == 2'd1 && index != 16'd0)
		tmp_reg <= sigma_poly_reg[0:15] ^ mul1_r_dat ^ mul2_r_dat ^ mul3_r_dat ^ mul4_r_dat ^ mul5_r_dat ^ mul6_r_dat ^ mul7_r_dat ^ mul8_r_dat ^ mul9_r_dat;
end

//third stage pipeline
always @(posedge clk or negedge rst_b) begin
	if (!rst_b) begin
		eval_r_reg <= 0;
	end
	else if (start)
		eval_r_reg <= 0;
	else if (counter == 2'd2 && index == 16'd0 && tmp_reg == 16'd0) //if first time
		eval_r_reg <= {index, eval_r_reg[0:poly_len-1-m]};
	else if (counter == 2'd2 && index == 16'd65535 && mul1_r_dat == 16'd0) //if last time
		eval_r_reg <= {index, eval_r_reg[0:poly_len-1-m]};
	else if (counter == 2'd2 && index != 16'd0 && index != 16'd65535 && tmp_reg == 16'd0) //if not first time, not last time
		eval_r_reg <= {index, eval_r_reg[0:poly_len-1-m]};		
	else
		eval_r_reg <= eval_r_reg;
end




assign mul1_o_out = sigma_poly_reg[16:31];
assign mul2_o_out = sigma_poly_reg[32:47];
assign mul3_o_out = sigma_poly_reg[48:63];
assign mul4_o_out = sigma_poly_reg[64:79];
assign mul5_o_out = sigma_poly_reg[80:95];
assign mul6_o_out = sigma_poly_reg[96:111];
assign mul7_o_out = sigma_poly_reg[112:127];
assign mul8_o_out = sigma_poly_reg[128:143];
assign mul9_o_out = sigma_poly_reg[144:159];
//a^i, 0<=i<=9
/* constant value list
a^0: [1]
a^1: [0 0 0 1 0 0 0 1 1 0 1 1 1 0 0 1]
a^2: [0 1 0 0 0 1 1 1 1 0 1 0 0 1 0 0]
a^3: [1 1 1 0 0 0 1 1 0 0 1 1 1 1 1 0]
a^4: [1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 1]
a^5: [0 1 1 0 1 1 0 0 0 0 0 1 0 0 0 1]
a^6: [1 1 1 1 1 0 1 1 0 0 0 0 1 0 0 0]
a^7: [0 1 1 1 0 0 0 0 1 1 1 0 1 0 0 1]
a^8: [0 0 0 0 1 1 0 1 0 0 0 0 1 1 1 0]
a^9: [1 0 1 0 1 0 1 0 0 0 1 0 0 1 0 1]
*/
assign mul1_t_out = 	16'b0001000110111001;
assign mul2_t_out = 	16'b0100011110100100;
assign mul3_t_out = 	16'b1110001100111110;
assign mul4_t_out = 	16'b1001111101000111;
assign mul5_t_out = 	16'b0110110000010001;
assign mul6_t_out = 	16'b1111101100001000;
assign mul7_t_out = 	16'b0111000011101001;
assign mul8_t_out = 	16'b0000110100001110;
assign mul9_t_out = 	16'b1010101000100101;

assign mul1_add_out = 16'b0;
assign mul2_add_out = 16'b0;
assign mul3_add_out = 16'b0;
assign mul4_add_out = 16'b0;
assign mul5_add_out = 16'b0;
assign mul6_add_out = 16'b0;
assign mul7_add_out = 16'b0;
assign mul8_add_out = 16'b0;
assign mul9_add_out = 16'b0;



assign eval_r_dat = eval_r_reg;	


/*Constant_Multiplier cmul(
	.clk 		(clk),
	.A 			(constmul_o_out),
	.C 			(constmul_r_dat)
	);*/
endmodule

