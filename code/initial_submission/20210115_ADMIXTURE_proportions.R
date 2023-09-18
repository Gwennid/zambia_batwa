### Gwenna Breton
### 20210115
### Goal: prepare summary tables of the ancestry proportions based on the admixture runs (as previously). Test new ways of representing the results.
#Based on 20200424_ADMIXTURE_proportions.R
#Edit 20210219: I added a part about the RHG versus West African proportion, like I did for the merge Omni1 + ancient. This explains the alternate paths and input files.

#setwd("/home/ecodair/Bureau/Work_from_home/P3/results/December2020/ADMIXTURE/")
#setwd("/home/gwennabreton/Desktop/from20210203/P3/results/ADMIXTURE/")
setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/December2020/ADMIXTURE/")

#Omni1
#pong_output_2020-12-14_17h25m52s
#I chose K=6.
#Representative run: run 18
coeff <- read.table(file="pong_output_2020-12-14_17h25m52s/runs/k6r18_reprun.Q")
pop <- read.table(file="ind2pop_202012_mergeOmni1_newnames.txt")

#Comment: I would like to have individuals names, but I do not have good names for all of them... Working with populations at the moment.
coeff2 <- data.frame(cbind(pop$V1,coeff))
names(coeff2) <- c("pop","component1","component2","component3","component4","component5","component6")
# 
# #component1: CEU_US        
# #component2: eHG (e.g. Sabue_Ethiopia)      
# #component3: KS (e.g. Juhoansi_Namibia)
# #component4: RHG (e.g. Baka_Cameroon)         
# #component5: Han_China
# #component6: Niger-Congo (e.g. Yoruba_Nigeria)
# 
# POP <- unique(pop)

