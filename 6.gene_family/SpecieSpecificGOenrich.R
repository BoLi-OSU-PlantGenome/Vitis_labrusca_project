#ClusterProfiler
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

#BiocManager::install("clusterProfiler")
#BiocManager::install("AnnotationHub")
library(clusterProfiler)
#library(AnnotationHub)

### unsing enricher to do GOE
#setwd("/Users/li.10917/OSU/projects/labrusca_genome/workdir/17_segmentalDuplication/results/Functional_annotation/diamond_validation/1_SD_gene_count")

#### PN40024
allgo <- read.delim("PN40024.pep.GO.lock")
go2geneID <- allgo[,c("GOTerm","GeneID")]
godes2geneID <- allgo[,c("GOTerm","GOName")]
testdata<-read.table("PN40024.specificGene.list",header = F)
x<-enricher(testdata$V1,TERM2GENE = go2geneID, TERM2NAME = godes2geneID, pvalueCutoff =0.05)
write.table(x, file="PN40024.specificGene.GOE.list",sep="\t",col.names = T,quote = F)
pdf("PN40024.specificGene.GOE.pdf")
barplot(x)
dev.off()

## Cab
allgo <- read.delim("Cab.pep.GO.lock")
go2geneID <- allgo[,c("GOTerm","GeneID")]
godes2geneID <- allgo[,c("GOTerm","GOName")]
testdata<-read.table("Cab.specificGene.list",header = F)
x<-enricher(testdata$V1,TERM2GENE = go2geneID, TERM2NAME = godes2geneID, pvalueCutoff =0.05)
write.table(x, file="Cab.specificGene.GOE.list",sep="\t",col.names = T,quote = F)
pdf("Cab.specificGene.GOE.pdf")
barplot(x)
dev.off()

##Char
allgo <- read.delim("Char.pep.GO.lock")
go2geneID <- allgo[,c("GOTerm","GeneID")]
godes2geneID <- allgo[,c("GOTerm","GOName")]
testdata<-read.table("Char.specificGene.list",header = F)
x<-enricher(testdata$V1,TERM2GENE = go2geneID, TERM2NAME = godes2geneID, pvalueCutoff =0.05)
write.table(x, file="Char.specificGene.GOE.list",sep="\t",col.names = T,quote = F)
pdf("Char.specificGene.GOE.pdf")
barplot(x)
dev.off()

##Vlab
allgo <- read.delim("Vlab.pep.GO.lock")
go2geneID <- allgo[,c("GOTerm","GeneID")]
godes2geneID <- allgo[,c("GOTerm","GOName")]
testdata<-read.table("Vlab.specificGene.list",header = F)
x<-enricher(testdata$V1,TERM2GENE = go2geneID, TERM2NAME = godes2geneID, pvalueCutoff =0.05)
write.table(x, file="Vlab.specificGene.GOE.list",sep="\t",col.names = T,quote = F)
pdf("Vlab.specificGene.GOE.pdf")
barplot(x)
dev.off()

##Vrip
allgo <- read.delim("Vrip.pep.GO.lock")
go2geneID <- allgo[,c("GOTerm","GeneID")]
godes2geneID <- allgo[,c("GOTerm","GOName")]
testdata<-read.table("Vrip.specificGene.list",header = F)
x<-enricher(testdata$V1,TERM2GENE = go2geneID, TERM2NAME = godes2geneID, pvalueCutoff =0.05)
write.table(x, file="Vrip.specificGene.GOE.list",sep="\t",col.names = T,quote = F)
pdf("Vrip.specificGene.GOE.pdf")
barplot(x)
dev.off()

##cultivated
allgo <- read.delim("PN40024.pep.GO.lock")
go2geneID <- allgo[,c("GOTerm","GeneID")]
godes2geneID <- allgo[,c("GOTerm","GOName")]
testdata<-read.table("cultivated.specificGene.PN40024Name.list",header = F)
x<-enricher(testdata$V1,TERM2GENE = go2geneID, TERM2NAME = godes2geneID, pvalueCutoff =0.05)
write.table(x, file="cultivated.specificGene.PN40024Name.GOE.list",sep="\t",col.names = T,quote = F)
pdf("cultivated.specificGene.PN40024Name.GOE.pdf")
barplot(x)
dev.off()

##wild
allgo <- read.delim("Vlab.pep.GO.lock")
go2geneID <- allgo[,c("GOTerm","GeneID")]
godes2geneID <- allgo[,c("GOTerm","GOName")]
testdata<-read.table("wild.specificGene.VlabName.list",header = F)
x<-enricher(testdata$V1,TERM2GENE = go2geneID, TERM2NAME = godes2geneID, pvalueCutoff =0.05)
write.table(x, file="wild.specificGene.VlabName.GOE.list",sep="\t",col.names = T,quote = F)
pdf("wild.specificGene.VlabName.GOE.pdf")
barplot(x)
dev.off()





