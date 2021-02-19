#!usr/bin/perl

use strict;
use warnings;
open OUT, ">grape.collinearGene.pairwise.sum";

## PN40024
open IN, "grape.PN40024.blocks" or die $!;
open OUT1, ">PN_cab.noncolgene.list";
open OUT2, ">PN_char.noncolgene.list";
open OUT3, ">PN_vrip.noncolgene.list";
open OUT4, ">PN_vlab.noncolgene.list";
my $pn_cab=0;
my $pn_char=0;
my $pn_vlab=0;
my $pn_vrip=0;
my $total=0;

while (<IN>) {
	$total++;
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/Cab/) {
		$pn_cab++;
	}
	if ($arr[1] eq "\.") {
		print OUT1 "$arr[0]\n";
	}
	#if ($arr[2]=~/Char/) {
	if ($arr[2] eq "\.") {
		$pn_char++;
		print OUT2 "$arr[0]\n";
	}
	#if ($arr[3]=~/-gene-/) {
	if ($arr[3] eq "\.") {
		$pn_vlab++;
		print OUT3 "$arr[0]\n";
	}
	#if ($arr[4]=~/vitri/) {
	if ($arr[4] eq "\.") {
		$pn_vrip++;
		print OUT4 "$arr[0]\n";
	}
}

my $pn_cab_non=$total-$pn_cab;
my $pn_char_non=$total-$pn_char;
my $pn_vrip_non=$total-$pn_vrip;
my $pn_vlab_non=$total-$pn_vlab;


print OUT "\t$pn_cab\/$pn_cab_non\t$pn_char\/$pn_char_non\t$pn_vrip\/$pn_vrip_non\t$pn_vlab\/$pn_vlab_non\n";

close IN;
close OUT1;
close OUT2;
close OUT3;
close OUT4;

## Cab
open IN, "grape.Cab.blocks" or die $!;
my $cab_pn=0;
my $cab_char=0;
my $cab_vlab=0;
my $cab_vrip=0;
$total=0;

while (<IN>) {
	$total++;
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/Char/) {
		$cab_char++;
	}
	if ($arr[2]=~/VIT/) {
		$cab_pn++;
	}
	if ($arr[3]=~/-gene-/) {
		$cab_vlab++;
	}
	if ($arr[4]=~/vitri/) {
		$cab_vrip++;
	}
}

my $cab_pn_non=$total-$cab_pn;
my $cab_char_non=$total-$cab_char;
my $cab_vrip_non=$total-$cab_vrip;
my $cab_vlab_non=$total-$cab_vlab;


print OUT "$cab_pn\/$cab_pn_non\t\t$cab_char\/$cab_char_non\t$cab_vrip\/$cab_vrip_non\t$cab_vlab\/$cab_vlab_non\n";

close IN;
# Char

open IN, "grape.Char.blocks" or die $!;
my $char_pn=0;
my $char_cab=0;
my $char_vlab=0;
my $char_vrip=0;
$total=0;

while (<IN>) {
	$total++;
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/Cab/) {
		$char_cab++;
	}
	if ($arr[2]=~/VIT/) {
		$char_pn++;
	}
	if ($arr[3]=~/-gene-/) {
		$char_vlab++;
	}
	if ($arr[4]=~/vitri/) {
		$char_vrip++;
	}
}

my $char_pn_non=$total-$char_pn;
my $char_cab_non=$total-$char_cab;
my $char_vrip_non=$total-$char_vrip;
my $char_vlab_non=$total-$char_vlab;


print OUT "$char_pn\/$char_pn_non\t$char_cab\/$char_cab_non\t\t$char_vrip\/$char_vrip_non\t$char_vlab\/$char_vlab_non\n";
close IN;
# Vrip

open IN, "grape.Vrip.blocks" or die $!;
my $vrip_pn=0;
my $vrip_cab=0;
my $vrip_char=0;
my $vrip_vlab=0;
$total=0;

while (<IN>) {
	$total++;
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/Cab/) {
		$vrip_cab++;
	}
	if ($arr[2]=~/Char/) {
		$vrip_char++;
	}
	if ($arr[3]=~/VIT/) {
		$vrip_pn++;
	}
	if ($arr[4]=~/-gene-/) {
		$vrip_vlab++;
	}
}

my $vrip_pn_non=$total-$vrip_pn;
my $vrip_cab_non=$total-$vrip_cab;
my $vrip_char_non=$total-$vrip_char;
my $vrip_vlab_non=$total-$vrip_vlab;


print OUT "$vrip_pn\/$vrip_pn_non\t$vrip_cab\/$vrip_cab_non\t$vrip_char\/$vrip_char_non\t\t$vrip_vlab\/$vrip_vlab_non\n";

close IN;
# Vlab

open IN, "grape.Vlab.blocks" or die $!;
my $vlab_pn=0;
my $vlab_cab=0;
my $vlab_char=0;
my $vlab_vrip=0;
$total=0;

while (<IN>) {
	$total++;
	chomp;
	my @arr=split("\t",$_);
	if ($arr[1]=~/VIT/) {
		$vlab_pn++;
	}
	if ($arr[2]=~/Cab/) {
		$vlab_cab++;
	}
	if ($arr[3]=~/Char/) {
		$vlab_char++;
	}
	if ($arr[4]=~/vitri/) {
		$vlab_vrip++;
	}
}

my $vlab_pn_non=$total-$vlab_pn;
my $vlab_cab_non=$total-$vlab_cab;
my $vlab_char_non=$total-$vlab_char;
my $vlab_vrip_non=$total-$vlab_vrip;


print OUT "$vlab_pn\/$vlab_pn_non\t$vlab_cab\/$vlab_cab_non\t$vlab_char\/$vlab_char_non\t$vlab_vrip\/$vlab_vrip_non\n";
close IN;
close OUT;