# write.table(file="pong_output_2020-12-14_17h25m52s/summary_K6_r18_mean_min_max_WAfrlike_nonAfrlike_HGlike",
#             t(c("POP","WAfr_mean","WAfr_min","WAfr_max","nonAfr_mean","nonAfr_min","nonAfr_max","HG_mean","HG_min","HG_max")),
#             col.names = FALSE,row.names=FALSE,quote=FALSE)
# write.table(file="pong_output_2020-12-14_17h25m52s/summary_K6_r18_mean_min_max_prop_different_HG",
#             t(c("POP","KSoverallHG_mean","KSoverallHG_min","KSoverallHG_max","RHGoverallHG_mean","RHGoverallHG_min","RHGoverallHG_max","eHGoverallHG_mean","eHGoverallHG_min","eHGoverallHG_max")),
#             col.names = FALSE,row.names=FALSE,quote=FALSE)
# 
# #
# for (i in c(1:length(POP[,1]))) {
#   # Proportion of WAfr-like ancestry.
#   pWf <- mean(coeff2[coeff2$pop==POP[i,1],7])
#   minWf <- min(coeff2[coeff2$pop==POP[i,1],7])
#   maxWf <- max(coeff2[coeff2$pop==POP[i,1],7])
# 
#   # Proportion of non-African-like ancestry
#   pnonAf <- mean(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],6])
#   minnonAf <- min(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],6])
#   maxnonAf <- max(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],6])
# 
#   # Proportion of HG-like ancestry.
#   pHG <- mean(coeff2[coeff2$pop==POP[i,1],3]+coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],5])
#   minHG <- min(coeff2[coeff2$pop==POP[i,1],3]+coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],5])
#   maxHG <- max(coeff2[coeff2$pop==POP[i,1],3]+coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],5])
# 
#   # Proportion of KS from all HG ancestry
#   HGancestry <- coeff2[coeff2$pop==POP[i,1],3]+coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],5]
#   KS_mean <- mean(coeff2[coeff2$pop==POP[i,1],4]/HGancestry)
#   KS_min <- min(coeff2[coeff2$pop==POP[i,1],4]/HGancestry)
#   KS_max <- max(coeff2[coeff2$pop==POP[i,1],4]/HGancestry)
# 
#   # Proportion of RHG from all HG ancestry
#   RHG_mean <- mean(coeff2[coeff2$pop==POP[i,1],5]/HGancestry)
#   RHG_min <- min(coeff2[coeff2$pop==POP[i,1],5]/HGancestry)
#   RHG_max <- max(coeff2[coeff2$pop==POP[i,1],5]/HGancestry)
# 
#   # Proportion of eHG from all HG ancestry
#   eHG_mean <- mean(coeff2[coeff2$pop==POP[i,1],3]/HGancestry)
#   eHG_min <- min(coeff2[coeff2$pop==POP[i,1],3]/HGancestry)
#   eHG_max <- max(coeff2[coeff2$pop==POP[i,1],3]/HGancestry)
# 
#   # Write out
#   write.table(file="pong_output_2020-12-14_17h25m52s/summary_K6_r18_mean_min_max_WAfrlike_nonAfrlike_HGlike",
#               t(c(as.vector(POP[i,1]),pWf,minWf,maxWf,pnonAf,minnonAf,maxnonAf,pHG,minHG,maxHG)),col.names = FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
#   write.table(file="pong_output_2020-12-14_17h25m52s/summary_K6_r18_mean_min_max_prop_different_HG",
#               t(c(as.vector(POP[i,1]),KS_mean,KS_min,KS_max,RHG_mean,RHG_min,RHG_max,eHG_mean,eHG_min,eHG_max)),col.names = FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
# }
# 
# 
# # 20200717: Include sem for the "interesting components"
# write.table(file="pong_output_2020-12-14_17h25m52s/summary_K6_r18_mean_sem_WAfrlike_nonAfrlike_HGlike",
#             t(c("POP","WAfr_mean","WAfr_sem","WAfr_sd","nonAfr_mean","nonAfr_sem","nonAfr_sd","HG_mean","HG_sem","HG_sd")),
#             col.names = FALSE,row.names=FALSE,quote=FALSE)
# #
# for (i in c(1:length(POP[,1]))) {
#   # Proportion of WAfr-like ancestry.
#   pWf <- mean(coeff2[coeff2$pop==POP[i,1],7])
#   semWf <- sd(coeff2[coeff2$pop==POP[i,1],7])/sqrt(length(coeff2[coeff2$pop==POP[i,1],2]))
#   sdWf <- sd(coeff2[coeff2$pop==POP[i,1],7])
#   
#   # Proportion of non-African-like ancestry
#   pnonAf <- mean(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],6])
#   semnonAf <- sd(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],6])/sqrt(length(coeff2[coeff2$pop==POP[i,1],2]))
#   sdnonAf <- sd(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],6])
# 
#   # Proportion of HG-like ancestry.
#   pHG <- mean(coeff2[coeff2$pop==POP[i,1],3]+coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],5])
#   semHG <- sd(coeff2[coeff2$pop==POP[i,1],3]+coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],5])/sqrt(length(coeff2[coeff2$pop==POP[i,1],2]))
#   sdHG <- sd(coeff2[coeff2$pop==POP[i,1],3]+coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],5])
#   
#   # Write out
#   write.table(file="pong_output_2020-12-14_17h25m52s/summary_K6_r18_mean_sem_WAfrlike_nonAfrlike_HGlike",
#               t(c(as.vector(POP[i,1]),pWf,semWf,sdWf,pnonAf,semnonAf,sdnonAf,pHG,semHG,sdHG)),col.names = FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
# }


# Visual representation
#How can I represent the proportion of HG ancestry? (from the total) Add a pie chart with in black the proportion of HG or something like that?
#Edit 20210330: I need to save the files in a different format than PNG to be able to modify them. What is the input??
#Edit 20210609: Adding broad group next to the population name (e.g. "KS", "RHG")

mat <- matrix(nrow=4,ncol=14) #the fourth row is for the total HG-like proportion and will not be used for the bar plots.
subset <- c("Bangweulu","Kafue","Bemba","Lozi","Tonga","Juhoansi","BakaC","Hadza","Sabue","Nzebi",
            "Nzime","Khwe","Amhara","Zulu")
for (i in c(1:length(subset))) {
  # Proportion of HG-like ancestry.
  pHG <- mean(coeff2[coeff2$pop==subset[i],3]+coeff2[coeff2$pop==subset[i],4]+coeff2[coeff2$pop==subset[i],5])
  # Proportion of KS from all HG ancestry
  HGancestry <- coeff2[coeff2$pop==subset[i],3]+coeff2[coeff2$pop==subset[i],4]+coeff2[coeff2$pop==subset[i],5]
  KS_mean <- mean(coeff2[coeff2$pop==subset[i],4]/HGancestry)
  # Proportion of RHG from all HG ancestry
  RHG_mean <- mean(coeff2[coeff2$pop==subset[i],5]/HGancestry)
  # Proportion of eHG from all HG ancestry
  eHG_mean <- mean(coeff2[coeff2$pop==subset[i],3]/HGancestry)
  # Fill the matrix.
  mat[,i] <- c(KS_mean,RHG_mean,eHG_mean,pHG)
}

