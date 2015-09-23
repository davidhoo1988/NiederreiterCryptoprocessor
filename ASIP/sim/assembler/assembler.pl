#! /usr/bin/perl
use warnings;


#---------------------------------------------------------------------
# input your assembly code
#---------------------------------------------------------------------
if ( !open SOURCE_CODE, '<', 'program.txt'){
	die "Cannot find source code file: $!";
}

if ( -e 'program.asm'){
	unlink 'program.asm';
}

if ( -e '../mem_data/program.asm'){
	unlink '../mem_data/program.asm';
}

if ( !open ASM_CODE, '>>', '../mem_data/program.asm'){
	die "Cannot create asm file: $!";
}

#---------------------------------------------------------------------
# parse assembly code for the first time, to extract label constant.
#---------------------------------------------------------------------
my $current_linenum = 0;
my $multiple_comment_enable = 0;
my %label_hash;
while (<SOURCE_CODE>){
	chomp;
	# cut comments off
	s/\/\/.*//g;
	if (m/\/\*.*\*\//){
		s/\/\*.*\*\///g;
	}
	elsif (m/\/\*.*$/){
		s/\/\*.*$//g;
		$multiple_comment_enable = 1;
	}
	elsif (m/^.*\*\//){
		s/^.*\*\///g;
		$multiple_comment_enable = 0;
	}
	elsif ($multiple_comment_enable == 1){
		s/^.*$//g;
	}
	
	# if it is blank, cut it off.
	if (m/^$/ or m/^\s+$/){ 
		next;
	}
	
	# parsing constant label:
	if (m/^\s*(\w+):/){
		#print "label captured: $1";
		$label_hash{$1} = $current_linenum;
	}
	$current_linenum++;
}
#print %label_hash;
close SOURCE_CODE;



#---------------------------------------------------------------------
# parse assembly code for the second time, 
# to convert assembly into binaries.
#---------------------------------------------------------------------
$multiple_comment_enable = 0;

