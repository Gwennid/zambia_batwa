#!/bin/sh

#20230818
#Gwenna Breton
#Goal: submit R script to explore admixture graphs.

cd /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/tmp_20230818_findgraph/withdenisovan/kafue
module load bioinfo-tools
module load R_packages/4.1.1
Rscript /crex/proj/snic2020-2-10/uppstore2018150/private/scripts/find_graphs/explore_admixture_graphs_denisovan_kafue_m4.R
