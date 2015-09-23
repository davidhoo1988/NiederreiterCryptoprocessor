module MUL_DSP(
	clk,
	a,
	b,
	p
);
parameter n=16;

input wire clk;
input wire [n-1:0] a, b;
output wire [2*n-1:0] p;

//----------------------------------------------------------
// Signal Declaration
//---------------------------------------------------------- 
reg [2*n-1:0] tmp1, tmp2, tmp3;

always @(posedge clk) begin
	tmp1 <= a*b;
end
always @(posedge clk) begin
	tmp2 <= tmp1;
end
always @(posedge clk) begin
	tmp3 <= tmp2;
end

assign p = tmp3;
endmodule