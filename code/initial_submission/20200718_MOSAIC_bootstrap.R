### Gwenna Breton
### 20200717
### Goal: Get boostrap values for the MOSAIC runs (by bootstrapping sample individuals).

setwd("/home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/analyses/July2020/MOSAIC/")

require(MOSAIC)  

prefix="SEBantu_2way_1-19"
load(paste("MOSAIC_RESULTS/",prefix,"_1-22_1942_60_0.99_100.RData",sep="")) #model parameters
load(paste("MOSAIC_RESULTS/localanc_",prefix,"_1-22_1942_60_0.99_100.RData",sep="")) #local ancestry

bc_dates=bootstrap_individuals_coanc_curves(acoancs, dr, alpha)

# I am interested in bc_dates$boot.gens[[1]] 1,2 or 2,1 (same value).

bootstrap <- c()
for (i in 1:100) {
  bootstrap <- c(bootstrap,bc_dates$boot.gens[[i]][2,1])
} 
round(min(bootstrap),1)
round(max(bootstrap),1)



# 3-way admixture:

prefix="Kafue_3way_1-33"
load(paste("MOSAIC_RESULTS/",prefix,"_1-22_244_60_0.99_100.RData",sep="")) #model parameters
load(paste("MOSAIC_RESULTS/localanc_",prefix,"_1-22_244_60_0.99_100.RData",sep="")) #local ancestry  
  
bc_dates_Kafue=bootstrap_individuals_coanc_curves(acoancs, dr, alpha)
length(bc_dates_Kafue$kgens) #33 i.e. corresponds to the number of individuals in the sample.
min(bc_dates_Kafue$kgens)
max(bc_dates_Kafue$kgens)
