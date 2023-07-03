# 2023-07-03
# Gwenna Breton
# Goal: perform f4 ratio test with additional populations (Batwa from Uganda and Sabue) per reviewer's suggestion.
# Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/20201210_analyses.sh which itself is based on f4_ratio_test.sh
#The data was prepared according to code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/20201210_analyses.sh
#Performed on Omni1 dataset.

folder=/crex/proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/20201210
cd $folder
module load bioinfo-tools AdmixTools/5.0-20171024

# Batwa from Uganda
sed 's/Baka_Cam/Batwa/g' < 20200717_popfile_wRHGadmixture > 20230703_popfile_eRHGadmixture
sed 's/example/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex/g' < /crex/proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20230703_popfile_eRHGadmixture/g' > par.f4ratio.20230703_eRHGadmixture
qpF4ratio -p par.f4ratio.20230703_eRHGadmixture > logfile.20230703_eRHGadmixture

# Sabue from Ethiopia
sed 's/Tanzania_Hadza/Ethiopia_Sabue/g' < 20200613_popfile_eHGadmixture > 20230703_popfile_eHGadmixture
sed 's/example/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex/g' < /crex/proj/snic2020-2-10/uppstore2018150/private/results/f4ratiotest/par.f4ratio | sed 's/POPFILE/20230703_popfile_eHGadmixture/g' > par.f4ratio.20230703_eHGadmixture
qpF4ratio -p par.f4ratio.20230703_eHGadmixture > logfile.20230703_eHGadmixture
