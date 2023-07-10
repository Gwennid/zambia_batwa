# 2023-07-10
# Gwenna Breton
# Goal: plot ADMIXTURE results with pong. pong is installed locally. The code is based on /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/plot_ADMIXTURE_with_pong.sh

#Omni1 full pruned K=2 to 12, 20 repeats. Rerun with cross-validation for revisions.
cd /crex/proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2023_Omni1_crossvalidation/
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2
mkdir adm_Qs_202307_mergeOmni1_pruned_K2-12_20repeats
cd adm_Qs_202307_mergeOmni1_pruned_K2-12_20repeats
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..20}; do
cp ../${prefix}.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_202307_mergeOmni1_pruned_K2-12_20repeats.zip adm_Qs_202307_mergeOmni1_pruned_K2-12_20repeats

##Get the CV error
cd /crex/proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2023_Omni1_crossvalidation/log
grep "CV error" *.output > CVerror_admixture_July2023_Omni1.txt

########## run pong locally ##########
cd /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/analyses/Revisions_NatureComm_2023/ADMIXTURE

#create ind2pop.txt and pop_order_expandednames.txt
#This was done in December 2020 or earlier. I'm keeping the code for reference, but I copied the ready made files.
#cut -d ' ' -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.fam > ind2pop_202012_mergeOmni1.txt
#cp ind2pop_202012_mergeOmni1.txt tmp1; bash /home/gwennabreton/Desktop/Work_from_home/P3/src/replace_population_names_for_MOSAIC_shorteshorternames.sh ; mv tmp2 ind2pop_202012_mergeOmni1_newnames.txt ; rm tmp1

#cp ../../VT2020/ADMIXTURE/poporder_Omni1 . #I removed manually the ColouredAskham and the San Schuster.
#cp poporder_Omni1 tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 poporder_Omni1_newnames.txt ; rm tmp1 #I also reorganized a bit - basically I put the Niger-Congo speakers before the eastern Africans.

cp /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/analyses/December2020/ADMIXTURE/ind2pop_202012_mergeOmni1_newnames.txt .
cp /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/analyses/December2020/ADMIXTURE/poporder_Omni1_newnames.txt .

#create pong_filemap
rm pong_filemap_202307_mergeOmni1_pruned
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..20}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_202307_mergeOmni1_pruned_K2-12_20repeats/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.${k}.Q.${i}
done
done >> pong_filemap_202307_mergeOmni1_pruned

pong -m pong_filemap_202307_mergeOmni1_pruned -n poporder_Omni1_newnames.txt -i ind2pop_202012_mergeOmni1_newnames.txt -v
#I saved the summary figure (barplots for major mode K=2 to 12) in PNG and SVG; I also saved the barplots for the Ks where there are several solutions (including the ones highlighting multimodality).

### Plot the cross-validation error.
#I could plot the CV error for the representative run at each value of K ( <=> one run per K); or/and take the average CV for the Ks that fit the major mode for each K ( <=> average across 12 to 20 runs depending on K).

#Transform the CV output so that it corresponds more closely to the output from pong.
cat CVerror_admixture_July2023_Omni1.txt | cut -f1 -d"." | cut -f2 -d"_" > colcluster
cat CVerror_admixture_July2023_Omni1.txt | cut -f1 -d"." | cut -f3 -d"_" > colrepeat
for i in {1..220}; do echo k; done > colk
for i in {1..220}; do echo r; done > colr
lam colk colcluster colr colrepeat > newcol

cat CVerror_admixture_July2023_Omni1.txt | cut -f3 -d":" | sed 's/^ *//g' > colCV

paste colcluster newcol colCV > CVerror_admixture_July2023_Omni1.txt_reformatted #The columns are: K | k_r_ | CV
rm col* newcol

###
### Plot the CV error for the representative run of each major mode
###
#Get list of representative runs from pong
cd /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/analyses/Revisions_NatureComm_2023/ADMIXTURE/pong_output_2023-07-10_10h32m22s
grep Major result_summary.txt | cut -f3 -d" " > result_summary.txt_major_mode_representative_run

#output the corresponding CV
while IFS= read -r line; do
grep "$line\t" ../CVerror_admixture_July2023_Omni1.txt_reformatted >> major_mode_representative_run_CVerror
done < result_summary.txt_major_mode_representative_run
#The lowest CV error is for K=9 (0.52350).

#plot
R
cv <- read.table("major_mode_representative_run_CVerror", col.names=c("K","run","CV"))
pdf(file="20230710_ADMIXTURE_CVerror_major-mode-representative-run.pdf",height=7,width=8,pointsize = 12)
plot(x=cv$K, y=cv$CV, pch=20, xlab="K", ylab="Cross-validation error", main="Cross-validation error for the representative run of the major mode")
dev.off()
q()
n

###
### Plot the average CV error for the runs of each major mode
###
#Get list of relevant runs for each major mode
while IFS= read -r line; do
grep $line result_summary.txt |tail -n1 | cut -f2 -d":" | cut -f1 -d"." | sed 's/runs//g' | tr "," "\n" |  sed 's/^ *//g' >> result_summary.txt_all_runs_major_mode
done < result_summary.txt_major_mode_representative_run

#Get the corresponding CV error
while IFS= read -r line; do
grep "$line\t" ../CVerror_admixture_July2023_Omni1.txt_reformatted >> all_runs_major_mode_CVerror
done < result_summary.txt_all_runs_major_mode

#plot
R
cv <- read.table("all_runs_major_mode_CVerror", col.names=c("K","run","CV"))
pdf(file="20230710_ADMIXTURE_CVerror_mean-runs-major-mode.pdf",height=7,width=8,pointsize = 12)
plot(x=2:12, y=tapply(cv$CV, cv$K, mean), pch=20, xlab="K", ylab="Mean cross-validation error", main="Mean cross-validation error across runs of the major mode")
dev.off()
#The lowest mean error is for K=9 (0.5234854).


