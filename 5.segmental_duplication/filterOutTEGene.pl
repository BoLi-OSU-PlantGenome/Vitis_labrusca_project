#!/usr/bin/perl
use strict;
use warnings;

### there are many TE related gene model in SDGG, remove these TEs based on interproscan results

my @all=glob("*.allSDgenes.pep.fa.tsv");
foreach my $each (@all){
	open IN, "$each" or die $!;
	$each=~/(.*).allSDgenes.pep.fa.tsv/;
	my $a=$1;
	open OUT, ">$a.TEGene.list";
	my @name=();
	while (<IN>) {
		if (/retropepsin_like/ or /RT_nLTR_like/ or /PF00078|PF07727|PF14223|PF00665|PF03732|PF17919|PF13456|PF14223|PF03004|PF05699/ or /transposase/) {
			my @arr=split("\t",$_);
			push @name,$arr[0]; 
		}
	}
	my @uniq=uniq(@name);

	foreach (@uniq){
		print OUT "$_\n";
	}
close IN;
close OUT;


open IN, "$a.TEGene.list" or die $!;
my @allTE=<IN>;
close IN;

open IN, "$a.SDGeneGroup.all" or die $!;
open OUT, ">$a.SDGeneGroup.all.TErm";
while (<IN>) {
	chomp;
	my $line=$_;
	my @arr=split("\t",$line);
	my $time=0;
	foreach my $a (@arr){
		if (grep /$a\b/, @allTE) {
			$time++;
		}
	}
	if ($time==0) {
		print OUT "$line\n";
	}
}
close IN;
close OUT;
}

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

