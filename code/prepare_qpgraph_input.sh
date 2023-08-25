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
plink --bfile $folder/$prefix --keep-fam $folder/$pop --make-bed --out ${outfolder}/July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Kafue
