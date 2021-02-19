#!usr/bin/perl

use strict;
use warnings;

open SUM, ">PNref.genelost_genemove_sep.count";
my @sp=("Vlab","Cab","Char","Vrip");
foreach my $each (@sp){
	my %hash;
	open IN, "$each.collinear.genelist" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		$hash{$arr[0]}=$arr[1];
	}
	close IN;

	open IN, "PN_ref.$each.lostgene.diamond.out";
	open OUT, ">PN_ref.$each.lostgene.validated.list"; 
	open OUT2, ">PN_ref.$each.lostmove.list";
	my $gene_lost_count=0;
	my $gene_move_count=0;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		if ($arr[1] eq "\*") { # if no hit
			print OUT "$arr[0]\n";
			$gene_lost_count++;
			next;
		}
		if (exists $hash{$arr[1]}) {
			if ($hash{$arr[1]} =~/All_shared_(4|5)/) { # gene movement can be found if this gene become a non-collinear
			   print OUT "$arr[0]\n";
			   $gene_lost_count++
			}
			else{
				$gene_move_count++;
				print OUT2 "$arr[0]\t$arr[1]\n";
			}

		}
	}
	close IN;
	close OUT;
	print SUM "$each\t$gene_lost_count\t$gene_move_count\n";
}
close SUM;