#Gwenna Breton
#2024-06-02
#Goal: make violin plot of the ROH length by length category.
#TODO in the end: delete the commented text that I didn't need.

setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/zambia_batwa/results/revisions3_NatureCommunication/ROH/")

dataname <- "Omni2.5_roh2"
data1 <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_2_roh2_newnames.hom",header=TRUE)
orderr <- read.table ("poporder_Omni2.5")
newnames=c("BaTwa (Bangweulu)","BaTwa (Kafue)","Bemba","Lozi","Tonga","Khutse San","Ju|'hoansi","Karretjie people","#Khomani","Khwe",
           "Nama","!Xun","Luhya","SE Bantu-speakers","Herero","Zulu","Sotho","Igbo","Mandinka","Yoruba","Maasai","Sara","Toubou",
           "Amhara","Oromo","Somali","CEU","Han")
library(vioplot)

#1-2 Mb

## Select the ROH between 1 and 2 Mb
cat_all1_2 <- data1[(data1$KB >= 1000) & (data1$KB <= 2000), ] #8975 rows, 13 columns
## For each ind, get the total length of ROH in that category. Write it out.
cat_all1_2_tmpp   <- split(cat_all1_2$KB, cat_all1_2$IID) #group the ROH by individual (714 ind)
cat_all1_2_sumind <- sapply(cat_all1_2_tmpp, sum) #for each individual, sum of the lenght of the ROH between 1 and 2 Mb
write.table (cat_all1_2_sumind, file = "xx1_2", quote = FALSE, col.names = FALSE)
## Add the information of population to be able to plot.
cat_all1_2_sumindd <- read.table ("xx1_2")
cat_all1_2_sumindd[,3] <- data1$FID[match(cat_all1_2_sumindd[,1], data1$IID)]
## Remove the individuals that have no ROH in that length category
cat_all1_2_sumindd1 <- cat_all1_2_sumindd[cat_all1_2_sumindd[,2]>0, ]
## Violin plot.
cat_all1_2_sumindd1$V3 <- factor(cat_all1_2_sumindd1$V3, levels=as.character(orderr[,1]))
par(mar=c(9.1,4.1,2.1,2.1),mfrow=c(1,1))
x <- vioplot((cat_all1_2_sumindd1$V2/1000)~cat_all1_2_sumindd1$V3,xlab="",ylab="Sum by individual of ROH in the category 1-2 Mb",
             las=2,col=as.character(orderr$V2),names=newnames)

#2-3 Mb

## Select the ROH between 2 and 3 Mb
cat_all2_3 <- data1[(data1$KB >= 2000) & (data1$KB <= 3000), ] #1268 rows, 13 columns
## For each ind, get the total length of ROH in that category. Write it out.
cat_all2_3_tmpp   <- split(cat_all2_3$KB, cat_all2_3$IID) #group the ROH by individual
cat_all2_3_sumind <- sapply(cat_all2_3_tmpp, sum) #for each individual, sum of the lenght of the ROH between 1 and 2 Mb
write.table (cat_all2_3_sumind, file = "xx2_3", quote = FALSE, col.names = FALSE)
## Add the information of population to be able to plot.
cat_all2_3_sumindd <- read.table ("xx2_3")
cat_all2_3_sumindd[,3] <- data1$FID[match(cat_all2_3_sumindd[,1], data1$IID)]
## Remove the individuals that have no ROH in that length category
cat_all2_3_sumindd1 <- cat_all2_3_sumindd[cat_all2_3_sumindd[,2]>0, ] #551 ind
## Violin plot.
cat_all2_3_sumindd1$V3 <- factor(cat_all2_3_sumindd1$V3, levels=as.character(orderr[,1]))
par(mar=c(9.1,4.1,2.1,2.1),mfrow=c(1,1))
x <- vioplot((cat_all2_3_sumindd1$V2/1000)~cat_all2_3_sumindd1$V3,xlab="",ylab="Sum by individual of ROH in the category 2-3 Mb",
             las=2,col=as.character(orderr$V2),names=newnames)

#Larger than 3 Mb

## Select the ROH between 2 and 3 Mb
cat_all3plus <- data1[(data1$KB >= 3000), ] #1259 rows, 13 columns
## For each ind, get the total length of ROH in that category. Write it out.
cat_all3plus_tmpp   <- split(cat_all3plus$KB, cat_all3plus$IID) #group the ROH by individual
cat_all3plus_sumind <- sapply(cat_all3plus_tmpp, sum) #for each individual, sum of the lenght of the ROH between 1 and 2 Mb
write.table (cat_all3plus_sumind, file = "xx3plus", quote = FALSE, col.names = FALSE)
## Add the information of population to be able to plot.
cat_all3plus_sumindd <- read.table ("xx3plus")
cat_all3plus_sumindd[,3] <- data1$FID[match(cat_all3plus_sumindd[,1], data1$IID)]
## Remove the individuals that have no ROH in that length category
cat_all3plus_sumindd1 <- cat_all3plus_sumindd[cat_all3plus_sumindd[,2]>0, ] #406 ind
## Violin plot.
cat_all3plus_sumindd1$V3 <- factor(cat_all3plus_sumindd1$V3, levels=as.character(orderr[,1]))
par(mar=c(9.1,4.1,2.1,2.1),mfrow=c(1,1))
x <- vioplot((cat_all3plus_sumindd1$V2/1000)~cat_all3plus_sumindd1$V3,xlab="",ylab="Sum by individual of ROH in the category longer than 3 Mb",
             las=2,col=as.character(orderr$V2),names=newnames)

# Write out the sample sizes (n_ind by population) for each of the length categories
write.table(table(cat_all1_2_sumindd1$V3), file="sample_size_1-2Mb", quote = FALSE, row.names = FALSE, col.names = c("Population","n_ind"))
write.table(table(cat_all2_3_sumindd1$V3), file="sample_size_2-3Mb", quote = FALSE, row.names = FALSE, col.names = c("Population","n_ind"))
write.table(table(cat_all3plus_sumindd1$V3), file="sample_size_3Mbormore", quote = FALSE, row.names = FALSE, col.names = c("Population","n_ind"))

# Make a figure with three panels
pdf (file=paste("20240603_violinplot_rohbyind_3classes_roh2.pdf",sep=""), width =8, height = 9, pointsize =10)
layout(matrix(c(1,2,3,3), nrow = 4, ncol = 1, byrow = TRUE))
par(mar=c(1.1,4.1,2.1,2.1))
x <- vioplot((cat_all1_2_sumindd1$V2/1000)~cat_all1_2_sumindd1$V3,xlab="",ylab="Sum by individual of ROH 1-2 Mb",
             las=2,col=as.character(orderr$V2),names=rep("",28))
x <- vioplot((cat_all2_3_sumindd1$V2/1000)~cat_all2_3_sumindd1$V3,xlab="",ylab="Sum by individual of ROH 2-3 Mb",
             las=2,col=as.character(orderr$V2),names=rep("",28))
par(mar=c(12.1,4.1,2.1,2.1))
x <- vioplot((cat_all3plus_sumindd1$V2/1000)~cat_all3plus_sumindd1$V3,xlab="",ylab="Sum by individual of ROH > 3 Mb",
             las=2,col=as.character(orderr$V2),names=newnames)
dev.off()

