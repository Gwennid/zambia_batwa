# 2023-07-11
# Gwenna Breton
# Goal: plot projected PCA.
#Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/analyses/December2020/PCA/plot_PCA.R

setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/zambia_batwa/results/revisions_NatureCommunication/PCA")
eval <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36.eval")
evec <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36.evec",skip=1)

#Prepare vector of colours
system(
  "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind |
  sed 's/Juhoansi/red/g' |
  sed 's/YRI/cornflowerblue/g' |
  sed 's/Baka_Cam/chartreuse4/g' |
  sed 's/Bangweulu/darkorchid/g' |
  sed 's/Kafue/darkorchid/g' |
  sed 's/Zambia_Bemba/cyan2/g' |
  sed 's/Zambia_Lozi/cyan2/g' |
  sed 's/Zambia_TongaZam/cyan2/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind |
  sed 's/Juhoansi/2/g' |
  sed 's/YRI/3/g' |
  sed 's/Baka_Cam/1/g' |
  sed 's/Bangweulu/20/g' |
  sed 's/Kafue/18/g' |
  sed 's/Zambia_Bemba/20/g' |
  sed 's/Zambia_Lozi/18/g' |
  sed 's/Zambia_TongaZam/17/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.pch" )

infocol <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.col")
infopch <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.pch")

#I created the ".legend" file by modifying one that I used earlier.
infoleg <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.legend",header=TRUE)

nrpc<-10
nreval <- nrow(eval)
totalev <- sum(eval)
aa <- array(NA,dim=c(nrpc,1))
for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_PC1to6.pdf", width=10, height=15, pointsize=12)
par(mfrow=c(3,2),oma=c(0,0,4,0))
#PC1 PC2
plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#PC1 PC3
plot(evec[,2],evec[,4],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC3: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC4
plot(evec[,2],evec[,5],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC4: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC5
plot(evec[,2],evec[,6],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC5: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC6
plot(evec[,2],evec[,7],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC6: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
legend("topright",legend=c("Ju|'hoansi (Namibia)","Yoruba (Nigeria)","Baka (Cameroon)","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
dev.off()

# #PC1-PC2 only FIGURE 1C
# pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_projected_PC1PC2.pdf", width=8, height=9, pointsize=16)
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# legend("bottomright",legend=c("Ju|'hoansi (Namibia)","Yoruba (Nigeria)","Batwa (Uganda)","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=1)
# dev.off()
# 
# #Batwa_04 is drawn towards the Yorubans on PC2. What do we make of that? It is also an outlier on PC3 (drives PC3) and PC4.
# #I will try without it.
# 
# setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/zambia_batwa/results/revisions_NatureCommunication/projected_PCA")
# eval <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04_killr20.2_popsize36_B_K_ZambiaBantusp_projected.eval")
# evec <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04_killr20.2_popsize36_B_K_ZambiaBantusp_projected.evec",skip=1)
# 
# #Prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04.pedind |
#   sed 's/Juhoansi/red/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' |
#   sed 's/Zambia_Bemba/cyan2/g' |
#   sed 's/Zambia_Lozi/cyan2/g' |
#   sed 's/Zambia_TongaZam/cyan2/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04.pedind |
#   sed 's/Juhoansi/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' |
#   sed 's/Zambia_Bemba/20/g' |
#   sed 's/Zambia_Lozi/18/g' |
#   sed 's/Zambia_TongaZam/17/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04.pedind.pch" )
# 
# infocol <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04.pedind.col")
# infopch <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04.pedind.pch")
# 
# #I created the ".legend" file by modifying one that I used earlier.
# infoleg <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04_projected_PC1to6.pdf", width=10, height=15, pointsize=12)
# par(mfrow=c(3,2),oma=c(0,0,4,0))
# #PC1 PC2
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# #PC1 PC3
# plot(evec[,2],evec[,4],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC3: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC4
# plot(evec[,2],evec[,5],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC4: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC5
# plot(evec[,2],evec[,6],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC5: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC6
# plot(evec[,2],evec[,7],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC6: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
# legend("topright",legend=c("Ju|'hoansi (Namibia)","Yoruba (Nigeria)","Batwa (Uganda)","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# #PC1-PC2 only FIGURE 1C
# pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04_projected_PC1PC2.pdf", width=8, height=9, pointsize=16)
# plot(evec[,3],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC2: ",aa[2,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# legend("bottomright",legend=c("Ju|'hoansi (Namibia)","Yoruba (Nigeria)","Batwa (Uganda)","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=1)
# dev.off()
# #Now it looks very similar to the results with Baka (Cameroon).
