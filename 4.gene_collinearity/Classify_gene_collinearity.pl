#!usr/bin/perl

use strict;
use warnings;

## This script is used to analysis MCScan results to classify gene into four categories: 
## (1) all_shared_5 (5 speices), all_shared_4a (2 cultivated and 2 wild) and all_shared_4b (3 cultivated and 1 wild), all_shared_3 (2 cultivated and 1 wild or 1cultivated and 2 wild), all_shared_2 (1 wild and 1 cultivated); 
## (2) cultivated_shared_3 (3 cultivated); cultivated_shared_2 (at least 2 cultivated);
## (3) wild_shared (two wild) (4) species_specific. 

## PN40024
my $pn_lost=0;
my $cab_lost=0;
my $char_lost=0;
my $vlab_lost=0;
my $vrip_lost=0;
my $all_shared_5=0;
my $all_shared_4a=0;
my $all_shared_4b=0;
my $all_shared_3=0;
my $all_shared_2=0;
my $cultivated_3=0;
my $cultivated_2=0;
my $ss=0;

open IN, "grape.PN40024.blocks" or die $!;
open OUT, ">PN40024.collinear.genelist";
open OUT2, ">PN40024.collinear.gene.sum";
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/VvCab/ and $arr[2]=~/Char/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_5\tall\n";
		$all_shared_5++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tChar\n";
		$char_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[2]=~/Char/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tCab\n";
		$cab_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[2]=~/Char/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4b\tVlab\n";
		$vlab_lost++;
		$all_shared_4b++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[2]=~/Char/ and $arr[3]=~/-gene-/ ) {
		print OUT "$arr[0]\tAll_shared_4b\tVrip\n";
		$vrip_lost++;
		$all_shared_4b++;
	}
	elsif ( $arr[2]=~/Char/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/Char/ and $arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Vrip\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/VvCab/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tChar_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/VvCab/ and $arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tChar_Vrip\n";
		$all_shared_3++;
	}
	elsif ($arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Char\n";
		$all_shared_3++;
	}
	elsif ($arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_2\tCab_Char_Vlab\n";
		$all_shared_2++;
	}
	elsif ($arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_2\tCab_Char_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[2]=~/Char/) {
		print OUT "$arr[0]\tCultivated_shared_3\tVlab_Vrip\n";
		$cultivated_3++;
	}
	elsif ($arr[1]=~/VvCab/) {
		print OUT "$arr[0]\tCultivated_shared_2\tChar_Vlab_Vrip\n";
		$cultivated_2++;
	}
	elsif ($arr[2]=~/Char/) {
		print OUT "$arr[0]\tCultivated_shared_2\tCab_Vlab_Vrip\n";
		$cultivated_2++;
	}
	else{
		print OUT "$arr[0]\tSpecies_specific\tCab_Char_Vlab_Vrip\n";
		$ss++;
	}
	
}
print OUT2 "Cab_lost\t$cab_lost\n";
print OUT2 "Char_lost\t$char_lost\n";
print OUT2 "Vlab_lost\t$vlab_lost\n";
print OUT2 "Vrip_lost\t$vrip_lost\n";
print OUT2 "All_shared_5\t$all_shared_5\n";
print OUT2 "All_shared_4a\t$all_shared_4a\n";
print OUT2 "All_shared_4b\t$all_shared_4b\n";
print OUT2 "All_shared_3\t$all_shared_3\n";
print OUT2 "All_shared_2\t$all_shared_2\n";
print OUT2 "Cultivated_shared_3\t$cultivated_3\n";
print OUT2 "Cultivated_shared_2\t$cultivated_2\n";
print OUT2 "Species_specific\t$ss\n";

close IN;
close OUT;
close OUT2;


## Cab

 $pn_lost=0;
 $cab_lost=0;
 $char_lost=0;
 $vlab_lost=0;
 $vrip_lost=0;
 $all_shared_5=0;
 $all_shared_4a=0;
 $all_shared_4b=0;
 $all_shared_3=0;
 $all_shared_2=0;
 $cultivated_3=0;
 $cultivated_2=0;
 $ss=0;

