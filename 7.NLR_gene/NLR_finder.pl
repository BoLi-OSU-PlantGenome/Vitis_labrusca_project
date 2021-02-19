#!usr/bin/perl
#use strict;
#use warnings;
use Array::Utils qw(:all);
## This script is used to identify NLR gene family and classify into four subgrougs based on other conserved domains

### Step1: generate protein name list with certain kind of domain, remove redudancy

open SUM, ">grape.NLR.genefamily.sum";
print SUM "TotalNLR\t(1)TNLs(NB+TIR)\t(2)CNLs(NB+CC)\t(3)RNLs(NB+CCr)\t(4)NB_LRR_only\t(5)NB_others\n";

my @species=("Vv12X", "Vlab", "Vrip","Cab08","Char");

foreach my $each (@species){
#open SUM, ">$each.NLR.genefamily.sum";
print SUM "$each\n";
#print SUM "TotalNLR\t(1)TNLs(NB+TIR)\t(2)CNLs(NB+CC)\t(3)RNLs(NB+CCr)\t(4)NB_LRR_only\t(5)NB_others\n";
### NB domain
open IN, "$each.NB" or die $!; #Vv12X.NB
my @NB=();
my $NB_count=0;
while (<IN>) {
	$NB_count++;
	my @arr=split(" ",$_);
	#print "$arr[0]\n";
	push (@NB,$arr[0]);
}
close IN;
my @NB_U= uniq (@NB);
my $NB_U=@NB_U;
open OUT, ">$each.NB.list";
foreach(@NB_U){
	print OUT "$_\n";
}
close OUT;


### CC domain
open IN, "$each.CC" or die $!; #Vv12X.CC
my @CC=();
my $CC_count=0;
while (<IN>) {
	$CC_count++;
	my @arr=split("\t",$_);
	push @CC,$arr[0];
}
close IN;

my @CC_U= uniq (@CC);
open OUT, ">$each.CC.list";
foreach(@CC_U){
	print OUT "$_\n";
}
close OUT;

### CCr domain
open IN, "$each.CCr" or die $!; #Vv12X.CCr
my @CCr=();
my $CCr_count=0;
while (<IN>) {
	$CCr_count++;
	my @arr=split("\t",$_);
	push @CCr,$arr[0];
}
close IN;

my @CCr_U= uniq (@CCr);

open OUT, ">$each.CCr.list";
foreach(@CCr_U){
	print OUT "$_\n";
}
close OUT;

### LRR domain

open IN, "$each.LRR" or die $!; #Vv12X.CCr
my @LRR=();
my $LRR_count=0;
while (<IN>) {
	$LRR_count++;
	my @arr=split("\t",$_);
	push @LRR,$arr[0];
}
close IN;
my @LRR_U=uniq (@LRR);
open OUT, ">$each.LRR.list";
foreach(@LRR_U){
	print OUT "$_\n";
}
close OUT;

### TIR domain

open IN, "$each.TIR" or die $!; #Vv12X.CCr
my @TIR=();
my $TIR_count=0;
while (<IN>) {
	$TIR_count++;
	my @arr=split("\t",$_);
	push @TIR,$arr[0];
}
close IN;
my @TIR_U= uniq (@TIR);
open OUT, ">$each.TIR.list";
foreach(@TIR_U){
	print OUT "$_\n";
}
close OUT;

###############################################

## Step2: detect overlap: protein with 2 kinds of domains 




## CCr + NB

my @CCr_NB=intersect(@CCr_U,@NB_U);
my $CCr_NB=@CCr_NB;
open OUT, ">$each.CCr_NB";
foreach(@CCr_NB){
	print OUT "$_\n";
}
close OUT;


## TIR + NB

my @TIR_NB=intersect(@TIR_U,@NB_U);
my @TIR_NB_u1 = array_minus( @TIR_NB, @CCr_NB); # remove overlap with CCr_NB
my $TIR_NB_u1=@TIR_NB_u1;
open OUT, ">$each.TIR_NB";
foreach(@TIR_NB_u1){
	print OUT "$_\n";
}
close OUT;



## CC + NB

my @CC_NB=intersect(@CC_U,@NB_U);
my @CC_NB_u1 = array_minus( @CC_NB, @TIR_NB_u1); # remove overlap with TIR_NB
my @CC_NB_u2 = array_minus( @CC_NB_u1, @CCr_NB); # remove overlap with CCr
my $CC_NB_u2=@CC_NB_u2;
open OUT, ">$each.CC_NB";
foreach(@CC_NB_u2){
	print OUT "$_\n";
}
close OUT;


## NB + LRR only

my @main=(@TIR_NB_u1,@CCr_NB,@CC_NB_u2);
my $main=@main;
print "$main\n";
my @main_u=uniq(@main);
my $main_u=@main_u;
print "$main_u\n";

my @rare=array_minus(@NB_U, @main); # all NB - NB+Ntermianl

my @NB_LRR_Only=intersect(@rare,@LRR_U); ## with NB and LRR

my $NB_LRR_Only=@NB_LRR_Only;

open OUT, ">$each.NB_LRR_only";
foreach(@NB_LRR_Only){
	print OUT "$_\n";
}
close OUT;

## only NB

my @NB_only=array_minus(@rare,@NB_LRR_Only);

my $NB_only=@NB_only;

open OUT, ">$each.NB_only";
foreach(@NB_only){
	print OUT "$_\n";
}
close OUT;


print SUM "$NB_U\t$TIR_NB_u1\t$CC_NB_u2\t$CCr_NB\t$NB_LRR_Only\t$NB_only\n";

#close SUM;

#### detect other domains
`rm $each.other`;

foreach(@NB_only){
	`grep $_ $each.chr.pep.fa.tsv | grep -v "PF00931" >> $each.other`;
}


}
close SUM;


##########################################################################
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

