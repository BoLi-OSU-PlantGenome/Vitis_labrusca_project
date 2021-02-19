#!usr/bin/perl
#
use strict;
use warnings;

#my @array = ('cookies','balls','cookies','balls','balls', 'orphan');

open IN, "$ARGV[0]" or die $!;
open OUT, ">$ARGV[0].family";

my @array=();

while (<IN>){
	my @tmp=split(" ",$_);
	#print "$tmp[2]";
	push (@array,$tmp[2]);
}

my %count;
$count{$_}++ foreach @array;

#removing the lonely strings
=pod
while (my ($key, $value) = each(%count)) {
    if ($value == 1) {
        delete($count{$key});
    }
}
=cut
#output the counts
while (my ($key, $value) = each(%count)) {
    print OUT "$key\t$value\n";
}
