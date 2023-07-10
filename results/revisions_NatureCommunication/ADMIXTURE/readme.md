# ADMIXTURE

We reran ADMIXTURE on the Omni1 dataset with the option to output the cross-validation errors (code: `code/ADMIXTURE.sh`). Results: `results/revisions_NatureCommunication/ADMIXTURE/adm_Qs_202307_mergeOmni1_pruned_K2-12_20repeats.zip`

The output was plotted with pong (code: `code/ADMIXTURE_plot_pong.sh`). The similitude with the ADMIXTURE results included in the manuscript was assessed visually (plots: `results/revisions_NatureCommunication/ADMIXTURE/mainviz_2023-6-10_10h36m47s_pong.png`).

Two types of plots were made to show the cross-validation error:

1. Using the output of pong, we identified the representative run for the major mode of each value of K, and plotted it. The lowest CV error is for K=9 (0.52350). Plot: `results/revisions_NatureCommunication/ADMIXTURE/20230710_ADMIXTURE_CVerror_major-mode-representative-run.pdf`
2. Using the output of pong, we selected the runs belonging to the major mode for each K, and calculated the mean CV error. We plotted it. The lowest mean CV error is for K=9 (0.52349). Plot: `results/revisions_NatureCommunication/ADMIXTURE/20230710_ADMIXTURE_CVerror_mean-runs-major-mode.pdf`
