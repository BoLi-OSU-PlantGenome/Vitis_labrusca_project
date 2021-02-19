#!usr/bin/perl

use strict;
use warnings;

## test how many cds withon ATG start codon
my @file=glob("*.codingseq");
foreach my $each (@file){
	open IN, "$each" or die $!;
	$/=">";
	my $count=0;
	my $count2=0;
	while (<IN>) {
		next if length $_ <2;
		s/>//;
		my @arr=split("\n",$_);
		if ($arr[1]!~/^ATG/i) {
			$count++;
			#print "$count";
		}
                if ($arr[1]=~/^ATG/i) {
                        $count2++;
                        #print "$count";
                }       #                }
	}
	print "$each\t$count\t$count2\n";
	close IN;

}
