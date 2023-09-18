# Gwenna Breton
# 20200613
# Goal: plot f4 ratio test results.
# 20200717: new plots with new results.
# 20201211: Updated with new results.
# 20210423: We decided to have only the results with Juhoansi for the main figure and the results with RHG and eHG for the supplements.
# 20230213: MJ suggested to have the results for Juhoansi + Baka for the main figure and the eHG for the supplements.

setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/analyses/December2020/f4ratio/")

#Khoe-San and wRHG ancestry (main figure)
pdf(file="20230213_f4ratio_test_KS_wRHG_ancestry_in15pop20201211.pdf",height=7,width=11,pointsize = 12)
par(mfrow=c(1,2))

#KS ancestry
data <- read.table(file="f4ratio_KSadmixture_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,9,1,5)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Ju|'hoansi ancestry (1-alpha)",ylab="")
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)

#wRHG ancestry
data <- read.table(file="f4ratio_wRHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,6,1,2)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Baka (Cameroon) ancestry (1-alpha)",ylab="",xlim=c(-0.4,0.5))
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)
dev.off()

#eHG ancestry (supplementary figure)
pdf(file="20230213_f4ratio_test_eHG_ancestry_in15pop20201211.pdf",height=7,width=5,pointsize = 12)
data <- read.table(file="f4ratio_eHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,8.5,1,3)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Hadza ancestry (1-alpha)",ylab="",xlim=c(-1.5,1))
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("BaTwa (Kafue)","SE Bantu-speakers","Sotho","Zulu","BaTwa (Bangweulu)","Herero","Nzebi","Nzime","Tonga","Bemba","Igbo","Lozi","Mandinka","Luhya","Ba.Kiga"),las=2,tick=FALSE)
dev.off()

