## we extract the best gene model from previous Maker annotation by using AED=0.00 
perl filter.pl

## activate augustus runing environment
conda activate augustus

## compute flanking region for annotation
computeFlankingRegion.pl BestGeneModel.gff3

## convert gff into genebank format
gff2gbSmallDNA.pl BestGeneModel.gff3 primary.masked.fa 798 BestGeneModel.gb

## create parameter files for new species 

new_species.pl --species=labrusca2  ## note: please change the species name to avoid overwrite


## run etraining program to determine the quality of the gene model and filfter out poor quality ones

etraining --species=labrusca2 BestGeneModel.gb  &  > training.1.out

grep -c "Variable stopCodonExcludedFromCDS set right" training.1.out  ## this is to test if need to change the parameter stopCodonExcludedFromCDS

etraining --species=labrusca2 BestGeneModel.gb 2>&1 | grep "in sequence" | perl -pe s'/.*n sequence (\S+):.*/$1/' | sort -u > bad.lst # This will output a list recording the bad gene model

filterGenes.pl bad.lst BestGeneModel.gb > BestGeneModel.f.gb # filter bad gene model out

grep -c LOCUS BestGeneModel.gb BestGeneModel.f.gb # display the gene number difference

mv BestGeneModel.f.gb BestGeneModel.gb # replace the BestGeneModel.gb

# randomly select training dataset and testing dataset

randomSplit.pl BestGeneModel.gb 800
mv BestGeneModel.gb.test test.gb
mv BestGeneModel.gb.train train.gb

## Now you have training and testing datasets for augustus training
etraining --species=labrusca2 train.gb > etrain.out

tail -6 etrain.out | head -3

##you will get the following results, you need this information to edit the stop codon frequency for your species

#   tag:  280 (0.245)
#   taa:  308 (0.269)
#   tga:  557 (0.486)

vi ~/miniconda2/envs/augustus/config/species/labrusca2/labrusca2_parameters.cfg # open this file and change the parameters

# use corrected parameter to evaluate the test dataset

augustus --species=labrusca2 test.gb > test.out


## open test.out and read the information by the end of the file

tail -n 50 test.out

# you will set this information. This is much better than the result when using parameter from Arabidopsis

*******      Evaluation of gene prediction     *******

---------------------------------------------\
                 | sensitivity | specificity |
---------------------------------------------|
nucleotide level |       0.978 |       0.965 |
---------------------------------------------/

----------------------------------------------------------------------------------------------------------\
           |  #pred |  #anno |      |    FP = false pos. |    FN = false neg. |             |             |
           | total/ | total/ |   TP |--------------------|--------------------| sensitivity | specificity |
           | unique | unique |      | part | ovlp | wrng | part | ovlp | wrng |             |             |
----------------------------------------------------------------------------------------------------------|
           |        |        |      |                318 |                294 |             |             |
exon level |   1188 |   1164 |  870 | ------------------ | ------------------ |       0.747 |       0.732 |
           |   1188 |   1164 |      |  185 |   12 |  121 |  185 |   14 |   95 |             |             |
----------------------------------------------------------------------------------------------------------/

----------------------------------------------------------------------------\
transcript | #pred | #anno |   TP |   FP |   FN | sensitivity | specificity |
----------------------------------------------------------------------------|
gene level |   858 |   798 |  608 |  250 |  190 |       0.762 |       0.709 |
----------------------------------------------------------------------------/

------------------------------------------------------------------------\
            UTR | total pred | CDS bnd. corr. |   meanDiff | medianDiff |
------------------------------------------------------------------------|
            TSS |         49 |              0 |         -1 |         -1 |
            TTS |         23 |              0 |         -1 |         -1 |
------------------------------------------------------------------------|
            UTR | uniq. pred |    unique anno |      sens. |      spec. |
------------------------------------------------------------------------|
                |  true positive = 1 bound. exact, 1 bound. <= 20bp off |
 UTR exon level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------|
 UTR base level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------/







#head -n 5995 BestGeneModel.gff3 > training.gff3
#gff2gbSmallDNA.pl training.gff3 primary.masked.fa 798 training.gb
#tail -n 4902 BestGeneModel.gff3 > testing.gff3
#gff2gbSmallDNA.pl testing.gff3 primary.masked.fa 798 testing.gb






