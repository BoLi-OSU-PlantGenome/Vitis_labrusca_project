#!usr/bin/perl

use strict;
use warnings;


## This script is used to validate the contigs removed from primary contig group by purge_haploid

# The basic pricinple to judge if this contig is correctly removed is when this contig have a very similar contigs which has already been assembled into the genome.



## Step1: This has been finished on Mac. run RaGoo with all falcon contig (669). The output file --- grouping can be used to determine which is the best reference alignment for each contig

## move into RaGoo installation directory 

# prepare input files: contig files, reference sequences (repeatmasked)

#system "source activate Ragoo"; 
#system "bash run_RaGOO.sh";


## Step2: based on the assembled pseudomolecule sequences from RaGoo, we can put each tested contig with corrospanding pseudomolecule togather
## and align these two sequences with corrospaning grape reference chromosome to generate dotplot for mannully checking

#input files: removed contig list, and output files from previous RaGOO 

## build a table: contig chromosome_number (000003F|arrow 1)
open OUT, ">Allcontig.2.refchr.table";
my @all=glob("*_contigs.txt");
foreach my $file (@all){
	my $a;
	if ($file=~/(\d+)_contigs.txt/) {
		$a=$1;
	}
	open IN, "$file" or die $!;
	while (<IN>) {
		my @arr=split("\t",$_);
		print OUT "$arr[0]\t$a\n";
	}
	close IN;
}
close OUT;


# generate a table only for removed contigs

open IN, "removedContigs.list" or die $!;
#open OUT, ">RemovedContig.2.refchr.table";
system "rm RemovedContig.2.refchr.table";
while (<IN>) {
	chomp;
	s/\|arrow//g;
	system "grep $_ Allcontig.2.refchr.table >> RemovedContig.2.refchr.table";
}

close IN;


## combined single removed contig with correspanding labrusca pseudomolecule and aligned to vinifera chromosome

open FA, "cns_p_ctg.fasta" or die $!;

$/=">";
my %hash;
while (<FA>) {
        next if(length $_ <2);
        s/>//;
        my $each=$_;
        my @arr=split("\n",$each);
        my $name=shift @arr;
        $hash{$name}=$each;
}
close FA;

$/="\n";


#open TABLE, "RemovedContig.2.refchr.table" or die $!;
open TABLE, "test001.table" or die $!;
while (<TABLE>) {
	chomp;
	my @arr=split("\t",$_);
	my $chr="\\>".$arr[1]."_";
	#print "$chr\n";
	system "grep -A 1 $chr ragoo.fasta > tmp.psudo.fa";
	open OUT, ">tmp.removedComtig.fa";
	if (exists $hash{$arr[0]}) {
		print OUT ">$hash{$arr[0]}";
	}
	$arr[0]=~s/\|arrow//g;
	system "cat tmp.psudo.fa tmp.removedComtig.fa > $arr[0].fasta";
	close OUT;

	## run mummer 
	system "mkdir $arr[0]_output";

	#my $refchr="chr".$arr[1];
	my $ref="chr".$arr[1].".fa";
	print "$ref\n";
	my $qry=$arr[0].".fasta";
	print "$qry\n";
	my $prefix=$arr[0].".test";
	print "$prefix\n";

	system "/users/PAS1444/li10917/local/MUMmer3.23/nucmer -maxmatch -l 100 -c 500 --prefix=$prefix  $ref $qry";
   system "/users/PAS1444/li10917/local/MUMmer3.23/mummerplot  $prefix.delta  -R $ref -Q $qry -p $prefix.delta --png";
    system "/users/PAS1444/li10917/local/MUMmer3.23/show-coords -rcl  $prefix.delta >  $prefix.coords.r";
   system "/users/PAS1444/li10917/local/MUMmer3.23/show-coords -qcl  $prefix.delta >  $prefix.coords.q";
   system "mv $prefix* $arr[0]_output";

}

close TABLE;










