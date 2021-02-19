#!/usr/bin/perl

use strict;
use warnings;


## This script is used to analyze the SDs based on Mummer alignment results

## Step1: format Mummer results into bed file and combined individual chr into one single chr bed file, chr1.allSD.bed.1k 

my @coords=glob("*.coords");

foreach my $each (@coords){
	open IN, "$each" or die $!;
	open OUT, ">$each.bed";
	while (<IN>) {
		next if (/^\// or /\[/ or /\=/ or /^$/ or /^NUCMER/);
		s/\|//g;
		s/^\s+//;
		s/\s+/\t/g;
		my @arr=split("\t",$_);
		print OUT "$arr[7]\t$arr[0]\t$arr[1]\t$arr[8]\t$arr[2]\t$arr[3]\t$arr[4]\t$arr[5]\t$arr[6]\n";
	}
	close IN;
	close OUT;
}

for (my $chr = 1; $chr < 20; $chr++) {
	my @allbed=glob("$chr.*.f.1k.coords.bed");
	open OUT, ">$chr.allSD.bed.1k";
	foreach my $each (@allbed){
		open IN, "$each" or die $!;
		while (<IN>) {
			chomp;
			my $line=$_;
			my @arr=split("\t",$line);
			if ($arr[0] eq $arr[3]) { # remove intrachromosome SDs
				next;
			}
			elsif ($arr[6]>=1000) {
				print OUT "$line\n";
			}
		}
		close IN;
	}
	close OUT;
}


## Step2: remove redudant records to find the exact number of SDs on each chromosomes 

for (my $chr = 1; $chr < 20; $chr++) {
		`sort -n -k 2 $chr.allSD.bed.1k > $chr.allSD.bed.1k.sort`;
		open IN, "$chr.allSD.bed.1k.sort" or die $!;
		open OUT, ">$chr.allSD.bed.1k.sort.rm";
		my @whole=<IN>;
		my $first=shift @whole;
		my @tmp=split("\t",$first);
		#my $chr=$tmp[0];
		my $start=$tmp[1];
		my $end=$tmp[2];
		my $len=$tmp[2]-$tmp[1];
		print OUT "$first";
		foreach my $each (@whole){
			my @arr=split("\t",$each);
			if ($arr[1] >= $start and $arr[1] <=$end) {
				my $tmp_len=$arr[2]-$arr[1];
				my $ratio=$tmp_len/$len;
				if ($ratio>0.5) { ## if the overlapped regions is about 50% we treat them as same SD and maintain only one 
					next;
				}
			}
			else{
				print OUT "$each";
				$start=$arr[1];
				$end=$arr[2];
				$len=$arr[2]-$arr[1];
			}
		}
		close IN;
		close OUT;	
}

## remove redudant records on other chromosomes

for (my $chr = 1; $chr < 20; $chr++) {
	    `sort -n -k4,4 -k5,5 $chr.allSD.bed.1k >$chr.allSD.bed.1k.sortbyOther`;
		open IN, "$chr.allSD.bed.1k.sortbyOther" or die $!;
		open OUT, ">$chr.allSD.bed.1k.sortbyOther.rm";
		my @whole=<IN>;
		my $first=shift @whole;
		my @tmp=split("\t",$first);
		my $chr=$tmp[3];
		my $start;
		my $end;
		if ($tmp[4]<=$tmp[5]) {
			$start=$tmp[4];
			$end=$tmp[5]
		}
		else{
			$start=$tmp[5];
			$end=$tmp[4];
		}
		my $len=$end-$start;
		print OUT "$first";
		foreach my $each (@whole){
			my @arr=split("\t",$each);
			if ($arr[3]==$chr) {
				if ($arr[4]<=$arr[5]) {
					if ($arr[4] >= $start and $arr[4] <=$end) {
						my $tmp_len=$arr[5]-$arr[4];
						my $ratio=$tmp_len/$len;
						if ($ratio>0.5) { ## if the overlapped regions is about 50% we treat them as same SD and maintain only one 
							next;
						}
					}
					else{
						print OUT "$each";
						$start=$arr[4];
						$end=$arr[5];
						$len=$arr[5]-$arr[4];
					}
				}
				elsif ($arr[4]>$arr[5]) {
					if ($arr[5] >= $start and $arr[5] <=$end) {
						my $tmp_len=$arr[4]-$arr[5];
						my $ratio=$tmp_len/$len;
						if ($ratio>0.5) { ## if the overlapped regions is about 50% we treat them as same SD and maintain only one 
							next;
						}
					}
				}
				else{
					print OUT "$each";
					$start=$arr[5];
					$end=$arr[4];
					$len=$arr[4]-$arr[5];
				}
			}
			else{
				$chr=$arr[3];
				if ($tmp[4]<=$tmp[5]) {
					$start=$tmp[4];
					$end=$tmp[5]
				}
				else{
					$start=$tmp[5];
					$end=$tmp[4];
				}
			}	
		}
		close IN;
		close OUT;	
}


### summarize the number of SDs

open OUT, ">allSDCount.sum";
print OUT "chr\t1-5k\tmean_Iden\t5-10k\tmean_Iden\t10-20k\tmean_Iden\t>20k\tmean_Iden\tduplicated_region_length\ttotalSD\tTotalSD_OtherChrs\n";
for (my $chr = 1; $chr < 20; $chr++) {
	open IN, "$chr.allSD.bed.1k.sort.rm" or die $!;
	open IN2,"$chr.allSD.bed.1k.sortbyOther.rm";
	my @whole=<IN2>;
	my $whole=@whole;
	close IN2;
	my $count_1k=0;
	my $totalID_1k=0;
	my $count_5k=0;
	my $totalID_5k=0;
	my $count_10k=0;
	my $totalID_10k=0;
	my $count_20k=0;
	my $totalID_20k=0;
	my $meanID=0;
	my $total_len=0;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		my $len=$arr[2]-$arr[1]+1;
		$total_len+=$len;
		if ($arr[6] >=1000 and $arr[6]<5000) {
			$count_1k++;
			$totalID_1k+=$arr[8];

		}
		elsif($arr[6] >=5000 and $arr[6]<10000){
			$count_5k++;
			$totalID_5k+=$arr[8];
		}
		elsif($arr[6] >=10000 and $arr[6]<20000){
			$count_10k++;
			$totalID_10k+=$arr[8];
		}
		elsif($arr[6] >=20000 ){
			$count_20k++;
			$totalID_20k+=$arr[8];
		}
	}
	my $meanID_1k=$totalID_1k/$count_1k;
	my $meanID_5k=$totalID_5k/$count_5k;
	my $meanID_10k;
	if ($count_10k>0) {
		$meanID_10k=$totalID_10k/$count_10k;
	}
	else{
		$meanID_10k="N/A";
	}
	
	my $meanID_20k;
	if ($count_20k>0) {
		$meanID_20k=$totalID_20k/$count_20k;
	}
	else{
		$meanID_20k="N/A";
	}
	
	my $total=$count_1k+$count_5k+$count_10k+$count_20k;

	print OUT "$chr\t$count_1k\t$meanID_1k\t$count_5k\t$meanID_5k\t$count_10k\t$meanID_10k\t$count_20k\t$meanID_20k\t$total_len\t$total\t$whole\n";
	close IN;
	
}
close OUT;


