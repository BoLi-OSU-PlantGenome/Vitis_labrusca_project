## this pipeline is used to identify NLR gene family and do some downstream analysis


## 1. run domain search

for fa in Vlabrusca.pep.fa Vriparia.pep.fa Vv12X.pep.fa Cab08.pep.fa Char.pep.fa
do
/fs/project/PAS1444/projects/1_labrusca_wgs/workdir/3_genomeAnnotation/GO_anno/interproscan-5.39-77.0/interproscan.sh --cpu 4 -appl \
PfamA,COILS -iprlookup -goterms -f tsv -i $fa
done

## 2. extract NLR domains, extract protein based on the identified pfam domians

bash extract_domains.sh

# 3. detect overlap among different domains and identify NLR and subgroups

perl NLR_finder.pl

# 4. integrated domain analysis

perl IntegretedDomain.pl

## 5. phylogenetic analysis

# run mafft to align

~/local/phylo/mafft --auto grape.test.pep.fa  > grape.TNLs.pep.fa.aln
~/local/phylo/trimAl/source/trimal -in grape.TNLs.pep.fa.aln  -out grape.TNLs.pep.fa.trimA.aln -htmlout grape.TNLs.pep.fa.trimA.aln.html -gt 0.7 -st 0.001 -cons 60 
~/local/phylo/standard-RAxML/raxmlHPC -T 10 -f a -N 500 -m PROTGAMMAJTT -x 123456 -p 123456 -s grape.TNLs.pep.fa.trimA.aln -n grape.TNLs.nwk 

