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

Likewise, results that take time to calculate have been computed beforehand and re-running the .rmd file loads them already.<br>

```
rmses <- readRDS("rmses.RData")
lambdas <- readRDS("lambdas.RData")
```

<h2>Running the .RMD code</h1>

If you wish to run the code .rmd code AS IS, you may download the preloaded values here:<br>

edx = https://drive.google.com/file/d/1yvlkdKuIO-xSiyAQ9GddrWy_kWnBwKtg/view?usp=sharing<br>
validation = https://github.com/r2rokid9/HarvardMLProject/blob/master/PreloadedData/movievalidation.RData<br>
lambdas = https://github.com/r2rokid9/HarvardMLProject/blob/master/PreloadedData/lambdas.RData<br>
rmses = https://github.com/r2rokid9/HarvardMLProject/blob/master/PreloadedData/rmses.RData<br>
<br>

<h3>OR</h3>
<br>
<br>
change the 'eval = FALSE' to 'eval = TRUE'<br>
<br>
Lines <b>65, 102, 501</b><br>
<br>
Line 65:<br>

```
r setup, echo = TRUE, message = FALSE, warning = FALSE, eval = FALSE} #change 'eval = FALSE' to 'eval = TRUE'
```

Line 102:<br>

```
r setup_2, echo = TRUE, message = FALSE, warning = FALSE, eval = FALSE} #change 'eval = FALSE' to 'eval = TRUE'
```

Line 501:<br>

```
r regularization, echo = TRUE, message = FALSE, warning = FALSE, eval} = FALSE #change 'eval = FALSE' to 'eval = TRUE'
```

Then Change Line 34 to add `eval = FALSE` at the end of the options:<br>

```
r load, echo = FALSE,message = FALSE, warning = FALSE,eval = FALSE}
```

<br>
<p>
  
<h2>R Codes</h2>
The following are the R codes used:<br><br>
<p>
<b>LoadData.r</b> = Code provided in the course to load the dataset. Takes time to load<br>
<br>
<b>DataAnalysis.r</b> = Code used for data analysis, consistent with the R Markdown File, but the regularization on LM(M,U,G) function is commented out and placed on a separate file called <b>MovieUserGenreRegularization</b><br>
<br>
<b>MovieUserGenreRegularization</b> = Code used to perform regularization on the LM(M,U,G) function. Takes time to execute, thus saved in a separate file.<br>
</p>
