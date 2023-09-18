#Gwenna Breton
#started 20181012
#based on pilot_study_20181012.sh. Commented commands are copied from the initial script and are not repeated here.
#20181023: the "Ethiopians" Gurdasani samples (Oromo, Amhara and Somali) were misattributed. I will rerun all steps containing these samples.

### The raw data we are going to use (at least for the pilot study) is here:
/proj/uppstore2018150/private/raw_data/QJ-1609/QJ-1609_180704_ResultReport/QJ-1609_180704_PLINK_PCF_FWD

#I made a no write copy here: /proj/uppstore2018150/private/raw_data/QJ-1609_BU

#Carina told me to use the FORWARD/REVERSE system

###
interactive -p core -n 1 -A snic2017-1-572 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9
cd /proj/uppstore2018150/private/process/preparedata
###

###
### Prepare the Zambian data
###

#cp /proj/uppstore2018150/private/raw_data/QJ-1609/QJ-1609_180704_ResultReport/QJ-1609_180704_PLINK_PCF_FWD/* .

#plink --file QJ-1609_180704_PLINK_PCF_FWD --make-bed --out QJ-1609_180704_PLINK_PCF_FWD
#plink --bfile QJ-1609_180704_PLINK_PCF_FWD --missing --out QJ-1609_180704_PLINK_PCF_FWD
#most individuals have low missingness, except:
#B-26          Y   217379  2264808  0.09598
#K-12          Y   873890  2264808   0.3859

###Exclude the 13 samples which belong to another study
#grep HSQ QJ-1609_180704_PLINK_PCF_FWD.fam > HSQsamples
#plink --bfile QJ-1609_180704_PLINK_PCF_FWD --remove HSQsamples --make-bed --out zbatwa1

###Create fake individual using this file: /proj/uppstore2018150/private/raw_data/QJ-1609/QJ-1609_180704_ResultReport/H3Africa_2017_20021485_A2.csv
#cd /proj/uppstore2018150/private/process/preparedata/fakeind
#file=/proj/uppstore2018150/private/raw_data/QJ-1609/QJ-1609_180704_ResultReport/H3Africa_2017_20021485_A2.csv
#head -n -23 ${file} > H3Africa_2017_20021485_A2.csv_truncated #keep all but the last 23 lines
#cut -d"," -f2,4 H3Africa_2017_20021485_A2.csv_truncated | sed "s/\,/\t/g" | sed "s/\[//g"| sed "s/\]//g" | sed -e '1,8d' | sed "s/\//\t/g" | sed "s/^/fakeInd\tfakeInd\t/g" >fakeInd.lgen
##col2: name of SNP, col4: alleles
##sed -e '1,8d' is to remove the first 8 lines

##cut column 2 (name of SNP), delete first 8 lines (info) and replace comma with tab 
#cut -d"," -f2 H3Africa_2017_20021485_A2.csv_truncated | sed -e '1,8d' | sed "s/\,/\t/g" > snp
##same as above for col 10 (=the chromosome)
#cut -d"," -f10 H3Africa_2017_20021485_A2.csv_truncated | sed -e '1,8d' | sed "s/\,/\t/g" > chr
##replace MT by 26, X by 23, Y by 24, XY by 25 so that it corresponds to what is in zbatwa1.bim
#sed 's/XY/25/g' < chr | sed 's/X/23/g' | sed 's/Y/24/g' |  sed 's/MT/26/g' > chr_new
##same as above for col 11 (position) and then replace start of line with 0 and tab
#cut -d"," -f11 H3Africa_2017_20021485_A2.csv_truncated | sed -e '1,8d' | sed "s/\,/\t/g" | sed "s/^/0\t/g" > pos
##paste all columns above together to make a map file for the lgen file
#paste chr_new snp pos > fakeInd.map

##made a fam file (manually)
#fakeInd fakeInd 0 0 0 -9

##now read lgen, fam and map files into plink and put fake sample out in bed format
#plink --lfile fakeInd --make-bed --out fakeInd

##merge data to fake, flip your alleles in fake sample to match your input file and merge again
#cd /proj/uppstore2018150/private/process/preparedata
#plink --bfile zbatwa1 --bmerge fakeind/fakeInd.bed fakeind/fakeInd.bim fakeind/fakeInd.fam --make-bed --out zbatwa1f
#plink --bfile fakeind/fakeInd --flip zbatwa1f-merge.missnp  --make-bed --out fakeind/fakeIndf 
#plink --bfile zbatwa1 --bmerge fakeind/fakeIndf.bed fakeind/fakeIndf.bim fakeind/fakeIndf.fam --make-bed --out zbatwa1f

##exclude 0 and sex chr (45,925 variants)
#rm exlist; touch exlist
#grep -P "^0\t" zbatwa1.bim >> exlist
#grep -P "^23\t" zbatwa1.bim >> exlist #X
#grep -P "^24\t" zbatwa1.bim >> exlist #Y
#grep -P "^25\t" zbatwa1.bim >> exlist #XY
#grep -P "^26\t" zbatwa1.bim >> exlist #MT

#plink --bfile zbatwa1f --exclude exlist --make-bed --out zbatwa2 #2,221,421 remain.

##exclude indels
#rm indellist; touch indellist
#grep -P "\tI" zbatwa2.bim >> indellist
#grep -P  "\tD" zbatwa2.bim >> indellist
##comment: the same 407 positions come up
#plink --bfile zbatwa2 --exclude indellist --make-bed --out zbatwa3
##407 variants excluded; 2221014 remain

##do snp missingness filer
#plink --bfile zbatwa3 --geno 0.1 --make-bed --out zbatwa4

