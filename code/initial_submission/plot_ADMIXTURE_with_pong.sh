#Gwenna Breton
#Goal: plot ADMIXTURE results with pong (So far I have been using pong installed locally on my computer).

#OCTOBER 2018
#In the terminal zip admixture folder
#cd /proj/uppstore2018150/private/process/preparedata/admixture/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex/
#mkdir adm_Qs_20181023_mergeOmni2.5_K2-10_20repeats
#cd adm_Qs_20181023_mergeOmni2.5_K2-10_20repeats
#for k in 2 3 4 5 6 7 8 9 10; do
#for i in {1..20}; do
#cp ../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.Q.${i} .
#done
#done
#cd ..
#zip -r adm_Qs_20181022_mergeOmni2.5_K2-10_20repeats.zip adm_Qs_20181023_mergeOmni2.5_K2-10_20repeats

cd /proj/uppstore2018150/private/process/preparedata/admixture/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex
mkdir adm_Qs_20181023_mergeOmni1_K2-10_20repeats
cd adm_Qs_20181023_mergeOmni1_K2-10_20repeats
for k in 2 3 4 5 6 7 8 9 10; do
for i in {1..20}; do
cp ../zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_20181023_mergeOmni1_K2-10_20repeats.zip adm_Qs_20181023_mergeOmni1_K2-10_20repeats

########## run pong locally ##########
cd /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/20181023/ADMIXTURE

#create ind2pop.txt
#get corresponding .fam
#cut -d ' ' -f1 zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.fam > ind2pop_20181023_mergeOmni2.5.txt
cut -d ' ' -f1 zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.fam  > ind2pop_20181023_mergeOmni1.txt

#create pong_filemap
#rm pong_filemap_20181023_mergeOmni2.5
#for k in 2 3 4 5 6 7 8 9 10; do
#for i in {1..20}; do
#echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_20181023_mergeOmni2.5_K2-10_20repeats/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.Q.${i}
#done
#done >> pong_filemap_20181023_mergeOmni2.5

rm pong_filemap_20181023_mergeOmni1
for k in 2 3 4 5 6 7 8 9 10; do
for i in {1..20}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_20181023_mergeOmni1_K2-10_20repeats/zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_5fex.${k}.Q.${i}
done
done >> pong_filemap_20181023_mergeOmni1

#create pop_order_expandednames.txt
#Here I reuse the ones I prepared earlier. Otherwise run the following:
#sort ind2pop.txt | uniq > poporder #and rearange

# run pong
#pong -m pong_filemap -n poporder2 -i ind2pop.txt
pong -m pong_filemap_20181023_mergeOmni2.5 -n poporder_Omni2.5 -i ind2pop_20181023_mergeOmni2.5.txt
pong -m pong_filemap_20181023_mergeOmni1 -n poporder_Omni1 -i ind2pop_20181023_mergeOmni1.txt


#VT2020

# 20200331 (output of October 2018)
# Verbose output
pong -m pong_filemap_20181023_mergeOmni2.5 -n poporder_Omni2.5 -i ind2pop_20181023_mergeOmni2.5.txt -v

# VT2020 output

#Omni2.5 full
#Comment: first prepared for 10 repeats, then for 20.
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni2.5full
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex
#mkdir adm_Qs_20200401_mergeOmni2.5_K2-10_20repeats
#cd adm_Qs_20200401_mergeOmni2.5_K2-10_20repeats
mkdir adm_Qs_20200416_mergeOmni2.5_K2-10_10repeats
cd adm_Qs_20200416_mergeOmni2.5_K2-10_10repeats
for k in 2 3 4 5 6 7 8 9 10; do
for i in {1..10}; do
cp ../${prefix}.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_20200416_mergeOmni2.5_K2-10_10repeats.zip adm_Qs_20200416_mergeOmni2.5_K2-10_10repeats