# subset_proper=c("BaTwa (Bangweulu)","BaTwa (Kafue)","Bemba","Lozi","Tonga",
#                 "Ju|'hoansi","Baka (Cameroon)","Hadza","Sabue","Nzebi",
#                 "Nzime","Khwe","Amhara","Zulu")
subset_proper=c("BaTwa (Bangweulu)","BaTwa (Kafue)","Bemba","Lozi","Tonga",
                "Ju|'hoansi (KS)","Baka (Cameroon) (RHG)","Hadza (eHG)","Sabue (eHG)","Nzebi (BS-WAf)",
                "Nzime (BS-WAf)","Khwe (KS)","Amhara (eA)","Zulu (BS-SAf)")

#Barplots with proportions of KS-like, RHG-like, eAHG-like
#svg(filename="20210330_barplots_HGcomponentsproportions.svg")
svg(filename="20210609_barplots_HGcomponentsproportions.svg")
par(mar=c(5, 10.5, 4, 7))
barplot(mat[1:3,],beside=FALSE,horiz=TRUE,names.arg=subset_proper,las=1,
        legend.text=c("KS-like","RHG-like","eHG-like"),
        args.legend = list(x = "topright", bty = "n", inset=c(-0.35, 0)),
        main="Proportions of different hunter-gatherer-like components") #to play with colours: col=c()
dev.off()
# 
# #Pie charts with total HG-like and total non-HG like proportions
# svg(filename = "20210330_piecharts_totalHGproportion.svg")
# par(mar=(c(1,2,4,2)+0.1),mfrow=c(3,5))
# for (i in c(1:length(subset))) {
# pie(x=c(mat[4,i],1-mat[4,i]),col=c("black","white"),labels=c("HG-like","rest"),main=subset_proper[i])
# }
# dev.off()
# 
# #Or add more bar plots? (more readable)
# #In any case I need them for the synthetic figure.
# svg(filename = "20210330_barcharts_totalHGproportion_Zambia.svg")
# HG_nonHG <- matrix(nrow=2,c(1-mat[4,],mat[4,]),byrow=TRUE)
# barplot(HG_nonHG[,1:5],beside=FALSE,horiz=FALSE,names.arg=subset_proper[1:5],las=1,
#         legend.text=c("HG-like","non-HG-like"),
#         args.legend = list(x = "topright", bty = "n", inset=c(-0.35, 0))) #to play with colours: col=c()
# dev.off()

#20210219
#Focus on the RHG/West African proportion.
K=6
run=18
coeff <- read.table(file=paste("adm_Qs_202012_mergeOmni1_pruned_K2-12_20repeats/zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.",K,".Q.",run,sep=""))
pop_ind <- read.table(file="zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_2.POP-IND") #TODO modify
coeff2 <- data.frame(cbind(pop_ind$V1,coeff))
names(coeff2) <- c("pop","component1","component2","component3","component4","component5","component6") #Here component4 is RHG and component 6 is Niger-Congo.

subset <- c("Bangweulu","Kafue","Zambia_Bemba","Zambia_Lozi","Zambia_TongaZam","Juhoansi","Baka_Cam","Tanzania_Hadza","Ethiopia_Sabue","Nzebi_Gab",
            "Nzime_Cam","Khwe","Amhara","Zulu")

subset_proper=c("BaTwa (Bangweulu)","BaTwa (Kafue)","Bemba","Lozi","Tonga",
                "Ju|'hoansi","Baka (Cameroon)","Hadza","Sabue","Nzebi",
                "Nzime","Khwe","Amhara","Zulu")

prop_rhg <- c()
poplist <- c()

for (i in c(1:length(subset))) {
  prop_rhg <- c(prop_rhg,coeff2[coeff2$pop==subset[i],5]/(coeff2[coeff2$pop==subset[i],5]+coeff2[coeff2$pop==subset[i],7]))
  nsam <- nrow(coeff2[coeff2$pop==subset[i],])
  poplist <- c(poplist,rep(subset[i],nsam))
}

#Default order
boxplot(prop_rhg ~ poplist, cex.axis=0.5, las=2)

#Order that I want (Zambian populations first)
data <- data.frame(poplist,prop_rhg)
data$poplist <- factor(data$poplist, levels=subset)
boxplot(data$prop_rhg ~ data$poplist, cex.axis=0.5, names=subset_proper, las=2) #This shows that the BaTwa (in particular the ones from Kafue) have a larger proportion of RHG-like component than the other three Zambian populations.

