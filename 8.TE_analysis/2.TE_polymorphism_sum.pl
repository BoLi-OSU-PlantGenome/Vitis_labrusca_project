#!usr/bin/perl

use strict;
use warnings;

## build collinear gene TE proportion data matrix

open IN, "grape.Vlabref.collinear.list.rmdup.pn.cab.char.vrip" or die $!;
open OUT, ">grape.collinear.list";
my $n=0;
while (<IN>) {
	$n++;
	my $colID="colgene_".$n;
	print OUT "$colID\t$_";
}
close IN;
close OUT;

my %pn;
open IN, "PN40024.bed" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $pos=$arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[5];
	$pn{$arr[3]}=$pos;
}
close IN;

my %cab;
open IN, "Cab.bed" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $pos=$arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[5];
	$cab{$arr[3]}=$pos;
}
close IN;

my %char;
open IN, "Char.bed" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $pos=$arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[5];
	$char{$arr[3]}=$pos;
}
close IN;

my %vrip;
open IN, "Vrip.bed" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $pos=$arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[5];
	$vrip{$arr[3]}=$pos;
}
close IN;

my %vlab;
open IN, "Vlab.bed" or die $!;
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	my $pos=$arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[5];
	$vlab{$arr[3]}=$pos;
}
close IN;

open IN, "grape.collinear.list" or die $!;
open OUT, ">PN40024.collinear.gene.bed";
open OUT2, ">Cab.collinear.gene.bed";
open OUT3, ">Char.collinear.gene.bed";
open OUT4, ">Vrip.collinear.gene.bed";
open OUT5, ">Vlab.collinear.gene.bed";
while (<IN>) {
	chomp;
	my @arr=split("\t",$_);
	if (exists $vlab{$arr[2]}) {
		print OUT5 "$vlab{$arr[2]}\t$arr[2]\t$arr[0]\n";
	}
	if (exists $pn{$arr[4]}) {
		print OUT "$pn{$arr[4]}\t$arr[4]\t$arr[0]\n";
	}
	if (exists $cab{$arr[6]}) {
		print OUT2 "$cab{$arr[6]}\t$arr[6]\t$arr[0]\n";
	}
	if (exists $char{$arr[8]}) {
		print OUT3 "$char{$arr[8]}\t$arr[8]\t$arr[0]\n";
	}
	if (exists $vrip{$arr[10]}) {
		print OUT4 "$vrip{$arr[10]}\t$arr[10]\t$arr[0]\n";
	}	
}

close IN;
close OUT;
close OUT2;
close OUT3;
close OUT4;
close OUT5;


## gene body LTR proportion
my @species=("PN40024","Cab","Char","Vlab","Vrip");
foreach my $sp (@species){
	`~/miniconda2/envs/biotools/bin/bedtools intersect -a $sp.LTR.merged.bed -b $sp.collinear.gene.bed -wo > $sp.LTR.genebody.bed`;
		open IN, "$sp.LTR.genebody.bed" or die $!;
        open OUT, ">$sp.LTR.genebody.bed.combined";
        my @whole=<IN>;
        my @tmp=split("\t",$whole[0]);
        my $init=$tmp[9];
        my $sum=0;
        my $colID;
        my $geneID;
        my $type; 
        my $genelen=0; 
        foreach(@whole){
                chomp;
                my @arr=split("\t",$_);
                if ($arr[9] eq $init) {
                        $sum=$sum+$arr[11];
                        $colID=$arr[10];
                        $geneID=$arr[9];
                        $type=$arr[4];
                        $genelen=abs($arr[7]-$arr[6]);
                }
                else{  
                		my $prop=$sum/$genelen; 
                        print OUT "$colID\t$geneID\t$prop\t$type\n";
                        $init=$arr[9];
                        $colID=$arr[10];
                        $geneID=$arr[9];
                        $sum=$arr[11];
                        $genelen=abs($arr[7]-$arr[6]);

                        
                }
        }
        print OUT "$colID\t$geneID\t$sum\t$type\n"; #print the last record
        close IN;
        close OUT;
}

