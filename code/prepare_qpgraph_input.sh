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
(echo '#!/bin/bash -l'
echo "
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex
module load bioinfo-tools plink/1.90b4.9
module load bioinfo-tools bcftools/1.17
cd $folder

for chr in {1..21}; do
chrbim=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex_${chr}
chrpositions=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/positions_${chr}
denisovan=/crex/proj/snic2020-2-10/private/Analyses/Matjes_River/per_chr_vcfs/GATK_called_vcfs/Denis_emitall_Denisova_${chr}.vcf.gz
output=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan/Denis_emitall_Denisova_${chr}_subset_zbatwa10_zbantu9_plus_comp.vcf.gz
plink --bfile $folder/$prefix --chr $chr --make-just-bim --out ${chrbim}
cut -f1,4 $chrbim.bim > $chrpositions
bcftools view -R ${chrpositions} -Oz -o ${output} ${denisovan}
done
exit 0") | sbatch -p core -n 1 -t 24:0:0 -A p2018003 -J subset_Denisova -o subset_Denisova.output -e subset_Denisova.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
#Submitted batch job 40864847

# Step 2: make a single VCF out of the 22; convert it to plink fileset.

# Step 3: merge to my SNP array fileset

# Step 4: extract the five modern populations + Denisovan

# Step 5: check that I can open this fileset, and that I can search for an admixture graph with it

# Step 6: scale-up (1000 repeats of m=1, 2 or 3)
