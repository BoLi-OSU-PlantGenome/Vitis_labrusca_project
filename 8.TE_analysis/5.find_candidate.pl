#/usr/bin/perl
use strict;
use warnings;

open IN,"allGrape.TE_insertion_5UTR.0_0.9.loci.TPM" or die $!;
open OUT, ">allGrape.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.tmp";

while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my @te=();
	my @tpm=();
	my %pn_te;
	$pn_te{$arr[2]}=$arr[1];
	my %pn_tpm;
	$pn_tpm{$arr[3]}=$arr[1];

	my %cab_te;
	$cab_te{$arr[5]}=$arr[4];
	my %cab_tpm;
	$cab_tpm{$arr[6]}=$arr[4];

	my %char_te;
	$char_te{$arr[8]}=$arr[7];
	my %char_tpm;
	$char_tpm{$arr[9]}=$arr[7];

	my %vlab_te;
	$vlab_te{$arr[11]}=$arr[10];
	my %vlab_tpm;
	$vlab_tpm{$arr[12]}=$arr[10];

	push @te,$arr[2];
	push @te,$arr[5];
	push @te,$arr[8];
	push @te,$arr[11];

	push @tpm,$arr[3];
	push @tpm,$arr[6];
	push @tpm,$arr[9];
	push @tpm,$arr[12];


	my @sort_te = sort { $a <=> $b } @te;
	my @sort_tpm = sort { $a <=> $b } @tpm;

	#print "$sort[0]\t$sort[-1]\n";
	if (exists $pn_te{$sort_te[-1]}) {
		print OUT "$pn_te{$sort_te[-1]}\t";
	}
	if (exists $cab_te{$sort_te[-1]}) {
		print OUT "$cab_te{$sort_te[-1]}\t";
	}
	if (exists $char_te{$sort_te[-1]}) {
		print OUT "$char_te{$sort_te[-1]}\t";
	}
	if (exists $vlab_te{$sort_te[-1]}) {
		print OUT "$vlab_te{$sort_te[-1]}\t";
	}

	if (exists $pn_tpm{$sort_tpm[0]}) {
		print OUT "$pn_tpm{$sort_tpm[0]}\t";
	}
	if (exists $cab_tpm{$sort_tpm[0]}) {
		print OUT "$cab_tpm{$sort_tpm[0]}\t";
	}
	if (exists $char_tpm{$sort_tpm[0]}) {
		print OUT "$char_tpm{$sort_tpm[0]}\t";
	}
	if (exists $vlab_tpm{$sort_tpm[0]}) {
		print OUT "$vlab_tpm{$sort_tpm[0]}\t";
	}
	print OUT "\n";
}
close IN;
close OUT;

`rm allGrape.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list`;
open IN, "allGrape.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.tmp" or die $!;
open TMP,">gene_list.highTEandlowTPM";
#open OUT, ">allGrape.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list";
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my %seen;
    foreach my $string (@arr) {
    	next unless $seen{$string}++;
    	print TMP "$string\n";
    	`grep $string allGrape.TE_insertion_5UTR.0_0.9.loci.list >> allGrape.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list`;
	}
}
close IN;
close TMP;



### preapre input for R barplot

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


open IN, "allGrape.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list" or die $!;
#open SUM, ">allGrape.TE_insertion_5UTR.0_0.9.loci.TPM";
open OUT, ">PN40024.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list";
print OUT "Pos\tCount\tType\n";
open OUT2, ">Cab.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list";
print OUT2 "Pos\tCount\tType\n";
open OUT3, ">Char.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list";
print OUT3 "Pos\tCount\tType\n";
open OUT4, ">Vlab.TE_insertion_5UTR.0_0.9.loci.goodCondiatate.list";
print OUT4 "Pos\tCount\tType\n";

my $n=0;
while (<IN>) {
	$n++;
	chomp;
	my @arr=split("\t",$_);
	#print SUM "$arr[0]\t";
	$arr[1]=~s/\.t\d+//;
	$arr[3]=~s/\.m\d+//;
	$arr[5]=~s/-RA//;
	$arr[7]=~s/-mRNA-1//;
	print OUT "$n\t$arr[2]\tTE_prop\n";
	print OUT2 "$n\t$arr[4]\tTE_prop\n";
	print OUT3 "$n\t$arr[6]\tTE_prop\n";
	print OUT4 "$n\t$arr[8]\tTE_prop\n";
	if (exists $pn{$arr[1]}) {
		#print SUM "$arr[1]\t$arr[2]\t$pn{$arr[1]}\t";
		print OUT "$n\t$pn{$arr[1]}\tTPM_mean\n";
	}
	if (exists $cab{$arr[3]}) {
		#print SUM "$arr[3]\t$arr[4]\t$cab{$arr[3]}\t";
		print OUT2 "$n\t$cab{$arr[3]}\tTPM_mean\n";
	}
	if (exists $char{$arr[5]}) {
		#print SUM "$arr[5]\t$arr[6]\t$char{$arr[5]}\t";
		print OUT3 "$n\t$char{$arr[5]}\tTPM_mean\n";
	}
	if (exists $vlab{$arr[7]}) {
		
		print OUT4 "$n\t$vlab{$arr[7]}\tTPM_mean\n";
	}
}
close IN;
close OUT;
close OUT2;
close OUT3;
close OUT4;






