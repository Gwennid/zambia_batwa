# f4 ratio test

These are results of the f4 ratio to test admixture from the Batwa from Uganda and the Sabue from Ethiopia (code: `code/f4ratio.sh`).

The outputs were modified manually to include only relevant columns for plotting:

```
tail -n 16 logfile.20230917_eHGadmixture-Sabue | head -15 | tr -s ' ' | cut -f5,10,12,13,14 -d" " > tmp
cat header tmp | tr ' ' \\t > f4ratio_20230917_eHGadmixture_Sabue_anc3apes
rm tmp
```

The resulting files are `results/revisions_NatureCommunication/f4ratio/f4ratio_*_anc3apes`.

The ratio were plotted with R (code: `main/code/plot_f4ratio.R`). The resulting figure is `main/results/revisions_NatureCommunication/f4ratio/20230710_f4ratio_test_rRHG-Batwa_eHG-Sabue_ancestry_in15pop20230703.pdf`.

Correlations between estimates made with different source populations were calculated in `main/code/plot_f4ratio.R`.

The estimated admixture fractions for the five Zambian populations were written out in `main/code/plot_f4ratio.R`.
