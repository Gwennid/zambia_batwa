###
### Process the X chromosome.
###
#Comment: I should have kept it and processed it together with the autosomes, it would have saved time. But it is as it is! Remove the same individuals and go through the same filtering steps.
#Edit 20210121: I have realized that I do not have the X chromosome for most of the comparative datasets, and thus I will need a different autosomal dataset. Thus I decided to reprocess -for the datasets that I have, i.e. Zambian BaTwa and Bantu, Schlebusch 2012, KGP and Patin 2014 (to which I will perhaps, later, add Pagani 2015)- from the beginning, both autosomes and chrX together (it represents extra work only for the two Zambian datasets that I have already prepared). Fingers crossed!

interactive -p core -n 1 -A snic2018-8-397 -t 4:0:0
module load bioinfo-tools plink/1.90b4.9

###
###BaTwa
###
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021

#exclude 0, mitochondria, chrY and XY variants
rm exlist; touch exlist
grep -P "^0\t" ../preparedata_Oct2018/zbatwa1.bim >> exlist
grep -P "^24\t" ../preparedata_Oct2018/zbatwa1.bim >> exlist #Y
grep -P "^25\t" ../preparedata_Oct2018/zbatwa1.bim >> exlist #XY
grep -P "^26\t" ../preparedata_Oct2018/zbatwa1.bim >> exlist #MT

plink --bfile ../preparedata_Oct2018/zbatwa1f --exclude exlist --make-bed --out zbatwa1-23_1 #2,260,358 variants and 81 people

##exclude indels
rm indellist; touch indellist
root=zbatwa1-23_
grep -P "\tI" ${root}1.bim >> indellist
grep -P  "\tD" ${root}1.bim >> indellist
plink --bfile ${root}1 --exclude indellist --make-bed --out ${root}2 #2259941 variants and 81 people

##SNP missingness filter
plink --bfile ${root}2 --geno 0.1 --biallelic-only strict --make-bed --out ${root}3 #2247228

##HWE filter
#One fileset for each population
grep B ${root}3.fam > Bangweulu
grep K ${root}3.fam > Kafue
plink --bfile ${root}3 --keep Bangweulu --make-bed --out ${root}3B
plink --bfile ${root}3 --keep Kafue --make-bed --out ${root}3K
#HWE in each fileset
plink --bfile ${root}3B --hwe 0.001 --make-bed --out ${root}3Bhwe
plink --bfile ${root}3K --hwe 0.001 --make-bed --out ${root}3Khwe
#Apparently for the X chromosome I might want to use a less stringent threshold.
#Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
cut -f2 ${root}3Bhwe.bim > ${root}3Bhwe_variants
plink --bfile ${root}3 --exclude ${root}3Bhwe_variants --make-bed --out ${root}3Bhweexcl
cut -f2 ${root}3Khwe.bim > ${root}3Khwe_variants
plink --bfile ${root}3 --exclude ${root}3Khwe_variants --make-bed --out ${root}3Khweexcl
#Find overlap between ${root}3Bhweexcl.bim and ${root}3Khweexcl.bim
cut -f2 ${root}3Khweexcl.bim > ${root}3Khweexcl_variants
plink --bfile ${root}3Bhweexcl --extract ${root}3Khweexcl_variants --make-bed --out ${root}3Bhweexcl-extract${root}3Khweexcl #1701 variants
#do the reverse to check that we get the same
cut -f2 ${root}3Bhweexcl.bim > ${root}3Bhweexcl_variants
plink --bfile ${root}3Khweexcl --extract ${root}3Bhweexcl_variants --make-bed --out ${root}3Khweexcl-extract${root}3Bhweexcl  #1701
#Finally, exclude these SNP
cut -f2 ${root}3Bhweexcl-extract${root}3Khweexcl.bim > ${root}3Bhweexcl-extract${root}3Khweexcl_variants
plink --bfile ${root}3 --exclude ${root}3Bhweexcl-extract${root}3Khweexcl_variants --make-bed --out ${root}4 #2245527 variants and 81 people

##Individual missingness filter
plink --bfile ${root}4 --mind 0.1 --make-bed --out ${root}5
##Autosomes: one individual is removed (K-12). Same for chr X.

##Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898 
cut -f1,4 ${root}5.bim | sed "s/\t/-/g" > mid
cut -f1 ${root}5.bim > first
cut -f3- ${root}5.bim > last
paste first mid last > ${root}5.bim

##Remove duplicate snps
cut -f2 ${root}5.bim | sort > with_dup
cut -f2 ${root}5.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl
plink --bfile ${root}5 --exclude dupl --make-bed --out ${root}6 #2,214,208 variants and 80 people
rm with_dup wo_dup dupl

##look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
plink --bfile ${root}6 --missing --out ${root}6
sed  "s/ \+/\t/g" ${root}6.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: 0.09142 (B-26)

##Relatedness filtering (based on the autosomes)
rm related_ex ; for ind in B-23 B-24 B-10 B-26 K-15 K-30 K-21 K-22 K-09 K-36; do grep ${ind} ${root}6.fam >> related_ex; done
plink --bfile ${root}6 --remove related_ex --make-bed --out ${root}7 #70 people

##Make new famfile with group name in first column
cat ${root}7.fam | cut -d" " -f2 | cut -d"-" -f1 | sed 's/B/Bangweulu/g' | sed 's/K/Kafue/g' > firstcol
cut -d" " -f2- ${root}7.fam > last
paste firstcol last | sed "s/\t/ /g" >both
cp ${root}7.fam ${root}7.famold
cp both ${root}7.fam
rm firstcol last both

##Exclude ATCG SNPs to prevent strand errors while flipping
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" ${root}7.bim >> ATCGlist
grep -P "\tT\tA" ${root}7.bim >> ATCGlist
grep -P "\tC\tG" ${root}7.bim >> ATCGlist
grep -P "\tG\tC" ${root}7.bim >> ATCGlist
plink --bfile ${root}7 --exclude ATCGlist --make-bed --out ${root}8 #2133405 variants and 70 people

###
###Zambian farmer neighbors
###
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021
infile="../prepareanalysisset_December2020/zbantu1f"  #I am using the most recent file (where the four Lozi were removed). 38,937 variants.
#exclude 0, mitochondria, chrY and XY variants
rm exlist; touch exlist
grep -P "^0\t" ${infile}.bim >> exlist
grep -P "^24\t" ${infile}.bim >> exlist #Y
grep -P "^25\t" ${infile}.bim >> exlist #XY
grep -P "^26\t" ${infile}.bim >> exlist #MT
plink --bfile ${infile} --exclude exlist --make-bed --out zbantu1-23_1 #2260358 variants and 45 people.
##exclude indels
rm indellist; touch indellist
root=zbantu1-23_
grep -P "\tI" ${root}1.bim >> indellist
grep -P  "\tD" ${root}1.bim >> indellist
plink --bfile ${root}1 --exclude indellist --make-bed --out ${root}2 #2259941 variants and 45 people
##SNP missingness filter
plink --bfile ${root}2 --geno 0.1 --biallelic-only strict --make-bed --out ${root}3 #2246195 variants and 45 people
#Comment: warning: 18443 het. haploid genotypes present (see zbantu1-23_3.hh ); many commands treat these as missing.
##HWE filter
#One fileset for each population
grep Lozi ${root}3.fam > Lozi
grep Bemba ${root}3.fam > Bemba
plink --bfile ${root}3 --keep Bemba --make-bed --out ${root}3B
plink --bfile ${root}3 --keep Lozi --make-bed --out ${root}3L
#HWE in each fileset
plink --bfile ${root}3B --hwe 0.001 --make-bed --out ${root}3Bhwe
plink --bfile ${root}3L --hwe 0.001 --make-bed --out ${root}3Lhwe
#Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
cut -f2 ${root}3Bhwe.bim > ${root}3Bhwe_variants
plink --bfile ${root}3 --exclude ${root}3Bhwe_variants --make-bed --out ${root}3Bhweexcl
cut -f2 ${root}3Lhwe.bim > ${root}3Lhwe_variants
plink --bfile ${root}3 --exclude ${root}3Lhwe_variants --make-bed --out ${root}3Lhweexcl
#Find overlap between ${root}3Bhweexcl.bim and ${root}3Lhweexcl.bim
cut -f2 ${root}3Lhweexcl.bim > ${root}3Lhweexcl_variants
plink --bfile ${root}3Bhweexcl --extract ${root}3Lhweexcl_variants --make-bed --out ${root}3Bhweexcl-extract${root}3Lhweexcl #4
#do the reverse to check that we get the same
cut -f2 ${root}3Bhweexcl.bim > ${root}3Bhweexcl_variants
plink --bfile ${root}3Lhweexcl --extract ${root}3Bhweexcl_variants --make-bed --out ${root}3Lhweexcl-extract${root}3Bhweexcl  #4
#Finally, exclude these SNP
cut -f2 ${root}3Bhweexcl-extract${root}3Lhweexcl.bim > ${root}3Bhweexcl-extract${root}3Lhweexcl_variants
plink --bfile ${root}3 --exclude ${root}3Bhweexcl-extract${root}3Lhweexcl_variants --make-bed --out ${root}4 #2246191 variants and 45 people
##Individual missingness filter
plink --bfile ${root}4 --mind 0.1 --make-bed --out ${root}5
####Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898
cut -f1,4 ${root}5.bim | sed "s/\t/-/g" > mid
cut -f1 ${root}5.bim > first
cut -f3- ${root}5.bim > last
paste first mid last > ${root}5.bim
##Remove duplicate snps
cut -f2 ${root}5.bim | sort > with_dup
cut -f2 ${root}5.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl
plink --bfile ${root}5 --exclude dupl --make-bed --out ${root}6 #2214609 variants and 45 people
rm with_dup wo_dup dupl
##look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
plink --bfile ${root}6 --missing --out ${root}6
sed  "s/ \+/\t/g" ${root}6.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: ZAM64 (Lozi), 0.01158
##Relatedness filtering (based on the autosomes)
rm related_ex ; for ind in ZAM46; do grep ${ind} ${root}6.fam >> related_ex; done
plink --bfile ${root}6 --remove related_ex --make-bed --out ${root}7 #44 people
##Exclude ATCG SNPs to prevent strand errors while flipping
rm ATCGlist; touch ATCGlist
grep -P "\tA\tT" ${root}7.bim >> ATCGlist
grep -P "\tT\tA" ${root}7.bim >> ATCGlist
grep -P "\tC\tG" ${root}7.bim >> ATCGlist
grep -P "\tG\tC" ${root}7.bim >> ATCGlist
plink --bfile ${root}7 --exclude ATCGlist --make-bed --out ${root}8 #2133711 variants and 44 people

