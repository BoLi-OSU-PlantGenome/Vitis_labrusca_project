#!usr/bin/perl

use strict;
use warnings;

`cut -f 4 PN40024.bed > PN40024.all.gene.list`;
`cut -f 4 Cab.bed > Cab.all.gene.list`;
`cut -f 4 Char.bed > Char.all.gene.list`;
`cut -f 4 Vlab.bed > Vlab.all.gene.list`;
`cut -f 4 Vrip.bed > Vrip.all.gene.list`;

`cut -f 2,3 grape.Vlabref.collinear.list.rmdup.pn.cab.char.vrip > Vlab.collinear.gene.list`;
`cut -f 4,5 grape.Vlabref.collinear.list.rmdup.pn.cab.char.vrip > PN40024.collinear.gene.list`;
`cut -f 6,7 grape.Vlabref.collinear.list.rmdup.pn.cab.char.vrip > Cab.collinear.gene.list`;
`cut -f 8,9 grape.Vlabref.collinear.list.rmdup.pn.cab.char.vrip > Char.collinear.gene.list`;
`cut -f 10,11 grape.Vlabref.collinear.list.rmdup.pn.cab.char.vrip > Vrip.collinear.gene.list`;

`cut -f 2,3 grape.collinear.gene.final.table.txt.4 > Vlab.HF.gene.list`;
`cut -f 4,5 grape.collinear.gene.final.table.txt.4 > PN40024.HF.gene.list`;
`cut -f 6,7 grape.collinear.gene.final.table.txt.4 > Cab.HF.gene.list`;
`cut -f 8,9 grape.collinear.gene.final.table.txt.4 > Char.HF.gene.list`;
`cut -f 10,11 grape.collinear.gene.final.table.txt.4 > Vrip.HF.gene.list`;

my @species=("PN40024","Cab","Char","Vlab","Vrip");
foreach my $sp (@species){
	my %hash;
	open IN, "$sp.collinear.gene.list" or die $!;
	while (<IN>) {
		my @arr=split("\t",$_);
		$hash{$arr[0]}=1;
	}
	close IN;

	open IN, "$sp.all.gene.list" or die $!;
	open OUT, ">$sp.noncollinear.gene.list";
	while (<IN>) {
		chomp;
		if (exists $hash{$_}) {
			next;
		}
		else{
			print OUT "$_\n";
		}
	}
	close IN;
	close OUT;
}


## prepare collinear gene bed files

my @type=("all","collinear","HF","noncollinear");

