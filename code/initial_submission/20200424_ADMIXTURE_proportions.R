### Gwenna Breton
### 20200424
### Goal: prepare summary tables of the ancestry proportions based on the admixture runs.
#20200717: Redone with new results.

setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/ADMIXTURE/")

#Omni2.5
#pong_output_2020-04-22_12h27m47s


#Omni1
#pong_output_2020-04-22_12h22m54s/
#I chose K=6 (I could take K=4 as well).
#Representative run: run 1
#coeff <- read.table(file="pong_output_2020-04-22_12h22m54s/runs/k6r1_reprun.Q")
#pop <- read.table(file="ind2pop_20200402_mergeOmni1_newnames.txt")

coeff <- read.table(file="pong_output_2020-07-17_18h00m16s/runs/k6r18_reprun.Q")
pop <- read.table(file="ind2pop_20200717_mergeOmni1_newnames.txt")

#Comment: I would like to have individuals names, but I do not have good names for all of them... Working with populations at the moment.
coeff2 <- data.frame(cbind(pop$V1,coeff))
names(coeff2) <- c("pop","component1","component2","component3","component4","component5","component6")

#component1: Niger-Congo (e.g. Yoruba_Nigeria)
#component2: RHG (e.g. Baka_Cameroon)
#component3: eHG (e.g. Sabue_Ethiopia)
#component4: Han_China
#component5: KS (e.g. Juhoansi_Namibia)
#component6: CEU_US

# 20200717
# What I had done earlier: mean of the population. But I discussed with MJ on how to get standard errors and for the ratio he suggested that I give the range (e.g. min max in the population). So I will do that.
#I also decided to take different fractions than what I had taken earlier.

# #For each component, write out the mean of the population and the standard error of the mean.
# # write.table(file="pong_output_2020-04-22_12h22m54s/summary_admixture_coeff_K6_r1_mean_and_standarderrorofmean",
# #             t(c("POP","C1_mean","C2_mean","C3_mean","C4_mean","C5_mean","C6_mean","C1_sem","C2_sem","C3_sem","C4_sem","C5_sem","C6_sem")),
# #             col.names = FALSE,row.names=FALSE,quote=FALSE)
# write.table(file="pong_output_2020-07-17_18h00m16s/summary_admixture_coeff_K6_r18_mean_and_standarderrorofmean",
#             t(c("POP","C1_mean","C2_mean","C3_mean","C4_mean","C5_mean","C6_mean","C1_sem","C2_sem","C3_sem","C4_sem","C5_sem","C6_sem")),
#             col.names = FALSE,row.names=FALSE,quote=FALSE)