###
###Omni2.5 (prepare)
###

###Schlebusch 2012
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021
infile=/proj/snic2020-2-10/uppstore2017249/DATA/Schlebusch_2012/Schlebusch_2012_Raw/Schlebusch_2012_chr1-26

#Preliminary step: keep only the individuals in the "Filtered" dataset, exclude Schuster San, and modify the fam file so that the Coloured Askham and the Khomani form a single group.
grep -v schus /proj/snic2020-2-10/uppstore2017249/DATA/Schlebusch_2012/Schlebusch_2012_Filtered/Schlebusch_2012.fam > Schlebusch2012_keep

#The IDs are like "1	1" or "12	12" in ${infile}.fam. After discussion with NH, I think that this corresponds to respectively KSP001 and KSP012. This is the "key" I used in the following. There are 231 individuals in ${infile} (including  "schus	kb1wg") and I selected the 117 that were in the "Filtered" dataset that I used previously (that file has 119 individuals, minus the fake and schus).

cat Schlebusch2012_keep |cut -d" " -f2| sed 's/KSP//g' | sed 's/^0*//' > Schlebusch2012_keep_shortindID
cut -d" " -f3-6 Schlebusch2012_keep > col3-6
paste Schlebusch2012_keep_shortindID Schlebusch2012_keep_shortindID col3-6 > Schlebusch2012_keep_shortIDs
plink --bfile ${infile} --keep Schlebusch2012_keep_shortIDs --biallelic-only strict --make-bed --out Schlebusch2012 #This worked fine. But this dataset does not contain a fake individual. Not so great because I won't be able to remove ACTG variants. Perhaps this does not matter since I will merge it with a dataset that has a fake?
#Now I need to change the samples ID's back to something more clear, plus change ColouredAskham to Khomani. I checked the correspondence between Schlebusch2012_keep and Schlebusch2012.fam
mv Schlebusch2012.fam Schlebusch2012.famold
grep -v fake Schlebusch2012_keep | sed 's/ColouredAskham/Khomani/g' > Schlebusch2012.fam
#Fingers crossed! TODO check with a PCA or something that it looks good (at the end).

#exclude 0, mitochondria, chrY and XY variants
infile=Schlebusch2012
rm exlist; touch exlist
grep -P "^0\t" ${infile}.bim >> exlist
grep -P "^24\t" ${infile}.bim >> exlist #Y
grep -P "^25\t" ${infile}.bim >> exlist #XY
grep -P "^26\t" ${infile}.bim >> exlist #MT
plink --bfile ${infile} --exclude exlist --make-bed --out Schlebusch1-23_1 #2434000 variants and 117 people.
##exclude indels
rm indellist; touch indellist
root="Schlebusch1-23_"
grep -P "\tI" ${root}1.bim >> indellist
grep -P  "\tD" ${root}1.bim >> indellist
plink --bfile ${root}1 --exclude indellist --make-bed --out ${root}2 #2433993 variants and 117 people
##SNP missingness filter
plink --bfile ${root}2 --geno 0.1 --biallelic-only strict --make-bed --out ${root}3 #2355528
##HWE filter
#20210121: I think this is the first time I filter this dataset for HWE. I am using two of the groups with the largest number of individuals.
#Comment: I am not modifying the file names with the right capital letter!
#One fileset for each population
grep SEBantu ${root}3.fam > SEBantu
grep Juhoansi ${root}3.fam > Juhoansi
plink --bfile ${root}3 --keep SEBantu --make-bed --out ${root}3B
plink --bfile ${root}3 --keep Juhoansi --make-bed --out ${root}3K
#HWE in each fileset
plink --bfile ${root}3B --hwe 0.001 --make-bed --out ${root}3Bhwe
plink --bfile ${root}3K --hwe 0.001 --make-bed --out ${root}3Khwe
#Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
cut -f2 ${root}3Bhwe.bim > ${root}3Bhwe_variants
plink --bfile ${root}3 --exclude ${root}3Bhwe_variants --make-bed --out ${root}3Bhweexcl
cut -f2 ${root}3Khwe.bim > ${root}3Khwe_variants
plink --bfile ${root}3 --exclude ${root}3Khwe_variants --make-bed --out ${root}3Khweexcl
#Find overlap between ${root}3Bhweexcl.bim and ${root}3Khweexcl.bim
cut -f2 ${root}3Khweexcl.bim > ${root}3Khweexcl_variants
plink --bfile ${root}3Bhweexcl --extract ${root}3Khweexcl_variants --make-bed --out ${root}3Bhweexcl-extract${root}3Khweexcl #4
#do the reverse to check that we get the same
cut -f2 ${root}3Bhweexcl.bim > ${root}3Bhweexcl_variants
plink --bfile ${root}3Khweexcl --extract ${root}3Bhweexcl_variants --make-bed --out ${root}3Khweexcl-extract${root}3Bhweexcl  #4
#Finally, exclude these SNP
cut -f2 ${root}3Bhweexcl-extract${root}3Khweexcl.bim > ${root}3Bhweexcl-extract${root}3Khweexcl_variants
plink --bfile ${root}3 --exclude ${root}3Bhweexcl-extract${root}3Khweexcl_variants --make-bed --out ${root}4 #2355524 variants and 117 people
##Individual missingness filter
plink --bfile ${root}4 --mind 0.1 --make-bed --out ${root}5
#Two individuals are lost! I did not remember that from before... A Khwe (KSP080) and a GuiGhanaKgal (KSP095). TODO remember!
####Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898
cut -f1,4 ${root}5.bim | sed "s/\t/-/g" > mid
cut -f1 ${root}5.bim > first
cut -f3- ${root}5.bim > last
paste first mid last > ${root}5.bim
##Remove duplicate snps
cut -f2 ${root}5.bim | sort > with_dup
cut -f2 ${root}5.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl
plink --bfile ${root}5 --exclude dupl --make-bed --out ${root}6 #2336598 variants and 115 people
rm with_dup wo_dup dupl
##look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
plink --bfile ${root}6 --missing --out ${root}6
sed  "s/ \+/\t/g" ${root}6.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: KSP108 (Juhoansi) 0.08928 (there are more with similar missingness).
##Relatedness filtering (based on the autosomes)
rm related_ex ; for ind in KSP226; do grep ${ind} ${root}6.fam >> related_ex; done
plink --bfile ${root}6 --remove related_ex --make-bed --out ${root}7 #
##I am not excluding ATCG SNPs because I do not have a fake individual. TODO flip the Zambian dataset (that has a fake individual).

