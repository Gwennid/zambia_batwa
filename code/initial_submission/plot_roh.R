### Gwenna Breton
### 20200428
### Goal: plot RoH results for the Zambian project.
#20200717: Updated with new results.
#20201211: Updated with new results.
#20210423: Updated population names.

#setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/VT2020/RoH/")
#setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/ROH/")
#setwd("/home/gwennabreton/Desktop/Work_from_home/P3/results/December2020/ROH/")
setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/December2020/ROH/")

## Read data
##roh_indiv <- read.table(file="output/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_3ex_2_roh1.hom.indiv",header=TRUE)
#roh_indiv <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_2_roh2_newnames.hom.indiv",header=TRUE)

#orderr <- read.table ("poporder_Omni2.5")

# Violin plot mean total RoH length by individual by population
# Violin plots are usually done with ggplot2, but otherwise R base has a library: Vioplot.
#library(vioplot)

#roh_indiv$FID <- factor(roh_indiv$FID , levels=as.character(orderr[,1])) #to have them in a better order.

#x <- vioplot((roh_indiv$KB/1000)~roh_indiv$FID,xlab="",ylab="Total length of RoH (Mbp)",las=2,col=as.character(orderr$V2))

newnames=c("BaTwa (Bangweulu)","BaTwa (Kafue)","Bemba","Lozi","Tonga","Khutse San","Ju|'hoansi","Karretjie people","#Khomani","Khwe",
           "Nama","!Xun","Luhya","SE Bantu-speakers","Herero","Zulu","Sotho","Igbo","Mandinka","Yoruba","Maasai","Sara","Toubou",
           "Amhara","Oromo","Somali","CEU","Han")

##pdf (file=paste("violinplot_rohbyind_allclasses_roh2.pdf",sep=""), width =8, height = 6, pointsize =10)
#pdf (file=paste("20210423_violinplot_rohbyind_allclasses_roh2.pdf",sep=""), width =8, height = 6, pointsize =10)
#par(mar=c(9.1,4.1,4.1,2.1),mfrow=c(1,1)) #mgp serves to modify the position of the axis label. But apparently it cannot be different for x and y axis...
#par(mar=c(9.1,4.1,2.1,2.1),mfrow=c(1,1)) #mgp serves to modify the position of the axis label. But apparently it cannot be different for x and y axis...
#vioplot((roh_indiv$KB/1000)~roh_indiv$FID,xlab="",ylab="Total length of RoH (Mbp)",las=2,col=as.character(orderr$V2),names = newnames)
#abline(h=150,lty=2,col="gray")
#abline(h=50,lty=2,col="gray")
#abline(h=100,lty=2,col="gray")
#abline(h=200,lty=2,col="gray")
#abline(h=250,lty=2,col="gray")
##title(main="Average total length of ROH length (Mbp by individual)")
#dev.off()

##col=c("darkgoldenrod2","darkorchid","gray","chocolate","chocolate","gray","red","red","cornflowerblue","red",
##"darkorchid","red","red","red","cornflowerblue","cornflowerblue","chocolate","red","darkgoldenrod2",
##"cornflowerblue","darkgoldenrod2","cornflowerblue","cornflowerblue","red","cornflowerblue","cyan2","cyan2","cyan2","cornflowerblue")
##This is a more basic vector of colours that I sometimes use.

##comment: in Hollfelder 2017, only the RoH between 0.5 and 1Mbp were used for that plot.

# PLOT BY LENGTH CLASS
# I copied code from CS RoH3July2012_NewParamsHenn2PlusGlobal_All.txt, and modified it.

