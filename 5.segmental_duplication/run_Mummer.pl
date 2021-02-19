#!usr/bin/perl 
use warnings;
use strict;


## run Mummer

for (my $chr = 1; $chr < 20; $chr++) {
	for (my $ch = 1; $ch < 20; $ch++) {
		`/fs/project/PAS1444/projects/1_labrusca_wgs/workdir/results/mummer_align/MUMmer3.23/nucmer --maxmatch --nosimplify --prefix=$chr.$ch $chr.fa $ch.fa`;
		`/fs/project/PAS1444/projects/1_labrusca_wgs/workdir/results/mummer_align/MUMmer3.23/delta-filter -i 90 -l 1000 $chr.$ch.delta > $chr.$ch.delta.f.1k`; 
		`/fs/project/PAS1444/projects/1_labrusca_wgs/workdir/results/mummer_align/MUMmer3.23/show-coords -r $chr.$ch.delta.f.1k > $chr.$ch.f.1k.coords`;
	}
}