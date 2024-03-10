# 2023-07-10
# Gwenna Breton
# Goal: plot f4 ratio results
# Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/plot_f4ratiotest.R

setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/zambia_batwa/results/revisions_NatureCommunication/f4ratio/")

#Read in the data
data <- read.table(file="f4ratio_20230917_eRHGadmixture_Batwa_anc3apes",header=TRUE)
datar_Batwa <- data[order(data$alpha),]

data <- read.table(file="f4ratio_20230917_wRHGadmixture_Baka_anc3apes",header=TRUE)
datar_Baka <- data[order(data$alpha),]

data <- read.table(file="f4ratio_20230917_KSadmixture_Juhoansi_anc3apes",header=TRUE)
datar_Juhoansi <- data[order(data$alpha),]

data <- read.table(file="f4ratio_20230917_eHGadmixture_Hadza_anc3apes",header=TRUE)
datar_Hadza <- data[order(data$alpha),]

data <- read.table(file="f4ratio_20230917_eHGadmixture_Sabue_anc3apes",header=TRUE)
datar_Sabue <- data[order(data$alpha),]

#Is it always the same order?
#It is like before: Same order for Juhoansi, Baka and Batwa; and inverted order for these three and Hadza/Sabue.
#In fact, it is the same admixture estimates like before (see below); the Z-scores are different though.

# Plot KS and wRHG ancestry (main figure)
pdf(file="20230917_f4ratio_KS-Juhoansi_wRHG-Baka_ancestry_in15pop.pdf",height=7,width=11,pointsize = 12)
par(mfrow=c(1,2))

