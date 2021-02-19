#!usr/bin/perl

open IN, "labrusca.V1.fasta.masked" or die $!;
open OUT, ">labrusca.chr16.fa";
$/=">";
while (<IN>) {
	next if(/random/);
	if (/^16/) {
		s/>//;
		print OUT ">$_";
	}
}
close IN;
close OUT;
$/="\n";

open IN, "labrusca.V1.fasta.all.gff" or die $!;
open OUT, ">labrusca.chr16.gff";
while (<IN>) {
	next if(/random/);
	if (/gff-version/) {
		print OUT "$_";
	}
	elsif(/^16/){
		print OUT "$_";

	}
}
close IN;
close OUT;
