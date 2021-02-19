#!usr/bin/perl
use strict;
use warnings;

open IN, "ngmlr.$ARGV[0].bed" or die $!;
open OUT, ">smallIndel.ngmlr.$ARGV[0].bed";
while (<IN>) {
	if (/^Chr/) {
		print OUT "$_";
		next;
	}
	my $line=$_;
	my @arr=split("\t",$_);
	if (abs($arr[7]) >=2 and abs($arr[7])<=30 ) {
		print OUT "$line";
	}
}
close IN;
close OUT;

## do summary on small indel and heterozygous genes

my $total_indel=0;
my $insertion=0;
my $deletion=0;
my $insertion_gene=0;
my $deletion_gene=0;
my $insertion_exon=0;
my $deletion_exon=0; ## 10% overlap


open IN, "smallIndel.ngmlr.$ARGV[0].bed" or die $!;
my @arr1=<IN>;
my $arr1=@arr1;
close IN;
$total_indel=$arr1-1;

`grep "INS" smallIndel.ngmlr.$ARGV[0].bed > smallIndel.insertion.ngmlr.$ARGV[0].bed`;
`grep "DEL" smallIndel.ngmlr.$ARGV[0].bed > smallIndel.deletion.ngmlr.$ARGV[0].bed`;

open IN, "smallIndel.insertion.ngmlr.$ARGV[0].bed" or die $!;
my @arr2=<IN>;
my $arr2=@arr2;
close IN;
$insertion=$arr2;

open IN, "smallIndel.deletion.ngmlr.$ARGV[0].bed" or die $!;
my @arr3=<IN>;
my $arr3=@arr3;
close IN;
$deletion=$arr3;

## gene overlap
`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a smallIndel.deletion.ngmlr.$ARGV[0].bed  -b  $ARGV[0].bed -f 0.1 > geneOverlap.del.bed`; 
#`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a $ARGV[0].bed  -b  smallIndel.deletion.ngmlr.$ARGV[0].bed -f 0.1 > geneOverlap.del.bed`; 

`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a smallIndel.insertion.ngmlr.$ARGV[0].bed  -b $ARGV[0].bed  -f 1 > geneOverlap.ins.bed`; 

## cds overlap
`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a smallIndel.deletion.ngmlr.$ARGV[0].bed  -b  $ARGV[0].chr.cds.bed -f 0.1 > CDSOverlap.del.bed`; 
`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a smallIndel.insertion.ngmlr.$ARGV[0].bed  -b $ARGV[0].chr.cds.bed -f 1 > CDSOverlap.ins.bed`; 

open IN, "geneOverlap.del.bed" or die $!;
my @genelist=(); # deletion within gene
while (<IN>) {
	$deletion_gene++;
	my @arr=split("\t",$_);
	push @genelist,$arr[14];
}
my @uniq=uniq(@genelist);
my $uniq=@uniq;
close IN;
my $gene_with_deletion=$uniq;

open IN, "geneOverlap.ins.bed" or die $!;
my @genelist2=(); # deletion within gene
while (<IN>) {
	$insertion_gene++;
	my @arr=split("\t",$_);
	push @genelist2,$arr[14];
}
my @uniq2=uniq(@genelist2);
my $uniq2=@uniq2;

my $gene_with_insertion=$uniq2;
close IN;


open IN, "CDSOverlap.ins.bed" or die $!;
my @genelist3=(); # deletion within gene
while (<IN>) {
	$insertion_exon++;
	my @arr=split("\t",$_);
	push @genelist3,$arr[14];
}
my @uniq3=uniq(@genelist3);
my $uniq3=@uniq3;

my $exon_with_insertion_exon=$uniq3;
close IN;


open IN, "CDSOverlap.del.bed" or die $!;
my @genelist4=(); # deletion within gene
while (<IN>) {
	$deletion_exon++;
	my @arr=split("\t",$_);
	push @genelist4,$arr[14];
}
my @uniq4=uniq(@genelist4);
my $uniq4=@uniq4;

my $exon_with_deletion=$uniq4;
close IN;

my $insertion_intron=$insertion_gene-$insertion_exon;
my $insertion_intergenic=$insertion-$insertion_gene;

my $deletion_intron=$deletion_gene-$deletion_exon;
my $deletion_intergenic=$deletion-$deletion_gene;


open OUT, ">$ARGV[0].heterozygousGene.GeneSequenceChanged.smallIndel.list";
my @hete_gene=(@uniq,@uniq2);

my @uniq_hete_gene=uniq(@hete_gene);

foreach(@uniq_hete_gene){
	print OUT "$_\n";
}
close OUT;

my $uniq_hete_gene=@uniq_hete_gene;


open OUT, ">$ARGV[0].heterozygousGene.proteinSequenceChanged.smallIndel.list";
my @hete_cds=(@uniq3,@uniq4);

my @uniq_hete_cds=uniq(@hete_cds);

foreach(@uniq_hete_cds){
	print OUT "$_";
}
close OUT;

my $uniq_hete_cds=@uniq_hete_cds;
close OUT;




open OUT, ">$ARGV[0].ngmlr.smallIndel.sum";
print OUT "SV_type\tGenomic_feature\tCount\n";
print OUT "Indel\tTotal\t$total_indel\n";
print OUT "Insertion\tTotal\t$insertion\n";
print OUT "\tIntergenic region\t$insertion_intergenic\n";
print OUT "\tIntron\t$insertion_intron\n";
print OUT "\tExon\t$insertion_exon\n";

print OUT "Deletion\tTotal\t$deletion\n";
print OUT "\tIntergenic region\t$deletion_intergenic\n";
print OUT "\tIntron\t$deletion_intron\n";
print OUT "\tExon\t$deletion_exon\n";

print OUT "Heterozygous genes (sequence level)\t\t$uniq_hete_gene\n";
print OUT "Heterozygous genes (protein level)\t\t$uniq_hete_cds\n";

close OUT;






sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}