par(mar=c(5,9,1,5)+0.1)
c(min(datar_Juhoansi$alpha),max(datar_Juhoansi$alpha)) #Gives an indication of which min and max to use on the x axis
plot(y=c(1:nrow(datar_Juhoansi)),x=datar_Juhoansi$alpha,pch=20,axes=FALSE,xlab="Estimated fraction of Ju|'hoansi ancestry (alpha)",ylab="",xlim=c(-0.2,0.22))
arrows(x0=datar_Juhoansi$alpha-datar_Juhoansi$std.err, y0=c(1:nrow(datar_Juhoansi)),x1=datar_Juhoansi$alpha+datar_Juhoansi$std.err, y1=c(1:nrow(datar_Juhoansi)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(datar_Juhoansi)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)
#check here that the order of labels is right: datar_Juhoansi$Target

par(mar=c(5,9,1,5)+0.1)
c(min(datar_Baka$alpha),max(datar_Baka$alpha)) #Gives an indication of which min and max to use on the x axis
plot(y=c(1:nrow(datar_Baka)),x=datar_Baka$alpha,pch=20,axes=FALSE,xlab="Estimated fraction of Baka (Cameroon) ancestry (alpha)",ylab="",xlim=c(-0.3,0.43))
arrows(x0=datar_Baka$alpha-datar_Baka$std.err, y0=c(1:nrow(datar_Baka)),x1=datar_Baka$alpha+datar_Baka$std.err, y1=c(1:nrow(datar_Baka)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(datar_Baka)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)
#check here that the order of labels is right: datar_Baka$Target
dev.off()

# Plot eHG ancestry (alone, Supplementary Figure)
# There was a typo in the figure text, hence the more recent date corresponding to the second revision of the ms.
pdf(file="20240310_f4ratio_eHG-Hadza_ancestry_in15pop.pdf",height=7,width=6,pointsize = 12)
par(mfrow=c(1,1))
par(mar=c(5,9,1,5)+0.1)
c(min(datar_Hadza$alpha),max(datar_Hadza$alpha)) #Gives an indication of which min and max to use on the x axis
plot(y=c(1:nrow(datar_Hadza)),x=datar_Hadza$alpha,pch=20,axes=FALSE,xlab="Estimated fraction of Hadza (Tanzania) ancestry (alpha)",ylab="",xlim=c(-1.5,1))
arrows(x0=datar_Hadza$alpha-datar_Hadza$std.err, y0=c(1:nrow(datar_Hadza)),x1=datar_Hadza$alpha+datar_Hadza$std.err, y1=c(1:nrow(datar_Hadza)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(datar_Hadza)),labels=c("BaTwa (Kafue)","SE Bantu-speakers","Sotho","Zulu","BaTwa (Bangweulu)","Herero","Nzebi","Nzime","Tonga","Bemba","Igbo","Lozi","Mandinka","Luhya","Ba.Kiga"),las=2,tick=FALSE)
#check here that the order of labels is right: datar_Hadza$Target
dev.off()

# Plot eRHG and eHG (Sabue) ancestry (Supplementary Figure for review)
pdf(file="20230917_f4ratio_eRHG-BaTwa_eHG-Sabue_ancestry_in15pop.pdf",height=7,width=11,pointsize = 12)
par(mfrow=c(1,2))

par(mar=c(5,9,1,5)+0.1)
c(min(datar_Batwa$alpha),max(datar_Batwa$alpha)) #Gives an indication of which min and max to use on the x axis
plot(y=c(1:nrow(datar_Batwa)),x=datar_Batwa$alpha,pch=20,axes=FALSE,xlab="Estimated fraction of BaTwa (Uganda) ancestry (alpha)",ylab="",xlim=c(-0.5,0.7))
arrows(x0=datar_Batwa$alpha-datar_Batwa$std.err, y0=c(1:nrow(datar_Batwa)),x1=datar_Batwa$alpha+datar_Batwa$std.err, y1=c(1:nrow(datar_Batwa)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(datar_Batwa)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)
#check here that the order of labels is right: datar_Batwa$Target

par(mar=c(5,9,1,5)+0.1)
c(min(datar_Sabue$alpha),max(datar_Sabue$alpha)) #Gives an indication of which min and max to use on the x axis
plot(y=c(1:nrow(datar_Sabue)),x=datar_Sabue$alpha,pch=20,axes=FALSE,xlab="Estimated fraction of Sabue (Ethiopia) ancestry (alpha)",ylab="",xlim=c(-1,0.63))
arrows(x0=datar_Sabue$alpha-datar_Sabue$std.err, y0=c(1:nrow(datar_Sabue)),x1=datar_Sabue$alpha+datar_Sabue$std.err, y1=c(1:nrow(datar_Sabue)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(datar_Sabue)),labels=c("BaTwa (Kafue)","SE Bantu-speakers","Sotho","Zulu","BaTwa (Bangweulu)","Herero","Nzebi","Nzime","Tonga","Bemba","Igbo","Lozi","Mandinka","Luhya","Ba.Kiga"),las=2,tick=FALSE)
#check here that the order of labels is right: datar_Sabue$Target
dev.off()

###
# Test correlation between the different ancestries
###

#Correlation between eRHG and wRHG admixture
cor.test(datar_Baka$alpha, datar_Batwa$alpha, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1

#Correlation between eRHG and KS admixture
cor.test(datar_Juhoansi$alpha, datar_Batwa$alpha, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1

#Correlation between Hadza and Sabue
cor.test(datar_Hadza$alpha, datar_Sabue$alpha, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1

#Correlation between eRHG and Sabue
cor.test(datar_Batwa$alpha, rev(datar_Sabue$alpha), method=c("spearman")) # S = 1120, p-value < 2.2e-16, rho = -1
#Here I can take rev() because the population order is the same but reverted between the two arrays.

#Correlation between KS and wRHG
cor.test(datar_Juhoansi$alpha, datar_Baka$alpha, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1

#Correlation between KS and eHG
cor.test(datar_Juhoansi$alpha, datar_Hadza$alpha, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1


###
# Estimated admixture for the Zambian populations
###

round(datar_Juhoansi$alpha,3)[c(4,6,7,11,15)]
#0.003 0.024 0.042 0.098 0.212

round(datar_Baka$alpha,3)[c(4,6,7,11,15)]
#0.006 0.049 0.085 0.197 0.427

round(datar_Batwa$alpha,3)[c(4,6,7,11,15)]
#0.010 0.080 0.138 0.320 0.694

round(datar_Hadza$alpha,3)[c(12,10,9,5,1)]
#-0.018 -0.149 -0.259 -0.599 -1.301

round(datar_Sabue$alpha,3)[c(12,10,9,5,1)]
#-0.012 -0.103 -0.179 -0.415 -0.901
