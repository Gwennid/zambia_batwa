#20210128
#Gwenna Breton
#Goal: repeat the X to autosome ancestry ratio procedure with only the Zambian+Omni2.5 individuals.

interactive -p core -n 1 -A snic2018-8-397 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021

#File before merge with Omni1: zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4

#Remove the fake individual and the CEU and CHB
root=zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4
head -1 fake_ex | cat CEU_CHB - > fake_ex_and_CEU_CHB
plink --bfile ${root} --remove fake_ex_and_CEU_CHB --make-bed --out ${root}fexAfr #326 people.

#LD filtering
root=zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4fexAfr
plink --bfile ${root} --indep-pairwise 50 10 0.4 --out ${root}_LD50-10-0.4
plink --bfile ${root} --extract ${root}_LD50-10-0.4.prune.in --make-bed --out ${root}_LD50-10-0.4
##Number of variants on the X chromosome: 10618.

#Cut the autosomes to 180cM.
root=zbatwa8_zbantu8_Schlebusch7_KGP8_
suffix=_4fexAfr_LD50-10-0.4
plink --bfile ${root}1-23${suffix} --chr 1 --to-bp 162713074 --make-bed --out ${root}1-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 2 --to-bp 163722422 --make-bed --out ${root}2-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 3 --to-bp 170771908 --make-bed --out ${root}3-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 4 --to-bp 170766662 --make-bed --out ${root}4-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 5 --to-bp 167649294 --make-bed --out ${root}5-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 6 --to-bp 162170141 --make-bed --out ${root}6-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 7 --to-bp 154669744 --make-bed --out ${root}7-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 8 --make-bed --out ${root}8-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 9 --make-bed --out ${root}9-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 10 --make-bed --out ${root}10-180cM${suffix} #
plink --bfile ${root}1-23${suffix} --chr 12 --make-bed --out ${root}12-180cM${suffix} #

#Prepare a hundred sets of variants (this goes extremely fast).
#list_autosomes is a file with a row with the name of each of chr1-10 and 12.
mkdir 20210128_100sets_Omni2.5
root=zbatwa8_zbantu8_Schlebusch7_KGP8_
suffix=_4fexAfr_LD50-10-0.4
nX=10618 #TODO update
for i in {1..100}; do
	chr=$(shuf -n 1 -r < list_autosomes)
	shuf -n ${nX} ${root}${chr}-180cM${suffix}.bim > 20210128_100sets_Omni2.5/set${i}_chr${chr}
	plink --bfile ${root}${chr}-180cM${suffix} --extract 20210128_100sets_Omni2.5/set${i}_chr${chr} --make-bed --out 20210128_100sets_Omni2.5/set${i}_chr${chr}
done

#Prepare the X chromosome (impute sex).
root=zbatwa8_zbantu8_Schlebusch7_KGP8_
suffix=_4fexAfr_LD50-10-0.4
##Have a look at the distribution.
plink --bfile ${root}1-23${suffix} --check-sex --out ${root}1-23${suffix}
grep PROBLEM ${root}1-23${suffix}.sexcheck |less
R
data <- read.table(file="zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4fexAfr_LD50-10-0.4.sexcheck",header=TRUE)
plot(data$F)
abline(h=0.5,col="red")
abline(h=0.4,col="blue")
abline(h=0.8,col="green")
q()
n
#There is one cluster for males, females are more dispersed (but all below 0.5). There is one male that is somewhat detached from the male cluster (but still higher than 0.8): SEBantu KSP185. It was imputed as male in the Omni1 fileset so I trust that result.
##Impute.
plink --bfile ${root}1-23${suffix} --impute-sex 0.5 0.8 --make-bed --out ${root}1-23${suffix}_sex #212 males, 114 females.
plink --bfile ${root}1-23${suffix}_sex --chr 23 --mind 0.1 --make-bed --out ${root}23${suffix}_sex
plink --bfile ${root}23${suffix}_sex --set-hh-missing --make-bed --out ${root}23${suffix}_sex2