open IN, "grape.Cab.blocks" or die $!;
open OUT, ">Cab.collinear.genelist";
open OUT2, ">Cab.collinear.gene.sum";
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/Char/ and $arr[2]=~/VIT/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_5\tall\n";
		$all_shared_5++;
	}
	elsif ($arr[1]=~/Char/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tPN40024\n";
		$pn_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[2]=~/VIT/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tChar\n";
		$char_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[1]=~/Char/ and $arr[2]=~/VIT/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4b\tVlab\n";
		$vlab_lost++;
		$all_shared_4b++;
	}
	elsif ($arr[1]=~/Char/ and $arr[2]=~/VIT/ and $arr[3]=~/-gene-/ ) {
		print OUT "$arr[0]\tAll_shared_4b\tVrip\n";
		$vrip_lost++;
		$all_shared_4b++;
	}
	elsif ( $arr[1]=~/Char/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/Char/ and $arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Vrip\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/VIT/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tChar_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/VIT/ and $arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tChar_Vrip\n";
		$all_shared_3++;
	}
	elsif ($arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Char\n";
		$all_shared_3++;
	}
	elsif ($arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Char_Vlab\n";
		$all_shared_2++;
	}
	elsif ($arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Char_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[1]=~/Char/ and $arr[2]=~/VIT/) {
		print OUT "$arr[0]\tCultivated_shared_3\tVlab_Vrip\n";
		$cultivated_3++;
	}
	elsif ($arr[1]=~/Char/) {
		print OUT "$arr[0]\tCultivated_shared_2\tPN_Vlab_Vrip\n";
		$cultivated_2++;
	}
	elsif ($arr[2]=~/VIT/) {
		print OUT "$arr[0]\tCultivated_shared_2\tChar_Vlab_Vrip\n";
		$cultivated_2++;
	}
	else{
		print OUT "$arr[0]\tSpecies_specific\tPN_Char_Vlab_Vrip\n";
		$ss++;
	}
	
}
print OUT2 "PN_lost\t$pn_lost\n";
print OUT2 "Char_lost\t$char_lost\n";
print OUT2 "Vlab_lost\t$vlab_lost\n";
print OUT2 "Vrip_lost\t$vrip_lost\n";
print OUT2 "All_shared_5\t$all_shared_5\n";
print OUT2 "All_shared_4a\t$all_shared_4a\n";
print OUT2 "All_shared_4b\t$all_shared_4b\n";
print OUT2 "All_shared_3\t$all_shared_3\n";
print OUT2 "All_shared_2\t$all_shared_2\n";
print OUT2 "Cultivated_shared_3\t$cultivated_3\n";
print OUT2 "Cultivated_shared_2\t$cultivated_2\n";
print OUT2 "Species_specific\t$ss\n";

close IN;
close OUT;
close OUT2;

## Char

 $pn_lost=0;
 $cab_lost=0;
 $char_lost=0;
 $vlab_lost=0;
 $vrip_lost=0;
 $all_shared_5=0;
 $all_shared_4a=0;
 $all_shared_4b=0;
 $all_shared_3=0;
 $all_shared_2=0;
 $cultivated_3=0;
 $cultivated_2=0;
 $ss=0;

