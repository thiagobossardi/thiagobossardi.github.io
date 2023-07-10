tsset year, yearly

//================================= Question 2-a =====================================//

sum

* Step 1: plot the data

line new_england mideast great_lakes plains southeast southwest rocky_mountain far_west year
* Upward trending

line d.new_england d.mideast d.great_lakes d.plains d.southeast d.southwest d.rocky_mountain d.far_west year
* Upward trending at first difference as well

* Step 2: Check lag order 
* Obtain lag-order selection statistics  
* It is to indentify the correct number of lags we need to include in the models to avoid serial correlation
varsoc ln_ne ln_me ln_gl ln_pl ln_se ln_sw ln_rm ln_fw
* resutlt: 4 lags 

* Step 3: Formal tests of stationarity

* Test for unit root
* ADF

dfuller ln_ne, lag(4) trend

dfuller ln_me, lag(4) trend

dfuller ln_gl, lag(4) trend

dfuller ln_pl , lag(4) trend

dfuller ln_se , lag(4) trend

dfuller ln_sw , lag(4) trend

dfuller ln_rm , lag(4) trend

dfuller ln_fw, lag(4) trend

* Non-stationarity not rejected 

* First Difference ADF

dfuller d.ln_ne, lag(4) trend

dfuller d.ln_me, lag(4) trend

dfuller d.ln_gl, lag(4) trend

dfuller d.ln_pl , lag(4) trend

dfuller d.ln_se , lag(4) trend

dfuller d.ln_sw , lag(4) trend

dfuller d.ln_rm , lag(4) trend

dfuller d.ln_fw, lag(4) trend


* Without lag restriction

dfuller ln_ne, trend

dfuller ln_me, trend

dfuller ln_gl, trend

dfuller ln_pl , trend

dfuller ln_se , trend

dfuller ln_sw , trend

dfuller ln_rm , trend

dfuller ln_fw, trend
* Even stronger not rejection!

* Check Philip-Peron

pperron ln_ne, lag(4) trend

pperron ln_me, lag(4) trend

pperron ln_gl, lag(4) trend

pperron ln_pl , lag(4) trend

pperron ln_se , lag(4) trend

pperron ln_sw , lag(4) trend

pperron ln_rm , lag(4) trend

pperron ln_fw, lag(4) trend

* Non-stationarity not rejected 


* Check Philip-Peron at First Difference

pperron d.ln_ne, lag(4) trend

pperron d.ln_me, lag(4) trend

pperron d.ln_gl, lag(4) trend

pperron d.ln_pl , lag(4) trend

pperron d.ln_se , lag(4) trend

pperron d.ln_sw , lag(4) trend

pperron d.ln_rm , lag(4) trend

pperron d.ln_fw, lag(4) trend

* Check DF-GLS

dfgls ln_ne, trend

dfgls ln_me, trend

dfgls ln_gl, trend

dfgls ln_pl, trend

dfgls ln_se, trend

dfgls ln_sw, trend

dfgls ln_rm, trend

dfgls ln_fw, trend

* Non-stationarioty is not rejected from lags 5 onwards
* Checks up to 13 lags
* Takes account heteroskedasticity

/* NOTE !!!
. Elliott, Rothenberg, and Stock and later studies have shown that DFGLS has significantly
greater power than the previous versions of the augmented Dickey–Fuller test.
*/


* Step 4: Johansen cointegration test

vecrank ln_ne ln_me ln_gl ln_pl ln_se ln_sw ln_rm ln_fw, lags(4)

* Step 5: Cheking for cointegration with Vector Error Correction Model (VECM)

vec ln_ne ln_me ln_gl ln_pl ln_se ln_sw ln_rm ln_fw, lags(4)


//================================= Question 2-b =====================================//

* Step 6: POST-ESTIMATION Checks 
* 6.1: Check the stationarity of the cointegrating equation
* Predict co-integrating equation
quietly vec ln_ne ln_me ln_gl ln_pl ln_se ln_sw ln_rm ln_fw, lags(4)
predict ce_uhat, ce
* graph and see if mean-reversing
line ce_uhat year


* 6.2: Check whether we have correctly specified the number of cointegrating equations
vecstable, graph
* Correcltly specified. 
/*  The companion matrix of a VECM with K endogenous
variables and r cointegrating equations has K −r unit eigenvalues. 
The model is correctly specified since remaining eigenvalues are less than one.
*/

* 6.3: Test for serial correlation in the residual
veclmar, mlag(4)
* the null of NO serial correlation cannot be rejected.



/*
the I(1) variables modeled in a
cointegrating VECM are not mean reverting, and the unit moduli in the companion matrix imply that
the effects of some shocks will not die out over time.
*/

//================================= Question 2-c =====================================//


* Step 8: Create average incomes and relative incomes

bysort year: gen av_income_per_year = (new_england + mideast + great_lakes + plains + southeast + southwest + rocky_mountain + far_west)/8

gen ln_av_income = ln(av_income_per_year)

gen rel_inc_new_england = ln_ne / ln_av_income

gen rel_inc_mideast = ln_me / ln_av_income

gen rel_inc_great_lakes = ln_gl / ln_av_income

gen rel_inc_plains = ln_pl / ln_av_income

gen rel_inc_southeast = ln_se / ln_av_income

gen rel_inc_southwest = ln_sw / ln_av_income

gen rel_inc_rocky_mountain = ln_rm / ln_av_income

gen rel_inc_far_west = ln_fw / ln_av_income

*Dickey–Fuller Generalized Least Squares

dfgls rel_inc_new_england

dfgls rel_inc_mideast

dfgls rel_inc_great_lakes

dfgls rel_inc_plains

dfgls rel_inc_southeast

dfgls rel_inc_southwest

dfgls rel_inc_rocky_mountain

dfgls rel_inc_far_west

/*
Non-stationarity is rejected in all lags
Hence, indicating that the series may contain a unit root
Therefore, we cannnot reject the null hypotesis of non-stationarity
We conclude that the series are non-stationary
*/


* Johansen cointegration test

vecrank rel_inc_new_england rel_inc_mideast rel_inc_great_lakes rel_inc_plains rel_inc_southeast rel_inc_southwest rel_inc_rocky_mountain rel_inc_far_west, trend (trend) 


/*
trend (trend): a linear trend in the cointegration equation implies that the long-term relationship between the variables is a linear function of time. In other words, the relationship between the varibales chenges over time but in a linear fashion.
*/

* Plot the data

tsline rel_inc_new_england rel_inc_mideast rel_inc_great_lakes rel_inc_plains rel_inc_southeast rel_inc_southwest rel_inc_rocky_mountain rel_inc_far_west 
