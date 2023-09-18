# 2023-09-18
# Gwenna Breton
# Goal: perform the different f-tests (f3, f4 ratio, find_graph) for the Lozi population, once the two individuals with recent non-African admixture are excluded. The goal is to see whether the Lozi are more similar to the Bemba and Tonga in that case.
# The inputs for f3 and f4 ratio are in eigenstrat format. Not straightforward to manipulate. I will try with the corresponding plink fileset, and with the admixtools R package.

# Make a new folder
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/
newfolder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/f_tests_Lozi_no-recent-non-African-admixture

# Prepare the inputs
module load bioinfo-tools plink/1.90b4.9
cd $newfolder

## The inputs for f3 are in .indiv, .snp and .geno format. Not that easy to exclude individuals...
prefix=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/omni1finalmerge_ancient4fexhap_2
newprefix=$newfolder/omni1finalmerge_ancient4fexhap_2_loziadmixedex
plink --bfile $prefix --remove lozi_exclude --make-bed --out $newprefix

module load bioinfo-tools
module load R_packages/4.1.1
R
library(admixtools, lib.loc='/domus/h1/gwennabr/R/x86_64-redhat-linux-gnu-library/4.1.1/')
library(dplyr)
setwd("/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/withdenisovan/kafue") #Replace by appropriate path
f2=f2_from_geno("omni1finalmerge_ancient4fexhap_2_loziadmixedex",maxmiss=0.15) #originally I had the inbreed:yes option. This is the case by default here (now it's adjust_pseudohaploid=TRUE)
#Previously I didn't use maxmiss=0.15...
#Oups. Job was killed.


## The inputs for f4 are also in .indiv, .snp and .geno format.
zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex*
#prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex

## The inputs for find_graph are a plink fileset. Easier.
folder=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/Denisovan
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2_denisovan_3fex
newprefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2_denisovan_3fex_loziadmixedex
plink --bfile $folder/$prefix --remove lozi_exclude --make-bed --out $newfolder/$newprefix

#Now, select only the six populations of interest (normally I should be able to do that directly in the find_graph call. But I'm not trying to be fancy here):
pop=${folder}/YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Lozi-Denisovan
plink --bfile $newprefix --keep-fam $pop --make-bed --out $newfolder/September2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Lozi-Denisovan #135 people

mkdir -p /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/withdenisovan/loziadmixedex/20230918/plots/
cp ${newfolder}/September2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Lozi-Denisovan.b* /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/withdenisovan/loziadmixedex/
cp ${newfolder}/September2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Lozi-Denisovan.fam /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/withdenisovan/loziadmixedex/
cd /crex/proj/snic2020-2-10/uppstore2018150/private/scripts/find_graphs
sbatch -A p2018003 -p core -n 1 -t 2-00:00:00 --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL runRscript_explore_admixture_graphs_denisovan_loziadmixedex_n100.sh




