#Gwenna Breton
#20210114
#Goal: manipulate the MOSAIC outputs to obtain the various things that I need e.g. exact Fst values and bootstraps.

#20210114 (December 2020 runs)
#I cannot run this on my laptop because MOSAIC is not installed and apparently it is not compatible with the R version I am using. Trying on the cluster instead.
#CL: module load bioinfo-tools R/3.6.1
setwd("/proj/snic2020-2-10/uppstore2018150/private/tmp/20201218_MOSAIC/")
require(MOSAIC)

#Then copy-paste into the console the content of New_MOSAIC_functions_for_the_cluster.txt

prefix="SEBantu_2way_1-19"
load(paste("MOSAIC_RESULTS/",prefix,"_1-22_1942_60_0.99_100.RData",sep="")) #model parameters
load(paste("MOSAIC_RESULTS/localanc_",prefix,"_1-22_1942_60_0.99_100.RData",sep="")) #local ancestry
#Fst <- plot_Fst_Gwenna(all_Fst$panels,ord=T)
##Fst
#round(sort(Fst[[1]]),4)

#And bootstrap
bc_dates=bootstrap_individuals_coanc_curves(acoancs, dr, alpha)

# I am interested in bc_dates$boot.gens[[1]] 1,2 or 2,1 (same value).

bootstrap <- c()
for (i in 1:100) {
  bootstrap <- c(bootstrap,bc_dates$boot.gens[[i]][2,1])
} 
round(min(bootstrap),1)
round(max(bootstrap),1)
#See BakaC_2way_72_1-22_1942_60_acoanc.pdf for the admixture date estimate.

#Try something with mu!
Mu <- plot_Mu_Gwenna(Mu,alpha,NL)
#round(sort(Mu[[1]]),4) #this gives values distributed over all of the populations (with some having 0.0)

