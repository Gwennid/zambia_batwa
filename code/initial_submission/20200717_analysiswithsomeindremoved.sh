#Gwenna Breton
#started 20200717
#Goal: Remove some individuals from the final merged datasets prepared in 20200330_prepare_data.sh to re-run the analyses for the thesis version of the manuscript. Later it would be better to remove the individuals before merging of the different datasets. And rerun the analyses that I am including in the manuscript.

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020

###
interactive -p core -n 1 -A snic2018-8-397 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9
###


###
### Omni2.5
###

# Final file Omni2.5 (before removing the fake individual):
/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3

#List with the four Lozi to exclude:
/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/4Lozitoexclude

#Add the Schuster San to that list; remove fakes from that file.
grep schus /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fam | cat /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/4Lozitoexclude - > 4Lozi_schus_toexclude
plink --bfile /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --remove 4Lozi_schus_toexclude --biallelic-only strict --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex --remove /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex

#Modify the .fam
cp zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex.fam zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex.fam_original
sed 's/ColouredAskham/Khomani/g' < zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex.fam_original > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex.fam

###
### Omni1
###

# Final file Omni1 (before removing the fake individual):
/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4

# Remove the 4 Lozi, Schuster San, and fake individuals:
plink --bfile /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --remove 4Lozi_schus_toexclude --biallelic-only strict --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex --remove /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex

#Modify the .fam
cp zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex.fam zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex.fam_original
sed 's/ColouredAskham/Khomani/g' < zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex.fam_original > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex.fam


###
### PCA
###

# Omni2.5 (for SI)
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex
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
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 30:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END
#Running. TODO plot. I am not sure why it is taking so long!

# Omni1 (for main & SI)
## Entire dataset.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex
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
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 30:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

## YRI, Baka (Cameroon), Juhoansi, and projection of the Zambian populations.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex
grep -e YRI -e Baka_Cam -e Juhoansi -e Bangweulu -e Kafue -e Zambia ${root}.fam > ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
plink --bfile ${root} --keep ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp --make-bed --out ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
#plink --bfile ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp --geno 0.1 --mind 0.1 --make-bed --out ${root}_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_2 #No variant removed - I am removing that file.
 
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
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
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
smartpca -p ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 10:0  -A snic2018-8-397 -J PC_${root}_B_K_ZambiaBantusp_projected -o PC_${root}_B_K_ZambiaBantusp_projected.output -e PC_${root}_B_K_ZambiaBantusp_projected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

###
### ADMIXTURE
###

# Only for Omni1 (main text).
## Preliminary step: filter for LD
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex
plink --bfile ${root} --indep-pairwise 50 10 0.1 --make-bed --out ${root}_2 #229372 of 344629
plink --bfile ${root} --extract ${root}_2.prune.in --make-bed --out ${root}_2

## Running admixture
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2020_Omni1/log
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_2
for i in {1..20}; do
for k in {2..12}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2020_Omni1/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 12:0:0 -A snic2018-8-397 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1_2.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done
#Submitted!
#Run 9_15 is taking twice as long as any other run. So I submitted 9_21 in case it eventually fails. In the end 9_15 finished so I cancelled 9_21.

###
### MOSAIC
###

#I decided to not redo the phasing, so I will need to exclude the individuals from the phasing output & to merge the Khomani and the ColouredAskham individuals. TODO later (for submission): redo the phasing!
#Commands are based on 20200421_phase_impute_MOSAIC.sh.

## I need to remove: the four Lozi from BP; schuster San; the two Lozi with high non-African admixture.

#There are 978 diploid individuals. haps has 5+978*2=1961 columns and sample has 2+978=980 rows.
#I need to remove six columns from haps and three rows from sample. For .sample, I can use grep -v.

#I look in "sample.names" (local file) to figure out which the row of each individual I want to remove.
#San schuster: row 711 in sample, individual 709. Columns 1422-1423.
#ZAM031: row 912, ind 910, columns: 1824-1825
#Lozi fifth individual: row 915 in .sample, individual 913 (ZAM27). Columns 1830-1831.
#Lozi 17th individual: row 927 in .sample, individual 925 (ZAM66). Columns 1854-1855.	
#ZAM229: row 933, ind 931, columns: 1866-1867
#ZAM280: row 934, ind 932, columns: 1868-1869
#ZAM342: row 935, ind 933, columns: 1870-1871

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/haps_sample_files
infolder=/proj/snic2020-2-10/uppstore2018150/private/tmp/20200421_phasing
for chr in {1..22}; do
haps=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps #one line per variant, two columns per individual.
sample=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.sample #one line per individual (plus two header lines).
haps2=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps #my new file (with the individuals I want to remove removed).
sample2=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.sample #my new file (with the individuals I want to remove removed).
cut -d" " -f1-1421,1424-1823,1826-1829,1832-1853,1856-1865,1872-1961 ${infolder}/${haps} > ${haps2}
grep -v schus ${infolder}/${sample} | grep -v ZAM27 | grep -v ZAM66 | grep -v ZAM031 | grep -v ZAM229 | grep -v ZAM280 | grep -v ZAM342 > ${sample2}
done

