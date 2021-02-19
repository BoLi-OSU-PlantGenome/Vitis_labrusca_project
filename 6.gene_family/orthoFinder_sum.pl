#!usr/bin/perl
use strict;
use warnings;

open IN, "Orthogroups.txt" or die $!;
open OUT, ">cultivated.uniqGene.list";
open OUT2, ">wild.uniqGene.list";
open OUT3,">VIT.uniqGene.list";
open OUT4,">Cab.uniqGene.list";
open OUT5,">Char.uniqGene.list";
open OUT6,">Vlab.uniqGene.list";
open OUT7,">Vrip.uniqGene.list";
open SUM, ">grape.orthofinder.sum";
my $cut_og;
my $wild_og;
#my $cut_gene;
#my $wild_gene;
my $VIT_og;
my $VIT;
my $VIT_share;
my $Cab_og;
my $Cab;
my $Cab_share;
my $Char_og;
my $Char;
my $Char_share;
my $Vlab_og;
my $Vlab;
my $Vlab_share;
my $Vrip_og;
my $Vrip;
my $Vrip_share;
my $shared_og;
while (<IN>) {
	chomp;
	next if(/^Orthgroup/);
	if (/VIT/ and /Char/ and /Cab/ and  !/Vlab/ and  !/Vrip/) {
		#my $line=$_;
		$cut_og++;
		my @arr=split(" ",$_);
		shift @arr;
		#print "$arr[0]\n";
		foreach my $a (@arr){
			print OUT "$a\n";
			if ($a=~/VIT/) {
				$VIT++;
			}
			elsif($a=~/Char/){
				$Char++;
			}
			elsif($a=~/Cab/){
				$Cab++;
			}
		}
	}
	elsif(!/VIT/ and !/Char/ and !/Cab/ and  /Vlab/ and /Vrip/){
		#print "$_\n";
		$wild_og++;
		my @arr=split(" ",$_);
		shift @arr;
		
		#my @tmp=split("\t",$arr[1]);
		foreach my $a (@arr){
			print OUT2 "$a\n";
			if ($a=~/Vlab/) {
				$Vlab++;
			}
			elsif($a=~/Vrip/){
				$Vrip++;
			}
		}
	}
	elsif(/VIT/ and !/Char/ and !/Cab/ and  !/Vlab/ and  !/Vrip/){
		$VIT_og++;
		my @arr=split(" ",$_);
		shift @arr;
		foreach my $a (@arr){
			print OUT3 "$a\n";
		}
	}

	elsif(!/VIT/ and !/Char/ and /Cab/ and  !/Vlab/ and  !/Vrip/){
		$Cab_og++;
		my @arr=split(" ",$_);
		shift @arr;
		foreach my $a (@arr){
			print OUT4 "$a\n";
		}
	}

	elsif(!/VIT/ and /Char/ and !/Cab/ and  !/Vlab/ and  !/Vrip/){
		$Char_og++;
		my @arr=split(" ",$_);
		shift @arr;
		foreach my $a (@arr){
			print OUT5 "$a\n";
		}
	}

	elsif(!/VIT/ and !/Char/ and !/Cab/ and  /Vlab/ and  !/Vrip/){
		$Vlab_og++;
		my @arr=split(" ",$_);
		shift @arr;
		foreach my $a (@arr){
			print OUT6 "$a\n";
		}
	}

	elsif(!/VIT/ and !/Char/ and !/Cab/ and  !/Vlab/ and  /Vrip/){
		#print "$_\n";
		$Vrip_og++;
		my @arr=split(" ",$_);
		shift @arr;
		foreach my $a (@arr){
			print OUT7 "$a\n";
		}
	}

	elsif(/VIT/ and /Char/ and /Cab/ and  /Vlab/ and  /Vrip/){
		#print "$_\n";
		 $shared_og++;
		 my @arr=split(" ",$_);
		shift @arr;
		#print "$arr[0]\n";
		foreach my $a (@arr){
			if ($a=~/VIT/) {
				$VIT_share++;
			}
			elsif($a=~/Char/){
				$Char_share++;
			}
			elsif($a=~/Cab/){
				$Cab_share++;
			}
			elsif($a=~/Vrip/){
				$Vrip_share++;
			}
			elsif($a=~/Vlab/){
				$Vlab_share++;
			}
		}
		
	}
}

print SUM "cultivatedshare\t$cut_og ($VIT)\n";
print SUM "cultivatedshare\t$cut_og ($Cab)\n";
print SUM "cultivatedshare\t$cut_og ($Char)\n";
print SUM "wildshared\t$wild_og ($Vrip)\n";
print SUM "wildshared\t$wild_og ($Vlab)\n";
print SUM "uniqOG:\tVIT\tCab\tChar\tVrip\tVlab\n";
print SUM "uniqOG:\t$VIT_og\t$Cab_og\t$Char_og\t$Vrip_og\t$Vlab_og\n";
print SUM "SharedOG:\t$shared_og\n";
print SUM "Sharedgene:\tVIT\tCab\tChar\tVrip\tVlab\n";
print SUM "Sharedgene:\t$VIT_share\t$Cab_share\t$Char_share\t$Vrip_share\t$Vlab_share\n";