###1KGP2015
#NH uploaded the files with the X chromosome:
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021
infile=/proj/snic2020-2-10/uppstore2017249/DATA/1KGP_2015/1000Genomes #Uploaded by NH
#exclude 0, mitochondria, chrY and XY variants
rm exlist; touch exlist
grep -P "^0\t" ${infile}.bim >> exlist
grep -P "^24\t" ${infile}.bim >> exlist #Y
grep -P "^25\t" ${infile}.bim >> exlist #XY
grep -P "^26\t" ${infile}.bim >> exlist #MT
grep -e CEU -e CHB -e YRI -e LWK -e MKK ${infile}.fam > CEU_CHB_YRI_LWK_MKK #496 individuals
plink --bfile ${infile} --exclude exlist --keep CEU_CHB_YRI_LWK_MKK --make-bed --out KGP1-23_1 #2445796 variants and 496 people
##exclude indels
rm indellist; touch indellist
root=KGP1-23_
grep -P "\tI" ${root}1.bim >> indellist
grep -P  "\tD" ${root}1.bim >> indellist
plink --bfile ${root}1 --exclude indellist --make-bed --out ${root}2 #2445796 variants and 496 people (i.e. there were no indels)
##SNP missingness filter
plink --bfile ${root}2 --geno 0.1 --biallelic-only strict --make-bed --out ${root}3 #2439787
##HWE filter
grep YRI ${root}3.fam > YRI
grep CEU ${root}3.fam > CEU
plink --bfile ${root}3 --keep YRI --make-bed --out ${root}3B
plink --bfile ${root}3 --keep CEU --make-bed --out ${root}3K
#HWE in each fileset
plink --bfile ${root}3B --hwe 0.001 --make-bed --out ${root}3Bhwe
plink --bfile ${root}3K --hwe 0.001 --make-bed --out ${root}3Khwe
#Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
cut -f2 ${root}3Bhwe.bim > ${root}3Bhwe_variants
plink --bfile ${root}3 --exclude ${root}3Bhwe_variants --make-bed --out ${root}3Bhweexcl
cut -f2 ${root}3Khwe.bim > ${root}3Khwe_variants
plink --bfile ${root}3 --exclude ${root}3Khwe_variants --make-bed --out ${root}3Khweexcl
#Find overlap between ${root}3Bhweexcl.bim and ${root}3Khweexcl.bim
cut -f2 ${root}3Khweexcl.bim > ${root}3Khweexcl_variants
plink --bfile ${root}3Bhweexcl --extract ${root}3Khweexcl_variants --make-bed --out ${root}3Bhweexcl-extract${root}3Khweexcl #23298 variants! That's a lot.
#do the reverse to check that we get the same
cut -f2 ${root}3Bhweexcl.bim > ${root}3Bhweexcl_variants
plink --bfile ${root}3Khweexcl --extract ${root}3Bhweexcl_variants --make-bed --out ${root}3Khweexcl-extract${root}3Bhweexcl  #23298
#Trying with one more population because I know that the YRI have a lot of related individuals and I think that this can disturb HWE.
grep LWK ${root}3.fam > LWK
plink --bfile ${root}3 --keep LWK --make-bed --out ${root}3L
plink --bfile ${root}3L --hwe 0.001 --make-bed --out ${root}3Lhwe
cut -f2 ${root}3Lhwe.bim > ${root}3Lhwe_variants
plink --bfile ${root}3 --exclude ${root}3Lhwe_variants --make-bed --out ${root}3Lhweexcl
#Find overlap between ${root}3Bhweexcl.bim and ${root}3Khweexcl.bim
cut -f2 ${root}3Lhweexcl.bim > ${root}3Lhweexcl_variants
plink --bfile ${root}3Bhweexcl-extract${root}3Khweexcl --extract ${root}3Lhweexcl_variants --make-bed --out ${root}3Bhweexcl-extract${root}3Khweexcl-extract${root}3Lhweexcl #Still 20408 variants. Ok, I am going to exclude these.
#Finally, exclude these SNP
cut -f2 ${root}3Bhweexcl-extract${root}3Khweexcl-extract${root}3Lhweexcl.bim > ${root}3Bhweexcl-extract${root}3Khweexcl-extract${root}3Lhweexcl_variants
plink --bfile ${root}3 --exclude ${root}3Bhweexcl-extract${root}3Khweexcl-extract${root}3Lhweexcl_variants --make-bed --out ${root}4 #2419379 variants and 496 people
##Individual missingness filter
plink --bfile ${root}4 --mind 0.1 --make-bed --out ${root}5
####Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898
cut -f1,4 ${root}5.bim | sed "s/\t/-/g" > mid
cut -f1 ${root}5.bim > first
cut -f3- ${root}5.bim > last
paste first mid last > ${root}5.bim
##Remove duplicate snps
cut -f2 ${root}5.bim | sort > with_dup
cut -f2 ${root}5.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl
plink --bfile ${root}5 --exclude dupl --make-bed --out ${root}6 #2403433 variants and 496 people
rm with_dup wo_dup dupl
##look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
plink --bfile ${root}6 --missing --out ${root}6
sed  "s/ \+/\t/g" ${root}6.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: 0.01832 (one CHB individual).
##Relatedness filtering (based on the autosomes)
#see details in 20201209_prepare_data.sh
grep -v NA21386 /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/1KGP_2015/1000Genomes_phased_duplicated_RelExcl_IBSexcl_CEU_CHB_YRI_LWK_MKK_uniq | grep -v NA21477 > KGP_unrelated 
plink --bfile ${root}6 --keep KGP_unrelated --make-bed --out ${root}7 #2403433 variants and 399 people
#Downsample to maximum 36 individuals per population.
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni2.5/1KGP_2015/randommax36bypop .
plink --bfile ${root}7 --keep randommax36bypop --make-bed --out ${root}8 #2403433 variants and 173 people
##I am not excluding ATCG SNPs because I do not have a fake individual. TODO flip the Zambian dataset (that has a fake individual).
#Comment: previously I had filtered for HWE in the end of the process (and only very few variants were removed).

###Gurdasani
cut -f1 /proj/snic2020-2-10/uppstore2017249/DATA/Gurdasani_2015/Gurdasani_2015_Full_DB/Gurdasani_2015_Full_DB.bim | sort | uniq -c
#does not include the X. Alternatively I could use the Pagani 2015 data (Pagani_2015/Pagani_2015_Raw/Pagani_2015_Raw_Ethiopian/), limitations might be about citation (?) (Amhara, Gumuz, Oromo, Wolayta, Somali).

###Haber
ls /proj/snic2020-2-10/uppstore2017249/DATA/Haber_2016/
#Does not contain the X.

###
###Omni1
###

###Patin
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021
infile=/proj/snic2020-2-10/uppstore2017249/DATA/Patin_2014/Patin_2014_Raw/Patin_2014 #Same number of people like in Patin_2014_Filtered
#exclude 0, mitochondria, chrY and XY variants
rm exlist; touch exlist
grep -P "^0\t" ${infile}.bim >> exlist
grep -P "^24\t" ${infile}.bim >> exlist #Y
grep -P "^25\t" ${infile}.bim >> exlist #XY
grep -P "^26\t" ${infile}.bim >> exlist #MT
plink --bfile ${infile} --exclude exlist --make-bed --out Patin1-23_1 #929238 variants and 260 people
##exclude indels
rm indellist; touch indellist
root=Patin1-23_
grep -P "\tI" ${root}1.bim >> indellist
grep -P  "\tD" ${root}1.bim >> indellist
plink --bfile ${root}1 --exclude indellist --make-bed --out ${root}2 #929237
##SNP missingness filter
plink --bfile ${root}2 --geno 0.1 --biallelic-only strict --make-bed --out ${root}3 #929200
##HWE filter
#TODO modify according to populations
#One fileset for each population
grep Baka_Cam ${root}3.fam > Baka_Cam #58 people
grep Nzime_Cam ${root}3.fam > Nzime_Cam #53 people
plink --bfile ${root}3 --keep Baka_Cam --make-bed --out ${root}3B
plink --bfile ${root}3 --keep Nzime_Cam --make-bed --out ${root}3K
#HWE in each fileset
plink --bfile ${root}3B --hwe 0.001 --make-bed --out ${root}3Bhwe
plink --bfile ${root}3K --hwe 0.001 --make-bed --out ${root}3Khwe
#Then exclude the BIM after filtering from the start BIM to see which variants were filtered out
cut -f2 ${root}3Bhwe.bim > ${root}3Bhwe_variants
plink --bfile ${root}3 --exclude ${root}3Bhwe_variants --make-bed --out ${root}3Bhweexcl
cut -f2 ${root}3Khwe.bim > ${root}3Khwe_variants
plink --bfile ${root}3 --exclude ${root}3Khwe_variants --make-bed --out ${root}3Khweexcl
#Find overlap between ${root}3Bhweexcl.bim and ${root}3Khweexcl.bim
cut -f2 ${root}3Khweexcl.bim > ${root}3Khweexcl_variants
plink --bfile ${root}3Bhweexcl --extract ${root}3Khweexcl_variants --make-bed --out ${root}3Bhweexcl-extract${root}3Khweexcl #85
#do the reverse to check that we get the same
cut -f2 ${root}3Bhweexcl.bim > ${root}3Bhweexcl_variants
plink --bfile ${root}3Khweexcl --extract ${root}3Bhweexcl_variants --make-bed --out ${root}3Khweexcl-extract${root}3Bhweexcl  #85
#Finally, exclude these SNP
cut -f2 ${root}3Bhweexcl-extract${root}3Khweexcl.bim > ${root}3Bhweexcl-extract${root}3Khweexcl_variants
plink --bfile ${root}3 --exclude ${root}3Bhweexcl-extract${root}3Khweexcl_variants --make-bed --out ${root}4 #929115 variants and 260 people
##Individual missingness filter
plink --bfile ${root}4 --mind 0.1 --make-bed --out ${root}5
####Replace rs and kgp type SNP names with SNPs that have new name in chr-baseposition format, i.e. 2-347898
cut -f1,4 ${root}5.bim | sed "s/\t/-/g" > mid
cut -f1 ${root}5.bim > first
cut -f3- ${root}5.bim > last
paste first mid last > ${root}5.bim
##Remove duplicate snps
cut -f2 ${root}5.bim | sort > with_dup
cut -f2 ${root}5.bim | sort | uniq | sort | uniq > wo_dup
comm -23 with_dup wo_dup > dupl
plink --bfile ${root}5 --exclude dupl --make-bed --out ${root}6 #929115 variants and 260 people
rm with_dup wo_dup dupl
##look at individual missingness to see if some inds has not gone over threshhold after SNP filtering
plink --bfile ${root}6 --missing --out ${root}6
sed  "s/ \+/\t/g" ${root}6.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: 0.02188
##Relatedness filtering (based on the autosomes)
rm related_ex ; grep -e Batwa_05 -e Batwa_06 -e Batwa_12 -e Batwa_14 -e Batwa_18 -e Batwa_19 -e Batwa_24 -e Batwa_25 -e Batwa_27 -e Baka_Cam_04 -e Baka_Cam_12 -e Baka_Cam_35 -e Baka_Cam_51 -e Baka_Cam_56 -e Bakiga_05 -e Bakiga_25 -e Bongo_GabE_08 -e Bongo_GabS_01 -e Bongo_GabS_19 -e Nzime_Cam_15 -e Nzime_Cam_33 -e Nzime_Cam_41 ${root}6.fam > related_ex;
plink --bfile ${root}6 --remove related_ex --make-bed --out ${root}7 #238 people
#Downsample
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/Comparative_data/Omni1/Patin_2014/randommax36bypop .
plink --bfile ${root}7 --keep randommax36bypop --make-bed --out ${root}8 #207 people
##I am not excluding ATCG SNPs because I do not have a fake individual. TODO flip the Zambian dataset (that has a fake individual).
#Comment: previously I had filtered for HWE in the end of the process.