#Prepare the .pop (same for all sets).
cut -d" " -f1 ${root}23${suffix}_sex2.fam | sed 's/Baka_Cam/-/g' | sed 's/Baka_Gab/-/g' | sed 's/Bakiga/-/g' |sed 's/Bangweulu/-/g' |sed 's/Batwa/-/g' | sed 's/Bongo_GabE/-/g' |sed 's/Bongo_GabS/-/g' |sed 's/CEU/-/g' | sed 's/CHB/-/g' |sed 's/GuiGhanaKgal/-/g' |sed 's/Juhoansi/Juhoansi/g' |sed 's/Kafue/-/g' |sed 's/Karretjie/-/g' |sed 's/Khomani/-/g' |sed 's/Khwe/-/g' |sed 's/LWK/-/g' | sed 's/MKK/-/g'  | sed 's/Nama/-/g' |sed 's/Nzebi_Gab/-/g' |sed 's/Nzime_Cam/-/g' |sed 's/SEBantu/-/g' |sed 's/SWBantu/-/g' |sed 's/Xun/-/g' |sed 's/YRI/Yoruba/g' |sed 's/Zambia_Bemba/-/g' |sed 's/Zambia_Lozi/-/g' |sed 's/Zambia_TongaZam/-/g' > ${root}1-23${suffix}.pop

#Run ADMIXTURE for the first autosomal set to check that everything works fine and in particular that there is a single mode.
root=zbatwa8_zbantu8_Schlebusch7_KGP8_
suffix=_4fexAfr_LD50-10-0.4
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/20210128_100sets_Omni2.5

module load bioinfo-tools ADMIXTURE/1.3.0
#mkdir /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210128_Omni2.5_K2_Juhoansi_Yoruba
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210128_Omni2.5_K2_Juhoansi_Yoruba
k=2
j="100_chr12" #TODO write coordinates of a set.
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/${root}1-23${suffix}.pop ${folder}/set${j}.pop #TODO check that the .pop file is really where I think it is.
for i in {1..25}; do
mkdir ad_set${j}_${k}_${i}
cd ad_set${j}_${k}_${i}
admixture ${folder}/set${j}.bed $k -s $RANDOM --supervised
mv set${j}.${k}.Q ../set${j}.${k}.Q.${i}
mv set${j}.${k}.P ../set${j}.${k}.P.${i}
cd ../
rm -R ad_set${j}_${k}_${i}
done

#Run pong.
mkdir /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210128_Omni2.5_K2_Juhoansi_Yoruba/pong
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210128_Omni2.5_K2_Juhoansi_Yoruba/pong

##Prepare ind2pop.txt and poporder.txt
cut -d ' ' -f1 ../../../${root}23${suffix}_sex2.fam > ind2pop.txt
cp ind2pop.txt tmp1; bash ../../../../../scripts/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 ind2pop_newnames.txt ; rm tmp1

cut -f1 ind2pop_newnames.txt |sort |uniq > poporder.txt #Modified manually and renamed to: poporder2Omni2.5.txt

##Prepare files for the first set.
mkdir adm_Qs_set${j}_K2_25repeats
for i in {1..25}; do mv ../set${j}.${k}.Q.${i} adm_Qs_set${j}_K2_25repeats ; done
for i in {1..25}; do echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_set${j}_K2_25repeats/set${j}.${k}.Q.${i} ; done >> pong_filemap_set${j}

module load bioinfo-tools pong/1.4.7
pong -m pong_filemap_set${j} -n poporder2Omni2.5.txt -i ind2pop_newnames.txt -v --disable_server -o set${j}
#Yay! One mode!

#Run ADMIXTURE for the 99 remaining autosomal sets.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/log
root=zbatwa8_zbantu8_Schlebusch7_KGP8_
suffix=_4fexAfr_LD50-10-0.4
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/20210128_100sets_Omni2.5
k=2

