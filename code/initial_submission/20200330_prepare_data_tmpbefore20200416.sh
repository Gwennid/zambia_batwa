#Gwenna Breton
#started 20200330
#Goal: prepare the analysis set for the Zambia project. Compared to the 2018 version, we have additional samples from Zambia (Bantu-speaker populations) also typed on the H3 Africa SNP array. Additional comparative populations might also be included.
#based on pilot_study_20181012.sh. Commented commands are copied from the initial script and are not repeated here.

### The raw data for the Bangweulu and the Kafue samples is here:
/proj/uppstore2018150/private/raw/QJ-1609/QJ-1609_180704_ResultReport/QJ-1609_180704_PLINK_PCF_FWD

### Changed naming of folders: changed "process" to "tmp" and "preparedata" to "preparedata_Oct2018", and "raw_data" to "raw".

### Data for the additional Zambian populations.
# Cesar Fortes-Lima selected the samples for me. I copied the entire folder to /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB.
# Caution! Need to subsample to only the populations we are interested in i.e. Lozi, Tonga and Bemba (Zambia_Bemba, Zambia_Lozi and Zambia_TongaZam).

###
interactive -p core -n 1 -A snic2018-8-397 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
#Other projects I can use: snic2019-8-14 (PS); snic2019-8-157 (mine, currently all hours are used); snic2019-8-175 (MV); g2019029 (teaching, maybe I should not use that one!).
###



###
### Prepare the Zambian Batwa data
###

#cp /proj/uppstore2018150/private/raw_data/QJ-1609/QJ-1609_180704_ResultReport/QJ-1609_180704_PLINK_PCF_FWD/* .

