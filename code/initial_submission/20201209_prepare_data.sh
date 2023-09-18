#Gwenna Breton
#started 20201209
#Goal: prepare the analysis set for the Zambia project.
#Compared to the spring 2020 version, removal of four Lozi individuals and restriction to biallelic SNPs. One analysis set includes ancient samples.
#Compared to the 2018 version, we have additional samples from Zambia (Bantu-speaker populations) also typed on the H3 Africa SNP array. Additional comparative populations might also be included.
#Based on 20200330_prepare_data.sh and 20200717_analysiswithsomeindremoved.sh.
#20200330_prepare_data.sh was based on pilot_study_20181012.sh. Commented commands are copied from the initial script and are not repeated here.

### The raw data for the Bangweulu and the Kafue samples is here:
/proj/snic2020-2-10/uppstore2018150/private/raw/QJ-1609/QJ-1609_180704_ResultReport/QJ-1609_180704_PLINK_PCF_FWD

### I created a new directory to work from:
/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020

### Data for the additional Zambian populations.
# Cesar Fortes-Lima selected the samples for me. I copied the entire folder to /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB.
# Caution! Need to subsample to only the populations we are interested in i.e. Lozi, Tonga and Bemba (Zambia_Bemba, Zambia_Lozi and Zambia_TongaZam).
# Caution! We are using only the samples from Himla Soodyall's collection. This means that four Lozi individuals should not be included.

### Typical commands to start working:
interactive -p core -n 1 -A snic2018-8-397 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
#Computing hours projects: snic2019-8-157 (mine); snic2019-8-14 (PS); snic2019-8-175 (MV); g2019029 (teaching).
###

###
### Prepare the Zambian Batwa data
### Edit 20201209: I decided to restrict to biallelic SNPs only in the end of the processing (i.e. just before starting to merge) because I do not think that it will have a big impact on any step.
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

###Restrict to biallelic SNPs only
#If we were to include the BaTwa specific analyses in the ms we would need to rerun them with the restriction to biallelic SNPs.
plink --bfile /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/zbatwa9 --biallelic-only strict --make-bed --out zbatwa10
#All variants are kept, so there were already only biallelic SNPs!

#START WITH: zbatwa10

###
### Prepare the Zambian Bantu-speakers data
###

#First, select the individuals I want.
#grep Bemba /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB.fam > keep_Bantu_speakers.txt
#grep Lozi /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB.fam >> keep_Bantu_speakers.txt
#grep Tonga /proj/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB.fam >> keep_Bantu_speakers.txt
cp ../prepareanalysisset_March2020/keep_Bantu_speakers.txt .
#I modified manually keep_Bantu_speakers.txt to remove the four Lozi individuals that should not be included: ZAM031, ZAM229, ZAM280, ZAM342.
plink --bfile /proj/snic2020-2-10/uppstore2018150/private/raw/ZAMBIA_Gwenna_DB/ZAMBIA_Gwenna_DB --keep keep_Bantu_speakers.txt --make-bed --out zbantu1
plink --bfile zbantu1 --missing --out zbantu1 #ZAM54 (Lozi) has 0.01546 missingness. The rest is below 0.01.

#I decided to merge with fake, just in case (and to do the ACTG step at some point).
#merge data to fake, flip your alleles in fake sample to match your input file and merge again
plink --bfile zbantu1 --bmerge /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd.bed /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd.bim /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd.fam --make-bed --out zbantu1f
plink --bfile /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/fakeind/fakeInd --flip zbantu1f-merge.missnp  --make-bed --out fakeIndf_withzbantu 
plink --bfile zbantu1 --bmerge fakeIndf_withzbantu.bed fakeIndf_withzbantu.bim fakeIndf_withzbantu.fam --make-bed --out zbantu1f

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

#do snp missingness filer and Edit 20201209 Restrict to biallelic SNPs
plink --bfile zbantu3 --geno 0.1 --biallelic-only strict --make-bed --out zbantu4

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
plink --bfile zbantu4Bhweexcl --extract zbantu4Lhweexcl_variants --make-bed --out zbantu4Bhweexcl-extractzbantu4Lhweexcl #4 variants
#do the reverse to check that we get the same
cut -f2 zbantu4Bhweexcl.bim > zbantu4Bhweexcl_variants
plink --bfile zbantu4Lhweexcl --extract zbantu4Bhweexcl_variants --make-bed --out zbantu4Lhweexcl-extractzbantu4Bhweexcl  #4 variants
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
sed  "s/ \+/\t/g" zbantu7.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: ZAM54 (Lozi) 0.01147; 2nd highest: ZAM68 (Lozi) 0.006077

#Edit 20201209: I am not rerunning the relatedness filtering.
##exclude fake before IBD filtering
#grep fake zbantu7.fam > fake_ex
#plink --bfile zbantu7 --remove fake_ex --make-bed --out zbantu7_fex 
#
####Relatedness filtering.
##with king
#/proj/uppstore2017249/DATA/king -b zbantu7_fex.bed --kinship --prefix /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbantu7_fex
##Close relatives can be inferred fairly reliably based on the estimated kinship coefficients as shown in the following simple algorithm: an estimated kinship coefficient range >0.354, [0.177, 0.354], [0.0884, 0.177] and [0.0442, 0.0884] corresponds to duplicate/MZ twin, 1st-degree, 2nd-degree, and 3rd-degree relationships respectively.
#R
#data <- read.table("zbantu7_fex.kin",header=TRUE)
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="zbantu7_fex_3degreerel")
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="zbantu7_fex_2degreerel")
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="zbantu7_fex_1degreerel")
#q()
#n
##No related individuals at all! (I am surprised)
#
##with plink
#plink --bfile zbantu7_fex --genome --out zbantu7_fex
#
##sort genome file to look at highest PiHAT
#sed  "s/ \+/\t/g" zbantu7_fex.genome | sed  "s/^\t//g" | sort -k10 > zbantu7_fex_genome_sorted
#
#R
#data <- read.table(file="zbantu7_fex.genome",header=TRUE)
#png("zbantu7_fex_IBD.png",height=480,width=1500, units="px",pointsize=16)
#par(mfrow=c(1,3))
#plot(data$Z0,data$Z1,pch=20,xlab="P(IBD=0)",ylab="P(IBD=1)",xlim=c(0,1),ylim=c(0,1))
#plot(data$Z1,data$Z2,pch=20,xlab="P(IBD=1)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
#plot(data$Z0,data$Z2,pch=20,xlab="P(IBD=0)",ylab="P(IBD=2)",xlim=c(0,1),ylim=c(0,1))
#dev.off()
#q()
#n
##Looks great. One pair which is a bit more extreme: ZAM43 and ZAM46 (TongaZam).

