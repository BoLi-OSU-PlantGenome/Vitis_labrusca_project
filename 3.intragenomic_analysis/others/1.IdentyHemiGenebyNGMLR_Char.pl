#!usr/bin/perl
use strict;
use warnings;

## This script is to identify hemizygous genes and potential heterozygous genes based on NGMLR mapping approach

open IN, "ngmlr.Char.vcf" or die $!; ## which is the sv calling results > 2 bp

# remove insertion and deletion larger than 1 Mb

open OUT, ">ngmlr.Char.lt1M.vcf"; ## this file is used to find hemizygous genes

while (<IN>) {
	if (/^\#/) {
		print OUT "$_";
		next;
	}
	else{
		if (/SVTYPE=DEL/ or /SVTYPE=INS/) {
			if (/SVLEN=(\d+)/ or /SVLEN=-(\d+)/) {
				my $len=$1;
				if ($len>2 and $len<1000000) {
					print OUT "$_";
				}
			}
		}

	}
}

close IN;
close OUT;



### format vcf 2 bed
open IN, "ngmlr.Char.lt1M.vcf" or die $!;
open OUT, ">ngmlr.Char.lt1M.bed";
print OUT "Chr\tstart\tend\tID\tquality\tSVTYPE\tSUPTYPE\tSVLEN\tSupportReads\tReferenceReads\tTotalReads\n";
while (<IN>) {
	next if(/\#/);
	next if(/random/);
	next if (/Chr0/);
	next if(/Un/i);
	#next unless (/0\/1/); # we only consider heterozygous sites
	my @arr=split("\t",$_); 
	my $Chr=$arr[0];
	$Chr=~s/_RaGOO//;
	my $start=$arr[1];
	my $ID=$arr[2];
	my @tmp=split(";",$arr[7]);

	#PRECISE;SVMETHOD=Snifflesv1.0.11;CHR2=1;END=519108;ZMW=11;STD_quant_start=0.000000;
	#STD_quant_stop=0.000000;Kurtosis_quant_start=3.107266;Kurtosis_quant_stop=2.739645;
	#SVTYPE=DEL;SUPTYPE=AL;SVLEN=-430;STRANDS=+-;RE=15;REF_strand=43;AF=0.348837
	
	my $quality=$tmp[0];
	my $end=0;
	my $svtype;
	my $subtype;
	my $svlen=0;
	my $sr=0;
	my $rr=0;
	my $tr=0;
	foreach $a (@tmp){
		#if ($a=~/PRECISE/i or $a=~/IMPRECISE/i) {
		#	$quality=$1;
		#}
		if($a=~/END=(\d+)/){
			$end=$1;
		}
		elsif($a=~/SVTYPE=(\w+)/){
			$svtype=$1;
		}
		elsif($a=~/SUPTYPE=(\w+)/){
			$subtype=$1;
		}
		elsif($a=~/SVLEN=(.*)/){
			$svlen=$1;
		}
		elsif($a=~/RE=(\d+)/){
			$sr=$1;
		}
		elsif($a=~/REF_strand=(\d+)/){
			$tr=$1;
		}
		$rr=$tr-$sr;
	}
	print OUT "$Chr\t$start\t$end\t$ID\t$quality\t$svtype\t$subtype\t$svlen\t$sr\t$rr\t$tr\n";
			
}

close IN;
close OUT;


### find hemizygous genes

`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a Char.bed  -b  ngmlr.Char.lt1M.bed -f 1 > Char.hemizygousGene.lt1M.bed`; 

#heterozygous and hemizygous genes
#`grep "Chr" ngmlr.Char.Indel.lt1M.bed >ngmlr.Char.insertion.lt1M.bed`;
#`grep "INS" ngmlr.Char.Indel.lt1M.bed >>ngmlr.Char.insertion.lt1M.bed`;
#`grep "Chr" ngmlr.Char.Indel.lt1M.bed >ngmlr.Char.deltion.lt1M.bed`;
#`grep "DEL" ngmlr.Char.Indel.lt1M.bed >>ngmlr.Char.deltion.lt1M.bed`;

##
#`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a ngmlr.Char.deltion.lt1M.bed  -b  Vlab.chr.cds.bed -f 0.1 > Char.geneOverlapWithDel.lt1M.bed`; 
#`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a ngmlr.Char.insertion.lt1M.bed  -b Vlab.chr.cds.bed  -f 1 > Char.geneOverlapWithIns.lt1M.bed`; 

#`grep -c "DEL" ngmlr.Char.Indel.lt1M.bed `;
#`grep -c "INS" ngmlr.Char.Indel.lt1M.bed `;
#`wc -l Char.geneOverlapWithDel.lt1M.bed`;
#`wc -l Char.geneOverlapWithIns.lt1M.bed`;


#`cat Char.geneOverlapWithDel.lt1M.bed Char.geneOverlapWithIns.lt1M.bed > Char.geneOverlapINDEL.lt1M.bed`;


open IN, "Char.hemizygousGene.lt1M.bed" or die $!;
open OUT, ">Char.hemizygousGene.lt1M.list";
my @genelist=(); # hemizygous gene
while (<IN>) {
	my @arr=split("\t",$_);
	push @genelist,$arr[3];
}
my @uniq=uniq(@genelist);
foreach(@uniq){
	print OUT "$_\n";
}
close IN;
close OUT;

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

=pod

my %hemi;
open IN, "Char.hemizygousGene.lt1M.list" or die $!;
while (<IN>) {
	chomp;
	$hemi{$_}=1;
}
close IN;

open IN, "Char.geneOverlapINDEL.lt1M.bed" or die $!;
open OUT, ">Char.heterozygousGene.lt1M.list";
my @genelist2=(); # heterozygous and hemizygous genes
while (<IN>) {
	my @arr=split("\t",$_);
	push @genelist2,$arr[3];
}
my @uniq2=uniq(@genelist2);
foreach(@uniq2){
	if (exists $hemi{$_}) {
		next;
	}
	else{
		print OUT "$_\n";
	}
	
}

close IN;
close OUT;



## functional annotation about the hemizygous genes


=pod
open IN, "Vlab.pep.GO.lock" or die $!;
my @whole=<IN>;
chomp @whole;
shift @whole;
close IN;

open IN, "Char.hemizygousGene.lt1M.list" or die $!;
open OUT, ">Char.hemizygousGene.lt1M.list.GOannotation";
while (<IN>) {
	chomp;
	my $line=$_;
	my @grep=grep /$line/,@whole;
	foreach my $a (@grep){
		print OUT "$a\n";
	}
}
close IN;
close OUT;

open IN, "Char.hemizygousGene.lt1M.list.GOannotation" or die $!;
open OUT, ">Char.hemizygousGene.lt1M.list.GOannotation.barplot4R";
my @id=();
while (<IN>) {
	next if (/molecular_function/ or /cellular_component/);
	my @arr=split("\t",$_);
	push @id,$arr[3];
}

my %count;
   $count{$_}++ foreach @id;

    while (my ($key, $value) = each(%count)) {
        if ($value > 1) {
                print OUT "$key\t$value\n";
                }
    }

`sort -n -r -k 2 Char.hemizygousGene.lt1M.list.GOannotation.barplot4R >Char.hemizygousGene.lt1M.list.GOannotation.barplot4R.sort `;







sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}