foreach my $tp (@type) {
foreach my $sp (@species){
	my %hash;
	open IN, "$sp.bed" or die $!;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		my $pos=$arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[5];
		$hash{$arr[3]}=$pos;
	}
	close IN;

	open IN, "$sp.$tp.gene.list" or die $!; ## remove duplicated collinear genes
	open OUT, ">$sp.$tp.1k_upstream.bed";
	open OUT2, ">$sp.$tp.1k_downstream.bed";
	open OUT3, ">$sp.$tp.2k_upstream.bed";
	open OUT4, ">$sp.$tp.2k_downstream.bed";
	open OUT5, ">$sp.$tp.3k_upstream.bed";
	open OUT6, ">$sp.$tp.3k_downstream.bed";
	open OUT7, ">$sp.$tp.4k_upstream.bed";
	open OUT8, ">$sp.$tp.4k_downstream.bed";
	open OUT9, ">$sp.$tp.5k_upstream.bed";
	open OUT10, ">$sp.$tp.5k_downstream.bed";
	my $n=0;
	while (<IN>) {
		chomp;
		my @arr=split("\t",$_);
		#print "$arr[0]\n";
		if (exists $hash{$arr[0]}) {
			$n++;
			my $colID="colgene_"."$n";
			my @gene=split("\t",$hash{$arr[0]});
			if ($gene[3] eq "+") {
				my $up1k=$gene[1]-1000; #upstream 1k
				if ($up1k<0) { # the first gene do not have 1 kb upsteam
					$up1k=1;
				}
				my $up2k=$gene[1]-2000; #upstream 2k
				if ($up2k<0) { # the first gene do not have 1 kb upsteam
					$up2k=1;
				}
				my $up3k=$gene[1]-3000; #upstream 3k
				if ($up3k<0) { # the first gene do not have 1 kb upsteam
					$up3k=1;
				}
				my $up4k=$gene[1]-4000; #upstream 4k
				if ($up4k<0) { # the first gene do not have 1 kb upsteam
					$up4k=1;
				}
				my $up5k=$gene[1]-5000; #upstream 5k
				if ($up5k<0) { # the first gene do not have 1 kb upsteam
					$up5k=1;
				}
				my $dw1k=$gene[2]+1000; #upstream 1k
				my $dw2k=$gene[2]+2000; #upstream 2k
				my $dw3k=$gene[2]+3000; #upstream 3k
				my $dw4k=$gene[2]+4000; #upstream 4k
				my $dw5k=$gene[2]+5000; #upstream 5k

				print OUT "$gene[0]\t$up1k\t$gene[1]\t$arr[0]\t$colID\n";
				print OUT2 "$gene[0]\t$gene[2]\t$dw1k\t$arr[0]\t$colID\n";
				print OUT3 "$gene[0]\t$up2k\t$up1k\t$arr[0]\t$colID\n";
				print OUT4 "$gene[0]\t$dw1k\t$dw2k\t$arr[0]\t$colID\n";
				print OUT5 "$gene[0]\t$up3k\t$up2k\t$arr[0]\t$colID\n";
				print OUT6 "$gene[0]\t$dw2k\t$dw3k\t$arr[0]\t$colID\n";
				print OUT7 "$gene[0]\t$up4k\t$up3k\t$arr[0]\t$colID\n";
				print OUT8 "$gene[0]\t$dw3k\t$dw4k\t$arr[0]\t$colID\n";
				print OUT9 "$gene[0]\t$up5k\t$up4k\t$arr[0]\t$colID\n";
				print OUT10 "$gene[0]\t$dw4k\t$dw5k\t$arr[0]\t$colID\n";
			}
			elsif ($gene[3] eq "-") {
				my $up1k=$gene[2]+1000; #upstream 1k
				my $up2k=$gene[2]+2000; #upstream 2k
				my $up3k=$gene[2]+3000; #upstream 3k
				my $up4k=$gene[2]+4000; #upstream 4k
				my $up5k=$gene[2]+5000; #upstream 5k
				my $dw1k=$gene[1]-1000; #upstream 1k
				if ($dw1k<0) { # the first gene do not have 1 kb upsteam
					$dw1k=1;
				}
				my $dw2k=$gene[1]-2000; #upstream 2k
				if ($dw2k<0) { # the first gene do not have 1 kb upsteam
					$dw2k=1;
				}
				my $dw3k=$gene[1]-3000; #upstream 3k
				if ($dw3k<0) { # the first gene do not have 1 kb upsteam
					$dw3k=1;
				}
				my $dw4k=$gene[1]-4000; #upstream 4k
				if ($dw4k<0) { # the first gene do not have 1 kb upsteam
					$dw4k=1;
				}
				my $dw5k=$gene[1]-5000; #upstream 5k
				if ($dw5k<0) { # the first gene do not have 1 kb upsteam
					$dw5k=1;
				}

				print OUT "$gene[0]\t$gene[2]\t$up1k\t$arr[0]\t$colID\n";
				print OUT2 "$gene[0]\t$dw1k\t$gene[1]\t$arr[0]\t$colID\n";
				print OUT3 "$gene[0]\t$up1k\t$up2k\t$arr[0]\t$colID\n";
				print OUT4 "$gene[0]\t$dw2k\t$dw1k\t$arr[0]\t$colID\n";
				print OUT5 "$gene[0]\t$up2k\t$up3k\t$arr[0]\t$colID\n";
				print OUT6 "$gene[0]\t$dw3k\t$dw2k\t$arr[0]\t$colID\n";
				print OUT7 "$gene[0]\t$up3k\t$up4k\t$arr[0]\t$colID\n";
				print OUT8 "$gene[0]\t$dw4k\t$dw3k\t$arr[0]\t$colID\n";
				print OUT9 "$gene[0]\t$up4k\t$up5k\t$arr[0]\t$colID\n";
				print OUT10 "$gene[0]\t$dw5k\t$dw4k\t$arr[0]\t$colID\n";
			}
		}
	}
	close IN;
	close OUT;
	close OUT2;
	close OUT3;
	close OUT4;
	close OUT5;
	close OUT6;
	close OUT7;
	close OUT8;
	close OUT9;
	close OUT10;
}
}
### run bedtools to calculate TE proportion within each region

### LTR and MITE

