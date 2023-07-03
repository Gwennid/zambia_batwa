# 2023-07-03
# Gwenna Breton
# Goal: run ADMIXTURE with K cross-validation (reviewer suggestion)
#Code based on /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/20201210_analyses.sh
#Input is Omni1 dataset, filtered for LD with --indep-pairwise 50 10 0.1

cd /crex/proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2023_Omni1_crossvalidation/log
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2

#Test: I don't know what the output of cross-validation is, so I will run one iteration at K=2 to check what I should move from the result folder!
i=1
k=2
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /crex/proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2023_Omni1_crossvalidation/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${prefix}.bed $k -s $RANDOM --cv
exit 0") | sbatch -p core -n 1 -t 12:0:0 -A p2018003 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1_2.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL

#Code for later - to be modified
for i in {1..20}; do
for k in {2..12}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools ADMIXTURE/1.3.0
cd /crex/proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2023_Omni1_crossvalidation/
mkdir ad_${k}_${i}
cd ad_${k}_${i}
admixture /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/${prefix}.bed $k -s $RANDOM --cv
mv ${prefix}.${k}.Q ../${prefix}.${k}.Q.${i}
mv ${prefix}.${k}.P ../${prefix}.${k}.P.${i}
cd ../
rm -R ad_${k}_${i}
exit 0") | sbatch -p core -n 1 -t 12:0:0 -A p2018003 -J ad_${k}_${i}_Omni1 -o ad_${k}_${i}_Omni1.output -e ad_${k}_${i}_Omni1_2.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL
done
done