#Edit 20201209: in the initial processing of these samples I had kept that pair. However in a second stage (20200331) I removed them - this is what I do here.
##Edit 20200331: Following CS answer, decided to remove one of the two samples in the pair of "more than average" related individuals.
#mv zbantu8_fex.asd.dist.MDSplot.pdf zbantu8_fex.asd.dist.MDSplot.20200330.norelatednessfiltering.pdf #and moved to a tmp folder before next command - moved back afterwards.
#rm zbantu8*
##Select the sample with the highest missingness to exclude.
#grep ZAM43 zbantu7.imiss #0.00127
#grep ZAM46 zbantu7.imiss #0.001849 EXCLUDE

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

##MDS matrix based on allele sharing distances
#plink --bfile zbantu9_fex --recode --transpose --out zbantu9_fex
#/crex/proj/uppstore2018150/private/Programs/asd --tped zbantu9_fex.tped --tfam zbantu9_fex.tfam --out zbantu9_fex
#rm zbantu9_fex.t*
#
#R
#data <- read.table(file="zbantu9_fex.asd.dist",header=TRUE)
#fam <- read.table(file="zbantu9_fex.fam")
#data.mds<-cmdscale(data)
#pdf(file="zbantu9_fex.asd.dist.MDSplot.pdf", width=10, height=15, pointsize=12)
#plot(data.mds,col=as.factor(fam$V1),pch=20,asp=1,xlab=c(""),ylab=c(""),cex=2)
#title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
#legend("bottomright",legend=unique(fam$V1),pch=20,col=as.factor(unique(fam$V1)))
#dev.off()
#q()
#n
##Populations still undistinguishable (but maybe third axis would tell something). Axis 1: Lozi at both extremes, axis2: one Lozi versus one Bemba.

###
### MERGE THE TWO ZAMBIAN DATASETS
###
### I will merge the Batwa dataset with the fake to the Bantu-speakers dataset without the fake.
plink --bfile zbatwa10 --bmerge zbantu9_fex.bed zbantu9_fex.bim zbantu9_fex.fam --make-bed --out zbatwa10_zbantu9 # 2 variants with 3+ alleles present
plink --bfile zbantu9_fex --flip zbatwa10_zbantu9-merge.missnp --make-bed --out zbantu9_fexf
plink --bfile zbatwa10 --bmerge zbantu9_fexf.bed zbantu9_fexf.bim zbantu9_fexf.fam --make-bed --out zbatwa10_zbantu9_2
#missingness filter
plink --bfile zbatwa10_zbantu9_2 --geno 0.1 --make-bed --out zbatwa10_zbantu9_3
plink --bfile zbatwa10_zbantu9_3 --missing --out zbatwa10_zbantu9_3
sed  "s/ \+/\t/g" zbatwa10_zbantu9_3.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness in the Zambian Bantu-speakers samples

##remove fake individual for preliminary analyses of the Zambian samples alone
#plink --bfile zbatwa9_zbantu9_3 --remove fake_ex --make-bed --out zbatwa9_zbantu9_3_fex
#
##MDS matrix based on allele sharing distances
#plink --bfile zbatwa9_zbantu9_3_fex --recode --transpose --out zbatwa9_zbantu9_3_fex
#/crex/proj/uppstore2018150/private/Programs/asd --tped zbatwa9_zbantu9_3_fex.tped --tfam zbatwa9_zbantu9_3_fex.tfam --out zbatwa9_zbantu9_3_fex
#rm zbatwa9_zbantu9_3_fex.t*
#
#R
#data <- read.table(file="zbatwa9_zbantu9_3_fex.asd.dist",header=TRUE)
#fam <- read.table(file="zbatwa9_zbantu9_3_fex.fam")
#data.mds<-cmdscale(data)
#pdf(file="zbatwa9_zbantu9_3_fex.asd.dist.MDSplot.pdf", width=10, height=15, pointsize=12)
#plot(data.mds,col=as.factor(fam$V1),pch=20,asp=1,xlab=c(""),ylab=c(""),cex=2)
#title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
#legend("bottomright",legend=unique(fam$V1),pch=20,col=as.factor(unique(fam$V1)))
#dev.off()
#q()
#n
##Bangweulu and Kafue clearly distinguishable (both legs of a "V"), Bantu-speakers all grouped. Yay!

###
### Merge with Omni2.5 datasets
###

# Comments: This section includes processing steps prior to merging (e.g. downsampling and relatedness).
#I have to prepare the data first. The data in /proj/snic2020-2-10/uppstore2017249/DATA/ has been filtered for --geno 0.05 (in the _Filtered folders that is). I think it is filtered for relatedness but I will check nevertheless. Fix the variants names as well (to chr-position).
# Also: downsample populations to 36 individuals (the max in my dataset).
# Edit 20200416: I will perform the HWE filtering step to identify batch errors (sequencing) in the comparative datasets too. For each dataset: split filesets into populations (at least two, if there are more than two populations it is not necessary to do it for more than two - possibly three); HWE; exclude overlap.
# Edit 20201209: I need to remove the "Schuster San" sample and to combine the Khomani and ColouredAshkham (both concern the Schlebusch 2012 dataset). 

