# 2023-07-17
# Gwenna Breton
# Goal: prepare eigenstrat format genotype files that can be used by ADMIXTOOLS 2
#Strategy: subset the plink fileset to incude populations of interest.
#Edit 2023-08-25: one can use directly bed bim fam, so I'm removing the code related to eigenstrat.

# Inputs
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex

module load bioinfo-tools plink/1.90b4.9

# YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu
cd $folder
pop=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu
plink --bfile $prefix --keep-fam $pop --make-bed --out July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu

# YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Kafue
outfolder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/kafue
pop=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Kafue
plink --bfile $folder/$prefix --keep-fam $pop --make-bed --out ${outfolder}/July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Kafue

# YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bemba
outfolder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/bemba
pop=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bemba
plink --bfile $folder/$prefix --keep-fam $pop --make-bed --out ${outfolder}/July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bemba

# YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Lozi
outfolder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/lozi
pop=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Lozi
plink --bfile $folder/$prefix --keep-fam $pop --make-bed --out ${outfolder}/July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Lozi

# YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Tonga
outfolder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/tonga
pop=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Tonga
plink --bfile $folder/$prefix --keep-fam $pop --make-bed --out ${outfolder}/July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Tonga

#
# Feat: merge with Denisovan data to test find_graph with an outgroup
#
# VCFs (all sites) for Denisovan can be found here: /crex/proj/snic2020-2-10/private/Analyses/Matjes_River/per_chr_vcfs/GATK_called_vcfs/Denis_emitall_Denisova_*.vcf.gz (as shared by Per Sjödin)

# Step 1: extract the sites present in the input from Denisovan's VCF
#I ran chr22 outside the loop to test the code.
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/log
(echo '#!/bin/bash -l
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex
module load bioinfo-tools plink/1.90b4.9
module load bioinfo-tools bcftools/1.17
cd $folder

for chr in {1..22}; do
chrbim=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex_${chr}
chrpositions=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/positions_${chr}
denisovan=/crex/proj/snic2020-2-10/private/Analyses/Matjes_River/per_chr_vcfs/GATK_called_vcfs/Denis_emitall_Denisova_${chr}.vcf.gz
output=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/Denis_emitall_Denisova_${chr}_subset_zbatwa10_zbantu9_plus_comp.vcf.gz
plink --bfile ${folder}/${prefix} --chr ${chr} --make-just-bim --out ${chrbim}
cut -f1,4 ${chrbim}.bim > ${chrpositions}
bcftools view -R ${chrpositions} -Oz -o ${output} ${denisovan}
done
exit 0') | sbatch -p core -n 1 -t 24:0:0 -A p2018003 -J subset_Denisova -o subset_Denisova.output -e subset_Denisova.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL

# Step 2: make a single VCF out of the 22; convert it to plink fileset.
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/
module load bioinfo-tools bcftools/1.17
for chr in {1..22}; do
echo /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/Denis_emitall_Denisova_${chr}_subset_zbatwa10_zbantu9_plus_comp.vcf.gz >> list_1-22
done
output=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/Denis_emitall_Denisova_1-22_subset_zbatwa10_zbantu9_plus_comp.vcf.gz
bcftools concat --file-list list_1-22 -Oz -o ${output}

module load bioinfo-tools plink/1.90b4.9
prefix=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/Denis_emitall_Denisova_1-22_subset_zbatwa10_zbantu9_plus_comp
plink --vcf ${output} --out ${prefix}

# Step 3: merge to my SNP array fileset
# Which steps should I include?  Merge with fake to flip alleles? Or can that be done when merging, if I still have the fake there?

## Rename the SNP to chr:position (now: rs numbers).
prefix=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/Denis_emitall_Denisova_1-22_subset_zbatwa10_zbantu9_plus_comp##cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
cut -f1,4 ${prefix}.bim | sed "s/\t/-/g" > mid
cut -f1 ${prefix}.bim > first
cut -f3- ${prefix}.bim > last
paste first mid last > ${prefix}.bim

## Remove duplicate snps - I checked and there were no duplicated SNPs.

## Remove ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" ${prefix}.bim >> ATCGlist
grep -P "\tT\tA" ${prefix}.bim >> ATCGlist
grep -P "\tC\tG" ${prefix}.bim >> ATCGlist
grep -P "\tG\tC" ${prefix}.bim >> ATCGlist #77 items. It's a bit strange, I would have expected these to not be there since it's only variants in the final dataset that I extracted...
plink --bfile ${prefix} --exclude ATCGlist --make-bed --out ${prefix}_1

## Merge with the main dataset
#Obs! Maybe I should have extracted the positions from a different fileset, from which the fake is not removed... Look into that.
#I will merge with ../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2.bim (most recent file that still has fake individuals)
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/
base=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2
denisovan=Denisovan/Denis_emitall_Denisova_1-22_subset_zbatwa10_zbantu9_plus_comp_1
plink --bfile ${folder}${base} --bmerge ${folder}${denisovan}.bed ${folder}${denisovan}.bim ${folder}${denisovan}.fam --make-bed --out ${folder}Denisovan/${base}_denisovan #168445 variants with 3+ alleles present.
plink --bfile ${folder}${denisovan} --flip ${folder}Denisovan/${base}_denisovan-merge.missnp --make-bed --out ${folder}${denisovan}f
plink --bfile ${folder}${base} --bmerge ${folder}${denisovan}f.bed ${folder}${denisovan}f.bim ${folder}${denisovan}f.fam --make-bed --out ${folder}Denisovan/${base}_denisovan_2 #80 variants with 3+ alleles present.
plink --bfile ${folder}${denisovan}f --exclude ${folder}Denisovan/${base}_denisovan_2-merge.missnp --make-bed --out ${folder}${denisovan}fe
plink --bfile ${folder}${base} --bmerge ${folder}${denisovan}fe.bed ${folder}${denisovan}fe.bim ${folder}${denisovan}fe.fam --make-bed --out ${folder}Denisovan/${base}_denisovan_3
#Error about sex?!

[gwennabr@r161 Denisovan]$ grep fake ../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc*.fam
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2.fam:fake1 fake1 0 0 0 1
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2.fam:fakeA fakeA 0 0 0 1
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2.fam:fakeInd fakeInd 0 0 0 1
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc-merge.fam:fake1        fake1      0       0       0       -9
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc-merge.fam:fakeA        fakeA      0       0       0       -9
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc-merge.fam:fakeInd      fakeInd    0       0       0       -9
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc.fam:fake1 fake1 0 0 0 -9
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc.fam:fakeInd fakeInd 0 0 0 -9
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapancf.fam:fake1 fake1 0 0 0 -9
../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapancf.fam:fakeInd fakeInd 0 0 0 -9


# Step 4: extract the five modern populations + Denisovan

# Step 5: check that I can open this fileset, and that I can search for an admixture graph with it

# Step 6: scale-up (1000 repeats of m=1, 2 or 3)
