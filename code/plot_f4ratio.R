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