#####
##### Schlebusch 2012
#####

###Prepare
##Remove the Schusster San sample
##the .kin0 file shows no related sample
##the names of the SNP are already fine! :)
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Comparative_data/Omni2.5/Schlebusch_2012/
cp -r /proj/snic2020-2-10/uppstore2017249/DATA/Schlebusch_2012/Schlebusch_2012_Filtered/ .
grep schus Schlebusch_2012_Filtered/Schlebusch_2012.fam > schus_toexclude
plink --bfile Schlebusch_2012_Filtered/Schlebusch_2012 --remove schus_toexclude --biallelic-only strict --make-bed --out Schlebusch_2012_Filtered/Schlebusch_2012_2
##Modify the .fam to group the ColouredAskham and the Khomani
cp Schlebusch_2012_Filtered/Schlebusch_2012_2.fam Schlebusch_2012_Filtered/Schlebusch_2012_2.fam_original
sed 's/ColouredAskham/Khomani/g' < Schlebusch_2012_Filtered/Schlebusch_2012_2.fam_original > Schlebusch_2012_Filtered/Schlebusch_2012_2.fam

##the SNP already have the right name.
##geno 0.05 filter
##related samples removed
##check duplicate SNPs
#infile="Schlebusch_2012"
#cut -f2 ${infile}.bim | sort > with_dup
##create a col 2 containing no dupl SNPs using the uniq function
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

##Relatedness filter (was not applied in Oct2018)
#mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data
#mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5
#mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Schlebusch_2012
#mkdir /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered
#cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered
#cp /proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.b* .
#cp /proj/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.fam .

#plink --bfile Schlebusch_2012 --missing --out Schlebusch_2012
#grep KSP096 Schlebusch_2012.imiss
#grep KSP226 Schlebusch_2012.imiss
##0 missingness for both - are these imputed?
##Decided to keep KSP096 since we kept it for the sequencing project.

cd Schlebusch_2012_Filtered/
for ind in KSP226 ; do grep ${ind} Schlebusch_2012_2.fam >> related_ex; done
plink --bfile Schlebusch_2012_2 --remove related_ex --make-bed --out Schlebusch_2012_3
rm related_ex

##HWE filter (20200416)
##One fileset for each population - if more than two populations, choose the two populations with the largest number of individuals.
#infile=Schlebusch_2012_2
#cut -f1 -d" " ${infile}.fam| sort| uniq -c|sort -n
#pop1=Khwe
#pop2=SEBantu
#grep ${pop1} ${infile}.fam > ${pop1}
#grep ${pop2} ${infile}.fam > ${pop2}
#plink --bfile ${infile} --keep ${pop1} --make-bed --out ${infile}${pop1}
#plink --bfile ${infile} --keep ${pop2} --make-bed --out ${infile}${pop2}
##HWE in each fileset
#plink --bfile ${infile}${pop1} --hwe 0.001 --make-bed --out ${infile}${pop1}hwe #269 excluded
#plink --bfile ${infile}${pop2} --hwe 0.001 --make-bed --out ${infile}${pop2}hwe #292
##Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
#cut -f2 ${infile}${pop1}hwe.bim > ${infile}${pop1}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hwe_variants --make-bed --out ${infile}${pop1}hweexcl
#cut -f2 ${infile}${pop2}hwe.bim > ${infile}${pop2}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop2}hwe_variants --make-bed --out ${infile}${pop2}hweexcl
##Find overlap between ${infile}${pop1}hweexcl.bim and ${infile}${pop2}hweexcl.bim
#cut -f2 ${infile}${pop2}hweexcl.bim > ${infile}${pop2}hweexcl_variants
#plink --bfile ${infile}${pop1}hweexcl --extract ${infile}${pop2}hweexcl_variants --make-bed --out ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl #0
##Confirm with the other set:
#cut -f2 ${infile}${pop1}hweexcl.bim > ${infile}${pop1}hweexcl_variants
#plink --bfile ${infile}${pop2}hweexcl --extract ${infile}${pop1}hweexcl_variants --make-bed --out ${infile}${pop2}hweexcl-extract${infile}${pop1}hweexcl #0
##Finally, exclude these SNP
##outfile=XXX
##cut -f2 ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl.bim > ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants
##plink --bfile ${infile} --exclude ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants --make-bed --out ${outfile}

#### Merge with Schlebusch2012
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
plink --bfile zbatwa10_zbantu9_3 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012 #2807 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3 --flip zbatwa10_zbantu9_Schlebusch2012-merge.missnp --make-bed --out Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3f
plink --bfile zbatwa10_zbantu9_3 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3f.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3f.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3f.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_2 #9 variants with 3+ alleles present
plink --bfile Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3f --exclude zbatwa10_zbantu9_Schlebusch2012_2-merge.missnp --make-bed --out Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3fe
plink --bfile zbatwa10_zbantu9_3 --bmerge Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3fe.bed Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3fe.bim Comparative_data/Omni2.5/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012_3fe.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_3
#missingness filter
plink --bfile zbatwa10_zbantu9_Schlebusch2012_3 --geno 0.1 --make-bed --out zbatwa10_zbantu9_Schlebusch2012_4
plink --bfile zbatwa10_zbantu9_Schlebusch2012_4 --missing --out zbatwa10_zbantu9_Schlebusch2012_4
sed  "s/ \+/\t/g" zbatwa10_zbantu9_Schlebusch2012_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness in the Zambian samples (Lozi, Tonga)
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

