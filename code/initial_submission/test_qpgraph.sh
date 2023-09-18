#Gwenna Breton
#20210212
#Goal: perform an admixture graph analysis.

cd /proj/snic2020-2-10/uppstore2018150/private/results/qpgraph

#QUESTION Should I use the diploid calls when I have them? For the moment I am using the inbreed: YES option.

#Possible to look at the graphs in Schlebusch 2017 (BBA article).

#Trying to write a scaffold graph based on what we know.
#see /proj/snic2020-2-10/uppstore2018150/private/results/qpgraph/20210212/test_graph_1
#QUESTION: Do I need to include the admixture edges that we know? (e.g. Baka_Cam Nzime_Cam and vice-versa).

#
cd /proj/snic2020-2-10/uppstore2018150/private/results/qpgraph/20210212
cp ../par.qpgraph par.qpgraph.test1.20210212 #Modified with nano.
module load bioinfo-tools AdmixTools/5.0-20171024
qpGraph -p par.qpgraph.test1.20210212 -g test_graph_1 -o test_graph_1.ggg -d test_graph_1.dot > log.test_graph_1 #Not a good fit at all!
qpGraph -p par.qpgraph.test1.20210212 -g test_graph_2 -o test_graph_2.ggg -d test_graph_2.dot > log.test_graph_2 #Not good either - looping. Perhaps I should have it in only one direction.
qpGraph -p par.qpgraph.test1.20210212 -g test_graph_2a -o test_graph_2a.ggg -d test_graph_2a.dot > log.test_graph_2a #Even worst. Perhaps I misunderstood the importance of naming the branches??

#To plot:
dot -Tpng test_graph_1.dot -o test_graph_1.png

#I have a lot of edges with length 0 which is not good (suggests that the edge does not exist).
#TODO continue to try, perhaps ask CS for a starting scaffold graph!

#20210215
#Use the Omni1 (modern only) dataset.
folder=/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020
root=zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4_overlapanc_anc2fex

cd /proj/snic2020-2-10/uppstore2018150/private/results/qpgraph/20210215
sed "s|\/data\/qpGraph|${folder}|g" ../par.qpgraph | sed "s|<filename>|${root}|g" | sed 's/inbreed: YES/inbreed: NO/g' > par.qpgraph.20210215_1

qpGraph -p par.qpgraph.20210215_1 -g test_graph_1 -o test_graph_1.ggg -d test_graph_1.dot > log.test_graph_1 #45.801 Bak        YRI        YRI        Eth
#What does that mean? Yoruba admixed between Baka and Sabue? That is weird. Could that be due to the West African admixture in Baka?
qpGraph -p par.qpgraph.20210215_1 -g test_graph_1b -o test_graph_1b.ggg -d test_graph_1b.dot > log.test_graph_1b #I excluded the Nzime. Not much better (same f3, 38.819).
#Try with the Hadza instead?
qpGraph -p par.qpgraph.20210215_1 -g test_graph_1c -o test_graph_1c.ggg -d test_graph_1c.dot > log.test_graph_1c #I replaced the Baka_Cam by the Batwa (less West African agriculturalists admixture).
#Now there is something off between Yoruba and Nzime. Arghh!!!
qpGraph -p par.qpgraph.20210215_1 -g test_graph_2 -o test_graph_2.ggg -d test_graph_2.dot > log.test_graph_2 #Includes a Nzime -> Baka edge. There is something weird with the Yoruba. Why???

#If I want an outgroup I can look at what I had done for the f4 test.
#TODO try with outgroup.
#TODO try without the Yoruba.

qpGraph -p par.qpgraph.20210215_2 -g test_graph_1 -o test_graph_1.ggg -d test_graph_1.dot > log.test_graph_1_outgroup #does not work ("zero popsize: anc_3apes").

#Okaaaaaaaaayyyyyyyy... So it is driving me a bit crazy. What is the issue here???


#First tree that works! (Worst Z-score: 0.004)
#root    R
#label   Juhoansi        Juhoansi
#label   YRI     YRI
#label   Tanzania_Hadza  Tanzania_Hadza
#
#edge    a       R       Juhoansi
#edge    b       R       nonSan
#edge    c3      nonSan  WestAfrica
#edge    c4      nonSan  EastAfrica
#edge    c5      WestAfrica      YRI
#edge    c7      EastAfrica      Tanzania_Hadza