#plink --file QJ-1609_180704_PLINK_PCF_FWD --make-bed --out QJ-1609_180704_PLINK_PCF_FWD
#plink --bfile QJ-1609_180704_PLINK_PCF_FWD --missing --out QJ-1609_180704_PLINK_PCF_FWD
#most individuals have low missingness, except:
#B-26          Y   217379  2264808  0.09598
#K-12          Y   873890  2264808   0.3859
#
###Exclude the 13 samples which belong to another study
#grep HSQ QJ-1609_180704_PLINK_PCF_FWD.fam > HSQsamples
#plink --bfile QJ-1609_180704_PLINK_PCF_FWD --remove HSQsamples --make-bed --out zbatwa1
#
###Create fake individual using this file: /proj/uppstore2018150/private/raw_data/QJ-1609/QJ-1609_180704_ResultReport/H3Africa_2017_20021485_A2.csv
#cd /proj/uppstore2018150/private/process/preparedata/fakeind
#file=/proj/uppstore2018150/private/raw_data/QJ-1609/QJ-1609_180704_ResultReport/H3Africa_2017_20021485_A2.csv
#head -n -23 ${file} > H3Africa_2017_20021485_A2.csv_truncated #keep all but the last 23 lines
#cut -d"," -f2,4 H3Africa_2017_20021485_A2.csv_truncated | sed "s/\,/\t/g" | sed "s/\[//g"| sed "s/\]//g" | sed -e '1,8d' | sed "s/\//\t/g" | sed "s/^/fakeInd\tfakeInd\t/g" >fakeInd.lgen
##col2: name of SNP, col4: alleles
##sed -e '1,8d' is to remove the first 8 lines
#
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
#
##made a fam file (manually)
#fakeInd fakeInd 0 0 0 -9
#
##now read lgen, fam and map files into plink and put fake sample out in bed format
#plink --lfile fakeInd --make-bed --out fakeInd
#
##merge data to fake, flip your alleles in fake sample to match your input file and merge again
#cd /proj/uppstore2018150/private/process/preparedata
#plink --bfile zbatwa1 --bmerge fakeind/fakeInd.bed fakeind/fakeInd.bim fakeind/fakeInd.fam --make-bed --out zbatwa1f
#plink --bfile fakeind/fakeInd --flip zbatwa1f-merge.missnp  --make-bed --out fakeind/fakeIndf 
#plink --bfile zbatwa1 --bmerge fakeind/fakeIndf.bed fakeind/fakeIndf.bim fakeind/fakeIndf.fam --make-bed --out zbatwa1f
#
##exclude 0 and sex chr (45,925 variants)
#rm exlist; touch exlist
#grep -P "^0\t" zbatwa1.bim >> exlist
#grep -P "^23\t" zbatwa1.bim >> exlist #X
#grep -P "^24\t" zbatwa1.bim >> exlist #Y
#grep -P "^25\t" zbatwa1.bim >> exlist #XY
#grep -P "^26\t" zbatwa1.bim >> exlist #MT
#
#plink --bfile zbatwa1f --exclude exlist --make-bed --out zbatwa2 #2,221,421 remain.
#
##exclude indels
#rm indellist; touch indellist
#grep -P "\tI" zbatwa2.bim >> indellist
#grep -P  "\tD" zbatwa2.bim >> indellist
##comment: the same 407 positions come up
#plink --bfile zbatwa2 --exclude indellist --make-bed --out zbatwa3
##407 variants excluded; 2221014 remain
#
##do snp missingness filer
#plink --bfile zbatwa3 --geno 0.1 --make-bed --out zbatwa4
#
##do hwe filter
##One fileset for each population
#grep B zbatwa4.fam > Bangweulu
#grep K zbatwa4.fam > Kafue
#plink --bfile zbatwa4 --keep Bangweulu --make-bed --out zbatwa4B
#plink --bfile zbatwa4 --keep Kafue --make-bed --out zbatwa4K
##HWE in each fileset
#plink --bfile zbatwa4B --hwe 0.001 --make-bed --out zbatwa4Bhwe #1284 excl
#plink --bfile zbatwa4K --hwe 0.001 --make-bed --out zbatwa4Khwe #1154 excl
##I got a warning for both because "--hwe observation counts vary by more than 10%"
##Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
#cut -f2 zbatwa4Bhwe.bim > zbatwa4Bhwe_variants
#plink --bfile zbatwa4 --exclude zbatwa4Bhwe_variants --make-bed --out zbatwa4Bhweexcl
#cut -f2 zbatwa4Khwe.bim > zbatwa4Khwe_variants
#plink --bfile zbatwa4 --exclude zbatwa4Khwe_variants --make-bed --out zbatwa4Khweexcl
##Find overlap between zbatwa4Bhweexcl.bim and zbatwa4Khweexcl.bim
#cut -f2 zbatwa4Khweexcl.bim > zbatwa4Khweexcl_variants
#plink --bfile zbatwa4Bhweexcl --extract zbatwa4Khweexcl_variants --make-bed --out zbatwa4Bhweexcl-extractzbatwa4Khweexcl #205 variants
##do the reverse to check that we get the same
#cut -f2 zbatwa4Bhweexcl.bim > zbatwa4Bhweexcl_variants
#plink --bfile zbatwa4Khweexcl --extract zbatwa4Bhweexcl_variants --make-bed --out zbatwa4Khweexcl-extractzbatwa4Bhweexcl  #205 variants
##Finally, exclude these SNP
#cut -f2 zbatwa4Bhweexcl-extractzbatwa4Khweexcl.bim > zbatwa4Bhweexcl-extractzbatwa4Khweexcl_variants
#plink --bfile zbatwa4 --exclude zbatwa4Bhweexcl-extractzbatwa4Khweexcl_variants --make-bed --out zbatwa5
#
##do ind missingness filter
#plink --bfile zbatwa5 --mind 0.1 --make-bed --out zbatwa6
##one individual is removed (K-12)
#
##make bimfiles with same snp names
##replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
#infile="zbatwa6"
##cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
#cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
#cut -f1 ${infile}.bim > first
#cut -f3- ${infile}.bim > last
#paste first mid last > ${infile}.bim
#
##remove duplicate snps
##some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
##create col two containing dupl SNPs
#cut -f2 ${infile}.bim | sort > with_dup
##create a col 2 containg no dupl SNPs using the uniq function
#cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
##use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
#comm -23 with_dup wo_dup > dupl
#plink --bfile zbatwa6 --exclude dupl --make-bed --out zbatwa7 
#
##look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
#plink --bfile zbatwa7 --missing --out zbatwa7
#sed  "s/ \+/\t/g" zbatwa7.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: B-26 0.09139; 2nd highest: B-23 0.01955
#
##exclude fake before IBD filtering
#grep fake zbatwa7.fam > fake_ex
#plink --bfile zbatwa7 --remove fake_ex --make-bed --out zbatwa7_fex 
#
####Relatedness filtering.
##with king
#/proj/uppstore2017249/DATA/king -b zbatwa7_fex.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/zbatwa7_fex #outputs are kin and kin0 but kin is empty -> I removed it
##Close relatives can be inferred fairly reliably based on the estimated kinship coefficients as shown in the following simple algorithm: an estimated kinship coefficient range >0.354, [0.177, 0.354], [0.0884, 0.177] and [0.0442, 0.0884] corresponds to duplicate/MZ twin, 1st-degree, 2nd-degree, and 3rd-degree relationships respectively.
##look at that one: zbatwa7_fex.kin0
#
#R
#data <- read.table("zbatwa7_fex.kin0",header=TRUE)
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="zbatwa7_fex_3degreerel")
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="zbatwa7_fex_2degreerel")
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="zbatwa7_fex_1degreerel")
#
##5 pairs of first degree relatives
##8 pairs of second degree relatives
##15 pairs of third degree relatives	
#
##with plink
##comment: normally I do LD pruning before using genome!
#plink --bfile zbatwa7_fex --genome --out zbatwa7_fex
#
##sort genome file to look at highest PiHAT
#sed  "s/ \+/\t/g" zbatwa7_fex.genome | sed  "s/^\t//g" | sort -k10 > zbatwa7_fex_genome_sorted
#
#R
#data <- read.table(file="zbatwa7_fex.genome",header=TRUE)
#png("zbatwa7_fex_IBD.png",height=480,width=1500, units="px",pointsize=16)
#par(mfrow=c(1,3))
#plot(data$Z0,data$Z1,pch=20,xlab="P(IBD=0)",ylab="P(IBD=1)",xlim=c(0,1),ylim=c(0,1))
#plot(data$Z1,data$Z2,pch=20,xlab="P(IBD=1)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
#plot(data$Z0,data$Z2,pch=20,xlab="P(IBD=0)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
#dev.off()
#q()
#n
#
###Usually Carina would exclude the first and second degree relatives. If it seems that the third degree relatives are perturbating the analyses we might need to exclude them as well.
###We expect high inbreeding in these populations. So it might be more relevant to look at outliers in IBD (rather than strong cutoffs).
#
#### Choose which individuals to remove due to relatedness (first and second degree relatives, I decided which pairs based on the comparison of the results of king and the plots of IBS in plink)
#
#### Comment 20181012: I did not go through the analyses steps as I found the same pairs of related individuals like before.
#
###Population B##
##in that population there is no overlap between the 4 pairs so I decided which to exclude based on missingness. Another possible criteria would have been to try to get an equal sex ratio in the sample.
#
###Pairs of PO
#
##B-05 and B-23
#grep "B-05" zbatwa7.imiss  # 0.001184
#grep "B-23" zbatwa7.imiss # 0.01954
##Keep B-05
#
###Pairs of FS
#
##B-02: 0.001179 and B-24: 0.001467 -> keep B-02
#
###HS or other second degree relatives
#
##B-06: 0.001056 and B-10: 0.001185 -> keep B-06
##B-26: 0.09139 and B-25: 0.00135 -> keep B-25
#
###Population K##
##In this population there is overlap between some pairs. Also there are more pairs of related samples (2 PO, 1 FS, 6 2nd degree)
#
###Pairs of PO
#
##K-15 K-37 -> keep K-37 because K-15 is in another pair as well. And K-15 has higher missingness!
##K-06: 0.00105 and K-30: 0.001111 -> keep K-06
#
###Pairs of FS
#
##K-22: 0.001426 K-28: 0.001013 -> there is a relationship triangle with K-21: 0.001508: both K-22 and K-28 are 2nd degree relatives of K-21. Based on missingness -> keep K-28.
#
###2nd degree
#
##K-09 K-26 -> keep K-26 because K-09 is in another pair. And K-26 as lower missingness!
##K-09 K-31 -> keep K-31 because K-09 is in another pair. And K-31 as lower missingness!
##K-15 K-40 -> keep K-40 because K-15 is in another pair. In that case K-40 has slightly higher missingness.
##K-21 K-22 see above
##K-21 K-28 see above
##K-25: 0.001017 K-36: 0.001038 -> keep K-25
#
####Create a list of samples to exclude
#for ind in B-23 B-24 B-10 B-26 K-15 K-30 K-21 K-22 K-09 K-36; do grep ${ind} zbatwa7.fam >> related_ex; done
#
####Exclude related samples
#plink --bfile zbatwa7 --remove related_ex --make-bed --out zbatwa8
#
##before doing more analysis, rerun king on the dataset from which I removed related individuals!!!
##exclude the fake individual
#plink --bfile zbatwa8 --remove fake_ex --make-bed --out zbatwa8_fex
#/proj/uppstore2017249/DATA/king -b zbatwa8_fex.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/zbatwa8_fex 
#R
#data <- read.table("zbatwa8_fex.kin0",header=TRUE)
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="zbatwa8_fex_3degreerel") #six pairs in population B, 5 pairs in population K
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="zbatwa8_fex_2degreerel") #none
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="zbatwa8_fex_1degreerel") #none
#q()
#n
##it worked :)
#
##make new famfile with group name in first column
##in our case the name must be made from scratch!
#cat zbatwa8.fam | cut -d" " -f2 | cut -d"-" -f1 | sed 's/B/Bangweulu/g' | sed 's/K/Kafue/g' > firstcol
#cut -d" " -f2- zbatwa8.fam >last
#paste firstcol last | sed "s/\t/ /g" >both
#cp zbatwa8.fam zbatwa8.famold
#cp both zbatwa8.fam
#
###exclude ATCG SNPs to prevent strand errors while flipping
##exclude ATCG
#rm ATCGlist; touch ATCGlist
#grep -P "\tA\tT" zbatwa8.bim >> ATCGlist
#grep -P "\tT\tA" zbatwa8.bim >> ATCGlist
#grep -P "\tC\tG" zbatwa8.bim >> ATCGlist
#grep -P "\tG\tC" zbatwa8.bim >> ATCGlist
#plink --bfile zbatwa8 --exclude ATCGlist --make-bed --out zbatwa9
#
##remove fake individual for preliminary analyses of the Zambian samples alone
#plink --bfile zbatwa9 --remove fake_ex --make-bed --out zbatwa9_fex
#plink --bfile zbatwa9_fex --genome --out zbatwa9_fex
#
##MDS matrix based on allele sharing distances
#plink --bfile zbatwa9_fex --recode --transpose --out zbatwa9_fex
#
#(echo '#!/bin/bash -l'
#echo "
#cd /proj/uppstore2018150/private/process/preparedata
#/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_fex.tped --tfam zbatwa9_fex.tfam --out zbatwa9_fex
#exit 0" )  | sbatch -p core -n 1 -t 4:0:0 -A snic2017-1-572 -J ASD_zbatwa9_fex -o ASD_zbatwa9_fex.output -e ASD_zbatwa9_fex.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
#
##TODO plot it
#R
#data <- read.table(file="zbatwa9_fex.asd.dist",header=TRUE)
#fam <- read.table(file="zbatwa9_fex.fam")
#data.mds<-cmdscale(data)
#pdf(file="zbatwa9_fex.asd.dist.MDSplot.pdf", width=10, height=15, pointsize=12)
#plot(data.mds,col=as.factor(fam$V1),pch=20,asp=1,xlab=c(""),ylab=c(""),cex=2)
#title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
#legend("bottomright",legend=unique(fam$V1),pch=20,col=as.factor(unique(fam$V1)))
#dev.off()
##the two populations are distinguishable. The Bangweulu population is more dispersed.

#START WITH: zbatwa9

###
### Prepare the Zambian Bantu-speakers data
###


#First, select the individuals I want.
grep Bemba /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB.fam > keep_Bantu_speakers.txt
grep Lozi /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB.fam >> keep_Bantu_speakers.txt
grep Tonga /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB.fam >> keep_Bantu_speakers.txt
plink --bfile /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB --keep keep_Bantu_speakers.txt --make-bed --out zbantu1
plink --bfile zbantu1 --missing --out zbantu1 #ZAM54 (Lozi) has 0.01546 missingness. The rest is below 0.01.

#I decided to merge with fake, just in case (and to do the ACTG step at some point).
#merge data to fake, flip your alleles in fake sample to match your input file and merge again
plink --bfile zbantu1 --bmerge /proj/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd.bed /proj/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd.bim /proj/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd.fam --make-bed --out zbantu1f
plink --bfile /proj/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd --flip zbantu1f-merge.missnp  --make-bed --out fakeIndf_withzbantu 
plink --bfile zbantu1 --bmerge fakeIndf_withzbantu.bed fakeIndf_withzbantu.bim fakeIndf_withzbantu.fam --make-bed --out zbantu1f

###TODO continue.