# dataname <- "Omni2.5_roh1"
# data1 <- read.table(file="output/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_3ex_2_roh1.hom",header=TRUE)
# 
# 
# # cat_all <- data1[(data1$KB >= 500) & (data1$KB <= 1000), ]
# # ##
# # cat_all_tmpp   <- split(cat_all$KB, cat_all$IID)
# # cat_all_sumind <- sapply(cat_all_tmpp, sum)
# # write.table (cat_all_sumind, file = "xx", quote = FALSE, col.names = FALSE)
# # cat_all_sumindd <- read.table ("xx")
# # cat_all_sumindd[,3] <-data1$FID[match(cat_all_sumindd[,1], data1$IID)]
# # cat_all_sumindd1<-cat_all_sumindd[cat_all_sumindd[,2]>0, ]
# # cat_all_tmpp   <- split(cat_all_sumindd1[,2], cat_all_sumindd1[,3])
# # cat_all_imeans2 <- sapply(cat_all_tmpp, mean)
# # cat_all_imeans3 <-cat_all_imeans2/1000
# # write.table(cat_all_imeans3, file = "0.5to1Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
# 
# # #1-2 Mbp
# # cat_all1_2 <- data1[(data1$KB >= 1000) & (data1$KB <= 2000), ]
# # cat_all1_2_tmpp   <- split(cat_all1_2$KB, cat_all1_2$IID)
# # cat_all1_2_sumind <- sapply(cat_all1_2_tmpp, sum)
# # write.table (cat_all1_2_sumind, file = "xx1_2", quote = FALSE, col.names = FALSE)
# # cat_all1_2_sumindd <- read.table ("xx1_2")
# # cat_all1_2_sumindd[,3] <-data1$FID[match(cat_all1_2_sumindd[,1], data1$IID)]
# # cat_all1_2_sumindd1<-cat_all1_2_sumindd[cat_all1_2_sumindd[,2]>0, ]
# # cat_all1_2_tmpp   <- split(cat_all1_2_sumindd1[,2], cat_all1_2_sumindd1[,3])
# # cat_all1_2_imeans2 <- sapply(cat_all1_2_tmpp, mean)
# # cat_all1_2_imeans3 <-cat_all1_2_imeans2/1000
# # write.table(cat_all1_2_imeans3, file = "1to2Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
# # 
# # #more than 2Mbp
# # cat_all2_andmore <- data1[(data1$KB >= 2000), ]
# # cat_all2_andmore_tmpp   <- split(cat_all2_andmore$KB, cat_all2_andmore$IID)
# # cat_all2_andmore_sumind <- sapply(cat_all2_andmore_tmpp, sum)
# # write.table (cat_all2_andmore_sumind, file = "xx2_andmore", quote = FALSE, col.names = FALSE)
# # cat_all2_andmore_sumindd <- read.table ("xx2_andmore")
# # cat_all2_andmore_sumindd[,3] <-data1$FID[match(cat_all2_andmore_sumindd[,1], data1$IID)]
# # cat_all2_andmore_sumindd1<-cat_all2_andmore_sumindd[cat_all2_andmore_sumindd[,2]>0, ]
# # cat_all2_andmore_tmpp   <- split(cat_all2_andmore_sumindd1[,2], cat_all2_andmore_sumindd1[,3])
# # cat_all2_andmore_imeans2 <- sapply(cat_all2_andmore_tmpp, mean)
# # cat_all2_andmore_imeans3 <-cat_all2_andmore_imeans2/1000
# # write.table(cat_all2_andmore_imeans3, file = "morethan2Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
# # 
# 
# # Plot
# orderr <- read.table ("poporder_Omni2.5")
# cat_all_label1 <- read.table ("0.5to1Mbp_means")
# reordered <- cat_all_label1[order(match(cat_all_label1[,1],orderr[,1])),]
# cat_all1_2_label1 <- read.table ("1to2Mbp_means")
# reordered1_2 <- cat_all1_2_label1[order(match(cat_all1_2_label1[,1],orderr[,1])),]
# cat_all2_3_label1 <- read.table ("morethan2Mbp_means")
# reordered2_3 <- cat_all2_3_label1[order(match(cat_all2_3_label1[,1],orderr[,1])),]
# 
# allcat <- cbind(reordered[,2],reordered1_2[,2],reordered2_3[,2])
# 
# pdf (file=paste(dataname,".pdf",sep=""), width =30, height = 15, pointsize =15)
# par(mfrow=c(1,1))
# barplot(allcat,beside=TRUE, width = 0.12, cex=2, names.arg=c("0.5-1","1-2","2-5"),
#                xlim = c(0, 11), main=paste("Global Distribution of ROH: ", dataname),
#                xlab="ROH length category (Mb)", ylab="Mean Total ROH length (Mb)", cex.main =3, cex.axis=2, col=as.character(orderr$V2))
# legend("topright",legend=as.character(orderr$V1), ncol=2,fill=as.character(orderr$V2))
# dev.off()
# 
# # Original command (the main change is about the legend).
# #barplot(allcat,beside=TRUE, width = 0.12, legend=as.character(orderr$V1), ncol=2, cex=2, names.arg=c("0.5-1","1-2","2-5"),
# #        xlim = c(0, 11), main=paste("Global Distribution of ROH: ", dataname), 
# #        xlab="ROH length category (Mb)", ylab="Mean Total ROH length (Mb)", cex.main =3, cex.axis=2, col=as.character(orderr$V2))

