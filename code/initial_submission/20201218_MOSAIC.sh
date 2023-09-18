###Gwenna Breton
###20201218
###Goal: prepare the input files for MOSAIC and run MOSAIC (with the newly processed data).

#TODO Caution! I need to exclude the recently admixed Lozi individuals... At which stage do I do that? 20200425: I removed them from the .haps and .sample files i.e. the phasing outputs.
#Caution! Do not mix the two Baka populations!
#I need to prepare the other MOSAIC input files too.

cd /proj/snic2020-2-10/uppstore2018150/private/

/proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R
/proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/convert_from_haps.R

###
###Prepare the population input files (Remove the two Lozi with recent non-African admixture).
###
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/haps_sample_files
infolder=/proj/snic2020-2-10/uppstore2018150/private/tmp/20201210_phasing

#There are 973 diploid individuals. haps has 5+973*2=1951 columns and sample has 2+973=975 rows.
#I need to remove four columns from haps and two rows from sample. For .sample, I can use grep -v.
#Lozi fourth individual: row 913 in .sample, individual 911 (ZAM27). Columns 5+911*2 = 1827 -> 1826-1827.
#Lozi 16th individual: row 925 in .sample, individual 923 (ZAM66). Columns 1850-1851.

for chr in {1..22}; do
#shapeit outputs
haps=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps
sample=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.sample
#modified shapeit outputs
haps2=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps
sample2=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.sample
cut -d" " -f1-1825,1828-1849,1852-1951 ${infolder}/${haps} > ${haps2}
grep -v ZAM27 ${infolder}/${sample} | grep -v ZAM66 > ${sample2}
done

#Prepare the .fam with the shorter population names.
#TODO Question: is that when I "merged" the two Baka populations? I am not sure. Pay attention in the next steps! (I do not think the problem is here)
grep -v ZAM27 ${infolder}/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr7f.fam | grep -v ZAM66 > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam
cp zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam tmp1; bash /crex/proj/snic2020-2-10/uppstore2018150/private/scripts/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam; rm tmp1

#Comment: this works with R/3.6.1 but not with R/3.6.0 as long as I can understand.
module load bioinfo-tools R/3.6.1
for chr in {1..22}; do
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/convert_from_haps.R /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/haps_sample_files/ ${chr} zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr f.phased_withKGP.2.haps zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/INPUT/
done

###
###Prepare the other files (rates, snpfile, and sample.names)
###

#snpfile
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/INPUT/
for chr in {1..22}; do
input=../haps_sample_files/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps
cut -f2 -d" " ${input} > col1
cut -f1 -d" " ${input} > col2
cut -f3-5 -d" " ${input} > col4-6
nrow=$(wc -l ../haps_sample_files/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps | cut -f1 -d" ")
for i in $(eval echo "{1..$nrow}") ; do echo "0" >> col3; done
paste col1 col2 col3 col4-6 > snpfile.${chr}
rm col*
done

#rates
#Super weird format: three rows! Row 1: number of sites (format: ":sites:44801"), row 2: positions, row 3: cumulative recombination rate. Preparing the files on Uppmax.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/INPUT/
GENETIC_MAP=/proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_chr
for chr in {1..22} ; do
grep -v "position" ${GENETIC_MAP}${chr}_combined_b37.txt > tmp_${chr}
n_var=$(wc -l tmp_${chr} | cut -f1 -d" ")
cut -f1 -d" " tmp_${chr} | tr "\n" "\t" | sed 's/[\t]$//' > line2
echo -e "\n" >> line2
cut -f3 -d" " tmp_${chr} | tr "\n" "\t" > line3
echo ":sites:${n_var}" > line1
cat line1 line2 line3 > rates.${chr}
rm line1 line2 line3 tmp_${chr}
done
#Then: open the files with nano and remove the empty line.