##exclude 0 and sex chr (45,925 variants)
rm exlist; touch exlist
grep -P "^0\t" zbantu1.bim >> exlist
grep -P "^23\t" zbantu1.bim >> exlist #X
grep -P "^24\t" zbantu1.bim >> exlist #Y
grep -P "^25\t" zbantu1.bim >> exlist #XY
grep -P "^26\t" zbantu1.bim >> exlist #MT

plink --bfile zbantu1f --exclude exlist --make-bed --out zbantu2 #2,221,421 remain.

##exclude indels
rm indellist; touch indellist
grep -P "\tI" zbantu2.bim >> indellist
grep -P  "\tD" zbantu2.bim >> indellist
plink --bfile zbantu2 --exclude indellist --make-bed --out zbantu3

#do snp missingness filer
plink --bfile zbantu3 --geno 0.1 --make-bed --out zbantu4

#do hwe filter
#One fileset for each population
grep Lozi zbantu4.fam > Lozi
grep Bemba zbantu4.fam > Bemba
grep Tonga zbantu4.fam > Tonga
plink --bfile zbantu4 --keep Bemba --make-bed --out zbantu4B
plink --bfile zbantu4 --keep Lozi --make-bed --out zbantu4L
plink --bfile zbantu4 --keep Tonga --make-bed --out zbantu4T
#HWE in each fileset
plink --bfile zbantu4B --hwe 0.001 --make-bed --out zbantu4Bhwe #151 excl
plink --bfile zbantu4L --hwe 0.001 --make-bed --out zbantu4Lhwe #454 excl
plink --bfile zbantu4T --hwe 0.001 --make-bed --out zbantu4Thwe #0 excl
#I got a warning for both because "--hwe observation counts vary by more than 10%"
#I do not need to consider the Tonga in the next steps because no variant excluded due to HWE.
#Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
cut -f2 zbantu4Bhwe.bim > zbantu4Bhwe_variants
plink --bfile zbantu4 --exclude zbantu4Bhwe_variants --make-bed --out zbantu4Bhweexcl
cut -f2 zbantu4Lhwe.bim > zbantu4Lhwe_variants
plink --bfile zbantu4 --exclude zbantu4Lhwe_variants --make-bed --out zbantu4Lhweexcl
#Find overlap between zbantu4Bhweexcl.bim and zbantu4Lhweexcl.bim
cut -f2 zbantu4Lhweexcl.bim > zbantu4Lhweexcl_variants
plink --bfile zbantu4Bhweexcl --extract zbantu4Lhweexcl_variants --make-bed --out zbantu4Bhweexcl-extractzbantu4Lhweexcl #3 variants
#do the reverse to check that we get the same
cut -f2 zbantu4Bhweexcl.bim > zbantu4Bhweexcl_variants
plink --bfile zbantu4Lhweexcl --extract zbantu4Bhweexcl_variants --make-bed --out zbantu4Lhweexcl-extractzbantu4Bhweexcl  #3 variants
#Finally, exclude these SNP
cut -f2 zbantu4Bhweexcl-extractzbantu4Lhweexcl.bim > zbantu4Bhweexcl-extractzbantu4Lhweexcl_variants
plink --bfile zbantu4 --exclude zbantu4Bhweexcl-extractzbantu4Lhweexcl_variants --make-bed --out zbantu5

#do ind missingness filter
plink --bfile zbantu5 --mind 0.1 --make-bed --out zbantu6 #no individual removed

#make bimfiles with same snp names
#replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
infile="zbantu6"
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
plink --bfile zbantu6 --exclude dupl --make-bed --out zbantu7 

#look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
plink --bfile zbantu7 --missing --out zbantu7
sed  "s/ \+/\t/g" zbantu7.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: ZAM54 (Lozi) 0.01116; 2nd highest: ZAM68 (Lozi) 0.005839

#exclude fake before IBD filtering
grep fake zbantu7.fam > fake_ex
plink --bfile zbantu7 --remove fake_ex --make-bed --out zbantu7_fex 

###Relatedness filtering.
#with king
/proj/uppstore2017249/DATA/king -b zbantu7_fex.bed --kinship --prefix /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbantu7_fex
#Close relatives can be inferred fairly reliably based on the estimated kinship coefficients as shown in the following simple algorithm: an estimated kinship coefficient range >0.354, [0.177, 0.354], [0.0884, 0.177] and [0.0442, 0.0884] corresponds to duplicate/MZ twin, 1st-degree, 2nd-degree, and 3rd-degree relationships respectively.
R
data <- read.table("zbantu7_fex.kin",header=TRUE)
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="zbantu7_fex_3degreerel")
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="zbantu7_fex_2degreerel")
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="zbantu7_fex_1degreerel")
q()
n
#No related individuals at all! (I am surprised)

#with plink
plink --bfile zbantu7_fex --genome --out zbantu7_fex

#sort genome file to look at highest PiHAT
sed  "s/ \+/\t/g" zbantu7_fex.genome | sed  "s/^\t//g" | sort -k10 > zbantu7_fex_genome_sorted