#Get the admixture fraction for KS
data <- read.table(file="f4ratio_KSadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_wRHG <- data2[order(data2$admixture),]
data2r_wRHG
round(data2r_wRHG$admixture,3) #value for Kafue: position 15, for Bangweulu: 10
#Bemba: 0.024346 0.007026
#Lozi: 0.002983 0.006406
#Tonga: 0.042167 0.007421

#Get the admixture fraction for wRHG
data <- read.table(file="f4ratio_wRHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_wRHG <- data2[order(data2$admixture),]
data2r_wRHG
round(data2r_wRHG$admixture,3) #value for Kafue: position 15, for Bangweulu: 10
#Bemba: 0.049158 0.014071
#Lozi: 0.006057 0.012908
#Tonga: 0.085118 0.014858

#Get the admixture fraction for eHG
data <- read.table(file="f4ratio_eHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_wRHG <- data2[order(data2$admixture),]
data2r_wRHG
round(data2r_wRHG$admixture,3)
#Kafue: -1.301033 0.115038
#Bangweulu: -0.598941 0.069594
#Bemba: -0.149053 0.047298
#Lozi: -0.017539 0.040003
#Tonga: -0.258693 0.053645

###
###VERSION PRIOR TO 20230213
###
setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/December2020/f4ratio/")

#Khoe-San ancestry (main figure)
pdf(file="20210423_f4ratio_test_KS_ancestry_in15pop20201211.pdf",height=7,width=5,pointsize = 12)
data <- read.table(file="f4ratio_KSadmixture_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,8.5,1,3)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Ju|'hoansi ancestry (1-alpha)",ylab="")
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)
dev.off()

#wRHG and eHG ancestry (supplementary figure)
pdf(file="20210423_f4ratio_test_wRHG_eHG_ancestry_in15pop20201211.pdf",height=7,width=11,pointsize = 12)
par(mfrow=c(1,2))

#wRHG ancestry
data <- read.table(file="f4ratio_wRHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,9,1,5)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Baka (Cameroon) ancestry (1-alpha)",ylab="",xlim=c(-0.4,0.5))
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa (Bangweulu)","Zulu","Sotho","SE Bantu-speakers","BaTwa (Kafue)"),las=2,tick=FALSE)

#eHG ancestry
data <- read.table(file="f4ratio_eHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]
par(mar=c(5,6,1,2)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Hadza ancestry (1-alpha)",ylab="",xlim=c(-1.5,1))
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
axis(side=2,at=c(1:nrow(data2r)),labels=c("BaTwa (Kafue)","SE Bantu-speakers","Sotho","Zulu","BaTwa (Bangweulu)","Herero","Nzebi","Nzime","Tonga","Bemba","Igbo","Lozi","Mandinka","Luhya","Ba.Kiga"),las=2,tick=FALSE)
dev.off()

#Calculate some kind of correlation between the different estimates.
data <- read.table(file="f4ratio_KSadmixture_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_KS <- data2[order(data2$admixture),]

data <- read.table(file="f4ratio_wRHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_wRHG <- data2[order(data2$admixture),]

data <- read.table(file="f4ratio_eHGadmixture_anc3apes",header=TRUE)
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r_eHG <- data2[order(data2$admixture),]

#I cannot use the Pearson correlation test because my values are not from a normal distribution. But I could use a non-parametric test (e.g. Spearman rho).
cor.test(data2r_KS$admixture, data2r_wRHG$admixture, method=c("spearman")) #S = 1.2434e-13, p-value < 2.2e-16, rho=1 which indicates a strong positive correlation.
cor.test(data2r_KS$admixture, rev(data2r_eHG$admixture), method=c("spearman")) #S = 1120, p-value < 2.2e-16, rho=-1 which indicates a strong negative correlation.

###
###OLD VERSION
###
# setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/VT2020/f4ratio/output/")
# setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/f4ratio")
#setwd("/home/gwennabreton/Desktop/Work_from_home/P3/results/December2020/f4ratio/")

#pdf(file="20200717_f4ratio_test_KS_wRHG_eHG_ancestry_in15pop.pdf",height=4,width=8,pointsize = 9)
# pdf(file="20200717_f4ratio_test_KS_wRHG_eHG_ancestry_in15pop20200803.pdf",height=4,width=8,pointsize = 9)
#pdf(file="20201210_f4ratio_test_KS_wRHG_eHG_ancestry_in15pop20201211.pdf",height=4,width=8,pointsize = 9)
par(mfrow=c(1,3))

#Khoe-San ancestry
data <- read.table(file="f4ratio_KSadmixture_anc3apes",header=TRUE) #This is a file created manually from the "logfile" output.
admixture = 1-data$alpha
data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
data2r <- data2[order(data2$admixture),]

par(mar=c(5,8,1,2)+0.1)
plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Ju|'hoansi ancestry (1-alpha)",ylab="")
arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
axis(side=1)
abline(v=0,lty=2)
#axis(side=2,at=c(1:nrow(data2r)),labels=data2r$Target,las=2,tick=FALSE) #This is with default population names. I made a new vector manually with nicer names.
axis(side=2,at=c(1:nrow(data2r)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa Bangweulu","Zulu","Sotho","SEBantu","BaTwa Kafue"),las=2,tick=FALSE)

# #wRHG ancestry
# data <- read.table(file="f4ratio_wRHGadmixture_anc3apes",header=TRUE)
# admixture = 1-data$alpha
# data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
# data2r <- data2[order(data2$admixture),]
# 
# par(mar=c(5,6,1,2)+0.1)
# plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Baka (Cameroon) ancestry (1-alpha)",ylab="",xlim=c(-0.4,0.5))
# arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
# axis(side=1)
# abline(v=0,lty=2)
# #axis(side=2,at=c(1:nrow(data2r)),labels=data2r$Target,las=2,tick=FALSE)
# axis(side=2,at=c(1:nrow(data2r)),labels=c("Ba.Kiga","Luhya","Mandinka","Lozi","Igbo","Bemba","Tonga","Nzime","Nzebi","Herero","BaTwa Bangweulu","Zulu","Sotho","SEBantu","BaTwa Kafue"),las=2,tick=FALSE)
# #It is exactly the same order like the f4 ratio test with the Ju|'hoansi!
# 
# #eHG ancestry
# data <- read.table(file="f4ratio_eHGadmixture_anc3apes",header=TRUE)
# admixture = 1-data$alpha
# data2 <- data.frame("Target"=data$Target, admixture, "std.err"=data$std.err)
# data2r <- data2[order(data2$admixture),]
# par(mar=c(5,6,1,2)+0.1)
# plot(y=c(1:nrow(data2r)),x=data2r$admixture,pch=20,axes=FALSE,xlab="Estimated fraction of Hadza ancestry (1-alpha)",ylab="",xlim=c(-1.5,1))
# arrows(x0=data2r$admixture-data2r$std.err, y0=c(1:nrow(data2r)), x1=data2r$admixture+data2r$std.err, y1=c(1:nrow(data2r)), code=3, angle=90, length=0.02)
# axis(side=1)
# abline(v=0,lty=2)
# #axis(side=2,at=c(1:nrow(data2r)),labels=data2r$Target,las=2,tick=FALSE)
# axis(side=2,at=c(1:nrow(data2r)),labels=c("BaTwa Kafue","SEBantu","Sotho","Zulu","BaTwa Bangweulu","Herero","Nzebi","Nzime","Tonga","Bemba","Igbo","Lozi","Mandinka","Luhya","Ba.Kiga"),las=2,tick=FALSE)
# #And this is exactly the reverse order... Not sure what to make out of it. Possibly these three ratio pick up exactly the same signal for which there is no ideal proxy. I am surprised at the Ba.Kiga/Hadza result!
# #Should I try eRHG? (The issue being that I only have the Batwa)
dev.off()
