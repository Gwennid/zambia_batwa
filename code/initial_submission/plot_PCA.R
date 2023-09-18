#Gwenna Breton
#Edit 20200331: File edited to work for outputs from spring 2020.
#Edit 20200717: and now for outputs from July 2020 (4 Lozi individuals removed, Schuster San removed, ColouredAskham became Khomani).
#Edit 20201211: Updated with new results.

#setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/VT2020/PCA/")
#setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/PCA/")
#setwd("/home/gwennabreton/Desktop/Work_from_home/P3/results/December2020/PCA/")
#setwd("/home/ecodair/Bureau/Work_from_home/P3/results/December2020/PCA")
setwd("/home/gwennabreton/Desktop/from20210303/P3/results/PCA/")

#Omni2.5
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_killr20.2_popsize36.evec",skip=1)
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_killr20.2_popsize36_BaTwaontop.evec",skip=1)
#eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex_killr20.2_popsize36.eval")
#evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3-4Lozi-schus-ex_fex_killr20.2_popsize36_Batwaontop.evec",skip=1)
# eval <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_killr20.2_popsize36.eval")
# evec <- read.table(file = "zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_killr20.2_popsize36_Batwaontop.evec", skip=1) #the .evec and the .pedind were modified manually so that the samples from Bangweulu and Kafue come last in the file and on top in the PCA plot.

# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_Batwaontop.pedind |
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' |
#   sed 's/Zambia_Bemba/cyan2/g' |
#   sed 's/Zambia_Lozi/cyan2/g' |
#   sed 's/Zambia_TongaZam/cyan2/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_Batwaontop.pedind.col" )

# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_Batwaontop.pedind |
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' |
#   sed 's/Zambia_Bemba/20/g' |
#   sed 's/Zambia_Lozi/18/g' |
#   sed 's/Zambia_TongaZam/17/g' >  zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_Batwaontop.pedind.pch" )
  
infocol <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_Batwaontop.pedind.col") #
infopch <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_Batwaontop.pedind.pch")
#infoleg <- read.table(file="../MDS_ASD/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.legend",header=TRUE)
infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.legend",header=TRUE) #modified slightly (mostly: I replaced the KGP abbreviations).

nrpc<-10
nreval <- nrow(eval)
totalev <- sum(eval)
aa <- array(NA,dim=c(nrpc,1))
for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC

newnames=c("Amhara","Oromo","Somali","Khutse San","Ju|'hoansi","Karretjie people","#Khomani","Khwe","Nama","!Xun","Luhya","SEBantu","Herero","Yoruba","Sotho","Zulu","Igbo","Mandinka","Maasai","Sara","Toubou","CEU","Han","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga")

pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_Batwaontop20201211.pdf", width=10, height=15, pointsize=12)
par(mfrow=c(3,2),oma=c(0,0,0,0))
#PC1 PC2
plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#PC1 PC3
plot(evec[,2],evec[,4],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC3: ",aa[3,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC4
plot(evec[,2],evec[,5],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC4: ",aa[4,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC5
plot(evec[,2],evec[,6],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC5: ",aa[5,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC6
plot(evec[,2],evec[,7],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC6: ",aa[6,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
#legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
legend("topright",legend=newnames,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
dev.off()

# #Plot only PC1 and PC2
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_PC1PC2_BaTwaontop.pdf", width=10, height=10, pointsize=10)
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# legend("bottomleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()

# pedind <- read.table(file="zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.pedind")
# pdf(file="zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_PC1to6_popnames.pdf", width=10, height=15, pointsize=12)
# par(mfrow=c(3,2),oma=c(0,0,4,0))
# #PC1 PC2
# plot(evec[,2],evec[,3],col=0,pch=0,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# text(evec[,2], evec[,3], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# #PC1 PC3
# plot (evec[,2], evec[,4], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC3: ", aa[3,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,4], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC4
# plot (evec[,2], evec[,5], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC4: ", aa[4,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,5], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC5
# plot (evec[,2], evec[,6], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC5: ", aa[5,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,6], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC6
# plot (evec[,2], evec[,7], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC6: ", aa[6,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,7], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 

#Omni1 FIGURE S1
#eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_killr20.2_popsize36.evec",skip=1)
# pedind <- read.table(file = "zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.pedind")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_killr20.2_popsize36_BaTwaontop.evec",skip=1)
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_killr20.2_popsize36_Batwaontop.evec",skip=1)
#eval <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_killr20.2_popsize36.eval")
#evec <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_killr20.2_popsize36_Batwaontop.evec",skip=1)
eval <- read.table(file="zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex_killr20.2_popsize36.eval")
evec <- read.table(file="zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex_killr20.2_popsize36.evec",skip=1)

#prepare vector of colours
system(
  "cut -d\" \" -f1 zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex.pedind |
  sed 's/Amhara/darkgoldenrod2/g' |
  sed 's/Oromo/darkgoldenrod2/g' |
  sed 's/Somali/darkgoldenrod2/g' |
  sed 's/ColouredAskham/red/g' |
  sed 's/GuiGhanaKgal/red/g' |
  sed 's/Juhoansi/red/g' |
  sed 's/Karretjie/red/g' |
  sed 's/Khomani/red/g' |
  sed 's/Khwe/red/g' |
  sed 's/Nama/red/g' |
  sed 's/schus/red/g' |
  sed 's/Xun/red/g' |
  sed 's/LWK/cornflowerblue/g' |
  sed 's/SEBantu/cornflowerblue/g' |
  sed 's/SWBantu/cornflowerblue/g' |
  sed 's/YRI/cornflowerblue/g' |
  sed 's/Sotho/cornflowerblue/g' |
  sed 's/Zulu/cornflowerblue/g' |
  sed 's/Igbo/cornflowerblue/g' |
  sed 's/Mandinka/cornflowerblue/g' |
  sed 's/Batwa/chartreuse4/g' |
  sed 's/Baka_Cam/chartreuse4/g' |
  sed 's/Baka_Gab/chartreuse4/g' |
  sed 's/Bongo_GabE/chartreuse4/g' |
  sed 's/Bongo_GabS/chartreuse4/g' |
  sed 's/Nzime_Cam/blue/g' |
  sed 's/Nzebi_Gab/blue/g' |
  sed 's/Bakiga/blue/g' |
  sed 's/MKK/chocolate/g' |
  sed 's/Chad_Sara/chocolate/g' |
  sed 's/Chad_Toubou/chocolate/g' |
  sed 's/CEU/black/g' |
  sed 's/CHB/black/g' |
  sed 's/Bangweulu/darkorchid/g' |
  sed 's/Kafue/darkorchid/g' |
  sed 's/Zambia_Bemba/cyan2/g' |
  sed 's/Zambia_Lozi/cyan2/g' |
  sed 's/Zambia_TongaZam/cyan2/g' |
  sed 's/Sudan_Dinka/chocolate/g'|
  sed 's/Tanzania_Hadza/indianred1/g'|
  sed 's/Ethiopia_Sabue/indianred1/g' >  zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex.pedind.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex.pedind |
  sed 's/Amhara/0/g' |
  sed 's/Oromo/1/g' |
  sed 's/Somali/2/g' |
  sed 's/ColouredAskham/0/g' |
  sed 's/GuiGhanaKgal/1/g' |
  sed 's/Juhoansi/2/g' |
  sed 's/Karretjie/3/g' |
  sed 's/Khomani/4/g' |
  sed 's/Khwe/5/g' |
  sed 's/Nama/6/g' |
  sed 's/schus/7/g' |
  sed 's/Xun/8/g' |
  sed 's/LWK/0/g' |
  sed 's/SEBantu/1/g' |
  sed 's/SWBantu/2/g' |
  sed 's/YRI/3/g' |
  sed 's/Sotho/4/g' |
  sed 's/Zulu/5/g' |
  sed 's/Igbo/6/g' |
  sed 's/Mandinka/7/g' |
  sed 's/Batwa/0/g' |
  sed 's/Baka_Cam/1/g' |
  sed 's/Baka_Gab/2/g' |
  sed 's/Bongo_GabE/3/g' |
  sed 's/Bongo_GabS/4/g' |
  sed 's/Nzime_Cam/0/g' |
  sed 's/Nzebi_Gab/1/g' |
  sed 's/Bakiga/2/g' |
  sed 's/MKK/0/g' |
  sed 's/Chad_Sara/1/g' |
  sed 's/Chad_Toubou/2/g' |
  sed 's/CEU/0/g' |
  sed 's/CHB/1/g' |
  sed 's/Bangweulu/20/g' |
  sed 's/Kafue/18/g' |
  sed 's/Zambia_Bemba/20/g' |
  sed 's/Zambia_Lozi/18/g' |
  sed 's/Zambia_TongaZam/17/g' |
  sed 's/Sudan_Dinka/3/g'|
  sed 's/Tanzania_Hadza/0/g'|
  sed 's/Ethiopia_Sabue/1/g'  > zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex.pedind.pch" )

#infocol <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Batwaontop.pedind.col")
#infopch <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Batwaontop.pedind.pch")
infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex.legend",header=TRUE)
infocol <- read.table(file="zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex.pedind.col")
infopch <- read.table(file="zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex.pedind.pch")

nrpc<-10
nreval <- nrow(eval)
totalev <- sum(eval)
aa <- array(NA,dim=c(nrpc,1))
for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC

newnames=c("Amhara","Oromo","Somali","Khutse San","Ju|'hoansi","Karretjie people","#Khomani","Khwe","Nama","!Xun","Luhya","SEBantu","Herero","Yoruba","Sotho","Zulu","Igbo","Mandinka","Batwa","Baka_C","Baka_G","Bongo_E","Bongo_S","Nzime","Nzebi","Ba.Kiga","Maasai","Sara","Toubou","CEU","Han","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga","Dinka","Hadza","Sabue")
pdf(file="zbatwa8_zbantu8_Schlebusch7_KGP8_Patin8_1-22_5fex_PC1to6_20210121.pdf", width=10, height=15, pointsize=12)
par(mfrow=c(3,2),oma=c(0,0,0,0))
#PC1 PC2
plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#PC1 PC3
plot(evec[,2],evec[,4],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC3: ",aa[3,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC4
plot(evec[,2],evec[,5],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC4: ",aa[4,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC5
plot(evec[,2],evec[,6],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC5: ",aa[5,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC6
plot(evec[,2],evec[,7],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC6: ",aa[6,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
#legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
legend("topright",legend=newnames,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
dev.off()

#Plot only PC1 and PC2 FIGURE 1B
pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_BaTwaontop_smaller20201211.pdf", width=7, height=7, pointsize=10)
plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
#legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=5)
#legend("bottomleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=5)
dev.off()


# pdf(file="zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_4fex_PC1to6_popnames.pdf", width=10, height=15, pointsize=12)
# par(mfrow=c(3,2),oma=c(0,0,4,0))
# #PC1 PC2
# plot(evec[,2],evec[,3],col=0,pch=0,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# text(evec[,2], evec[,3], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# #PC1 PC3
# plot (evec[,2], evec[,4], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC3: ", aa[3,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,4], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC4
# plot (evec[,2], evec[,5], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC4: ", aa[4,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,5], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC5
# plot (evec[,2], evec[,6], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC5: ", aa[5,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,6], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC6
# plot (evec[,2], evec[,7], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC6: ", aa[6,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,7], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()



###
###  PCA with KS, RHG and West Africans + projection of the Zambian and RHG neighbours samples
###
#Edit 20210310: similar but with the Nzime instead of the Yoruba. The input with the Yoruba was zbatwa9_Schlebusch2012_1KGP36_Patin108_2.pedind.

#prepare the col and pch files
#Omni1
#prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP36_Patin108_2.pedind |
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP36_Patin108_2.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP36_Patin108_2.pedind |
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP36_Patin108_2.pedind.pch" )

# eval <- read.table(file="zbatwa9_Schlebusch2012_1KGP36_Patin108_2_killr20.2_popsize36_RHGnandZambianprojected.eval")
# evec <- read.table(file="zbatwa9_Schlebusch2012_1KGP36_Patin108_2_killr20.2_popsize36_RHGnandZambianprojected.evec",skip=1)
# infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP36_Patin108_2.pedind.col")
# infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP36_Patin108_2.pedind.pch")
# infoleg <- read.table(file="zbatwa9_Schlebusch2012_1KGP36_Patin108_2.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_Schlebusch2012_1KGP36_Patin108_2_killr20.2_popsize36_RHGnandZambianprojected_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# title("Zambian and RHG neighbours projected onto PCA of KS, RHG and YRI")
# dev.off()

# #PC1-PC2 only
# pdf(file="zbatwa9_Schlebusch2012_1KGP36_Patin108_2_killr20.2_popsize36_RHGnandZambianprojected_PC1PC2.pdf", width=10, height=10, pointsize=12)
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# legend("topleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# title("Zambian and RHG neighbours projected onto PCA of KS, RHG and YRI")
# dev.off()

###
### 20200415 - Plot smaller PCAs
###

# #Omni1, YRI-Baka-Cam-Juhoansi-Bangweulu-Kafue
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_killr20.2_popsize36.evec",skip=1)
# 
# # #prepare vector of colours
# # system(
# #   "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind | 
# #   sed 's/Juhoansi/red/g' |
# #   sed 's/YRI/cornflowerblue/g' |
# #   sed 's/Baka_Cam/chartreuse4/g' |
# #   sed 's/Bangweulu/darkorchid/g' |
# #   sed 's/Kafue/darkorchid/g' > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind.col" )
# # 
# # #Prepare vector of pch
# # system(
# #   "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind | 
# #   sed 's/Juhoansi/2/g' |
# #   sed 's/YRI/3/g' |
# #   sed 's/Baka_Cam/1/g' |
# #   sed 's/Bangweulu/20/g' |
# #   sed 's/Kafue/18/g'  > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind.pch" )
# 
# infocol <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind.col")
# infopch <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind.pch")
# infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=c("Juhoansi","Yoruba","Baka (Cameroon)","Bangweulu","Kafue"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# #Omni1, YRI-Baka-Cam-Juhoansi, Bangweulu-Kafue projected
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_killr20.2_popsize36_B_K_projected.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_killr20.2_popsize36_B_K_projected.evec",skip=1)
# infocol <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind.col")
# infopch <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.pedind.pch")
# infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_B_K_projected_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=c("Juhoansi","Yoruba","Baka (Cameroon)","Bangweulu","Kafue"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# #PC1-PC2 only
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_B_K_projected_PC1PC2.pdf", width=10, height=10, pointsize=12)
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# legend("bottomright",legend=c("Juhoansi","Yoruba","Baka (Cameroon)","Bangweulu","Kafue"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# title("Zambian BaTwa individuals projected onto PCA of Juhoansi, Baka and Yoruba")
# dev.off()
# 
# #Omni1, Nzebi-Baka-Cam-Juhoansi, Bangweulu-Kafue projected
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2_killr20.2_popsize36_B_K_projected.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2_killr20.2_popsize36_B_K_projected.evec",skip=1)
# 
# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2.pedind |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2.pedind |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g'  > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2.pedind.pch" )
# 
# infocol <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2.pedind.col")
# infopch <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2.pedind.pch")
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# 
# #PC1-PC2 only
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzebi_Baka-Cam_Juhoansi_B_Z_2_B_K_projected_PC1PC2.pdf", width=10, height=10, pointsize=12)
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# legend("bottomleft",legend=c("Juhoansi","Nzebi","Baka (Cameroon)","Bangweulu","Kafue"),col=c("red","blue","chartreuse4","darkorchid","darkorchid"),pch=c(2,1,1,20,18),ncol=2)
# title("Zambian BaTwa individuals projected onto PCA of Juhoansi, Baka and Nzebi")
# dev.off()

#20200506
#Omni1, YRI-Baka-Cam-Juhoansi, Bangweulu-Kafue-Bemba-Lozi-Tonga projected (I also have the non projected version but I won't plot it now).
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_2_killr20.2_popsize36_B_K_ZambiaBantusp_projected.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_2_killr20.2_popsize36_B_K_ZambiaBantusp_projected.evec",skip=1)
#eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36_B_K_ZambiaBantusp_projected.eval")
#evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4-4Lozi-schus-ex_fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36_B_K_ZambiaBantusp_projected.evec",skip=1)
eval <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36_B_K_ZambiaBantusp_projected.eval")
evec <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36_B_K_ZambiaBantusp_projected.evec",skip=1)

# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind |
#   sed 's/Juhoansi/red/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' |
#   sed 's/Zambia_Bemba/cyan2/g' |
#   sed 's/Zambia_Lozi/cyan2/g' |
#   sed 's/Zambia_TongaZam/cyan2/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind |
#   sed 's/Juhoansi/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' |
#   sed 's/Zambia_Bemba/20/g' |
#   sed 's/Zambia_Lozi/18/g' |
#   sed 's/Zambia_TongaZam/17/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.pch" )

infocol <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.col")
infopch <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.pch")
infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_2.legend",header=TRUE)

nrpc<-10
nreval <- nrow(eval)
totalev <- sum(eval)
aa <- array(NA,dim=c(nrpc,1))
for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_2_B_K_ZambiaBantusp_projected_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=c("Juhoansi","Yoruba","Baka (Cameroon)","Bangweulu","Kafue","Bemba","Lozi","Tonga"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()

#PC1-PC2 only FIGURE 1C
pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_projected_PC1PC2_smaller20201211.pdf", width=8, height=9, pointsize=16)
#plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
plot(evec[,3],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC2: ",aa[2,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
legend("topleft",legend=c("Ju|'hoansi (Namibia)","Yoruba (Nigeria)","Baka (Cameroon)","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=1)
#title("Zambian BaTwa and Bantu-speaker individuals projected onto PCA of Juhoansi, Baka and Yoruba")
dev.off()

# #Omni1, YRI-Baka-Cam-Juhoansi-Hadza-Bangweulu-Kafue
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2_killr20.2_popsize36.evec",skip=1)
# 
# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind | 
#   sed 's/Juhoansi/red/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' |
#   sed 's/Tanzania_Hadza/indianred1/g' > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind | 
#   sed 's/Juhoansi/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' |
#   sed 's/Tanzania_Hadza/0/g' > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind.pch" )
# 
# infocol <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind.col")
# infopch <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind.pch")
# infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# #Omni1, YRI-Baka-Cam-Juhoansi-Hadza-Bangweulu-Kafue
# eval <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2_killr20.2_popsize36_B_K_projected.eval")
# evec <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2_killr20.2_popsize36_B_K_projected.evec",skip=1)
# infocol <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind.col")
# infopch <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.pedind.pch")
# infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Baka-Cam_Juhoansi_Hadza_B_Z_2_B_K_projected_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()

# ###
# ### Without CHB
# ###
# 
# #Omni2.5
# eval <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex_killr20.2_popsize36.evec",skip=1)
# pedind <- read.table(file = "zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pedind")
# 
# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pedind | 
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pedind | 
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pedind.pch" )
# 
# infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pedind.col")
# infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pedind.pch")
# infoleg <- read.table(file="../MDS_ASD/zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# #Omni1
# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pedind | 
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pedind | 
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pedind.pch" )
# 
# eval <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex_killr20.2_popsize36.evec",skip=1)
# infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pedind.col")
# infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pedind.pch")
# infoleg <- read.table(file="../MDS_ASD/zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# ###
# ### Without CEU + CHB
# ###
# 
# #Omni2.5
# 
# eval <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex_killr20.2_popsize36.evec",skip=1)
# pedind <- read.table(file = "zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pedind")
# 
# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pedind | 
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pedind | 
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pedind.pch" )
# 
# infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pedind.col")
# infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pedind.pch")
# infoleg <- read.table(file="../MDS_ASD/zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# pdf(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex_PC1to6_popnames.pdf", width=10, height=15, pointsize=12)
# par(mfrow=c(3,2),oma=c(0,0,4,0))
# #PC1 PC2
# plot(evec[,2],evec[,3],col=0,pch=0,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# text(evec[,2], evec[,3], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# #PC1 PC3
# plot (evec[,2], evec[,4], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC3: ", aa[3,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,4], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC4
# plot (evec[,2], evec[,5], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC4: ", aa[4,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,5], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC5
# plot (evec[,2], evec[,6], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC5: ", aa[5,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,6], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC6
# plot (evec[,2], evec[,7], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC6: ", aa[6,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,7], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# 
# #Omni1
# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pedind | 
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pedind | 
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pedind.pch" )
# 
# eval <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex_killr20.2_popsize36.eval")
# evec <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex_killr20.2_popsize36.evec",skip=1)
# infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pedind.col")
# infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pedind.pch")
# infoleg <- read.table(file="../MDS_ASD/zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.legend",header=TRUE)
# 
# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# pdf(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex_PC1to6.pdf", width=10, height=15, pointsize=12)
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
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()
# 
# pdf(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex_PC1to6_popnames.pdf", width=10, height=15, pointsize=12)
# par(mfrow=c(3,2),oma=c(0,0,4,0))
# #PC1 PC2
# plot(evec[,2],evec[,3],col=0,pch=0,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# text(evec[,2], evec[,3], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# #PC1 PC3
# plot (evec[,2], evec[,4], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC3: ", aa[3,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,4], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC4
# plot (evec[,2], evec[,5], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC4: ", aa[4,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,5], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC5
# plot (evec[,2], evec[,6], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC5: ", aa[5,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,6], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC6
# plot (evec[,2], evec[,7], col = 0, pch = 0, xlab=paste("PC1: ", aa[1,1], "%", sep=""), ylab=paste("PC6: ", aa[6,1], "%", sep=""),asp=1)
# text(evec[,2], evec[,7], pedind[,1], cex = 0.7, col = as.vector(infocol$V1))
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# dev.off()

#20200108
#Omni1 + ancient (new figure)
pedind <- read.table(file = "omni1finalmerge_ancient4fexhap.pedind")
eval <- read.table(file="omni1finalmerge_ancient4fexhap_killr20.2_popsize36_ancientprojected.eval")
# evec <- read.table(file="omni1finalmerge_ancient4fexhap_killr20.2_popsize36_ancientprojected.evec",skip=1)
evec <- read.table(file="omni1finalmerge_ancient4fexhap_killr20.2_popsize36_ancientprojected_Batwaontop.evec",skip=1)

#Edit 20210127: new settings
setwd("/home/gwennabreton/Desktop/20210128/PCA/")
pedind <- read.table(file = "omni1finalmerge_ancient4fexhap_2_Africaonly.pedind")
eval <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_20210125.eval")
evec <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_20210125.evec",skip=1)


# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 omni1finalmerge_ancient4fexhap_2_Africaonly.pedind |
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' |
#   sed 's/Zambia_Bemba/cyan2/g' |
#   sed 's/Zambia_Lozi/cyan2/g' |
#   sed 's/Zambia_TongaZam/cyan2/g' |
#   sed 's/Sudan_Dinka/chocolate/g'|
#   sed 's/Tanzania_Hadza/indianred1/g'|
#   sed 's/Ethiopia_Sabue/indianred1/g' |
#   sed 's/baa001/gray30/g' |
#   sed 's/bab001/gray60/g' |
#   sed 's/cha001/gray90/g' |
#   sed 's/ela001/gray30/g' |
#   sed 's/I9028/gray60/g' |
#   sed 's/I9133/gray90/g' |
#   sed 's/I9134/gray30/g' |
#   sed 's/Kenya_500BP/gray60/g' |
#   sed 's/Kenya_IA_Deloraine/gray90/g' |
#   sed 's/Kenya_LSA/gray30/g' |
#   sed 's/Kenya_Pastoral_IA/gray60/g' |
#   sed 's/Kenya_Pastoral_Neolithic_Elmenteitan/gray30/g' |
#   sed 's/Kenya_Pastoral_Neolithic/gray90/g' |
#   sed 's/Malawi_Fingira_2500BP/gray60/g' |
#   sed 's/Malawi_Fingira_6000BP/gray90/g' |
#   sed 's/Malawi_Hora_Holocene/gray30/g' |
#   sed 's/mfo001/gray60/g' |
#   sed 's/Mota/gray90/g' |
#   sed 's/new001/gray30/g' |
#   sed 's/Shum_Laka/gray60/g' |
#   sed 's/Tanzania_Luxmanda_3000BP/gray90/g' |
#   sed 's/Tanzania_Pemba_1400BP/gray30/g' |
#   sed 's/Tanzania_Pemba_700BP/gray60/g' |
#   sed 's/Tanzania_PN/gray90/g' |
#   sed 's/Tanzania_Zanzibar_1400BP/gray30/g' >  omni1finalmerge_ancient4fexhap_2_Africaonly.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 omni1finalmerge_ancient4fexhap_2_Africaonly.pedind |
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' |
#   sed 's/Zambia_Bemba/20/g' |
#   sed 's/Zambia_Lozi/18/g' |
#   sed 's/Zambia_TongaZam/17/g' |
#   sed 's/Sudan_Dinka/3/g'|
#   sed 's/Tanzania_Hadza/0/g'|
#   sed 's/Ethiopia_Sabue/1/g' |
#   sed 's/baa001/9/g' |
#   sed 's/bab001/10/g' |
#   sed 's/cha001/11/g' |
#   sed 's/ela001/12/g' |
#   sed 's/I9028/13/g' |
#   sed 's/I9133/14/g' |
#   sed 's/I9134/15/g' |
#   sed 's/Kenya_500BP/16/g' |
#   sed 's/Kenya_IA_Deloraine/17/g' |
#   sed 's/Kenya_LSA/18/g' |
#   sed 's/Kenya_Pastoral_IA/9/g' |
#   sed 's/Kenya_Pastoral_Neolithic_Elmenteitan/11/g' |
#   sed 's/Kenya_Pastoral_Neolithic/10/g' |
#   sed 's/Malawi_Fingira_2500BP/12/g' |
#   sed 's/Malawi_Fingira_6000BP/13/g' |
#   sed 's/Malawi_Hora_Holocene/14/g' |
#   sed 's/mfo001/15/g' |
#   sed 's/Mota/16/g' |
#   sed 's/new001/17/g' |
#   sed 's/Shum_Laka/18/g' |
#   sed 's/Tanzania_Luxmanda_3000BP/9/g' |
#   sed 's/Tanzania_Pemba_1400BP/10/g' |
#   sed 's/Tanzania_Pemba_700BP/11/g' |
#   sed 's/Tanzania_PN/12/g' |
#   sed 's/Tanzania_Zanzibar_1400BP/13/g'  >  omni1finalmerge_ancient4fexhap_2_Africaonly.pedind.pch" )

infocol <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly.pedind.col")
infopch <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly.pedind.pch")
#infoleg <- read.table(file="omni1finalmerge_ancient4fexhap.legend",header=TRUE)
infoleg <- read.table(file="omni1finalmerge_ancient4fexhap_Africaonly.legend",header=TRUE)

# nrpc<-10
# nreval <- nrow(eval)
# totalev <- sum(eval)
# aa <- array(NA,dim=c(nrpc,1))
# for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC
# 
# newnames=c("Amhara","Oromo","Somali","Khutse San","Ju|'hoansi","Karretjie people","#Khomani","Khwe","Nama","!Xun","Luhya","SEBantu","Herero","Yoruba","Sotho","Zulu","Igbo","Mandinka","Batwa","Baka_C","Baka_G","Bongo_E","Bongo_S","Nzime","Nzebi","Ba.Kiga","Maasai","Sara","Toubou","CEU","Han","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga","Dinka","Hadza","Sabue",
#            "SA LSA (BBA)","SA LSA (BBB)","SA IA (CC)","SA IA (EC)","SA LSA (I9028)","SA LSA (I9133)","SA LSA (I9134)","Kenya (500 BP, EAHG)","Kenya IA (Deloraine, Wafr)","Kenya LSA (EAHG)","Kenya IA (pastoralist)","Kenya PN EA","Kenya PN","Malawi Fingira (2500 BP)","Malawi Fingira (6000 BP)","Malawi Hora (Holocene)","SA IA (M)","Ethiopia Mota (EAHG)","SA IA (N)","Cameroon (Shum Laka)","Tanzania Luxmanda","Tanzania Pemba","Tanzania Pemba","Tanzania PN","Tanzania Zanzibar")
# pdf(file="omni1finalmerge_ancient4fexhap_Batwaontop_20210113.pdf", width=10, height=15, pointsize=12)
# par(mfrow=c(3,2),oma=c(0,0,0,0))
# #PC1 PC2
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# #Not sure whether this looks like expected or not. TODO look up MV's plot. TODO legend. The % explained by the PCs are different. Is that normal?
# #How much do we expect from a PCA in such case? Will an ADMIXTURE or a f4 ratio analysis be more interesting?
# #Should the ancient samples be on top as well?
# #PC1 PC3
# plot(evec[,2],evec[,4],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC3: ",aa[3,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC4
# plot(evec[,2],evec[,5],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC4: ",aa[4,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC5
# plot(evec[,2],evec[,6],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC5: ",aa[5,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# #PC1 PC6
# plot(evec[,2],evec[,7],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC6: ",aa[6,1],"%",sep=""),asp=1)
# abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
# barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
# #legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
# legend("center",legend=newnames,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=3,cex=0.8)
# dev.off()
# 
# #Plot only PC1 and PC2 FIGURE 1B
# pdf(file="omni1finalmerge_ancient4fexhap_Batwaontop_PC1-PC2_20210113.pdf", width=7, height=7, pointsize=10)
# plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
# abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
# #barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
# #legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=5)
# #legend("bottomleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=5)
# dev.off()
# 

# #Omni1 African only (i.e. CEU and CHB excluded) 20210119
# eval <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_killr20.2_popsize36_Africaonly.eval")
# evec <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_killr20.2_popsize36_Africaonly_Batwaontop.evec",skip=1)
# 
# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_Batwaontop.pedind |
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' |
#   sed 's/Zambia_Bemba/cyan2/g' |
#   sed 's/Zambia_Lozi/cyan2/g' |
#   sed 's/Zambia_TongaZam/cyan2/g' |
#   sed 's/Sudan_Dinka/chocolate/g'|
#   sed 's/Tanzania_Hadza/indianred1/g'|
#   sed 's/Ethiopia_Sabue/indianred1/g' >  zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_Batwaontop.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_Batwaontop.pedind |
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' |
#   sed 's/Zambia_Bemba/20/g' |
#   sed 's/Zambia_Lozi/18/g' |
#   sed 's/Zambia_TongaZam/17/g' |
#   sed 's/Sudan_Dinka/3/g'|
#   sed 's/Tanzania_Hadza/0/g'|
#   sed 's/Ethiopia_Sabue/1/g'  >  zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_Batwaontop.pedind.pch" )
# 
# infocol <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_Batwaontop.pedind.col")
# infopch <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_Batwaontop.pedind.pch")
# infoleg <- read.table(file="omni1_Africanonly.legend",header=TRUE)

nrpc<-10
nreval <- nrow(eval)
totalev <- sum(eval)
aa <- array(NA,dim=c(nrpc,1))
for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC

newnames=c("Amhara","Oromo","Somali","Khutse San","Ju|'hoansi","Karretjie people","#Khomani","Khwe","Nama","!Xun","Luhya","SEBantu","Herero","Yoruba","Sotho","Zulu","Igbo","Mandinka","Batwa","Baka_C","Baka_G","Bongo_E","Bongo_S","Nzime","Nzebi","Ba.Kiga","Maasai","Sara","Toubou","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga","Dinka","Hadza","Sabue")
pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Africaonly_Batwaontop_PC1to6_20210119.pdf", width=10, height=15, pointsize=12)
par(mfrow=c(3,2),oma=c(0,0,0,0))
#PC1 PC2
plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#PC1 PC3
plot(evec[,2],evec[,4],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC3: ",aa[3,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC4
plot(evec[,2],evec[,5],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC4: ",aa[4,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC5
plot(evec[,2],evec[,6],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC5: ",aa[5,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC6
plot(evec[,2],evec[,7],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC6: ",aa[6,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
#legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
legend("topright",legend=newnames,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
dev.off()

#Try to plot like in Vicente 2020 review (axes are somewhat rotated).
pdf(file="omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_20210125_PC1to4_inverted_20210119.pdf", width=10, height=10, pointsize=12)
par(mfrow=c(2,2),oma=c(0,0,0,0))
#PC1 PC2
plot(evec[,3],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC2: ",aa[2,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#PC1 PC3
plot(-evec[,4],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC3: ",aa[3,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC4
plot(-evec[,5],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC4: ",aa[4,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#legend
barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
legend("topright",legend=newnames,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
dev.off()
#It looks somewhat like MV's, but his are better split out.

### Omni1 African only + ancient (20210119)
pedind <- read.table(file = "omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop.pedind")
#eval <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected.eval")
eval <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_popsize36_ancientprojected.eval")
#evec <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_Batwaontop.evec",skip=1)
evec <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_popsize36_ancientprojected_Batwaontop.evec",skip=1)

# #prepare vector of colours
# system(
#   "cut -d\" \" -f1 omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop.pedind |
#   sed 's/Amhara/darkgoldenrod2/g' |
#   sed 's/Oromo/darkgoldenrod2/g' |
#   sed 's/Somali/darkgoldenrod2/g' |
#   sed 's/ColouredAskham/red/g' |
#   sed 's/GuiGhanaKgal/red/g' |
#   sed 's/Juhoansi/red/g' |
#   sed 's/Karretjie/red/g' |
#   sed 's/Khomani/red/g' |
#   sed 's/Khwe/red/g' |
#   sed 's/Nama/red/g' |
#   sed 's/schus/red/g' |
#   sed 's/Xun/red/g' |
#   sed 's/LWK/cornflowerblue/g' |
#   sed 's/SEBantu/cornflowerblue/g' |
#   sed 's/SWBantu/cornflowerblue/g' |
#   sed 's/YRI/cornflowerblue/g' |
#   sed 's/Sotho/cornflowerblue/g' |
#   sed 's/Zulu/cornflowerblue/g' |
#   sed 's/Igbo/cornflowerblue/g' |
#   sed 's/Mandinka/cornflowerblue/g' |
#   sed 's/Batwa/chartreuse4/g' |
#   sed 's/Baka_Cam/chartreuse4/g' |
#   sed 's/Baka_Gab/chartreuse4/g' |
#   sed 's/Bongo_GabE/chartreuse4/g' |
#   sed 's/Bongo_GabS/chartreuse4/g' |
#   sed 's/Nzime_Cam/blue/g' |
#   sed 's/Nzebi_Gab/blue/g' |
#   sed 's/Bakiga/blue/g' |
#   sed 's/MKK/chocolate/g' |
#   sed 's/Chad_Sara/chocolate/g' |
#   sed 's/Chad_Toubou/chocolate/g' |
#   sed 's/CEU/black/g' |
#   sed 's/CHB/black/g' |
#   sed 's/Bangweulu/darkorchid/g' |
#   sed 's/Kafue/darkorchid/g' |
#   sed 's/Zambia_Bemba/cyan2/g' |
#   sed 's/Zambia_Lozi/cyan2/g' |
#   sed 's/Zambia_TongaZam/cyan2/g' |
#   sed 's/Sudan_Dinka/chocolate/g'|
#   sed 's/Tanzania_Hadza/indianred1/g'|
#   sed 's/Ethiopia_Sabue/indianred1/g' |
#   sed 's/baa001/gray30/g' |
#   sed 's/bab001/gray60/g' |
#   sed 's/cha001/gray90/g' |
#   sed 's/ela001/gray30/g' |
#   sed 's/I9028/gray60/g' |
#   sed 's/I9133/gray90/g' |
#   sed 's/I9134/gray30/g' |
#   sed 's/Kenya_500BP/gray60/g' |
#   sed 's/Kenya_IA_Deloraine/gray90/g' |
#   sed 's/Kenya_LSA/gray30/g' |
#   sed 's/Kenya_Pastoral_IA/gray60/g' |
#   sed 's/Kenya_Pastoral_Neolithic_Elmenteitan/gray30/g' |
#   sed 's/Kenya_Pastoral_Neolithic/gray90/g' |
#   sed 's/Malawi_Fingira_2500BP/gray60/g' |
#   sed 's/Malawi_Fingira_6000BP/gray90/g' |
#   sed 's/Malawi_Hora_Holocene/gray30/g' |
#   sed 's/mfo001/gray60/g' |
#   sed 's/Mota/gray90/g' |
#   sed 's/new001/gray30/g' |
#   sed 's/Shum_Laka/gray60/g' |
#   sed 's/Tanzania_Luxmanda_3000BP/gray90/g' |
#   sed 's/Tanzania_Pemba_1400BP/gray30/g' |
#   sed 's/Tanzania_Pemba_700BP/gray60/g' |
#   sed 's/Tanzania_PN/gray90/g' |
#   sed 's/Tanzania_Zanzibar_1400BP/gray30/g' >  omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop.pedind.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop.pedind |
#   sed 's/Amhara/0/g' |
#   sed 's/Oromo/1/g' |
#   sed 's/Somali/2/g' |
#   sed 's/ColouredAskham/0/g' |
#   sed 's/GuiGhanaKgal/1/g' |
#   sed 's/Juhoansi/2/g' |
#   sed 's/Karretjie/3/g' |
#   sed 's/Khomani/4/g' |
#   sed 's/Khwe/5/g' |
#   sed 's/Nama/6/g' |
#   sed 's/schus/7/g' |
#   sed 's/Xun/8/g' |
#   sed 's/LWK/0/g' |
#   sed 's/SEBantu/1/g' |
#   sed 's/SWBantu/2/g' |
#   sed 's/YRI/3/g' |
#   sed 's/Sotho/4/g' |
#   sed 's/Zulu/5/g' |
#   sed 's/Igbo/6/g' |
#   sed 's/Mandinka/7/g' |
#   sed 's/Batwa/0/g' |
#   sed 's/Baka_Cam/1/g' |
#   sed 's/Baka_Gab/2/g' |
#   sed 's/Bongo_GabE/3/g' |
#   sed 's/Bongo_GabS/4/g' |
#   sed 's/Nzime_Cam/0/g' |
#   sed 's/Nzebi_Gab/1/g' |
#   sed 's/Bakiga/2/g' |
#   sed 's/MKK/0/g' |
#   sed 's/Chad_Sara/1/g' |
#   sed 's/Chad_Toubou/2/g' |
#   sed 's/CEU/0/g' |
#   sed 's/CHB/1/g' |
#   sed 's/Bangweulu/20/g' |
#   sed 's/Kafue/18/g' |
#   sed 's/Zambia_Bemba/20/g' |
#   sed 's/Zambia_Lozi/18/g' |
#   sed 's/Zambia_TongaZam/17/g' |
#   sed 's/Sudan_Dinka/3/g'|
#   sed 's/Tanzania_Hadza/0/g'|
#   sed 's/Ethiopia_Sabue/1/g' |
#   sed 's/baa001/9/g' |
#   sed 's/bab001/10/g' |
#   sed 's/cha001/11/g' |
#   sed 's/ela001/12/g' |
#   sed 's/I9028/13/g' |
#   sed 's/I9133/14/g' |
#   sed 's/I9134/15/g' |
#   sed 's/Kenya_500BP/16/g' |
#   sed 's/Kenya_IA_Deloraine/17/g' |
#   sed 's/Kenya_LSA/18/g' |
#   sed 's/Kenya_Pastoral_IA/9/g' |
#   sed 's/Kenya_Pastoral_Neolithic_Elmenteitan/11/g' |
#   sed 's/Kenya_Pastoral_Neolithic/10/g' |
#   sed 's/Malawi_Fingira_2500BP/12/g' |
#   sed 's/Malawi_Fingira_6000BP/13/g' |
#   sed 's/Malawi_Hora_Holocene/14/g' |
#   sed 's/mfo001/15/g' |
#   sed 's/Mota/16/g' |
#   sed 's/new001/17/g' |
#   sed 's/Shum_Laka/18/g' |
#   sed 's/Tanzania_Luxmanda_3000BP/9/g' |
#   sed 's/Tanzania_Pemba_1400BP/10/g' |
#   sed 's/Tanzania_Pemba_700BP/11/g' |
#   sed 's/Tanzania_PN/12/g' |
#   sed 's/Tanzania_Zanzibar_1400BP/13/g'  >  omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop.pedind.pch" )

infocol <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop.pedind.col")
infopch <- read.table(file="omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop.pedind.pch")
infoleg <- read.table(file="omni1finalmerge_ancient4fexhap_Africaonly.legend",header=TRUE)

nrpc<-10
nreval <- nrow(eval)
totalev <- sum(eval)
aa <- array(NA,dim=c(nrpc,1))
for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC

newnames=c("Amhara","Oromo","Somali","Khutse San","Ju|'hoansi","Karretjie people",
           "#Khomani","Khwe","Nama","!Xun","Luhya","SEBantu","Herero","Yoruba","Sotho",
           "Zulu","Igbo","Mandinka","Batwa","Baka_C","Baka_G","Bongo_E","Bongo_S","Nzime",
           "Nzebi","Ba.Kiga","Maasai","Sara","Toubou","BaTwa Bangweulu",
           "BaTwa Kafue","Bemba","Lozi","Tonga","Dinka","Hadza","Sabue",
           "SA LSA (BBA)","SA LSA (BBB)","SA IA (CC)","SA IA (EC)","SA LSA (I9028)","SA LSA (I9133)",
           "SA LSA (I9134)","Kenya (500 BP, EAHG)","Kenya IA (Deloraine, Wafr)","Kenya LSA (EAHG)",
           "Kenya IA (pastoralist)","Kenya PN EA","Kenya PN","Malawi Fingira (2500 BP)",
           "Malawi Fingira (6000 BP)","Malawi Hora (Holocene)","SA IA (M)","Ethiopia Mota (EAHG)",
           "SA IA (N)","Cameroon (Shum Laka)","Tanzania Luxmanda","Tanzania Pemba","Tanzania Pemba",
           "Tanzania PN","Tanzania Zanzibar")
#TODO double check whether it changes something that one Tanzania NP was removed (was it the only one in that group?)
#pdf(file="omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop_20210119.pdf", width=10, height=15, pointsize=12)
pdf(file="omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_20210125.pdf", width=10, height=15, pointsize=12)
par(mfrow=c(3,2),oma=c(0,0,0,0))
#PC1 PC2
plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#PC1 PC3
plot(evec[,2],evec[,4],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC3: ",aa[3,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC4
plot(evec[,2],evec[,5],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC4: ",aa[4,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC5
plot(evec[,2],evec[,6],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC5: ",aa[5,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC6
plot(evec[,2],evec[,7],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC6: ",aa[6,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
#legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=2)
legend("center",legend=newnames,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=3,cex=0.8)
dev.off()

#Figure similar to Vicente 2020 review (axes are somewhat rotated).
#pdf(file="omni1finalmerge_ancient4fexhap_2_Africaonly_Batwaontop_PC1to4_inverted_20210119.pdf", width=10, height=10, pointsize=12)
pdf(file="omni1finalmerge_ancient4fexhap_2_Africaonly_killr20.2_popsize36_ancientprojected_PC1to4_inverted_20210125.pdf", width=10, height=10, pointsize=12)
par(mfrow=c(2,2),oma=c(0,0,0,0))
#PC1 PC2
plot(evec[,3],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC2: ",aa[2,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
#PC1 PC3
plot(-evec[,4],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC3: ",aa[3,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#PC1 PC4
plot(-evec[,5],evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC4: ",aa[4,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0, col="lightgray", lty=5, lwd=0.8); abline(v=0, col="lightgray", lty=5, lwd=0.8)
#legend
barplot (eval[,1], xlab = "PC", ylab = "Loadings", axes=TRUE)
legend("topright",legend=newnames,col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=3,cex=0.65)
dev.off()

#Comparison with/out LD filtering: very similar. But my plots are still quite far from MV's, in particular the ancient samples cluster in the middle...


###
#20210310
#Omni1, Nzime-Baka-Cam-Juhoansi, Bangweulu-Kafue-Bemba-Lozi-Tonga projected.
eval <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36_B_K_ZambiaBantusp_projected.eval")
evec <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp_killr20.2_popsize36_B_K_ZambiaBantusp_projected.evec",skip=1)

#prepare vector of colours
system(
  "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind |
  sed 's/Juhoansi/red/g' |
  sed 's/Nzime_Cam/cornflowerblue/g' |
  sed 's/Baka_Cam/chartreuse4/g' |
  sed 's/Bangweulu/darkorchid/g' |
  sed 's/Kafue/darkorchid/g' |
  sed 's/Zambia_Bemba/cyan2/g' |
  sed 's/Zambia_Lozi/cyan2/g' |
  sed 's/Zambia_TongaZam/cyan2/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind |
  sed 's/Juhoansi/2/g' |
  sed 's/Nzime_Cam/3/g' |
  sed 's/Baka_Cam/1/g' |
  sed 's/Bangweulu/20/g' |
  sed 's/Kafue/18/g' |
  sed 's/Zambia_Bemba/20/g' |
  sed 's/Zambia_Lozi/18/g' |
  sed 's/Zambia_TongaZam/17/g' > zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.pch" )

infocol <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.col")
infopch <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pedind.pch")
infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.legend",header=TRUE)

nrpc<-10
nreval <- nrow(eval)
totalev <- sum(eval)
aa <- array(NA,dim=c(nrpc,1))
for (i in 1:nrpc) {aa[i,1] <- format(round(((eval[i,1]/totalev)*100),3),nsamll=3)} #aa contains the % of variance explained by each PC

#PC1-PC2 only FIGURE 1C
pdf(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_Nzime_Baka-Cam_Juhoansi_B_Z_ZambiaBantusp.pdf", width=8, height=9, pointsize=16)
plot(evec[,2],evec[,3],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC1: ",aa[1,1],"%",sep=""), ylab=paste("PC2: ",aa[2,1],"%",sep=""),asp=1)
#plot(evec[,3],-evec[,2],col=as.vector(infocol$V1),pch=infopch$V1,xlab=paste("PC2: ",aa[2,1],"%",sep=""), ylab=paste("PC1: ",aa[1,1],"%",sep=""),asp=1)
abline(h=0,col="lightgray",lty=5,lwd=0.8); abline(v=0,col="lightgray",lty=5,lwd=0.8)
legend("topright",legend=c("Ju|'hoansi (Namibia)","Nzime (Cameroon)","Baka (Cameroon)","BaTwa Bangweulu","BaTwa Kafue","Bemba","Lozi","Tonga"),col=as.vector(infoleg$Colour),pch=infoleg$pch,ncol=1)
#title("Zambian BaTwa and Bantu-speaker individuals projected onto PCA of Juhoansi, Baka and Yoruba")
dev.off()







