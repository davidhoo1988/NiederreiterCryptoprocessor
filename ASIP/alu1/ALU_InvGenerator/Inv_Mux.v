module Inv_Mux(ctrl, d_0, d_1, q);

parameter m=16;

input ctrl;
input[m-1:0] d_0, d_1;
output[m-1:0] q;

wire[m-1:0] q;

assign q = (!ctrl) ? d_0 //when ctrl is 0, forward d_0 to output qx
		 : d_1;
		 
endmodule