if ( !open SOURCE_CODE, '<', 'program.txt'){
	die "Cannot find source code file: $!";
}
# parsing assembly code
while (<SOURCE_CODE>){
	chomp;
	# cutting off comments part, supporting c++ like comments, e.g. // and /**/
	s/\/\/.*//g;
	if (m/\/\*.*\*\//){
		s/\/\*.*\*\///g;
		
	}
	elsif (m/\/\*.*$/){
		s/\/\*.*$//g;
		$multiple_comment_enable = 1;
	}
	elsif (m/^.*\*\//){
		s/^.*\*\///g;
		$multiple_comment_enable = 0;
	}
	elsif ($multiple_comment_enable == 1){
		s/^.*$//g;
	}
	# if it is blank, cut it off.
	if (m/^$/ or m/^\s+$/){
		next;
	}
	
	# cutting off constant label:
	s/^\s*\w+://g;
	#print "real codes: $_\n";
	# parsing real source codes
	if (m/^\s*+(\w+)\s*$/){ # it is 'HALT'?
		if ($1 eq 'HALT'){
			printf ASM_CODE "%043b\n", '0';
		}
		else {
			printf ASM_CODE "%s", "Pattern not found.\n";
			next;
		}
	}
	elsif (m/^\s*(?<op_typ>MOV|ADD|SUB|MUL|DIV|INV|SPLIT|DEG|RSHIFT|EVAL)\s+(?<src_typ>R|\@IDX|#)(?<src_val>((\d+)|(0x[0-9a-f]+)|(0b[01]+)))\s+(?<dst_typ>R|IDX|\@IDX)(?<dst_val>((\d+)|(0x[0-9a-f]+)|(0b[01]+)))\s*$/){ 
	# if it is sequential instructions, e.g. MOV, ADD, SUB, MUL, DIV, INV, SPLIT, DEG, RSHIFT
		# parse operand code
		if ($+{op_typ} eq 'MOV'){
			$opr_code = sprintf("%05b", 1);
		}
		elsif ($+{op_typ} eq 'ADD'){
			$opr_code = sprintf("%05b", 2);
		}
		elsif ($+{op_typ} eq 'SUB'){
			$opr_code = sprintf("%05b", 3);
		}
		elsif ($+{op_typ} eq 'MUL'){
			$opr_code = sprintf("%05b", 4);
		}
		elsif ($+{op_typ} eq 'DIV'){
			$opr_code = sprintf("%05b",5);
		}
		elsif ($+{op_typ} eq 'INV'){
			$opr_code = sprintf("%05b",8);
		}
		elsif ($+{op_typ} eq 'SPLIT'){
			$opr_code = sprintf("%05b",9);
		}
		elsif ($+{op_typ} eq 'DEG'){
			$opr_code = sprintf("%05b",10);
		}
		elsif ($+{op_typ} eq 'RSHIFT'){
			$opr_code = sprintf("%05b",11);
		}
		else {
			printf ASM_CODE "%s", "Pattern not found.\n";
			next;
		}	
		# parse src code
		if ($+{src_typ} eq "\@IDX"){ # indirect memory addr
			
			if ($+{src_val} =~ /^(\d+)$/){
				$src_code = sprintf("101%016b", $1+32);
			}
		}
		elsif ($+{src_typ} eq "#"){ # immediate data
			if ($+{src_val} =~ /^(\d+)$/){
				$src_code = sprintf("010%016b", $1);
			}
			elsif ($+{src_val} =~ /^0x([0-9A-Fa-f]+)$/){
				
				$src_code = sprintf("010%016b", hex($1));
			}
			else{
				$+{src_val} =~ /^0b([01]+)$/;
				$src_code = sprintf("010%016b", oct("0b".$1));
			}	
		}
		elsif ($+{src_typ} eq "R"){ # register
			if ($+{src_val} =~ /^(\d+)$/){
				$src_code = sprintf("000%016b", $1);
			}
			elsif ($+{src_val} =~ /^0x([0-9A-Fa-f]+)$/){
				$src_code = sprintf("000%016b", hex($1));
			}
			else{
				$+{src_val} =~ /^0b([01]+)$/;
				$src_code = sprintf("000%016b", oct("0b".$1));
			}	
		}
		else {
			printf ASM_CODE "%s", "Pattern not found.\n";
			next;
		}
		# parse dst code
		if ($+{dst_typ} eq "\@IDX"){ # indirect register referencing
			if ($+{dst_val} =~ /^(\d+)$/){
				$dst_code = sprintf("101%016b", $1+32);
			}
			elsif ($+{dst_val} =~ /^0x([0-9A-Fa-f]+)$/){
				$dst_code = sprintf("001%016b", hex($1));
			}
			else{
				$+{dst_val} =~ /^0b([01]+)$/;
				$dst_code = sprintf("001%016b", oct("0b".$1));
			}	
		}
		elsif ($+{dst_typ} eq 'R'){ # register
			if ($+{dst_val} =~ /^(\d+)$/){
				$dst_code = sprintf("000%016b", $1);
			}
			elsif ($+{dst_val} =~ /^0x([0-9A-Fa-f]+)$/){
				$dst_code = sprintf("000%016b", hex($1));
			}
			else{
				$+{dst_val} =~ /^0b([01]+)$/;
				$dst_code = sprintf("000%016b", oct("0b".$1));
			}	
		}
		elsif ($+{dst_typ} eq "IDX"){ #SPRF register
			if ($+{dst_val} =~ /^(\d+)$/){
				$dst_code = sprintf("000%016b", $1+32);
			}	
		}
		else {
			printf ASM_CODE "%s", "Pattern not found.\n";
			next;
		}
		
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}
	#Rmod related instructions
	elsif (m/^\s*DIV\s+Rmod\s+R(\d+)\s*$/){  #DIV Rmod Rx
		$opr_code = sprintf("%05b", 5);
		$src_code = sprintf("100%016b", 0);
		$dst_code = sprintf("000%016b",$1);
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}

	elsif (m/^\s*MOV\s+\@IDX(\d+)\s+Rmod\s*$/){ #MOV @IDX Rmod
		$opr_code = sprintf("%05b", 1);
		$src_code = sprintf("101%016b", $1+32);
		$dst_code = sprintf("100%016b",0);
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}

	elsif (m/^\s*MOV\s+R(\d+)\s+Rmod\s*$/){ #MOV Rx Rmod
		$opr_code = sprintf("%05b",1);
		$src_code = sprintf("000%016b",$1);
		$dst_code = sprintf("100%016b",0);
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}

	elsif (m/^\s*EVAL\s+Rmod\s+R(\d+)\s*$/){ #EVAL Rmod Rx
		$opr_code = sprintf("%05b",12);
		$src_code = sprintf("100%016b",0);
		$dst_code = sprintf("000%016b",$1);
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}
	
	elsif (m/^\s*JMP\s+@(\w+)\s*$/){ #if it is unconditional jump
		$opr_code = sprintf("%05b", 16);
		if (exists $label_hash{$1}){
			$src_code = sprintf("%019b",0);
			$dst_code = sprintf("%019b", $label_hash{$1}); 
		}
		else {
			printf ASM_CODE "%s", "Pattern not found.\n";
			next;
		}
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;	
	}
	
	elsif (m/^\s*JRE\s+IDX(\d+)\s+@(\w+)\s*$/){ #if it is conditional jump
		$opr_code = sprintf("%05b", 17);
		if (exists $label_hash{$2}){
			$src_code = sprintf("000%016b",$1+32);
			$dst_code = sprintf("%019b", $label_hash{$2}); 
		}
		else {
			printf ASM_CODE "%s", "Pattern not found.\n";
			next;
		}
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}

	elsif (m/^\s*PRNG\s+R(\d+)\s*$/){ #if it is PRNG Rx
			$opr_code = sprintf("%05b",6);
			$src_code = sprintf("%019b",0);
			$dst_code = sprintf("000%016b",$1);
			printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}

	elsif (m/^\s*PRNG\s+#(?<imm_val>((\d+)|(0x[0-9a-f]+)|(0b[01]+)))\s+R(?<reg_no>\d+)\s*$/){ # if it is PRNG #imm Rx
			$opr_code = sprintf("%05b",6);
			$dst_code = sprintf("000%016b", $+{reg_no});

			if ($+{imm_val} =~ /^(\d+)$/){
				$src_code = sprintf("010%016b", $1);
			}
			elsif ($+{imm_val} =~ /^0x([0-9A-Fa-f]+)$/){
				$src_code = sprintf("010%016b", hex($1));
			}
			else{
				$+{imm_val} =~ /^0b([01]+)$/;
				$src_code = sprintf("010%016b", oct("0b".$1));
			}	
			printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;			
	}

	elsif (m/^\s*IDX(?<idx_no>\d+)\s*(?<idx_typ>\+\+|--)/){ #if it is IDX++ or IDX--
		$opr_code = sprintf("%05b",7);
		$src_code = sprintf("%019b",0);
		my $IdxNo = $+{idx_no};
		if ($+{idx_typ} =~ /\+\+/){
			$dst_code = sprintf("000%016b", $IdxNo+32);	
		}
		elsif ($+{idx_typ} =~ /--/){
			$dst_code = sprintf("001%016b", $IdxNo+32);
		}
		printf ASM_CODE "%s%s%s\n", $opr_code, $src_code, $dst_code;
	}	

	else {
		printf ASM_CODE "%s", "Pattern not found.\n";
	}

}

#---------------------------------------------------------------------
# close file handlers
#---------------------------------------------------------------------
close SOURCE_CODE;
close ASM_CODE;