open IN, "grape.Char.blocks" or die $!;
open OUT, ">Char.collinear.genelist";
open OUT2, ">Char.collinear.gene.sum";
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/VvCab/ and $arr[2]=~/VIT/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_5\tall\n";
		$all_shared_5++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tPN40024\n";
		$pn_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[2]=~/VIT/ and $arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tCab\n";
		$cab_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[2]=~/VIT/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4b\tVlab\n";
		$vlab_lost++;
		$all_shared_4b++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[2]=~/VIT/ and $arr[3]=~/-gene-/ ) {
		print OUT "$arr[0]\tAll_shared_4b\tVrip\n";
		$vrip_lost++;
		$all_shared_4b++;
	}
	elsif ( $arr[1]=~/VvCab/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/VvCab/ and $arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Vrip\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/VIT/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/VIT/ and $arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Vrip\n";
		$all_shared_3++;
	}
	elsif ($arr[3]=~/-gene-/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Cab\n";
		$all_shared_3++;
	}
	elsif ($arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Cab_Vlab\n";
		$all_shared_2++;
	}
	elsif ($arr[3]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Cab_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[1]=~/Cab/ and $arr[2]=~/VIT/) {
		print OUT "$arr[0]\tCultivated_shared_3\tVlab_Vrip\n";
		$cultivated_3++;
	}
	elsif ($arr[1]=~/Cab/) {
		print OUT "$arr[0]\tCultivated_shared_2\tPN_Vlab_Vrip\n";
		$cultivated_2++;
	}
	elsif ($arr[2]=~/VIT/) {
		print OUT "$arr[0]\tCultivated_shared_2\tCab_Vlab_Vrip\n";
		$cultivated_2++;
	}
	else{
		print OUT "$arr[0]\tSpecies_specific\tPN_Cab_Vlab_Vrip\n";
		$ss++;
	}
	
}
print OUT2 "PN_lost\t$pn_lost\n";
print OUT2 "Cab_lost\t$cab_lost\n";
print OUT2 "Vlab_lost\t$vlab_lost\n";
print OUT2 "Vrip_lost\t$vrip_lost\n";
print OUT2 "All_shared_5\t$all_shared_5\n";
print OUT2 "All_shared_4a\t$all_shared_4a\n";
print OUT2 "All_shared_4b\t$all_shared_4b\n";
print OUT2 "All_shared_3\t$all_shared_3\n";
print OUT2 "All_shared_2\t$all_shared_2\n";
print OUT2 "Cultivated_shared_3\t$cultivated_3\n";
print OUT2 "Cultivated_shared_2\t$cultivated_2\n";
print OUT2 "Species_specific\t$ss\n";

close IN;
close OUT;
close OUT2;

#Vlab

$pn_lost=0;
 $cab_lost=0;
 $char_lost=0;
 $vlab_lost=0;
 $vrip_lost=0;
 $all_shared_5=0;
 $all_shared_4a=0;
 $all_shared_4b=0;
 $all_shared_3=0;
 $all_shared_2=0;
 my $wild=0;
 $ss=0;

open IN, "grape.Vlab.blocks" or die $!;
open OUT, ">Vlab.collinear.genelist";
open OUT2, ">Vlab.collinear.gene.sum";
open FA1, ">PN40024.lostgene.list";
open FA2, ">Cab.lostgene.list";
open FA3, ">Char.lostgene.list";
open FA4, ">Vrip.lostgene.list";
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/VIT/ and $arr[2]=~/VvCab/ and $arr[3]=~/Char/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_5\tall\n";
		$all_shared_5++;
	}
	elsif ($arr[2]=~/VvCab/ and $arr[3]=~/Char/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tPN40024\n";
		$pn_lost++;
		print FA1 "$arr[0]\n";
		$all_shared_4a++;
	}
	elsif ($arr[1]=~/VIT/ and $arr[3]=~/Char/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tCab\n";
		$cab_lost++;
		print FA2 "$arr[0]\n";
		$all_shared_4a++;
	}
	elsif ($arr[1]=~/VIT/ and $arr[2]=~/VvCab/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_4a\tChar\n";
		$char_lost++;
		print FA3 "$arr[0]\n";
		$all_shared_4a++;
	}
	elsif ($arr[1]=~/VIT/ and $arr[2]=~/VvCab/ and $arr[3]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_4b\tVrip\n";
		$vrip_lost++;
		print FA4 "$arr[0]\n";
		$all_shared_4b++;
	}
	elsif ( $arr[1]=~/VIT/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Char\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/VvCab/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Char\n";
		$all_shared_3++;
	}
	elsif ( $arr[3]=~/Char/ and $arr[4]=~/vitri/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Cab\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/VIT/ and $arr[2]=~/VvCab/) {
		print OUT "$arr[0]\tAll_shared_3\tChar_Vrip\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/VIT/ and $arr[3]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Vrip\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/Cab/ and $arr[3]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Vrip\n";
		$all_shared_3++;
	}

	elsif ($arr[1]=~/VIT/) {
		print OUT "$arr[0]\tAll_shared_2\tCab_Char_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[2]=~/Cab/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Char_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[3]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Cab_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[4]=~/vitri/) {
		print OUT "$arr[0]\tWild_shared\tPN_Cab_Char\n";
		$wild++;
	}
	else{
		print OUT "$arr[0]\tSpecies_specific\tPN_Cab_Char_Vrip\n";
		$ss++;
	}
	
}
print OUT2 "PN_lost\t$pn_lost\n";
print OUT2 "Cab_lost\t$cab_lost\n";
print OUT2 "Char_lost\t$char_lost\n";
print OUT2 "Vrip_lost\t$vrip_lost\n";
print OUT2 "All_shared_5\t$all_shared_5\n";
print OUT2 "All_shared_4a\t$all_shared_4a\n";
print OUT2 "All_shared_4b\t$all_shared_4b\n";
print OUT2 "All_shared_3\t$all_shared_3\n";
print OUT2 "All_shared_2\t$all_shared_2\n";
print OUT2 "Wild_shared\t$wild\n";
print OUT2 "Species_specific\t$ss\n";

