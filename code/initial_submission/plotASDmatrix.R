#Gwenna Breton
#this file was modified after (and including) 20181019. Some paths may have become obsolete.
#Edit 20200331: File edited to work for outputs from spring 2020.

setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/VT2020/MDS_ASD/")

# #Zambian samples only
# data <- read.table(file="zbatwa9_fex.asd.dist",header=TRUE)
# 
# #first in 2D
# data.mds<-cmdscale(data)
# plot(data.mds,pch=20,asp=1,xlab=c(""),ylab=c(""),cex=1)
# plot(data.mds,col=as.vector(as.character(colhex_legend$V1)),pch=symbol_legend$V1,asp=1,xlab=c(""),ylab=c(""),cex=1)
# title("MDS plot based on the inter-ind allele sharing dissimilarity matrix")
# 
# data.3d<-cmdscale(data,k=3)
# library(rgl)
# 
# open3d()
# plot3d(data.3d,col=c(rep("black",36),rep("red",33)),xlab="Axis 1", ylab="Axis 2", zlab="Axis3",size=5,pch=20) #caution! if the number of samples in each population or the order of the sample changes, change the colour vector!
# legend3d("bottomright",legend=c("Bangweulu","Kafue"),pch=20,col=c("black","red"))
# rgl.postscript("3D_MDS_legend.eps",fmt="eps")
# rgl.postscript("3D_MDS_legend.svg",fmt="svg")
# dev.off()

#MDS Omni2.5 dataset
data <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.asd.dist",header=TRUE)

