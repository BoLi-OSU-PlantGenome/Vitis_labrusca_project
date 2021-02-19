#!/usr/bin/perl

use strict;
use warnings;

#this is to annotate rRNA in a genome, and summerize the copy number

##make blast database
system "makeblastdb -in $ARGV[0] -dbtype nucl";
system "blastn -db $ARGV[0] -query maize_rRNA.txt -out $ARGV[0].rRNA.blastn.out -outfmt 6 -evalue 1e-8";

system "grep Zm5S $ARGV[0].rRNA.blastn.out >$ARGV[0].5S.CN.txt";
system "grep Zm58S $ARGV[0].rRNA.blastn.out > $ARGV[0].58S.CN.txt";
system "grep Zm18S $ARGV[0].rRNA.blastn.out > $ARGV[0].18S.CN.txt";
system "grep Zm25S $ARGV[0].rRNA.blastn.out > $ARGV[0].25S.CN.txt";
system "wc -l $ARGV[0].*.CN.txt >$ARGV[0].rRNA.sum";
