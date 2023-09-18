#20210218
#Gwenna Breton
#Goal: Make a more readable 'ADMIXTURE with ancient samples' figure, by showing population averages for the modern samples.

#Strategy 1: use only the representative run.
setwd("/home/gwennabreton/Desktop/from20210203/P3/results/ADMIXTURE/")

K=6 #Replace at will
run=13 #Replace at will
#Values chosen based on pong_output_2021-02-17_12h27m37s/result_summary.txt

pop_ind <- read.table(file="omni1finalmerge_ancient4fexhap_2_ld200-25-0.4.POP-IND")
Qs <- read.table(file=paste("adm_Qs_202102_mergeOmni1-ancient_ld50_K2-12_20repeats/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,sep=""))

Qs_pop_ind <- data.frame(pop_ind,Qs)

modern <- c("Amhara","Baka_Cam","Baka_Gab","Bakiga","Bangweulu","Batwa","Bemba","Bongo_GabE","Bongo_GabS","CEU","Chad_Sara","Chad_Toubou","CHB","Ethiopia_Sabue","GuiGhanaKgal","Igbo","Juhoansi","Kafue","Karretjie","Khomani","Khwe","Lozi","LWK","Mandinka","MKK","Nama","Nzebi_Gab","Nzime_Cam","Oromo","SEBantu","Somali","Sotho","Sudan_Dinka","SWBantu","Tanzania_Hadza","Tonga","Xun","YRI","Zulu")
ancient <- c("BBay","Kenya_500BP","Kenya_IA_Deloraine","Kenya_LSA","Kenya_Pastoral_IA","Kenya_Pastoral_Neolithic","Kenya_Pastoral_Neolithic_Elmenteitan","Malawi_Fingira_2500BP","Malawi_Fingira_6000BP","Malawi_Hora_Holocene","Mota","SAfr_IA_500BP","SAfr_LSA_Cape_2000BP","SAfr_LSA_Pastoralist_1200BP","Shum_Laka_3000BP","Shum_Laka_8000BP","Tanzania_Luxmanda_3000BP","Tanzania_Pemba_1400BP","Tanzania_Pemba_700BP","Tanzania_PN","Tanzania_Zanzibar_1400BP")

system(paste("rm plot_with_pop-avg/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,".pop-avg-modern",sep=""))
system(paste("rm plot_with_pop-avg/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,".ind2pop",sep=""))

for (POP in modern) {
  avg <- c(colMeans(Qs_pop_ind[Qs_pop_ind$V1==POP,3:(K+2)]))
  write.table(file=paste("plot_with_pop-avg/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,".pop-avg-modern",sep=""),t(as.vector(avg)),append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
  write.table(file=paste("plot_with_pop-avg/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,".ind2pop",sep=""),POP,append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
}

for (POP in ancient) {
  subset <- Qs_pop_ind[Qs_pop_ind$V1==POP,3:(K+2)]
  nsam <- nrow(subset)
  write.table(file=paste("plot_with_pop-avg/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,".pop-avg-modern",sep=""),subset,append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
  write.table(file=paste("plot_with_pop-avg/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,".ind2pop",sep=""),matrix(POP,nsam),append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
}

#Do it for the run without ancient samples too, in order to be able to compare better.
K=6
run=18

pop_ind <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.POP-IND") #TODO modify
Qs <- read.table(file=paste("adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.",K,".Q.",run,sep=""))

Qs_pop_ind <- data.frame(pop_ind,Qs)

modern <- c("Amhara","Baka_Cam","Baka_Gab","Bakiga","Bangweulu","Batwa","Zambia_Bemba","Bongo_GabE","Bongo_GabS","CEU","Chad_Sara","Chad_Toubou","CHB","Ethiopia_Sabue","GuiGhanaKgal",
            "Igbo","Juhoansi","Kafue","Karretjie","Khomani","Khwe","Zambia_Lozi","LWK","Mandinka","MKK","Nama","Nzebi_Gab","Nzime_Cam","Oromo","SEBantu","Somali","Sotho","Sudan_Dinka",
            "SWBantu","Tanzania_Hadza","Zambia_TongaZam","Xun","YRI","Zulu")

system(paste("rm plot_with_pop-avg/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.",K,".Q.",run,".pop-avg-modern",sep=""))
system(paste("rm plot_with_pop-avg/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.",K,".Q.",run,".ind2pop",sep=""))

for (POP in modern) {
  avg <- c(colMeans(Qs_pop_ind[Qs_pop_ind$V1==POP,3:(K+2)]))
  write.table(file=paste("plot_with_pop-avg/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.",K,".Q.",run,".pop-avg-modern",sep=""),t(as.vector(avg)),append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
  write.table(file=paste("plot_with_pop-avg/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.",K,".Q.",run,".ind2pop",sep=""),POP,append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
}