close IN;
close OUT;
close OUT2;



#Vrip

$pn_lost=0;
 $cab_lost=0;
 $char_lost=0;
 $vlab_lost=0;
 $vrip_lost=0;
 $all_shared_5=0;
 $all_shared_4a=0;
 $all_shared_4b=0;
 $all_shared_3=0;
 $all_shared_2=0;
 $wild=0;
 $ss=0;

open IN, "grape.Vrip.blocks" or die $!;
open OUT, ">Vrip.collinear.genelist";
open OUT2, ">Vrip.collinear.gene.sum";
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/VvCab/ and $arr[2]=~/Char/ and $arr[3]=~/VIT/ and $arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_5\tall\n";
		$all_shared_5++;
	}
	elsif ($arr[1]=~/VvCab/ and $arr[2]=~/Char/ and $arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_4a\tPN40024\n";
		$pn_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[3]=~/VIT/ and $arr[2]=~/Char/ and $arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_4a\tCab\n";
		$cab_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[3]=~/VIT/ and $arr[1]=~/VvCab/ and $arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_4a\tChar\n";
		$char_lost++;
		$all_shared_4a++;
	}
	elsif ($arr[3]=~/VIT/ and $arr[1]=~/VvCab/ and $arr[2]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_4b\tVlab\n";
		$vlab_lost++;
		$all_shared_4b++;
	}
	elsif ( $arr[3]=~/VIT/ and $arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Char\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/VvCab/ and $arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Char\n";
		$all_shared_3++;
	}
	elsif ( $arr[2]=~/Char/ and $arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Cab\n";
		$all_shared_3++;
	}
	elsif ( $arr[3]=~/VIT/ and $arr[1]=~/VvCab/) {
		print OUT "$arr[0]\tAll_shared_3\tChar_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[3]=~/VIT/ and $arr[2]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_3\tCab_Vlab\n";
		$all_shared_3++;
	}
	elsif ( $arr[1]=~/Cab/ and $arr[2]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_3\tPN_Vlab\n";
		$all_shared_3++;
	}

	elsif ($arr[3]=~/VIT/) {
		print OUT "$arr[0]\tAll_shared_2\tCab_Char_Vlab\n";
		$all_shared_2++;
	}
	elsif ($arr[1]=~/Cab/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Char_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[2]=~/Char/) {
		print OUT "$arr[0]\tAll_shared_2\tPN_Cab_Vrip\n";
		$all_shared_2++;
	}
	elsif ($arr[4]=~/-gene-/) {
		print OUT "$arr[0]\tWild_shared\tPN_Cab_Char\n";
		$wild++;
	}
	else{
		print OUT "$arr[0]\tSpecies_specific\tPN_Cab_Char_Vlab\n";
		$ss++;
	}
	
}
print OUT2 "PN_lost\t$pn_lost\n";
print OUT2 "Cab_lost\t$cab_lost\n";
print OUT2 "Char_lost\t$char_lost\n";
print OUT2 "Vlab_lost\t$vlab_lost\n";
print OUT2 "All_shared_5\t$all_shared_5\n";
print OUT2 "All_shared_4a\t$all_shared_4a\n";
print OUT2 "All_shared_4b\t$all_shared_4b\n";
print OUT2 "All_shared_3\t$all_shared_3\n";
print OUT2 "All_shared_2\t$all_shared_2\n";
print OUT2 "Wild_shared\t$wild\n";
print OUT2 "Species_specific\t$ss\n";

close IN;
close OUT;
close OUT2;