(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210128_Omni2.5_K2_Juhoansi_Yoruba
k=2
for j in 10_chr1 11_chr12 12_chr10 13_chr5 14_chr5 15_chr7 16_chr12 17_chr6 18_chr10 19_chr3 1_chr1 20_chr6 21_chr2 22_chr9 23_chr9 24_chr6 25_chr9 26_chr9 27_chr6 28_chr3 29_chr2 2_chr2 30_chr1 31_chr2 32_chr3 33_chr6 34_chr7 35_chr4 36_chr3 37_chr9 38_chr7 39_chr12 3_chr9 40_chr8 41_chr8 42_chr1 43_chr3 44_chr10 45_chr1 46_chr3 47_chr12 48_chr10 49_chr3 4_chr3 50_chr5 51_chr12 52_chr5 53_chr12 54_chr8 55_chr6 56_chr4 57_chr4 58_chr8 59_chr1 5_chr5 60_chr7 61_chr9 62_chr6 63_chr6 64_chr2 65_chr4 66_chr4 67_chr3 68_chr3 69_chr8 6_chr9 70_chr8 71_chr10 72_chr2 73_chr9 74_chr9 75_chr9 76_chr8 77_chr3 78_chr4 79_chr4 7_chr12 80_chr7 81_chr6 82_chr7 83_chr1 84_chr9 85_chr4 86_chr2 87_chr12 88_chr7 89_chr3 8_chr8 90_chr1 91_chr3 92_chr6 93_chr1 94_chr10 95_chr6 96_chr5 97_chr10 98_chr5 99_chr2 9_chr12; do
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/${root}1-23${suffix}.pop ${folder}/set\${j}.pop
for i in {1..25}; do
mkdir ad_set\${j}_\${k}_\${i}
cd ad_set\${j}_\${k}_\${i}
admixture ${folder}/set\${j}.bed \$k -s \$RANDOM --supervised
mv set\${j}.\${k}.Q ../set\${j}.\${k}.Q.\${i}
mv set\${j}.\${k}.P ../set\${j}.\${k}.P.\${i}
cd ../
rm -R ad_set\${j}_\${k}_\${i}
done
rm ${folder}/set\${j}.pop
done
exit 0") | sbatch -p core -n 1 -t 8:0:0 -A snic2018-8-397 -J ad_100sets_Omni2.5Afr_${k} -o ad_100sets_Omni2.5Afr_${k}.output -e ad_100sets_Omni2.5Afr_${k}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END
#Submitted.

#Run ADMIXTURE for the X chromosome.
root=zbatwa8_zbantu8_Schlebusch7_KGP8_
suffix=_4fexAfr_LD50-10-0.4_sex2
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/

module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210128_Omni2.5_K2_Juhoansi_Yoruba
k=2
cp ${folder}${root}1-23_4fexAfr_LD50-10-0.4.pop ${folder}${root}23${suffix}.pop
for i in {1..25}; do
mkdir ad_chr23_${k}_${i}
cd ad_chr23_${k}_${i}
admixture ${folder}${root}23${suffix}.bed $k -s $RANDOM --supervised --haploid="male:23"
mv ${root}23${suffix}.${k}.Q ../chr23.${k}.Q.${i}
mv ${root}23${suffix}.${k}.P ../chr23.${k}.P.${i}
cd ../
rm -R ad_chr23_${k}_${i}
done
rm ${folder}${root}23${suffix}.pop

#Get average ancestry fractions for the X chromosome
##Caution! Females should weight double as much like males.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210128_Omni2.5_K2_Juhoansi_Yoruba/pong

##Run pong.
k=2
mkdir adm_Qs_23_K2_25repeats
for i in {1..25}; do mv ../chr23.${k}.Q.${i} adm_Qs_23_K2_25repeats/ ; done
for i in {1..25}; do echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_23_K2_25repeats/chr23.${k}.Q.${i} ; done >> pong_filemap_23
pong -m pong_filemap_23 -n poporder2Omni2.5.txt -i ind2pop_newnames.txt -v --disable_server -o chr23
cat chr23/result_summary.txt
#Yay! One mode!

##Get the ancestry fractions.
#cut -d" " -f1,2,5 ../../../zbatwa8_zbantu8_Schlebusch7_KGP8_23_4fexAfr_LD50-10-0.4_sex2.fam > FID_IID_sex
R
FID_IID_sex <- read.table(file="FID_IID_sex")
names(FID_IID_sex) <- c("FID","IID","sex")
write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file="summary_326ind_chr23_weighted_25runs",append=FALSE,row.names=FALSE,col.names=FALSE)
for (i in 1:25) {
ancestry_frac <- read.table(file=paste("adm_Qs_23_K2_25repeats/chr23.2.Q.",i,sep=""))
write.table(data.frame("chr23",i,FID_IID_sex$FID,FID_IID_sex$IID,ancestry_frac*FID_IID_sex$sex),
file="summary_326ind_chr23_weighted_25runs",append=TRUE,row.names=FALSE,col.names=FALSE)
}

