#!/usr/bin/perl

use strict;
use warnings;

my $ref=$ARGV[0];
my @species=("PN40024","Cab","Char","Vlab","Vrip");
foreach my $each (@species){
        if ($each eq $ref) {
                next;
        }
        else{
                `python -m jcvi.compara.catalog ortholog  $each $ref --no_strip_names`;
                `python -m jcvi.compara.synteny mcscan $ref.bed $each.$ref.lifted.anchors --iter=1 -o $each.$ref.i1.blocks`;
        }
}

`python -m jcvi.formats.base join  *.$ref.i1.blocks  --noheader | cut -f1,2,4,6,8,10 > grape.$ref.blocks`;