#do hwe filter
#One fileset for each population
grep B zbatwa4.fam > Bangweulu
grep K zbatwa4.fam > Kafue
plink --bfile zbatwa4 --keep Bangweulu --make-bed --out zbatwa4B
plink --bfile zbatwa4 --keep Kafue --make-bed --out zbatwa4K
#HWE in each fileset
plink --bfile zbatwa4B --hwe 0.001 --make-bed --out zbatwa4Bhwe #1284 excl
plink --bfile zbatwa4K --hwe 0.001 --make-bed --out zbatwa4Khwe #1154 excl
#I got a warning for both because "--hwe observation counts vary by more than 10%"
#Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
cut -f2 zbatwa4Bhwe.bim > zbatwa4Bhwe_variants
plink --bfile zbatwa4 --exclude zbatwa4Bhwe_variants --make-bed --out zbatwa4Bhweexcl
cut -f2 zbatwa4Khwe.bim > zbatwa4Khwe_variants
plink --bfile zbatwa4 --exclude zbatwa4Khwe_variants --make-bed --out zbatwa4Khweexcl
#Find overlap between zbatwa4Bhweexcl.bim and zbatwa4Khweexcl.bim
cut -f2 zbatwa4Khweexcl.bim > zbatwa4Khweexcl_variants
plink --bfile zbatwa4Bhweexcl --extract zbatwa4Khweexcl_variants --make-bed --out zbatwa4Bhweexcl-extractzbatwa4Khweexcl #205 variants
#do the reverse to check that we get the same
cut -f2 zbatwa4Bhweexcl.bim > zbatwa4Bhweexcl_variants
plink --bfile zbatwa4Khweexcl --extract zbatwa4Bhweexcl_variants --make-bed --out zbatwa4Khweexcl-extractzbatwa4Bhweexcl  #205 variants
#Finally, exclude these SNP
cut -f2 zbatwa4Bhweexcl-extractzbatwa4Khweexcl.bim > zbatwa4Bhweexcl-extractzbatwa4Khweexcl_variants
plink --bfile zbatwa4 --exclude zbatwa4Bhweexcl-extractzbatwa4Khweexcl_variants --make-bed --out zbatwa5

#Comment: from that point on I need to rerun all commands as "zbatwa5" has changed (I did a more straightforward HWE filter before)

#do ind missingness filter
plink --bfile zbatwa5 --mind 0.1 --make-bed --out zbatwa6
#one individual is removed (K-12)

#make bimfiles with same snp names
#replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
infile="zbatwa6"
#cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim

#remove duplicate snps
#some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
#create col two containing dupl SNPs
cut -f2 ${infile}.bim | sort > with_dup
#create a col 2 containg no dupl SNPs using the uniq function
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
#use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
comm -23 with_dup wo_dup > dupl
plink --bfile zbatwa6 --exclude dupl --make-bed --out zbatwa7 

#look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
plink --bfile zbatwa7 --missing --out zbatwa7
sed  "s/ \+/\t/g" zbatwa7.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: B-26 0.09139; 2nd highest: B-23 0.01955

#exclude fake before IBD filtering
grep fake zbatwa7.fam > fake_ex
plink --bfile zbatwa7 --remove fake_ex --make-bed --out zbatwa7_fex 

###Relatedness filtering.
#with king
/proj/uppstore2017249/DATA/king -b zbatwa7_fex.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/zbatwa7_fex #outputs are kin and kin0 but kin is empty -> I removed it
#Close relatives can be inferred fairly reliably based on the estimated kinship coefficients as shown in the following simple algorithm: an estimated kinship coefficient range >0.354, [0.177, 0.354], [0.0884, 0.177] and [0.0442, 0.0884] corresponds to duplicate/MZ twin, 1st-degree, 2nd-degree, and 3rd-degree relationships respectively.
#look at that one: zbatwa7_fex.kin0

R
data <- read.table("zbatwa7_fex.kin0",header=TRUE)
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="zbatwa7_fex_3degreerel")
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="zbatwa7_fex_2degreerel")
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="zbatwa7_fex_1degreerel")

#5 pairs of first degree relatives
#8 pairs of second degree relatives
#15 pairs of third degree relatives	

#with plink
#comment: normally I do LD pruning before using genome!
plink --bfile zbatwa7_fex --genome --out zbatwa7_fex

#sort genome file to look at highest PiHAT
sed  "s/ \+/\t/g" zbatwa7_fex.genome | sed  "s/^\t//g" | sort -k10 > zbatwa7_fex_genome_sorted

R
data <- read.table(file="zbatwa7_fex.genome",header=TRUE)
png("zbatwa7_fex_IBD.png",height=480,width=1500, units="px",pointsize=16)
par(mfrow=c(1,3))
plot(data$Z0,data$Z1,pch=20,xlab="P(IBD=0)",ylab="P(IBD=1)",xlim=c(0,1),ylim=c(0,1))
plot(data$Z1,data$Z2,pch=20,xlab="P(IBD=1)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
plot(data$Z0,data$Z2,pch=20,xlab="P(IBD=0)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
dev.off()
q()
n

##Usually Carina would exclude the first and second degree relatives. If it seems that the third degree relatives are perturbating the analyses we might need to exclude them as well.
##We expect high inbreeding in these populations. So it might be more relevant to look at outliers in IBD (rather than strong cutoffs).

### Choose which individuals to remove due to relatedness (first and second degree relatives, I decided which pairs based on the comparison of the results of king and the plots of IBS in plink)

### Comment 20181012: I did not go through the analyses steps as I found the same pairs of related individuals like before.

##Population B##
#in that population there is no overlap between the 4 pairs so I decided which to exclude based on missingness. Another possible criteria would have been to try to get an equal sex ratio in the sample.

##Pairs of PO

#B-05 and B-23
grep "B-05" zbatwa7.imiss  # 0.001184
grep "B-23" zbatwa7.imiss # 0.01954
#Keep B-05

##Pairs of FS

#B-02: 0.001179 and B-24: 0.001467 -> keep B-02

##HS or other second degree relatives

#B-06: 0.001056 and B-10: 0.001185 -> keep B-06
#B-26: 0.09139 and B-25: 0.00135 -> keep B-25

##Population K##
#In this population there is overlap between some pairs. Also there are more pairs of related samples (2 PO, 1 FS, 6 2nd degree)

##Pairs of PO

#K-15 K-37 -> keep K-37 because K-15 is in another pair as well. And K-15 has higher missingness!
#K-06: 0.00105 and K-30: 0.001111 -> keep K-06

##Pairs of FS

#K-22: 0.001426 K-28: 0.001013 -> there is a relationship triangle with K-21: 0.001508: both K-22 and K-28 are 2nd degree relatives of K-21. Based on missingness -> keep K-28.

##2nd degree

#K-09 K-26 -> keep K-26 because K-09 is in another pair. And K-26 as lower missingness!
#K-09 K-31 -> keep K-31 because K-09 is in another pair. And K-31 as lower missingness!
#K-15 K-40 -> keep K-40 because K-15 is in another pair. In that case K-40 has slightly higher missingness.
#K-21 K-22 see above
#K-21 K-28 see above
#K-25: 0.001017 K-36: 0.001038 -> keep K-25

###Create a list of samples to exclude
for ind in B-23 B-24 B-10 B-26 K-15 K-30 K-21 K-22 K-09 K-36; do grep ${ind} zbatwa7.fam >> related_ex; done

###Exclude related samples
plink --bfile zbatwa7 --remove related_ex --make-bed --out zbatwa8

#before doing more analysis, rerun king on the dataset from which I removed related individuals!!!
#exclude the fake individual
plink --bfile zbatwa8 --remove fake_ex --make-bed --out zbatwa8_fex
/proj/uppstore2017249/DATA/king -b zbatwa8_fex.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/zbatwa8_fex 
R
data <- read.table("zbatwa8_fex.kin0",header=TRUE)
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="zbatwa8_fex_3degreerel") #six pairs in population B, 5 pairs in population K
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="zbatwa8_fex_2degreerel") #none
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="zbatwa8_fex_1degreerel") #none
q()
n
#it worked :)

