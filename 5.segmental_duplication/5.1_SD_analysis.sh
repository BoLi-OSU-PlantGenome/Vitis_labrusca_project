## This pipeline is used to identify segmental duplication genome wide and conduct downstream analysis

## 1. SD identification in each of five genome

perl run_Mummer.pl

## 2. do summary

perl sum_SD.pl

## 3. filter out TE like genes 

perl filterOutTEGene.pl

## 4. identify different groups of SD derived genes

perl IdentifySubgroupAndSpecificGene.pl