POP <- unique(pop)
#
# for (i in c(1:length(POP[,1]))) {
#   mean <- colMeans(coeff2[coeff2$pop==POP[i,1],2:7])
#   sem <- lapply(coeff2[coeff2$pop==POP[i,1],2:7], function(x) sd(x)/sqrt(length(coeff2[coeff2$pop==POP[i,1],2])))
#   write.table(file="pong_output_2020-07-17_18h00m16s/summary_admixture_coeff_K6_r18_mean_and_standarderrorofmean",t(c(as.vector(POP[i,1]),as.vector(mean),as.vector(sem))),col.names = FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
# }
# 
# #Look into proportions of the different components.
# coeff_mean <- read.table(file="pong_output_2020-04-22_12h22m54s/summary_admixture_coeff_K6_r1_mean_and_standarderrorofmean",header=TRUE)
# 
# ##KS-like/Niger-Congo-like ratio
# cbind.data.frame(POP,round(((coeff_mean$C5_mean/(coeff_mean$C5_mean+coeff_mean$C1_mean))*100),2))
# write.table(cbind.data.frame(POP,round(((coeff_mean$C5_mean/(coeff_mean$C5_mean+coeff_mean$C1_mean))*100),2)),
#             file="KS_NC_component_ratio_bypop",col.names=c("POP","RATIO"),row.names=FALSE,quote=FALSE)
# #a value above 50 means that the proportion of KS-like is larger than the proportion of Niger-Congo-like. But of course, both proportions can represent a tiny amount of the diversity.
# #Bangweulu: 8.6%, Kafue: 18.9%, Bemba: 2.8%, Lozi: 3.3%, Tonga: 3.6%.
# 
# ##KS-like/RHG-like ratio
# write.table(cbind.data.frame(POP,round(((coeff_mean$C5_mean/(coeff_mean$C5_mean+coeff_mean$C2_mean))*100),2)),
#             file="KS_RHG_component_ratio_bypop",col.names=c("POP","RATIO"),row.names=FALSE,quote=FALSE)
# #a value above 50 means that the proportion of KS-like is larger than the proportion of RHG-like.
# #Bangweulu: 45.4%, Kafue: 57.2% (funny! Very similar to the Hadza), Bemba: 26.1%, Lozi: 28%, Tonga: 29.3%.
# 
# ##RHG-like/NC-like ratio
# write.table(cbind.data.frame(POP,round(((coeff_mean$C2_mean/(coeff_mean$C1_mean+coeff_mean$C2_mean))*100),2)),
#             file="RHG_NC_component_ratio_bypop",col.names=c("POP","RATIO"),row.names=FALSE,quote=FALSE)
# 
# #Sum of all non-Niger-Congo-like component
# write.table(cbind.data.frame(POP,(1-coeff_mean$C1_mean)),
#             file="non_NC_component_prop_bypop",col.names=c("POP","PROP"),row.names=FALSE,quote=FALSE)
# 
# # eastern African like (C3)
# coeff_mean[,c(1,3)]

### 20200717 - new way to look at the components.
# Caution! The order of the components changed.
#component1: Han_China
#component2: Niger-Congo (e.g. Yoruba_Nigeria)
#component3: KS (e.g. Juhoansi_Namibia)
#component4: CEU_US
#component5: RHG (e.g. Baka_Cameroon)
#component6: eHG (e.g. Sabue_Ethiopia)

# write.table(file="pong_output_2020-07-17_18h00m16s/summary_K6_r18_mean_min_max_WAfrlike_nonAfrlike_HGlike",
#             t(c("POP","WAfr_mean","WAfr_min","WAfr_max","nonAfr_mean","nonAfr_min","nonAfr_max","HG_mean","HG_min","HG_max")),
#             col.names = FALSE,row.names=FALSE,quote=FALSE)
# write.table(file="pong_output_2020-07-17_18h00m16s/summary_K6_r18_mean_min_max_prop_different_HG",
#             t(c("POP","KSoverallHG_mean","KSoverallHG_min","KSoverallHG_max","RHGoverallHG_mean","RHGoverallHG_min","RHGoverallHG_max","eHGoverallHG_mean","eHGoverallHG_min","eHGoverallHG_max")),
#             col.names = FALSE,row.names=FALSE,quote=FALSE)
# 
# #
# for (i in c(1:length(POP[,1]))) {
#   # Proportion of WAfr-like ancestry.
#   pWf <- mean(coeff2[coeff2$pop==POP[i,1],3])
#   minWf <- min(coeff2[coeff2$pop==POP[i,1],3])
#   maxWf <- max(coeff2[coeff2$pop==POP[i,1],3])
#   
#   # Proportion of non-African-like ancestry
#   pnonAf <- mean(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],5])
#   minnonAf <- min(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],5])
#   maxnonAf <- max(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],5])
#   
#   # Proportion of HG-like ancestry.
#   pHG <- mean(coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],6]+coeff2[coeff2$pop==POP[i,1],7])
#   minHG <- min(coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],6]+coeff2[coeff2$pop==POP[i,1],7])
#   maxHG <- max(coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],6]+coeff2[coeff2$pop==POP[i,1],7])
#   
#   # Proportion of KS from all HG ancestry
#   HGancestry <- coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],6]+coeff2[coeff2$pop==POP[i,1],7]
#   KS_mean <- mean(coeff2[coeff2$pop==POP[i,1],4]/HGancestry)
#   KS_min <- min(coeff2[coeff2$pop==POP[i,1],4]/HGancestry)
#   KS_max <- max(coeff2[coeff2$pop==POP[i,1],4]/HGancestry)
#   
#   # Proportion of RHG from all HG ancestry
#   RHG_mean <- mean(coeff2[coeff2$pop==POP[i,1],6]/HGancestry)
#   RHG_min <- min(coeff2[coeff2$pop==POP[i,1],6]/HGancestry)
#   RHG_max <- max(coeff2[coeff2$pop==POP[i,1],6]/HGancestry)
#   
#   # Proportion of eHG from all HG ancestry
#   eHG_mean <- mean(coeff2[coeff2$pop==POP[i,1],7]/HGancestry)
#   eHG_min <- min(coeff2[coeff2$pop==POP[i,1],7]/HGancestry)
#   eHG_max <- max(coeff2[coeff2$pop==POP[i,1],7]/HGancestry)
#   
#   # Write out
#   write.table(file="pong_output_2020-07-17_18h00m16s/summary_K6_r18_mean_min_max_WAfrlike_nonAfrlike_HGlike",
#               t(c(as.vector(POP[i,1]),pWf,minWf,maxWf,pnonAf,minnonAf,maxnonAf,pHG,minHG,maxHG)),col.names = FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
#   write.table(file="pong_output_2020-07-17_18h00m16s/summary_K6_r18_mean_min_max_prop_different_HG",
#               t(c(as.vector(POP[i,1]),KS_mean,KS_min,KS_max,RHG_mean,RHG_min,RHG_max,eHG_mean,eHG_min,eHG_max)),col.names = FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
# }


