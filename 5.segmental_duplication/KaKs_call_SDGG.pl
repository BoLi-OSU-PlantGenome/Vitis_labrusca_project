#!usr/bin/perl

use strict;
use warnings;


#open TABLE, ">grape.geneName.conversion.table";

## prepare cds and pep seq for alignment

#my @species=("PN40024","Cab","Char","Vlab","Vrip");

my @species=("PN40024");

foreach my $each (@species){

$/=">";
my %pep;
open IN, "$each.chr.pep.fa" or die $!;
while (<IN>) {
        next if (length $_ <2);
        s/>//;
        my @arr=split("\n",$_);
        my $name=shift @arr;
        my @first=split(" ",$name);
        my $seq=join("\n",@arr);
        $pep{$first[0]}=$seq;
}
close IN;

my %cds;
open IN, "$each.chr.cds.fa" or die $!;
while (<IN>) {
        next if (length $_ <2);
        s/>//;
        my @arr=split("\n",$_);
        my $name=shift @arr;
        my @first=split(" ",$name);
        my $seq=join("\n",@arr);
        $cds{$first[0]}=$seq;
}
close IN;

$/="\n";


	open IN, "$each.SDGeneGroup.all.TErm.MultiSDG" or die $!;
	my $n=1000000000;
	while (<IN>) {
		chomp;
		if (/\bCab|PN40024|Char|Vlab|Vrip\b/) {
			my @arr=split("\t",$_);
			open OUT, ">$each.$arr[0].SDGG.pep.fa";
			open OUT2, ">$each.$arr[0].SDGG.cds.fa";
			foreach	my $a (@arr){
				if (exists $pep{$a} ) {
					$n++;
					print TABLE "$n\t$a\n";
					print OUT ">$n\n$pep{$a}\n";
					#print OUT ">$a\n$pep{$a}\n";
				}
				if (exists $cds{$a}) {
					print OUT2 ">$n\n$cds{$a}\n";
					#print OUT2 ">$a\n$cds{$a}\n";
				}
			}
			close OUT;
			close OUT2;
		}

	}
}



### run muscle to perform alignments within each SDGG and remove spurious sequences

my @allpep=glob("*.SDGG.pep.fa");
foreach (@allpep){
	#`~/local/muscle3.8.31_i86linux64 -in $_ -out $_.phy -phyi `;
	`~/local/muscle3.8.31_i86linux64 -in $_ -out $_.aln -clw `;
	open IN, "$_.aln" or die $!;
	open OUT, ">$_.phy";
	my @whole=<IN>;
	shift @whole; # remove line "MUSCLE (3.8) multiple sequence alignment"
	print OUT "@whole";
	close IN;
	close OUT;
	#`/users/PAS1444/li10917/local/phylo/trimAl/source/trimal -in $_.phy -out $_.trimed.phy  -resoverlap 0.5 -seqoverlap 50`;
}

#my @allcds=glob("*.SDGG.cds.fa");
#foreach (@allcds){
#	`~/local/muscle3.8.31_i86linux64 -in $_ -out $_.phy -phyi `;
#	`/users/PAS1444/li10917/local/phylo/trimAl/source/trimal -in $_.phy -out $_.trimed.phy  -resoverlap 0.75 -seqoverlap 80`;
#}



## run pal2nal.pl

my @phy=glob("*.phy");
foreach my $each (@phy){
	my $a;
	if ($each=~/(.*).SDGG.pep.fa.phy/) {
		$a=$1;
	}

	`./pal2nal.pl $each $a.SDGG.cds.fa -output paml -nogap > $a.pal2nal`;

 }