#Try to add the Baka. Now I miss an internal node!

#Ahah! If you want an admixture edge (e.g. Nzime > Baka) you need to call it "admix" not "edge"!

prefix=test_graph_3c
qpGraph -p par.qpgraph.20210215_1 -g ${prefix} -o ${prefix}.ggg -d ${prefix}.dot > log.${prefix}
dot -Tpng ${prefix}.dot -o ${prefix}.png

#test_graph_3c is quite alright. Now add Baka_Cam. I added it to the nonSan node. Not a good fit. I will try adding an admixture edge and if it still does not work I will add it somewhere else.
#It does work ok, even though I do not like it! (and the percentages are crazy - only 49% come from the "Baka_ancestors").

#test_graph_3c1a.v2: Batwa instead of Baka_Cam. Good fit as well.
#test_graph_3c1b: I tried to add some admixture from Tanzania_Hadza (since the worst Z-score suggests there is something going on there). But it is not better.
#test_graph_3c1c: similar to test_graph_3c1b but inverted. 0% contribution of the Tanzania_Hadza to the Baka_Cam. I do not understand the Z-score!

#Whatever. Trying to add the Kafue now (starting from test_graph_3c1a).
#TODO what could be done to improve these graphs?
#test_graph_3c1a1: branching off from the San. Bad.
#test_graph_3c1a2: admixed between San and YRI. Better (but Z-score is still 40.474).
#test_graph_3c1a3: admixed between San and Baka_Cam. Not great (Z-score 91.859). The Kafue get 100% contribution from the Baka_Cam. QUESTION can you compare Z-scores? (besides significant/not significant) 
#test_graph_3c1a1a: Building upon test_graph_3c1a1 and adding an admixture edge with Baka_Cam. 40.473.
#test_graph_3c1a1b: similar to test_graph_3c1a1a but with RHG instead. No improvement.
#test_graph_3c1a4: admixed between Baka_Cam and YRI. Nope.

#I am slowly running out of ideas...


#test_graph_3c1a5: Make a population admixed between RHG and San (or Juhoansi perhaps) and contribute that to Kafue. Not better. In fact, RHG does contribute 0% to that hypothetical population.

#Ok. I am very annoyed. I decided to use my best model for the dataset with ancient samples and see whether that works.
prefix=test_graph_3c1a
qpGraph -p par.qpgraph.20210215_3 -g ${prefix} -o ${prefix}_withancient.ggg -d ${prefix}_withancient.dot > log.${prefix}_withancient #works fine.
#Adding some ancient samples.
prefix=test_graph_3c1aA #baa001
qpGraph -p par.qpgraph.20210215_3 -g ${prefix} -o ${prefix}.ggg -d ${prefix}.dot > log.${prefix} #Not too bad (5.723). I would need to fix it though. TODO later.
prefix=test_graph_3c1aM #Malawi Malawi_Fingira_2500BP. Not good. There is something with YRI and Sabue, possibly I'd need an extra common ancestor or such.

prefix=test_graph_3c1a-alt #Nzime_Cam instead of YRI. Not too bad but still Z=-4.793. Unmodelled relationship between Nzime, Baka and Hadza...
prefix=test_graph_3c1a-alt2 #Ethiopia_Sabue instead of Tanzania_Hadza. Works fine, in fact slightly lower Z-score than test_graph_3c1a



#Things to try:
#-replace YRI by Nzime
#-replace Tanzania_Hadza by Sabue
#-test YRI+Hadza or another East African population for the Lozi.
#-try to copy the Schlebusch 2017 (BBA) graph (with CEU instead of ancient European).

#20210216
#I continued some of the graphs from 20210215 (see above) and I started in a new folder graphs similar to the BBA article ones.
cd /proj/snic2020-2-10/uppstore2018150/private/results/qpgraph/20210216
prefix=graph_Schlebusch2017_1 #The initial graph, with CEU instead of LBK. Works fine.
prefix=graph_Schlebusch2017_2 #Add Amhara (mix EastAfrican + OOA). 1.893. A bit high but it works! (perhaps I could try mixture CEU+EAfrica).
prefix=graph_Schlebusch2017_3 #Add KS and Juhoansi (Model IV). It works, but the % are quite different from the ones in Schlebusch 2017!
#QUESTION: how far do I want to go here? I do not need all populations (and I need other instead, e.g. Malawi).










