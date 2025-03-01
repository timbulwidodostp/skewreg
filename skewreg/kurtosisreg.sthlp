{smcl}
{* *! version 1.0  20July2020}{...}
{* *! version 2.0  12December2023}{...}
{cmd: help kurtosisreg}
{hline}

{title:Title}

{phang}
{bf: kurtosisreg {hline 2} Kurtosis Regression}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt kurtosisreg} {depvar} [{indepvars}] {ifin} 
   [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt r:eps(#)}}specify number of bootstrap replications; default is {cmd:reps(50)} {p_end}
{synopt :{opt s:eed(#)}}set random seed; default is {cmd:seed(1)} {p_end}

{syntab:Reporting}
{synopt :{opt d:etail}}show detailed results{p_end}
{synopt :{opt g:raph}}graph coefficients and confidence intervals{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt p:redict(string)}}predict conditional kurtosis{p_end}

{synoptline}
INCLUDE help fvvarlist
{p 4 6 2}
{cmd:by} and {cmd: bysort} are allowed; see {help prefix}.
{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:kurtosisreg} performs kurtosis regression for cross-sectional or time-series data as defined in Chen and Xiao (2020), which quantifies the effects of covariates on quantile-based measure of kurtosis of the conditional distribution.  
{cmd:kurtosisreg} calls {cmd: qrprocess} for fast implementation of quantile regressions (Chernozhukov et al., 2020, 2022), which also avoids the potential problem of quantile crossing (Chernozhukov et al., 2010).
The command {cmd: qrprocess} can be installed from SSC by typing "ssc install qrprocess,replace".  
{cmd:kurtosisreg} then use {help margins} to computes average marginal effects (AME), which are parameters of interest. 
For a continuous variable {cmd:x}, AME is defined as marginal effects ({cmd:dy/dx}) averaged over all observations. For discrete variables, marginal effects are defined as discrete changes from the base level. 
For example, for a dummy variable {cmd:x}, AME is defined as {cmd:(y|x=1)-(y|x=0)}, averaged over all observations. Standard errors for AMEs are obtained by the delta method from bootstrap standard errors. 

{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt reps} specify the number of bootstrap replications used for obtaining bootstrap standard errors. The default is {cmd:reps(50)} for fast computation, but {cmd:reps(500)} is recommended for accurate results. 

{phang}
{opt seed} set random seed for reproducible results. The default is {cmd:seed(1)}. 

{dlgtab:Reporting}

{phang}
{opt detail} show detailed results, including simultaneous quantile regression, the numerator and denominator parts of kurtosis regression.

{phang}
{opt graph} graph coefficients of kurtosis regression to visualize average marginal effects and their confidence intervals.

{phang}
{opt level(#)} set confidence level for confidence intervals in both regression results and graph. The default is {cmd:level(95)} for the 95% confidence level. 

{phang}
{opt predict(string)} predict conditional kurtosis for possible later usage.

{marker examples}{...}
{title:Example: fast but trivial}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto,clear}{p_end}

{pstd}Fit a default kurtosis regression{p_end}
{phang2}{cmd:. kurtosisreg price mpg weight foreign}{p_end}

{pstd}Fit a kurtosis regression with detailed output, 90% confidience intervals, coefficient graph, and record predicted conditional kurtosis as a new variable {cmd:kurtosis} {p_end}
{phang2}{cmd:. kurtosisreg price mpg weight foreign, detail level(90) graph predict(kurtosis)}{p_end}

{pstd}Fit a kurtosis regression with random seed 123 and 500 bootstrap replications{p_end}
{phang2}{cmd:. kurtosisreg price mpg weight foreign, seed(123) reps(500)}{p_end}

{pstd}Fit a kurtosis regression in a subsample{p_end}
{phang2}{cmd:. kurtosisreg price mpg weight foreign if rep78==3}{p_end}

{marker examples}{...}
{title:Example: slow but interesting}

{pstd}Setup (1% US census data in 1980 obtained from Angrist et al.(2006). After loading data, use command {help notes} for a detailed description){p_end}
{phang2}{cmd:. sysuse census80.dta, clear}{p_end}

{pstd}Fit a default kurtosis regression (for correct computation of AME, use factor variable (see {help fvvarlist}) {cmd:c.exper#c.exper} so that Stata recognizes it as the square of {cmd:exper}){p_end}
{phang2}{cmd:. kurtosisreg logwk educ black exper c.exper#c.exper}{p_end}

{pstd}Test joint significance of coefficients following the above kurtosis regression{p_end}
{phang2}{cmd:. test educ black exper}{p_end}

{pstd}Fit a kurtosis regression with detailed output, 90% confidience intervals, coefficient graph, and record predicted conditional kurtosis as a new variable {cmd:kurtosis} {p_end}
{phang2}{cmd:. kurtosisreg logwk educ black exper c.exper#c.exper, detail level(90) graph predict(kurtosis)}{p_end}

{pstd}Fit a kurtosis regression with random seed 123 and 500 bootstrap replications{p_end}
{phang2}{cmd:. kurtosisreg logwk educ black exper c.exper#c.exper, seed(123) reps(500)}{p_end}

{pstd}Fit a default kurtosis regression for the black and non-black subsamples respectively via {help bysort}{p_end}
{phang2}{cmd:. bysort black: kurtosisreg logwk educ exper c.exper#c.exper}{p_end}

{marker examples}{...}
{title:Example: time series}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse sp500.dta, clear}{p_end}

{pstd}Since {help qrprocess} doesn't accept time-series operators (see {help tsvarlist}), {cmd:kurtosisreg} doesn't either. So define one-period lagged variable manually{p_end}
{phang2}{cmd:. gen trade_date = _n}{p_end}
{phang2}{cmd:. tsset trade_date}{p_end}
{phang2}{cmd:. gen l1_close = l.close}{p_end}

{pstd}Fit a default kurtosis regression{p_end}
{phang2}{cmd:. kurtosisreg close l1_close}{p_end}

{pstd}Fit a kurtosis regression with detailed output, 90% confidience intervals, coefficient graph, and record predicted conditional kurtosis as a new variable {cmd:kurtosis} {p_end}
{phang2}{cmd:. kurtosisreg close l1_close, detail level(90) graph predict(kurtosis)}{p_end}

{pstd}Fit a kurtosis regression with random seed 123 and 500 bootstrap replications{p_end}
{phang2}{cmd:. kurtosisreg close l1_close, seed(123) reps(500)}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:kurtosisreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(reps)}}number of bootstrap replications{p_end}
{synopt:{cmd:e(seed)}}random seed number{p_end}
{synopt:{cmd:e(q1)}}quantile index of the first quantile regression{p_end}
{synopt:{cmd:e(q2)}}quantile index of the second quantile regression{p_end}
{synopt:{cmd:e(q3)}}quantile index of the third quantile regression{p_end}
{synopt:{cmd:e(q4)}}quantile index of the fourth quantile regression{p_end}
{synopt:{cmd:e(q5)}}quantile index of the fifth quantile regression{p_end}
{synopt:{cmd:e(q6)}}quantile index of the sixth quantile regression{p_end}
{synopt:{cmd:e(pr_q1)}}pseudo R2 of the first quantile regression{p_end}
{synopt:{cmd:e(pr_q2)}}pseudo R2 of the second quantile regression{p_end}
{synopt:{cmd:e(pr_q3)}}pseudo R2 of the third quantile regression{p_end}
{synopt:{cmd:e(pr_q4)}}pseudo R2 of the fourth quantile regression{p_end}
{synopt:{cmd:e(pr_q5)}}pseudo R2 of the fifth quantile regression{p_end}
{synopt:{cmd:e(pr_q6)}}pseudo R2 of the sixth quantile regression{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(vcetype)}}Delta-method{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(cmd)}}{cmd:kurtosisreg}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(depvar)}}Kurtosis{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector, i.e. average marginal effects{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}

{marker author}{...}
{title:Author}

{phang}
Qiang Chen, School of Economics, Shandong University, P. R. China{p_end}
    qiang2chen2@126.com
    {browse "www.econometrics-stata.com"}       

{marker references}{...}
{title:References}

{marker ACF2006}{...}
{phang}
Angrist, Joshua, Victor Chernozhukov and Iván Fernández-Val, 2006.{browse "https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1468-0262.2006.00671.x": Quantile Regression under Misspecification, with an Application to the U.S. Wage Structure}. 
{it:Econometrica}, 74(2), 539-563. 

{marker CFG2010}{...}
{phang}
Chernozhukov, Victor, Iván Fernández-Val and Alfred Galichon, 2010. {browse "https://onlinelibrary.wiley.com/doi/abs/10.3982/ECTA7880":Quantile and Probability Curves without Crossing}. 
{it:Econometrica}, 78, 1093-1125. 

{marker CFM2020}{...}
{phang}
Chernozhukov, Victor, Iván Fernández-Val and Blaise Melly, 2020. Quantile and Distribution Regression in Stata: Algorithms, Pointwise and
Functional Inference. {it:Working paper}. 

{marker CFM2022}{...}
{phang}
Chernozhukov, Victor, Iván Fernández-Val and Blaise Melly, 2022. {browse "https://link.springer.com/article/10.1007/s00181-020-01898-0": Fast Algorithms for the Quantile Regression Process}. 
{it:Empirical Economics}, 62,7-33. 

{marker CX2023}{...}
{phang}
Chen, Qiang, and Zhijie Xiao, 2023, "Spread Regression, Skewness Regression and Kurtosis Regression with an Application to the U.S. Wage Structure," {it:Journal of Applied Econometrics}, revise and resubmit.{p_end}

