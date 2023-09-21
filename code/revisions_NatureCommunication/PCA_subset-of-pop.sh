# 2023-09-21
# Gwenna Breton
# Goal: PCA with the Baka (Cameroon), Juhoansi, Yoruba, and the five Zambian populations
#Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/20201201_analyses.sh
#Same as the plot in Figure 1C but unprojected

interactive -p core -n 1 -A p2018003 -t 1:0:0
module load bioinfo-tools plink/1.90b4.9
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020

## Input
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
cp /crex/proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36.par
rm temppar

## Run the PCA
(echo '#!/bin/bash -l'
echo "
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp
smartpca -p ${root}_killr20.2_popsize36.par > ${root}_killr20.2_popsize36.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 10:0  -A p2018003 -J PC_${root} -o PC_${root}.output -e PC_${root}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

## Plot
