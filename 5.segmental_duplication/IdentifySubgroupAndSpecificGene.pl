#!usr/bin/perl
use strict;
use warnings;

# This script is to identify how many subgroup shared genes and species-specific genes are generated via SD.

open SUM, ">allgrape.SDGeneGroup.all.TErm.MultiSDG.sum";
print SUM "Species\tAllshare_SDG\tSubgroupShared_SDG\tSpecies-spicific_SDG\tAllshare_gene\tSubgroupShared_gene\tSpecies-spicific_gene\n";
open SUM2, ">allgrape.SDGeneGroup.all.TErm.singleSDG.sum";
print SUM2 "Species\tAllshare\tSubgroupShared\tSpecies-spicific\n";
my @species=("PN40024","Cab","Char","Vlab","Vrip");

foreach my $each (@species){

###prepare protein sequences and cds sequences

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


### separate all SDG into single gene SDG and multi gene SDG

open IN, "$each.SDGeneGroup.all.TErm.rmdup" or die $!;
open SN, ">$each.SDGeneGroup.all.TErm.singleSDG";
open MU, ">$each.SDGeneGroup.all.TErm.MultiSDG";
	
	while (<IN>) {
		chomp;
		my $line=$_;
		my @namelist=();
		my @arr=split("\t",$line);
		foreach my $a (@arr){
			if ($a!~/NoGene|NoType/) {
				push @namelist,$a;
			}
		}
		my $namelist=@namelist;
		if ($namelist==2) { 
			print SN "$line\n";
		}
		elsif($namelist>2){
			print MU "$line\n";
		}
	}
	close IN;
	close SN;
	close MU;
#############################################

####single gene SDG analysis
open IN, "$each.SDGeneGroup.all.TErm.singleSDG";
#open OUT, ">$each.SDGeneGroup.all.TErm.singleSDG.sum";
open FA, ">$each.SDGeneGroup.all.TErm.singleSDG.lost.pep.fa";

	my $allshare=0;
	my $subgroup=0;
	my $sp=0;

	while (<IN>) {	
		my @arr=split("\t",$_);
		if ($arr[1]=~/all/) {
			$allshare++;
			if (exists $pep{$arr[0]}) {
				print FA ">$arr[0]\n$pep{$arr[0]}\n";
			}

		}
		elsif ($arr[1]=~/wild|cultivated/) {
			$subgroup++;
		}
		else{
			$sp++;
		}

 	}
	print SUM2 "$each\t$allshare\t$subgroup\t$sp\n";

	close IN;
	#close OUT;
	close FA;


#### Multi gene SDG analysis
	open IN, "$each.SDGeneGroup.all.TErm.MultiSDG";
	open OUT, ">$each.SDGeneGroup.all.TErm.MultiSDG.SubgroupShared";
	open OUT2, ">$each.SDGeneGroup.all.TErm.MultiSDG.Specific";
	open OUT3, ">$each.SDGeneGroup.all.TErm.MultiSDG.allshare";
	open PROT, ">$each.SDGeneGroup.all.TErm.MultiSDG.SubgroupShared.pep.fa";
	open CDS, ">$each.SDGeneGroup.all.TErm.MultiSDG.SubgroupShared.cds.fa";
	open PROT2, ">$each.SDGeneGroup.all.TErm.MultiSDG.Specific.pep.fa";
	open CDS2, ">$each.SDGeneGroup.all.TErm.MultiSDG.Specific.cds.fa";
	open AN, ">$each.subgroupSDG.4annotation.pep.fa";
	open AN2, ">$each.SpSDG.4annotation.pep.fa";

	my $all_count=0; ## gene count
	my $sub_count=0; ## gene count
	my $sp_count=0;  ## gene count
	#my $all_SDG_count=0; ## SDG count
	my $sub_SDG_count=0; ## SDG count
	my $sp_SDG_count=0; ## SDG count
	while (<IN>) {
		chomp;
		if (/allshare/ and !/wild|cultivated|unknown/ and !/(PN40024|Cab|Char|Vlab|Vrip)\b/) {
			$all_count++;
			print OUT3 "$_\n";
		}
		if (/allShare/ and /wild|cultivated/) {
			print OUT "$_\n";
			$sub_SDG_count++;
			my @arr=split("\t",$_);
			if (exists $pep{$arr[0]}) {
				print AN ">$arr[0]\n$pep{$arr[0]}\n"
			}
			foreach my $a(@arr){
				if ($a=~/wild|cultivated/) {
					$sub_count++;
				}
			}
			my $arr=@arr;
			for (my $n = 1; $n < $arr; $n++) {
				if ($arr[$n]=~/wild|cultivated/) {
					#print "$arr[$n-1]\n";
					if (exists $pep{$arr[$n-1]}) {
						print PROT ">$arr[$n-1]\n$pep{$arr[$n-1]}\n"; 
					}
					if (exists $cds{$arr[$n-1]}) {
						print CDS ">$arr[$n-1]\n$cds{$arr[$n-1]}\n"; 
					}
				}
			}
		}
		if (/(PN40024|Cab|Char|Vlab|Vrip)\b/) {
			print OUT2 "$_\n";
			$sp_SDG_count++;
			my @arr=split("\t",$_);
			if (exists $pep{$arr[0]}) {
				print AN2 ">$arr[0]\n$pep{$arr[0]}\n"
			}
			foreach my $a(@arr){
				if ($a=~/(PN40024|Cab|Char|Vlab|Vrip)\b/) {
					$sp_count++;
				}
			}
			my $arr=@arr;
			for (my $n = 1; $n < $arr; $n++) {
				if ($arr[$n]=~/(PN40024|Cab|Char|Vlab|Vrip)\b/) {
					#print "$arr[$n-1]\n";
					if (exists $pep{$arr[$n-1]}) {
						print PROT2 ">$arr[$n-1]\n$pep{$arr[$n-1]}\n"; 
					}
					if (exists $cds{$arr[$n-1]}) {
						print CDS2 ">$arr[$n-1]\n$cds{$arr[$n-1]}\n"; 
					}
				}
			}
		}
	}
	print SUM "$each\t$all_count\t$sub_SDG_count\t$sp_SDG_count\t$all_count\t$sub_count\t$sp_count\n";
	close IN;
	close OUT;
	close OUT2;
	close OUT3;
	close PROT;
	close CDS;
	close PROT2;
	close CDS2;
	close AN;
	close AN2;
}

close SUM;
close SUM2;
