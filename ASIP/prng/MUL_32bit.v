module MUL_32bit (
clk, 
multiplicand,
multiplier, 
result
);
parameter n = 32;

input wire clk;
input wire [n-1:0] multiplicand, multiplier;
output reg [2*n-1:0] result;

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
wire [n-1:0]	z0,z1,z2, z1_tmp;

reg  [n/2-1:0]  AHALAdd, BHBLAdd;

reg  [n-1:0]	z0_reg0, z2_reg0;
reg  [n-1:0]	z0_reg1, z1_reg1, z2_reg1;

//ISE template or Modelsim template
MUL_DSP my_MUL_IPCore0 (
  .clk(clk), // input clk
  .a(multiplicand[n-1:n/2]), // input [15 : 0] a
  .b(multiplier[n-1:n/2]), // input [15 : 0] b
  .p(z2) // output [31 : 0] p
);

MUL_DSP my_MUL_IPCore1 (
  .clk(clk), // input clk
  .a(multiplicand[n/2-1:0]), // input [15 : 0] a
  .b(multiplier[n/2-1:0]), // input [15 : 0] b
  .p(z0) // output [31 : 0] p
);

MUL_DSP my_MUL_IPCore2 (
  .clk(clk), // input clk
  .a(AHALAdd), // input [15 : 0] a
  .b(BHBLAdd), // input [15 : 0] b
  .p(z1_tmp) // output [31 : 0] p
);

/*
//Vivado template
MUL_DSP my_MUL_IPCore0 (
  .CLK(clk), // input clk
  .A(multiplicand[n-1:n/2]), // input [15 : 0] a
  .B(multiplier[n-1:n/2]), // input [15 : 0] b
  .P(z2) // output [31 : 0] p
);

MUL_DSP my_MUL_IPCore1 (
  .CLK(clk), // input clk
  .A(multiplicand[n/2-1:0]), // input [15 : 0] a
  .B(multiplier[n/2-1:0]), // input [15 : 0] b
  .P(z0) // output [31 : 0] p
);

MUL_DSP my_MUL_IPCore2 (
  .CLK(clk), // input clk
  .A(AHALAdd), // input [15 : 0] a
  .B(BHBLAdd), // input [15 : 0] b
  .P(z1_tmp) // output [31 : 0] p
);
*/
assign z1 = z1_tmp - z0_reg0 - z2_reg0;


always@(posedge clk)
begin
	AHALAdd <= multiplicand[n-1:n/2] + multiplicand[n/2-1:0];
end

always@(posedge clk)
begin
	BHBLAdd <= multiplier[n-1:n/2] + multiplier[n/2-1:0];
end

always@(posedge clk)
begin
	z0_reg0 <= z0;
end

always@(posedge clk)
begin
	z0_reg1 <= z0_reg0;
end

always@(posedge clk)
begin
	z1_reg1 <= z1;
end

always@(posedge clk)
begin
	z2_reg0 <= z2;
end

always@(posedge clk)
begin
	z2_reg1 <= z2_reg0;
end

always@(posedge clk)
begin
	result <= {{32'b0, z0_reg1[n-1:n/2]} + {16'b0,z1_reg1} + {z2_reg1,16'b0}, z0_reg1[n/2-1:0]};
end


endmodule