###Scheinfeldt
ls /crex/proj/snic2020-2-10/uppstore2017249/DATA/Scheinfeldt_2019/
#Does not contain the X.

###
### MERGE
###

###The two Zambian datasets.
grep fake zbantu1-23_8.fam > fake_ex
plink --bfile zbantu1-23_8 --remove fake_ex --make-bed --out zbantu1-23_8_fex
plink --bfile zbatwa1-23_8 --bmerge zbantu1-23_8_fex.bed zbantu1-23_8_fex.bim zbantu1-23_8_fex.fam --make-bed --out zbatwa8_zbantu8_1-23
plink --bfile zbantu1-23_8_fex --flip zbatwa8_zbantu8_1-23-merge.missnp --make-bed --out zbantu1-23_8_fexf
plink --bfile zbatwa1-23_8 --bmerge zbantu1-23_8_fexf.bed zbantu1-23_8_fexf.bim zbantu1-23_8_fexf.fam --make-bed --out zbatwa8_zbantu8_1-23_2
#missingness filter
plink --bfile zbatwa8_zbantu8_1-23_2 --geno 0.1 --make-bed --out zbatwa8_zbantu8_1-23_3 #2125578 variants and 113 people (including one fake)
plink --bfile zbatwa8_zbantu8_1-23_3 --missing --out zbatwa8_zbantu8_1-23_3
sed  "s/ \+/\t/g" zbatwa8_zbantu8_1-23_3.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: ZAM54 (Lozi)

###With Schlebusch 2012
#I decided to flip the Zambian dataset (i.e. the one with a fake individual).
plink --bfile zbatwa8_zbantu8_1-23_3 --bmerge Schlebusch1-23_7.bed Schlebusch1-23_7.bim Schlebusch1-23_7.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_1-23
plink --bfile zbatwa8_zbantu8_1-23_3 --flip zbatwa8_zbantu8_Schlebusch7_1-23-merge.missnp --make-bed --out zbatwa8_zbantu8_1-23_3f
plink --bfile zbatwa8_zbantu8_1-23_3f --bmerge Schlebusch1-23_7.bed Schlebusch1-23_7.bim Schlebusch1-23_7.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_1-23_2
plink --bfile zbatwa8_zbantu8_1-23_3f --exclude zbatwa8_zbantu8_Schlebusch7_1-23_2-merge.missnp --make-bed --out zbatwa8_zbantu8_1-23_3fe
plink --bfile zbatwa8_zbantu8_1-23_3fe --bmerge Schlebusch1-23_7.bed Schlebusch1-23_7.bim Schlebusch1-23_7.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_1-23_3
#missingness filter
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_3 --geno 0.1 --make-bed --out zbatwa8_zbantu8_Schlebusch7_1-23_4 #1518927 variants and 227 people (including one fake)
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_4 --missing --out zbatwa8_zbantu8_Schlebusch7_1-23_4
sed  "s/ \+/\t/g" zbatwa8_zbantu8_Schlebusch7_1-23_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: KSP218 (Khomani), actually higher than 0.1! (0.1012) I will filter it out since we are not particularly interested in this population.
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_4 --mind 0.1 --make-bed --out zbatwa8_zbantu8_Schlebusch7_1-23_5 #1518927 variants and 226 people

###With KGP2015
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_5 --bmerge KGP1-23_8.bed KGP1-23_8.bim KGP1-23_8.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_1-23
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_5 --flip zbatwa8_zbantu8_Schlebusch7_KGP8_1-23-merge.missnp --make-bed --out zbatwa8_zbantu8_Schlebusch7_1-23_5f
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_5f --bmerge KGP1-23_8.bed KGP1-23_8.bim KGP1-23_8.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_2
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_5f --exclude zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_2-merge.missnp --make-bed --out zbatwa8_zbantu8_Schlebusch7_1-23_5fe
plink --bfile zbatwa8_zbantu8_Schlebusch7_1-23_5fe --bmerge KGP1-23_8.bed KGP1-23_8.bim KGP1-23_8.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_3
#missingness filter
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_3 --geno 0.1 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4 #1504272 variants and 399 people (including one fake)
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4 --missing --out zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4
sed  "s/ \+/\t/g" zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: KSP108 (Juhoansi), 0.09959

###With Patin2014.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4 --bmerge Patin1-23_8.bed Patin1-23_8.bim Patin1-23_8.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4 --flip zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23-merge.missnp --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4f
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4f --bmerge Patin1-23_8.bed Patin1-23_8.bim Patin1-23_8.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_2
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4f --exclude zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_2-merge.missnp --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4fe
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_1-23_4fe --bmerge Patin1-23_8.bed Patin1-23_8.bim Patin1-23_8.fam --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_3
#missingness filter
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_3 --geno 0.1 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_4 #572854 variants and 606 people (including one fake)
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_4 --missing --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_4
sed  "s/ \+/\t/g" zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_4.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness: KSP108 (Juhoansi), 0.1132
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_4 --mind 0.1 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5 #572854 variants and 604 people

#TODO possibly I will need to apply a more stringent filter at some point (the Schlebusch samples in particular have high individual missingness, which was not the case previously; perhaps they had been filtered more stringently). Is it worrying? On the other hand, I have more variants than I had in previous merges (after removing the X chr).
#I end up with 5034 SNPs on the X chromosome.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5 --missing --chr 23 --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5
sed  "s/ \+/\t/g" zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5.imiss | sed  "s/^\t//g" | sort -k6 | tail #highest missingness is 0.07529 - good!

#Remove the fake individual.
grep fake zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5.fam >> fake_ex
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5 --remove fake_ex --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex

###
### Simple PCA to check that everything is in order!
###
#Keep only the autosomes.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex --not-chr 23 --mind 0.1 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex

#PCA
root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb
cp /proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par
rm temppar

module load bioinfo-tools eigensoft/7.2.0
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
#Plotted locally. Looks good I think - I had not noticed that one Lozi individual is very close to the Maasai. Possibly one that is rem

###
### Continue - LD filtering
###
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex --indep-pairwise 50 10 0.4 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4 #Filtering I used previously; 190687 of 572854 variants removed, in particular 3729 variants remain on the X chr.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex --indep-pairwise 200 25 0.4 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD200-25-0.4 #NH filtering; 191538 of 572854 variants removed, in particular 3700 remain on the X chr.
#I will use my usual filter with r2=0.4
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex --extract zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4.prune.in --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4

#Create chromosome-specific filesets (for some of the autosomes this also mean cutting to 180 cM).
##X chromosome: see below (20210125), after sex imputation.

#Comment: before merging with Patin2014 I have 18579 variants on the X chr (more than three time more than after merging!). It might be worth it to try with that dataset too.

###
### To prepare the autosomes to mimic the X: cut the autosomes to 180 cM.
###
#I am using the genetic maps that I used for the phasing.
cd /proj/snic2020-2-10/uppstore2017249/DATA/KGP_reference_haplotypes
awk '$3 > 179.99999 && $3 < 180.00001 {print}' genetic_map_chr1_combined_b37.txt #Adapt the boundaries depending on the chromosome.
#162713074 0.1012761046 179.999997797795
#Next row: 162713789 0.1012515981 180.000070192688 ($grep -A 1)
awk '$3 > 179.999 && $3 < 180.001 {print}' genetic_map_chr2_combined_b37.txt
#163722422 0.5249895536 180.000376301645 (closest)
#chr3: 170771908 15.3179516502 180.009437343870
#chr4: 170766662 1.0344719362 180.000251264636
#chr5: 167649294 6.5693749465 179.990002277394 Next: 167650243 32.3798689519 180.020730773030
#chr6: 162170141 70.1599068432 180.001626699863
#chr7: 154669744 26.0203219719 179.97112499744
#chr8: last position is 178 cM
#chr9: last position is 180 cM
#chr10: last position is 183 cM
#chr11: last position is 162 cM
#chr12: last position is 175 cM
#I decided to use chromosomes 8 and 9 too (and not chromosome 11).

