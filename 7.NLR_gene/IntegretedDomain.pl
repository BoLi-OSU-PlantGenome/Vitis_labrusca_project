#!/usr/bin/perl

use strict;
use warnings;


## this scirpt is to identity the integreted domains in NLR protein and investigate whether there are differenees between different grape speceis


my @species=("Vv12X", "Cab08", "Char", "labrusca", "riparia");

`rm *.ID.list`;

foreach my $each (@species){

	open IN, "$each.TIR.list" or die $!;

	while (<IN>) {
		chomp;
		`grep -Eiv "coil|PF18052|NB-ARC|TIR|RPW8|Leucine rich repeat" $each.pep.fa.tsv | grep "$_" >> $each.TNLs.ID.list`;
	}
	close IN;
	#close OUT;


	open IN, "$each.CC_NB" or die $!;
	#open OUT, ">$each.CC_NB.ID.list";

	while (<IN>) {
		chomp;
		`grep -Eiv "coil|PF18052|NB-ARC|TIR|RPW8|Leucine rich repeat" $each.pep.fa.tsv | grep "$_" >> $each.CNLs.ID.list`;
	}
	close IN;
	#close OUT;


	open IN, "$each.CCr_NB" or die $!;
	#open OUT, ">$each.CCr_NB.ID.list";

	while (<IN>) {
		chomp;
		`grep -Eiv "coil|PF18052|NB-ARC|TIR|RPW8|Leucine rich repeat" $each.pep.fa.tsv | grep "$_" >> $each.RNLs.ID.list`;
	}
	close IN;
	#close OUT;


	open IN, "$each.NB_LRR_only" or die $!;
	#open OUT, ">$each.NB_LRR_only.ID.list";

	while (<IN>) {
		chomp;
		`grep -Eiv "coil|PF18052|NB-ARC|TIR|RPW8|Leucine rich repeat" $each.pep.fa.tsv | grep "$_" >> $each.NB_LRR_only.ID.list`;
	}
	close IN;
	#close OUT;

	open IN, "$each.NB_only" or die $!;
	#open OUT, ">$each.NB_only.ID.list";

	while (<IN>) {
		chomp;
		`grep -Eiv "coil|PF18052|NB-ARC|TIR|RPW8|Leucine rich repeat" $each.pep.fa.tsv | grep "$_" >> $each.NB_only.ID.list`;
	}
	close IN;
	#close OUT;
}

`cat Vv12X.*.ID.list > Vv12X.all.ID`;
`cat Cab08.*.ID.list > Cab08.all.ID`;
`cat Char.*.ID.list > Char.all.ID`;
`cat Vv12X.all.ID Cab08.all.ID Char.all.ID >cultivated.all.ID`;
`cat labrusca.*.ID.list > labrusca.all.ID`;
`cat riparia.*.ID.list > riparia.all.ID`;
`cat labrusca.all.ID riparia.all.ID > wild.all.ID`;


my @all=glob("*.all.ID");

open OUT, ">grape.ID.cmp.list";

foreach my $a (@all){
	my $b;
	if ($a=~/(.*)\.all\.ID/) {
		$b=$1;
	}
	print OUT "$b\n";

	open IN, "$a" or die $!;
	my @id=();
	while (<IN>) {
		my @tmp=split("\t", $_);
		#print "$tmp[4]\t$tmp[5]\n";
		push @id,$tmp[5];
	}

	close IN;

	my %count;
	$count{$_}++ foreach @id;

#output the counts
    while (my ($key, $value) = each(%count)) {
     print OUT "$key\t$value\n";
    }
}

close OUT;