#sample.names
cut -f1-3 -d" " ../haps_sample_files/*fam > sample.names #not sure this is the way to go, but likely this was the place with the Baka issue.

###
###Test MOSAIC (in particular the Lozi!!)
###
cd /proj/snic2020-2-10/uppstore2018150/private/scripts/bashout/MOSAIC
for pop in Lozi; do
i=3
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 18:22
exit 0") | sbatch -p node -C fat -t 12:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done
#Done. I decided to submit chr1-22 to check that I removed the right individuals. Two-way admixture should be enough.

cd /proj/snic2020-2-10/uppstore2018150/private/scripts/bashout/MOSAIC/December2020
for pop in Lozi; do
i=2
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22
exit 0") | sbatch -p node -C fat -t 24:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

#20201229
cd /proj/snic2020-2-10/uppstore2018150/private/scripts/bashout/MOSAIC/December2020

##2-way
###Trying with fat cores for Kafue and Bangweulu, 10 cores for Bemba and Tonga (it was overbooked for the Lozi).
#Edit 20210107: I am not sure of what I did. I think they all ran with 20 cores. Well, too bad.
for pop in Bangweulu Bemba Kafue Tonga; do
i=2
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 20
exit 0") | sbatch -p node -C fat -t 24:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

#EDIT DO NOT use the code below! Replace "node" by "core".
#for pop in Bemba Tonga; do
#i=2
#(echo '#!/bin/bash -l'
#echo "
#module load bioinfo-tools R/3.6.1
#cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
#Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 10
#exit 0") | sbatch -p node -n 10 -t 12:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
#done

##3-way
#Edit 20210108: I submitted the five Zambian populations on 10 cores, only Tonga succeeded -> requiring a fat node now.
#Edit 20210111: done!
for pop in Bangweulu Bemba Kafue Lozi; do
i=3
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 10
exit 0") | sbatch -p node -C fat -t 48:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

##
##TODO submit (not all at once to avoid over-burdening the cluster):
##
##2-ways for additional populations
for pop in BakaC Nzime SEBantu Xun Khomani Karretjie; do
i=2
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 10
exit 0") | sbatch -p core -n 10 -t 48:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done
#Submitted - will start after the maintenance window. Out_of_memory for Xun and Karrejtie already. I am cancelling the rest and submitting on a fat node instead, with the script using scratch.

#for pop in BakaC Nzime SEBantu Karretjie Khomani Xun; do
for pop in Khomani Xun; do
i=2
chr=22
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:${chr} -m 20"
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/FREQS/
exit 0') | sbatch -p node -C fat -t 24:0:0 -A snic2018-8-397 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

##3-ways supervised
#Submitted.
for pop in Bangweulu Kafue; do
i=3
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -p \"Yoruba BakaC Juhoansi\" -m 8
exit 0") | sbatch -p core -n 8 -t 10:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i}_subset -o MOSAIC_${pop}_${i}_subset.output -e MOSAIC_${pop}_${i}_subset.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

for pop in Bemba Lozi Tonga; do
i=3
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -p \"Yoruba BakaC Juhoansi\" -m 4
exit 0") | sbatch -p core -n 4 -t 16:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i}_subset -o MOSAIC_${pop}_${i}_subset.output -e MOSAIC_${pop}_${i}_subset.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

##4-ways supervised
#Submitted.
for pop in Bangweulu Kafue; do
i=4
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -p \"Yoruba BakaC Juhoansi Amhara\" -m 8
exit 0") | sbatch -p core -n 8 -t 15:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i}_subset4 -o MOSAIC_${pop}_${i}_subset4.output -e MOSAIC_${pop}_${i}_subset4.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

for pop in Bemba Lozi Tonga; do
i=4
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -p \"Yoruba BakaC Juhoansi Amhara\" -m 4
exit 0") | sbatch -p core -n 4 -t 16:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i}_subset4 -o MOSAIC_${pop}_${i}_subset4.output -e MOSAIC_${pop}_${i}_subset4.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

#2-way supervised for the KS and KS-neigbors
#Submitted.
for pop in SEBantu Karretjie Khomani Xun; do
i=2
(echo '#!/bin/bash -l
module load bioinfo-tools R/3.6.1
cd $SNIC_TMP/
cp -r /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/INPUT/ .
cp /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R . '
echo "Rscript mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 4 -p \"Yoruba Juhoansi\" "
echo '
cp $SNIC_TMP/MOSAIC_RESULTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/MOSAIC_RESULTS/
cp $SNIC_TMP/MOSAIC_PLOTS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/MOSAIC_PLOTS/
cp $SNIC_TMP/FREQS/* /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/FREQS/
exit 0') | sbatch -p core -n 4 -t 12:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i}_subset2 -o MOSAIC_${pop}_${i}_subset2.output -e MOSAIC_${pop}_${i}_subset2.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done

##4-ways unsupervised (is that really necessary?)
for pop in Bangweulu Kafue; do
i=4
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/
Rscript /proj/snic2020-2-10/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 20
exit 0") | sbatch -p node -C fat -t 48:0:0 -A snic2019-8-157 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done



