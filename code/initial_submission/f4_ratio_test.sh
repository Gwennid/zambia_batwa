# 20200612
# Gwenna Breton
# Goal: perform f4 ratio test.

#
# Prepare the input.
#
#I need to: 1.Combine the ancestral prepared by MV and my samples; 2.Convert to PED; 3.Convert to eigenstrat.
#I do not know how much the dataset should be filtered (missingness etc). I won't filter it for LD at the moment.

cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
module load bioinfo-tools plink/1.90b4.9

#Omni1
##Step 0: remove the four Lozi individuals from BP.
grep -e ZAM031 -e ZAM229 -e ZAM280 -e ZAM342 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam > 4Lozitoexclude
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex --remove 4Lozitoexclude --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziex

##Step1: find overlap between the markers in the ancestral and the marker in the Omni1 dataset.
cut -f2 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziex.bim > Omni1_variants
folder=/proj/uppstore2018150/private/raw/H3Africaancestral/
plink --bfile ${folder}ancestral_samples --extract Omni1_variants --make-bed --out ancestral_samples_Omni1variants
cut -f2 ancestral_samples_Omni1variants.bim > ancestral_samples_Omni1variants
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziex --extract ancestral_samples_Omni1variants --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc

##Step2: Merge.
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc --bmerge ancestral_samples_Omni1variants.bed ancestral_samples_Omni1variants.bim ancestral_samples_Omni1variants.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc --flip zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc-merge.missnp --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapancf
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapancf --bmerge ancestral_samples_Omni1variants.bed ancestral_samples_Omni1variants.bim ancestral_samples_Omni1variants.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc2

##Step3: Change phenotype status to 1.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc2
cp ${root}.fam ${root}.fam_original
sed 's/-9/1/g' < ${root}.fam > tmp; mv tmp ${root}.fam

##Step4: Exclude the fake.
plink --bfile ${root} --remove anc_fake --make-bed --out ${root}fex
plink --bfile ${root}fex --recode --out ${root}fex

##
sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc2fex/g' par.PED.EIGENSTRAT > par.PED.EIGENSTRAT.20200613.Omni1
module load bioinfo-tools AdmixTools/5.0-20171024
convertf -p par.PED.EIGENSTRAT.20200613.Omni1

#Modify the third column of .indiv so it has the population ID.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc2fex
cp ${root}.indiv ${root}.indiv_original #do that the first time only!!!
cut -d" " -f1 ${root}.fam >file2a
awk '{print $1 " " $2}' < ${root}.indiv_original > file1
touch fileComb
paste file1 file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.indiv
rm file1; rm file2a; rm fileComb

#
# Perform the test!
#
cd /proj/uppstore2018150/private/results/f4ratiotest/20200613
cp /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${root}.indiv .
cp /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${root}.geno .
cp /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${root}.snp .

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc2fex/g' < /proj/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_KSadmixture/g' > par.f4ratio.20200613_KSadmixture
qpF4ratio -p par.f4ratio.20200613_KSadmixture > logfile.20200613_KSadmixture
#I get some alpha larger than 1! Does not seem right.

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc2fex/g' < /proj/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_wRHGadmixture/g' > par.f4ratio.20200613_wRHGadmixture
qpF4ratio -p par.f4ratio.20200613_wRHGadmixture > logfile.20200613_wRHGadmixture

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex4Loziexoverlapanc_anc2fex/g' < /proj/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_eHGadmixture/g' > par.f4ratio.20200613_eHGadmixture
qpF4ratio -p par.f4ratio.20200613_eHGadmixture > logfile.20200613_eHGadmixture


#Repeat with Omni2.5 dataset.
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020

##Step 0: remove the four Lozi individuals from BP.
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex --remove 4Lozitoexclude --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziex

##Step1: find overlap between the markers in the ancestral and the marker in the Omni1 dataset.
cut -f2 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziex.bim > Omni2.5_variants
folder=/proj/uppstore2018150/private/raw/H3Africaancestral/
plink --bfile ${folder}ancestral_samples --extract Omni2.5_variants --make-bed --out ancestral_samples_Omni2.5variants
cut -f2 ancestral_samples_Omni2.5variants.bim > ancestral_samples_Omni2.5variants
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziex --extract ancestral_samples_Omni2.5variants --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziexoverlapanc #1159172 variants and 715 people

##Step2: Merge.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziexoverlapanc
plink --bfile ${root} --bmerge ancestral_samples_Omni2.5variants.bed ancestral_samples_Omni2.5variants.bim ancestral_samples_Omni2.5variants.fam --make-bed --out ${root}_anc
plink --bfile ${root} --flip ${root}_anc-merge.missnp --make-bed --out ${root}f
plink --bfile ${root}f --bmerge ancestral_samples_Omni2.5variants.bed ancestral_samples_Omni2.5variants.bim ancestral_samples_Omni2.5variants.fam --make-bed --out ${root}_anc2

##Step3: Change phenotype status to 1.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziexoverlapanc_anc2
cp ${root}.fam ${root}.fam_original
sed 's/-9/1/g' < ${root}.fam > tmp; mv tmp ${root}.fam

##Step4: Exclude the fake.
plink --bfile ${root} --remove anc_fake --make-bed --out ${root}fex
plink --bfile ${root}fex --recode --out ${root}fex

##
sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziexoverlapanc_anc2fex/g' par.PED.EIGENSTRAT > par.PED.EIGENSTRAT.20200613.Omni2.5
#module load bioinfo-tools AdmixTools/5.0-20171024
convertf -p par.PED.EIGENSTRAT.20200613.Omni2.5

