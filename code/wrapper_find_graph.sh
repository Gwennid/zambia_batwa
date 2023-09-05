#This is a template script, to be adjusted to your purpose.
#!/bin/sh

#20230818
#Gwenna Breton
#Goal: submit R script to explore admixture graphs.

cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph
module load bioinfo-tools
module load R_packages/4.1.1
Rscript /crex/proj/snic2020-2-10/uppstore2018150/private/scripts/find_graphs/explore_admixture_graphs.R
