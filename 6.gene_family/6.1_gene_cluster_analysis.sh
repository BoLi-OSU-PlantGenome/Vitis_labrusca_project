# by using the all protein sequences from five grape genome to identify gene clusters (gene family) and single copy orthlogous groups

## 1. run orthofinder to cluster proteins

~/local/OrthoFinder/orthofinder  -t 10 -f clean_pep_data -S diamond ## all protein sequences were stored within clean_pep_data directory 

perl orthoFinder_sum.pl


## 2. convert the results to input for venn diagram drawing

perl prepareInputFromOrthFinder4VennDraw.pl

## 3. functional annotation and enrichment analysis

Rscript SpecieSpecificGOenrich.R