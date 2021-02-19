#!usr/bin/perl 
use warnings;
use strict;

##split genome sequence into chr

$/=">";
my @all=glob("Vlab.associate.chr.fasta");
foreach my $file (@all){
	$file=~/(.*)\.chr\.fasta/;
	my $a=$1;
	open IN, "$file" or die $!;
	while (<IN>) {
		next if (length $_ <2);
		next if(/random/ or /Un/ or /Chr0/ or /F_RaGOO/);
		s/>//;
		my @arr=split("\n",$_);
		#$arr[0]=~s/_RaGOO//g;
		open OUT, ">$arr[0].fa";
		print OUT ">$arr[0]\n$arr[1]\n";
	}
}


$/="\n";
