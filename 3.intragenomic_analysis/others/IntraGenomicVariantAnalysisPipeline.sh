## This script is to identify three levels of genetic variants between two homologous chromosomes and identify hemizygous, heterozygous and homozygous genes
## Before running this program, run ngmlr, sniff and longshot to call the genetic variants first

## qsub run_Sniffles.pbs

## qsub run_longshot.pbs


## Step1: SV analysis: summrize SV type and SV count

perl 1.SV_type_sum.pl Char

## Step2: identify hemizygous genes

perl 2.IdentyHemiGenebyNGMLR.pl Char

## Step 3: identify heterozygous genes caused by SV
## require bed file and cds bed file

perl 3.SVindel_heterozygousGene.pl Char

## Step4: identify heterozygous genes caused by small indel

perl 4.Small_Indel_heterozygousGene.pl Char

