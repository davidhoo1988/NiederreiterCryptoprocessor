
# FPGA Implementation of Goppa Code Decoder


## GF(2^m) Multiplier
Basically, we have two options for it.

- Speed Optimized: Fully Matrix Multiplication
- Speed+area tradeoff Optimized: Matrix+Karatusba Multiplication 

For example, assume we are prepared to calculate C(x) = A(x)*B(x) mod F(x). When speed is set top priority,  a specific irreducible polynomial F(x) is fixed such that we construct a new matrix Z to make C = Z*B hold where C, B is the column vector form of C(x) and B(x) and Z is exclusively related to F(x). One can observe thath this calculation can be performed in a single cycle because each entry in the C vector is independent and thus is able to be executed in parallel. 

On the other hand, if area consumption is more concerned whereas the high speed need to be preserved to some extent, we can split GF(2^m) into two halves as GF(2^{m/2}) in which we use matrix multiplication method. Furthermore, to recover GF(2^{m/2} or to be more precise, to combine this subfield back to GF(2^m), Karatsuba-Offman multiplication is applied. In this way, we can perform GF(2^{m/2})multiplication in one cycle and the whole GF(2^m) could be done in several， and more importantly, we use one GF(2^{m/2}) module to accomplish the GF(2^m)multiplication, which saves the circuit area definitely.
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>


## Choosing Secure Parameters
To guarantee that the McEliece Crytosystem is secure, we must choose the appropriate system parameters cautiously.
Blow list a table to show how different parameters affect the system security.
- m stands for the basic field the arithmetic is undertaken, or n=2^m, the codeword size; 
- t is the maximum error correcting capability that Goppa code can offer;
- \\(\delta\\) is the extra error correcting capability, which is useful for CFS implementation;
- cost is the average number of tries for correcting a random codeword;
- \\(\sigma\\) is the average number of codewords at distance \\(t+\delta\\);
- Failure rate indicates the probability that the decoding may fail;
- LB-factor and CC-facotr are two methods for cracking McEliece Crytosystem, for example, if LB-factor is 80, that means we need a computational
complexity of 2^80 to break this cryosystem.

<table border=".5">
<tr><td>m</td><td>t</td><td>\\(\delta\\)</td><td>cost</td><td>\\(\sigma\\)</td><td>failure rate</td><td> LB-factor</td><td>CC-factor</td></tr>
<tr><td>16</td><td>8</td><td>1</td><td>40342.155480</td><td>0.180500</td><td>0.834852</td><td>88.417718</td><td>88.123587</td></tr>
<tr><td>16</td><td>8</td><td>2</td><td>40347.080736</td><td>1182.765390</td><td>0.000000</td><td>75.739844</td><td>75.445713</td></tr>
<tr><td>16</td><td>8</td><td>3</td><td>40352.006668</td><td>7045625.901845</td><td>0.000000</td><td>63.199496</td><td>62.905365</td></tr>
<tr><td>16</td><td>9</td><td>1</td><td>363129.267536</td><td>0.018048</td><td>0.982114</td><td>99.399652</td><td>99.302524</td></tr>
<tr><td>16</td><td>9</td><td>2</td><td>363179.143363</td><td>107.507719</td><td>0.000000</td><td>86.859304</td><td>86.762175</td></tr>
<tr><td>16</td><td>9</td><td>3</td><td>363229.026801</td><td>587036.943078</td><td>0.000000</td><td>74.444509</td><td>74.347380</td></tr>
<tr><td>16</td><td>10</td><td>1</td><td>3631846.851211</td><td>0.001640</td><td>0.998361</td><td>110.346121</td><td>110.477037</td></tr>
<tr><td>16</td><td>10</td><td>2</td><td>3632401.120093</td><td>8.957473</td><td>0.000129</td><td>97.931326</td><td>98.062242</td></tr>
<tr><td>16</td><td>10</td><td>3</td><td>3632955.482025</td><td>45148.419493</td><td>0.000000</td><td>85.632029</td><td>85.762945</td></tr>
<tr><td>17</td><td>8</td><td>1</td><td>40331.075979</td><td>0.361100</td><td>0.696909</td><td>94.882967</td><td>98.570929</td></tr>
<tr><td>17</td><td>8</td><td>2</td><td>40333.537762</td><td>4732.686236</td><td>0.000000</td><td>81.204994</td><td>84.892956</td></tr>
<tr><td>17</td><td>8</td><td>3</td><td>40335.999713</td><td>56388665.771731</td><td>0.000000</td><td>67.664536</td><td>71.352498</td></tr>
<tr><td>17</td><td>9</td><td>1</td><td>363004.609361</td><td>0.036108</td><td>0.964537</td><td>106.774902</td><td>111.097063</td></tr>
<tr><td>17</td><td>9</td><td>2</td><td>363029.536811</td><td>430.211378</td><td>0.000000</td><td>93.234444</td><td>97.556604</td></tr>
<tr><td>17</td><td>9</td><td>3</td><td>363054.466163</td><td>4698661.120547</td><td>0.000000</td><td>79.819527</td><td>84.141688</td></tr>
<tr><td>17</td><td>10</td><td>1</td><td>3630323.065278</td><td>0.003282</td><td>0.996723</td><td>118.631324</td><td>123.610045</td></tr>
<tr><td>17</td><td>10</td><td>2</td><td>3630600.060194</td><td>35.847939</td><td>0.000000</td><td>105.216408</td><td>110.195129</td></tr>
<tr><td>17</td><td>10</td><td>3</td><td>3630877.078358</td><td>361402.380406</td><td>0.000000</td><td>91.916980</td><td>96.895701</td></tr>
<tr><td>18</td><td>8</td><td>1</td><td>40325.537549</td><td>0.722299</td><td>0.485634</td><td>101.379256</td><td>109.860925</td></tr>
<tr><td>18</td><td>8</td><td>2</td><td>40326.768229</td><td>18933.995019</td><td>0.000000</td><td>86.701234</td><td>95.182903</td></tr>
<tr><td>18</td><td>8</td><td>3</td><td>40327.998952</td><td>451203986.398545</td><td>0.000000</td><td>72.160720</td><td>80.642390</td></tr>
<tr><td>18</td><td>9</td><td>1</td><td>362942.298580</td><td>0.072227</td><td>0.930319</td><td>114.186485</td><td>123.839350</td></tr>
<tr><td>18</td><td>9</td><td>2</td><td>362954.759690</td><td>1721.206613</td><td>0.000000</td><td>99.645972</td><td>109.298837</td></tr>
<tr><td>18</td><td>9</td><td>3</td><td>362967.221276</td><td>37598754.427150</td><td>0.000000</td><td>85.230995</td><td>94.883860</td></tr>
<tr><td>18</td><td>10</td><td>1</td><td>3629561.442581</td><td>0.006566</td><td>0.993456</td><td>126.958160</td><td>137.795843</td></tr>
<tr><td>18</td><td>10</td><td>2</td><td>3629699.905172</td><td>143.427866</td><td>0.000000</td><td>112.543183</td><td>123.380866</td></tr>
<tr><td>18</td><td>10</td><td>3</td><td>3629838.373574</td><td>2892079.484059</td><td>0.000000</td><td>98.243689</td><td>109.081372</td></tr>
<tr><td>19</td><td>8</td><td>1</td><td>40322.768665</td><td>1.444698</td><td>0.235817</td><td>107.903206</td><td>121.996353</td></tr>
<tr><td>19</td><td>8</td><td>2</td><td>40323.383952</td><td>75742.480945</td><td>0.000000</td><td>92.225159</td><td>106.318306</td></tr>
<tr><td>19</td><td>8</td><td>3</td><td>40323.999250</td><td>3610010584.090307</td><td>0.000000</td><td>76.684618</td><td>90.777765</td></tr>
<tr><td>19</td><td>9</td><td>1</td><td>362911.147765</td><td>0.144467</td><td>0.865483</td><td>121.630433</td><td>137.532609</td></tr>
<tr><td>19</td><td>9</td><td>2</td><td>362917.377667</td><td>6885.548752</td><td>0.000000</td><td>106.089892</td><td>121.992068</td></tr>
<tr><td>19</td><td>9</td><td>3</td><td>362923.607687</td><td>300827903.587836</td><td>0.000000</td><td>90.674885</td><td>106.577061</td></tr>
<tr><td>19</td><td>10</td><td>1</td><td>3629180.698779</td><td>0.013133</td><td>0.986953</td><td>135.322067</td><td>153.038121</td></tr>
<tr><td>19</td><td>10</td><td>2</td><td>3629249.921360</td><td>573.783691</td><td>0.000000</td><td>119.907059</td><td>137.623114</td></tr>
<tr><td>19</td><td>10</td><td>3</td><td>3629319.145393</td><td>23140078.321811</td><td>0.000000</td><td>104.607532</td><td>122.323586</td></tr>
<tr><td>20</td><td>8</td><td>1</td><td>40321.384305</td><td>2.889495</td><td>0.055604</td><td>114.451954</td><td>134.979487</td></tr>
<tr><td>20</td><td>8</td><td>2</td><td>40321.691935</td><td>302982.926236</td><td>0.000000</td><td>97.773894</td><td>118.301427</td></tr>
<tr><td>20</td><td>8</td><td>3</td><td>40321.999568</td><td>28881599548.346096</td><td>0.000000</td><td>81.233340</td><td>101.760872</td></tr>
<tr><td>20</td><td>9</td><td>1</td><td>362895.573501</td><td>0.288947</td><td>0.749052</td><td>129.103384</td><td>152.179457</td></tr>
<tr><td>20</td><td>9</td><td>2</td><td>362898.688289</td><td>27543.639706</td><td>0.000000</td><td>112.562830</td><td>135.638902</td></tr>
<tr><td>20</td><td>9</td><td>3</td><td>362901.803106</td><td>2406774714.025777</td><td>0.000000</td><td>96.147807</td><td>119.223880</td></tr>
<tr><td>20</td><td>10</td><td>1</td><td>3628990.343762</td><td>0.026268</td><td>0.974074</td><td>143.719188</td><td>169.339854</td></tr>
<tr><td>20</td><td>10</td><td>2</td><td>3629024.952874</td><td>2295.279230</td><td>0.000000</td><td>127.304165</td><td>152.924831</td></tr>
<tr><td>20</td><td>10</td><td>3</td><td>3629059.562349</td><td>185134397.744232</td><td>0.000000</td><td>111.004622</td><td>136.625288</td></tr>
<tr><td></td></tr>
</table>



## Crypto-Coprocessor Architecture
### Single Instruction Single Datastream (SISD Version)
#### Instruction Set
We list below the operations that are allowed in our processor, that is, addition, subtraction and multiplication for two integer operands.
<table border=".5">
<caption><em>Instruction type</em></caption>
<tr><th>Microcode</th> <th>Instruction</th> <th>Illustration</th></tr>
<tr><td>1001</td> <td>ADD</td> <td>Add two integers located in register or memory</td></tr>
<tr><td>1010</td> <td>SUB</td> <td>Subtract two integers located in register or memory</td></tr>
<tr><td>1011</td> <td>MUL</td> <td>Multiply two integers located in register or memory</td></tr>
</table>

<table border=".5">
<caption><em>Instruction format for two register operands</em></caption>
<tr><th colspan="4">Reg[19:16]<th colspan="4">Reg[15:12]<th colspan="4">Reg[11:8]<th colspan="4">Reg[7:4]<th colspan="4">Reg[3:0]
<tr><td>19<td>18<td>17<td>16<td>15<td>14<td>13<td>12<td>11<td>10<td>9<td>8<td>7<td>6<td>5<td>4<td>3<td>2<td>1<td>0
<tr><td>  <td>  <td>  <td>  <td> 1<td colspan="3"> ALU<br>control code<td colspan="4"> Register-1 address<br>(Destination)<td colspan="4"> Register-2 address<td colspan="4"> NULL
</table>

<table border=".5">
<caption><em>Instruction format for register-memory operands</em></caption>
<tr><th colspan="4">Reg[19:16]<th colspan="4">Reg[15:12]<th colspan="4">Reg[11:8]<th colspan="4">Reg[7:4]<th colspan="4">Reg[3:0]
<tr><td>19<td>18<td>17<td>16<td>15<td>14<td>13<td>12<td>11<td>10<td>9<td>8<td>7<td>6<td>5<td>4<td>3<td>2<td>1<td>0
<tr><td>  <td>  <td>  <td>  <td> 0<td colspan="3"> ALU<br>control code<td colspan="4"> Register-1 address<br>(Destination)<td colspan="8"> Memory address
</table>