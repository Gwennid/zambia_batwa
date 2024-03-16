#Gwenna Breton
#2024-03-16
#Goal: calculate ancestry fractions for the autosomes and chromosome X. For the autosomes, it will be 1-SAfr_ancestry. For the X chromosome it will be different since the average is weighted (by the number of X chromosomes).
#TODO get stdev too.
#This code is based on code in TMP_processXchr_tobemergedwithmainpreparedatafile.sh

#setwd("/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/preparechr1-23_Jan2021/ADMIXTURE/20210126_Afr_K2_Juhoansi_Yoruba/pong")
setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P3_Zambia/zambia_batwa/results/revisions2_NatureCommunication/X_autosomes_ancestry_ratio")
FID_IID_sex <- read.table(file="FID_IID_sex")
names(FID_IID_sex) <- c("FID","IID","sex")
pop <- unique(FID_IID_sex[,1]) #25 populations

# Autosomes

# Ran on Uppmax:
# write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file="summary_326ind_2500runs",append=FALSE,row.names=FALSE,col.names=FALSE)
# for (set in c("100_chr4","10_chr6","11_chr10","12_chr6","13_chr1","14_chr9","15_chr12","16_chr2","17_chr1","18_chr12","19_chr4","1_chr4","20_chr6","21_chr8","22_chr1",
# "23_chr10","24_chr2","25_chr7","26_chr6","27_chr3","28_chr5","29_chr10","2_chr10","30_chr12","31_chr9","32_chr5","33_chr6","34_chr7","35_chr5","36_chr6",
# "37_chr4","38_chr3","39_chr3","3_chr1","40_chr6","41_chr10","42_chr5","43_chr2","44_chr2","45_chr5","46_chr7","47_chr1","48_chr5","49_chr1","4_chr2","50_chr6",
# "51_chr9","52_chr1","53_chr10","54_chr3","55_chr10","56_chr8","57_chr8","58_chr2","59_chr5","5_chr4","60_chr2","61_chr6","62_chr9","63_chr9","64_chr7",
# "65_chr3","66_chr10","67_chr3","68_chr4","69_chr1","6_chr2","70_chr3","71_chr5","72_chr9","73_chr3","74_chr6","75_chr7","76_chr9","77_chr4","78_chr8",
# "79_chr2","7_chr1","80_chr7","81_chr2","82_chr6","83_chr2","84_chr10","85_chr8","86_chr1","87_chr9","88_chr7","89_chr6","8_chr5","90_chr1","91_chr6",
# "92_chr12","93_chr6","94_chr2","95_chr3","96_chr1","97_chr8","98_chr7","99_chr8","9_chr10")) {
#  for (i in 1:25) {
#   ancestry_frac <- read.table(file=paste("adm_Qs_",set,"_K2_25repeats/set",set,".2.Q.",i,sep=""))
#   write.table(data.frame(set,i,FID_IID_sex$FID,FID_IID_sex$IID,ancestry_frac),file="summary_531ind_2500runs",append=TRUE,row.names=FALSE,col.names=FALSE)
#  }
# }

## Get mean and standard deviation by population
all <- read.table(file="../../initial_submission/X_autosomes_ancestry_ratio/summary_531ind_2500runs",header=TRUE)

### West African
write.table(file="avg_sd_WAfr_2500iterations_by_pop",t(c("FID","mean_WAfr","sd_WAfr")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
	POP <- pop[i]
	write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,6]),sd(all[all$FID==POP,][,6]))),file="avg_sd_WAfr_2500iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}