root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4
plink --bfile ${root}1-23${suffix} --chr 1 --to-bp 162713074 --make-bed --out ${root}1-180cM${suffix} #18739 variants
plink --bfile ${root}1-23${suffix} --chr 2 --to-bp 163722422 --make-bed --out ${root}2-180cM${suffix} #20658
plink --bfile ${root}1-23${suffix} --chr 3 --to-bp 170771908 --make-bed --out ${root}3-180cM${suffix} #21337
plink --bfile ${root}1-23${suffix} --chr 4 --to-bp 170766662 --make-bed --out ${root}4-180cM${suffix} #19379
plink --bfile ${root}1-23${suffix} --chr 5 --to-bp 167649294 --make-bed --out ${root}5-180cM${suffix} #20832
plink --bfile ${root}1-23${suffix} --chr 6 --to-bp 162170141 --make-bed --out ${root}6-180cM${suffix} #21828
plink --bfile ${root}1-23${suffix} --chr 7 --to-bp 154669744 --make-bed --out ${root}7-180cM${suffix} #19913
plink --bfile ${root}1-23${suffix} --chr 8 --make-bed --out ${root}8-180cM${suffix} #20348
plink --bfile ${root}1-23${suffix} --chr 9 --make-bed --out ${root}9-180cM${suffix} #17841
plink --bfile ${root}1-23${suffix} --chr 10 --make-bed --out ${root}10-180cM${suffix} #20906
plink --bfile ${root}1-23${suffix} --chr 12 --make-bed --out ${root}12-180cM${suffix} #19384

###
### Prepare a hundred sets of variants (this goes extremely fast).
###
#list_autosomes is a file with a row with the name of each of chr1-10 and 12.
root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4
nX=3729
for i in {1..100}; do
	chr=$(shuf -n 1 -r < list_autosomes)
	shuf -n ${nX} ${root}${chr}-180cM${suffix}.bim > 20210122_100sets/set${i}_chr${chr}
	plink --bfile ${root}${chr}-180cM${suffix} --extract 20210122_100sets/set${i}_chr${chr} --make-bed --out 20210122_100sets/set${i}_chr${chr}
done

###
###ADMIXTURE###
###
#25 iterations on each random set.
#Start with supervised ADMIXTURE at K=2 with Juhoansi and YRI as source populations. I decided to keep all other populations, but I could also restrict to e.g. the Zambian populations only.

#Prepare the .pop (same for all sets).
cut -d" " -f1 ${root}23${suffix}.fam | sed 's/Baka_Cam/-/g' | sed 's/Baka_Gab/-/g' | sed 's/Bakiga/-/g' |sed 's/Bangweulu/-/g' |sed 's/Batwa/-/g' | sed 's/Bongo_GabE/-/g' |sed 's/Bongo_GabS/-/g' |sed 's/CEU/-/g' | sed 's/CHB/-/g' |sed 's/GuiGhanaKgal/-/g' |sed 's/Juhoansi/Juhoansi/g' |sed 's/Kafue/-/g' |sed 's/Karretjie/-/g' |sed 's/Khomani/-/g' |sed 's/Khwe/-/g' |sed 's/LWK/-/g' | sed 's/MKK/-/g'  | sed 's/Nama/-/g' |sed 's/Nzebi_Gab/-/g' |sed 's/Nzime_Cam/-/g' |sed 's/SEBantu/-/g' |sed 's/SWBantu/-/g' |sed 's/Xun/-/g' |sed 's/YRI/Yoruba/g' |sed 's/Zambia_Bemba/-/g' |sed 's/Zambia_Lozi/-/g' |sed 's/Zambia_TongaZam/-/g' > ${root}1-23${suffix}.pop

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/log

root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/

(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba
k=2
for j in 100_chr6 10_chr1 11_chr8 12_chr12 13_chr10 14_chr9 15_chr4 16_chr6 17_chr8 18_chr4 19_chr5 1_chr2 20_chr8 21_chr12 22_chr7 23_chr4 24_chr12 25_chr4 26_chr2 27_chr1 28_chr5 29_chr10 2_chr10 30_chr3 31_chr9 32_chr8 33_chr12 34_chr8 35_chr4 36_chr4 37_chr9 38_chr7 39_chr8 3_chr12 40_chr12 41_chr1 42_chr7 43_chr8 44_chr12 45_chr12 46_chr10 47_chr7 48_chr6 49_chr8 4_chr8 50_chr5 51_chr8 52_chr7 53_chr6 54_chr2 55_chr7 56_chr12 57_chr7 58_chr4 59_chr4 5_chr6 60_chr1 61_chr9 62_chr5 63_chr7 64_chr8 65_chr9 66_chr7 67_chr4 68_chr10 69_chr4 6_chr8 70_chr2 71_chr2 72_chr1 73_chr3 74_chr2 75_chr7 76_chr3 77_chr8 78_chr3 79_chr12 7_chr3 80_chr8 81_chr12 82_chr10 83_chr10 84_chr7 85_chr4 86_chr10 87_chr1 88_chr3 89_chr12 8_chr3 90_chr7 91_chr6 92_chr12 93_chr2 94_chr3 95_chr8 96_chr1 97_chr4 98_chr8 99_chr1 9_chr5; do
cp ${folder}${root}1-23_5fex_LD50-10-0.4.pop ${folder}20210122_100sets/set\${j}.pop
for i in {1..25}; do
mkdir ad_set\${j}_\${k}_\${i}
cd ad_set\${j}_\${k}_\${i}
admixture ${folder}20210122_100sets/set\${j}.bed \$k -s \$RANDOM --supervised
mv set\${j}.\${k}.Q ../set\${j}.\${k}.Q.\${i}
mv set\${j}.\${k}.P ../set\${j}.\${k}.P.\${i}
cd ../
rm -R ad_set\${j}_\${k}_\${i}
done
rm ${folder}20210122_100sets/set\${j}.pop
done
exit 0") | sbatch -p core -n 1 -t 24:0:0 -A snic2018-8-397 -J ad_100sets_${k} -o ad_100sets_${k}.output -e ad_100sets_${k}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

#Took 5 seconds for an iteration! I submitted all in one go and it took 3.5 hours on one core.

#For the X chromosome

#20210125
#Check the sex of the individuals (not known for all...)
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4 --check-sex --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4 #3729 Xchr VARIANTS and 0 Ychr variant(s) scanned, 265 problems detected
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4 --check-sex --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4 #Same message when I use only the X chromosome.
#Double-check that the X PAR region has been removed (I think yes because I selected "23" and the PAR should be "25", but checking nevertheless.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4 --split-x hg19 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4_checkPAR #fine, no such positions.
grep PROBLEM zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4.sexcheck |less
R
data <- read.table(file="zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4.sexcheck",header=TRUE)
plot(data$F)
abline(h=0.5,col="red")
abline(h=0.4,col="blue")
q()
n
#Clearly there is a male cluster (tightly around 1), and more dispersed females. Most females have values below 0.4 and all below 0.5.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4 --check-sex 0.5 0.9 --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4_secondtest #Now all of the problems are individuals for which the sex was not assigned initially (but all have determinable sex according to these criteria).
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4 --impute-sex 0.5 0.9 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4_sex

#Extract X chr again (no need to do it for the autosomes I think, it is not important to know whether male or female there).
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4_sex --chr 23 --mind 0.1 --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex

#Running ADMIXTURE.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex --recode --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex #Looking at the .ped: males are coded as homozygous ref or alt.
#There are 774 het haploid (i.e. males with heterozygous calls) calls; represents about 2.2 calls per male i.e. less than 1 in 1000 variants. I think that is decent.
#But ADMIXTURE does not tolerate it... TODO find a way to set these genotypes to missing.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex --set-hh-missing --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex2

#for i in {2..25}; do
#k=2
#module load bioinfo-tools ADMIXTURE/1.3.0
#cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba/test_Xchr
#cp ${folder}${root}1-23_5fex_LD50-10-0.4.pop ${folder}${root}23${suffix}.pop
#mkdir ad_chr23_${k}_${i}
#cd ad_chr23_${k}_${i}
#admixture ${folder}${root}23${suffix}.bed $k -s $RANDOM --supervised --haploid="male:23"
#mv ${root}23${suffix}.${k}.Q ../chr23.${k}.Q.${i}
#mv ${root}23${suffix}.${k}.P ../chr23.${k}.P.${i}
#cd ../
#rm -R ad_chr23_${k}_${i}
#rm ${folder}${root}23${suffix}.pop
#done

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/log
root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4_sex2
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba
k=2
cp ${folder}${root}1-23_5fex_LD50-10-0.4.pop ${folder}${root}23${suffix}.pop
for i in {1..25}; do
mkdir ad_chr23_\${k}_\${i}
cd ad_chr23_\${k}_\${i}
admixture ${folder}${root}23${suffix}.bed \$k -s \$RANDOM --supervised --haploid=\"male:23\"
mv ${root}23${suffix}.\${k}.Q ../chr23.\${k}.Q.\${i}
mv ${root}23${suffix}.\${k}.P ../chr23.\${k}.P.\${i}
cd ../
rm -R ad_chr23_\${k}_\${i}
done
rm ${folder}${root}23${suffix}.pop
exit 0") | sbatch -p core -n 1 -t 1:0:0 -A snic2018-8-397 -J ad_chr23_${k} -o ad_chr23_${k}.output -e ad_chr23_${k}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

###
###Somehow compute the ratio!
###
#NH took the population mean of the 2500 autosomal results (=one value for the autosomes) and the mean of the 25 X chromosome runs (=one value for the X chromosome, caution: females weight double as much like the males to reflect the ploidy). Then computed the male and female contributions with equations 22-23 from Goldberg 2015.
#MV calculated the X-chr to autosome ratio for each autosome according to Goldberg 2017. Then he represented that with a bar plot (Figure 3, not sure that I understand it fully!).
cut -d" " -f1,2 ${folder}${root}23${suffix}.fam > FID_IID


#Comment: my idea is to gather all of the values in a single file, and later to extract based on populations and/or chr. However it will be a very long file (and rather large: 71 MiB).
R
FID_IID <- read.table(file="FID_IID")
write.table(t(c("SET","iteration","FID","IID","A_Juhoansi","A_Yoruba")),file="summary_603ind_2500runs",append=FALSE,row.names=FALSE,col.names=FALSE)
for (set in c("100_chr6","10_chr1","11_chr8","12_chr12","13_chr10","14_chr9","15_chr4","16_chr6","17_chr8","18_chr4","19_chr5","1_chr2",
"20_chr8","21_chr12","22_chr7","23_chr4","24_chr12","25_chr4","26_chr2","27_chr1","28_chr5","29_chr10","2_chr10","30_chr3",
"31_chr9","32_chr8","33_chr12","34_chr8","35_chr4","36_chr4","37_chr9","38_chr7","39_chr8","3_chr12","40_chr12","41_chr1",
"42_chr7","43_chr8","44_chr12","45_chr12","46_chr10","47_chr7","48_chr6","49_chr8","4_chr8","50_chr5","51_chr8","52_chr7",
"53_chr6","54_chr2","55_chr7","56_chr12","57_chr7","58_chr4","59_chr4","5_chr6","60_chr1","61_chr9","62_chr5","63_chr7",
"64_chr8","65_chr9","66_chr7","67_chr4","68_chr10","69_chr4","6_chr8","70_chr2","71_chr2","72_chr1","73_chr3","74_chr2",
"75_chr7","76_chr3","77_chr8","78_chr3","79_chr12","7_chr3","80_chr8","81_chr12","82_chr10","83_chr10","84_chr7","85_chr4",
"86_chr10","87_chr1","88_chr3","89_chr12","8_chr3","90_chr7","91_chr6","92_chr12","93_chr2","94_chr3","95_chr8","96_chr1",
"97_chr4","98_chr8","99_chr1","9_chr5")) {
#for (set in c("100_chr6","10_chr1","11_chr8")) {
 for (i in 1:25) {
  ancestry_frac <- read.table(file=paste("set",set,".2.Q.",i,sep=""))
  ancestry_frac_ID <- data.frame(FID_IID,ancestry_frac)
  names(ancestry_frac_ID) <- c("FID","IID","A1","A2")
  if (ancestry_frac_ID[ancestry_frac_ID$FID=="Juhoansi",][1,3]==0.99999) {
   #Write out the fractions in the order they are given (i.e. A1 A2)
   write.table(data.frame(set,i,ancestry_frac_ID),file="summary_603ind_2500runs",append=TRUE,row.names=FALSE,col.names=FALSE)
   } else {
   #Write out the fractions in the order A2 A1
   write.table(data.frame(set,i,FID_IID,ancestry_frac[,2],ancestry_frac[,1]),file="summary_603ind_2500runs",append=TRUE,row.names=FALSE,col.names=FALSE)
  }
 }
}

all <- read.table(file="summary_603ind_2500runs",header=TRUE)
FID_IID <- read.table(file="FID_IID")
pop <- unique(FID_IID[,1]) #27 populations
write.table(file="avg_2500iterations_by_pop",t(c("FID","A_Juhoansi")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,5]))),file="avg_2500iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}
#TODO investigate the results. All of the proportions (except for Juhoansi and YRI) are strangely similar I find. And low (compare to value for Nama, K=2, YRI as second source, in NH PhD thesis 4th paper, Table S1).

