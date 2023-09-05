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
#I will merge with ../zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2.bim (most recent file that still has fake individuals; all the files, with/out fake, have the same number of variants)
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/
base=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2
denisovan=Denisovan/Denis_emitall_Denisova_1-22_subset_zbatwa10_zbantu9_plus_comp_1
plink --bfile ${folder}${base} --bmerge ${folder}${denisovan}.bed ${folder}${denisovan}.bim ${folder}${denisovan}.fam --make-bed --out ${folder}Denisovan/${base}_denisovan #168445 variants with 3+ alleles present.
plink --bfile ${folder}${denisovan} --flip ${folder}Denisovan/${base}_denisovan-merge.missnp --make-bed --out ${folder}${denisovan}f
plink --bfile ${folder}${base} --bmerge ${folder}${denisovan}f.bed ${folder}${denisovan}f.bim ${folder}${denisovan}f.fam --make-bed --out ${folder}Denisovan/${base}_denisovan_2 #80 variants with 3+ alleles present.
plink --bfile ${folder}${denisovan}f --exclude ${folder}Denisovan/${base}_denisovan_2-merge.missnp --make-bed --out ${folder}${denisovan}fe
plink --bfile ${folder}${base} --bmerge ${folder}${denisovan}fe.bed ${folder}${denisovan}fe.bim ${folder}${denisovan}fe.fam --allow-no-sex --make-bed --out ${folder}Denisovan/${base}_denisovan_3 #337051 variants and 979 people pass filters and QC.

## Remove the fake individuals
grep fake ${folder}Denisovan/${base}_denisovan_3.fam > ${folder}Denisovan/${base}_denisovan_3_fake
plink --bfile ${folder}Denisovan/${base}_denisovan_3 --remove ${folder}Denisovan/${base}_denisovan_3_fake --allow-no-sex --make-bed --out ${folder}Denisovan/${base}_denisovan_3fex

# Step 4: extract the five modern populations + Denisovan
# Inputs
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2_denisovan_3fex

# YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu-Denisovan
cd $folder
pop=${folder}/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu-Denisovan
plink --bfile $prefix --keep-fam $pop --make-bed --out September2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu-Denisovan

# Step 5: check that I can open this fileset, and that I can search for an admixture graph with it
module load bioinfo-tools
module load R_packages/4.1.1
R
library(admixtools, lib.loc='/domus/h1/gwennabr/R/x86_64-redhat-linux-gnu-library/4.1.1/')
library(dplyr)
#setwd("/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph")
setwd("/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan")
f2=f2_from_geno("September2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu-Denisovan",maxmiss=0.15)
m=1 #or 2 or 3
opt_results = find_graphs(f2, numadmix = m, stop_gen = 10000, stop_gen2 = 30, plusminus_generations = 10, outpop = 'Denisovan')
winner = opt_results %>% slice_min(score, with_ties = FALSE)
s=winner$score[[1]]
pdf(paste('graph.Bangweulu.test',m,s,'pdf',sep='.'))
print(plot_graph(winner$edges[[1]]))
dev.off()

#With a single iteration, it seems like m=2 is not such a good fit as it was for the runs without an outgroup!

# Step 6: scale-up (1000 repeats of m=1, 2 or 3)