R
data <- read.table(file="zbantu7_fex.genome",header=TRUE)
png("zbantu7_fex_IBD.png",height=480,width=1500, units="px",pointsize=16)
par(mfrow=c(1,3))
plot(data$Z0,data$Z1,pch=20,xlab="P(IBD=0)",ylab="P(IBD=1)",xlim=c(0,1),ylim=c(0,1))
plot(data$Z1,data$Z2,pch=20,xlab="P(IBD=1)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
plot(data$Z0,data$Z2,pch=20,xlab="P(IBD=0)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
dev.off()
q()
n
#Looks great. One pair which is a bit more extreme: ZAM43 and ZAM46 (TongaZam). I will keep it though since it does not pass the threshold of third degree relatives in KING.

##I do not need to exclude samples due to relatedness.
##I do not need to do a new FAM file because the population names are already there.
#
###exclude ATCG SNPs to prevent strand errors while flipping
##exclude ATCG
#rm ATCGlist; touch ATCGlist
#grep -P "\tA\tT" zbantu7.bim >> ATCGlist
#grep -P "\tT\tA" zbantu7.bim >> ATCGlist
#grep -P "\tC\tG" zbantu7.bim >> ATCGlist
#grep -P "\tG\tC" zbantu7.bim >> ATCGlist
#plink --bfile zbantu7 --exclude ATCGlist --make-bed --out zbantu8
#
##remove fake individual for preliminary analyses of the Zambian samples alone
#plink --bfile zbantu8 --remove fake_ex --make-bed --out zbantu8_fex
#plink --bfile zbantu8_fex --genome --out zbantu8_fex
#
##MDS matrix based on allele sharing distances
#plink --bfile zbantu8_fex --recode --transpose --out zbantu8_fex
#/crex/proj/uppstore2018150/private/Programs/asd --tped zbantu8_fex.tped --tfam zbantu8_fex.tfam --out zbantu8_fex
#
#R
#data <- read.table(file="zbantu8_fex.asd.dist",header=TRUE)
#fam <- read.table(file="zbantu8_fex.fam")
#data.mds<-cmdscale(data)
#pdf(file="zbantu8_fex.asd.dist.MDSplot.pdf", width=10, height=15, pointsize=12)
#plot(data.mds,col=as.factor(fam$V1),pch=20,asp=1,xlab=c(""),ylab=c(""),cex=2)
#title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
#legend("bottomright",legend=unique(fam$V1),pch=20,col=as.factor(unique(fam$V1)))
#dev.off()
##The populations are indistinguishable. This is weird. The pair of related individuals from the Tonga population is driving the first axis, but still.
##I sent the plot to CS because I would like another opinion - is that something we expect or should I worry and look for a potential sample mixup?

#Edit 20200331: Following CS answer, decided to remove one of the two samples in the pair of "more than average" related individuals.
mv zbantu8_fex.asd.dist.MDSplot.pdf zbantu8_fex.asd.dist.MDSplot.20200330.norelatednessfiltering.pdf #and moved to a tmp folder before next command - moved back afterwards.
rm zbantu8*
#Select the sample with the highest missingness to exclude.
grep ZAM43 zbantu7.imiss #0.00127
grep ZAM46 zbantu7.imiss #0.001849 EXCLUDE

#Relatedness filtering
###Create a list of samples to exclude
for ind in ZAM46 ; do grep ${ind} zbantu7.fam >> related_ex; done

###Exclude related samples
plink --bfile zbantu7 --remove related_ex --make-bed --out zbantu8
rm related_ex

#exclude ATCG SNPs to prevent strand errors while flipping
#exclude ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" zbantu7.bim >> ATCGlist
grep -P "\tT\tA" zbantu7.bim >> ATCGlist
grep -P "\tC\tG" zbantu7.bim >> ATCGlist
grep -P "\tG\tC" zbantu7.bim >> ATCGlist
plink --bfile zbantu8 --exclude ATCGlist --make-bed --out zbantu9

#remove fake individual for preliminary analyses of the Zambian samples alone
plink --bfile zbantu9 --remove fake_ex --make-bed --out zbantu9_fex
plink --bfile zbantu9_fex --genome --out zbantu9_fex

#MDS matrix based on allele sharing distances
plink --bfile zbantu9_fex --recode --transpose --out zbantu9_fex
/crex/proj/uppstore2018150/private/Programs/asd --tped zbantu9_fex.tped --tfam zbantu9_fex.tfam --out zbantu9_fex
rm zbantu9_fex.t*

R
data <- read.table(file="zbantu9_fex.asd.dist",header=TRUE)
fam <- read.table(file="zbantu9_fex.fam")
data.mds<-cmdscale(data)
pdf(file="zbantu9_fex.asd.dist.MDSplot.pdf", width=10, height=15, pointsize=12)
plot(data.mds,col=as.factor(fam$V1),pch=20,asp=1,xlab=c(""),ylab=c(""),cex=2)
title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
legend("bottomright",legend=unique(fam$V1),pch=20,col=as.factor(unique(fam$V1)))
dev.off()
q()
n
#Populations still undistinguishable (but maybe third axis would tell something). Axis 1: Lozi at both extremes, axis2: one Lozi versus one Bemba.


###
### MERGE THE TWO ZAMBIAN DATASETS
###
### I will merge the Batwa dataset with the fake to the Bantu-speakers dataset without the fake.
plink --bfile /proj/uppstore2018150/private/tmp/preparedata_Oct2018/zbatwa9 --bmerge zbantu9_fex.bed zbantu9_fex.bim zbantu9_fex.fam --make-bed --out zbatwa9_zbantu9 # 2 variants with 3+ alleles present
plink --bfile zbantu9_fex --flip zbatwa9_zbantu9-merge.missnp --make-bed --out zbantu9_fexf
plink --bfile /proj/uppstore2018150/private/tmp/preparedata_Oct2018/zbatwa9 --bmerge zbantu9_fexf.bed zbantu9_fexf.bim zbantu9_fexf.fam --make-bed --out zbatwa9_zbantu9_2
#missingness filter
plink --bfile zbatwa9_zbantu9_2 --geno 0.1 --make-bed --out zbatwa9_zbantu9_3
plink --bfile zbatwa9_zbantu9_3 --missing --out zbatwa9_zbantu9_3
sed  "s/ \+/\t/g" zbatwa9_zbantu9_3.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness in the Zambian Bantu-speakers samples

#remove fake individual for preliminary analyses of the Zambian samples alone
plink --bfile zbatwa9_zbantu9_3 --remove fake_ex --make-bed --out zbatwa9_zbantu9_3_fex

#MDS matrix based on allele sharing distances
plink --bfile zbatwa9_zbantu9_3_fex --recode --transpose --out zbatwa9_zbantu9_3_fex
/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_zbantu9_3_fex.tped --tfam zbatwa9_zbantu9_3_fex.tfam --out zbatwa9_zbantu9_3_fex
rm zbatwa9_zbantu9_3_fex.t*

R
data <- read.table(file="zbatwa9_zbantu9_3_fex.asd.dist",header=TRUE)
fam <- read.table(file="zbatwa9_zbantu9_3_fex.fam")
data.mds<-cmdscale(data)
pdf(file="zbatwa9_zbantu9_3_fex.asd.dist.MDSplot.pdf", width=10, height=15, pointsize=12)
plot(data.mds,col=as.factor(fam$V1),pch=20,asp=1,xlab=c(""),ylab=c(""),cex=2)
title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
legend("bottomright",legend=unique(fam$V1),pch=20,col=as.factor(unique(fam$V1)))
dev.off()
q()
n
#Bangweulu and Kafue clearly distinguishable (both legs of a "V"), Bantu-speakers all grouped. Yay!

###
### Merge with Omni2.5 datasets
###

# Comments: This section includes processing steps prior to merging (e.g. downsampling and relatedness).
#I have to prepare the data first. The data in /proj/uppstore2017249/DATA/ has been filtered for --geno 0.05 (in the _Filtered folders that is). I think it is filtered for relatedness but I will check nevertheless. Fix the variants names as well (to chr-position).
# Also: downsample populations to 36 individuals (the max in my dataset).

#####
##### Schlebusch 2012
#####

###Prepare
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

##relatedness
#/proj/uppstore2017249/DATA/king -b Schlebusch_2012_Filtered/Schlebusch_2012.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012
#
#R
#data <- read.table("Schlebusch_2012.kin0",header=TRUE) #accross families
#summary(data)
##the highest kinship coefficient is 0.0112
#data <- read.table("Schlebusch_2012.kin",header=TRUE) #within families
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Schlebusch_2012.3degreerel") #7
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Schlebusch_2012.2degreerel") #1 pair in the GuiGhanaKgal: KSP096 and KSP226
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Schlebusch_2012.1degreerel") #0
#q()
#n

#Relatedness filter (was not applied in Oct2018)
mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data
mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5
mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Schlebusch_2012
mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered
cp /proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.b* .
cp /proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.fam .

plink --bfile Schlebusch_2012 --missing --out Schlebusch_2012
grep KSP096 Schlebusch_2012.imiss
grep KSP226 Schlebusch_2012.imiss
#0 missingness for both - are these imputed?
#Decided to keep KSP096 since we kept it for the sequencing project.

for ind in KSP226 ; do grep ${ind} Schlebusch_2012.fam >> related_ex; done
plink --bfile Schlebusch_2012 --remove related_ex --make-bed --out Schlebusch_2012_2
rm related_ex

#### Merge with Schlebusch2012
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
plink --bfile zbatwa9_zbantu9_3 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012 #2806 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2 --flip zbatwa9_zbantu9_Schlebusch2012-merge.missnp --make-bed --out Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2f
plink --bfile zbatwa9_zbantu9_3 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2f.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2f.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2f.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_2 #9 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2f --exclude zbatwa9_zbantu9_Schlebusch2012_2-merge.missnp --make-bed --out Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2fe
plink --bfile zbatwa9_zbantu9_3 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2fe.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2fe.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_2fe.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_3
#missingness filter
plink --bfile zbatwa9_zbantu9_Schlebusch2012_3 --geno 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_4
plink --bfile zbatwa9_zbantu9_Schlebusch2012_4 --missing --out zbatwa9_zbantu9_Schlebusch2012_4
sed  "s/ \+/\t/g" zbatwa9_zbantu9_Schlebusch2012_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness in the Zambian samples (Lozi, Tonga)
#Comment: now there are two fake individuals

#####
##### 1KGP2015
#####

###Prepare
## Here I want to keep 36 of the following populations: non African: CEU, CHB; African: YRI LWK MKK
#
## Previously I used the fileset prepared by Mario ( /proj/uppstore2017249/DATA/1KGP_2015/G1000MV_shufdupl ) but this caused issues because I did not realize it was phased data [or maybe not phased but at least duplicated] and thus I took "half" individuals. Moreover I thought it has 60 ind / pop while in reality it has 30 by pop!
## I have 2 options: use the original fileset [I think it is original] which has 2000+ individuals -and possibly run into issues with related samples - or use the phased + related excl that has 1666 individuals - but then I have to understand how to "unphase" it.
## I'd rather use the unphased - start and see!
#
#cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/1KGP_2015
#cp  /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_final_onlyAutosomal.* .
#
##Select only the individuals from the following populations: CEU, CHB, YRI, LWK, MKK
#grep -e CEU -e CHB -e YRI -e LWK -e MKK 1000Genomes_final_onlyAutosomal.fam > CEU_CHB_YRI_LWK_MKK #496 individuals
#plink --bfile 1000Genomes_final_onlyAutosomal --keep CEU_CHB_YRI_LWK_MKK --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK
#
##snp and ind missingness
#plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK --geno 0.1 --mind 0.1 --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_2 # all ind passed. 1922 SNP removed.
#
##replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
#infile="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_2"
##cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
#cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
#cut -f1 ${infile}.bim > first
#cut -f3- ${infile}.bim > last
#paste first mid last > ${infile}.bim
#
##remove duplicate snps
##some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
##create col two containing dupl SNPs
#cut -f2 ${infile}.bim | sort > with_dup
##create a col 2 containg no dupl SNPs using the uniq function
#cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
##use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
#comm -23 with_dup wo_dup > dupl #6995
#plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_2 --exclude dupl --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3 
#
##relatedness
#/proj/uppstore2017249/DATA/king -b 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3
#
#R
#data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.kin0",header=TRUE) #accross families
#summary(data)
##the highest kinship coefficient is 0.0019
#data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.kin",header=TRUE) #within families
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.3degreerel") #14
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.2degreerel") #10
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.1degreerel") #113!
#q()
#n
#
##Error: 1 because I have a difference between the estimated and specified (here = none) kinship coefficients
#
#for POP in CEU CHB YRI MKK LWK; do grep ${POP} 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.1degreerel > 1and2degreerel_${POP}; grep ${POP} 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3.2degreerel >> 1and2degreerel_${POP}; done
##101 pairs in the YRI!!!!! (from a total of 161 samples) (in the /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_phased_duplicated_RelExcl_IBSexcl.tfam there are 196 YRI entries i.e. 98 YRI samples...)
#
##This time I am not trying to maximize the number of samples I keep so I can simply remove all individuals found in at least one pair.
##not going to work for the YRI though because that way I keep only 6 samples...
##I could keep the ones kept in /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_phased_duplicated_RelExcl_IBSexcl.tfam
#
#grep -e CEU -e CHB -e YRI -e LWK -e MKK /proj/uppstore2017249/DATA/1KGP_2015/1000Genomes_phased_duplicated_RelExcl_IBSexcl.tfam > 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK
#sed 's/_A//g' 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK | sed 's/_B//g' | sort | uniq > 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK_uniq
#
##Extract these from the dataset and run KING again
#plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_3 --keep 1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK_uniq --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4
#
#/proj/uppstore2017249/DATA/king -b 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/1KGP_2015/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4
#
#R
#data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.kin0",header=TRUE) #accross families
#summary(data)
##the highest kinship coefficient is 0.0017
#data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.kin",header=TRUE) #within families
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.3degreerel") #8
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.2degreerel") #2
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.1degreerel") #0
#q()
#n
#
##The two pairs of second degree relatives are from the MKK. I will remove the one with highest missingness from each pair.
#plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4 --missing --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4
#grep -e NA21386 -e NA21389 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.imiss #remove NA21386
#grep -e NA21477 -e NA21490 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.imiss #remove NA21477
#grep -e NA21386 -e NA21477 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4.fam > excl_MKK
#plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_4 --remove excl_MKK --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5
#
##Remaining number of samples by pop: CEU 95, CHB 100, LWK 77, MKK 29, YRI 98. So I need to downsample all except the MKK.
#
##Downsample
#rm randommax36bypop
#R
#data <- read.table("1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5.fam",header=FALSE)
##CEU
#CEU <- subset(data[data$V1=="CEU",])
#max <- nrow(CEU)
#x <- sort(sample(1:max,36,replace=F))
#write.table(CEU[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##CHB
#CHB <- subset(data[data$V1=="CHB",])
#max <- nrow(CHB)
#x <- sort(sample(1:max,36,replace=F))
#write.table(CHB[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##LWK
#LWK <- subset(data[data$V1=="LWK",])
#max <- nrow(LWK)
#x <- sort(sample(1:max,36,replace=F))
#write.table(LWK[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##YRI
#YRI <- subset(data[data$V1=="YRI",])
#max <- nrow(YRI)
#x <- sort(sample(1:max,36,replace=F))
#write.table(YRI[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#q()
#n
#grep MKK 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5.fam >> randommax36bypop #173 samples
#
##Extract those
#plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_5 --keep randommax36bypop --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6
#
##flip ATCG
#rm ATCGlist; touch ATCGlist
#grep -P "\tA\tT" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
#grep -P "\tT\tA" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
#grep -P "\tC\tG" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
#grep -P "\tG\tC" 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6.bim >> ATCGlist
#plink --bfile 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_6 --exclude ATCGlist --make-bed --out 1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7

#### Merge with 1KGP (subset)
folder=/proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/1KGP_2015
newfolder=/proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/1KGP_2015
plink --bfile zbatwa9_zbantu9_Schlebusch2012_4 --bmerge ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7.bed ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7.bim ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173 #91416 variants with 3+ alleles present
plink --bfile ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7 --flip zbatwa9_zbantu9_Schlebusch2012_1KGP173-merge.missnp --make-bed --out ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f
plink --bfile zbatwa9_zbantu9_Schlebusch2012_4 --bmerge ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f.bed ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f.bim ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_2 #85
plink --bfile ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7f --exclude zbatwa9_zbantu9_Schlebusch2012_1KGP173_2-merge.missnp --make-bed --out ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe
plink --bfile zbatwa9_zbantu9_Schlebusch2012_4 --bmerge ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe.bed ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe.bim ${newfolder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7fe.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_3
#missingness filter
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_3 --geno 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_4
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_4 --missing --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_4
sed  "s/ \+/\t/g" zbatwa9_zbantu9_Schlebusch2012_1KGP173_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #now the samples with the highest missingness are KGP samples (and one Lozi).

#####
##### Gurdasani
#####

###Prepare
#/proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Gurdasani_2015
## Amhara, Oromo, Somali, Sotho, Zulu, Igbo, Mandinka
##caution! Amhara Oromo Somali - see in Mario's folder AGVPpoplist
##Sotho: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Sotho/Sotho.bed
##Zulu: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Zulu/Zulu.bed
##Igbo: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Igbo/Igbo.bed
##Mandinka: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Mandinka/Mandinka.bed
##Amhara, Oromo, Somali are here: /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Ethiopians/Ethiopians.bed
##but do not use the data in Mario's folder because it is filtered.
#cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Gurdasani_2015
#
###Copy all necessary files
##cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Sotho/Sotho* .
##cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Zulu/Zulu* .
##cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Igbo/Igbo* .
##cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Mandinka/Mandinka* .
##cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Filtered/Ethiopians/Ethiopians* .
##cp /proj/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_MarioData/AGVPpoplist .
#
##Select 36 samples from each population
#R
#data <- read.table(file="Sotho.fam",header=FALSE)
#max <- nrow(data)
#x <- sort(sample(1:max,36,replace=F))
#write.table(data[x,],file="random36Sotho",append=TRUE,col.names=F,row.names=F,quote=F)
#data <- read.table(file="Zulu.fam",header=FALSE)
#max <- nrow(data)
#x <- sort(sample(1:max,36,replace=F))
#write.table(data[x,],file="random36Zulu",append=TRUE,col.names=F,row.names=F,quote=F)
#data <- read.table(file="Igbo.fam",header=FALSE)
#max <- nrow(data)
#x <- sort(sample(1:max,36,replace=F))
#write.table(data[x,],file="random36Igbo",append=TRUE,col.names=F,row.names=F,quote=F)
#data <- read.table(file="Mandinka.fam",header=FALSE)
#max <- nrow(data)
#x <- sort(sample(1:max,36,replace=F))
#write.table(data[x,],file="random36Mandinka",append=TRUE,col.names=F,row.names=F,quote=F)
##Ethiopians (it is different for these ones)
#data <- read.table(file="AGVPpoplist",header=FALSE)
#OROMO <- subset(data[data$V3=="OROMO",])
#max <- nrow(OROMO) #26 -> keep all
#write.table(OROMO[,c(1,3)],file="Oromo26",col.names=F,row.names=F,quote=F)
#AMHARA <- subset(data[data$V3=="AMHARA",])
#max <- nrow(AMHARA) #42
#x <- sort(sample(1:max,36,replace=F))
#write.table(AMHARA[x,c(1,3)],file="Amhara36",col.names=F,row.names=F,quote=F)
#SOMALI <- subset(data[data$V3=="SOMALI",])
#max <- nrow(SOMALI) #39
#x <- sort(sample(1:max,36,replace=F))
#write.table(SOMALI[x,c(1,3)],file="Somali36",col.names=F,row.names=F,quote=F)
#q()
#n
#
#plink --bfile Sotho --keep random36Sotho --make-bed --out random36Sotho
#plink --bfile Zulu --keep random36Zulu --make-bed --out random36Zulu
#plink --bfile Igbo --keep random36Igbo --make-bed --out random36Igbo
#plink --bfile Mandinka --keep random36Mandinka --make-bed --out random36Mandinka
#
##It is a bit different for the Oromo, Amhara and Somali because they are all in the same fileset. I create one plink fileset for each, modify the fam (to include Amhara, Oromo and Somali) and merge.
#rm oromo_fam; for i in {1..26}; do echo "Ethiopians" >> oromo_fam; done
#paste oromo_fam Oromo26 > EthiopiansOromo26
#plink --bfile Ethiopians --keep EthiopiansOromo26 --make-bed --out Oromo26
##Change the .fam so they contain the name of the population instead of "Ethiopians"
#mv Oromo26.fam Oromo26.oldfam
#cp Oromo26.oldfam tmp
#sed 's/Ethiopians/Oromo/g' < tmp > Oromo26.fam
#
#rm Amhara_fam; for i in {1..36}; do echo "Ethiopians" >> Amhara_fam; done
#paste Amhara_fam Amhara36 > EthiopiansAmhara36
#plink --bfile Ethiopians --keep EthiopiansAmhara36 --make-bed --out Amhara36
##Change the .fam so they contain the name of the population instead of "Ethiopians"
#mv Amhara36.fam Amhara36.oldfam
#cp Amhara36.oldfam tmp
#sed 's/Ethiopians/Amhara/g' < tmp > Amhara36.fam
#
#rm Somali_fam; for i in {1..36}; do echo "Ethiopians" >> Somali_fam; done
#paste Somali_fam Somali36 > EthiopiansSomali36
#plink --bfile Ethiopians --keep EthiopiansSomali36 --make-bed --out Somali36
##Change the .fam so they contain the name of the population instead of "Ethiopians"
#mv Somali36.fam Somali36.oldfam
#cp Somali36.oldfam tmp
#sed 's/Ethiopians/Somali/g' < tmp > Somali36.fam
#
#plink --bfile Amhara36 --bmerge Oromo26.bed Oromo26.bim Oromo26.fam --make-bed --out Amhara36_Oromo26 #no complaint
#plink --bfile Amhara36_Oromo26 --bmerge Somali36.bed Somali36.bim Somali36.fam --make-bed --out Amhara36_Oromo26_Somali36
#
##Now merge into a single "Gurdasani" fileset
#plink --bfile Amhara36_Oromo26_Somali36 --bmerge random36Sotho.bed random36Sotho.bim random36Sotho.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36
#plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36 --bmerge random36Igbo.bed random36Igbo.bim random36Igbo.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36
#plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36 --bmerge random36Zulu.bed random36Zulu.bim random36Zulu.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36
#plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36 --bmerge random36Mandinka.bed random36Mandinka.bim random36Mandinka.fam --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36
#
##Missingness filtering
#plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36 --geno 0.1 --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2 #1794966 variants and 242 people
#
##Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
#infile="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2"
##cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
#cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
#cut -f1 ${infile}.bim > first
#cut -f3- ${infile}.bim > last
#paste first mid last > ${infile}.bim
#
##remove duplicate snps
##some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
##create col two containing dupl SNPs
#cut -f2 ${infile}.bim | sort > with_dup
##create a col 2 containg no dupl SNPs using the uniq function
#cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
##use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
#comm -23 with_dup wo_dup > dupl #0
#
##relatedness
#/proj/uppstore2017249/DATA/king -b random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Gurdasani_2015/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2
#
#R
#data <- read.table("random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.kin0",header=TRUE) #accross families
#summary(data)
##the highest kinship coefficient is 0.01310
#data <- read.table("random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.kin",header=TRUE) #within families
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.3degreerel") #0
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.2degreerel") #0
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.1degreerel") #0
#q()
#n
##no related individuals to filter

##Flip ATCG
#rm ATCGlist; touch ATCGlist
#grep -P "\tA\tT" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
#grep -P "\tT\tA" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
#grep -P "\tC\tG" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
#grep -P "\tG\tC" random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2.bim >> ATCGlist
#plink --bfile random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_2 --exclude ATCGlist --make-bed --out random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3 #1770340 variants and 242 people

#### Merge with Gurdasani
folder=/proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/Gurdasani_2015
newfolder=/proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Gurdasani_2015
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_4 --bmerge ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3.bed ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3.bim ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242 #74714 variants with 3+ alleles present
plink --bfile ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3 --flip zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242-merge.missnp --make-bed --out ${newfolder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_4 --bmerge ${newfolder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f.bed ${newfolder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f.bim ${newfolder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3f.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_2 #
#missingness filter
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_2 --geno 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3 --missing --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3
sed  "s/ \+/\t/g" zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3.imiss | sed  "s/^\t//g" | sort -k6 | tail #now the samples with the highest missingness are KGP and Gurdasani samples.

#####
##### Haber
#####

### Prepare
#cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Haber_2016
#cp -r /proj/uppstore2017249/DATA/Haber_2016/Haber_2016_Filtered/ .
#
##Downsample
#rm randommax36bypop
#R
#data <- read.table("Haber_2016_Filtered/Haber_2016.fam",header=FALSE)
##Chad_Sara
#Sara <- subset(data[data$V1=="Chad_Sara",])
#max <- nrow(Sara)
#x <- sort(sample(1:max,36,replace=F))
#write.table(Sara[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Chad_Toubou
#Toubou <- subset(data[data$V1=="Chad_Toubou",])
#max <- nrow(Toubou)
#x <- sort(sample(1:max,36,replace=F))
#write.table(Toubou[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#q()
#n
#
#plink --bfile Haber_2016_Filtered/Haber_2016 --keep randommax36bypop --make-bed --out random_Sara36_Toubou36
#
##Missingness
#plink --bfile random_Sara36_Toubou36 --geno 0.1 --make-bed --out random_Sara36_Toubou36_2
#
##Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
#infile="random_Sara36_Toubou36_2"
##cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
#cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
#cut -f1 ${infile}.bim > first
#cut -f3- ${infile}.bim > last
#paste first mid last > ${infile}.bim
#
##remove duplicate snps
##some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
##create col two containing dupl SNPs
#cut -f2 ${infile}.bim | sort > with_dup
##create a col 2 containg no dupl SNPs using the uniq function
#cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
##use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
#comm -23 with_dup wo_dup > dupl #0
#
##relatedness
#/proj/uppstore2017249/DATA/king -b random_Sara36_Toubou36_2.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni2.5/Haber_2016/random_Sara36_Toubou36_2
#
#R
#data <- read.table("random_Sara36_Toubou36_2.kin0",header=TRUE) #accross families
#summary(data)
##the highest kinship coefficient is <0
#data <- read.table("random_Sara36_Toubou36_2.kin",header=TRUE) #within families
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="random_Sara36_Toubou36_2.3degreerel") #0
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="random_Sara36_Toubou36_2.2degreerel") #1
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="random_Sara36_Toubou36_2.1degreerel") #2
#q()
#n
#
#cat random_Sara36_Toubou36_2.2degreerel 
##"FID" "ID1" "ID2" "N_SNP" "Z0" "Phi" "HetHet" "IBS0" "Kinship" "Error"
##"1047" "Chad_Toubou" "yemcha6089821" "yemcha6089908" 2219393 1 0 0.089 0.02 0.1176 1
##one pair of second degree relatives and two pairs of third degree relatives. I decided to remove one of the samples in the 2nd degree pair i.e. there will be only 35 samples for the Chad_Toubou. I think that is ok!
#plink --bfile random_Sara36_Toubou36_2 --missing --out random_Sara36_Toubou36_2
##highest missingness: Chad_Toubou   yemcha6089908
#grep yemcha6089908 random_Sara36_Toubou36_2.fam > excl_related
#plink --bfile random_Sara36_Toubou36_2 --remove excl_related --make-bed --out random_Sara36_Toubou35
#
##Flip ATCG
#rm ATCGlist; touch ATCGlist
#grep -P "\tA\tT" random_Sara36_Toubou35.bim >> ATCGlist
#grep -P "\tT\tA" random_Sara36_Toubou35.bim >> ATCGlist
#grep -P "\tC\tG" random_Sara36_Toubou35.bim >> ATCGlist
#grep -P "\tG\tC" random_Sara36_Toubou35.bim >> ATCGlist
#plink --bfile random_Sara36_Toubou35 --exclude ATCGlist --make-bed --out random_Sara36_Toubou35_2 #2,164,153 variants and 71 people

### Merge with Haber
folder=/proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/Haber_2016
newfolder=/proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Haber_2016
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3 --bmerge ${folder}/random_Sara36_Toubou35_2.bed ${folder}/random_Sara36_Toubou35_2.bim ${folder}/random_Sara36_Toubou35_2.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71
plink --bfile ${folder}/random_Sara36_Toubou35_2 --flip zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71-merge.missnp --make-bed --out ${newfolder}/random_Sara36_Toubou35_2f
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3 --bmerge ${newfolder}/random_Sara36_Toubou35_2f.bed ${newfolder}/random_Sara36_Toubou35_2f.bim ${newfolder}/random_Sara36_Toubou35_2f.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_2
#missingness filter
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_2 --geno 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --missing --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3
sed  "s/ \+/\t/g" zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.imiss | sed  "s/^\t//g" | sort -k6 | tail #Samples with highest missingness are Haber 2016 samples.

####
#### Some analysis before merging with Omni1
####

### Remove fake individuals
grep fake zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fam > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --remove zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex --recode --transpose --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex

#run asd SUBMITTED
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.tped --tfam zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.tfam --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2018-8-397 -J mds_Omni2.5full -o mds_Omni2.5full.output -e mds_Omni2.5full.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL

#run smartpca SUBMITTED
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
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
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0 -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output

###
### Merge with Omni1 datasets
###

#####
##### Patin 2014
#####

#### Prepare
#
##max 36 individuals per population, from Patin_2014
##comment: there are BaTwa and BaKiga in Patin_2014 so I will use those instead of using samples from Perry_2014 as well
#
#mkdir /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/
#mkdir /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014
#cd /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014
#
#cp -r /proj/uppstore2017249/DATA/Patin_2014/Patin_2014_Filtered/ .
#
##I am starting with relatedness filtering
#/proj/uppstore2017249/DATA/king -b Patin_2014_Filtered/Patin_2014.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014/Patin_2014_Filtered/Patin_2014
#
#R
#data <- read.table("Patin_2014_Filtered/Patin_2014.kin0",header=TRUE) #accross families
#summary(data)
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_Filtered/Patin_2014_kin0.3degreerel") #
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_Filtered/Patin_2014_kin0.2degreerel") #
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_Filtered/Patin_2014_kin0.1degreerel") #
##the highest kinship coefficient is 0.0624
#data <- read.table("Patin_2014_Filtered/Patin_2014.kin",header=TRUE) #within families
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_Filtered/Patin_2014_kin.3degreerel") #
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_Filtered/Patin_2014_kin.2degreerel") #
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_Filtered/Patin_2014_kin.1degreerel")
#q()
#n
#
##remove related samples (1st and 2nd degree relatives)
#grep -e Batwa_05 -e Batwa_06 -e Batwa_12 -e Batwa_14 -e Batwa_18 -e Batwa_19 -e Batwa_24 -e Batwa_25 -e Batwa_27 -e Baka_Cam_04 -e Baka_Cam_12 -e Baka_Cam_35 -e Baka_Cam_51 -e Baka_Cam_56 -e Bakiga_05 -e Bakiga_25 -e Bongo_GabE_08 -e Bongo_GabS_01 -e Bongo_GabS_19 -e Nzime_Cam_15 -e Nzime_Cam_33 -e Nzime_Cam_41 Patin_2014_Filtered/Patin_2014.fam > Patin_2014_related
#plink --bfile Patin_2014_Filtered/Patin_2014 --remove Patin_2014_related --make-bed --out Patin_2014_unrelated #238 remaining out of 260
#
##Check relatedness
#/proj/uppstore2017249/DATA/king -b Patin_2014_unrelated.bed --kinship --prefix /proj/uppstore2018150/private/process/preparedata/Comparative_data/Omni1/Patin_2014/Patin_2014_unrelated
#
#R
#data <- read.table("Patin_2014_unrelated.kin0",header=TRUE) #accross families
#summary(data) #max 0.06240
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_unrelated_kin0.3degreerel") #
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_unrelated_kin0.2degreerel") #
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_unrelated_kin0.1degreerel") #
#data <- read.table("Patin_2014_unrelated.kin",header=TRUE) #within families
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Patin_2014_unrelated_kin.3degreerel") #
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Patin_2014_unrelated_kin.2degreerel") #
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Patin_2014_unrelated_kin.1degreerel") #
#q()
#n
##Only third degree relatives remain
#
##Downsample
##comment: some populations have less than 36 samples. In that case I take all of them - minus the related samples. Total: 207
#rm randommax36bypop
#R
#data <- read.table("Patin_2014_unrelated.fam",header=FALSE)
##Baka_Cam
#Baka_Cam <- subset(data[data$V1=="Baka_Cam",])
#max <- nrow(Baka_Cam)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Baka_Cam[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Baka_Gab
#Baka_Gab <- subset(data[data$V1=="Baka_Gab",])
#max <- nrow(Baka_Gab)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Baka_Gab[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Bakiga
#Bakiga <- subset(data[data$V1=="Bakiga",])
#max <- nrow(Bakiga)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Bakiga[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Batwa
#Batwa <- subset(data[data$V1=="Batwa",])
#max <- nrow(Batwa)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Batwa[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Bongo_GabE
#Bongo_GabE <- subset(data[data$V1=="Bongo_GabE",])
#max <- nrow(Bongo_GabE)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Bongo_GabE[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Bongo_GabS
#Bongo_GabS <- subset(data[data$V1=="Bongo_GabS",])
#max <- nrow(Bongo_GabS)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Bongo_GabS[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Nzebi_Gab
#Nzebi_Gab <- subset(data[data$V1=="Nzebi_Gab",])
#max <- nrow(Nzebi_Gab)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Nzebi_Gab[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
##Nzime_Cam
#Nzime_Cam <- subset(data[data$V1=="Nzime_Cam",])
#max <- nrow(Nzime_Cam)
#x <- sort(sample(1:max,min(36,max),replace=F))
#write.table(Nzime_Cam[x,],file="randommax36bypop",append=TRUE,col.names=F,row.names=F,quote=F)
#q()
#n
#
#plink --bfile Patin_2014_unrelated --keep randommax36bypop --make-bed --out Patin207
#
##Missingness filtering
#plink --bfile Patin207 --geno 0.1 --make-bed --out Patin207_2 #905500 variants and 207
#
##Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
#infile="Patin207_2"
##cut first and fourth cols and replace tab with -, the cut first col, then cut 3rd col onwards, then paste three files cols together in one file to form new bimfile
#cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
#cut -f1 ${infile}.bim > first
#cut -f3- ${infile}.bim > last
#paste first mid last > ${infile}.bim
#
##remove duplicate snps
##some SNPs have different SNP names i.e. kgp and rs but have the same base position - these are duplicate snps need to be removed
##create col two containing dupl SNPs
#cut -f2 ${infile}.bim | sort > with_dup
##create a col 2 containg no dupl SNPs using the uniq function
#cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
##use the comm function to only print lines that one file contain but not the other in a comparison - this give you the duplicate SNPs
#comm -23 with_dup wo_dup > dupl #0
#
##Flip ATCG
#rm ATCGlist; touch ATCGlist
#grep -P "\tA\tT" Patin207_2.bim >> ATCGlist
#grep -P "\tT\tA" Patin207_2.bim >> ATCGlist
#grep -P "\tC\tG" Patin207_2.bim >> ATCGlist
#grep -P "\tG\tC" Patin207_2.bim >> ATCGlist
#plink --bfile Patin207_2 --exclude ATCGlist --make-bed --out Patin207_3 #888234 variants and 207
#
#### Merge
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020

folder=/proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni1/Patin_2014
newfolder=/proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Patin_2014
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge ${folder}/Patin207_3.bed ${folder}/Patin207_3.bim ${folder}/Patin207_3.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207
plink --bfile ${folder}/Patin207_3 --flip zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207-merge.missnp --make-bed --out ${newfolder}/Patin207_3f
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge ${newfolder}/Patin207_3f.bed ${newfolder}/Patin207_3f.bim ${newfolder}/Patin207_3f.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_2
plink --bfile ${newfolder}/Patin207_3f --exclude zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_2-merge.missnp --make-bed --out ${newfolder}/Patin207_3fe
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge ${newfolder}/Patin207_3fe.bed ${newfolder}/Patin207_3fe.bim ${newfolder}/Patin207_3fe.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_3
#Missingness
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_3 --geno 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --missing --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4
sed  "s/ \+/\t/g" zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #mix (Haber, Patin, 1KGP)

#####
##### Scheinfeldt 2019
#####

# Comment: I think it is Omni1! I'll see when I merge (they do not write Omni1 in the article but mention an Illumina 1M SNP array and when I googled it I found the Omni1 so...).
# I decided to start with the "Raw" not the Filtered (for the rest of the dataset I started with the Filtered). The difference should be a --geno and a --hwe filter.
# I won't have to downsample (less than 36 individuals in each population).
/crex/proj/uppstore2017249/DATA/Scheinfeldt_2019/Scheinfeldt_2019_Raw
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Scheinfeldt_2019
cp /crex/proj/uppstore2017249/DATA/Scheinfeldt_2019/Scheinfeldt_2019_Raw/Scheinfeldt_2019.b* . ; cp /crex/proj/uppstore2017249/DATA/Scheinfeldt_2019/Scheinfeldt_2019_Raw/Scheinfeldt_2019.fam .

#### Prepare

#Select the Ethiopia_Sabue, Tanzania_Hadza and Sudan_Dinka
grep -e Ethiopia_Sabue -e Tanzania_Hadza -e Sudan_Dinka Scheinfeldt_2019.fam > Sabue_Hadza_Dinka
plink --bfile Scheinfeldt_2019 --keep Sabue_Hadza_Dinka --make-bed --out Scheinfeldt_2019_Sabue_Hadza_Dinka
#Missingness filtering
plink --bfile Scheinfeldt_2019_Sabue_Hadza_Dinka --geno 0.1 --mind 0.1 --make-bed --out Scheinfeldt_2019_Sabue_Hadza_Dinka_2
#Rename SNPs to chr-pos 
infile="Scheinfeldt_2019_Sabue_Hadza_Dinka_2"
cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
cut -f1 ${infile}.bim > first
cut -f3- ${infile}.bim > last
paste first mid last > ${infile}.bim
#Remove duplicate snps
cut -f2 ${infile}.bim | sort > with_dup
cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl #None!
#Relatedness
/proj/uppstore2017249/DATA/king -b Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bed --kinship --prefix /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Scheinfeldt_2019/Scheinfeldt_2019_Sabue_Hadza_Dinka_2
R
data <- read.table("Scheinfeldt_2019_Sabue_Hadza_Dinka_2.kin",header=TRUE) #accross families
summary(data)
write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Scheinfeldt_2019_Sabue_Hadza_Dinka_2_kin.3degreerel") #16 pairs
write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Scheinfeldt_2019_Sabue_Hadza_Dinka_2_kin.2degreerel") #0
write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Scheinfeldt_2019_Sabue_Hadza_Dinka_2_kin.1degreerel") #0
q()
n
#I am not going to exclude anyone due to relatedness (only third degree).
#Flip ATCG
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
grep -P "\tT\tA" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
grep -P "\tC\tG" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
grep -P "\tG\tC" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
plink --bfile Scheinfeldt_2019_Sabue_Hadza_Dinka_2 --exclude ATCGlist --make-bed --out Scheinfeldt_2019_Sabue_Hadza_Dinka_3

#### Merge
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
folder=/proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Scheinfeldt_2019
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --bmerge ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3.bed ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3.bim ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52
plink --bfile ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3 --flip zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52-merge.missnp --make-bed --out ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3f
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --bmerge ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3f.bed ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3f.bim ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_3f.fam --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_2
#Missingness
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_2 --geno 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3 --missing --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3
sed  "s/ \+/\t/g" zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3.imiss | sed  "s/^\t//g" | sort -k6 | tail -n 55 #highest missingness in the Scheinfeldt data. They all have ~0.25 missingness. I suppose this means they have a different set of variants. I need a more stringent variant filtering. 0.05 should do.
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3 --geno 0.05 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --missing --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4
sed  "s/ \+/\t/g" zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #Looks much better.
#TODO decide how to proceed. Even less variants than previously... 

####
#### Some analysis
####

### Remove fake individuals
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --remove zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex --recode --transpose --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex

#run asd: SUBMITTED
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.tped --tfam zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.tfam --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
exit 0") | sbatch -p core -n 2 -t 4:0:0 -A snic2018-8-397 -J mds_Omni1full -o mds_Omni1full.output -e mds_Omni1full.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END
#Took 30 minutes.

#run smartpca SUBMITTED
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
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
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END
#Took 5 minutes.

####
#### ADMIXTURE
####

#Preliminary step: filter for LD
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71
plink --bfile ${root}_3fex --indep-pairwise 50 10 0.1 --make-bed --out ${root}_4fex #931166 of 1193235 variants removed
plink --bfile ${root}_3fex --extract ${root}_4fex.prune.in --make-bed --out ${root}_4fex;
#
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52
plink --bfile ${root}_4fex --indep-pairwise 50 10 0.1 --make-bed --out ${root}_5fex #229372 of 344630
plink --bfile ${root}_4fex --extract ${root}_5fex.prune.in --make-bed --out ${root}_5fex;

#Run admixture

cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni2.5full/log
for i in {1..10}; do
for k in {2..10}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni2.5full
mkdir ad_${k}_${i}
cd ad_${k}_${i}
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex
admixture /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 24:0:0 -A snic2018-8-397 -J ad_${k}_${i}_Omni2.5full -o ad_${k}_${i}_Omni2.5full.output -e ad_${k}_${i}_Omni2.5full.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done

#TODO later, if I am happy: run an extra ten iterations per K.
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni1full/log
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
for i in {1..10}; do
for k in {2..10}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni1full/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 8:0:0 -A snic2019-8-157 -J ad_${k}_${i}_Omni1full -o ad_${k}_${i}_Omni1full.output -e ad_${k}_${i}_Omni1full.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done
#Edit 20200402: Because of where I specified the "prefix" (it should have been outside the script - compare script for Omni2.5 and updated script for Omni1), the Omni1full runs also ran on the Omni2.5 dataset. I moved the output to tmp_Omni2.5 (same for the log) and resubmitted.

#This means that I have an extra 10 runs for each K for Omni2.5! I will rename them (e.g. 1 becomes 11) and then I can use them.
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni1full/tmp_Omni2.5
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex
for i in {1..10}; do
for k in {2..10}; do
j=$(($i+10))
mv ${prefix}.${k}.Q.${i} ${prefix}.${k}.Q.${j}
mv ${prefix}.${k}.P.${i} ${prefix}.${k}.P.${j}
done
done
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni2.5full
for i in {11..20}; do
for k in {2..10}; do
mv /proj/uppstore2018150/private/results/admixture_VT2020_Omni1full/tmp_Omni2.5/${prefix}.${k}.*.${i} .
done
done

#Edit 20200403: ADMIXTURE for Omni1 was submitted for the un-LD-pruned dataset. Submitting now for the pruned dataset and up to K=12.
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni1full/log
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_5fex
for i in {1..10}; do
for k in {2..12}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni1full/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/${prefix}.bed $k -s $RANDOM
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 12:0:0 -A snic2019-8-157 -J ad_${k}_${i}_Omni1full_2 -o ad_${k}_${i}_Omni1full_2.output -e ad_${k}_${i}_Omni1full_2.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done

###
### 20200415: additional preliminary analyses
###

#### PCA with YRI, Baka, Juhoansi, Bangweulu, Kafue.

cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/
grep -e YRI -e Baka_Cam -e Juhoansi -e Bangweulu -e Kafue zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex --keep zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z --geno 0.1 --mind 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2

##run smartpca
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
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
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 30:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

##run smartpca - Zambian projected.
grep -e YRI -e Baka_Cam -e Juhoansi zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z | cut -f1 -d" " | sort | uniq > YRI_Baka-Cam_Juhoansi_poplist
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_B_K_projected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_B_K_projected.par
echo -e 'poplistname:\tYRI_Baka-Cam_Juhoansi_poplist' >> ${root}_killr20.2_popsize36_B_K_projected.par
rm temppar
#TODO check that the pedind is correct - in that case I could have used the same like for the PCA not projected!
#cut -d" " -f1-5 ${root}.fam >file1a
#cut -d" " -f1 ${root}.fam >file2a
#touch fileComb
#paste file1a file2a >fileComb
#sed "s/\t/ /g" fileComb > ${root}.pedind
#rm file1a; rm file2a; rm fileComb

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2
smartpca -p ${root}_killr20.2_popsize36_B_K_projected.par > ${root}_killr20.2_popsize36_B_K_projected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 30:0  -A snic2018-8-397 -J PC_${root}_B_K_projected -o PC_${root}_B_K_projected.output -e PC_${root}_B_K_projected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

#### PCA with YRI, Baka, Juhoansi, Hadza, Bangweulu, Kafue.

cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/
grep -e YRI -e Baka_Cam -e Juhoansi -e Bangweulu -e Kafue -e Hadza zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex --keep zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z
plink --bfile zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z --geno 0.1 --mind 0.1 --make-bed --out zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2

##run smartpca
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
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
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 10:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

##run smartpca - Zambian projected.
grep -e YRI -e Baka_Cam -e Juhoansi -e Hadza zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z | cut -f1 -d" " | sort | uniq > YRI_Baka-Cam_Juhoansi_Hadza_poplist
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2
cp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_B_K_projected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_B_K_projected.par
echo -e 'poplistname:\tYRI_Baka-Cam_Juhoansi_Hadza_poplist' >> ${root}_killr20.2_popsize36_B_K_projected.par
rm temppar

(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2
smartpca -p ${root}_killr20.2_popsize36_B_K_projected.par > ${root}_killr20.2_popsize36_B_K_projected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 5:0  -A snic2018-8-397 -J PC_${root}_B_K_projected -o PC_${root}_B_K_projected.output -e PC_${root}_B_K_projected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END


