#HWE filter (20200416)
#One fileset for each population - if more than two populations, choose the two populations with the largest number of individuals.
#infile=1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_7
#cut -f1 -d" " ${infile}.fam| sort| uniq -c|sort -n
#pop1=CHB
#pop2=YRI
#grep ${pop1} ${infile}.fam > ${pop1}
#grep ${pop2} ${infile}.fam > ${pop2}
#plink --bfile ${infile} --keep ${pop1} --make-bed --out ${infile}${pop1}
#plink --bfile ${infile} --keep ${pop2} --make-bed --out ${infile}${pop2}
##HWE in each fileset
#plink --bfile ${infile}${pop1} --hwe 0.001 --make-bed --out ${infile}${pop1}hwe #597 excluded
#plink --bfile ${infile}${pop2} --hwe 0.001 --make-bed --out ${infile}${pop2}hwe #763
##Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
#cut -f2 ${infile}${pop1}hwe.bim > ${infile}${pop1}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hwe_variants --make-bed --out ${infile}${pop1}hweexcl
#cut -f2 ${infile}${pop2}hwe.bim > ${infile}${pop2}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop2}hwe_variants --make-bed --out ${infile}${pop2}hweexcl
##Find overlap between ${infile}${pop1}hweexcl.bim and ${infile}${pop2}hweexcl.bim
#cut -f2 ${infile}${pop2}hweexcl.bim > ${infile}${pop2}hweexcl_variants
#plink --bfile ${infile}${pop1}hweexcl --extract ${infile}${pop2}hweexcl_variants --make-bed --out ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl #15
##Confirm with the other set:
#cut -f2 ${infile}${pop1}hweexcl.bim > ${infile}${pop1}hweexcl_variants
#plink --bfile ${infile}${pop2}hweexcl --extract ${infile}${pop1}hweexcl_variants --make-bed --out ${infile}${pop2}hweexcl-extract${infile}${pop1}hweexcl #15
##Finally, exclude these SNP
#outfile=1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8
#cut -f2 ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl.bim > ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants --make-bed --out ${outfile}

#### Merge with 1KGP (subset)
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/1KGP_2015
plink --bfile zbatwa10_zbantu9_Schlebusch2012_4 --bmerge ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8.bed ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8.bim ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173 #91423 variants with 3+ alleles present
folder2=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Comparative_data/Omni2.5/1KGP_2015
plink --bfile ${folder}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8 --flip zbatwa10_zbantu9_Schlebusch2012_1KGP173-merge.missnp --make-bed --out ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8f
plink --bfile zbatwa10_zbantu9_Schlebusch2012_4 --bmerge ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8f.bed ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8f.bim ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8f.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_2 #85
plink --bfile ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8f --exclude zbatwa10_zbantu9_Schlebusch2012_1KGP173_2-merge.missnp --make-bed --out ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8fe
plink --bfile zbatwa10_zbantu9_Schlebusch2012_4 --bmerge ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8fe.bed ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8fe.bim ${folder2}/1000Genomes_final_onlyAutosomal_onlyCEU_CHB_YRI_LWK_MKK_8fe.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_3
#missingness filter
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_3 --geno 0.1 --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_4
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_4 --missing --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_4
sed  "s/ \+/\t/g" zbatwa10_zbantu9_Schlebusch2012_1KGP173_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #now the samples with the highest missingness are KGP samples (and one Lozi).

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

##HWE filter (20200416)
##One fileset for each population - if more than two populations, choose the two populations with the largest number of individuals.
#infile=random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_3
#cut -f1 -d" " ${infile}.fam| sort| uniq -c|sort -n
#pop1=Zulu
#pop2=Somali
#grep ${pop1} ${infile}.fam > ${pop1}
#grep ${pop2} ${infile}.fam > ${pop2}
#plink --bfile ${infile} --keep ${pop1} --make-bed --out ${infile}${pop1}
#plink --bfile ${infile} --keep ${pop2} --make-bed --out ${infile}${pop2}
##HWE in each fileset
#plink --bfile ${infile}${pop1} --hwe 0.001 --make-bed --out ${infile}${pop1}hwe #3192 excluded
#plink --bfile ${infile}${pop2} --hwe 0.001 --make-bed --out ${infile}${pop2}hwe #628
##Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
#cut -f2 ${infile}${pop1}hwe.bim > ${infile}${pop1}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hwe_variants --make-bed --out ${infile}${pop1}hweexcl
#cut -f2 ${infile}${pop2}hwe.bim > ${infile}${pop2}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop2}hwe_variants --make-bed --out ${infile}${pop2}hweexcl
##Find overlap between ${infile}${pop1}hweexcl.bim and ${infile}${pop2}hweexcl.bim
#cut -f2 ${infile}${pop2}hweexcl.bim > ${infile}${pop2}hweexcl_variants
#plink --bfile ${infile}${pop1}hweexcl --extract ${infile}${pop2}hweexcl_variants --make-bed --out ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl #3
##Confirm with the other set:
#cut -f2 ${infile}${pop1}hweexcl.bim > ${infile}${pop1}hweexcl_variants
#plink --bfile ${infile}${pop2}hweexcl --extract ${infile}${pop1}hweexcl_variants --make-bed --out ${infile}${pop2}hweexcl-extract${infile}${pop1}hweexcl #3
##Finally, exclude these SNP
#outfile=random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4
#cut -f2 ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl.bim > ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants --make-bed --out ${outfile}

#### Merge with Gurdasani
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Gurdasani_2015
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_4 --bmerge ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4.bed ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4.bim ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242 #74714 variants with 3+ alleles present
folder2=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Comparative_data/Omni2.5/Gurdasani_2015
plink --bfile ${folder}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4 --flip zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242-merge.missnp --make-bed --out ${folder2}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4f
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_4 --bmerge ${folder2}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4f.bed ${folder2}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4f.bim ${folder2}/random_Amhara36_Oromo26_Somali36_Sotho36_Igbo36_Zulu36_Mandinka36_4f.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_2 #

