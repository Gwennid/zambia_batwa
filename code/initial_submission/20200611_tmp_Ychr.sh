###
### Y haplogroups
###

# Zambian farmers
module load bioinfo-tools plink/1.90b4.9
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020

grep -P "^24\t" zbantu1.bim >> chr24_Y #Y
plink --bfile zbantu1f --extract chr24_Y --make-bed --out zbantuchrY_1 #2538 remain.
#plink --bfile zbantuchrY_1 --recode --out zbantuchrY_1 #TODO why do I have this command???
#I created with grep a file with the individuals that I want to keep (plus the fake individual). I used the information in the fam file (a single female).
plink --bfile zbantuchrY_1 --keep zbantuchrY_1_males --make-bed --out zbantuchrY_2
#plink --bfile zbantuchrY_2 --recode --out zbantuchrY_2 #TODO why do I have this command???
plink --bfile zbantuchrY_2 --mind 0.1 --geno 0.1 --make-bed --out zbantuchrY_3 #2334 variants
#replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
infile="zbantuchrY_3"
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim
#remove duplicate snps
cut -f2 ${infile}.bim | sort > with_dup
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl
plink --bfile zbantuchrY_3 --exclude dupl --make-bed --out zbantuchrY_4 #2326

#Flip to match the reference (I use the file that I created for the BaTwa).
plink --bfile hg37_chrY  --bmerge zbantuchrY_4.bed zbantuchrY_4.bim zbantuchrY_4.fam --make-bed --out zbantuchrY_4_hg37 #41 with 3+ alleles
plink --bfile zbantuchrY_4 --flip zbantuchrY_4_hg37-merge.missnp --make-bed --out zbantuchrY_4f
plink --bfile zbantuchrY_4f --remove fake_ex --make-bed --out zbantuchrY_4f_fex

cd /proj/uppstore2018150/private/Programs/snappy-master
module load bioinfo-tools python/2.7.6
cp /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbantuchrY_4f_fex* .
python SNAPPY_v0.1.py --infile zbantuchrY_4f_fex --out zbantuchrY_4f_fex_Yhg

#Success!
mv zbantuchrY_4f_fex_Yhg* /proj/uppstore2018150/private/results/Yhaplogroups/20200611_SNAPPY_Zbantu

###
### 20200717
###

# I set out to explore the weird discrepancy between our results for the BaTwa and the Zambian agropastoralists (i.e. different) and even with previously published studies. I noticed that three of the signature variants for the haplogroups found in the BaTwa are filtered out from the Zambian agropastoralists because of high missingness (>10%). Overall the missingness is much higher in the Zambian agropastoralists than in the BaTwa (total genotyping rate: 0.945685 and 0.988968 respectively).

# I will try to run SNAPPY without filtering for variant missingness.

#replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898
cp zbantuchrY_2.bed zbantuchrY_2-alt.bed 
cp zbantuchrY_2.bim zbantuchrY_2-alt.bim
cp zbantuchrY_2.fam zbantuchrY_2-alt.fam
infile="zbantuchrY_2-alt"
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim
#remove duplicate snps
cut -f2 ${infile}.bim | sort > with_dup
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl
plink --bfile zbantuchrY_2-alt --exclude dupl --make-bed --out zbantuchrY_3-alt #2530 variants

#Flip to match the reference (I use the file that I created for the BaTwa).
plink --bfile hg37_chrY  --bmerge zbantuchrY_3-alt.bed zbantuchrY_3-alt.bim zbantuchrY_3-alt.fam --make-bed --out zbantuchrY_3-alt_hg37 #s
plink --bfile zbantuchrY_3-alt --flip zbantuchrY_3-alt_hg37-merge.missnp --make-bed --out zbantuchrY_3-altf
plink --bfile zbantuchrY_3-altf --remove fake_ex --make-bed --out zbantuchrY_3-altf_fex

cd /proj/snic2020-2-10/uppstore2018150/private/Programs/snappy-master
module load bioinfo-tools python/2.7.6
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbantuchrY_3-altf_fex* .
python SNAPPY_v0.1.py --infile zbantuchrY_3-altf_fex --out zbantuchrY_3-altf_fex_Yhg

mv zbantuchrY_3-altf_fex_Yhg* /proj/snic2020-2-10/uppstore2018150/private/results/Yhaplogroups/20200611_SNAPPY_Zbantu
#It gives the exact same result...

#I will look at these locations to see whether they are really all reference.

plink --bfile zbantuchrY_3-altf_fex --recode transpose --out zbantuchrY_3-altf_fex
plink --bfile zbatwachrY_4f_fex --recode transpose --out zbatwachrY_4f_fex

# So apparently one difference is that though all of the samples are treated as diploid (why?), the BaTwa are hom ref or hom alt (but see 24-2929077), while the agropastoralists are either hom ref or het.














