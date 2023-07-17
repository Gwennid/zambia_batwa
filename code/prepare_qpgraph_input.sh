# 2023-07-17
# Gwenna Breton
# Goal: prepare eigenstrat format genotype files that can be used by ADMIXTOOLS 2
#Strategy: subset the plink fileset to incude populations of interest; transform to eigenstrat format.
#Commands are based on 20201210_analyses.sh, from row 257

# Inputs
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex
eigenstrat=/crex/proj/snic2020-2-10/uppstore2018150/private/scripts/par.PED.EIGENSTRAT

module load bioinfo-tools plink/1.90b4.9

# YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu
cd $folder
pop=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu
plink --bfile $prefix --keep-fam $pop --make-bed --out July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu
plink --bfile $prefix --keep-fam $pop --make-bed --recode --out July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu #To get the input for eigenstrat convertf

sed 's/example/July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu/g' $eigenstrat > par.PED.EIGENSTRAT.20230717_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu
module load bioinfo-tools AdmixTools/5.0-20171024
convertf -p par.PED.EIGENSTRAT.20230717_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu

#Modify the third column of .indiv so it has the population ID.
root=July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu
#cp ${root}.indiv ${root}.indiv_original #do that the first time only!!!
cut -d" " -f1 ${root}.fam >file2a
awk '{print $1 " " $2}' < ${root}.indiv_original > file1
touch fileComb
paste file1 file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.indiv
rm file1; rm file2a; rm fileComb

#Now I will get the files locally and test running ADMIXTOOLS 2!