## gene body MITE proportion
foreach my $sp (@species){
		`~/miniconda2/envs/biotools/bin/bedtools intersect -a $sp.MITE.merged.bed -b $sp.collinear.gene.bed -wo > $sp.MITE.genebody.bed`;
        open IN, "$sp.MITE.genebody.bed" or die $!;
        open OUT, ">$sp.MITE.genebody.bed.combined";
        my @whole=<IN>;
        my @tmp=split("\t",$whole[0]);
        my $init=$tmp[9];
        my $sum=0;
        my $colID;
        my $geneID;
        my $type; 
        my $genelen=0;  
        foreach(@whole){
                chomp;
                my @arr=split("\t",$_);
                if ($arr[9] eq $init) {
                        $sum=$sum+$arr[11];
                        $colID=$arr[10];
                        $geneID=$arr[9];
                        $type=$arr[4];
                        $genelen=abs($arr[7]-$arr[6]);
                }
                else{   
                		my $prop=$sum/$genelen;
                        print OUT "$colID\t$geneID\t$prop\t$type\n";
                        $init=$arr[9];
                        $colID=$arr[10];
                        $geneID=$arr[9];
                        $sum=$arr[11];
                }
        }
        print OUT "$colID\t$geneID\t$sum\t$type\n"; #print the last record
        close IN;
        close OUT;
}

## prepare table contain all information 
foreach my $sp (@species){
	my %up_ltr;
	my %up_mite;
	my %gb_ltr;
	my %gb_mite;
	my %dw_ltr;
	my %dw_mite;

	open IN, "$sp.collinear.1k_upstream.bed.LTR.bed.combined" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		my $tmp=$arr[2]/1000;
		my $prop=sprintf("%.2f",$tmp);
		#my $value=$arr[1]."\t".$prop;
		$up_ltr{$arr[0]}=$prop;
	}
	close IN;

	open IN, "$sp.collinear.1k_upstream.bed.MITE.bed.combined" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		my $tmp=$arr[2]/1000;
		my $prop=sprintf("%.2f",$tmp);
		#my $value=$arr[1]."\t".$prop;
		$up_mite{$arr[0]}=$prop;
	}
	close IN;

	open IN, "$sp.LTR.genebody.bed.combined" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		#my $tmp=$arr[2]/1000;
		my $prop=sprintf("%.2f",$arr[2]);
		#my $value=$arr[1]."\t".$prop;
		$gb_ltr{$arr[0]}=$prop;
	}
	close IN;

	open IN, "$sp.MITE.genebody.bed.combined" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		#my $tmp=$arr[2]/1000;
		my $prop=sprintf("%.2f",$arr[2]);
		#my $value=$arr[1]."\t".$prop;
		$gb_mite{$arr[0]}=$prop;
	}
	close IN;

	open IN, "$sp.collinear.1k_downstream.bed.LTR.bed.combined" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		my $tmp=$arr[2]/1000;
		my $prop=sprintf ("%.2f",$tmp);
		#my $value=$arr[1]."\t".$prop;
		$dw_ltr{$arr[0]}=$prop;
	}
	close IN;

	open IN, "$sp.collinear.1k_downstream.bed.MITE.bed.combined" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		my $tmp=$arr[2]/1000;
		my $prop=sprintf("%.2f",$tmp);
		#my $value=$arr[1]."\t".$prop;
		$dw_mite{$arr[0]}=$prop;
	}
	close IN;


	open OUT, ">$sp.TE_prop.table";
	print OUT "ColID\tGeneName\tLTR_prop_1k_upstream\tLTR_gene_body\tLTR_prop_1k_downstream\tMITE_prop_1k_upstream\tMITE_gene_body\tMITE_prop_1k_downstream\n";
	open IN, "$sp.collinear.gene.bed" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		if (exists $up_ltr{$arr[5]}) {
			print OUT "$arr[5]\t$arr[4]\t$up_ltr{$arr[5]}\t";
		}
		else{
			print OUT "$arr[5]\t$arr[4]\t0\t";
		}
		if (exists $gb_ltr{$arr[5]}) {
			print OUT "$gb_ltr{$arr[5]}\t";
		}
		else{
			print OUT "0\t";
		}
		if (exists $dw_ltr{$arr[5]}) {
			print OUT "$dw_ltr{$arr[5]}\t";
		}
		else{
			print OUT "0\t";
		}
		if (exists $up_mite{$arr[5]}) {
			print OUT "$up_mite{$arr[5]}\t";
		}
		else{
			print OUT "0\t";
		}
		if (exists $gb_mite{$arr[5]}) {
			print OUT "$gb_mite{$arr[5]}\t";
		}
		else{
			print OUT "0\t";
		}
		if (exists $dw_mite{$arr[5]}) {
			print OUT "$dw_mite{$arr[5]}\n";
		}
		else{
			print OUT "0\n";
		}
	}
	close IN;
	close OUT;
}


