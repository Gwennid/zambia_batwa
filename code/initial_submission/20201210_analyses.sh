#20201210
#Gwenna Breton
#Goal: perform the analyses that are currently in the ms (PCA, ADMIXTURE, f4 ratio, MOSAIC, ROH, etc) on the new analysis set (same individuals like in 20200717_analysiswithsomeindremoved.sh but the removal of the Lozi and the Schuster San and the merging of the ColouredAshkam and the Khomani has been done properly i.e. at an earlier stage).
#Based on 20200717_analysiswithsomeindremoved.sh

### Typical commands to start working:
interactive -p core -n 1 -A snic2018-8-397 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
#Computing hours projects: snic2019-8-157 (mine); snic2019-8-14 (PS); snic2019-8-175 (MV); g2019029 (teaching).
###

###
### PCA
###

# Omni2.5 (for SI)
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par 
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 30:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

# Omni1 (for main & SI)
## Entire dataset.
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par 
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 30:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

## YRI, Baka (Cameroon), Juhoansi, and projection of the Zambian populations.
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
grep -e YRI -e Baka_Cam -e Juhoansi -e Bangweulu -e Kafue -e Zambia ${root}.fam > ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
plink --bfile ${root} --keep ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp --make-bed --out ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
#plink --bfile ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp --geno 0.1 --mind 0.1 --make-bed --out ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_2 #No variant removed - I am removing that file.
 
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
echo -e 'poplistname:\tYRI_Baka-Cam_Juhoansi_poplist' >> ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
rm temppar

