# 2023-07-03
# Gwenna Breton
# Goal: perform f3 test with additional populations (Batwa from Uganda and Sabue) per reviewer's suggestion.
# Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/test_f3.sh
#The data was prepared according to code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/test_f3.sh

folder=/crex/proj/snic2020-2-10/uppstore2018150/private/results/f3test/20210128
cd $folder
module load bioinfo-tools AdmixTools/5.0-20171024

#Batwa from Uganda
head -5 20210128_popfile1 | sed 's/baa001/Batwa/g' > 20230703_Batwa_popfile
sed 's/20210128_popfile1/20230703_Batwa_popfile/g' < par.f3test.20210128_popfile1 > par.f3test.20230703_Batwa_popfile
qp3Pop -p par.f3test.20230703_Batwa_popfile > logfile.20230703_Batwa_popfile

#Sabue
head -5 20210128_popfile1 | sed 's/baa001/Ethiopia_Sabue/g' > 20230703_Sabue_popfile
sed 's/20210128_popfile1/20230703_Sabue_popfile/g' < par.f3test.20210128_popfile1 > par.f3test.20230703_Sabue_popfile
qp3Pop -p par.f3test.20230703_Sabue_popfile > logfile.20230703_Sabue_popfile
