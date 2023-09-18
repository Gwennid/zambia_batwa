### Gwenna Breton
### 20210218
### Goal: repeat the analysis/plots in 20210115_ADMIXTURE_proportions.R for the merge Omni1+ancient individuals.

setwd("/home/gwennabreton/Desktop/from20210203/P3/results/ADMIXTURE/")

#Omni1
#pong_output_2021-02-17_12h27m37s/result_summary.txt
#I chose K=6.
#Representative run: run 13
K <- 6
run <- 13
coeff <- read.table(file=paste("adm_Qs_202102_mergeOmni1-ancient_ld50_K2-12_20repeats/omni1finalmerge_ancient4fexhap_2_ld50-10-0.1.",K,".Q.",run,sep=""))
pop <- read.table(file="ind2pop_202102_mergeOmni1-ancient_newnames.txt")

#Comment: I would like to have individuals names, but I do not have good names for all of them... Working with populations at the moment.
coeff2 <- data.frame(cbind(pop$V1,coeff))
names(coeff2) <- c("pop","component1","component2","component3","component4","component5","component6")

#component1: RHG (e.g. BakaC)        
#component2: Han
#component3: CEU
#component4: Niger-Congo (e.g. Yoruba)
#component5: KS (e.g. Juhoansi)
#component6: eHG (e.g. Sabue)

POP <- unique(pop)

# Visual representation
#How can I represent the proportion of HG ancestry? (from the total) Add a pie chart with in black the proportion of HG or something like that?
mat <- matrix(nrow=4,ncol=14) #the fourth row is for the total HG-like proportion and will not be used for the bar plots.
subset <- c("Bangweulu","Kafue","Bemba","Lozi","Tonga","Juhoansi","BakaC","Hadza","Sabue","Nzebi",
            "Nzime","Khwe","Amhara","Zulu")
for (i in c(1:length(subset))) {
  # Proportion of HG-like ancestry.
  pHG <- mean(coeff2[coeff2$pop==subset[i],2]+coeff2[coeff2$pop==subset[i],6]+coeff2[coeff2$pop==subset[i],7])
  # Proportion of KS from all HG ancestry
  HGancestry <- coeff2[coeff2$pop==subset[i],2]+coeff2[coeff2$pop==subset[i],6]+coeff2[coeff2$pop==subset[i],7]
  KS_mean <- mean(coeff2[coeff2$pop==subset[i],6]/HGancestry)
  # Proportion of RHG from all HG ancestry
  RHG_mean <- mean(coeff2[coeff2$pop==subset[i],2]/HGancestry)
  # Proportion of eHG from all HG ancestry
  eHG_mean <- mean(coeff2[coeff2$pop==subset[i],7]/HGancestry)
  # Fill the matrix.
  mat[,i] <- c(KS_mean,RHG_mean,eHG_mean,pHG)
}

subset_proper=c("BaTwa (Bangweulu)","BaTwa (Kafue)","Bemba","Lozi","Tonga",
                "Ju|'hoansi","Baka (Cameroon)","Hadza","Sabue","Nzebi",
                "Nzime","Khwe","Amhara","Zulu")

#Barplots with proportions of KS-like, RHG-like, eAHG-like
par(mar=c(5, 9, 4, 7),mfrow=c(1,1))
barplot(mat[1:3,],beside=FALSE,horiz=TRUE,names.arg=subset_proper,las=1,
        legend.text=c("KS-like","RHG-like","eHG-like"),
        args.legend = list(x = "topright", bty = "n", inset=c(-0.35, 0)),
        main="Proportions of different hunter-gatherer-like components") #to play with colours: col=c()
   
#Pie charts with total HG-like and total non-HG like proportions
par(mar=(c(1,2,4,2)+0.1),mfrow=c(3,5))
for (i in c(1:length(subset))) {
pie(x=c(mat[4,i],1-mat[4,i]),col=c("black","white"),labels=c("HG-like","rest"),main=subset_proper[i])
}

#Or add more bar plots? (more readable)
#In any case I need them for the synthetic figure.
HG_nonHG <- matrix(nrow=2,c(1-mat[4,],mat[4,]),byrow=TRUE)
barplot(HG_nonHG[,1:5],beside=FALSE,horiz=FALSE,names.arg=subset_proper[1:5],las=1,
        legend.text=c("HG-like","non-HG-like"),
        args.legend = list(x = "topright", bty = "n", inset=c(-0.35, 0))) #to play with colours: col=c()

#New (20210218) for both the ancient+modern and modern only analysis: Look into the proportion of RHG-like in relation with the proportion of West African like.
##All populations.
prop_rhg <- coeff2$component1/(coeff2$component1+coeff2$component4)
prop_wafr <- coeff2$component4/(coeff2$component1+coeff2$component4)
plot(prop_rhg,prop_wafr,col=as.factor(coeff2$pop)) #Not very interesting since obviously all points have to fall on the diagonal.
boxplot(prop_rhg ~ coeff2$pop)

##My favorite subset.
prop_rhg <- c()
poplist <- c()

for (i in c(1:length(subset))) {
  prop_rhg <- c(prop_rhg,coeff2[coeff2$pop==subset[i],2]/(coeff2[coeff2$pop==subset[i],2]+coeff2[coeff2$pop==subset[i],5]))
  nsam <- nrow(coeff2[coeff2$pop==subset[i],])
  poplist <- c(poplist,rep(subset[i],nsam))
}

#Default order
boxplot(prop_rhg ~ poplist)

#Order that I want (Zambian populations first)
data <- data.frame(poplist,prop_rhg)
data$poplist <- factor(data$poplist, levels=subset)
boxplot(data$prop_rhg ~ data$poplist) #This shows that the BaTwa (in particular the ones from Kafue) have a larger proportion of RHG-like component than the other three Zambian populations.

#Ordered by increasing median.
new_order <- with(data, reorder(poplist , prop_rhg, median , na.rm=T))
boxplot(data$prop_rhg ~ new_order, cex.axis=0.8)

#To be continued... What should I conclude? The difference is not significant I think, though the Kafue in particular are quite off (similar to the Nzebi/Nzime in fact).