foreach my $sp (@species){

	my @allbed=glob("$sp.*stream.bed");
	foreach my $file (@allbed){
		`~/miniconda2/envs/biotools/bin/bedtools intersect -a $sp.LTR.bed -b $file -wo > $file.LTR.bed`;
		`~/miniconda2/envs/biotools/bin/bedtools intersect -a $sp.MITE.bed -b $file -wo > $file.MITE.bed`;
		#`~/miniconda2/envs/biotools/bin/bedtools intersect -a $file  -b $sp.LTR.merged.bed -wo > $file.LTR.bed`;
		#`~/miniconda2/envs/biotools/bin/bedtools intersect -a $file  -b $sp.MITE.merged.bed -wo > $file.MITE.bed`;
		open IN, "$file.LTR.bed" or die $!;
        open OUT, ">$file.LTR.bed.combined";
        my @whole=<IN>;
        my @tmp=split("\t",$whole[0]);
        my $init=$tmp[9];
        my $sum=0;
        my $colID;
        my $geneID;
        my $type;  
        foreach(@whole){
                chomp;
                my @arr=split("\t",$_);
                if ($arr[9] eq $init) {
                        $sum=$sum+$arr[10];
                        $colID=$arr[9];
                        $geneID=$arr[8];
                        $type=$arr[4];
                }
                else{   
                        print OUT "$colID\t$geneID\t$sum\t$type\n";
                        $init=$arr[9];
                        $colID=$arr[9];
                        $geneID=$arr[8];
                        $sum=$arr[10];
                }
        }
        print OUT "$colID\t$geneID\t$sum\t$type\n"; #print the last record
        close IN;
        close OUT;


        open IN, "$file.MITE.bed" or die $!;
        open OUT, ">$file.MITE.bed.combined";
        @whole=<IN>;
        @tmp=split("\t",$whole[0]);
        $init=$tmp[9];
        $sum=0;
        #$colID;
        #$geneID;
        #$type;  
        foreach(@whole){
                chomp;
                my @arr=split("\t",$_);
                if ($arr[9] eq $init) {
                        $sum=$sum+$arr[10];
                        $colID=$arr[9];
                        $geneID=$arr[8];
                        $type=$arr[4];
                }
                else{   
                        print OUT "$colID\t$geneID\t$sum\t$type\n";
                        $init=$arr[9];
                        $colID=$arr[9];
                        $geneID=$arr[8];
                        $sum=$arr[10];
                }
        }
        print OUT "$colID\t$geneID\t$sum\t$type\n"; #print the last record
        close IN;
        close OUT;

	}
}

## prepare meta-gene results
##LTR
foreach my $tp (@type) {
	open OUT, ">grape.$tp.LTR.dist.table";
	print OUT "Pos\tProp\tSpecies\n";
	foreach my $sp (@species){
		open IN, "$sp.$tp.gene.list" or die $!; 
		my @geneCount=<IN>;
		my $geneCount=@geneCount;
		close IN;
		my $total_prop=0;
		open IN, "$sp.$tp.1k_upstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		my $mean_prop=$total_prop/$geneCount;
		print OUT "-500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.2k_upstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-1500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.3k_upstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-2500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.4k_upstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-3500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.5k_upstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-4500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.1k_downstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		 $mean_prop=$total_prop/$geneCount;
		print OUT "500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.2k_downstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "1500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.3k_downstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "2500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.4k_downstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "3500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.5k_downstream.bed.LTR.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "4500\t$mean_prop\t$sp\n";
		close IN;


	}
}

### MITE
foreach my $tp (@type) {
	open OUT, ">grape.$tp.MITE.dist.table";
	print OUT "Pos\tProp\tSpecies\n";
	foreach my $sp (@species){
		open IN, "$sp.$tp.gene.list" or die $!; 
		my @geneCount=<IN>;
		my $geneCount=@geneCount;
		close IN;
		my $total_prop=0;
		open IN, "$sp.$tp.1k_upstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		my $mean_prop=$total_prop/$geneCount;
		print OUT "-500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.2k_upstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-1500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.3k_upstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-2500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.4k_upstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-3500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.5k_upstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "-4500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.1k_downstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		 $mean_prop=$total_prop/$geneCount;
		print OUT "500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.2k_downstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "1500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.3k_downstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "2500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.4k_downstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "3500\t$mean_prop\t$sp\n";
		close IN;

		$total_prop=0;
		open IN, "$sp.$tp.5k_downstream.bed.MITE.bed.combined" or die $!;
		while (<IN>) {
			chomp;
			my @arr=split("\t",$_);
			my $prop=$arr[2]/1000;
			$total_prop+=$prop;
		}
		$mean_prop=$total_prop/$geneCount;
		print OUT "4500\t$mean_prop\t$sp\n";
		close IN;
	}
}