#missingness filter
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_2 --geno 0.1 --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3 --missing --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3
sed  "s/ \+/\t/g" zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3.imiss | sed  "s/^\t//g" | sort -k6 | tail #now the samples with the highest missingness are KGP and Gurdasani samples.

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

##HWE filter (20200416)
##One fileset for each population - if more than two populations, choose the two populations with the largest number of individuals.
#infile=random_Sara36_Toubou35_2
##cut -f1 -d" " ${infile}.fam| sort| uniq -c|sort -n
#pop1=Sara
#pop2=Toubou
#grep ${pop1} ${infile}.fam > ${pop1}
#grep ${pop2} ${infile}.fam > ${pop2}
#plink --bfile ${infile} --keep ${pop1} --make-bed --out ${infile}${pop1}
#plink --bfile ${infile} --keep ${pop2} --make-bed --out ${infile}${pop2}
##HWE in each fileset
#plink --bfile ${infile}${pop1} --hwe 0.001 --make-bed --out ${infile}${pop1}hwe #457 excluded
#plink --bfile ${infile}${pop2} --hwe 0.001 --make-bed --out ${infile}${pop2}hwe #502
##Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
#cut -f2 ${infile}${pop1}hwe.bim > ${infile}${pop1}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hwe_variants --make-bed --out ${infile}${pop1}hweexcl
#cut -f2 ${infile}${pop2}hwe.bim > ${infile}${pop2}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop2}hwe_variants --make-bed --out ${infile}${pop2}hweexcl
##Find overlap between ${infile}${pop1}hweexcl.bim and ${infile}${pop2}hweexcl.bim
#cut -f2 ${infile}${pop2}hweexcl.bim > ${infile}${pop2}hweexcl_variants
#plink --bfile ${infile}${pop1}hweexcl --extract ${infile}${pop2}hweexcl_variants --make-bed --out ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl #2
##Confirm with the other set:
#cut -f2 ${infile}${pop1}hweexcl.bim > ${infile}${pop1}hweexcl_variants
#plink --bfile ${infile}${pop2}hweexcl --extract ${infile}${pop1}hweexcl_variants --make-bed --out ${infile}${pop2}hweexcl-extract${infile}${pop1}hweexcl #2
##Finally, exclude these SNP
#outfile=random_Sara36_Toubou35_3
#cut -f2 ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl.bim > ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants --make-bed --out ${outfile}

### Merge with Haber
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni2.5/Haber_2016*
folder2=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Comparative_data/Omni2.5/Haber_2016
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3 --bmerge ${folder}/random_Sara36_Toubou35_3.bed ${folder}/random_Sara36_Toubou35_3.bim ${folder}/random_Sara36_Toubou35_3.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71 #588880
plink --bfile ${folder}/random_Sara36_Toubou35_3 --flip zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71-merge.missnp --make-bed --out ${folder2}/random_Sara36_Toubou35_3f
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_3 --bmerge ${folder2}/random_Sara36_Toubou35_3f.bed ${folder2}/random_Sara36_Toubou35_3f.bim ${folder2}/random_Sara36_Toubou35_3f.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_2
#missingness filter
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_2 --geno 0.1 --biallelic-only strict --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --missing --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3
sed  "s/ \+/\t/g" zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.imiss | sed  "s/^\t//g" | sort -k6 | tail #Samples with highest missingness are Haber 2016 samples.

### Exclude the fake(s) (for analyses).
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --remove zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex

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

##HWE filter (20200416)
##One fileset for each population - if more than two populations, choose the two populations with the largest number of individuals.
#infile=Patin207_3
#cut -f1 -d" " ${infile}.fam| sort| uniq -c|sort -n
#pop1=Baka_Cam
#pop2=Nzime_Cam
#grep ${pop1} ${infile}.fam > ${pop1}
#grep ${pop2} ${infile}.fam > ${pop2}
#plink --bfile ${infile} --keep ${pop1} --make-bed --out ${infile}${pop1}
#plink --bfile ${infile} --keep ${pop2} --make-bed --out ${infile}${pop2}
##HWE in each fileset
#plink --bfile ${infile}${pop1} --hwe 0.001 --make-bed --out ${infile}${pop1}hwe #357 excluded
#plink --bfile ${infile}${pop2} --hwe 0.001 --make-bed --out ${infile}${pop2}hwe #339
##Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
#cut -f2 ${infile}${pop1}hwe.bim > ${infile}${pop1}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hwe_variants --make-bed --out ${infile}${pop1}hweexcl
#cut -f2 ${infile}${pop2}hwe.bim > ${infile}${pop2}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop2}hwe_variants --make-bed --out ${infile}${pop2}hweexcl
##Find overlap between ${infile}${pop1}hweexcl.bim and ${infile}${pop2}hweexcl.bim
#cut -f2 ${infile}${pop2}hweexcl.bim > ${infile}${pop2}hweexcl_variants
#plink --bfile ${infile}${pop1}hweexcl --extract ${infile}${pop2}hweexcl_variants --make-bed --out ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl #41
##Confirm with the other set:
#cut -f2 ${infile}${pop1}hweexcl.bim > ${infile}${pop1}hweexcl_variants
#plink --bfile ${infile}${pop2}hweexcl --extract ${infile}${pop1}hweexcl_variants --make-bed --out ${infile}${pop2}hweexcl-extract${infile}${pop1}hweexcl #41
##Finally, exclude these SNP
#outfile=Patin207_4
#cut -f2 ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl.bim > ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants --make-bed --out ${outfile}

