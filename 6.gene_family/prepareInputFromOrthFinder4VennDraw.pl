#!usr/bin/perl

use strict;
use warnings;

## This script is used to prepare input file for venn diagram drawing with ClusterVenn from the OrthFinder results

open IN, "Orthogroups.txt" or die $!;
open OUT, ">orthfinder.4ven";

while (<IN>) {
	chomp;
	my @arr=split(" ",$_);
	shift @arr;
	foreach my $a (@arr){
		if ($a=~/VIT/) {
			print OUT "PN40024|$a\t";
		}
		elsif ($a=~/Char/) {
			print OUT "Char|$a\t";
		}
		elsif ($a=~/Cab/) {
			print OUT "Cab|$a\t";
		}
		elsif ($a=~/Vlab/) {
			print OUT "Vlab|$a\t";
		}
		elsif ($a=~/Vrip/) {
			print OUT "Vrip|$a\t";
		}
	}
	print OUT "\n";
}
close IN;
close OUT;

## preapre species specific gene cluster and singleton gene lists
open IN, "Orthogroups.txt" or die $!;
open OUT, ">PN40024.specificGene.list";
open OUT2, ">Cab.specificGene.list";
open OUT3, ">Char.specificGene.list";
open OUT4, ">Vlab.specificGene.list";
open OUT5, ">Vrip.specificGene.list";
open OUT6, ">cultivated.specificGene.list";
open OUT7, ">wild.specificGene.list";

while (<IN>) {
	chomp;
	if (/VIT/ and !/Cab/ and !/Char/ and !/Vlab/ and !/Vrip/) {
		my @arr=split(" ",$_);
		shift @arr;
		foreach (@arr){
			print OUT "$_\n";
		}	
	}
	elsif (!/VIT/ and /Cab/ and !/Char/ and !/Vlab/ and !/Vrip/) {
		my @arr=split(" ",$_);
		shift @arr;
		foreach (@arr){
			s/Cab/VvCabSauv08/;
			print OUT2 "$_\n";
		}	
	}
	elsif (!/VIT/ and !/Cab/ and /Char/ and !/Vlab/ and !/Vrip/) {
		my @arr=split(" ",$_);
		shift @arr;
		foreach (@arr){
			$_=$_."-RA";
			print OUT3 "$_\n";
		}	
	}
	elsif (!/VIT/ and !/Cab/ and !/Char/ and /Vlab/ and !/Vrip/) {
		my @arr=split(" ",$_);
		shift @arr;
		foreach (@arr){
			s/Vlab_//;
			print OUT4 "$_\n";
		}	
	}
	elsif (!/VIT/ and !/Cab/ and !/Char/ and !/Vlab/ and /Vrip/) {
		my @arr=split(" ",$_);
		shift @arr;
		foreach (@arr){
			s/Vrip_/vitri/;
			$_=$_."-mRNA-1";
			print OUT5 "$_\n";
		}	
	}
	elsif (/VIT/ and /Cab/ and /Char/ and !/Vlab/ and !/Vrip/ ) {
		my @arr=split(" ",$_);
		shift @arr;
		foreach (@arr){
			print OUT6 "$_\n";
		}	
	}

	elsif (!/VIT/ and !/Cab/ and !/Char/ and /Vlab/ and /Vrip/) {
		my @arr=split(" ",$_);
		shift @arr;
		foreach (@arr){
			s/Vlab_//;
			print OUT7 "$_\n";
		}	
	}
	
}
close IN;
close OUT;
close OUT2;
close OUT3;
close OUT4;
close OUT5;
close OUT6;
close OUT7;

`grep "mRNA" wild.specificGene.list > wild.specificGene.VlabName.list `;
`grep "VIT" cultivated.specificGene.list >cultivated.specificGene.PN40024Name.list`;




