*Coding Sample Pre-doctoral Position

cd "/Users/edwinleandry/Documents/EconometricsData_HWs"

*q6
use wagepan.dta

*part b
*generating interaction variables(can be made cleaner)
gen d81educ = d81*educ
gen d82educ = d82*educ
gen d83educ = d83*educ
gen d84educ = d84*educ
gen d85educ = d85*educ
gen d86educ = d86*educ
gen d87educ = d87*educ
xtreg lwage educ union d81-d87 d81educ-d87educ, fe robust

*Testing whether return on educ changed over time
testnl (_b[d81educ] = _b[d82educ] = _b[d83educ] = _b[d84educ] = _b[d85educ] = _b[d86educ] = _b[d87educ] = 0)

*part c
gen d81union = d81*union
gen d82union = d82*union
gen d83union = d83*union
gen d84union = d84*union
gen d85union = d85*union
gen d86union = d86*union
gen d87union = d87*union
xtreg lwage educ union d81-d87 d81educ-d87educ d81union-d87union, fe robust

*Testing whether difference between 1980 and 1987 effect is statistically significant
testnl (_b[union] - _b[d87union] = 0)

*part d
*Testing whether union effect changed over time
testnl (_b[d81union] = _b[d82union] = _b[d83union] = _b[d84union] = _b[d85union] = _b[d86union] = _b[d87union] = 0)


*q7
use loanapp.dta

*part a
*Linear Prob model
reg approve white, robust

*Estimated approval rate and se for white 
predict approve_phat
predict approve_phat_se, stdp

*Probit model
probit approve white, robust

*Estimated approval rate and se for white 
predictnl approve_probit = normal(xb(#1)), se(approve_probit_se)

*part b
reg approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr, robust
probit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr, robust

*part iii
*Partial effect at average values
dprobit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr, robust

*Average partial effect
margins, dydx(white)

*part iv
margins, dydx(obrat)

*part v
*Average predicted approval probs
margins, at(obrat = (10 20 30 40 50))

*Average parital effects
margins, dydx(obrat) at (obrat = (10 20 30 40 50))

*part c
probit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr, robust

*Testing whether effect from vars with z-stats < 2 is = 0
testnl (_b[hrat] = _b[male] = _b[dep] = _b[sch] = _b[cosign] = _b[mortlat1] = _b[mortlat2] = 0)


*q8
use married_bmi_sample.dta
xtset hhid male

*part a
*Pooled OLS
reg bmi male educ age agesq smoke logfaminc withkid, robust

*part b
predict bmi_hat
predict u_hat, resid
gen u_hat_wife = u_hat[_n-1] if hhid==hhid[_n-1]

*testing whether residuals of husband and wife are correlated
pwcorr u_hat u_hat_wife, sig star(.05)

*part c
*Pooled OLS with clustered errors
reg bmi male educ age agesq smoke logfaminc withkid, cluster(hhid)

*part d
*Fixed effect model
xtreg bmi male educ age agesq smoke logfaminc withkid, fe robust