### Do the same but with the other ROH identification settings ("roh2" - ROH has to be minimum 1000 kb)
dataname <- "Omni2.5_roh2"
# data1 <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_2_roh2_newnames.hom",header=TRUE)
# 
# #1-2 Mbp
# cat_all1_2 <- data1[(data1$KB >= 1000) & (data1$KB <= 2000), ]
# cat_all1_2_tmpp   <- split(cat_all1_2$KB, cat_all1_2$IID)
# cat_all1_2_sumind <- sapply(cat_all1_2_tmpp, sum)
# write.table (cat_all1_2_sumind, file = "xx1_2", quote = FALSE, col.names = FALSE)
# cat_all1_2_sumindd <- read.table ("xx1_2")
# cat_all1_2_sumindd[,3] <-data1$FID[match(cat_all1_2_sumindd[,1], data1$IID)]
# cat_all1_2_sumindd1<-cat_all1_2_sumindd[cat_all1_2_sumindd[,2]>0, ]
# cat_all1_2_tmpp   <- split(cat_all1_2_sumindd1[,2], cat_all1_2_sumindd1[,3])
# cat_all1_2_imeans2 <- sapply(cat_all1_2_tmpp, mean)
# cat_all1_2_imeans3 <-cat_all1_2_imeans2/1000
# write.table(cat_all1_2_imeans3, file = "1to2Mbp_means_roh2", sep = " ", col.names = FALSE, quote = FALSE)
# 
# #2-3 Mbp
# cat_all1_2 <- data1[(data1$KB >= 2000) & (data1$KB <= 3000), ]
# cat_all1_2_tmpp   <- split(cat_all1_2$KB, cat_all1_2$IID)
# cat_all1_2_sumind <- sapply(cat_all1_2_tmpp, sum)
# write.table (cat_all1_2_sumind, file = "xx1_2", quote = FALSE, col.names = FALSE)
# cat_all1_2_sumindd <- read.table ("xx1_2")
# cat_all1_2_sumindd[,3] <-data1$FID[match(cat_all1_2_sumindd[,1], data1$IID)]
# cat_all1_2_sumindd1<-cat_all1_2_sumindd[cat_all1_2_sumindd[,2]>0, ]
# cat_all1_2_tmpp   <- split(cat_all1_2_sumindd1[,2], cat_all1_2_sumindd1[,3])
# cat_all1_2_imeans2 <- sapply(cat_all1_2_tmpp, mean)
# cat_all1_2_imeans3 <-cat_all1_2_imeans2/1000
# write.table(cat_all1_2_imeans3, file = "2to3Mbp_means_roh2", sep = " ", col.names = FALSE, quote = FALSE)
# 
# #more than 3Mbp
# cat_all2_andmore <- data1[(data1$KB >= 3000), ]
# cat_all2_andmore_tmpp   <- split(cat_all2_andmore$KB, cat_all2_andmore$IID)
# cat_all2_andmore_sumind <- sapply(cat_all2_andmore_tmpp, sum)
# write.table (cat_all2_andmore_sumind, file = "xx2_andmore", quote = FALSE, col.names = FALSE)
# cat_all2_andmore_sumindd <- read.table ("xx2_andmore")
# cat_all2_andmore_sumindd[,3] <-data1$FID[match(cat_all2_andmore_sumindd[,1], data1$IID)]
# cat_all2_andmore_sumindd1<-cat_all2_andmore_sumindd[cat_all2_andmore_sumindd[,2]>0, ]
# cat_all2_andmore_tmpp   <- split(cat_all2_andmore_sumindd1[,2], cat_all2_andmore_sumindd1[,3])
# cat_all2_andmore_imeans2 <- sapply(cat_all2_andmore_tmpp, mean)
# cat_all2_andmore_imeans3 <-cat_all2_andmore_imeans2/1000
# write.table(cat_all2_andmore_imeans3, file = "morethan3Mbp_means_roh2", sep = " ", col.names = FALSE, quote = FALSE)

# Plot
orderr <- read.table ("poporder_Omni2.5")
cat_all1_2_label1 <- read.table ("1to2Mbp_means_roh2")
reordered1_2 <- cat_all1_2_label1[order(match(cat_all1_2_label1[,1],orderr[,1])),]
cat_all2_3_label1 <- read.table ("2to3Mbp_means_roh2")
reordered2_3 <- cat_all2_3_label1[order(match(cat_all2_3_label1[,1],orderr[,1])),]
cat_all3_label1 <- read.table ("morethan3Mbp_means_roh2")
reordered3 <- cat_all3_label1[order(match(cat_all3_label1[,1],orderr[,1])),]

allcat <- cbind(reordered1_2[,2],reordered2_3[,2],reordered3[,2])

#pdf(file=paste(dataname,"_newnames.pdf",sep=""), width =8.5, height = 5, pointsize =9)
pdf(file=paste(dataname,"_newnames_20220120.pdf",sep=""), width =8.5, height = 5, pointsize =9)
par(mfrow=c(1,1))
barplot(allcat,beside=TRUE, width = 0.12, cex=2, names.arg=c("1-2","2-3","3-5"),
        xlim = c(0, 11), main=paste("Global Distribution of ROH: ", dataname),
        xlab="ROH length category (Mb)", ylab="Mean Total ROH length (Mb)", cex.main =1.5, cex.axis=1, col=as.character(orderr$V2))
legend("top",legend=newnames, ncol=2, fill=as.character(orderr$V2), cex=0.9, bty="n")
dev.off()




#TODO choose a color-blind friendly colour scheme for this article!
