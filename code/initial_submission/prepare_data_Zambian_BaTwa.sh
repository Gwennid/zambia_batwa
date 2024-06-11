#Gwenna Breton
#started 20181012

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

#Plot
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
