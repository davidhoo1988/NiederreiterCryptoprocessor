module Mul_ModularX8(D_in, Q_out);

parameter m=16;

input[m-1:0] D_in;
output[m-1:0] Q_out;

assign Q_out ={D_in[7:5],
					D_in[4:3] ^ D_in[15:14],
					D_in[2] ^ D_in[13] ^ D_in[15],
					D_in[1:0] ^ D_in[12:11] ^ D_in[14:13] ^ D_in[15:14],
					D_in[10:8] ^ D_in[12:10] ^ D_in[13:11] ^ D_in[15:13],
					D_in[9:8] ^ D_in[10:9] ^ D_in[12:11],
					D_in[8] ^ D_in[10],
					D_in[9:8]};
					
endmodule 