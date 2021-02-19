## This pipeline is used to analyze TE evolution and TE regulation

## Beore this analysis, TE annotation has been perfomed with all five grape genomes.

## 1. identify TE insertion polymorphism for upstream, gene body and downstream

perl 1.TE_polymorphsm_Analysis.pl

## 2. compared TE proportion for collinear genes among five grapes

perl 2.TE_polymorphism_sum.pl

## 3. identify candidate genes which show TE regulated gene expression differences

perl 3.combinedGeneExpWithTEprop.pl

perl 4.compareTPM4VariableTEColgene.pl

perl 5.find_candidate.pl

## find TE differentially regulated genes between cultivated and wild grapes

perl 6.find_TE_dif_regulate_genes.pl

perl 7.0_filterOutTEGeneModel copy.pl

perl 7.TE_geneExp_mean.pl
