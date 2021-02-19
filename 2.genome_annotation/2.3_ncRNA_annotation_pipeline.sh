# run infernal

/users/PAS1444/li10917/local/bin/bin/cmsearch --cpu 12 --cut_ga --tblout Vlabrusca.tbl Rfam.cm labrusca.chr.v1.fasta > Vlabrusca.cmsearch


## summarize count for each kind of ncRNA
 
perl CountFamilyMember.pl 


## run blast to detect rRNA independently

perl rRNACNsum.pl labrusca.chr.v1.fasta