# 20200717: Include sem for the "interesting components"
write.table(file="pong_output_2020-07-17_18h00m16s/summary_K6_r18_mean_sem_WAfrlike_nonAfrlike_HGlike",
            t(c("POP","WAfr_mean","WAfr_sem","WAfr_sd","nonAfr_mean","nonAfr_sem","nonAfr_sd","HG_mean","HG_sem","HG_sd")),
            col.names = FALSE,row.names=FALSE,quote=FALSE)
#
for (i in c(1:length(POP[,1]))) {
  # Proportion of WAfr-like ancestry.
  pWf <- mean(coeff2[coeff2$pop==POP[i,1],3])
  semWf <- sd(coeff2[coeff2$pop==POP[i,1],3])/sqrt(length(coeff2[coeff2$pop==POP[i,1],2]))
  sdWf <- sd(coeff2[coeff2$pop==POP[i,1],3])
  
  # Proportion of non-African-like ancestry
  pnonAf <- mean(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],5])
  semnonAf <- sd(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],5])/sqrt(length(coeff2[coeff2$pop==POP[i,1],2]))
  sdnonAf <- sd(coeff2[coeff2$pop==POP[i,1],2]+coeff2[coeff2$pop==POP[i,1],5])

  # Proportion of HG-like ancestry.
  pHG <- mean(coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],6]+coeff2[coeff2$pop==POP[i,1],7])
  semHG <- sd(coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],6]+coeff2[coeff2$pop==POP[i,1],7])/sqrt(length(coeff2[coeff2$pop==POP[i,1],2]))
  sdHG <- sd(coeff2[coeff2$pop==POP[i,1],4]+coeff2[coeff2$pop==POP[i,1],6]+coeff2[coeff2$pop==POP[i,1],7])
  
  # Write out
  write.table(file="pong_output_2020-07-17_18h00m16s/summary_K6_r18_mean_sem_WAfrlike_nonAfrlike_HGlike",
              t(c(as.vector(POP[i,1]),pWf,semWf,sdWf,pnonAf,semnonAf,sdnonAf,pHG,semHG,sdHG)),col.names = FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
}

