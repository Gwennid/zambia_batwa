#### pca
infile="Somaliland_AfricaF.merged_haplo3"
outfile="Somaliland_AfricaF.merged_haplo3"
poplist="Africa_refpops"
 
#create .pedind
cut -d" " -f1-5 ${infile}.fam >file1a
cut -d" " -f1 ${infile}.fam >file2a
touch fileComb
paste file1a file2a >fileComb
sed "s/\t/ /g" fileComb > ${infile}.pedind
rm file1a; rm file2a; rm fileComb
 
 
#create .par for smartpca
echo "altnormstyle:     NO
genotypename:     ${infile}.bed
snpname:          ${infile}.bim
indivname:        ${infile}.pedind
evecoutname:      ${outfile}.evec
evaloutname:      ${outfile}.eval
popsizelimit:     20
qtmode:           NO
killr2:           NO
r2thresh:         0.7
numoutlieriter:   0
lsqproject:       YES
poplistname:      ${poplist}
shrinkmode:       YES" > ${outfile}.par
 
 
# prepre and submit the script
echo "
module load bioinfo-tools
module load eigensoft/7.2.1
 
smartpca -p ${outfile}.par
sed 1d ${outfile}.evec | sed 's/:/ /g' > ${outfile}.evecm" > smartpca_${outfile}.sh
sed -i '1 i\#!/bin/bash -l' smartpca_${outfile}.sh
 
sbatch -J ${outfile}_pca -A snic2018-8-107 -t 2-00:00:00 -p core -n 4 -M snowy smartpca_${outfile}.sh