#prepare vector of colours
system(
  "cut -d\" \" -f1  zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.fam | 
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
  sed 's/Zambia_TongaZam/cyan2/g' > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.fam | 
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
  sed 's/Zambia_TongaZam/17/g' >  zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.pch" )
  
infocol <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.col")
infopch <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.pch")
infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex.legend",header=TRUE)

data.mds<-cmdscale(data,3)
png(file="zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_MDSofASD_dim1-2.png",width=1000,height=1000,pointsize=14)
plot(data.mds[,1:2],pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("bottomleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8)
title("MDS plot of ASD matrix - zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71 , ~1.2 million variants")
dev.off()
png(file="zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_3fex_MDSofASD_dim1-3.png",width=1000,height=1000,pointsize=14)
plot(data.mds[,c(1,3)],pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8)
title("MDS plot of ASD matrix - zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71 , ~1.2 million variants")
dev.off()
#it looks like the two Zambian populations are drawn towards the Khwe - and all of these are close to Niger-Congo populations - but difficult to see much!

data.3d<-cmdscale(data,k=3)
library(rgl)
open3d()
plot3d(data.3d,col=as.character(infocol$V1),xlab="Axis 1", ylab="Axis 2", zlab="Axis3",size=5,pch=infopch$V1)
#does not look great because only one type of point

#MDS Omni1 dataset

data <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.asd.dist",header=TRUE)

#prepare vector of colours
system(
  "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam |
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
  sed 's/Kafue/darkorchid/g'|
  sed 's/Zambia_Bemba/cyan2/g' |
  sed 's/Zambia_Lozi/cyan2/g' |
  sed 's/Zambia_TongaZam/cyan2/g' |
  sed 's/Sudan_Dinka/chocolate/g'|
  sed 's/Tanzania_Hadza/indianred1/g'|
  sed 's/Ethiopia_Sabue/indianred1/g' > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam |
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
  sed 's/Ethiopia_Sabue/1/g' >  zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.pch" )

infocol <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.col")
infopch <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.pch")
infoleg <- read.table(file="zbatwa9_zbantu9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.legend",header=TRUE)

data.mds<-cmdscale(data,3)
png(file="zbatwa9_zbantu9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_Scheinfeldt52_MDSofASD_dim1-2.png",width=1000,height=1000,pointsize = 14)
plot(data.mds[,1:2],pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("topleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8,ncol=2)
title("MDS plot of ASD matrix - zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207, ~0.34 M variants")
dev.off()
png(file="zbatwa9_zbantu9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_Scheinfeldt52_MDSofASD_dim1-3.png",width=1000,height=1000,pointsize = 14)
plot(data.mds[,c(1,3)],pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8,ncol=2)
title("MDS plot of ASD matrix - zbatwa9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207, ~0.34 M variants")
dev.off()

#the RHG samples are drawn towards the Khwe. The Zambian samples are drawn towards the Khwe and the Bantu-speakers samples (particularly Sotho, SEBantu, Zulu). The East African HG (Hadza, Sabue) fall in between the axis driven by the KS (on which the RHG fall) and the axis driven by the non-African (on which the Nilo-Saharan -including the Dinka- and the Afro-Asiatic fall).
#The third dimension is between CEU and CHB.
 
# data.3d<-cmdscale(data,k=3)
# library(rgl)
# open3d()
# plot3d(data.3d,col=as.character(infocol$V1),xlab="Axis 1", ylab="Axis 2", zlab="Axis3",size=5,pch=infopch$V1) #does not look great because only one type of point
# #Same pattern as with 2D plot
 
###
### Without CHB
###

#Omni2.5
data <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.asd.dist",header=TRUE)

#prepare vector of colours
system(
  "cut -d\" \" -f1  zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.fam | 
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
  sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.fam | 
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
  sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pch" )

infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.col")
infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.pch")
infoleg <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex.legend",header=TRUE)

data.mds<-cmdscale(data)
png(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex_MDSofASD.png",width=1000,height=1000,pointsize = 14)
plot(data.mds,pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("bottomleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8)
title("MDS plot of ASD matrix - zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71 , ~1.2 million variants")
dev.off()
#dimensions of the plot: ~1090 1250

###Omni1

data <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.asd.dist",header=TRUE)

#prepare vector of colours
system(
  "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.fam |
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
  sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.fam |
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
  sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pch" )

infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.col")
infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.pch")
infoleg <- read.table(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex.legend",header=TRUE)

data.mds<-cmdscale(data)
png(file="zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_Patin207_2fex_MDSofASD.png",width=1000,height=1000,pointsize = 14)
plot(data.mds,pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("topleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8,ncol=2)
title("MDS plot of ASD matrix - zbatwa9_Schlebusch2012_1KGP137_Gurdasani242_Haber71_2fex, ~0.46 M variants")
dev.off()
#the RHG samples are drawn towards the Khwe. The Zambian samples are drawn towards the Khwe and the Bantu-speakers samples (particularly Sotho, SEBantu, Zulu).

###
### Without CHB + CEU
###

#Omni2.5
#prepare vector of colours
system(
  "cut -d\" \" -f1  zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.fam | 
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
  sed 's/Bangweulu/darkorchid/g' |
  sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.col" )

#Prepare vector of pch
system(
  "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.fam | 
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
  sed 's/Bangweulu/20/g' |
  sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pch" )

data <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.asd.dist",header=TRUE)
infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.col")
infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.pch")
infoleg <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.legend",header=TRUE)

data.mds<-cmdscale(data)
png(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex_MDSofASD.png",width=1000,height=1000,pointsize = 14)
plot(data.mds,pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("bottomleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8,ncol=2)
title("MDS plot of ASD matrix - zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71 , ~1.2 million variants")
dev.off()
#dimensions of the plot: ~1090 1250

#vector of 3D colours
system(
  "cut -d\" \" -f1  zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.fam | 
  sed 's/Amhara/darkgoldenrod/g' |
  sed 's/Oromo/darkgoldenrod1/g' |
  sed 's/Somali/darkgoldenrod4/g' |
  sed 's/ColouredAskham/indianred/g' |
  sed 's/GuiGhanaKgal/indianred1/g' |
  sed 's/Khwe/indianred4/g' |
  sed 's/Juhoansi/red/g' |
  sed 's/schus/red/g' |
  sed 's/Xun/red3/g' |
  sed 's/Karretjie/salmon/g' |
  sed 's/Khomani/salmon1/g' |
  sed 's/Nama/salmon3/g' |
  sed 's/LWK/cornflowerblue/g' |
  sed 's/SEBantu/deepskyblue/g' |
  sed 's/SWBantu/deepskyblue3/g' |
  sed 's/Sotho/deepskyblue4/g' |
  sed 's/Zulu/cyan4/g' |
  sed 's/Nzime_Cam/dodgerblue/g' |
  sed 's/Nzebi_Gab/dodgerblue2/g' |
  sed 's/Bakiga/dodgerblue4/g' |
  sed 's/YRI/darkslategray2/g' |
  sed 's/Igbo/darkslategray3/g' |
  sed 's/Mandinka/darkslategray4/g' |
  sed 's/Batwa/chartreuse4/g' |
  sed 's/Baka_Cam/darkseagreen1/g' |
  sed 's/Baka_Gab/darkseagreen2/g' |
  sed 's/Bongo_GabE/darkseagreen3/g' |
  sed 's/Bongo_GabS/darkseagreen4/g' |
  sed 's/MKK/chocolate1/g' |
  sed 's/Chad_Sara/chocolate3/g' |
  sed 's/Chad_Toubou/chocolate4/g' |
  sed 's/CEU/black/g' |
  sed 's/CHB/gray50/g' |
  sed 's/Bangweulu/darkorchid1/g' |
  sed 's/Kafue/darkorchid4/g' > zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.col3D" )

data <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.asd.dist",header=TRUE)
col3d <- read.table(file = "zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_2fex.col3D")
data.3d<-cmdscale(data,k=3)
library(rgl)
open3d()
plot3d(data.3d,col=as.character(col3d$V1),xlab="Axis 1", ylab="Axis 2", zlab="Axis3",size=5) #does not look great because only one type of point
#extremes of axis 3: Chad_Toubou versus Sotho / SEBantu. The Kafue are on a line towards the KS while the Bangweulu are more intermediate between the southern Bantu-speakers and the rest (e.g. LWK, Igbo etc)
#easier to see with the plot!

###Omni1
#prepare vector of colours
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.fam |
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
#   sed 's/Kafue/darkorchid/g' > zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.col" )
# 
# #Prepare vector of pch
# system(
#   "cut -d\" \" -f1 zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.fam |
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
#   sed 's/Kafue/18/g' >  zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pch" )

data <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.asd.dist",header=TRUE)
infocol <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.col")
infopch <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.pch")
infoleg <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.legend",header=TRUE)

data.mds<-cmdscale(data)
png(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex_MDSofASD.png",width=1000,height=1000,pointsize = 14)
plot(data.mds,pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
legend("bottomleft",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8,ncol=2)
title("MDS plot of ASD matrix - zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex, ~0.46 M variants")
dev.off()

#vector of 3D colours
system(
  "cut -d\" \" -f1  zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.fam | 
  sed 's/Amhara/darkgoldenrod/g' |
  sed 's/Oromo/darkgoldenrod1/g' |
  sed 's/Somali/darkgoldenrod4/g' |
  sed 's/ColouredAskham/indianred/g' |
  sed 's/GuiGhanaKgal/indianred1/g' |
  sed 's/Khwe/indianred4/g' |
  sed 's/Juhoansi/red/g' |
  sed 's/schus/red/g' |
  sed 's/Xun/red3/g' |
  sed 's/Karretjie/salmon/g' |
  sed 's/Khomani/salmon1/g' |
  sed 's/Nama/salmon3/g' |
  sed 's/LWK/cornflowerblue/g' |
  sed 's/SEBantu/deepskyblue/g' |
  sed 's/SWBantu/deepskyblue3/g' |
  sed 's/Sotho/deepskyblue4/g' |
  sed 's/Zulu/cyan4/g' |
  sed 's/Nzime_Cam/dodgerblue/g' |
  sed 's/Nzebi_Gab/dodgerblue2/g' |
  sed 's/Bakiga/dodgerblue4/g' |
  sed 's/YRI/darkslategray2/g' |
  sed 's/Igbo/darkslategray3/g' |
  sed 's/Mandinka/darkslategray4/g' |
  sed 's/Batwa/chartreuse4/g' |
  sed 's/Baka_Cam/darkseagreen1/g' |
  sed 's/Baka_Gab/darkseagreen2/g' |
  sed 's/Bongo_GabE/darkseagreen3/g' |
  sed 's/Bongo_GabS/darkseagreen4/g' |
  sed 's/MKK/chocolate1/g' |
  sed 's/Chad_Sara/chocolate3/g' |
  sed 's/Chad_Toubou/chocolate4/g' |
  sed 's/CEU/black/g' |
  sed 's/CHB/gray50/g' |
  sed 's/Bangweulu/darkorchid1/g' |
  sed 's/Kafue/darkorchid4/g' > zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.col3D" )

data <- read.table(file="zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.asd.dist",header=TRUE)
col3d <- read.table(file = "zbatwa9_Schlebusch2012_1KGP101_Gurdasani242_Haber71_Patin207_2fex.col3D")
data.3d<-cmdscale(data,k=3)
library(rgl)
open3d()
plot3d(data.3d,col=as.character(col3d$V1),xlab="Axis 1", ylab="Axis 2", zlab="Axis3",size=5) 
#Extreme of third axis: Baka_Cam versus Sotho (??)
#On that one the Bangweulu and the Kafue are more or less on one line (so maybe the pattern observed in the Omni2.5 dataset is due to RHG admixture). No Bantu-speaker group is super close to them.






# ###Same as above but after MAF 0.05 pruning
# ###Plot Patin221_Haber72_Gurdasani242_KSP_KGP180_zbatwa9_5_fex.asd.dist ###
# data <- read.table(file="Patin221_Haber72_Gurdasani242_KSP_KGP180_zbatwa9_5_fex.asd.dist",header=TRUE)
# infocol <- read.table(file="Patin221_Haber72_Gurdasani242_KSP_KGP180_zbatwa9_4_fex.col")
# infopch <- read.table(file="Patin221_Haber72_Gurdasani242_KSP_KGP180_zbatwa9_4_fex.pch")
# infoleg <- read.table(file="Patin221_Haber72_Gurdasani242_KSP_KGP180_zbatwa9_4_fex.legend",header=TRUE)
# 
# data.mds<-cmdscale(data)
# plot(data.mds,pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8,ncol=2)
# title("MDS plot of ASD matrix - Patin221_Haber72_Gurdasani242_KSP_KGP180_zbatwa MAF 0.05, ~0.47 million variants",cex=0.7)
# #extremly similar to the plot without MAF pruning
# 
# ###Plot Haber72_Gurdasani242_KSP_KGP180_zbatwa9_3_fex.asd.dist ###
# data <- read.table(file="Haber72_Gurdasani242_KSP_KGP180_zbatwa9_4_fex.asd.dist",header=TRUE)
# infocol <- read.table(file="Haber72_Gurdasani242_KSP_KGP180_zbatwa9_3_fex.col")
# infopch <- read.table(file="Haber72_Gurdasani242_KSP_KGP180_zbatwa9_3_fex.pch")
# infoleg <- read.table(file="Haber72_Gurdasani242_KSP_KGP180_zbatwa9_3_fex.legend",header=TRUE)
# 
# data.mds<-cmdscale(data)
# plot(data.mds,pch=infopch$V1,asp=1,xlab=c(""),ylab=c(""),cex=1,col=as.vector(infocol$V1))
# legend("topright",legend=infoleg$Population,col=as.vector(infoleg$Colour),pch=infoleg$pch,cex=0.8)
# title("MDS plot of ASD matrix - Haber72_Gurdasani242_KSP_KGP180_zbatwa MAF0.05, ~1 million variants")
# #also look extremly similar...