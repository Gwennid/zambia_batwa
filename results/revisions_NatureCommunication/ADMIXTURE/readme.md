# ADMIXTURE

We reran ADMIXTURE on the Omni1 dataset with the option to output the cross-validation errors (code: `code/ADMIXTURE.sh`).

The output was plotted with pong (code: `code/ADMIXTURE_plot_pong.sh`). The similitude with the ADMIXTURE results included in the manuscript was assessed visually (plots: `results/revisions_NatureCommunication/ADMIXTURE/xx`).

Two types of plots were made to show the cross-validation error:

1. Using the output of pong, we identified the representative run for the major mode of each value of K, and plotted it. The lowest CV error is for K=9 (0.52350). Plot: xx
2. Using the output of pong, we selected the runs belonging to the major mode for each K, and calculated the mean CV error. We plotted it. The lowest mean CV error is for K=9 (0.52349). Plot: xx
