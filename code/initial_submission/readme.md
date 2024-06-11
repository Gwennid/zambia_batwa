This folder contains code used to prepare the data and perform analyses. It corresponds to the initial submission of the work.

- Processing of the Zambian BaTwa dataset (autosomes): [prepare_data_Zambian_BaTwa.sh](prepare_data_Zambian_BaTwa.sh)
- Processing of re-used datasets and merging with the Zambian BaTwa dataset (autosomes): [prepare_reused_data_and_merge.sh](prepare_reused_data_and_merge.sh)
  - this includes haplodizing the data for merging with ancient DNA samples: [haploidize_tped.py](haploidize_tped.py)
- Processing of Zambian BaTwa and re-used dataset, merging (autosomes plus X chromosome), and corresponding analyses (X to autosome ancestry ratio): [prepare_data_1-22X.sh](prepare_data_1-22X.sh)
  - the procedure for the X to autosome ancestry ratio was repeated for a dense set: [Xtoautosomes_ancestry_ratio_H3Africa-Omni2.5.sh](Xtoautosomes_ancestry_ratio_H3Africa-Omni2.5.sh)
- Phasing (autosomes): [phase_data.sh](phase_data.sh)
- Processing Y chromosome: [prepare_data_Y_chr.sh](prepare_data_Y_chr.sh)
- Initial analyses: PCA, ADMIXTURE, ROH, f4 ratio: [initial_analyses.sh](initial_analyses.sh)
  - Additional code for f4 ratio test, for both datasets - Omni2.5 and Omni1: [f4_ratio_test.sh](f4_ratio_test.sh)
  - Get ADMIXTURE proportions: [20210115_ADMIXTURE_proportions.R](20200424_ADMIXTURE_proportions.R), [20210218_ADMIXTURE_proportions_mergeOmni1-ancient.R](20210218_ADMIXTURE_proportions_mergeOmni1-ancient.R)
- f3 analyses: [f3_test.sh](f3_test.sh), [par.f3test](par.f3test)
- MOSAIC analyses:
  - prepare the files and run the analyses: [20201218_MOSAIC.sh](20201218_MOSAIC.sh), [replace_population_names_for_MOSAIC_shorternames.sh](replace_population_names_for_MOSAIC_shorternames.sh)
  - extract relevant information from the outputs: [20200429_replot_MOSAIC_results.R](20200429_replot_MOSAIC_results.R), [20200718_MOSAIC_bootstrap.R](20200718_MOSAIC_bootstrap.R), [20210114_MOSAIC.R](20210114_MOSAIC.R) and [New_MOSAIC_functions_for_the_cluster.txt](New_MOSAIC_functions_for_the_cluster.txt)
- Extract genotypes for lactase persistence alleles: [20230907_LP.sh](20230907_LP.sh)
- Diverse plotting scripts: [plotASDmatrix.R](plotASDmatrix.R), [plot_ADMIXTURE_with_pong.sh](plot_ADMIXTURE_with_pong.sh), [prepare_ADMIXTURE-plotting_ancient-modern.R](prepare_ADMIXTURE-plotting_ancient-modern.R), [plot_PCA.R](plot_PCA.R), [plot_f4ratiotest.R](plot_f4ratiotest.R), [plot_roh.R](plot_roh.R)
