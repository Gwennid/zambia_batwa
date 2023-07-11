# 2023-07-11
# Gwenna Breton
# Goal: PCA where the Yoruba, the Ju|'hoansi and the Batwa from Uganda form the PCA and the Zambian populations are projected in the space.
#Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/20201201_analyses.sh
#Same as the plot in Figure 1C but with the Batwa from Uganda instead of the Baka from Cameroon.

interactive -p core -n 1 -A p2018003 -t 1:0:0
module load bioinfo-tools plink/1.90b4.9
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020

## YRI, Batwa (Uganda), Juhoansi, and projection of the Zambian populations.
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
grep -e YRI -e Batwa -e Juhoansi -e Bangweulu -e Kafue -e Zambia ${root}.fam > ${root}_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp
plink --bfile ${root} --keep ${root}_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp --make-bed --out ${root}_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp
#plink --bfile ${root}_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp --geno 0.1 --mind 0.1 --make-bed --out ${root}_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_2 #No variant removed - I am removing that file.
 
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

cp /crex/proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
echo -e 'poplistname:\tYRI_Batwa-Uganda_Juhoansi_poplist' >> ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
rm temppar

(echo '#!/bin/bash -l'
echo "
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp
smartpca -p ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 10:0  -A p2018003 -J PC_${root}_B_K_ZambiaBantusp_projected -o PC_${root}_B_K_ZambiaBantusp_projected.output -e PC_${root}_B_K_ZambiaBantusp_projected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END

# I plotted the results (cf plot_PCA_projected.R in the same folder). Sample Batwa_04 is an outlier and drives several of the axes. I will perform the PCA without it again.

###
# PCA with Batwa_04 (outlier) removed
###
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
grep -e YRI -e Batwa -e Juhoansi -e Bangweulu -e Kafue -e Zambia ${root}.fam | grep -v "Batwa_04" > ${root}_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04
newroot=${root}_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04
plink --bfile ${root} --keep ${newroot} --make-bed --out ${newroot}

root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04
cut -d" " -f1-5 ${root}.fam >file1a
cut -d" " -f1 ${root}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${root}.pedind
rm file1a; rm file2a; rm fileComb

cp /crex/proj/snic2020-2-10/uppstore2018150/private/scripts/parfile.par temppar
sed "s/infile/${root}/g" temppar |   sed "s/outfile/${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected/g"  | sed "s/popsizelimit:     20/popsizelimit:     36/g" | sed "s/killr2:           YES/killr2:           YES/g"   > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
echo -e 'poplistname:\tYRI_Batwa-Uganda_Juhoansi_poplist' >> ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par
rm temppar

(echo '#!/bin/bash -l'
echo "
cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
module load bioinfo-tools eigensoft/7.2.0
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04
smartpca -p ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.par > ${root}_killr20.2_popsize36_B_K_ZambiaBantusp_projected.smartpca.logfile
exit 0") | sbatch -p core -n 1 -t 10:0  -A p2018003 -J PC_${root}_B_K_ZambiaBantusp_projected -o PC_${root}_B_K_ZambiaBantusp_projected.output -e PC_${root}_B_K_ZambiaBantusp_projected.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL,END