#### Merge
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Patin_2014
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge ${folder}/Patin207_4.bed ${folder}/Patin207_4.bim ${folder}/Patin207_4.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207 #5757
folder2=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Comparative_data/Omni1/Patin_2014
plink --bfile ${folder}/Patin207_4 --flip zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207-merge.missnp --make-bed --out ${folder2}/Patin207_4f
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge ${folder2}/Patin207_4f.bed ${folder2}/Patin207_4f.bim ${folder2}/Patin207_4f.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_2 #16
plink --bfile ${folder2}/Patin207_4f --exclude zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_2-merge.missnp --make-bed --out ${folder2}/Patin207_4fe
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3 --bmerge ${folder2}/Patin207_4fe.bed ${folder2}/Patin207_4fe.bim ${folder2}/Patin207_4fe.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_3
#Missingness
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_3 --geno 0.1 --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --missing --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4
sed  "s/ \+/\t/g" zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #mix (Haber, Patin, 1KGP)

#####
##### Scheinfeldt 2019
#####
## I decided to start with the "Raw" not the Filtered (for the rest of the dataset I started with the Filtered). The difference should be a --geno and a --hwe filter.
## I won't have to downsample (less than 36 individuals in each population).
#/crex/proj/uppstore2017249/DATA/Scheinfeldt_2019/Scheinfeldt_2019_Raw
#cd /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Scheinfeldt_2019
#cp /crex/proj/uppstore2017249/DATA/Scheinfeldt_2019/Scheinfeldt_2019_Raw/Scheinfeldt_2019.b* . ; cp /crex/proj/uppstore2017249/DATA/Scheinfeldt_2019/Scheinfeldt_2019_Raw/Scheinfeldt_2019.fam .
#
##### Prepare
#
##Select the Ethiopia_Sabue, Tanzania_Hadza and Sudan_Dinka
#grep -e Ethiopia_Sabue -e Tanzania_Hadza -e Sudan_Dinka Scheinfeldt_2019.fam > Sabue_Hadza_Dinka
#plink --bfile Scheinfeldt_2019 --keep Sabue_Hadza_Dinka --make-bed --out Scheinfeldt_2019_Sabue_Hadza_Dinka
##Missingness filtering
#plink --bfile Scheinfeldt_2019_Sabue_Hadza_Dinka --geno 0.1 --mind 0.1 --make-bed --out Scheinfeldt_2019_Sabue_Hadza_Dinka_2
##Rename SNPs to chr-pos 
#infile="Scheinfeldt_2019_Sabue_Hadza_Dinka_2"
#cut -f1,4 ${infile}.bim | sed "s/\t/-/g" > mid
#cut -f1 ${infile}.bim > first
#cut -f3- ${infile}.bim > last
#paste first mid last > ${infile}.bim
##Remove duplicate snps
#cut -f2 ${infile}.bim | sort > with_dup
#cut -f2 ${infile}.bim | sort | uniq | sort | uniq > wo_dup
#comm -23 with_dup wo_dup > dupl #None!
##Relatedness
#/proj/uppstore2017249/DATA/king -b Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bed --kinship --prefix /proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Scheinfeldt_2019/Scheinfeldt_2019_Sabue_Hadza_Dinka_2
#R
#data <- read.table("Scheinfeldt_2019_Sabue_Hadza_Dinka_2.kin",header=TRUE) #accross families
#summary(data)
#write.table(data[data$Kinship>=0.0442 & data$Kinship<0.0884 ,],file="Scheinfeldt_2019_Sabue_Hadza_Dinka_2_kin.3degreerel") #16 pairs
#write.table(data[data$Kinship>=0.0884 & data$Kinship<0.177 ,],file="Scheinfeldt_2019_Sabue_Hadza_Dinka_2_kin.2degreerel") #0
#write.table(data[data$Kinship>=0.177 & data$Kinship<0.354 ,],file="Scheinfeldt_2019_Sabue_Hadza_Dinka_2_kin.1degreerel") #0
#q()
#n
##I am not going to exclude anyone due to relatedness (only third degree).
##Flip ATCG
#rm ATCGlist; touch ATCGlist
#grep -P "\tA\tT" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
#grep -P "\tT\tA" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
#grep -P "\tC\tG" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
#grep -P "\tG\tC" Scheinfeldt_2019_Sabue_Hadza_Dinka_2.bim >> ATCGlist
#plink --bfile Scheinfeldt_2019_Sabue_Hadza_Dinka_2 --exclude ATCGlist --make-bed --out Scheinfeldt_2019_Sabue_Hadza_Dinka_3
#
##HWE filter (20200416)
##One fileset for each population - if more than two populations, choose the two populations with the largest number of individuals.
#infile=Scheinfeldt_2019_Sabue_Hadza_Dinka_3
#cut -f1 -d" " ${infile}.fam| sort| uniq -c|sort -n
#pop1=Ethiopia_Sabue
#pop2=Tanzania_Hadza
#grep ${pop1} ${infile}.fam > ${pop1}
#grep ${pop2} ${infile}.fam > ${pop2}
#plink --bfile ${infile} --keep ${pop1} --make-bed --out ${infile}${pop1}
#plink --bfile ${infile} --keep ${pop2} --make-bed --out ${infile}${pop2}
##HWE in each fileset
#plink --bfile ${infile}${pop1} --hwe 0.001 --make-bed --out ${infile}${pop1}hwe #101 excluded
#plink --bfile ${infile}${pop2} --hwe 0.001 --make-bed --out ${infile}${pop2}hwe #363
##Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
#cut -f2 ${infile}${pop1}hwe.bim > ${infile}${pop1}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hwe_variants --make-bed --out ${infile}${pop1}hweexcl
#cut -f2 ${infile}${pop2}hwe.bim > ${infile}${pop2}hwe_variants
#plink --bfile ${infile} --exclude ${infile}${pop2}hwe_variants --make-bed --out ${infile}${pop2}hweexcl
##Find overlap between ${infile}${pop1}hweexcl.bim and ${infile}${pop2}hweexcl.bim
#cut -f2 ${infile}${pop2}hweexcl.bim > ${infile}${pop2}hweexcl_variants
#plink --bfile ${infile}${pop1}hweexcl --extract ${infile}${pop2}hweexcl_variants --make-bed --out ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl #10
##Confirm with the other set:
#cut -f2 ${infile}${pop1}hweexcl.bim > ${infile}${pop1}hweexcl_variants
#plink --bfile ${infile}${pop2}hweexcl --extract ${infile}${pop1}hweexcl_variants --make-bed --out ${infile}${pop2}hweexcl-extract${infile}${pop1}hweexcl #10
##Finally, exclude these SNP
#outfile=Scheinfeldt_2019_Sabue_Hadza_Dinka_4
#cut -f2 ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl.bim > ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants
#plink --bfile ${infile} --exclude ${infile}${pop1}hweexcl-extract${infile}${pop2}hweexcl_variants --make-bed --out ${outfile}

