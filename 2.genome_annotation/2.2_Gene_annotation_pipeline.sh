
# 1. run maker with Arabidopsis parameter, then selected the best gene model to train augustus

## we extract the best gene model from previous Maker annotation by using AED=0.00 
perl quality_filter.pl  -a 0.001  labrusca.V1.fasta.all.gff > BestGeneModel.gff

## compute flanking region for annotation

computeFlankingRegion.pl BestGeneModel.gff

## convert gff into genebank format
gff2gbSmallDNA.pl BestGeneModel.gff  ../../labrusca.V1.fasta.masked 889 BestGeneModel.gb

## mainrain multiple exon gene models

perl multipleExonGeneModelSelection.pl

# 2. train augustus with these best gene models

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

# 3. snap training

mkdir snap1
cd snap1/
cp ../../Maker_final/Redo_newAugustus/labrusca.V1.fasta.maker.output/labrusca.V1.fasta.all.gff .
maker2zff labrusca.V1.fasta.all.gff 
athom -categorize 1000 genome.ann  genome.dna 
fathom -export 1000 -plus uni.ann uni.dna 
forge export.ann export.dna 
hmm-assembler.pl labrusca_snap1 . > labrusca_snap1.hmm


# 4. re-run Maker 
maker -CTL

## modify the control files 

maker

cd labrusca.V1.fasta.maker.output/

fasta_merge -d labrusca.V1.fasta_master_datastore_index.log

gff3_merge -d labrusca.V1.fasta_master_datastore_index.log

perl quality_filter.pl ## to extract high quality gene models


# 5. 

# 6. BUSCO assessment

/users/PAS1444/li10917/miniconda2/envs/BUSCO/bin/run_BUSCO.py -i labrusca.V1.fasta.default.functional_ipr.fasta  -o Maker_default  -l ../embryophyta_odb9 -m prot --cpu 10