(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
smartpca -p ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 10:0  -A snic2018-8-397 -J PC_${root}_B_K_ZambiaBantusp_projected -o PC_${root}_B_K_ZambiaBantusp_projected.output -e PC_${root}_B_K_ZambiaBantusp_projected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

## African individuals only (2021-01-15)
#20210119: Submitted
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
grep -v CEU ${root}.fam | grep -v CHB > ${root}_Africaonly #901 individuals left
plink --bfile ${root} --keep ${root}_Africaonly --make-bed --out ${root}_Africaonly
#plink --bfile ${root}_Africaonly --geno 0.1 --mind 0.1 --make-bed --out ${root}_Africaonly_2 #No variant removed - I am removing that file.
 
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_Africaonly/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par
rm temppar

(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 1:0:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END #Took five minutes. Used 194297 SNPs.

# Omni1 + ancient samples
# See how the input file was obtained in 20201209_prepare_data.sh as well as a first PCA test.

root=omni1finalmerge_ancient4fexhap

plink --file omni1finalmerge_ancient4fexhap --make-bed --out omni1finalmerge_ancient4fexhap
plink --bfile omni1finalmerge_ancient4fexhap --missing --out omni1finalmerge_ancient4fexhap #Missingness goes from ~0.5 (the WG samples I think) to ~0.95.

##Filtering for site and individual missingness like MV did.
#I have 344,644 sites in total, so if I keep individuals with at least 15,000 sites it means a missingness of: 1-15000/344644 ~ 0.956. Only one individual is failing that (Kenya_Pastoral_Neolithic I8820).
plink --bfile ${root} --geno 0.15 --mind 0.956 --make-bed --out ${root}_2 #344644 variants and 1019 people

#There is still the question of the LD pruning. After discussion with MJ and CS, I will try with and without LD pruning.

#African only
root=omni1finalmerge_ancient4fexhap_2
grep -v CEU ${root}.fam | grep -v CHB > ${root}_Africaonly
plink --bfile ${root} --keep ${root}_Africaonly --make-bed --out ${root}_Africaonly

root=omni1finalmerge_ancient4fexhap_2_Africaonly
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

#With smartpca LD filtering
cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_ancientprojected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_ancientprojected.par
echo -e 'poplistname:\tpop_omni1_Africaonly' >> ${root}_killr20.2_popsize36_ancientprojected.par
rm temppar

#Without LD filtering
cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_popsize36_ancientprojected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           NO/g"   > ${root}_popsize36_ancientprojected.par
echo -e 'poplistname:\tpop_omni1_Africaonly' >> ${root}_popsize36_ancientprojected.par
rm temppar

(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=omni1finalmerge_ancient4fexhap_2_Africaonly
smartpca -p ${root}_killr20.2_popsize36_ancientprojected.par > ${root}_killr20.2_popsize36_ancientprojected.smartpca.logfile
smartpca -p ${root}_popsize36_ancientprojected.par > ${root}_popsize36_ancientprojected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 1:0:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END #Took 10 minutes. 319,535 SNPs used, i.e. a lot more than in the equivalent PCA without the ancient. Not sure why! When not including LD filtering, more SNPs are "killed in pass" (4691 versus 35).

#TODO possibly: plink LD filtering

#20210125
#Trying with recommendations from MV: include BBA in the population reference list; use options lsqproject and shrinkmode.
cp pop_omni1_Africaonly pop_omni1_Africaonly_baa
echo "baa001" >> pop_omni1_Africaonly_baa

#create .par for smartpca
poplist=pop_omni1_Africaonly_baa
infile=omni1finalmerge_ancient4fexhap_2_Africaonly
outfile=omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_20210125
echo "altnormstyle:     NO
genotypename:     ${infile}.bed
snpname:          ${infile}.bim
indivname:        ${infile}.pedind
evecoutname:      ${outfile}.evec
evaloutname:      ${outfile}.eval
popsizelimit:     36
qtmode:           NO
killr2:           YES
r2thresh:         0.2
numoutlieriter:   0
lsqproject:       YES
poplistname:      ${poplist}
shrinkmode:       YES" > ${outfile}.par

#Modified compared to MV: popsizelimit (36 instead of 20); killr2 (YES instead of NO); r2thresh (0.2 instead of 0.7). TODO: run PCA with these parameters, see how it impacts the output. Then look into all options that differ between mine and his script (e.g. altnormstyle, lsqproject, shrinkmode) and also the impact of killr2/LD filtering.
 
# prepare and submit the script
cd /proj/snic2020-2-10/uppstore2018150/private/scripts/bashout/PCA
root=omni1finalmerge_ancient4fexhap_2_Africaonly
(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=omni1finalmerge_ancient4fexhap_2_Africaonly
outfile=omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_20210125
smartpca -p \${root}_killr20.2_popsize36_ancientprojected_20210125.par > \${root}_killr20.2_popsize36_ancientprojected_20210125.smartpca.logfile
sed 1d \${outfile}.evec | sed 's/:/ /g' > \${outfile}.evecm
exit 0") | sbatch -p core -n 1 -t 12:0:0  -A snic2018-8-397 -J PC_${root}_20210125 -o PC_${root}_20210125.output -e PC_${root}_20210125.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END 
#MV asks for 2 days and 4 cores!
#Submitted.





###
### ADMIXTURE
###

# Only for Omni1 (main text).
## Preliminary step: filter for LD
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
plink --bfile ${root} --indep-pairwise 50 10 0.1 --make-bed --out ${root}_2 #229409 of 344644 removed.
plink --bfile ${root} --extract ${root}_2.prune.in --make-bed --out ${root}_2

## Running admixture
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Dec2020_Omni1/log
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2
for i in {1..20}; do
for k in {2..12}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Dec2020_Omni1/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 12:0:0 -A snic2018-8-397 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1_2.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done
#Submitted!
#

###
### Runs of homozygosity
###

#Comment: previously I had removed the two Lozi with recent European admixture. Here I won't because I do not really understand why. TODO later if someone asks and / or if it makes a bit difference in the results.
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
plink --bfile ${root} --mind 0.05 --geno 0.05 --make-bed --out ${root}_2

plink --bfile ${root}_2 --homozyg --homozyg-snp 50 --homozyg-kb 500 --homozyg-density 50 --homozyg-gap 100 --homozyg-window-snp 50 --homozyg-window-het 1 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --out ${root}_2_roh1
plink --bfile ${root}_2 --homozyg --homozyg-snp 50 --homozyg-kb 1000 --homozyg-density 50 --homozyg-gap 100 --homozyg-window-snp 50 --homozyg-window-het 1 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --out ${root}_2_roh2

# Locally: modify the population names
cd /home/gwennabreton/Desktop/Work_from_home/P3/results/December2020/ROH/
cp zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_2_roh2.hom tmp1; bash /home/gwennabreton/Desktop/Work_from_home/P3/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_2_roh2_newnames.hom ; rm tmp1
cp zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_2_roh2.hom.indiv tmp1; bash /home/gwennabreton/Desktop/Work_from_home/P3/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_2_roh2_newnames.hom.indiv ; rm tmp1

###
### f4 ratio
###

# I am doing it only for the Omni1 dataset this time (I tested earlier that it did not make much of a difference with Omni2.5). Again, I am not going to remove the two Lozi with recent admixture unless results are very different or someone asks for it.
# Commands are based on f4_ratio_test.sh

##Step1: find overlap between the markers in the ancestral and the marker in the Omni1 dataset (fake individual not excluded yet).
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4
cut -f2 ${root}.bim > Omni1_variants
folder=/proj/snic2020-2-10/uppstore2018150/private/raw/H3Africaancestral/
plink --bfile ${folder}ancestral_samples --extract Omni1_variants --make-bed --out ancestral_samples_Omni1variants
cut -f2 ancestral_samples_Omni1variants.bim > ancestral_samples_Omni1variants
plink --bfile ${root} --extract ancestral_samples_Omni1variants --make-bed --out ${root}_overlapanc

##Step2: Merge.
plink --bfile ${root}_overlapanc --bmerge ancestral_samples_Omni1variants.bed ancestral_samples_Omni1variants.bim ancestral_samples_Omni1variants.fam --make-bed --out ${root}_overlapanc_anc
plink --bfile ${root}_overlapanc --flip ${root}_overlapanc_anc-merge.missnp --make-bed --out ${root}_overlapancf
plink --bfile ${root}_overlapancf --bmerge ancestral_samples_Omni1variants.bed ancestral_samples_Omni1variants.bim ancestral_samples_Omni1variants.fam --make-bed --out ${root}_overlapanc_anc2

##Step3: Change phenotype status to 1.
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2
cp ${root}.fam ${root}.fam_original
sed 's/-9/1/g' < ${root}.fam > tmp; mv tmp ${root}.fam

##Step4: Exclude the fake.
grep fake ${root}.fam > ${root}_fake
plink --bfile ${root} --remove ${root}_fake --make-bed --out ${root}fex
plink --bfile ${root}fex --recode --out ${root}fex

##
sed 's/example/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex/g' /proj/snic2020-2-10/uppstore2018150/private/scripts/par.PED.EIGENSTRAT > par.PED.EIGENSTRAT.20201210.Omni1
module load bioinfo-tools AdmixTools/5.0-20171024
convertf -p par.PED.EIGENSTRAT.20201210.Omni1 #this is slow.

#Modify the third column of .indiv so it has the population ID.
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex
#cp ${root}.indiv ${root}.indiv_original #do that the first time only!!!
cut -d" " -f1 ${root}.fam >file2a
awk '{print $1 " " $2}' < ${root}.indiv_original > file1
touch fileComb
paste file1 file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.indiv
rm file1; rm file2a; rm fileComb

#
# Perform the test!
#
cd /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/20201210
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${root}.indiv .
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${root}.geno .
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${root}.snp .

sed 's/example/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex/g' < /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_KSadmixture/g' > par.f4ratio.20201210_KSadmixture
qpF4ratio -p par.f4ratio.20201210_KSadmixture > logfile.20201210_KSadmixture
#I get some alpha larger than 1! Does not seem right.

sed 's/example/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex/g' < /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200717_popfile_wRHGadmixture/g' > par.f4ratio.20201210_wRHGadmixture
qpF4ratio -p par.f4ratio.20201210_wRHGadmixture > logfile.20201210_wRHGadmixture

sed 's/example/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex/g' < /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_eHGadmixture/g' > par.f4ratio.20201210_eHGadmixture
qpF4ratio -p par.f4ratio.20201210_eHGadmixture > logfile.20201210_eHGadmixture


###
###ADMIXTURE with ancient sample (20210212)
###

#LD filtered fileset: /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/omni1finalmerge_ancient4fexhap_2_ld200-25-0.4

#Group some of the ancient samples in populations.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/
root=omni1finalmerge_ancient4fexhap_2_ld200-25-0.4
#cp ${root}.fam ${root}.fam_original

##First I modified with nano ${root}.fam to split the four samples from Shum Laka into Shum_Laka_8000BP and Shum_Laka_3000BP (they all had FID Shum_Laka).
##Then I grouped some samples (+ renamed the Zambian agriculturalists).
cut -d" " -f1 ${root}.fam | sed 's/baa001/BBay/g' | sed 's/bab001/BBay/g' | sed 's/Zambia_Bemba/Bemba/g' | sed 's/Zambia_Lozi/Lozi/g' | sed 's/Zambia_TongaZam/Tonga/g' | sed 's/I9028/SAfr_LSA_Cape_2000BP/g' | sed 's/I9133/SAfr_LSA_Cape_2000BP/g' | sed 's/I9134/SAfr_LSA_Pastoralist_1200BP/g' | sed 's/cha001/SAfr_IA_500BP/g' | sed 's/ela001/SAfr_IA_500BP/g' | sed 's/mfo001/SAfr_IA_500BP/g' | sed 's/new001/SAfr_IA_500BP/g' > ${root}.fam_col1
cut -d" " -f2-6 ${root}.fam | paste ${root}.fam_col1 - > tmp
mv tmp ${root}.fam
rm ${root}.fam_col1

## Running admixture
#For the moment I am only testing K=2 to K=8 and ten repeats. I will plot this and depending on how it looks either run more iterations, go to higher Ks, or/and test more stringent LD filtering (in fact I will in any case test more stringent LD filter, but I want first to check that these results make sense somehow).
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/log
prefix=omni1finalmerge_ancient4fexhap_2_ld200-25-0.4
for i in {1..10}; do
for k in {2..8}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 16:0:0 -A snic2018-8-397 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done

#20210215
#ADMIXTURE K=2 to K=8, 10 repeats, same LD threshold than in the modern only dataset (i.e. more stringent, but still ~240,000 variants remain).
#cp omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.fam omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.fam_original
cp omni1finalmerge_ancient4fexhap_2_ld200-25-0.4.fam omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.fam

cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/log
prefix=omni1finalmerge_ancient4fexhap_2_ld50-10-0.1
for i in {1..10}; do
for k in {2..8}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 16:0:0 -A snic2018-8-397 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done
#Based on quick visualisation, I decided to submit more repeats and higher Ks under this LD filter (TODO double check more closely for possible differences).

cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/log
prefix=omni1finalmerge_ancient4fexhap_2_ld50-10-0.1
for i in {11..20}; do
for k in {2..8}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 16:0:0 -A snic2018-8-397 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done

for i in {1..20}; do
for k in {9..12}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 16:0:0 -A snic2018-8-397 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done

#####
#20210310 - Additional PCA.
## Nzebi, Baka (Cameroon), Juhoansi, and projection of the Zambian populations.
interactive -p core -n 1 -A snic2018-8-397 -t 1:0:0
module load bioinfo-tools plink/1.90b4.9
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020

root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
grep -e Nzime -e Baka_Cam -e Juhoansi -e Bangweulu -e Kafue -e Zambia ${root}.fam > ${root}_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
plink --bfile ${root} --keep ${root}_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp --make-bed --out ${root}_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
#plink --bfile ${root}_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp --geno 0.1 --mind 0.1 --make-bed --out ${root}_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_2 #No variant removed - I am removing that file.
 
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

#TODO make a "poplistname" manually.

cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
echo -e 'poplistname:\tNzime_Baka-Cam_Juhoansi_poplist' >> ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
rm temppar

(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
smartpca -p ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 10:0  -A snic2019-8-157 -J PC_${root}_B_K_ZambiaBantusp_projected -o PC_${root}_B_K_ZambiaBantusp_projected.output -e PC_${root}_B_K_ZambiaBantusp_projected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END



