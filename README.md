# HarvardMLProject

Required RMSE for full credit: RMSE < 0.86490
RMSE obtained for the project: <b>0.8644501</b>

NOTE: The data set is very large, so various measures were taken to speed up the loading.

In the .rmd file, the data has been split with the provided code and loaded into separate .RData

```
edx <- readRDS("movielens.RData")
validation <- readRDS("movievalidation.RData")
set.seed(1, sample.kind="Rounding")
```

Likewise, results that take time to calculate have been loaded already.

```
rmses <- readRDS("rmses.RData")
lambdas <- readRDS("lambdas.RData")
```


The following are the R codes used:

<b>LoadData.r</b> = Code provided in the course to load the dataset. Takes time to load
<b>DataAnalysis.r</b> = Code used for data analysis, consistent with the R Markdown File
<b>MovieUserGenreRegularization</b> = Code used to perform regularization on the L(M,U,G) function. Takes time to execute, thus saved in a separate file.