`mkdir Mummer_out`;
`mv *.coords Mummer_out`;
`mkdir bed_out`;
`mv *.bed bed_out`;
#`mkdir rm_out`;
#`mv *.rm rm_out`;


##Step2: identify SDs containing genes 

for (my $chr = 1; $chr < 20; $chr++) {
		open IN, "$chr.allSD.bed.1k.sortbyOther" or die $!;
		open OUT, ">$chr.allSD.bed.1k.sortbyOther.bed";
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			if ($arr[4]<$arr[5]) {
				print OUT "$arr[3]\t$arr[4]\t$arr[5]\t$arr[0]\t$arr[1]\t$arr[2]\t$arr[6]\t$arr[7]\t$arr[8]\n";
			}
			if ($arr[4]>$arr[5]) {
				print OUT "$arr[3]\t$arr[5]\t$arr[4]\t$arr[0]\t$arr[1]\t$arr[2]\t$arr[6]\t$arr[7]\t$arr[8]\n";
			}
			
		}
		close IN;
		close OUT;

		#`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a $ARGV[0].chr.bed  -b $chr.allSD.bed.1k.sort.rm  -f 1 > $ARGV[0].$chr.allSD.bed.1k.sort.rm.tmp`;
		`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a $ARGV[0].chr.bed  -b $chr.allSD.bed.1k.sort  -f 1 > $ARGV[0].$chr.allSD.bed.1k.sort.tmp`;
		`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a $ARGV[0].chr.bed  -b $chr.allSD.bed.1k.sortbyOther.bed  -f 1 > $ARGV[0].$chr.allSD.bed.1k.sortbyOther.tmp`;

		my @tmp=("$ARGV[0].$chr.allSD.bed.1k.sort","$ARGV[0].$chr.allSD.bed.1k.sortbyOther");
		foreach my $each (@tmp){
			open IN, "$each.tmp" or die $!;
			open OUT, ">$each.list";	
			my @allgene=();
			while (<IN>) {
				my @arr=split("\t",$_);
				push @allgene,$arr[3];
			}
			my %count;
			$count{$_}++ foreach @allgene;
    		while (my ($key, $value) = each(%count)) {
     			print OUT "$key\t$value\n";
    		}
    		close IN;
			close OUT;
		}
	}


`mkdir GeneOnSD_out`;
`mv *.tmp GeneOnSD_out`;
`mv *.list GeneOnSD_out`;
`rm *.sortbyOther.rm.bed`;


