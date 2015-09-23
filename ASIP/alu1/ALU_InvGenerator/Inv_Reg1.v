module Inv_Reg1(clk, rst, reg_in, reg_out, en, init, reg_init);

parameter m=16;//1,1,3,3,6,1

input clk, rst, en, init;
input[m-1:0] reg_in, reg_init;
output[m-1:0] reg_out;

reg[m-1:0] reg_out;

always @(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		reg_out <= {m{1'b0}};
	end
	else if(en)
	begin
		if(init)
		begin
			reg_out <= reg_init;
		end
		else
		begin
			reg_out <= reg_in;
		end
	end
end

endmodule
