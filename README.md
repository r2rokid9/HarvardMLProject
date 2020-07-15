# HarvardMLProject

Required RMSE for full credit: RMSE < 0.86490<br>
RMSE obtained for the project: <b>0.8644501</b><br>
<br>
NOTE: The data set is very large, so various measures were taken to speed up the loading.<br>
<br>
In the .rmd file, the data has been split with the provided code and loaded into separate .RData<br>

```
edx <- readRDS("movielens.RData")
validation <- readRDS("movievalidation.RData")
set.seed(1, sample.kind="Rounding")
```

Likewise, results that take time to calculate have been loaded already.<br>

```
rmses <- readRDS("rmses.RData")
lambdas <- readRDS("lambdas.RData")
```


The following are the R codes used:<br>
<p>
<b>LoadData.r</b> = Code provided in the course to load the dataset. Takes time to load<br>
<b>DataAnalysis.r</b> = Code used for data analysis, consistent with the R Markdown File<br>
<b>MovieUserGenreRegularization</b> = Code used to perform regularization on the L(M,U,G) function. Takes time to execute, thus saved in a separate file.<br>
</p>
