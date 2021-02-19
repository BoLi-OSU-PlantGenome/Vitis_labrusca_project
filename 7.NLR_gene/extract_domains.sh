## vv12x
grep -i "NB-ARC" Vv12X.chr.pep.fa.tsv >Vv12X.NB
grep -i "PF01582" Vv12X.chr.pep.fa.tsv>Vv12X.TIR #(PF01582)
grep -Ei "coil|PF18052" Vv12X.chr.pep.fa.tsv >Vv12X.CC
grep -i "RPW8" Vv12X.chr.pep.fa.tsv >Vv12X.CCr
grep -i "Leucine rich repeat" Vv12X.chr.pep.fa.tsv >Vv12X.LRR
#grep "Leucine Rich repeat" Vv12X.pep.tsv >>Vv12X.LRR

## labrusca
#NB-ARC
grep -i "PF00931" Vlab.chr.pep.fa.tsv > Vlab.NB 
#TIR
grep -i "PF01582" Vlab.chr.pep.fa.tsv > Vlab.TIR 
#grep -i "coil" VVlab.pep.fa.tsv > Vlab.CC
grep -Ei "coil|PF18052" Vlab.chr.pep.fa.tsv > Vlab.CC
grep -i "RPW8" Vlab.chr.pep.fa.tsv > Vlab.CCr
grep -i "Leucine rich repeat" Vlab.chr.pep.fa.tsv > Vlab.LRR
#grep "Leucine Rich repeat" Vlab.pep.fa.tsv >> Vlab.LRR

## riparia
grep -i "NB-ARC" Vrip.chr.pep.fa.tsv > Vrip.NB
grep -i "PF01582" Vrip.chr.pep.fa.tsv > Vrip.TIR
#grep -i "coil" Vriparia.pep.fa.tsv > Vrip.CC
grep -Ei "coil|PF18052" Vrip.chr.pep.fa.tsv > Vrip.CC
grep -i "RPW8" Vrip.chr.pep.fa.tsv > Vrip.CCr
grep -i "Leucine rich repeat" Vrip.chr.pep.fa.tsv > Vrip.LRR


## Cabernet Sauvignon
grep -i "NB-ARC" Cab08.chr.pep.fa.tsv > Cab08.NB
grep -i "PF01582" Cab08.chr.pep.fa.tsv > Cab08.TIR 
#grep -i "coil" Vriparia.pep.fa.tsv > riparia.CC
grep -Ei "coil|PF18052" Cab08.chr.pep.fa.tsv > Cab08.CC
grep -i "RPW8" Cab08.chr.pep.fa.tsv > Cab08.CCr
grep -i "Leucine rich repeat" Cab08.chr.pep.fa.tsv > Cab08.LRR

## Chardonnay
grep -i "NB-ARC" Char.chr.pep.fa.tsv > Char.NB
grep -i "PF01582" Char.chr.pep.fa.tsv > Char.TIR
#grep -i "coil" Vriparia.pep.fa.tsv > riparia.CC
grep -Ei "coil|PF18052" Char.chr.pep.fa.tsv > Char.CC
grep -i "RPW8" Char.chr.pep.fa.tsv > Char.CCr
grep -i "Leucine rich repeat" Char.chr.pep.fa.tsv > Char.LRR 