#20210126
#Plot one set to get an idea of what is going on.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba
prefix=set100_chr6
mkdir adm_Qs_set100_chr6_K2_25repeats
cd adm_Qs_set100_chr6_K2_25repeats
k=2
for i in {1..25}; do
cp ../${prefix}.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_set100_chr6_K2_25repeats.zip adm_Qs_set100_chr6_K2_25repeats

########## run pong locally ##########
cd /home/ecodair/Bureau/Work_from_home/P3/results/December2020/Xtoautosomes_ancestryratio

#create ind2pop.txt
cut -d ' ' -f1 zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex2.fam > ind2pop.txt
cp ind2pop.txt tmp1; bash /home/ecodair/Bureau/Work_from_home/P3/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 ind2pop_newnames.txt ; rm tmp1

#create pong_filemap
rm pong_filemap_set100_chr6
k=2
for i in {1..25}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_set100_chr6_K2_25repeats/set100_chr6.${k}.Q.${i}
done >> pong_filemap_set100_chr6

#create poporder.txt
cut -f1 ind2pop_newnames.txt |sort |uniq > poporder.txt #Modified manually: poporder2.txt

pong -m pong_filemap_set100_chr6 -n poporder2.txt -i ind2pop_newnames.txt -v
#Bah. I do not have PONG installed apparently. Install it? I tried "pip install pong" and updated pip as asked, but it did not work :/

#Or try on Uppmax.
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba/pong/
module load bioinfo-tools pong/1.4.7
pong -m pong_filemap_set100_chr6 -n poporder2.txt -i ind2pop_newnames.txt -v --disable_server
#Aha. Apparently there are two modes. So perhaps this is why my results are weird, I should stick to one mode?
#One mode represents 19 runs and the other 6.
#Should I try across all 2500??

#I tried to put the following ten sets together: 100_chr6 10_chr1 11_chr8 12_chr12 13_chr10 14_chr9 15_chr4 16_chr6 17_chr8 18_chr4 19_chr5 . It did not work because I have duplicate matrices (e.g. ten k2r1). Also most likely it is not allowed to mix ADMXITURE results that way...

#I decided to look at more sets. ind2pop and poporder remain the same.

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba/pong
k=2

set="12_chr12"
mkdir adm_Qs_set${set}_K2_25repeats
for i in {1..25}; do cp ../set${set}.${k}.Q.${i} adm_Qs_set${set}_K2_25repeats ; done
for i in {1..25}; do echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_set${set}_K2_25repeats/set${set}.${k}.Q.${i} ; done >> pong_filemap_set${set}

pong -m pong_filemap_set${set} -n poporder2.txt -i ind2pop_newnames.txt -v --disable_server -o set${set}
cat set${set}/result_summary.txt

#For set "10_chr1" there are two modes, one with 14 and the other with 11 runs.
#Set "11_chr8": 18/7
#Set "12_chr12": 19/6. The two modes coincide with the difference I based my script on i.e. whether the first individual has 0.99 0.00 or 0.00 0.99 (in my case I based it on a Juhoansi, but I expect it to be the same).

#Could it be that excluding some populations makes it easier to have a single mode? TODO look at the ancestry proportions between different modes and see whether they vary a lot for certain populations.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba/pong/adm_Qs_set12_chr12_K2_25repeats
R
FID_IID <- read.table(file="../../FID_IID")
set="100_chr6" #TODO modify with set of interest
setwd(paste("/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba/pong/adm_Qs_set",set,"_K2_25repeats",sep=""))
#write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file=paste("summary_set",set,"_mode1",sep=""),append=FALSE,row.names=FALSE,col.names=FALSE)
write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file=paste("summary_set",set,"_mode2",sep=""),append=FALSE,row.names=FALSE,col.names=FALSE)
mode1=c(2,6:12,14:19,21:25) #TODO modify based on pong output
mode2=c(1,3,4,5,13,20) #TODO modify based on pong output
#for (i in mode1) {
for (i in mode2) {
 ancestry_frac <- read.table(file=paste("set",set,".2.Q.",i,sep=""))
 ancestry_frac_ID <- data.frame(FID_IID,ancestry_frac)
 names(ancestry_frac_ID) <- c("FID","IID","A1","A2")
 #Write out the fractions in the order they are given (i.e. A1 A2)
 #write.table(data.frame(set,i,ancestry_frac_ID),file=paste("summary_set",set,"_mode1",sep=""),append=TRUE,row.names=FALSE,col.names=FALSE)
write.table(data.frame(set,i,ancestry_frac_ID),file=paste("summary_set",set,"_mode2",sep=""),append=TRUE,row.names=FALSE,col.names=FALSE)
}

pop <- unique(FID_IID[,1]) #27 populations

all <- read.table(file=paste("summary_set",set,"_mode1",sep=""),header=TRUE)
write.table(file=paste("avg_set",set,"_mode1_by_pop",sep=""),t(c("FID","A_1")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,5]))),file=paste("avg_set",set,"_mode1_by_pop",sep=""),row.names=FALSE,col.names=FALSE,append=TRUE)
}

all <- read.table(file=paste("summary_set",set,"_mode2",sep=""),header=TRUE)
write.table(file=paste("avg_set",set,"_mode2_by_pop",sep=""),t(c("FID","A_1")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,5]))),file=paste("avg_set",set,"_mode2_by_pop",sep=""),row.names=FALSE,col.names=FALSE,append=TRUE)
}

