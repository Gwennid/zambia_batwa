# 2023-07-10
# Gwenna Breton
# Goal: plot ADMIXTURE results with pong. pong is installed locally. The code is based on /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/plot_ADMIXTURE_with_pong.sh

#Omni1 full pruned K=2 to 12, 20 repeats. Rerun with cross-validation for revisions.
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Dec2020_Omni1/
prefix=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2
mkdir adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats
cd adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..20}; do
cp ../${prefix}.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats.zip adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats

########## run pong locally ##########
cd /home/gwennabreton/Desktop/Work_from_home/P3/results/December2020/ADMIXTURE

#create ind2pop.txt
cut -d ' ' -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.fam > ind2pop_202012_mergeOmn>
cp ind2pop_202012_mergeOmni1.txt tmp1; bash /home/gwennabreton/Desktop/Work_from_home/P3/src/replace_population_names_for_MOSAIC_shorte>

#create pong_filemap
rm pong_filemap_202012_mergeOmni1_pruned
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..20}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Habe>
done
done >> pong_filemap_202012_mergeOmni1_pruned

#create pop_order_expandednames.txt
#cp ../../VT2020/ADMIXTURE/poporder_Omni1 . #I removed manually the ColouredAskham and the San Schuster.
#cp poporder_Omni1 tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAI>

pong -m pong_filemap_202012_mergeOmni1_pruned -n poporder_Omni1_newnames.txt -i ind2pop_202012_mergeOmni1_newnames.txt -v
#TODO test a new order (like CS suggested).
