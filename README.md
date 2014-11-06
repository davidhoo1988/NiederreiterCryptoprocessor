# FPGA Implementation of Goppa Code Decoder


## GF(2^m) Multiplier
Basically, we have two options for it.

- Speed Optimized: Fully Matrix Multiplication
- Speed+area tradeoff Optimized: Matrix+Karatusba Multiplication 

For example, assume we are prepared to calculate C(x) = A(x)*B(x) mod F(x). When speed is set top priority,  a specific irreducible polynomial F(x) is fixed such that we construct a new matrix Z to make C = Z*B hold where C, B is the column vector form of C(x) and B(x) and Z is exclusively related to F(x). One can observe thath this calculation can be performed in a single cycle because each entry in the C vector is independent and thus is able to be executed in parallel. 

On the other hand, if area consumption is more concerned whereas the high speed need to be preserved to some extent, we can split GF(2^m) into two halves as GF(2^{m/2}) in which we use matrix multiplication method. Furthermore, to recover GF(2^{m/2}) or to be more precise, to combine this subfield back to GF(2^m), Karatsuba-Offman multiplication is applied. In this way, we can perform GF(2^{m/2}) multiplication in one cycle and the whole GF(2^m) could be done in several， and more importantly, we use one GF(2^{m/2}) module to accomplish the GF(2^m) multiplication, which saves the circuit area definitely.