#Ordered by increasing median.
new_order <- with(data, reorder(poplist , prop_rhg, median , na.rm=T))
boxplot(data$prop_rhg ~ new_order)

par(mar=(c(8,4,4,2)+0.1)) #Default mar: c(5, 4, 4, 2) + 0.1
boxplot(data$prop_rhg ~ new_order, cex.axis=0.8, las=2, 
        ylab="Proportion of RHG-like genetic membership compared to the proportion of West African-like genetic membership",
        main="Relative RHG-like and West-African-like genetic membership",
        names=c("Zulu","Lozi","Tonga","Bemba","BaTwa (Bangweulu)","Khwe","Nzebi","BaTwa (Kafue)","Nzime","Ju|'hoansi","Amhara","Hadza","Baka (Cameroon)","Sabue"),
        xlab="",
        col=c("white","cyan","cyan","cyan","darkorchid4","white","white","darkorchid4","white","white","white","white","white","white"))
#CAUTION! The "names" vector has to be edited manually based on the order of the medians.

#If we want to include such a figure, I can color it like the ROH figures so that everything fits together nicely.

#Statistical test? I think we want to compare whether the means are the same.
##Test whether the BaTwa from Kafue have a mean RHG proportion greater than the Lozi, Bemba and Tonga.
t.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Zambia_Lozi"],alternative="greater") #p-value = 1.471e-14, mean of x: 0.15087420, mean of y: 0.07897168
t.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Zambia_Bemba"],alternative="greater") #p-value = 3.383e-11, mean of x: 0.15087420, mean of y: 0.07433091
t.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Zambia_TongaZam"],alternative="greater") #p-value = 1.484e-13, mean of x: xx, mean of y: 0.08273102

##Test whether the BaTwa from Bangweulu have a mean RHG proportion greater than the Lozi, Bemba and Tonga.
t.test(x=prop_rhg[poplist=="Bangweulu"],y=prop_rhg[poplist=="Zambia_Bemba"],alternative="greater") #p-value = 0.0003462, mean of x: 0.10075100, mean of y: 0.07433091
t.test(x=prop_rhg[poplist=="Bangweulu"],y=prop_rhg[poplist=="Zambia_Lozi"],alternative="greater") #p-value = 6.336e-07, mean of x: xx, mean of y: 0.07897168
t.test(x=prop_rhg[poplist=="Bangweulu"],y=prop_rhg[poplist=="Zambia_TongaZam"],alternative="greater") #p-value = 2.388e-06, mean of x: xx, mean of y: 0.08273102

# -> Yes, the BaTwa have a larger mean RHG over RHG+Niger-Congo farmers proportion than the other populations from Zambia.

# TODO figure out why it is "Welch Two Sample t-test" (also called Welch's unequal variances t-test) and not Student's t-test.
#Apparently by default it assumes that the variances are different. If they are equal you can use "var.equal=TRUE". To test it: var.test(x,y)
var.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Zambia_Lozi"]) #p-value = 0.0001378 - not equal.
var.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Zambia_Bemba"]) #p-value = 0.08466 - the hypothesis that they are equal cannot be rejected.
var.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Zambia_TongaZam"]) #p-value = 5.508e-05
var.test(x=prop_rhg[poplist=="Bangweulu"],y=prop_rhg[poplist=="Zambia_Lozi"]) #p-value = 0.8297
var.test(x=prop_rhg[poplist=="Bangweulu"],y=prop_rhg[poplist=="Zambia_Bemba"]) #p-value = 0.04439
var.test(x=prop_rhg[poplist=="Bangweulu"],y=prop_rhg[poplist=="Zambia_TongaZam"]) #p-value = 0.03677

##Student's t.test for the two tests where the variances are equal:
t.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Zambia_Bemba"],alternative="greater",var.equal = TRUE) #p-value = 8.661e-10
t.test(x=prop_rhg[poplist=="Bangweulu"],y=prop_rhg[poplist=="Zambia_Lozi"],alternative="greater",var.equal = TRUE) #p-value = 2.173e-07
#It does not make much of a difference!

#######
#Edit 20210310: I want to look into the proportion of RHG in the Bantu-speaking populations from southern Africa. Is it higher or lower than in the Bemba, Lozi and Tonga?
subset <- c("Bangweulu","Kafue","Zambia_Bemba","Zambia_Lozi","Zambia_TongaZam",
            "Juhoansi","Baka_Cam","Tanzania_Hadza","Ethiopia_Sabue","Nzebi_Gab",
            "Nzime_Cam","Khwe","Amhara","Zulu",
            "SEBantu","Sotho","SWBantu")

