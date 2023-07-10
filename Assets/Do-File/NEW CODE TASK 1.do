* Summarise some variables
* pooled data
clear 
use "C:\Users\tp1679z\OneDrive - University of Greenwich\Desktop\Data - Applied Economectris\Wage_at_work_panel.dta"
** Descriptive statistics
xtset idcode

generate age2 = age^2

*Information between and within individuals (idcode)
xtsum ln_wage age age2 tenure union ttl_exp nev_mar south



//--------------------------------------------- Question 1-a ------------------------------------------------// 


*** Chossing between estimators: Pooled_OLS, FE and RE


quietly reg ln_wage age age2 tenure union ttl_exp 
estimates store Pooled_OLS

quietly xtreg ln_wage age age2 tenure union ttl_exp, fe
estimates store FE

quietly xtreg ln_wage age age2 tenure union ttl_exp, re
estimates store RE

**Tabulate
estout Pooled_OLS FE RE, cells(b(star fmt(3)) se(par fmt(3))) /// 
starlevels(* 0.10 ** 0.05 *** 0.01) stats (N k df_m ll aic bic rmse r2_w r2_b r2_o) varwidth(25) modelwidth(10)


* Verifying for equality of the intercepts after LSDV
quietly reg ln_wage i.idcode age age2 c_city tenure union ttl_exp if idcode<=10
test 1.idcode = 2.idcode = 3.idcode = 4.id = 5.idcode = 6.idcode = 7.idcode = 9.idcode = 10.idcode

*  F =9.83
*  P-vlue = 0.0000
* we reject the null hipotesys that there is no difference between individuals. so we should not run the regression without controlling for idcode, meaning, we can discard the Pooled OLS estimator.
* Pooled OLS assumes that unobserved characteristics of all individuals are the same


*Chossing between FE and RE
quietly xtreg ln_wage age age2 tenure union ttl_exp, fe
estimates store FE

quietly xtreg ln_wage age age2 tenure union ttl_exp, re
estimates store RE

**Tabulate
estout FE RE, cells(b(star fmt(3)) se(par fmt(3))) /// 
starlevels(* 0.10 ** 0.05 *** 0.01) stats (N k df_m ll aic bic rmse r2_w r2_b r2_o) varwidth(25) modelwidth(10)


hausman FE RE, sigmamore
*P-vlue less the 5% meaning that FE is preffered

* Using cluster

quietly xtreg ln_wage age age2 tenure union ttl_exp,  vce(cluster idcode) fe
estimates store FE

quietly xtreg ln_wage age age2 tenure union ttl_exp,  vce(cluster idcode) fe
estimates store FE_Rob

**Tabulate
estout FE FE_Rob, cells(b(star fmt(3)) se(par fmt(3))) /// 
starlevels(* 0.10 ** 0.05 *** 0.01) stats (N k df_m ll aic bic rmse r2_w r2_b r2_o) varwidth(25) modelwidth(10)



* Controlling for time trend
quietly xtreg ln_wage age age2 tenure union ttl_exp,  fe
estimates store FE_NTD

quietly xtreg ln_wage i.year age age2 tenure union ttl_exp, fe
estimates store FE_WTD

**Tabulate
estout FE_NTD FE_WTD, cells(b(star fmt(3)) se(par fmt(3))) /// 
starlevels(* 0.10 ** 0.05 *** 0.01) stats (N k df_m ll aic bic rmse r2_w r2_b r2_o) varwidth(25) modelwidth(10)

** Negative coefficient: A negative coefficient for an independent variable means that a decrease in the value of that independent variable is associated with an increase in the value of the dependent variable, holding constant all other factors that are unique to each entity in the panel. This indicates a negative association between the independent and dependent variables within each entity in the panel.


//--------------------------------------- Question 1-b -----------------------------------------------------//

*Test for endogeneity

xtivreg ln_wage age age2 (tenure = nev_mar south) union ttl_exp, fe
estimate store FE_IV

xtivreg ln_wage age age2 (tenure = nev_mar south) union ttl_exp, re
estimate store RE_IV

estout FE_IV RE_IV, cells(b(star fmt(3)) se(par fmt(3))) /// 
starlevels(* 0.10 ** 0.05 *** 0.01) stats (N k df_m ll aic bic rmse r2_w r2_b r2_o) varwidth(25) modelwidth(10)


** Hausman Test

hausman FE_IV RE_IV,
*P-vlue less the 5% meaning that FE is preffered


** Explain the IV and test the validity
 
ivreg2 ln_wage age age2 (tenure = nev_mar south) union ttl_exp, 

overid



// -------------------- Question 1-d ---------------------//

set more off

quietly xtreg ln_wage age age2 tenure union ttl_exp, fe
estimates store FE

quietly xtivreg ln_wage age age2 (tenure = nev_mar south) union ttl_exp, fe
estimates store FE_IV

estout FE FE_IV, cells(b(star fmt(3)) se(par fmt(3))) /// 
starlevels(* 0.10 ** 0.05 *** 0.01) stats (N k df_m ll aic bic rmse r2_w r2_b r2_o) varwidth(25) modelwidth(10)

hausman FE FE_IV

** End of questions 1- d

//================================================== End of Task 1===============================//