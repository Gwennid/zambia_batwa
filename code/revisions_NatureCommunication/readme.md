This folder contains code related to the revisions following the initial submission to Nature Communications.

## find_graph

To compare the fit of graphs with increasing number of admixture event, the following was performed in R:

```
R
load("20230914/graphs.bangweulu.RData")
fits = qpgraph_resample_multi(f2, list(best.M1$graph[[1]], best.M2$graph[[1]]), nboot = 1000)
compare_fits(fits[[1]]$score_test, fits[[2]]$score_test)
```

The value of $p\\_emp$ indicates whether the more complex model is a significantly better fit.