subset_proper=c("BaTwa (Bangweulu)","BaTwa (Kafue)","Bemba","Lozi","Tonga",
                "Ju|'hoansi","Baka (Cameroon)","Hadza","Sabue","Nzebi",
                "Nzime","Khwe","Amhara","Zulu",
                "SEBantu","Sotho","SWBantu")

prop_rhg <- c()
poplist <- c()

for (i in c(1:length(subset))) {
  prop_rhg <- c(prop_rhg,coeff2[coeff2$pop==subset[i],5]/(coeff2[coeff2$pop==subset[i],5]+coeff2[coeff2$pop==subset[i],7]))
  nsam <- nrow(coeff2[coeff2$pop==subset[i],])
  poplist <- c(poplist,rep(subset[i],nsam))
}

data <- data.frame(poplist,prop_rhg)

#Ordered by increasing median.
new_order <- with(data, reorder(poplist , prop_rhg, median , na.rm=T))
boxplot(data$prop_rhg ~ new_order)

par(mar=(c(8,4,2,2)+0.1)) #Default mar: c(5, 4, 4, 2) + 0.1
boxplot(data$prop_rhg ~ new_order, cex.axis=0.8, las=2, 
        ylab="Ratio RHG-like to West African-like genetic membership proportion",
        # main="Relative RHG-like and West-African-like genetic membership",
        names=c("SEBantu-speakers","Sotho","Zulu","Lozi","Tonga","Bemba","BaTwa (Bangweulu)","Herero","Khwe","Nzebi","BaTwa (Kafue)","Nzime","Ju|'hoansi","Amhara","Hadza","Baka (Cameroon)","Sabue"),
        xlab="",
        # col=c("white","white","white","cyan","cyan","cyan","darkorchid4","white","white","white","darkorchid4","white","white","white","white","white","white")
        # col=c("deepskyblue","deepskyblue4","cyan4","lightsteelblue2","lightsteelblue3","lightsteelblue1","darkorchid1","deepskyblue3",
              # "indianred4","white","darkorchid4","white","red","darkgoldenrod","white","white","white")) #This color vector is similar to the one for the ROH, except that I did not have the Omni1-only populations for the ROH plot.
        col=c("white","white","white","lightsteelblue2","lightsteelblue3","lightsteelblue1","darkorchid1","white","white","white","darkorchid4","white","white","white","white","white","white"))
#CAUTION! The "names" vector has to be edited manually based on the order of the medians.
#Interesting! The SEBantu, Sotho and Zulu have the three lowest medians. The SWBantu is similar to the BaTwa from Bangweulu.

t.test(x=prop_rhg[poplist=="SEBantu"],y=prop_rhg[poplist=="Zambia_Lozi"],alternative="less") #p-value < 2.2e-16
t.test(x=prop_rhg[poplist=="Sotho"],y=prop_rhg[poplist=="Zambia_Lozi"],alternative="less") #p-value < 2.2e-16
t.test(x=prop_rhg[poplist=="Zulu"],y=prop_rhg[poplist=="Zambia_Lozi"],alternative="less") #p-value < 2.2e-16
t.test(x=prop_rhg[poplist=="SWBantu"],y=prop_rhg[poplist=="Zambia_Lozi"]) #p-value = 0.00133 - the mean in the SWBantu is significantly higher.


#Double-check that the three Zambian agropastoralist populations have the same mean!
t.test(x=prop_rhg[poplist=="Zambia_Bemba"],y=prop_rhg[poplist=="Zambia_Lozi"]) #p-value = 0.492
t.test(x=prop_rhg[poplist=="Zambia_TongaZam"],y=prop_rhg[poplist=="Zambia_Lozi"]) #p-value = 0.3304
t.test(x=prop_rhg[poplist=="Zambia_TongaZam"],y=prop_rhg[poplist=="Zambia_Bemba"]) #p-value = 0.1993

#Do the BaTwa from Bangweulu and from Kafue have the same mean?
t.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Bangweulu"]) #p-value = 7.672e-10. No. Greater in Kafue.
t.test(x=prop_rhg[poplist=="Kafue"],y=prop_rhg[poplist=="Bangweulu"],alternative = "greater") #p-value = 3.836e-10

#And the BaTwa from Bangweulu and the SWBantu?
t.test(x=prop_rhg[poplist=="SWBantu"],y=prop_rhg[poplist=="Bangweulu"]) #p-value = 0.4336. Same mean.