#Omni1 full
#Done for pruned (K=2 to K=12) and unpruned dataset (K=2 to K=10)
cd /proj/uppstore2018150/private/results/admixture_VT2020_Omni1full
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_5fex
#mkdir adm_Qs_20200402_mergeOmni1_pruned_K2-12_10repeats
#cd adm_Qs_20200402_mergeOmni1_pruned_K2-12_10repeats
mkdir adm_Qs_20200416_mergeOmni1_pruned_K2-12_10repeats
cd adm_Qs_20200416_mergeOmni1_pruned_K2-12_10repeats
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..10}; do
cp ../${prefix}.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_20200416_mergeOmni1_pruned_K2-12_10repeats.zip adm_Qs_20200416_mergeOmni1_pruned_K2-12_10repeats

########## run pong locally ##########
cd /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/VT2020/ADMIXTURE

#create ind2pop.txt
#get corresponding .fam
cut -d ' ' -f1 ../MDS_ASD/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.fam > ind2pop_20200401_mergeOmni2.5.txt
cut -d ' ' -f1 ../MDS_ASD/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam > ind2pop_20200402_mergeOmni1.txt
#Edit 20200422: Use more homogeneous population names (i.e. the ones that I defined for MOSAIC).
cp ind2pop_20200401_mergeOmni2.5.txt tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC.sh ; mv tmp2 ind2pop_20200401_mergeOmni2.5_newnames.txt; rm tmp1
cp ind2pop_20200402_mergeOmni1.txt tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC.sh ; mv tmp2 ind2pop_20200402_mergeOmni1_newnames.txt ; rm tmp1

#create pong_filemap
#rm pong_filemap_20200401_mergeOmni2.5
#for k in 2 3 4 5 6 7 8 9 10; do
#for i in {1..20}; do
#echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_20200401_mergeOmni2.5_K2-10_20repeats/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.Q.${i}
#done
#done >> pong_filemap_20200401_mergeOmni2.5
#
#rm pong_filemap_20200402_mergeOmni1_pruned
#for k in 2 3 4 5 6 7 8 9 10 11 12; do
#for i in {1..10}; do
#echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_20200402_mergeOmni1_pruned_K2-12_10repeats/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_5fex.${k}.Q.${i}
#done
#done >> pong_filemap_20200402_mergeOmni1_pruned

for k in 2 3 4 5 6 7 8 9 10; do
for i in {1..10}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_20200416_mergeOmni2.5_K2-10_10repeats/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_4fex.${k}.Q.${i}
done
done >> pong_filemap_20200416_mergeOmni2.5

for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..10}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_20200416_mergeOmni1_pruned_K2-12_10repeats/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_5fex.${k}.Q.${i}
done
done >> pong_filemap_20200416_mergeOmni1

#create pop_order_expandednames.txt
#Here I reuse the ones I prepared earlier. Otherwise run the following:
#sort ind2pop_20200402_mergeOmni1.txt | uniq > poporder #and rearange
#Edit 20200422: Use more homogeneous population names (i.e. the ones that I defined for MOSAIC).
cp poporder_Omni2.5 tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC.sh ; mv tmp2 poporder_Omni2.5_newnames.txt; rm tmp1
cp poporder_Omni1 tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC.sh ; mv tmp2 poporder_Omni1_newnames.txt; rm tmp1

# run pong
#pong -m pong_filemap_20200401_mergeOmni2.5 -n poporder_Omni2.5 -i ind2pop_20200401_mergeOmni2.5.txt
#pong -m pong_filemap_20200402_mergeOmni1 -n poporder_Omni1 -i ind2pop_20200402_mergeOmni1.txt
#pong -m pong_filemap_20200402_mergeOmni1_pruned -n poporder_Omni1 -i ind2pop_20200402_mergeOmni1.txt

