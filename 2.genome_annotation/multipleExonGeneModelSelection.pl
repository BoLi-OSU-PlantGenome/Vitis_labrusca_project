#!usr/bin/perl

use strict;
use warnings;

## this script is used to choose best gene model with muiltple exons from the annotated genes by Maker (AED=0.0)

$/="\/\/";
open IN, "BestGeneModel.gb" or die $!;
open OUT, ">BestMexonModel.gb";
while (<IN>) {
	if (/join/) {
		print OUT "$_";
	}
}
close IN;
close OUT;

open IN, "BestMexonModel.gb";
#open OUT, ">BestMexonModel.gff";
open TMP, ">tmp.list";
while (<IN>) {
	#if (/gene="maker-\d+F\|(arrow-augustus-gene-\d+\.\d+)-mRNA"/) { #arrow-augustus-gene-18.14-mRNA-1
	if (/gene="maker-\d+F\|(arrow-augustus-gene-.*)-mRNA"/) { #arrow-augustus-gene-18.14-mRNA-1
		my $a=$1;
		print TMP "$a\n";
	}
}

close IN;
close TMP;

$/="\n";

my $file = "BestMexonModel.gff";
if (-e $file) {
	`rm $file`;
}

open IN, "tmp.list" or die $!;
while (<IN>) {
	chomp;
	`grep $_ BestGeneModel.gff3 >> BestMexonModel.gff`;
}
close IN;