#For 12_chr12, even if YRI has 0.00 and Juhoansi 0.99 in both modes (for A_1 - this time I kept the default order), the values for the other populations are very different (and not directly 1-the avg for the other mode).

#12_chr12: mode1=c(2,3,4,6,7,8,9,10,11,13,14,15,16,17,18,20,21,22,23) mode2=c(1,5,12,19,24,25)

#100_chr6: similar trends like in 12_chr12 (for the populations averages as well).

#The CEU and Han are particularly extreme in their distribution between the two modes, but they are not the only populations in that situation...
#Test: run 25 iterations of the dataset without the CEU and Han and see whether I have one or several modes.
root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4
grep -e CEU -e CHB ${root}6-180cM${suffix}.fam > CEU_CHB
plink --bfile ${root}6-180cM${suffix} --remove CEU_CHB --make-bed --out ${root}6-180cM${suffix}_Afr
set="100_chr6"
plink --bfile ${root}6-180cM${suffix}_Afr --extract 20210122_100sets/set${set} --make-bed --out 20210126_test_Afr/set${set}

#Prepare the .pop (same for all sets).
cut -d" " -f1 20210126_test_Afr/set${set}.fam | sed 's/Baka_Cam/-/g' | sed 's/Baka_Gab/-/g' | sed 's/Bakiga/-/g' |sed 's/Bangweulu/-/g' |sed 's/Batwa/-/g' | sed 's/Bongo_GabE/-/g' |sed 's/Bongo_GabS/-/g' |sed 's/CEU/-/g' | sed 's/CHB/-/g' |sed 's/GuiGhanaKgal/-/g' |sed 's/Juhoansi/Juhoansi/g' |sed 's/Kafue/-/g' |sed 's/Karretjie/-/g' |sed 's/Khomani/-/g' |sed 's/Khwe/-/g' |sed 's/LWK/-/g' | sed 's/MKK/-/g'  | sed 's/Nama/-/g' |sed 's/Nzebi_Gab/-/g' |sed 's/Nzime_Cam/-/g' |sed 's/SEBantu/-/g' |sed 's/SWBantu/-/g' |sed 's/Xun/-/g' |sed 's/YRI/Yoruba/g' |sed 's/Zambia_Bemba/-/g' |sed 's/Zambia_Lozi/-/g' |sed 's/Zambia_TongaZam/-/g' > 20210126_test_Afr/set${set}.pop

root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/20210126_test_Afr

module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba
k=2
j="100_chr6"
for i in {1..25}; do
mkdir ad_set${j}_${k}_${i}
cd ad_set${j}_${k}_${i}
admixture ${folder}/set${j}.bed $k -s $RANDOM --supervised
mv set${j}.${k}.Q ../set${j}.${k}.Q.${i}
mv set${j}.${k}.P ../set${j}.${k}.P.${i}
cd ../
rm -R ad_set${j}_${k}_${i}
done
 
mkdir adm_Qs_set${j}_K2_25repeats
for i in {1..25}; do mv set${j}.${k}.Q.${i} adm_Qs_set${j}_K2_25repeats ; done
for i in {1..25}; do echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_set${j}_K2_25repeats/set${j}.${k}.Q.${i} ; done >> pong_filemap_set${j}

pong -m pong_filemap_set${j} -n poporder.txt -i ind2pop.txt -v --disable_server -o set${j}
#Bingo. There is a single mode.

R
FID_IID <- read.table(file="FID_IID")
set="100_chr6" #TODO modify with set of interest
setwd(paste("/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba/adm_Qs_set",set,"_K2_25repeats",sep=""))
write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file=paste("summary_set",set,sep=""),append=FALSE,row.names=FALSE,col.names=FALSE)
for (i in 1:25) {
 ancestry_frac <- read.table(file=paste("set",set,".2.Q.",i,sep=""))
 ancestry_frac_ID <- data.frame(FID_IID,ancestry_frac)
 names(ancestry_frac_ID) <- c("FID","IID","A1","A2")
 write.table(data.frame(set,i,ancestry_frac_ID),file=paste("summary_set",set,sep=""),append=TRUE,row.names=FALSE,col.names=FALSE)
}

pop <- unique(FID_IID[,1]) #25 populations

all <- read.table(file=paste("summary_set",set,sep=""),header=TRUE)
write.table(file=paste("avg_set",set,"_by_pop",sep=""),t(c("FID","A_1")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,5]))),file=paste("avg_set",set,"_by_pop",sep=""),row.names=FALSE,col.names=FALSE,append=TRUE)
}
#Comment: I moved all of the files to subfolder "test". TODO later: remove what I do not need, as well as the initial ADMIXTURE runs. The ind2pop.txt, FID_IID and poporder.txt files will be useful again.

#Preparing sets and running ADMIXTURE with African samples only.
##Prepare the sets
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021
root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4
for chr in {{1..10},12}; do plink --bfile ${root}${chr}-180cM${suffix} --remove CEU_CHB --make-bed --out ${root}${chr}-180cM${suffix}_Afr; done
#I will go with new sets, it is easier!
nX=3729
for i in {1..100}; do
	chr=$(shuf -n 1 -r < list_autosomes)
	shuf -n ${nX} ${root}${chr}-180cM${suffix}_Afr.bim > 20210126_Afr_100sets/set${i}_chr${chr}
	plink --bfile ${root}${chr}-180cM${suffix}_Afr --extract 20210126_Afr_100sets/set${i}_chr${chr} --make-bed --out 20210126_Afr_100sets/set${i}_chr${chr}
done