#### Merge
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_March2020/Comparative_data/Omni1/Scheinfeldt_2019
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --bmerge ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4.bed ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4.bim ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52 #58207
folder2=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Comparative_data/Omni1/Scheinfeldt_2019
plink --bfile ${folder}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4 --flip zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52-merge.missnp --make-bed --out ${folder2}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4f
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4 --bmerge ${folder2}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4f.bed ${folder2}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4f.bim ${folder2}/Scheinfeldt_2019_Sabue_Hadza_Dinka_4f.fam --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_2
#Missingness
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_2 --geno 0.1 --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3 --missing --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3
sed  "s/ \+/\t/g" zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3.imiss | sed  "s/^\t//g" | sort -k6 | tail -n 55 #highest missingness in the Scheinfeldt data. They all have ~0.25 missingness. I suppose this means they have a different set of variants. I need a more stringent variant filtering. 0.05 should do.
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_3 --geno 0.05 --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --missing --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4
sed  "s/ \+/\t/g" zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #Looks much better.

###Remove fake(s) (for analyses).
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --remove zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex

### See 20201210_analyses.sh for PCA, ADMIXTURE, f4 ratio, ROH.

#TODO when using the Patin dataset (in particular): be careful with naming!!! (Baka) (I do not remember exactly when the naming was an issue though).

### Phasing
#Based on 20200421_phase_impute_MOSAIC.sh

###### USEFUL ################
module load bioinfo-tools SHAPEIT/v2.r904
module load bioinfo-tools plink/1.90b4.9
##############################

# Genetic map (recommended by CFL and MV)
/proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/ # 'combined'

# KGP haplotype data in the right format for IMPUTE2 (includes genetic maps - not sure where they come from).
/proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/

# My input data (plink binary fileset).
/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex

# Prepare the data.
#See steps in http://www.griv.org/shapeit/pages/documentation.html. I have already performed the relevant ones (i.e. missingness filtering). The only thing left is to split by chromosome.
input=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
output=/proj/snic2020-2-10/uppstore2018150/private/tmp/20201210_phasing/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
for chr in $(seq 1 22) ; do plink --bfile ${input} --chr $chr --make-bed --out ${output}_chr$chr ; done

# Alignment of the SNPs between the GWAS dataset and the reference panel.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201210_phasing
chr=1
REF_DATASET=/proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3_chr
BED=/proj/snic2020-2-10/uppstore2018150/private/tmp/20201210_phasing/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr
GENETIC_MAP=/proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_chr
shapeit -check \
        -B ${BED}${chr} \
        -M ${GENETIC_MAP}${chr}_combined_b37.txt \
        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
        --output-log ${BED}${chr}.alignments
cut -f4 ${BED}${chr}.alignments.snp.strand | grep -v "main_A" | sort | uniq > ${BED}${chr}.alignments.snp.strand.flip
plink --bfile ${BED}${chr} --flip ${BED}${chr}.alignments.snp.strand.flip --make-bed --out ${BED}${chr}f
shapeit -check \
        -B ${BED}${chr}f \
        -M ${GENETIC_MAP}${chr}_combined_b37.txt \
        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
        --output-log ${BED}${chr}f.alignments

