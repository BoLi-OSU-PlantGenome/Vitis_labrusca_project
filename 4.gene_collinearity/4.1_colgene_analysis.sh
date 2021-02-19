## This pipeline is used to identify collinear genes amoung different grape genomes

## 1. build pairwise collinear gene blocks 

perl pairwise_colgene_analysis.pl

## do summary with collinear genes analysis

perl Pair_wise_collinearGene_analysis.pl 

## 2. classify genes into different groups based on the collinearity

perl Classify_gene_collinearity.pl

## 3. identify lost gene and gene movement events

perl blast_lostgene_PNref.pl

perl geneLost_sum_PNref.pl

