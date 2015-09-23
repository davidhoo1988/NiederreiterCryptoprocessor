module Inv_Reg0(clk, rst, en, init, reg_in, reg_init, reg_out0, reg_out1);

parameter m=16;

input clk, rst, en, init;
input[m-1:0] reg_in, reg_init;
output[m-1:0] reg_out0, reg_out1;

reg ctrl;
reg[m-1:0] reg_out0, reg_out1;

always @(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		reg_out0 <= {m{1'b0}};
		reg_out1 <= {m{1'b0}};
	end
	else if(en)
	begin
	  if(init)
	    begin
	      reg_out0 <= reg_init;
	      reg_out1 <= {m{1'b0}};
	    end
	  else
	    begin
		    reg_out0 <= reg_in;
		    reg_out1 <= reg_out0;
	    end
	end
	else
	begin
		reg_out0 <= reg_out0;
		reg_out1 <= reg_out1;
	end
end

endmodule
		
		