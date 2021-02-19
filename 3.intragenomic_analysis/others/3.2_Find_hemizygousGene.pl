## This script is used to identify hemizygous genes 

# 1. run ngmlr and sniffles to identify SVs

# run ngmlr mapper

`~/local/SVToolKit/bin/ngmlr -t 16 -x pacbio  -r Char.chr.fasta -q Char.raw.fastq  -o ngmlr.Char.sam`;

# run sniffles

`/users/PAS1444/li10917/miniconda2/envs/biotools/bin/samtools view -S -b ngmlr.Char.sam > ngmlr.Char.bam`;
`/users/PAS1444/li10917/miniconda2/envs/biotools/bin/samtools sort -o ngmlr.Char.sorted.bam  ngmlr.Char.bam`;
`/users/PAS1444/li10917/miniconda2/envs/biotools/bin/samtools index ngmlr.Char.sorted.bam`;
`~/local/SVToolKit/bin/sniffles -m ngmlr.Char.sorted.bam -v ngmlr.Char.vcf -l 2`;

# 2. extract deletions covering genes

open IN, "ngmlr.Char.vcf" or die $!; ## which is the sv calling results > 2 bp

# remove insertion and deletion larger than 1 Mb

open OUT, ">ngmlr.Char.lt1M.vcf"; ## this file is used to find hemizygous genes

while (<IN>) {
        if (/^\#/) {
                print OUT "$_";
                next;
        }
        else{
                if (/SVTYPE=DEL/ or /SVTYPE=INS/) {
                        if (/SVLEN=(\d+)/ or /SVLEN=-(\d+)/) {
                                my $len=$1;
                                if ($len>2 and $len<1000000) {
                                        print OUT "$_";
                                }
                        }
                }

        }
}

close IN;
close OUT;

### format vcf 2 bed
open IN, "ngmlr.Char.lt1M.vcf" or die $!;
open OUT, ">ngmlr.Char.lt1M.bed";
print OUT "Chr\tstart\tend\tID\tquality\tSVTYPE\tSUPTYPE\tSVLEN\tSupportReads\tReferenceReads\tTotalReads\n";
while (<IN>) {
	next if(/\#/);
	next if(/random/);
	next if (/Chr0/);
	next if(/Un/i);
	#next unless (/0\/1/); # we only consider heterozygous sites
	my @arr=split("\t",$_); 
	my $Chr=$arr[0];
	$Chr=~s/_RaGOO//;
	my $start=$arr[1];
	my $ID=$arr[2];
	my @tmp=split(";",$arr[7]);

	my $quality=$tmp[0];
	my $end=0;
	my $svtype;
	my $subtype;
	my $svlen=0;
	my $sr=0;
	my $rr=0;
	my $tr=0;
	foreach $a (@tmp){
		#if ($a=~/PRECISE/i or $a=~/IMPRECISE/i) {
		#	$quality=$1;
		#}
		if($a=~/END=(\d+)/){
			$end=$1;
		}
		elsif($a=~/SVTYPE=(\w+)/){
			$svtype=$1;
		}
		elsif($a=~/SUPTYPE=(\w+)/){
			$subtype=$1;
		}
		elsif($a=~/SVLEN=(.*)/){
			$svlen=$1;
		}
		elsif($a=~/RE=(\d+)/){
			$sr=$1;
		}
		elsif($a=~/REF_strand=(\d+)/){
			$tr=$1;
		}
		$rr=$tr-$sr;
	}
	print OUT "$Chr\t$start\t$end\t$ID\t$quality\t$svtype\t$subtype\t$svlen\t$sr\t$rr\t$tr\n";
			
}

close IN;
close OUT;

## summrize the SV results

`perl SV_type_sum.pl`;

### find hemizygous genes

`~/miniconda2/envs/biotools/bin/bedtools intersect -wa -wb -a Char.bed  -b  ngmlr.Char.lt1M.bed -f 1 > Char.hemizygousGene.lt1M.bed`; 

open IN, "Char.hemizygousGene.lt1M.bed" or die $!;
open OUT, ">Char.hemizygousGene.lt1M.list";
my @genelist=(); # hemizygous gene
while (<IN>) {
	my @arr=split("\t",$_);
	push @genelist,$arr[3];
}
my @uniq=uniq(@genelist);
foreach(@uniq){
	print OUT "$_\n";
}
close IN;
close OUT;

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}