##The command below is an extra check - run it only if phasing does not start!
#shapeit -check \
#        -B ${BED}${chr}f \
#        -M ${GENETIC_MAP}${chr}_combined_b37.txt \
#        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
#        --exclude-snp ${BED}${chr}f.alignments.snp.strand.exclude

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201210_phasing/log
(echo '#!/bin/bash -l'
echo "chr=${chr}"
echo 'module load bioinfo-tools SHAPEIT/v2.r904
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/20201210_phasing
REF_DATASET=/proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3_chr
BED=/proj/snic2020-2-10/uppstore2018150/private/tmp/20201210_phasing/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr
GENETIC_MAP=/proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_chr
shapeit -B ${BED}${chr}f -M ${GENETIC_MAP}${chr}_combined_b37.txt --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample --exclude-snp ${BED}${chr}f.alignments.snp.strand.exclude -T 2 -W 0.5 --output-graph ${BED}${chr}f.phased_withKGP.graph --output-log ${BED}${chr}f.phased_withKGP.graph
shapeit -convert --input-graph ${BED}${chr}f.phased_withKGP.graph --output-max ${BED}${chr}f.phased_withKGP --output-log ${BED}${chr}f.phased_withKGP
shapeit -convert --input-haps ${BED}${chr}f.phased_withKGP --output-vcf ${BED}${chr}f.phased_withKGP.vcf
exit 0') | sbatch -p core -n 2 -t 24:0:0 -A snic2018-8-397 -J phasing_chr${chr}bis -o phasing_chr${chr}bis.output -e phasing_chr${chr}bis.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL


###
### Merge with ancient data (goal: PCA, ADMIXTURE) (2021-01-08)
###

##1## Extract the relevant ancient samples from the plink file prepared by MV (I am keeping all ancient samples except for three: the Egyptian and the two Moroccans).
# Location of the files: /proj/snic2020-2-10/uppstore2019041/private/Flo_merging/Flo_aDNA_AfricaHG/AfricaH
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
interactive -p core -n 1 -A snic2018-8-397 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9
infile=/proj/snic2020-2-10/uppstore2019041/private/Flo_merging/Flo_aDNA_AfricaHG/AfricaH
grep -e baa -e bab -e Kenya_ -e cha -e ela -e I9028 -e I9133 -e I9134 -e Malawi -e mfo -e Mota -e new -e Shum -e Tanzania ${infile}.fam > ancient_keep #total of 47 ancient samples.
plink --bfile ${infile} --keep ancient_keep --make-bed --out ancient_subsaharan #183306 variants and 47 people; 0.58 genotyping rate.
plink --bfile ancient_subsaharan --geno 0.1 --make-bed --out ancient_subsaharan2 #only 20 variants remain > this is clearly too stringent.
plink --bfile ancient_subsaharan --geno 0.2 --make-bed --out ancient_subsaharan2 #3356 variants
rm ancient_subsaharan2*
#I need to replace the underscore in the .bim by a "-" (to match what I have in my .bim).
cp ancient_subsaharan.bim ancient_subsaharan.bim_original
tr "_" "-" < ancient_subsaharan.bim > tmp; mv tmp ancient_subsaharan.bim

##2## Merge with my final plink file (Omni1)
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --bmerge ancient_subsaharan.bed ancient_subsaharan.bim ancient_subsaharan.fam --make-bed --out omni1finalmerge_ancient #Caution! Here I changed the name of my Omni1 merge because it was very cumbersome.
#Apparently, 159,297 variants in common! Great.
plink --bfile ancient_subsaharan --flip omni1finalmerge_ancient-merge.missnp --make-bed --out ancient_subsaharanf
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --bmerge ancient_subsaharanf.bed ancient_subsaharanf.bim ancient_subsaharanf.fam --make-bed --out omni1finalmerge_ancient2 #Apparently I need to allow for no sex.
plink --bfile zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4 --bmerge ancient_subsaharanf.bed ancient_subsaharanf.bim ancient_subsaharanf.fam --allow-no-sex --make-bed --out omni1finalmerge_ancient3 #1022 individuals (including two fakes). Variants found only in the ancient samples will have a missingness of at least (1022-47)/1022=0.954 (not sure how the haploid/diploid state influence that).
plink --bfile omni1finalmerge_ancient3 --geno 0.954 --make-bed --out omni1finalmerge_ancient4 #Yes! (it removed exactly the number of variants found only in ancient_subsaharan)
plink --bfile omni1finalmerge_ancient4 --remove zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3.fake --make-bed --out omni1finalmerge_ancient4fex

##3## Haplodize the data (using the script that MV gave me).
plink --bfile omni1finalmerge_ancient4fex --recode transpose --out omni1finalmerge_ancient4fex
module load bioinfo-tools python/2.7.6
python ../../scripts/haploidize_tped.py < omni1finalmerge_ancient4fex.tped > omni1finalmerge_ancient4fexhap.tped

#Caution! TPED is not a valid format for smartpca. Maybe I need to convert from TPED to PED?
cp omni1finalmerge_ancient4fex.tfam omni1finalmerge_ancient4fexhap.tfam
plink --tfile omni1finalmerge_ancient4fexhap --recode --out omni1finalmerge_ancient4fexhap

##4## Test PCA (no filtering for LD nor genotyping rate at this stage).
#Basing my script on "run_pca_projectBBA.sh" from KS genome project.

root=omni1finalmerge_ancient4fexhap
cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
#set: killr2 YES, r2thresh 0.2, numoutlier 0, popsizelimit 36
#TODO play with killr2, LD pruning with plink etc. For now I am doing the same thing like I did for earlier PCAs.
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_ancientprojected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > temppar2
echo -e 'poplistname:\tpop_omni1' >> temppar2
mv temppar2 ${root}_killr20.2_popsize36_ancientprojected.par 
rm temppar
cut -d" " -f1-5 ${root}.tfam >file1a
cut -d" " -f1 ${root}.tfam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb
#Caution! I modified manually the par file to change bed and bim to ped and map.

cd /proj/snic2020-2-10/uppstore2018150/private/scripts/bashout/PCA
(echo '#!/bin/bash -l'
echo "
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=omni1finalmerge_ancient4fexhap
smartpca -p ${root}_killr20.2_popsize36_ancientprojected.par > ${root}_killr20.2_popsize36_ancientprojected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 30:0  -A snic2018-8-397 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

###20210211
###Prepare modern+ancient set for ADMIXTURE: filter for LD. Testing the settings in Alex Papers I and II.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
root=omni1finalmerge_ancient4fexhap_2 #That file has a site and individual missingness filter, --geno 0.15 --mind 0.956, see 20201210_analyses.sh
#I could also use the African only fileset, but I do not think that it is necessary here.
plink --bfile ${root} --indep-pairwise 200 25 0.4 --make-bed --out ${root}_ld200-25-0.4 --allow-no-sex #2818 of 344644 variants removed: very little!
plink --bfile ${root} --extract ${root}_ld200-25-0.4.prune.in --make-bed --out ${root}_ld200-25-0.4 --allow-no-sex

#LD filter for my Omni1 (modern) dataset: 50 10 0.1
plink --bfile ${root} --indep-pairwise 50 10 0.1 --out ${root}_ld50-10-0.1 --allow-no-sex #101011 of 344644 variants removed. Still ~240,000 remaining -> quite ok. I will test ADMIXTURE with that because it would make it easier to have a single LD filtering threshold!
plink --bfile ${root} --extract ${root}_ld50-10-0.1.prune.in --make-bed --out ${root}_ld50-10-0.1 --allow-no-sex