cp 20210126_test_Afr/*.pop 20210126_Afr_100sets/zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-23_5fex_LD50-10-0.4_Afr.pop

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/log
root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4_Afr
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/20210126_Afr_100sets/
k=2

(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba
k=2
for j in 100_chr4 10_chr6 11_chr10 12_chr6 13_chr1 14_chr9 15_chr12 16_chr2 17_chr1 18_chr12 19_chr4 1_chr4 20_chr6 21_chr8 22_chr1 23_chr10 24_chr2 25_chr7 26_chr6 27_chr3 28_chr5 29_chr10 2_chr10 30_chr12 31_chr9 32_chr5 33_chr6 34_chr7 35_chr5 36_chr6 37_chr4 38_chr3 39_chr3 3_chr1 40_chr6 41_chr10 42_chr5 43_chr2 44_chr2 45_chr5 46_chr7 47_chr1 48_chr5 49_chr1 4_chr2 50_chr6 51_chr9 52_chr1 53_chr10 54_chr3 55_chr10 56_chr8 57_chr8 58_chr2 59_chr5 5_chr4 60_chr2 61_chr6 62_chr9 63_chr9 64_chr7 65_chr3 66_chr10 67_chr3 68_chr4 69_chr1 6_chr2 70_chr3 71_chr5 72_chr9 73_chr3 74_chr6 75_chr7 76_chr9 77_chr4 78_chr8 79_chr2 7_chr1 80_chr7 81_chr2 82_chr6 83_chr2 84_chr10 85_chr8 86_chr1 87_chr9 88_chr7 89_chr6 8_chr5 90_chr1 91_chr6 92_chr12 93_chr6 94_chr2 95_chr3 96_chr1 97_chr8 98_chr7 99_chr8 9_chr10; do
cp ${folder}${root}1-23_5fex_LD50-10-0.4_Afr.pop ${folder}set\${j}.pop
for i in {1..25}; do
mkdir ad_set\${j}_\${k}_\${i}
cd ad_set\${j}_\${k}_\${i}
admixture ${folder}set\${j}.bed \$k -s \$RANDOM --supervised
mv set\${j}.\${k}.Q ../set\${j}.\${k}.Q.\${i}
mv set\${j}.\${k}.P ../set\${j}.\${k}.P.\${i}
cd ../
rm -R ad_set\${j}_\${k}_\${i}
done
rm ${folder}set\${j}.pop
done
exit 0") | sbatch -p core -n 1 -t 6:0:0 -A snic2018-8-397 -J ad_100sets_Afr_${k} -o ad_100sets_Afr_${k}.output -e ad_100sets_Afr_${k}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END
#Submitted.

#Do the same for the X chromosome.
plink --bfile zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex2 --remove CEU_CHB --make-bed --out zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_23_5fex_LD50-10-0.4_sex2_Afr

root=zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_
suffix=_5fex_LD50-10-0.4_sex2_Afr
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/

module load bioinfo-tools ADMIXTURE/1.3.0
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba
k=2
cp ${folder}20210126_Afr_100sets/${root}1-23_5fex_LD50-10-0.4_Afr.pop ${folder}${root}23${suffix}.pop
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

#Run Pong to check that I have a single mode.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba/pong
k=2

##X chromosome
mkdir adm_Qs_23_K2_25repeats
for i in {1..25}; do cp ../chr23.${k}.Q.${i} adm_Qs_23_K2_25repeats ; done
for i in {1..25}; do echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_23_K2_25repeats/chr23.${k}.Q.${i} ; done >> pong_filemap_23

pong -m pong_filemap_23 -n poporder.txt -i ind2pop.txt -v --disable_server -o chr23
cat chr23/result_summary.txt
#Yay! One mode!

#Remove the doubletons Q files (after running pong).
for i in {1..25}; do rm ../chr23.${k}.Q.${i} ; done


##Autosomes
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba/pong
k=2
for j in 100_chr4 10_chr6 11_chr10 12_chr6 13_chr1 14_chr9 15_chr12 16_chr2 17_chr1 18_chr12 19_chr4 1_chr4 20_chr6 21_chr8 22_chr1 23_chr10 24_chr2 25_chr7 26_chr6 27_chr3 28_chr5 29_chr10 2_chr10 30_chr12 31_chr9 32_chr5 33_chr6 34_chr7 35_chr5 36_chr6 37_chr4 38_chr3 39_chr3 3_chr1 40_chr6 41_chr10 42_chr5 43_chr2 44_chr2 45_chr5 46_chr7 47_chr1 48_chr5 49_chr1 4_chr2 50_chr6 51_chr9 52_chr1 53_chr10 54_chr3 55_chr10 56_chr8 57_chr8 58_chr2 59_chr5 5_chr4 60_chr2 61_chr6 62_chr9 63_chr9 64_chr7 65_chr3 66_chr10 67_chr3 68_chr4 69_chr1 6_chr2 70_chr3 71_chr5 72_chr9 73_chr3 74_chr6 75_chr7 76_chr9 77_chr4 78_chr8 79_chr2 7_chr1 80_chr7 81_chr2 82_chr6 83_chr2 84_chr10 85_chr8 86_chr1 87_chr9 88_chr7 89_chr6 8_chr5 90_chr1 91_chr6 92_chr12 93_chr6 94_chr2 95_chr3 96_chr1 97_chr8 98_chr7 99_chr8 9_chr10; do
mkdir adm_Qs_${j}_K2_25repeats
for i in {1..25}; do mv ../set${j}.${k}.Q.${i} adm_Qs_${j}_K2_25repeats/ ; done
for i in {1..25}; do echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_${j}_K2_25repeats/set${j}.${k}.Q.${i} ; done >> pong_filemap_${j}
pong -m pong_filemap_${j} -n poporder.txt -i ind2pop.txt -v --disable_server -o set${j}
done

#Loop over the pong outputs to see whether one or several modes.
for j in 100_chr4 10_chr6 11_chr10 12_chr6 13_chr1 14_chr9 15_chr12 16_chr2 17_chr1 18_chr12 19_chr4 1_chr4 20_chr6 21_chr8 22_chr1 23_chr10 24_chr2 25_chr7 26_chr6 27_chr3 28_chr5 29_chr10 2_chr10 30_chr12 31_chr9 32_chr5 33_chr6 34_chr7 35_chr5 36_chr6 37_chr4 38_chr3 39_chr3 3_chr1 40_chr6 41_chr10 42_chr5 43_chr2 44_chr2 45_chr5 46_chr7 47_chr1 48_chr5 49_chr1 4_chr2 50_chr6 51_chr9 52_chr1 53_chr10 54_chr3 55_chr10 56_chr8 57_chr8 58_chr2 59_chr5 5_chr4 60_chr2 61_chr6 62_chr9 63_chr9 64_chr7 65_chr3 66_chr10 67_chr3 68_chr4 69_chr1 6_chr2 70_chr3 71_chr5 72_chr9 73_chr3 74_chr6 75_chr7 76_chr9 77_chr4 78_chr8 79_chr2 7_chr1 80_chr7 81_chr2 82_chr6 83_chr2 84_chr10 85_chr8 86_chr1 87_chr9 88_chr7 89_chr6 8_chr5 90_chr1 91_chr6 92_chr12 93_chr6 94_chr2 95_chr3 96_chr1 97_chr8 98_chr7 99_chr8 9_chr10; do
grep "represents 25 runs" set${j}/result_summary.txt
done | wc -l #100 -> yes all have a single mode! Yay!

#Remove the files from the previous ADMIXTURE run.
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210122_K2_Juhoansi_Yoruba
rm set*
#TODO later: remove summary_603ind_2500runs

#Get average ancestry fractions
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba/pong
R
FID_IID <- read.table(file="FID_IID")
write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file="summary_531ind_2500runs",append=FALSE,row.names=FALSE,col.names=FALSE)
for (set in c("100_chr4","10_chr6","11_chr10","12_chr6","13_chr1","14_chr9","15_chr12","16_chr2","17_chr1","18_chr12","19_chr4","1_chr4","20_chr6","21_chr8","22_chr1",
"23_chr10","24_chr2","25_chr7","26_chr6","27_chr3","28_chr5","29_chr10","2_chr10","30_chr12","31_chr9","32_chr5","33_chr6","34_chr7","35_chr5","36_chr6",
"37_chr4","38_chr3","39_chr3","3_chr1","40_chr6","41_chr10","42_chr5","43_chr2","44_chr2","45_chr5","46_chr7","47_chr1","48_chr5","49_chr1","4_chr2","50_chr6",
"51_chr9","52_chr1","53_chr10","54_chr3","55_chr10","56_chr8","57_chr8","58_chr2","59_chr5","5_chr4","60_chr2","61_chr6","62_chr9","63_chr9","64_chr7",
"65_chr3","66_chr10","67_chr3","68_chr4","69_chr1","6_chr2","70_chr3","71_chr5","72_chr9","73_chr3","74_chr6","75_chr7","76_chr9","77_chr4","78_chr8",
"79_chr2","7_chr1","80_chr7","81_chr2","82_chr6","83_chr2","84_chr10","85_chr8","86_chr1","87_chr9","88_chr7","89_chr6","8_chr5","90_chr1","91_chr6",
"92_chr12","93_chr6","94_chr2","95_chr3","96_chr1","97_chr8","98_chr7","99_chr8","9_chr10")) {
 for (i in 1:25) {
  ancestry_frac <- read.table(file=paste("adm_Qs_",set,"_K2_25repeats/set",set,".2.Q.",i,sep=""))
  write.table(data.frame(set,i,FID_IID,ancestry_frac),file="summary_531ind_2500runs",append=TRUE,row.names=FALSE,col.names=FALSE)
 }
}

all <- read.table(file="summary_531ind_2500runs",header=TRUE)
pop <- unique(FID_IID[,1]) #25 populations
write.table(file="avg_2500iterations_by_pop",t(c("FID","A_1")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,5]))),file="avg_2500iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}

q()
n
#Yay! Values seem to make a lot of sense.

#Get average ancestry fractions for the X chromosome
#Caution! Females should weight double as much like males. I also did the calculations without weighting the females (summary_531ind_chr23_25runs and avg_chr23_25iterations_by_pop) and the two are very similar (which makes sense I suppose, unless very recent admixture?).
#My values are still super high compared to NH's for the Nama, I do not know why!
cd /proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba/pong
R
FID_IID_sex <- read.table(file="FID_IID_sex")
names(FID_IID_sex) <- c("FID","IID","sex")
write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file="summary_531ind_chr23_weighted_25runs",append=FALSE,row.names=FALSE,col.names=FALSE)
for (i in 1:25) {
ancestry_frac <- read.table(file=paste("adm_Qs_23_K2_25repeats/chr23.2.Q.",i,sep=""))
write.table(data.frame("chr23",i,FID_IID_sex$FID,FID_IID_sex$IID,ancestry_frac*FID_IID_sex$sex),
file="summary_531ind_chr23_weighted_25runs",append=TRUE,row.names=FALSE,col.names=FALSE)
}

all <- read.table(file="summary_531ind_chr23_weighted_25runs",header=TRUE)
pop <- unique(FID_IID_sex[,1]) #25 populations
write.table(file="avg_chr23_weighted_25iterations_by_pop",t(c("FID","A_1")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	sex <- sum(FID_IID_sex[FID_IID_sex$FID==POP,3])
	write.table(t(c(as.vector(POP),sum(all[all$FID==POP,][,5])/sex/25)),file="avg_chr23_weighted_25iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}
q()
n

#Calculate the ratio.
##I solved by hand the equations 22 and 23 in Goldberg and Rosenberg Genetics 2015 (i.e. what NH used) and ended up with: y=4A-3X and x=3X-2A where y is the male contribution, x is the female contribution, A is the average autosomal ancestry and X is the (weighted) average X chromosome ancestry. I checked that these equations are correct by comparing to NH's Tables S1 and S2.
avgX <- read.table(file="avg_chr23_weighted_25iterations_by_pop",header=TRUE)
avgA <- read.table(file="avg_2500iterations_by_pop",header=TRUE)
y <- 4*avgA$A_1 - 3*avgX$A_1
x <- 3*avgX$A_1 - 2*avgA$A_1 
write.table(data.frame(avgX$FID,y,x), col.names=c("FID","male_contribution","female_contribution"),row.names=FALSE, file="male_female_contributions")
#I have a couple of values <0 or >1. That means that they fall outside of the bound of migration [0,1].

write.table(file="Xtoaut_ancestry_ratio_Juhoansi_ancestry",data.frame(avgX$FID,avgX$A_1/avgA$A_1),
col.names=c("FID","ratio"),row.names=FALSE)
#This suggests that the Juhoansi-like source contributed more females than the YRI-like source, at least in the five Zambian populations. This is as expected!
#TODO do a couple more things (e.g. repeat with only the Zambian and only Omni2.5) and then discuss quickly with NH. Does it matter that I do not get the same values (by far) than hers? (e.g. for the Nama) Do the values in themselves mean something or are the relative values more important? (I have quite extreme values.)


#TODO possibly, reduce even more the dataset (exclude the RHG and RHGn) (or look at the effect of keeping only the Zambian populations).