#Modify the third column of .indiv so it has the population ID.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziexoverlapanc_anc2fex
cp ${root}.indiv ${root}.indiv_original #do that the first time only!!!
cut -d" " -f1 ${root}.fam >file2a
awk '{print $1 " " $2}' < ${root}.indiv_original > file1
touch fileComb
paste file1 file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.indiv
rm file1; rm file2a; rm fileComb

cd /proj/uppstore2018150/private/results/f4ratiotest/20200613
cp /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${root}.indiv .
cp /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${root}.geno .
cp /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${root}.snp .

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex4Loziexoverlapanc_anc2fex/g' < /proj/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_KSadmixture_Omni2.5/g' > par.f4ratio.20200613_KSadmixture_Omni2.5
qpF4ratio -p par.f4ratio.20200613_KSadmixture_Omni2.5 > logfile.20200613_KSadmixture_Omni2.5

#I do not have RHG nor eHG so I cannot test those.

###
### Comparisons.
###
#Results using 2 or 3 apes to determine the ancestral state are very similar.
#Results for the KS admixture with Omni2.5 and Omni1 are very similar (larger CI with Omni1 but nothing dramatic).
#CCL: I can use the results with Omni1 and 3 apes.


###
### Plot.
###

#The easiest is to plot 1-alpha (easier to understand). I think it should be fine to use the standard deviation. NH in her Paper I added bars of in total 2 stdev.


##########################################################################################
###
### The code below corresponds to my first f4 ratio test tests! (20200612). I modified several things and the more updated commands are above.
###
### What I changed:
# -remove the fake individual.
# -use a different strategy to remove the variants not in my callset.
# -do it for the Omni2.5 merge.
# -remove BP Lozi individuals.

##
##plink fileset for the ancestral state (prepared by Mario Vicente): /proj/uppstore2018150/private/raw/H3Africaancestral/ancestral_samples
##Starting with the Omni1 merge (to have RHG too).
##Comment: remember that I do not have many variants in this callset... (~350,000)

folder=/proj/uppstore2018150/private/raw/H3Africaancestral/
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex --bmerge ${folder}ancestral_samples.bed ${folder}ancestral_samples.bim ${folder}ancestral_samples.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex --flip zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral-merge.missnp --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fexf
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fexf --bmerge ${folder}ancestral_samples.bed ${folder}ancestral_samples.bim ${folder}ancestral_samples.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral2
#Now I need to filter for missingness to remove all the sites variable only in the new samples! Or MAF.
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral2 --geno 0.0034 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral3 #325110 variants and 981 people pass filters and QC. I might have lost some extra variants. Too bad. I will try like that though.

##
#I modified manually the .fam to have 1 instead of -9 in the phenotype column. 
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral3 --recode --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral3
#I do not think that I need to remove the fake individual since I am not going to use it anyway! If something looks weird I will.

##
sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral3/g' par.PED.EIGENSTRAT > par.PED.EIGENSTRAT.20200612.Omni1
#I modified the file manually to remove the long comments.
convertf -p par.PED.EIGENSTRAT.20200612.Omni1

root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral3
#cp ${root}.ind ${root}.ind_original #do that the first time only!!!
cut -d" " -f1 ${root}.fam >file2a
#cut -d" " -f1,2 ${root}.ind > file1
awk '{print $1 " " $2}' < ${root}.ind_original > file1
touch fileComb
paste file1 file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.ind
rm file1; rm file2a; rm fileComb

#
# Perform the test!
#
cd /proj/uppstore2018150/private/results/f4ratiotest/20200612
module load bioinfo-tools AdmixTools/5.0-20171024
#I copied the fileset to the folder and I renamed the .eigenstratgeno to .geno. Let's see...

#I am testing the following combinations:
CHB anc_2apes : Bangweulu Juhoansi :: CHB anc_2apes : YRI Juhoansi
CHB anc_2apes : Kafue Juhoansi :: CHB anc_2apes : YRI Juhoansi
CHB anc_2apes : SEBantu Juhoansi :: CHB anc_2apes : YRI Juhoansi
CHB anc_2apes : Zulu Juhoansi :: CHB anc_2apes : YRI Juhoansi

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral3/g' < par.f4ratio | sed 's/POPFILE/20200612_popfile_KSadmixture_test/g' > par.f4ratio.20200612_popfile_KSadmixture_test

qpF4ratio -p par.f4ratio.20200612_popfile_KSadmixture_test > logfile.20200612_KSadmixture_test #It seems to be working just fine! :)

#Now with the RHG!
CHB anc_2apes : Bangweulu Baka_Gab :: CHB anc_2apes : YRI Baka_Gab
CHB anc_2apes : Kafue Baka_Gab :: CHB anc_2apes : YRI Baka_Gab
CHB anc_2apes : Zambia_Lozi Baka_Gab :: CHB anc_2apes : YRI Baka_Gab
CHB anc_2apes : Zambia_Bemba Baka_Gab :: CHB anc_2apes : YRI Baka_Gab
CHB anc_2apes : Zambia_TongaZam Baka_Gab :: CHB anc_2apes : YRI Baka_Gab
CHB anc_2apes : SEBantu Baka_Gab :: CHB anc_2apes : YRI Baka_Gab
CHB anc_2apes : Zulu Baka_Gab :: CHB anc_2apes : YRI Baka_Gab
CHB anc_2apes : Nzime_Cam Baka_Gab :: CHB anc_2apes : YRI Baka_Gab

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_ancestral3/g' < par.f4ratio | sed 's/POPFILE/20200612_popfile_RHGadmixture_test/g' > par.f4ratio.20200612_RHGadmixture_test

qpF4ratio -p par.f4ratio.20200612_RHGadmixture_test > logfile.20200612_RHGadmixture_test #Looks like the RHG and KS ancestries get mixed up!