#Prepare the .fam with the shorter population names.
grep -v schus ../../20200421_phasing/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr7f.fam | grep -v ZAM27 | grep -v ZAM66 | grep -v ZAM031 | grep -v ZAM229 | grep -v ZAM280 | grep -v ZAM342 > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam

cp zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam tmp1; bash /proj/snic2020-2-10/uppstore2018150/private/scripts/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam; rm tmp1

#Prepare the other inputs.

## genofile
##Comment: this works with R/3.6.1 but not with R/3.6.0 as long as I can understand.
for chr in {1..22}; do
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/convert_from_haps.R /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/haps_sample_files/ ${chr} zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr f.phased_withKGP.2.haps zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/
done

## snpfile and rates: copied from /proj/snic2020-2-10/uppstore2018150/private/tmp/20200425_MOSAIC/INPUT because I did not modify the number of markers. Wait that the R script is done because the R script also creates snpfiles!
cd INPUT/
cp ../../20200425_MOSAIC/INPUT/snpfile.* .
cp ../../20200425_MOSAIC/INPUT/rates.* .

#Comment: I deleted the genofiles from my previous MOSAIC runs (because it represents many files). But I can recreate them easily if I need to.

# Run MOSAIC!!!

## Two-way admixture for each of the five Zambian populations as well as the Baka from Cameroon, the SEBantu, maybe the Nama? TODO check my notes. Comment: I should maybe try to copy all the files to avoid too much read/write operations. On the other hand, I am not sure how I can do that with this R script... I should try it out.

## Test: using scratch. Trying for chr1 from the Tonga (it should go fast). It took 8 minutes on a fat core. Dates are very different than when using 1-22, it's a bit scary!
## A fat core is likely an overkill but it makes the management of scratch easier (apparently in core mode you need to use the job ID) (it worked just fine on the ABC though, so I might try).

# I want:
# -2 way admixture for Bangweulu Bemba Kafue Lozi Tonga,
# -possibly 3 and 4 way admixture for Bangweulu and Kafue (though it is less of a priority) (and the other Zambian populations),
# -3 and 4 way admixture for Bangweulu and Kafue with specification of the source populations,
# -2 way admixture for the Baka (Cameroon), Nzime (Cameroon), Karretjie, Khomani, Xun, SEBantu, SWBantu (compare to results from Schlebusch 2016)
# -2 way admixture with specified sources (YRI and Juhoansi) for Karretjie, Khomani, Xun, SEBantu, SWBantu (compare to results from Schlebusch 2016)
# TODO work on that once I have an idea of whether using scratch did work. If I use less than a node, try the following: (I think that with the double quotes like I did above, $SNIC_TMP is replaced by /scratch and this is common to all cores, while normally it corresponds to a folder unique for the job.)

### Testing
cd /proj/snic2020-2-10/uppstore2018150/private/scripts/bashout/MOSAIC
pop=Tonga
i=2
chr=1
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R .
Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:${chr} -m 20
cp -r $SNIC_TMP/MOSAIC_RESULTS/ /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/
cp -r $SNIC_TMP/MOSAIC_PLOTS/ /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/
cp -r $SNIC_TMP/FREQS/ /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/
exit 0") | sbatch -p node -C fat -t 1:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL

# I will try 1-22 but 10 cores.
# It failed. So I will use a fat node, too bad! At least I might be saving a bit of time by copying everything (I hope...). I am still trying with the Tonga only and then I will submit the rest. Caution! TODO increase time for the other populations.
pop=Tonga
i=2
chr=22
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:${chr} -m 20"
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/FREQS/
exit 0') | sbatch -p node -C fat -t 9:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
#So. It was not faster than previously, but at least it ran. I will go for a fat node for the other runs too.

###All.
#2-ways
for pop in Kafue Bangweulu Lozi Bemba BakaC Nzime SEBantu Karretjie Khomani Xun; do
i=2
chr=22
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:${chr} -m 20"
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/FREQS/
exit 0') | sbatch -p node -C fat -t 24:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL

#3-ways (only for the Zambian BaTwa).
for pop in Kafue Bangweulu; do
i=3
chr=22
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:${chr} -m 20"
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/FREQS/
exit 0') | sbatch -p node -C fat -t 36:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

#4-ways (only for the Zambian BaTwa).
for pop in Kafue Bangweulu; do
i=4
chr=22
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:${chr} -m 20"
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/FREQS/
exit 0') | sbatch -p node -C fat -t 36:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

#Ancestry specified.
#3-way
for pop in Bangweulu Kafue; do
i=3
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 8 -p \"Yoruba BakaC Juhoansi\" "
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/FREQS/
exit 0') | sbatch -p core -n 8 -t 12:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i}_subset -o MOSAIC_${pop}_${i}_subset.output -e MOSAIC_${pop}_${i}_subset.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

#4-way
for pop in Bangweulu Kafue; do
i=4
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 8 -p \"Yoruba BakaC Juhoansi Amhara\" "
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/FREQS/
exit 0') | sbatch -p core -n 8 -t 18:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i}_subset -o MOSAIC_${pop}_${i}_subset.output -e MOSAIC_${pop}_${i}_subset.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