### Khoe-San (as in initial submission)
write.table(file="avg_sd_KS_2500iterations_by_pop",t(c("FID","mean_KS","sd_KS")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
        POP <- pop[i]
        write.table(t(c(as.vector(POP),mean(all[all$FID==POP,][,5]),sd(all[all$FID==POP,][,5]))),file="avg_sd_KS_2500iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}

# X chromosome
#Females weight double as much like males, since they have two X chromosomes. I also did the calculations without weighting the females (summary_531ind_chr23_25runs and avg_chr23_25iterations_by_pop) and the two are very similar (which makes sense I suppose, unless very recent admixture).
#My values are still super high compared to NH's for the Nama, I do not know why!

# Ran on Uppmax:
# write.table(t(c("SET","iteration","FID","IID","A_1","A_2")),file="summary_531ind_chr23_weighted_25runs",append=FALSE,row.names=FALSE,col.names=FALSE)
# for (i in 1:25) {
# ancestry_frac <- read.table(file=paste("adm_Qs_23_K2_25repeats/chr23.2.Q.",i,sep=""))
# write.table(data.frame("chr23",i,FID_IID_sex$FID,FID_IID_sex$IID,ancestry_frac*FID_IID_sex$sex),
# file="summary_531ind_chr23_weighted_25runs",append=TRUE,row.names=FALSE,col.names=FALSE)
# }
#This file can be found in: # Results with Ju|'hoansi ancestry: ../../initial_submission/X_autosomes_ancestry_ratio/summary_531ind_chr23_weighted_25runs
# In this file, the ancestry fractions sum to 1 for males, and to 2 for females.

## Get mean and standard deviation by population
all <- read.table(file="../../initial_submission/X_autosomes_ancestry_ratio/summary_531ind_chr23_weighted_25runs",header=TRUE)

### West African
write.table(file="avg_WAfr_chr23_weighted_25iterations_by_pop",t(c("FID","mean_WAfr")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
        POP <- pop[i]
        sex <- sum(FID_IID_sex[FID_IID_sex$FID==POP,3])
        write.table(t(c(as.vector(POP),sum(all[all$FID==POP,][,6])/sex/25)),file="avg_WAfr_chr23_weighted_25iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}

### Khoe-San
write.table(file="avg_KS_chr23_weighted_25iterations_by_pop",t(c("FID","mean_KS")),row.names=FALSE,col.names=FALSE,append=FALSE)
for (i in 1:length(pop)) {
  POP <- pop[i]
  sex <- sum(FID_IID_sex[FID_IID_sex$FID==POP,3])
  write.table(t(c(as.vector(POP),sum(all[all$FID==POP,][,5])/sex/25)),file="avg_KS_chr23_weighted_25iterations_by_pop",row.names=FALSE,col.names=FALSE,append=TRUE)
}

# Calculate male and female contributions and ancestry ratio
##I solved by hand the equations 22 and 23 in Goldberg and Rosenberg Genetics 2015 (i.e. what NH used) and ended up with: y=4A-3X and x=3X-2A where y is the male contribution, x is the female contribution, A is the average autosomal ancestry and X is the (weighted) average X chromosome ancestry. I checked that these equations are correct by comparing to NH's Tables S1 and S2.

## Using West African ancestry
avgX <- read.table(file="avg_WAfr_chr23_weighted_25iterations_by_pop",header=TRUE)
avgA <- read.table(file="avg_sd_WAfr_2500iterations_by_pop",header=TRUE)
y <- 4*avgA$mean_WAfr - 3*avgX$mean_WAfr
x <- 3*avgX$mean_WAfr - 2*avgA$mean_WAfr
write.table(data.frame(avgX$FID,y,x), col.names=c("FID","male_contribution","female_contribution"),row.names=FALSE, file="male_female_contributions_WAfr")
write.table(file="Xtoaut_ancestry_ratio_WAfr_ancestry",data.frame(avgX$FID,avgX$mean_WAfr/avgA$mean_WAfr),
            col.names=c("FID","ratio"),row.names=FALSE)

## Using Khoe-San ancestry (as in the original submission)
avgX <- read.table(file="avg_KS_chr23_weighted_25iterations_by_pop",header=TRUE)
avgA <- read.table(file="avg_sd_KS_2500iterations_by_pop",header=TRUE)
y <- 4*avgA$mean_KS - 3*avgX$mean_KS
x <- 3*avgX$mean_KS - 2*avgA$mean_KS
write.table(data.frame(avgX$FID,y,x), col.names=c("FID","male_contribution","female_contribution"),row.names=FALSE, file="male_female_contributions_KS")
write.table(file="Xtoaut_ancestry_ratio_KS_ancestry",data.frame(avgX$FID,avgX$mean_KS/avgA$mean_KS),
            col.names=c("FID","ratio"),row.names=FALSE)

##KS results: I get the same results like initially.

# Depending on the composition of the population (males and females), the WAfr and KS contributions sum to 1 or not (e.g. in Baka from Gambia, 100% males -> the contributions sum to 1.)

## Make a summary table
contributions_WAfr <- read.table(file="male_female_contributions_WAfr",header=TRUE)
contributions_KS <- read.table(file="male_female_contributions_KS",header=TRUE)
avgX_KS <- read.table(file="avg_KS_chr23_weighted_25iterations_by_pop",header=TRUE)
avgA_KS <- read.table(file="avg_sd_KS_2500iterations_by_pop",header=TRUE)
avgX_WAfr <- read.table(file="avg_WAfr_chr23_weighted_25iterations_by_pop",header=TRUE)
avgA_WAfr <- read.table(file="avg_sd_WAfr_2500iterations_by_pop",header=TRUE)
write.table(data.frame(avgX_KS$FID,
                       contributions_WAfr$female_contribution/contributions_WAfr$male_contribution,
                       avgX_WAfr$mean_WAfr,
                       avgA_WAfr$mean_WAfr,
                       contributions_KS$female_contribution/contributions_KS$male_contribution,
                       avgX_KS$mean_KS,
                       avgA_KS$mean_KS),
            col.names=c("FID","ratio_female_male_WAfr","HX_WAfr","HA_WAfr","ratio_female_male_KS","HX_KS","HA_KS"),
            row.names=FALSE, file="ratio-female-male_and_ancestry-fractions_WAfr_KS")

## Redo the table present in the initial submission, with X to autosomes ratio and the mean ancestry proportions for the HG/KS ancestry.
#I'm adding the values for WAfr.
write.table(data.frame(avgX_KS$FID,
                       avgX_WAfr$mean_WAfr/avgA_WAfr$mean_WAfr,
                       avgX_WAfr$mean_WAfr,
                       avgA_WAfr$mean_WAfr,
                       avgX_KS$mean_KS/avgA_KS$mean_KS,
                       avgX_KS$mean_KS,
                       avgA_KS$mean_KS),
            col.names=c("FID","ratio_X_autosomes_WAfr","HX_WAfr","HA_WAfr","ratio_X_autosomes_KS","HX_KS","HA_KS"),
            row.names=FALSE, file="ratio-X-A_and_ancestry-fractions_WAfr_KS")
