## run EDTA to de novo identify TE modelers

perl EDTA.pl -genome labrusca.V1.fasta -species others -step final -sensitive 1 -overwrite 0 -protlib alluniRefprexp082813  -t 12

## run repeatmask to identify all TE

RepeatMasker -e ncbi -pa 16 -xsmall  -dir RepeatMasker_output -lib labrusca.fasta.EDTA.TElib.fa  -gff -html labrusca.V1.fasta 