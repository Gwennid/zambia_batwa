#20230818
#Gwenna Breton
#Based on Luciana Simoes' "explore_admixture_graphs.R" script. This is a template script.
library(admixtools, lib.loc='/domus/h1/gwennabr/R/x86_64-redhat-linux-gnu-library/4.1.1/')
library(dplyr)
setwd("/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph") #Replace by appropriate path

f2=f2_from_geno("July2023_YRI-Juhoansi-Baka_Cam-Tanzania_Hadza-Bangweulu",maxmiss=0.15)

for (m in 1:3){
  best.s=.Machine$integer.max
  for (i in 1:1000){
    set.seed(i) #keep track of random seed, in order to reproduce models
    opt_results = find_graphs(f2, numadmix = m, stop_gen = 10000, stop_gen2 = 30, plusminus_generations = 10)
    #opt_results = find_graphs(f2, numadmix = m, stop_gen = 10000, stop_gen2 = 30, plusminus_generations = 10, outpop = 'Denisovan')
    winner = opt_results %>% slice_min(score, with_ties = FALSE)
    s=winner$score[[1]]
    if (s<=best.s*1.1){ 
      #plot graphs with LL close to the currently best model
      pdf(paste('20230823/plots/graph',m,i,s,'pdf',sep='.')) #Replace by appropriate path to output PDFs
      print(plot_graph(winner$edges[[1]]))
      dev.off()
      if (s<best.s){
        best.M=winner
        best.s=s      
      }
    }
  }
  assign(paste('best.M',m,sep=''),best.M) #save the best model for a certain m
}


save.image("graphs.RData")
#load('graphs.RData')

#test which graph fits better (if $p is high, then the more complicated model does not provide a significantly better fit, regardless of a possibly better likelihood)
fits = qpgraph_resample_multi(f2, list(best.M2$graph[[1]], best.M3$graph[[1]]), nboot = 1000)
compare_fits(fits[[1]]$score_test, fits[[2]]$score_test)
