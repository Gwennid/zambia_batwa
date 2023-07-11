# Projected PCA

We reran the projected PCA with the Batwa from Uganda instead of the Baka from Cameroon as representative of the RHG (code: `main/code/projected_PCA.sh`). The results were plotted with R (code: `main/code/plot_projected_PCA.R`), to obtain a figure similar to the figure 1C in the manuscript, as well as the plots for PC1 to PC6.

We noticed that one of the Batwa samples is an outlier (see in this folder `zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_projected_PC1to6.pdf`, outlier on PC2, PC3 and PC4). We removed the sample and performed the projected PCA again. The result is very similar to what we observed with the Baka as the RHG population (see in this folder `zbatwa10_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_YRI_Batwa-Uganda_Juhoansi_B_Z_ZambiaBantusp_minus-Batwa04_projected_PC1PC2.pdf`).