#make new famfile with group name in first column
#in our case the name must be made from scratch!
cat zbatwa8.fam | cut -d" " -f2 | cut -d"-" -f1 | sed 's/B/Bangweulu/g' | sed 's/K/Kafue/g' > firstcol
cut -d" " -f2- zbatwa8.fam >last
paste firstcol last | sed "s/\t/ /g" >both
cp zbatwa8.fam zbatwa8.famold
cp both zbatwa8.fam

##exclude ATCG SNPs to prevent strand errors while flipping
#exclude ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" zbatwa8.bim >> ATCGlist
grep -P "\tT\tA" zbatwa8.bim >> ATCGlist
grep -P "\tC\tG" zbatwa8.bim >> ATCGlist
grep -P "\tG\tC" zbatwa8.bim >> ATCGlist
plink --bfile zbatwa8 --exclude ATCGlist --make-bed --out zbatwa9

#remove fake individual for preliminary analyses of the Zambian samples alone
plink --bfile zbatwa9 --remove fake_ex --make-bed --out zbatwa9_fex
plink --bfile zbatwa9_fex --genome --out zbatwa9_fex

#MDS matrix based on allele sharing distances
plink --bfile zbatwa9_fex --recode --transpose --out zbatwa9_fex

(echo '#!/bin/bash -l'
echo "
cd cd /proj/uppstore2018150/private/process/preparedata
/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_fex.tped --tfam zbatwa9_fex.tfam --out zbatwa9_fex
exit 0" )  | sbatch -p core -n 1 -t 4:0:0 -A snic2017-1-572 -J ASD_zbatwa9_fex -o ASD_zbatwa9_fex.output -e ASD_zbatwa9_fex.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL

#TODO plot it
R
data <- read.table(file="zbatwa9_fex.asd.dist",header=TRUE)
fam <- read.table(file="zbatwa9_fex.fam")
data.mds<-cmdscale(data)
pdf(file="zbatwa9_fex.asd.dist.MDSplot.pdf", width=10, height=15, pointsize=12)
plot(data.mds,col=as.factor(fam$V1),pch=20,asp=1,xlab=c(""),ylab=c(""),cex=2)
title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
legend("bottomright",legend=unique(fam$V1),pch=20,col=as.factor(unique(fam$V1)))
dev.off()
#the two populations are distinguishable. The Bangweulu population is more dispersed.
#TODO update the plots on my local computer as well!


###
### Merge with Omni2.5 datasets
###

# Comments: there are some pre-processing steps before merging. That is included in this section as well.
#I have to prepare the data first. The data in /proj/uppstore2017249/DATA/ has been filtered for --geno 0.05 (in the _Filtered folders that is). I think it is filtered for relatedness but I will check nevertheless. Fix the variants names as well (to chr-position).
# Also: downsample populations to 36 individuals (the max in my dataset).

### Schlebusch 2012
##keep all samples
##the .kin0 file shows no related sample
##the names of the SNP are already fine! :)
#cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Schlebusch_2012/
#cp -r /proj/uppstore2017249/DATA/Schlebusch_2012/Schlebusch_2012_Filtered/ .
##the SNP already have the right name.
##geno 0.05 filter
##related samples removed
##check duplicate SNPs
#infile="Schlebusch_2012"
#cut -f2 ${infile}.bim | sort > with_dup
##create a col 2 containg no dupl SNPs using the uniq function
#cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
##use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
#comm -23 with_dup wo_dup > dupl #none
#rm dupl with_dup wo_dup

#relatedness
/proj/uppstore2017249/DATA/king -b Schlebusch_2012_Filtered/Schlebusch_2012.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012

R
data <- read.table("Schlebusch_2012.kin0",header=TRUE) #accross families
summary(data)
#the highest kinship coefficient is 0.0112
data <- read.table("Schlebusch_2012.kin",header=TRUE) #within families
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Schlebusch_2012.3degreerel") #7
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Schlebusch_2012.2degreerel") #1 pair in the GuiGhanaKgal: KSP096 and KSP226
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Schlebusch_2012.1degreerel") #0
q()
n

#TODO if I remerge: remove one of KSP096 and KSP226 (see above)

### 1KGP2015
# Here I want to keep 36 of the following populations: non African: CEU, CHB; African: YRI LWK MKK

# Previously I used the fileset prepared by Mario ( /proj/uppstore2017249/DATA/1KGP_2015/G1000MV_shufdupl ) but this caused issues because I did not realize it was phased data [or maybe not phased but at least duplicated] and thus I took "half" individuals. Moreover I thought it has 60 ind / pop while in reality it has 30 by pop!
# I have 2 options: use the original fileset [I think it is original] which has 2000+ individuals -and possibly run into issues with related samples - or use the phased + related excl that has 1666 individuals - but then I have to understand how to "unphase" it.
# I'd rather use the unphased - start and see!

cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/1KGP_2015
cp  /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_final_onlyAutosomal.* .

#Select only the individuals from the following populations: CEU, CHB, YRI, LWK, MKK
grep -e CEU -e CHB -e YRI -e LWK -e MKK 1000Genomes_final_onlyAutosomal.fam > CEU_CHB_YRI_LWK_MKK #496 individuals
plink --bfile 1000Genomes_final_onlyAutosomal --keep CEU_CHB_YRI_LWK_MKK --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK

#snp and ind missingness
plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK --geno 0.1 --mind 0.1 --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_2 # all ind passed. 1922 SNP removed.

#replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
infile="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_2"
#cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim

#remove duplicate snps
#some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
#create col two containing dupl SNPs
cut -f2 ${infile}.bim | sort > with_dup
#create a col 2 containg no dupl SNPs using the uniq function
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
#use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
comm -23 with_dup wo_dup > dupl #6995
plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_2 --exclude dupl --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3 

#relatedness
/proj/uppstore2017249/DATA/king -b 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3

R
data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.kin0",header=TRUE) #accross families
summary(data)
#the highest kinship coefficient is 0.0019
data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.kin",header=TRUE) #within families
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.3degreerel") #14
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.2degreerel") #10
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.1degreerel") #113!
q()
n

#Error: 1 because I have a difference between the estimated and specified (here = none) kinship coefficients

for POP in CEU CHB YRI MKK LWK; do grep ${POP} 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.1degreerel > 1and2degreerel_${POP}; grep ${POP} 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.2degreerel >> 1and2degreerel_${POP}; done
#101 pairs in the YRI!!!!! (from a total of 161 samples) (in the /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_phased_duplicated_RelExcl_IBSexcl.tfam there are 196 YRI entries i.e. 98 YRI samples...)

#This time I am not trying to maximize the number of samples I keep so I can simply remove all individuals found in at least one pair.
#not going to work for the YRI though because that way I keep only 6 samples...
#I could keep the ones kept in /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_phased_duplicated_RelExcl_IBSexcl.tfam

grep -e CEU -e CHB -e YRI -e LWK -e MKK /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_phased_duplicated_RelExcl_IBSexcl.tfam > 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK
sed 's/_A//g' 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK | sed 's/_B//g' | sort | uniq > 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK_uniq

#Extract these from the dataset and run KING again
plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3 --keep 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK_uniq --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4

/proj/uppstore2017249/DATA/king -b 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4

R
data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.kin0",header=TRUE) #accross families
summary(data)
#the highest kinship coefficient is 0.0017
data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.kin",header=TRUE) #within families
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.3degreerel") #8
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.2degreerel") #2
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.1degreerel") #0
q()
n

#The two pairs of second degree relatives are from the MKK. I will remove the one with highest missingness from each pair.
plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4 --missing --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4
grep -e NA21386 -e NA21389 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.imiss #remove NA21386
grep -e NA21477 -e NA21490 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.imiss #remove NA21477
grep -e NA21386 -e NA21477 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.fam > excl_MKK
plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4 --remove excl_MKK --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5

#Remaining number of samples by pop: CEU 95, CHB 100, LWK 77, MKK 29, YRI 98. So I need to downsample all except the MKK.

#Downsample
rm randommax36bypop
R
data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5.fam",header=FALSE)
#CEU
CEU <- subset(data[data$V1=="CEU",])
max <- nrow(CEU)
x <- sort(sample(1:max,36,replace=F))
write.table(CEU[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#CHB
CHB <- subset(data[data$V1=="CHB",])
max <- nrow(CHB)
x <- sort(sample(1:max,36,replace=F))
write.table(CHB[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#LWK
LWK <- subset(data[data$V1=="LWK",])
max <- nrow(LWK)
x <- sort(sample(1:max,36,replace=F))
write.table(LWK[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#YRI
YRI <- subset(data[data$V1=="YRI",])
max <- nrow(YRI)
x <- sort(sample(1:max,36,replace=F))
write.table(YRI[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
q()
n
grep MKK 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5.fam >> randommax36bypop #173 samples

#Extract those
plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5 --keep randommax36bypop --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6

#flip ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
grep -P "\tT\tA" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
grep -P "\tC\tG" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
grep -P "\tG\tC" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6 --exclude ATCGlist --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7

### Gurdasani
/proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Gurdasani_2015
# Amhara, Oromo, Somali, Sotho, Zulu, Igbo, Mandinka
#caution! Amhara Oromo Somali - see in Mario's folder AGVPpoplist
#Sotho: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Sotho/Sotho.bed
#Zulu: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Zulu/Zulu.bed
#Igbo: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Igbo/Igbo.bed
#Mandinka: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Mandinka/Mandinka.bed
#Amhara, Oromo, Somali are here: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Ethiopians/Ethiopians.bed
#but do not use the data in Mario's folder because it is filtered.
cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Gurdasani_2015

##Copy all necessary files
#cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Sotho/Sotho* .
#cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Zulu/Zulu* .
#cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Igbo/Igbo* .
#cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Mandinka/Mandinka* .
#cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Ethiopians/Ethiopians* .
#cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_MarioData/AGVPpoplist .

#Select 36 samples from each population
R
data <- read.table(file="Sotho.fam",header=FALSE)
max <- nrow(data)
x <- sort(sample(1:max,36,replace=F))
write.table(data[x,],file="random36Sotho",append=TRUE,col.names=F,row.names=F,quote=F)
data <- read.table(file="Zulu.fam",header=FALSE)
max <- nrow(data)
x <- sort(sample(1:max,36,replace=F))
write.table(data[x,],file="random36Zulu",append=TRUE,col.names=F,row.names=F,quote=F)
data <- read.table(file="Igbo.fam",header=FALSE)
max <- nrow(data)
x <- sort(sample(1:max,36,replace=F))
write.table(data[x,],file="random36Igbo",append=TRUE,col.names=F,row.names=F,quote=F)
data <- read.table(file="Mandinka.fam",header=FALSE)
max <- nrow(data)
x <- sort(sample(1:max,36,replace=F))
write.table(data[x,],file="random36Mandinka",append=TRUE,col.names=F,row.names=F,quote=F)
#Ethiopians (it is different for these ones)
data <- read.table(file="AGVPpoplist",header=FALSE)
OROMO <- subset(data[data$V3=="OROMO",])
max <- nrow(OROMO) #26 -> keep all
write.table(OROMO[,c(1,3)],file="Oromo26",col.names=F,row.names=F,quote=F)
AMHARA <- subset(data[data$V3=="AMHARA",])
max <- nrow(AMHARA) #42
x <- sort(sample(1:max,36,replace=F))
write.table(AMHARA[x,c(1,3)],file="Amhara36",col.names=F,row.names=F,quote=F)
SOMALI <- subset(data[data$V3=="SOMALI",])
max <- nrow(SOMALI) #39
x <- sort(sample(1:max,36,replace=F))
write.table(SOMALI[x,c(1,3)],file="Somali36",col.names=F,row.names=F,quote=F)
q()
n

plink --bfile Sotho --keep random36Sotho --make-bed --out random36Sotho
plink --bfile Zulu --keep random36Zulu --make-bed --out random36Zulu
plink --bfile Igbo --keep random36Igbo --make-bed --out random36Igbo
plink --bfile Mandinka --keep random36Mandinka --make-bed --out random36Mandinka

#It is a bit different for the Oromo, Amhara and Somali because they are all in the same fileset. I create one plink fileset for each, modify the fam (to include Amhara, Oromo and Somali) and merge.
rm oromo_fam; for i in {1..26}; do echo "Ethiopians" >> oromo_fam; done
paste oromo_fam Oromo26 > EthiopiansOromo26
plink --bfile Ethiopians --keep EthiopiansOromo26 --make-bed --out Oromo26
#Change the .fam so they contain the name of the population instead of "Ethiopians"
mv Oromo26.fam Oromo26.oldfam
cp Oromo26.oldfam tmp
sed 's/Ethiopians/Oromo/g' < tmp > Oromo26.fam

rm Amhara_fam; for i in {1..36}; do echo "Ethiopians" >> Amhara_fam; done
paste Amhara_fam Amhara36 > EthiopiansAmhara36
plink --bfile Ethiopians --keep EthiopiansAmhara36 --make-bed --out Amhara36
#Change the .fam so they contain the name of the population instead of "Ethiopians"
mv Amhara36.fam Amhara36.oldfam
cp Amhara36.oldfam tmp
sed 's/Ethiopians/Amhara/g' < tmp > Amhara36.fam

rm Somali_fam; for i in {1..36}; do echo "Ethiopians" >> Somali_fam; done
paste Somali_fam Somali36 > EthiopiansSomali36
plink --bfile Ethiopians --keep EthiopiansSomali36 --make-bed --out Somali36
#Change the .fam so they contain the name of the population instead of "Ethiopians"
mv Somali36.fam Somali36.oldfam
cp Somali36.oldfam tmp
sed 's/Ethiopians/Somali/g' < tmp > Somali36.fam

plink --bfile Amhara36 --bmerge Oromo26.bed Oromo26.bim Oromo26.fam --make-bed --out Amhara36_Oromo26 #no complaint
plink --bfile Amhara36_Oromo26 --bmerge Somali36.bed Somali36.bim Somali36.fam --make-bed --out Amhara36_Oromo26_Somali36

#Now merge into a single "Gurdasani" fileset
plink --bfile Amhara36_Oromo26_Somali36 --bmerge random36Sotho.bed random36Sotho.bim random36Sotho.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36
plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36 --bmerge random36Igbo.bed random36Igbo.bim random36Igbo.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36
plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36 --bmerge random36Zulu.bed random36Zulu.bim random36Zulu.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36
plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36 --bmerge random36Mandinka.bed random36Mandinka.bim random36Mandinka.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36

#Missingness filtering
plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36 --geno 0.1 --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2 #1794966 variants and 242 people

#Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
infile="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2"
#cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim

#remove duplicate snps
#some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
#create col two containing dupl SNPs
cut -f2 ${infile}.bim | sort > with_dup
#create a col 2 containg no dupl SNPs using the uniq function
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
#use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
comm -23 with_dup wo_dup > dupl #0

#relatedness
/proj/uppstore2017249/DATA/king -b random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2

R
data <- read.table("random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.kin0",header=TRUE) #accross families
summary(data)
#the highest kinship coefficient is 0.01310
data <- read.table("random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.kin",header=TRUE) #within families
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.3degreerel") #0
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.2degreerel") #0
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.1degreerel") #0
q()
n

#no related individuals to filter

#Flip ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
grep -P "\tT\tA" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
grep -P "\tC\tG" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
grep -P "\tG\tC" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2 --exclude ATCGlist --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3 #1770340 variants and 242 people

### Haber
cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Haber_2016
#cp -r /proj/uppstore2017249/DATA/Haber_2016/Haber_2016_Filtered/ .

#Downsample
rm randommax36bypop
R
data <- read.table("Haber_2016_Filtered/Haber_2016.fam",header=FALSE)
#Chad_Sara
Sara <- subset(data[data$V1=="Chad_Sara",])
max <- nrow(Sara)
x <- sort(sample(1:max,36,replace=F))
write.table(Sara[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Chad_Toubou
Toubou <- subset(data[data$V1=="Chad_Toubou",])
max <- nrow(Toubou)
x <- sort(sample(1:max,36,replace=F))
write.table(Toubou[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
q()
n

plink --bfile Haber_2016_Filtered/Haber_2016 --keep randommax36bypop --make-bed --out random_Sara36_Toubou36

#Missingness
plink --bfile random_Sara36_Toubou36 --geno 0.1 --make-bed --out random_Sara36_Toubou36_2

#Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
infile="random_Sara36_Toubou36_2"
#cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim

#remove duplicate snps
#some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
#create col two containing dupl SNPs
cut -f2 ${infile}.bim | sort > with_dup
#create a col 2 containg no dupl SNPs using the uniq function
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
#use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
comm -23 with_dup wo_dup > dupl #0

#relatedness
/proj/uppstore2017249/DATA/king -b random_Sara36_Toubou36_2.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou36_2

R
data <- read.table("random_Sara36_Toubou36_2.kin0",header=TRUE) #accross families
summary(data)
#the highest kinship coefficient is <0
data <- read.table("random_Sara36_Toubou36_2.kin",header=TRUE) #within families
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="random_Sara36_Toubou36_2.3degreerel") #0
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="random_Sara36_Toubou36_2.2degreerel") #1
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="random_Sara36_Toubou36_2.1degreerel") #2
q()
n

cat random_Sara36_Toubou36_2.2degreerel 
#"FID" "ID1" "ID2" "N_SNP" "Z0" "Phi" "HetHet" "IBS0" "Kinship" "Error"
#"1047" "Chad_Toubou" "yemcha6089821" "yemcha6089908" 2219393 1 0 0.089 0.02 0.1176 1
#one pair of second degree relatives and two pairs of third degree relatives. I decided to remove one of the samples in the 2nd degree pair i.e. there will be only 35 samples for the Chad_Toubou. I think that is ok!
plink --bfile random_Sara36_Toubou36_2 --missing --out random_Sara36_Toubou36_2
#highest missingness: Chad_Toubou   yemcha6089908
grep yemcha6089908 random_Sara36_Toubou36_2.fam > excl_related
plink --bfile random_Sara36_Toubou36_2 --remove excl_related --make-bed --out random_Sara36_Toubou35

#Flip ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" random_Sara36_Toubou35.bim >> ATCGlist
grep -P "\tT\tA" random_Sara36_Toubou35.bim >> ATCGlist
grep -P "\tC\tG" random_Sara36_Toubou35.bim >> ATCGlist
grep -P "\tG\tC" random_Sara36_Toubou35.bim >> ATCGlist
plink --bfile random_Sara36_Toubou35 --exclude ATCGlist --make-bed --out random_Sara36_Toubou35_2 #2,164,153 variants and 71 people


#### Now merging!!!!
cd /proj/uppstore2018150/private/process/preparedata

#with Schlebusch2012
plink --bfile zbatwa9 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.fam --make-bed --out zbatwa9_Schlebusch2012 #2816 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012 --flip zbatwa9_Schlebusch2012-merge.missnp --make-bed --out Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012f
plink --bfile zbatwa9 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012f.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012f.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012f.fam --make-bed --out zbatwa9_Schlebusch2012_2 #9 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012f --exclude zbatwa9_Schlebusch2012_2-merge.missnp --make-bed --out Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012fe
plink --bfile zbatwa9 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012fe.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012fe.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012fe.fam --make-bed --out zbatwa9_Schlebusch2012_3 
#missingness filter
plink --bfile zbatwa9_Schlebusch2012_3 --geno 0.1 --make-bed --out zbatwa9_Schlebusch2012_4 #1,489,138 variants and 189 people
plink --bfile zbatwa9_Schlebusch2012_4 --missing --out zbatwa9_Schlebusch2012_4
sed  "s/ \+/\t/g" zbatwa9_Schlebusch2012_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness in the Zambian samples
#comment: now there are two fake individuals

#with 1KGP
plink --bfile zbatwa9_Schlebusch2012_4 --bmerge Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7.bed Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7.bim Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173 #91503 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7 --flip zbatwa9_Schlebusch2012_1KGP173-merge.missnp --make-bed --out Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f
plink --bfile zbatwa9_Schlebusch2012_4 --bmerge Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f.bed Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f.bim Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_2 #85
plink --bfile Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f --exclude zbatwa9_Schlebusch2012_1KGP173_2-merge.missnp --make-bed --out Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe
plink --bfile zbatwa9_Schlebusch2012_4 --bmerge Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe.bed Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe.bim Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_3 #2306985 variants and 362 people
#missingness filter
plink --bfile zbatwa9_Schlebusch2012_1KGP173_3 --geno 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP173_4 #1,482,994 variants and 362 people
plink --bfile zbatwa9_Schlebusch2012_1KGP173_4 --missing --out zbatwa9_Schlebusch2012_1KGP173_4
sed  "s/ \+/\t/g" zbatwa9_Schlebusch2012_1KGP173_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #now the samples with the highest missingness are KGP samples

#with Gurdasani_2015
plink --bfile zbatwa9_Schlebusch2012_1KGP173_4 --bmerge Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3.bed Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3.bim Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242 #74757 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3 --flip zbatwa9_Schlebusch2012_1KGP173_Gurdasani242-merge.missnp --make-bed --out Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f
plink --bfile zbatwa9_Schlebusch2012_1KGP173_4 --bmerge Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f.bed Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f.bim Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_2 #2052244 variants and 604 people
#missingness filter
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_2 --geno 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_3 #1,201,090 variants and 604 people
#QUESTION not a big overlap! Is that normal?
 
#with Haber_2016
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_3 --bmerge Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2.bed Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2.bim Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71 #589303 variants with 3+ alleles present.
plink --bfile Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2 --flip zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71-merge.missnp --make-bed --out Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2f
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_3 --bmerge Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2f.bed Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2f.bim Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou35_2f.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_2 #2188325 variants and 675 people
#Missingness
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_2 --geno 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 #1,176,918 variants and 675 people
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --missing --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3
sed  "s/ \+/\t/g" zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.imiss | sed  "s/^\t//g" | sort -k6 | tail 

####
#### Some analysis before merging with Omni1
####

### Remove fake individuals
grep fake zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fam > zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex --recode --transpose --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex

#run asd:
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.tped --tfam zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.tfam --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2017-1-572 -J mds_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex -o mds_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.output -e mds_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

#run smartpca
root=zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par #Careful! the number of spaces has to be exactly right for sed to recognize it...
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0  -A snic2017-1-572 -J PC_${root} -o PC_${root}.output -e PC_${root}.output

####
#### Merging Omni1
####

#max 36 individuals per population, from Patin_2014
#comment: there are BaTwa and BaKiga in Patin_2014 so I will use those instead of using samples from Perry_2014 as well

mkdir /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/
mkdir /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014
cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014

cp -r /proj/uppstore2017249/DATA/Patin_2014/Patin_2014_Filtered/ .

#I am starting with relatedness filtering
/proj/uppstore2017249/DATA/king -b Patin_2014_Filtered/Patin_2014.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014/Patin_2014_Filtered/Patin_2014

R
data <- read.table("Patin_2014_Filtered/Patin_2014.kin0",header=TRUE) #accross families
summary(data)
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_Filtered/Patin_2014_kin0.3degreerel") #
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_Filtered/Patin_2014_kin0.2degreerel") #
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_Filtered/Patin_2014_kin0.1degreerel") #
#the highest kinship coefficient is 0.0624
data <- read.table("Patin_2014_Filtered/Patin_2014.kin",header=TRUE) #within families
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_Filtered/Patin_2014_kin.3degreerel") #
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_Filtered/Patin_2014_kin.2degreerel") #
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_Filtered/Patin_2014_kin.1degreerel")
q()
n

#remove related samples (1st and 2nd degree relatives)
grep -e Batwa_05 -e Batwa_06 -e Batwa_12 -e Batwa_14 -e Batwa_18 -e Batwa_19 -e Batwa_24 -e Batwa_25 -e Batwa_27 -e Baka_Cam_04 -e Baka_Cam_12 -e Baka_Cam_35 -e Baka_Cam_51 -e Baka_Cam_56 -e Bakiga_05 -e Bakiga_25 -e Bongo_GabE_08 -e Bongo_GabS_01 -e Bongo_GabS_19 -e Nzime_Cam_15 -e Nzime_Cam_33 -e Nzime_Cam_41 Patin_2014_Filtered/Patin_2014.fam > Patin_2014_related
plink --bfile Patin_2014_Filtered/Patin_2014 --remove Patin_2014_related --make-bed --out Patin_2014_unrelated #238 remaining out of 260

#Check relatedness
/proj/uppstore2017249/DATA/king -b Patin_2014_unrelated.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014/Patin_2014_unrelated

R
data <- read.table("Patin_2014_unrelated.kin0",header=TRUE) #accross families
summary(data) #max 0.06240
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_unrelated_kin0.3degreerel") #
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_unrelated_kin0.2degreerel") #
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_unrelated_kin0.1degreerel") #
data <- read.table("Patin_2014_unrelated.kin",header=TRUE) #within families
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_unrelated_kin.3degreerel") #
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_unrelated_kin.2degreerel") #
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_unrelated_kin.1degreerel") #
q()
n
#Only third degree relatives remain

#Downsample
#comment: some populations have less than 36 samples. In that case I take all of them - minus the related samples. Total: 207
rm randommax36bypop
R
data <- read.table("Patin_2014_unrelated.fam",header=FALSE)
#Baka_Cam
Baka_Cam <- subset(data[data$V1=="Baka_Cam",])
max <- nrow(Baka_Cam)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Baka_Cam[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Baka_Gab
Baka_Gab <- subset(data[data$V1=="Baka_Gab",])
max <- nrow(Baka_Gab)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Baka_Gab[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Bakiga
Bakiga <- subset(data[data$V1=="Bakiga",])
max <- nrow(Bakiga)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Bakiga[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Batwa
Batwa <- subset(data[data$V1=="Batwa",])
max <- nrow(Batwa)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Batwa[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Bongo_GabE
Bongo_GabE <- subset(data[data$V1=="Bongo_GabE",])
max <- nrow(Bongo_GabE)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Bongo_GabE[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Bongo_GabS
Bongo_GabS <- subset(data[data$V1=="Bongo_GabS",])
max <- nrow(Bongo_GabS)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Bongo_GabS[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Nzebi_Gab
Nzebi_Gab <- subset(data[data$V1=="Nzebi_Gab",])
max <- nrow(Nzebi_Gab)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Nzebi_Gab[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#Nzime_Cam
Nzime_Cam <- subset(data[data$V1=="Nzime_Cam",])
max <- nrow(Nzime_Cam)
x <- sort(sample(1:max,min(36,max),replace=F))
write.table(Nzime_Cam[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
q()
n

plink --bfile Patin_2014_unrelated --keep randommax36bypop --make-bed --out Patin207

#Missingness filtering
plink --bfile Patin207 --geno 0.1 --make-bed --out Patin207_2 #905500 variants and 207

#Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
infile="Patin207_2"
#cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim

#remove duplicate snps
#some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
#create col two containing dupl SNPs
cut -f2 ${infile}.bim | sort > with_dup
#create a col 2 containg no dupl SNPs using the uniq function
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
#use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
comm -23 with_dup wo_dup > dupl #0

#Flip ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" Patin207_2.bim >> ATCGlist
grep -P "\tT\tA" Patin207_2.bim >> ATCGlist
grep -P "\tC\tG" Patin207_2.bim >> ATCGlist
grep -P "\tG\tC" Patin207_2.bim >> ATCGlist
plink --bfile Patin207_2 --exclude ATCGlist --make-bed --out Patin207_3 #888234 variants and 207

###Merge!!!
cd /proj/uppstore2018150/private/process/preparedata

#with Patin_2014
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge Comparative_data/Omni1/Patin_2014/Patin207_3.bed Comparative_data/Omni1/Patin_2014/Patin207_3.bim Comparative_data/Omni1/Patin_2014/Patin207_3.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207 #5702 variants with 3+ alleles present
plink --bfile Comparative_data/Omni1/Patin_2014/Patin207_3 --flip zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207-merge.missnp --make-bed --out Comparative_data/Omni1/Patin_2014/Patin207_3f
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge Comparative_data/Omni1/Patin_2014/Patin207_3f.bed Comparative_data/Omni1/Patin_2014/Patin207_3f.bim Comparative_data/Omni1/Patin_2014/Patin207_3f.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_2 #16
plink --bfile Comparative_data/Omni1/Patin_2014/Patin207_3f --exclude zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_2-merge.missnp --make-bed --out Comparative_data/Omni1/Patin_2014/Patin207_3fe
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge Comparative_data/Omni1/Patin_2014/Patin207_3fe.bed Comparative_data/Omni1/Patin_2014/Patin207_3fe.bim Comparative_data/Omni1/Patin_2014/Patin207_3fe.fam --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_3 #1,603,552 variants and 882 ind

#Missingness
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_3 --geno 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 #461,584 variants and 882 people
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --missing --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4
sed  "s/ \+/\t/g" zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #most missingness in the Haber_2016 samples

####
#### Some analysis
####

### Remove fake individuals
grep fake zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.fam > zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.fake
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.fake --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex --recode --transpose --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex

#run asd:
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex.tped --tfam zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex.tfam --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2017-1-572 -J mds_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex -o mds_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex.output -e mds_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

#run smartpca
root=zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par #Careful! the number of spaces has to be exactly right for sed to recognize it...
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0  -A snic2017-1-572 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

#ask Carina about missingness filter. Ask Cesar about Haber data. Forward present email.
####
#### ADMIXTURE
####

#Preliminary step: filter for LD

#Filter for LD
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex --indep-pairwise 50 10 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex # 916789 of 1176918
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex --extract zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.prune.in --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex; #260129 variants and 673 people
#
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex --indep-pairwise 50 10 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex #335892 of 461584 variants removed
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex --extract zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.prune.in --make-bed --out zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex; #125692 variants and 880 people

#Run admixture
#zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex
cd /proj/uppstore2018150/private/process/preparedata/admixture/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex/log
for i in {1..20}; do
for k in {1..10}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/uppstore2018150/private/process/preparedata/admixture/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture ../../../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.bed $k -s $RANDOM
mv zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.Q ../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.Q.${i}
mv zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.P ../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 24:0:0 -A snic2017-1-572 -J ad_${k}_${i}_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex -o ad_${k}_${i}_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.output -e ad_${k}_${i}_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done

#Run admixture
#zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex
cd /proj/uppstore2018150/private/process/preparedata/admixture/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex/log
for i in {1..20}; do
for k in {1..10}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/uppstore2018150/private/process/preparedata/admixture/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture ../../../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.bed $k -s $RANDOM
mv zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.${k}.Q ../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.${k}.Q.${i}
mv zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.${k}.P ../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 24:0:0 -A snic2017-1-572 -J ad_${k}_${i}_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex -o ad_${k}_${i}_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.output -e ad_${k}_${i}_zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done
#Comment: the submission of one job might have failed (?)

####
#### PREPARE DATASETS WITHOUT CHB + BASIC ANALYSES
####
grep CHB zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fam > zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3_CHB
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3_CHB --make-bed --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71
plink --bfile zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71 --geno 0.1 --mind 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2
plink --bfile zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex
plink --bfile zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex --recode --transpose --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex

grep CHB zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.fam > zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4_CHB
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4_CHB --make-bed --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207
plink --bfile zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207 --geno 0.1 --mind 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2
plink --bfile zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex
plink --bfile zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex --recode --transpose --out zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex

#run asd:
root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex
/crex/proj/uppstore2018150/private/Programs/asd --tped ${root}.tped --tfam ${root}.tfam --out ${root}
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2017-1-572 -J mds_${root} -o mds_${root}.output -e mds_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex
/crex/proj/uppstore2018150/private/Programs/asd --tped ${root}.tped --tfam ${root}.tfam --out ${root}
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2017-1-572 -J mds_${root} -o mds_${root}.output -e mds_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

#run smartpca
root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par #Careful! the number of spaces has to be exactly right for sed to recognize it...
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0  -A snic2017-1-572 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END


root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par #Careful! the number of spaces has to be exactly right for sed to recognize it...
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0  -A snic2017-1-572 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END


####
#### PREPARE DATASETS WITHOUT CHB+CEU + BASIC ANALYSES
####
grep -e CHB -e CEU zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fam > zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3_CHB_CEU
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3_CHB_CEU --make-bed --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71
plink --bfile zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71 --geno 0.1 --mind 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2
plink --bfile zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex
plink --bfile zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex --recode --transpose --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex

grep -e CHB -e CEU zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.fam > zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4_CHB_CEU
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4_CHB_CEU --make-bed --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207
plink --bfile zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207 --geno 0.1 --mind 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2
plink --bfile zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2 --remove zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex
plink --bfile zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex --recode --transpose --out zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex


#run asd:
root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex
/crex/proj/uppstore2018150/private/Programs/asd --tped ${root}.tped --tfam ${root}.tfam --out ${root}
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2017-1-572 -J mds_${root} -o mds_${root}.output -e mds_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex
/crex/proj/uppstore2018150/private/Programs/asd --tped ${root}.tped --tfam ${root}.tfam --out ${root}
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2017-1-572 -J mds_${root} -o mds_${root}.output -e mds_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

#run smartpca
root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par #Careful! the number of spaces has to be exactly right for sed to recognize it...
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0  -A snic2017-1-572 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END


root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par #Careful! the number of spaces has to be exactly right for sed to recognize it...
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0  -A snic2017-1-572 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END


####
#### PCA with KS, RHG and West Africans + projection of the Zambian and RHG neighbours samples
####

#goal: see where the Zambian samples fall in a 2D space. Do they fall on the KS-RHG axis?

#starting fileset: Nzime_Cam zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4


##Select individuals
#set 1: all KS
grep -e ColouredAskham -e GuiGhanaKgal -e Juhoansi -e Karretjie -e Khomani -e Khwe -e Nama -e schust -e Xun -e YRI -e Baka_Cam -e Baka_Gab -e Bakiga -e Bangweulu -e Kafue -e Nzebi_Gab -e Nzime_Cam zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.fam > zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4_KS_RHG_YRI_Zambian_RHGn #336 samples
plink --bfile zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --keep zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4_KS_RHG_YRI_Zambian_RHGn --make-bed --out zbatwa9_Schlebusch2012_1KGP36_Patin108
plink --bfile zbatwa9_Schlebusch2012_1KGP36_Patin108 --geno 0.1 --mind 0.1 --make-bed --out zbatwa9_Schlebusch2012_1KGP36_Patin108_2

#Comment: depending on how the results look like I could also do it with less KS (e.g. not the ColouredAskham)

##run smartpca
root=zbatwa9_Schlebusch2012_1KGP36_Patin108_2
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_RHGnandZambianprojected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_RHGnandZambianprojected.par
echo -e 'poplistname:\tzbatwa9_Schlebusch2012_1KGP36_Patin108_2_noRHGn_noZambian' >> ${root}_killr20.2_popsize36_RHGnandZambianprojected.par
rm temppar
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/process/preparedata
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_Schlebusch2012_1KGP36_Patin108_2
smartpca -p ${root}_killr20.2_popsize36_RHGnandZambianprojected.par > ${root}_killr20.2_popsize36_RHGnandZambianprojected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 1:0:0  -A snic2017-1-572 -J PC_${root}_RHGnandZambianprojected -o PC_${root}_RHGnandZambianprojected.output -e PC_${root}_RHGnandZambianprojected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END


