#2-way for the KS and KS-neigbors
for pop in SEBantu Karretjie Khomani Xun; do
i=2
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 8 -p \"Yoruba Juhoansi\" "
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20200717_MOSAIC/FREQS/
exit 0') | sbatch -p core -n 8 -t 12:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i}_subset -o MOSAIC_${pop}_${i}_subset.output -e MOSAIC_${pop}_${i}_subset.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done


###
### Runs of homozygosity
###

interactive -p core -n 1 -A snic2018-8-397 -t 2:00:0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020
module load bioinfo-tools plink/1.90b4.9

#Comment: previously I had removed the two Lozi with recent European admixture. Here I won't because I do not really understand why. TODO later if someone asks and / or if it makes a bit difference in the results.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex
plink --bfile ${root} --mind 0.05 --geno 0.05 --make-bed --out ${root}_2

plink --bfile ${root}_2 --homozyg --homozyg-snp 50 --homozyg-kb 500 --homozyg-density 50 --homozyg-gap 100 --homozyg-window-snp 50 --homozyg-window-het 1 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --out ${root}_2_roh1
plink --bfile ${root}_2 --homozyg --homozyg-snp 50 --homozyg-kb 1000 --homozyg-density 50 --homozyg-gap 100 --homozyg-window-snp 50 --homozyg-window-het 1 --homozyg-window-missing 5 --homozyg-window-threshold 0.05 --out ${root}_2_roh2

## n_ROH by population (total) (Caution! Number of individuals should be accounted for somehow).
for POP in Amhara Bangweulu CEU Chad_Sara Chad_Toubou CHB GuiGhanaKgal Igbo Juhoansi Kafue Karretjie Khomani Khwe LWK Mandinka MKK Nama Oromo SEBantu Somali Sotho SWBantu Xun YRI Zambia_Bemba Zambia_Lozi Zambia_TongaZam Zulu; do
n_ROH=$(grep ${POP} ${root}_2_roh1.hom | wc -l|cut -f1)
echo -e "${POP}\t${n_ROH}" >> ${root}_2_roh1.nROHbypop
done
#idem for roh2

# Locally: modify the population names
cd /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/ROH
cp zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex_2_roh2.hom tmp1; bash ../../../src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex_2_roh2_newnames.hom ; rm tmp1
cp zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex_2_roh2.hom.indiv tmp1; bash ../../../src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex_2_roh2_newnames.hom.indiv ; rm tmp1


###
### f4 ratio
###

# I am doing it only for the Omni1 dataset this time (I tested earlier that it did not make much of a difference with Omni2.5). Again, I am not going to remove the two Lozi with recent admixture unless results are very different or someone asks for it.
# Commands are based on f4_ratio_test.sh

##Step1: find overlap between the markers in the ancestral and the marker in the Omni1 dataset (fake individual not excluded yet).
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex
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
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_overlapanc_anc2
cp ${root}.fam ${root}.fam_original
sed 's/-9/1/g' < ${root}.fam > tmp; mv tmp ${root}.fam
#Oops! I modified zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex.fam AND zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_overlapanc_anc.fam ...

##Step4: Exclude the fake.
grep fake ${root}.fam > ${root}_fake
plink --bfile ${root} --remove ${root}_fake --make-bed --out ${root}fex
#Change the ColouredAskham to Khomani:
cp ${root}fex.fam ${root}fex.fam_original 
sed 's/ColouredAskham/Khomani/g' < ${root}fex.fam_original > ${root}fex.fam
plink --bfile ${root}fex --recode --out ${root}fex

##
sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_overlapanc_anc2fex/g' par.PED.EIGENSTRAT > par.PED.EIGENSTRAT.20200717.Omni1
module load bioinfo-tools AdmixTools/5.0-20171024
convertf -p par.PED.EIGENSTRAT.20200717.Omni1 #this is slow.

#Modify the third column of .indiv so it has the population ID.
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_overlapanc_anc2fex
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
cd /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/20200717
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020/${root}.indiv .
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020/${root}.geno .
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/reducedanalysisset_July2020/${root}.snp .

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_overlapanc_anc2fex/g' < /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_KSadmixture/g' > par.f4ratio.20200717_KSadmixture
qpF4ratio -p par.f4ratio.20200717_KSadmixture > logfile.20200717_KSadmixture
#I get some alpha larger than 1! Does not seem right.

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_overlapanc_anc2fex/g' < /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200717_popfile_wRHGadmixture/g' > par.f4ratio.20200717_wRHGadmixture
#for that one I modified 20200613_popfile_wRHGadmixture because I wanted to use the Baka from Cameroon instead of the Baka from Gabon.
qpF4ratio -p par.f4ratio.20200717_wRHGadmixture > logfile.20200717_wRHGadmixture

sed 's/example/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_overlapanc_anc2fex/g' < /proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20200613_popfile_eHGadmixture/g' > par.f4ratio.20200717_eHGadmixture
qpF4ratio -p par.f4ratio.20200717_eHGadmixture > logfile.20200717_eHGadmixture










