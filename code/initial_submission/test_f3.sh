#20210128
#Gwenna Breton
#Goal: test f3 statistic calculation!

#Comment: at the moment I do not know how to deal with the haploid data, so this is really just to play around!
#Edit 20210212: apparently I did the right thing.

#Question: Is LD an issue?
#Edit 20210212: no.

#Question: Does it figure out by itself the overlap between the samples included in the analysis?
#Edit 20210212: yes.

cd /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
root=omni1finalmerge_ancient4fexhap_2 #filtered for missingness; all individuals should have at least 15,000 variants.
#Change phenotype status to 1 (otherwise they will be ignored in the conversion).
cp ${root}.fam ${root}.fam_original
sed 's/-9/1/g' < ${root}.fam > tmp; mv tmp ${root}.fam
plink --bfile ${root} --recode --out ${root}

##
sed 's/example/omni1finalmerge_ancient4fexhap_2/g' par.PED.EIGENSTRAT > par.PED.EIGENSTRAT.20210128.Omni1.ancient
module load bioinfo-tools AdmixTools/5.0-20171024
convertf -p par.PED.EIGENSTRAT.20210128.Omni1.ancient

#Modify the third column of .indiv so it has the population ID.
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
cd /proj/snic2020-2-10/uppstore2018150/private/results/f3test/20210128
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${root}.indiv .
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${root}.geno .
cp /proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${root}.snp .

sed 's/example/omni1finalmerge_ancient4fexhap_2/g' < /proj/snic2020-2-10/uppstore2018150/private/results/f3test/par.f3test | sed 's/list_qp3Pop/20210128_popfile1/g' > par.f3test.20210128_popfile1
qp3Pop -p par.f3test.20210128_popfile1 > logfile.20210128_popfile1
#It runs, but all values are very close to 0! Two negative Z-scores: Kafue + Juhoansi and Kafue + BBA. According to Schlebusch et al 2017 Table S9 (and associated text) this suggests admixture.


#20210212: Test Baka from Cameroon
head -5 20210128_popfile1 | sed 's/baa001/Baka_Cam/g' > 20210212_popfile
sed 's/20210128_popfile1/20210212_popfile/g' < par.f3test.20210128_popfile1 > par.f3test.20210212_popfile
qp3Pop -p par.f3test.20210212_popfile > logfile.20210212_popfile

#I also redid the test for the Shum Laka samples, separated in two pairs (the two from 8000BP and the two from 3000BP).
qp3Pop -p par.f3test.20210212_popfile2 > logfile.20210212_popfile2

#20210218
#Test the two other Malawi samples and a modern East African population (Hadza).
qp3Pop -p par.f3test.20210218 > logfile.20210218_popfile

#20210401
#Group the three Malawi samples and see what happens. They are genetically homogeneous so grouping should be ok. The downside might be less SNPs to work with since the 6000BP sample has a lot less SNPs than the other two.
cp omni1finalmerge_ancient4fexhap_2_ShumLakaseparate.indiv omni1finalmerge_ancient4fexhap_2_ShumLakaseparate_Malawitogether.indiv #I modified the file with nano.
head -5 20210218_popfile | sed 's/Malawi_Fingira_6000BP/Malawi_ancient/g' > 20210401_popfile
cat par.f3test.20210218 | sed 's/omni1finalmerge_ancient4fexhap_2_ShumLakaseparate.indiv/omni1finalmerge_ancient4fexhap_2_ShumLakaseparate_Malawitogether.indiv/g' | sed 's/20210218_popfile/20210401_popfile/g' > par.f3test.20210401
qp3Pop -p par.f3test.20210401 > logfile.20210401_popfile