all <- read.table(file="summary_326ind_chr23_weighted_25runs",header=TRUE)
pop <- unique(FID_IID_sex[,1]) #17 populations
write.table(file="avg_chr23_weighted_25iterations_by_pop",t(c("FID","A_1")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	sex <- sum(FID_IID_sex[FID_IID_sex$FID==POP,3])
	write.table(t(c(as.vector(POP),sum(all[all$FID==POP,][,5])/sex/25)),file="avg_chr23_weighted_25iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}
q()
n
#Values are somewhat different, but nothing crazy I think.

#Get average ancestry fractions for the autosomes.
##Run pong.
k=2
#100_chr12
for j in 10_chr1 11_chr12 12_chr10 13_chr5 14_chr5 15_chr7 16_chr12 17_chr6 18_chr10 19_chr3 1_chr1 20_chr6 21_chr2 22_chr9 23_chr9 24_chr6 25_chr9 26_chr9 27_chr6 28_chr3 29_chr2 2_chr2 30_chr1 31_chr2 32_chr3 33_chr6 34_chr7 35_chr4 36_chr3 37_chr9 38_chr7 39_chr12 3_chr9 40_chr8 41_chr8 42_chr1 43_chr3 44_chr10 45_chr1 46_chr3 47_chr12 48_chr10 49_chr3 4_chr3 50_chr5 51_chr12 52_chr5 53_chr12 54_chr8 55_chr6 56_chr4 57_chr4 58_chr8 59_chr1 5_chr5 60_chr7 61_chr9 62_chr6 63_chr6 64_chr2 65_chr4 66_chr4 67_chr3 68_chr3 69_chr8 6_chr9 70_chr8 71_chr10 72_chr2 73_chr9 74_chr9 75_chr9 76_chr8 77_chr3 78_chr4 79_chr4 7_chr12 80_chr7 81_chr6 82_chr7 83_chr1 84_chr9 85_chr4 86_chr2 87_chr12 88_chr7 89_chr3 8_chr8 90_chr1 91_chr3 92_chr6 93_chr1 94_chr10 95_chr6 96_chr5 97_chr10 98_chr5 99_chr2 9_chr12; do
mkdir adm_Qs_${j}_K2_25repeats
for i in {1..25}; do mv ../set${j}.${k}.Q.${i} adm_Qs_${j}_K2_25repeats/ ; done
for i in {1..25}; do echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_${j}_K2_25repeats/set${j}.${k}.Q.${i} ; done >> pong_filemap_${j}
pong -m pong_filemap_${j} -n poporder2Omni2.5.txt -i ind2pop_newnames.txt -v --disable_server -o set${j}
done

###Loop over the pong outputs to see whether one or several modes.
for j in 100_chr12 10_chr1 11_chr12 12_chr10 13_chr5 14_chr5 15_chr7 16_chr12 17_chr6 18_chr10 19_chr3 1_chr1 20_chr6 21_chr2 22_chr9 23_chr9 24_chr6 25_chr9 26_chr9 27_chr6 28_chr3 29_chr2 2_chr2 30_chr1 31_chr2 32_chr3 33_chr6 34_chr7 35_chr4 36_chr3 37_chr9 38_chr7 39_chr12 3_chr9 40_chr8 41_chr8 42_chr1 43_chr3 44_chr10 45_chr1 46_chr3 47_chr12 48_chr10 49_chr3 4_chr3 50_chr5 51_chr12 52_chr5 53_chr12 54_chr8 55_chr6 56_chr4 57_chr4 58_chr8 59_chr1 5_chr5 60_chr7 61_chr9 62_chr6 63_chr6 64_chr2 65_chr4 66_chr4 67_chr3 68_chr3 69_chr8 6_chr9 70_chr8 71_chr10 72_chr2 73_chr9 74_chr9 75_chr9 76_chr8 77_chr3 78_chr4 79_chr4 7_chr12 80_chr7 81_chr6 82_chr7 83_chr1 84_chr9 85_chr4 86_chr2 87_chr12 88_chr7 89_chr3 8_chr8 90_chr1 91_chr3 92_chr6 93_chr1 94_chr10 95_chr6 96_chr5 97_chr10 98_chr5 99_chr2 9_chr12; do
grep "represents 25 runs" set${j}/result_summary.txt
done | wc -l #

##Calculate the ancestry fractions and the average.
R
FID_IID <- read.table(file="FID_IID")
write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file="summary_326ind_2500runs",append=FALSE,row.names=FALSE,col.names=FALSE)
for (set in c("100_chr12","10_chr1","11_chr12","12_chr10","13_chr5","14_chr5","15_chr7","16_chr12","17_chr6","18_chr10","19_chr3","1_chr1","20_chr6","21_chr2","22_chr9",
"23_chr9","24_chr6","25_chr9","26_chr9","27_chr6","28_chr3","29_chr2","2_chr2","30_chr1","31_chr2","32_chr3","33_chr6","34_chr7","35_chr4","36_chr3","37_chr9",
"38_chr7","39_chr12","3_chr9","40_chr8","41_chr8","42_chr1","43_chr3","44_chr10","45_chr1","46_chr3","47_chr12","48_chr10","49_chr3","4_chr3","50_chr5",
"51_chr12","52_chr5","53_chr12","54_chr8","55_chr6","56_chr4","57_chr4","58_chr8","59_chr1","5_chr5","60_chr7","61_chr9","62_chr6","63_chr6","64_chr2",
"65_chr4","66_chr4","67_chr3","68_chr3","69_chr8","6_chr9","70_chr8","71_chr10","72_chr2","73_chr9","74_chr9","75_chr9","76_chr8","77_chr3","78_chr4",
"79_chr4","7_chr12","80_chr7","81_chr6","82_chr7","83_chr1","84_chr9","85_chr4","86_chr2","87_chr12","88_chr7","89_chr3","8_chr8","90_chr1","91_chr3",
"92_chr6","93_chr1","94_chr10","95_chr6","96_chr5","97_chr10","98_chr5","99_chr2","9_chr12")) {
 for (i in 1:25) {
  ancestry_frac <- read.table(file=paste("adm_Qs_",set,"_K2_25repeats/set",set,".2.Q.",i,sep=""))
  write.table(data.frame(set,i,FID_IID,ancestry_frac),file="summary_326ind_2500runs",append=TRUE,row.names=FALSE,col.names=FALSE)
 }
}

all <- read.table(file="summary_326ind_2500runs",header=TRUE)
pop <- unique(FID_IID[,1]) #25 populations
write.table(file="avg_2500iterations_by_pop",t(c("FID","A_1")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,5]))),file="avg_2500iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}
q()
n

#Calculate the ratio.
##I solved by hand the equations 22 and 23 in Goldberg and Rosenberg Genetics 2015 (i.e. what NH used) and ended up with: y=4A-3X and x=3X-2A where y is the male contribution, x is the female contribution, A is the average autosomal ancestry and X is the (weighted) average X chromosome ancestry. I checked that these equations are correct by comparing to NH's Tables S1 and S2.
R
avgX <- read.table(file="avg_chr23_weighted_25iterations_by_pop",header=TRUE)
avgA <- read.table(file="avg_2500iterations_by_pop",header=TRUE)
y <- 4*avgA$A_1 - 3*avgX$A_1
x <- 3*avgX$A_1 - 2*avgA$A_1 
write.table(data.frame(avgX$FID,y,x), col.names=c("FID","male_contribution","female_contribution"),row.names=FALSE, file="male_female_contributions")

write.table(file="Xtoaut_ancestry_ratio_Juhoansi_ancestry",data.frame(avgX$FID,avgX$A_1/avgA$A_1),
col.names=c("FID","ratio"),row.names=FALSE)
#