## do some summary

# gene count with TE insertion within 5'UTR, gb and 3'UTR
# prepare file for venn diagram

my @allfile=glob("*.combined");
foreach my $each (@allfile){
	`cut -f 1 $each > $each.colID`;
}

`mkdir vennDiagram_input`;
`mv *.colID vennDiagram_input`;

## 5'UTR TE polymorphism

foreach my $sp (@species){
	open IN, "$sp.TE_prop.table" or die $!;
	open OUT, ">$sp.5utr.TE_total_prop.txt";
	while (<IN>) {
		next if(/^ColID/);
		my @arr=split("\t",$_);
		my $total=$arr[2]+$arr[5];
		print OUT "$arr[0]\t$arr[1]\t$total\n";
	}
	close IN;
	close OUT;
}

## PAV of TE insertion if at least one genome have 0 TE prop and at least one genome has 10% TE prop

`cut -f 2,3 Cab.5utr.TE_total_prop.txt>001`;
`cut -f 2,3 Char.5utr.TE_total_prop.txt>002`;
`cut -f 2,3 Vlab.5utr.TE_total_prop.txt>003`;
`cut -f 2,3 Vrip.5utr.TE_total_prop.txt>004`;
`paste PN40024.5utr.TE_total_prop.txt 001 002 003 004 > allGrape.TE_total_prop.txt`;
`rm 001 002 003 004 `;

open IN, "allGrape.TE_total_prop.txt" or die $!;
open OUT, ">allGrape.TE_insertion_5UTR.polymorphism.loci.list";
while (<IN>) {
	chomp;
	my $line=$_;
	my @arr=split("\t",$line);
	my @total=();
	push @total,$arr[2];
	push @total,$arr[4];
	push @total,$arr[6];
	push @total,$arr[8];
	push @total,$arr[10];
	my @sort=sort (@total);
	if ($sort[0] == 0 and $sort[-1] >= 0.1) {
		print OUT "$line\n";
	}
}

close IN;
close OUT;

`mkdir collinear_gene_TE_table`;
`cp *.TE_total_prop.txt collinear_gene_TE_table`;



=pod
my $pn_3utr_ltr=0;
my $pn_gb_ltr=0;
my $pn_5utr_ltr=0;
my $cab_3utr_ltr=0;
my $cab_gb_ltr=0;
my $cab_5utr_ltr=0;
my $char_3utr_ltr=0;
my $char_gb_ltr=0;
my $char_5utr_ltr=0;
my $vlab_3utr_ltr=0;
my $vlab_gb_ltr=0;
my $vlab_5utr_ltr=0;
my $vrip_3utr_ltr=0;
my $vrip_gb_ltr=0;
my $vrip_5utr_ltr=0;















