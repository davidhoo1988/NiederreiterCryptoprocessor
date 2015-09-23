module Inv_Exp(d, q, ctrl);

parameter m=16;//1,1,3,3,6,1

input[1:0] ctrl;
input[m-1:0] d;
output[m-1:0] q;
//output[0:m-1] exp1, exp3, exp6;

wire[m-1:0] q;
wire[m-1:0] exp1, exp3, exp6; 

//exp_1
//[1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1] x^0
//[0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1]
//[0 1 0 0 0 0 0 0 1 1 0 0 0 0 0 1]
//[0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 1]
//[0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 1]
//[0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0]
//[0 0 0 1 0 0 0 0 0 0 1 1 0 0 1 0]
//[0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0]
//[0 0 0 0 1 0 0 0 0 0 0 1 1 0 0 1]
//[0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0]
//[0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0]
//[0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0]
//[0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0]
//[0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0]
//[0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1]
//[0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0] x^15

assign exp1[m-1:0] = {
						d[13] ^ d[14] ,
						d[ 7] ^ d[14] ^ d[15] ,
						d[12] ^ d[13] ,
						d[ 6] ^ d[13] ^ d[14] ,
						d[11] ^ d[12] ,
						d[ 5] ^ d[12] ^ d[13] ,
						d[10] ^ d[11] ,
						d[ 4] ^ d[11] ^ d[12] ^ d[15] ,
						d[ 9] ^ d[10] ,
						d[ 3] ^ d[10] ^ d[11] ^ d[14] ,
						d[ 8] ^ d[ 9] ,
						d[ 2] ^ d[ 9] ^ d[10] ^ d[14] ^ d[15] ,
						d[ 8] ^ d[14] ^ d[15] ,
						d[ 1] ^ d[ 8] ^ d[ 9] ^ d[15] ,
						d[14] ^ d[15] ,
						d[ 0] ^ d[ 8] ^ d[15]};

//exp_3
//[1 0 1 0 1 0 1 1 1 1 1 0 1 0 1 0] x^0
//[0 0 0 0 0 0 0 0 0 1 1 0 1 0 1 0]
//[0 0 1 0 0 1 1 0 0 1 1 0 0 1 0 1]
//[0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 1]
//[0 0 0 0 1 1 1 0 1 0 0 1 1 0 0 0]
//[0 0 1 0 0 1 1 0 0 1 1 0 1 1 1 1]
//[0 0 0 0 1 0 0 0 1 0 1 0 1 1 0 1]
//[0 0 0 0 0 1 1 0 1 1 0 1 1 1 1 0]
//[0 1 0 1 0 1 1 1 1 1 0 1 0 1 0 0]
//[0 0 0 0 0 0 0 0 1 1 0 1 0 1 0 0]
//[0 0 0 1 1 0 1 1 0 0 0 1 1 1 1 0]
//[0 0 0 1 0 0 1 1 0 0 1 0 0 0 1 1]
//[0 0 0 0 0 1 1 0 1 1 1 1 1 0 1 1]
//[0 0 0 1 0 0 1 1 0 0 1 1 0 1 1 1]
//[0 0 0 0 0 1 0 0 0 1 0 1 0 1 1 0]
//[0 0 0 0 0 0 1 1 0 1 1 0 1 1 1 1] x^15

assign exp3[m-1:0] = {
            d[ 6] ^ d[ 7] ^ d[ 9] ^ d[10] ^ d[12] ^ d[13] ^ d[14] ^ d[15],
            d[ 5] ^ d[ 9] ^ d[11] ^ d[13] ^ d[14] ,
            d[ 3] ^ d[ 6] ^ d[ 7] ^ d[10] ^ d[11] ^ d[13] ^ d[14] ^ d[15] ,
            d[ 5] ^ d[ 6] ^ d[ 8] ^ d[ 9] ^ d[10] ^ d[11] ^ d[12] ^ d[14] ^ d[15] ,
            d[ 3] ^ d[ 6] ^ d[ 7] ^ d[10] ^ d[14] ^ d[15] ,
            d[ 3] ^ d[ 4] ^ d[ 6] ^ d[ 7] ^ d[11] ^ d[12] ^ d[13] ^ d[14] ,
            d[ 8] ^ d[ 9] ^ d[11] ^ d[13] ,
            d[ 1] ^ d[ 3] ^ d[ 5] ^ d[ 6] ^ d[ 7] ^ d[ 8] ^ d[ 9] ^ d[11] ^ d[13] ,
            d[ 5] ^ d[ 6] ^ d[ 8] ^ d[ 9] ^ d[11] ^ d[12] ^ d[13] ^ d[14] ,
            d[ 4] ^ d[ 8] ^ d[10] ^ d[12] ^ d[13] ^ d[15] ,
            d[ 2] ^ d[ 5] ^ d[ 6] ^ d[ 9] ^ d[10] ^ d[12] ^ d[13] ^ d[14] ^ d[15] ,
            d[ 4] ^ d[ 5] ^ d[ 6] ^ d[ 8] ^ d[11] ^ d[12] ,
            d[ 2] ^ d[ 6] ^ d[11] ^ d[15] ,
            d[ 2] ^ d[ 5] ^ d[ 6] ^ d[ 9] ^ d[10] ^ d[13] ^ d[15] ,
            d[ 9] ^ d[10] ^ d[12] ^ d[14] ,
            d[ 0] ^ d[ 2] ^ d[ 4] ^ d[ 6] ^ d[ 7] ^ d[ 8] ^ d[ 9] ^ d[10] ^ d[12] ^ d[14]};
						
