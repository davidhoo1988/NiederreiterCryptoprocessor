module Mul_MultiCore(a_in, b_in, c_out);

parameter m=8;

input[m-1:0] a_in, b_in;
output[2*m-2:0] c_out;

wire[m-1:0] partial_product0_0, partial_product0_1, partial_product0_2, partial_product0_3, partial_product0_4, partial_product0_5, partial_product0_6, partial_product0_7;
wire[m:0] partial_product1_0, partial_product1_1, partial_product1_2, partial_product1_3;
wire[m+2:0] partial_product2_0, partial_product2_1;

assign partial_product0_0 = a_in & {m{b_in[0]}};
assign partial_product0_1 = a_in & {m{b_in[1]}};
assign partial_product0_2 = a_in & {m{b_in[2]}};
assign partial_product0_3 = a_in & {m{b_in[3]}};
assign partial_product0_4 = a_in & {m{b_in[4]}};
assign partial_product0_5 = a_in & {m{b_in[5]}};
assign partial_product0_6 = a_in & {m{b_in[6]}};
assign partial_product0_7 = a_in & {m{b_in[7]}};

assign partial_product1_0 = {partial_product0_1[m-1], partial_product0_1[m-2:0]^partial_product0_0[m-1:1], partial_product0_0[0]};
assign partial_product1_1 = {partial_product0_3[m-1], partial_product0_3[m-2:0]^partial_product0_2[m-1:1], partial_product0_2[0]};
assign partial_product1_2 = {partial_product0_5[m-1], partial_product0_5[m-2:0]^partial_product0_4[m-1:1], partial_product0_4[0]};
assign partial_product1_3 = {partial_product0_7[m-1], partial_product0_7[m-2:0]^partial_product0_6[m-1:1], partial_product0_6[0]};

assign partial_product2_0 = {partial_product1_1[m:m-1], partial_product1_1[m-2:0]^partial_product1_0[m:2], partial_product1_0[1:0]};
assign partial_product2_1 = {partial_product1_3[m:m-1], partial_product1_3[m-2:0]^partial_product1_2[m:2], partial_product1_2[1:0]};

assign c_out = {partial_product2_1[m+2:m-1], partial_product2_1[m-2:0]^partial_product2_0[m+2:4], partial_product2_0[3:0]};

endmodule 