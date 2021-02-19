#/usr/bin/perl
use strict;
use warnings;

my %vlab;
open IN, "Vlab.all.berry.TPM.mean" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $log=log($arr[1]+1);
	$vlab{$arr[0]}=$log;
}
close IN;

my %pn;
open IN, "PN40024.all.berry.TPM.mean" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $log=log($arr[1]+1);
	$pn{$arr[0]}=$log;
}
close IN;

my %cab;
open IN, "Cab.all.berry.TPM.mean" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $log=log($arr[1]+1);
	$cab{$arr[0]}=$log;
}
close IN;

my %char;
open IN, "Char.all.berry.TPM.mean" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $log=log($arr[1]+1);
	$char{$arr[0]}=$log;
}
close IN;


open IN, "allGrape.TE_insertion_5UTR.0_0.9.loci.list" or die $!;
open SUM, ">allGrape.TE_insertion_5UTR.0_0.9.loci.TPM";
open OUT, ">PN40024.TE_insertion_5UTR.0_0.9.loci.TPM";
print OUT "Pos\tCount\tType\n";
open OUT2, ">Cab.TE_insertion_5UTR.0_0.9.loci.TPM";
print OUT2 "Pos\tCount\tType\n";
open OUT3, ">Char.TE_insertion_5UTR.0_0.9.loci.TPM";
print OUT3 "Pos\tCount\tType\n";
open OUT4, ">Vlab.TE_insertion_5UTR.0_0.9.loci.TPM";
print OUT4 "Pos\tCount\tType\n";

my $n=0;
while (<IN>) {
	$n++;
	chomp;
	my @arr=split("\t",$_);
	print SUM "$arr[0]\t";
	$arr[1]=~s/\.t\d+//;
	$arr[3]=~s/\.m\d+//;
	$arr[5]=~s/-RA//;
	$arr[7]=~s/-mRNA-1//;
	print OUT "$n\t$arr[2]\tTE_prop\n";
	print OUT2 "$n\t$arr[4]\tTE_prop\n";
	print OUT3 "$n\t$arr[6]\tTE_prop\n";
	print OUT4 "$n\t$arr[8]\tTE_prop\n";
	if (exists $pn{$arr[1]}) {
		print SUM "$arr[1]\t$arr[2]\t$pn{$arr[1]}\t";
		print OUT "$n\t$pn{$arr[1]}\tTPM_mean\n";
	}
	if (exists $cab{$arr[3]}) {
		print SUM "$arr[3]\t$arr[4]\t$cab{$arr[3]}\t";
		print OUT2 "$n\t$cab{$arr[3]}\tTPM_mean\n";
	}
	if (exists $char{$arr[5]}) {
		print SUM "$arr[5]\t$arr[6]\t$char{$arr[5]}\t";
		print OUT3 "$n\t$char{$arr[5]}\tTPM_mean\n";
	}
	if (exists $vlab{$arr[7]}) {
		print SUM "$arr[7]\t$arr[8]\t$vlab{$arr[7]}\n";
		print OUT4 "$n\t$vlab{$arr[7]}\tTPM_mean\n";
	}
}
close IN;
close OUT;
close OUT2;
close OUT3;
close OUT4;
close SUM;