pong -m pong_filemap_20200416_mergeOmni1 -n poporder_Omni1_newnames.txt -i ind2pop_20200402_mergeOmni1_newnames.txt -v #output in pong_output_2020-04-22_12h22m54s
pong -m pong_filemap_20200416_mergeOmni2.5 -n poporder_Omni2.5_newnames.txt -i ind2pop_20200401_mergeOmni2.5_newnames.txt -v #output in pong_output_2020-04-22_12h27m47s

##########################
# July 2020

#Omni1 full pruned K=2 to 12, 20 repeats.
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_July2020_Omni1
prefix=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_2
mkdir adm_Qs_20200717_mergeOmni1_pruned_K2-12_20repeats
cd adm_Qs_20200717_mergeOmni1_pruned_K2-12_20repeats
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..20}; do
cp ../${prefix}.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_20200717_mergeOmni1_pruned_K2-12_20repeats.zip adm_Qs_20200717_mergeOmni1_pruned_K2-12_20repeats

########## run pong locally ##########
cd /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/ADMIXTURE

#create ind2pop.txt
#cut -d ' ' -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_2.fam > ind2pop_20200717_mergeOmni1.txt
cp ind2pop_20200717_mergeOmni1.txt tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 ind2pop_20200717_mergeOmni1_newnames.txt ; rm tmp1

#create pong_filemap
rm pong_filemap_20200717_mergeOmni1_pruned
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..20}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_20200717_mergeOmni1_pruned_K2-12_20repeats/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_2.${k}.Q.${i}
done
done >> pong_filemap_20200717_mergeOmni1_pruned

#create pop_order_expandednames.txt
cp ../../VT2020/ADMIXTURE/poporder_Omni1 . #I removed manually the ColouredAskham and the San Schuster.
cp poporder_Omni1 tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 poporder_Omni1_newnames.txt ; rm tmp1 #I also reorganized a bit - basically I put the Niger-Congo speakers before the eastern Africans.

pong -m pong_filemap_20200717_mergeOmni1_pruned -n poporder_Omni1_newnames.txt -i ind2pop_20200717_mergeOmni1_newnames.txt -v

##########################
# December 2020

#Omni1 full pruned K=2 to 12, 20 repeats.
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
cut -d ' ' -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.fam > ind2pop_202012_mergeOmni1.txt
cp ind2pop_202012_mergeOmni1.txt tmp1; bash /home/gwennabreton/Desktop/Work_from_home/P3/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 ind2pop_202012_mergeOmni1_newnames.txt ; rm tmp1

#create pong_filemap
rm pong_filemap_202012_mergeOmni1_pruned
for k in 2 3 4 5 6 7 8 9 10 11 12; do
for i in {1..20}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.${k}.Q.${i}
done
done >> pong_filemap_202012_mergeOmni1_pruned

#create pop_order_expandednames.txt
#cp ../../VT2020/ADMIXTURE/poporder_Omni1 . #I removed manually the ColouredAskham and the San Schuster.
#cp poporder_Omni1 tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 poporder_Omni1_newnames.txt ; rm tmp1 #I also reorganized a bit - basically I put the Niger-Congo speakers before the eastern Africans.

pong -m pong_filemap_202012_mergeOmni1_pruned -n poporder_Omni1_newnames.txt -i ind2pop_202012_mergeOmni1_newnames.txt -v
#TODO test a new order (like CS suggested).


##########################
# February 2021

#Omni1 + African ancient samples.
#K=2 to 8, 10 repeats (to try it out).

##Create a zipped archive.
cd /proj/snic2020-2-10/uppstore2018150/private/results/admixture_Feb2021_Omni1-plus-ancient/
#prefix=omni1finalmerge_ancient4fexhap_2_ld200-25-0.4
prefix=omni1finalmerge_ancient4fexhap_2_ld50-10-0.1
mkdir adm_Qs_202102_mergeOmni1-ancient_ld50_K2-12_20repeats
cd adm_Qs_202102_mergeOmni1-ancient_ld50_K2-12_20repeats
for k in {2..12} ; do
for i in {1..20} ; do
cp ../${prefix}.${k}.Q.${i} .
done
done
cd ..
zip -r adm_Qs_202102_mergeOmni1-ancient_ld50_K2-12_20repeats.zip adm_Qs_202102_mergeOmni1-ancient_ld50_K2-12_20repeats

