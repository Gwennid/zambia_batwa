# 2023-07-10
# Gwenna Breton
# Goal: plot f4 ratio results
# Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/src/plot_f4ratiotest.R
# TODO figure out why this isn't working!!! (Fitting of the plots to the window, and now it won't even read the dataframe - perhaps it's the Rstudio error again).

setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/analyses/Revisions_NatureComm_2023/f4ratio")

#eRHG and eHG ancestry (main figure)
pdf(file="20230710_f4ratio_test_rRHG-Batwa_eHG-Sabue_ancestry_in15pop20230703.pdf",height=7,width=11,pointsize = 12)
par(mfrow=c(1,2))

#eRHG ancestry
data <- read.table(file="f4ratio_eRHGadmixture_Batwa_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,9,1,5)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Batwa (Uganda) ancestry (1-alpha)",ylab="",xlim=c(-0.5,0.75))
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)
#check here that the order of labels is right: data2r$Target

#eHG ancestry
data <- read.table(file="f4ratio_eHGadmixture_Sabue_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,8.5,1,3)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Sabue (Ethiopia) ancestry (1-alpha)",ylab="",xlim=c(-1,0.7))
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("BaTwa (Kafue)","SE Bantu-speakers","Sotho","Zulu","BaTwa (Bangweulu)","Herero","Nzebi","Nzime","Tonga","Bemba","Igbo","Lozi","Mandinka","Luhya","Ba.Kiga"),las=2,tick=FALSE)
dev.off()

###
# Test correlation with previous results
###

data <- read.table(file="f4ratio_eRHGadmixture_Batwa_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_Batwa <- data2[order(data2$admixture),]

data <- read.table(file="../../December2020/f4ratio/f4ratio_wRHGadmixture_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_Baka <- data2[order(data2$admixture),]

data <- read.table(file="../../December2020/f4ratio/f4ratio_KSadmixture_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_KS <- data2[order(data2$admixture),]

data <- read.table(file="../../December2020/f4ratio/f4ratio_eHGadmixture_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_Hadza <- data2[order(data2$admixture),]

data <- read.table(file="f4ratio_eHGadmixture_Sabue_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_Sabue <- data2[order(data2$admixture),]

#Correlation between eRHG and wRHG admixture
cor.test(data2r_Baka$admixture, data2r_Batwa$admixture, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1

#Correlation between eRHG and KS admixture
cor.test(data2r_KS$admixture, data2r_Batwa$admixture, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1

#Correlation between Hadza and Sabue
cor.test(data2r_Hadza$admixture, data2r_Sabue$admixture, method=c("spearman")) # S = 1.2434e-13, p-value < 2.2e-16, rho = 1

#Correlation between eRHG and Sabue
cor.test(data2r_Batwa$admixture, rev(data2r_Sabue$admixture), method=c("spearman")) # S = 1120, p-value < 2.2e-16, rho = -1
#Here I can take rev() because the population order is the same but reverted between the two arrays.

###
# Estimated admixture for the Zambian populations
###

round(data2r_Batwa$admixture,3)[c(4,6,7,11,15)]
#Lozi: 0.010
#Bemba: 0.08
#Tonga: 0.138
#BaTwa Bangweulu: 0.320
#BaTwa Kafue: 0.694

round(data2r_Baka$admixture,3)[c(4,6,7,11,15)]
#0.006 0.049 0.085 0.197 0.427

round(data2r_KS$admixture,3)[c(4,6,7,11,15)]
#0.003 0.024 0.042 0.098 0.212

round(data2r_Hadza$admixture,3)[c(12,10,9,5,1)]
#-0.018 -0.149 -0.259 -0.599 -1.301

round(data2r_Sabue$admixture,3)[c(12,10,9,5,1)]
#-0.012 -0.103 -0.179 -0.415 -0.901