//exp_6
//[1 1 0 0 0 0 1 1 1 1 0 1 0 1 1 1] x^0
//[0 0 0 1 1 0 0 1 0 1 1 0 0 1 1 1]
//[0 0 0 0 0 0 1 1 0 0 1 1 0 1 0 1]
//[0 0 1 1 1 1 1 0 1 0 0 0 0 1 0 0]
//[0 1 1 0 0 0 1 0 0 1 0 1 0 1 1 0]
//[0 0 0 0 0 0 0 1 1 0 0 1 1 0 0 0]
//[0 1 0 1 0 1 0 0 1 1 1 1 0 0 0 1]
//[0 1 1 1 1 0 1 1 0 1 1 1 1 0 1 1]
//[0 1 0 1 1 1 0 1 0 1 1 1 0 0 1 1]
//[0 1 0 1 0 1 1 1 0 0 0 1 0 1 0 0]
//[0 0 1 0 0 0 0 0 0 1 0 0 0 0 1 1]
//[0 0 1 1 0 0 0 0 0 1 0 0 0 1 0 1]
//[0 1 1 1 0 0 0 0 0 0 1 1 1 1 0 1]
//[0 0 1 1 0 0 0 0 0 1 0 1 0 0 0 1]
//[0 0 1 0 0 0 1 0 1 1 1 1 1 0 0 1]
//[0 0 0 0 0 1 1 1 0 1 0 0 1 1 0 0] x^15

assign exp6[m-1:0] = {
            d[ 5] ^ d[ 6] ^ d[ 7] ^ d[ 9] ^ d[12] ^ d[13],
            d[ 2] ^ d[ 6] ^ d[ 8] ^ d[ 9] ^ d[10] ^ d[11] ^ d[12] ^ d[15] ,
            d[ 2] ^ d[ 3] ^ d[ 9] ^ d[11] ^ d[15] ,
            d[ 1] ^ d[ 2] ^ d[ 3] ^ d[10] ^ d[11] ^ d[12] ^ d[13] ^ d[15] ,
            d[ 2] ^ d[ 3] ^ d[ 9] ^ d[13] ^ d[15] ,
            d[ 2] ^ d[ 9] ^ d[14] ^ d[15] ,
            d[ 1] ^ d[ 3] ^ d[ 5] ^ d[ 6] ^ d[ 7] ^ d[11] ^ d[13] ,
            d[ 1] ^ d[ 3] ^ d[ 4] ^ d[ 5] ^ d[ 7] ^ d[ 9] ^ d[10] ^ d[11] ^ d[14] ^ d[15] ,
            d[ 1] ^ d[ 2] ^ d[ 3] ^ d[ 4] ^ d[ 6] ^ d[ 7] ^ d[ 9] ^ d[10] ^ d[11] ^ d[12] ^ d[14] ^ d[15] ,
            d[ 1] ^ d[ 3] ^ d[ 5] ^ d[ 8] ^ d[ 9] ^ d[10] ^ d[11] ^ d[15] ,
            d[ 7] ^ d[ 8] ^ d[11] ^ d[12] ,
            d[ 1] ^ d[ 2] ^ d[ 6] ^ d[ 9] ^ d[11] ^ d[13] ^ d[14] ,
            d[ 2] ^ d[ 3] ^ d[ 4] ^ d[ 5] ^ d[ 6] ^ d[ 8] ^ d[13] ,
            d[ 6] ^ d[ 7] ^ d[10] ^ d[11] ^ d[13] ^ d[15] ,
            d[ 3] ^ d[ 4] ^ d[ 7] ^ d[ 9] ^ d[10] ^ d[13] ^ d[14] ^ d[15] ,
            d[ 0] ^ d[ 1] ^ d[ 6] ^ d[ 7] ^ d[ 8] ^ d[ 9] ^ d[11] ^ d[13] ^ d[14] ^ d[15]};

assign q = (ctrl == 2'b00) ? exp1
			: (ctrl == 2'b01) ? exp3
			: exp6;
					
endmodule