##Run PONG locally.

###Create pong_filemap
for k in {2..12}; do
for i in {1..20}; do
echo -e k${k}r${i}'\t'${k}'\t'adm_Qs_202102_mergeOmni1-ancient_ld50_K2-12_20repeats/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.${k}.Q.${i}
done
done >> pong_filemap_202102_mergeOmni1-ancient_ld50_K2-12_20repeats

###Create ind2pop.txt
#cut -f1 omni1finalmerge_ancient4fexhap_2_ld200-25-0.4.fam > ind2pop_202102_mergeOmni1-ancient.txt
#cp ind2pop_202102_mergeOmni1-ancient.txt tmp1; bash /home/gwennabreton/Desktop/from20210203/P3/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 ind2pop_202102_mergeOmni1-ancient_newnames.txt ; rm tmp1 #The names of some ancient samples might still be too long. I will see to it later.

###Create population order file.
#sort ind2pop_202102_mergeOmni1-ancient_newnames.txt |uniq -c > poporder_202102_mergeOmni1-ancient.txt #reordered manually. I used MV's order for the ancient samples.

###Plot.
pong -m pong_filemap_202102_mergeOmni1-ancient -n poporder_202102_mergeOmni1-ancient.txt -i ind2pop_202102_mergeOmni1-ancient_newnames.txt -v
pong -m pong_filemap_202102_mergeOmni1-ancient_ld50 -n poporder_202102_mergeOmni1-ancient.txt -i ind2pop_202102_mergeOmni1-ancient_newnames.txt -v #This looks pretty much the same I think. I will submit more runs of it.
pong -m pong_filemap_202102_mergeOmni1-ancient_ld50_K2-12_20repeats -n poporder_202102_mergeOmni1-ancient.txt -i ind2pop_202102_mergeOmni1-ancient_newnames.txt #Last K with a single mode: K=7. QUESTION: should I try even higher Ks?


##20210218
#Make special plots where the population average is shown for modern populations while all ancient populations are displayed.
#See prepare_ADMIXTURE-plotting_ancient-modern.R for how to prepare the input.

#cp omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.ind2pop tmp1; bash /home/gwennabreton/Desktop/from20210203/P3/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.ind2pop_newnames.txt ; rm tmp1
k=7
i=18
echo -e k${k}r${i}'\t'${k}'\t'omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.pop-avg-modern > omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.filemap
pong -m omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.filemap -n poporder_202102_mergeOmni1-ancient.txt -i omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.ind2pop_newnames.txt

k=6
i=13
echo -e k${k}r${i}'\t'${k}'\t'plot_with_pop-avg/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.${k}.Q.${i}.pop-avg-modern > omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.${k}.Q.${i}.filemap
pong -m omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.${k}.Q.${i}.filemap -n poporder_202102_mergeOmni1-ancient.txt -i omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.ind2pop_newnames.txt

k=6
i=18
cp plot_with_pop-avg/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.${k}.Q.${i}.ind2pop tmp1; bash /home/gwennabreton/Desktop/from20210203/P3/src/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.ind2pop_newnames.txt ; rm tmp1
echo -e k${k}r${i}'\t'${k}'\t'plot_with_pop-avg/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.${k}.Q.${i}.pop-avg-modern > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.${k}.Q.${i}.filemap
pong -m zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.${k}.Q.${i}.filemap -n poporder_202102_mergeOmni1.txt -i zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.ind2pop_newnames.txt

#Edit 20210610: I need to run it again because I have not saved the SVG.
cd Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/December2020/ADMIXTURE/
k=6
i=13
pong -m omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.${k}.Q.${i}.filemap -n poporder_202102_mergeOmni1-ancient.txt -i omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.7.Q.18.ind2pop_newnames.txt























