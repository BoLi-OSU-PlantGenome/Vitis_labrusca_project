#!usr/bin/perl

use strict;
use warnings;


my @sp=("Vlab","Cab","Char","Vrip");
foreach my $each (@sp){

	my %fa;
	$/=">";
	open IN, "PN40024.chr.pep.fa" or die $!;
	while (<IN>) {
		next if (length $_ <2);
		s/>//;
		my @arr=split("\n",$_);
		my $name=shift @arr;
		my @first=split(" ",$name);
		my $seq=join("\n",@arr);
		$fa{$first[0]}=$seq;
	}
	$/="\n";
	close IN;

	open IN, "PN_ref.$each.lostgene.list" or die $!;
	open OUT, ">PN_ref.$each.lostgene.fasta";
	while (<IN>) {
		chomp;
		my @arr=split("\t");
		
		if (exists $fa{$arr[0]}) {
			print OUT ">$arr[0]\n";
			print OUT "$fa{$arr[0]}\n";
		}
		
	}
	close IN;
	close OUT;

	##run blast

	#`makeblastdb -in $each.chr.pep.fa -dbtype prot `;
	#`blastp -db $each.chr.pep.fa -query $each.lostgene.fasta -out $each.lostgene.blast.out -evalue 1e-10 -outfmt 6 -max_target_seqs 2`;

	`diamond makedb --in $each.chr.pep.fa -d $each.pep`;
    `diamond blastp -d $each.pep -q PN_ref.$each.lostgene.fasta -e 1e-10 --max-target-seqs 1 --unal 1 -f 6 -o PN_ref.$each.lostgene.diamond.out`;

}