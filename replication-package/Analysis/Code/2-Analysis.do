/* _____________________________________________________________________________

	CSA ANALYSIS
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

global rel_label_tex	varlabels(rel_guilt "$\Delta$ Guilt" rel_pride "$\Delta$ Pride" ///
						rel_finan "$\Delta$ Finan. Satis." rel_fair "$\Delta$ Fairness" ///
						rel_unfair "$\Delta$ Unfairness" rel_happy "$\Delta$ Happiness" ///
						rel_satis "$\Delta$ Satisfaction") 
global table_order 		order(rel_guilt rel_pride rel_finan rel_fair rel_unfair rel_happy rel_satis)
global emotions 		guilt pride finan fair unfair happy satis

* Instrumented logit program, where the instrument is the lagged relative CSA
cap program drop iv_logit
program define iv_logit, rclass
	preserve
	
	* First stage + control function
	foreach e in $emotions {
		reg rel_`e' lag_rel_`e' if part==1 & inlist(treatment,"main","cs")			
		predict `e'_resid, residual   
		predict `e'_pred
	}
	
	* Second stage
	logit part1_choice rel_* *_resid if part==1 & inlist(treatment,"main","cs"), ///
		vce(cluster mturkid) nocons
	margins, dydx(*) 
	
	* Get marginal effects coefficients
	matrix b=r(b)
	return scalar rel_guilt=b[1,1]
	return scalar rel_pride=b[1,2]
	return scalar rel_finan=b[1,3]
	return scalar rel_fair=b[1,4]
	return scalar rel_unfair=b[1,5]
	return scalar rel_happy=b[1,6]
	return scalar rel_satis=b[1,7]
	
	restore
end

* Instrumented logit program, same as above but log odds
cap program drop iv_logit_lo
program define iv_logit_lo, rclass
	preserve
	
	* First stage + control function
	foreach e in $emotions {
		reg rel_`e' lag_rel_`e' if part==1 & inlist(treatment,"main","cs")			
		predict `e'_resid, residual   
		predict `e'_pred
	}
	
	* Second stage
	logit part1_choice rel_* *_resid if part==1 & inlist(treatment,"main","cs"), ///
		vce(cluster mturkid) nocons
	
	* Get coefficients
	return scalar rel_guilt=_b[rel_guilt]
	return scalar rel_pride=_b[rel_pride]
	return scalar rel_finan=_b[rel_finan]
	return scalar rel_fair=_b[rel_fair]
	return scalar rel_unfair=_b[rel_unfair]
	return scalar rel_happy=_b[rel_happy]
	return scalar rel_satis=_b[rel_satis]
	
	restore
end

* Instrumented logit program, same as above-above but with a constant
cap program drop iv_logit_constant
program define iv_logit_constant, rclass
	preserve
	
	* First stage + control function
	foreach e in $emotions {
		reg rel_`e' lag_rel_`e' if part==1 & inlist(treatment,"main","cs")			
		predict `e'_resid, residual   
		predict `e'_pred
	}
	
	* Second stage
	logit part1_choice rel_* *_resid if part==1 & inlist(treatment,"main","cs"), ///
		vce(cluster mturkid) 
	
	* Get coefficients
	return scalar rel_guilt=_b[rel_guilt]
	return scalar rel_pride=_b[rel_pride]
	return scalar rel_finan=_b[rel_finan]
	return scalar rel_fair=_b[rel_fair]
	return scalar rel_unfair=_b[rel_unfair]
	return scalar rel_happy=_b[rel_happy]
	return scalar rel_satis=_b[rel_satis]
	return scalar cons=_b[_cons]
	
	restore
end

* Non-IV logit
cap program drop rlogit
program define rlogit, rclass
	preserve
	
	* Get CSA weights with logit regression
	logit part1_choice rel_* if part==1 & inlist(treatment,"main","cs"), ///
		vce(cluster mturkid) nocons
		
	* Get coefficients
	return scalar rel_guilt=_b[rel_guilt]
	return scalar rel_pride=_b[rel_pride]
	return scalar rel_finan=_b[rel_finan]
	return scalar rel_fair=_b[rel_fair]
	return scalar rel_unfair=_b[rel_unfair]
	return scalar rel_happy=_b[rel_happy]
	return scalar rel_satis=_b[rel_satis]
	
	restore
end

*  Non-IV logit, with a constant
cap program drop rlogit_cons
program define rlogit_cons, rclass
	preserve
	
	* Get CSA weights with logit regression
	logit part1_choice rel_* if part==1 & inlist(treatment,"main","cs"), ///
		vce(cluster mturkid) 
	
	* Get coefficients
	return scalar rel_guilt=_b[rel_guilt]
	return scalar rel_pride=_b[rel_pride]
	return scalar rel_finan=_b[rel_finan]
	return scalar rel_fair=_b[rel_fair]
	return scalar rel_unfair=_b[rel_unfair]
	return scalar rel_happy=_b[rel_happy]
	return scalar rel_satis=_b[rel_satis]
	return scalar cons=_b[_cons]
	
	restore
end

*  Non-IV logit, no constant and no happy/satis
cap program drop rlogit2
program define rlogit2, rclass
	preserve
	
	* Get CSA weights with logit regression
	logit part1_choice rel_guilt rel_pride rel_finan rel_fair rel_unfair if part==1 & inlist(treatment,"main","cs"), ///
		vce(cluster mturkid) nocons
		
	* Get coefficients
	return scalar rel_guilt=_b[rel_guilt]
	return scalar rel_pride=_b[rel_pride]
	return scalar rel_finan=_b[rel_finan]
	return scalar rel_fair=_b[rel_fair]
	return scalar rel_unfair=_b[rel_unfair]
	
	restore
end

*  Non-IV logit, with constant and no happy/satis
cap program drop rlogit_cons2
program define rlogit_cons2, rclass
	preserve
	
	* Get CSA weights with logit regression
	logit part1_choice rel_guilt rel_pride rel_finan rel_fair rel_unfair if part==1 & inlist(treatment,"main","cs"), ///
		vce(cluster mturkid) 
	
	* Get coefficients
	return scalar rel_guilt=_b[rel_guilt]
	return scalar rel_pride=_b[rel_pride]
	return scalar rel_finan=_b[rel_finan]
	return scalar rel_fair=_b[rel_fair]
	return scalar rel_unfair=_b[rel_unfair]
	return scalar cons=_b[_cons]
	
	restore
end

* Non-IV logit, marginal effects
cap program drop rlogit_me
program define rlogit_me, rclass
	preserve
	
	* Get CSA weights with logit regression
	logit part1_choice rel_* if part==1 & inlist(treatment,"main","cs"), ///
	 vce(cluster mturkid) nocons
	margins, dydx(*) 
	
	* Get coefficients
	matrix b=r(b)
	return scalar rel_guilt=b[1,1]
	return scalar rel_pride=b[1,2]
	return scalar rel_finan=b[1,3]
	return scalar rel_fair=b[1,4]
	return scalar rel_unfair=b[1,5]
	return scalar rel_happy=b[1,6]
	return scalar rel_satis=b[1,7]
	
	restore
end

* Non-IV logit, marginal effects and no happy/satis
cap program drop rlogit_me2
program define rlogit_me2, rclass
	preserve
	
	* Get CSA weights with logit regression
	logit part1_choice rel_guilt rel_pride rel_finan rel_fair rel_unfair ///
		if part==1 & inlist(treatment,"main","cs"), vce(cluster mturkid) nocons
	margins, dydx(*) 
	
	* Get coefficients
	matrix b=r(b)
	return scalar rel_guilt=b[1,1]
	return scalar rel_pride=b[1,2]
	return scalar rel_finan=b[1,3]
	return scalar rel_fair=b[1,4]
	return scalar rel_unfair=b[1,5]
	
	restore
end




* ---------------------------------------------- *
* 		Happiness/Satisfaction Weights
* ---------------------------------------------- *

* Open data
use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
keep if inlist(treatment,"main","cs")

* Make xtset
egen id=group(mturkid)
xtset id

* Relative emotions 
foreach emotion in $emotions {
	gen rel_`emotion' = `emotion'_p1-`emotion'_p0
}


* Regress happiness/satisfaction on other CSAs _________________________________
foreach e in happy satis {
	if "`e'"=="happy" {
		local title Happiness
	}
	if "`e'"=="satis" {
		local title Satisfaction
	}
	
	* Regular OLS of happy/satis on the other 5 CSAs
	reg rel_`e' rel_guilt rel_pride rel_finan rel_fair rel_unfair if part==1, r cluster(mturkid) nocons
	table_details
	eststo model1_`e'
}

* Put happiness and satisfaction model in one table
esttab model1_happy model1_satis ///
	using "$output_dir/reg_happy_satis_main.tex", replace keep(rel*) ///
	eqlabels(none) $tablefit $tableprop ///
	order(rel_guilt rel_pride rel_finan rel_fair rel_unfair) ///
	mlabels("\shortstack{OLS\\ $\Delta$ Happiness}" ///
	"\shortstack{OLS\\ $\Delta$ Satisfaction}" , lhs(Dependent Var.)) ///
	scalars("group N. Participants") ///
	varlabels(rel_guilt "$\Delta$ Guilt" rel_pride "$\Delta$ Pride" ///
	rel_finan "$\Delta$ Finan. Satis." rel_fair "$\Delta$ Fairness" ///
	rel_unfair "$\Delta$ Unfairness") 
eststo clear
	
* Regressions of happiness, satisfaction, and choice on the disaggregated CSAs
* Compare CSA weights on happiness, satisfaction, and choice, normalizing by guilt rating
reg rel_happy rel_guilt rel_pride rel_finan rel_fair rel_unfair if part==1, r cluster(mturkid) nocons
eststo happy: nlcom (_b[rel_guilt]/_b[rel_finan]) (_b[rel_pride]/_b[rel_finan]) ///
	(_b[rel_finan]/_b[rel_finan]) (_b[rel_fair]/_b[rel_finan]) ///
	(_b[rel_unfair]/_b[rel_finan]), post

reg rel_satis rel_guilt rel_pride rel_finan rel_fair rel_unfair if part==1, r cluster(mturkid) nocons
eststo satis: nlcom (_b[rel_guilt]/_b[rel_finan]) (_b[rel_pride]/_b[rel_finan]) ///
	(_b[rel_finan]/_b[rel_finan]) (_b[rel_fair]/_b[rel_finan]) ///
	(_b[rel_unfair]/_b[rel_finan]), post

logit part1_choice rel_guilt rel_pride rel_finan rel_fair rel_unfair if part==1, r cluster(mturkid) nocons
eststo logit: nlcom (_b[rel_guilt]/_b[rel_finan]) (_b[rel_pride]/_b[rel_finan]) ///
	(_b[rel_finan]/_b[rel_finan]) (_b[rel_fair]/_b[rel_finan]) ///
	(_b[rel_unfair]/_b[rel_finan]), post
local group = e(N)/7

* Put into table
esttab happy satis logit using "$output_dir/reg_happy_satis_logit.tex", replace ///
	eqlabels(none)  $tableprop mlabels("\shortstack{OLS\\ $\Delta$ Happiness}" ///
	"\shortstack{OLS\\ $\Delta$ Satisfaction}" ///
	"\shortstack{Logit\\ Choosing More Equitably}", lhs(Dependent Var.)) ///
	varlabels(_nl_1 "$\Delta$ Guilt" _nl_2 "$\Delta$ Pride" ///
	_nl_3 "$\Delta$ Finan. Satis." _nl_4 "$\Delta$ Fairness" ///
	_nl_5 "$\Delta$ Unfairness") ///
	postfoot(`"\midrule"'  `"\multicolumn{1}{l}{N. Participants: `group'}  \\"' `"\bottomrule"' `"\end{tabular}"' `"}"') ///
	prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\adjustbox{max height=\dimexpr\textheight-5.5cm\relax, max width=\textwidth}{"'`"\begin{tabular}{l*{8}{c}}"' `"\toprule"') 
eststo clear



* ---------------------------------------------- *
* 		 Measurement Error
* ---------------------------------------------- *

* Reshape data longer
qui {
	* Reshape long
	reshape long $emotions, ///
		i(mturkid choice_set part present) j(prosocial) string
	replace prosocial="1" if prosocial=="_p1"
	replace prosocial="0" if prosocial=="_p0"
	replace prosocial="2" if prosocial=="_p2"
	destring prosocial, force replace
	
	* Drop choices with no data
	drop if guilt==. | part==2

	* Generate lagged emotions
	sort mturkid part prosocial choice_set
	foreach e in $emotions {
		gen lag_`e'=`e'[_n-1]
		replace lag_`e'=. if choice_set==1
	}
	sort mturkid part prosocial choice_set
	
	* Get differences in lagged emotions
	foreach e in $emotions {
		gen lag_rel_`e'=rel_`e'[_n-1]
		replace lag_rel_`e'=. if choice_set==1
		gen diff_lag_rel_`e'=rel_`e'-lag_rel_`e'
	}
}	

* Check for measurement error by instrumenting using the IV programs above
** Bootstrap SEs using percentiles
bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair) rel_happy=r(rel_happy) ///
	rel_satis=r(rel_satis), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: iv_logit
estat bootstrap, all
eststo iv

* Non-instrumented logit
bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair) rel_happy=r(rel_happy) ///
	rel_satis=r(rel_satis), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: rlogit_me
estat bootstrap, all
eststo logit
logit_table_details

* Non-instrumented logit, excluding happiness and satis
bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: rlogit_me2
estat bootstrap, all
eststo logit2
logit_table_details

* Get counts of participants
preserve
* First stage + control function
foreach e in $emotions {
	reg rel_`e' lag_rel_`e' if part==1 & inlist(treatment,"main","cs")			
	predict `e'_resid, residual   
	predict `e'_pred
	if "`e'"=="unfair" {
			local ivlow : di %4.2g _b[lag_rel_unfair]
			latex_write ivlow `ivlow' numbers_pipe
		}
		if "`e'"=="happy" {
			local ivhigh : di %4.2g _b[lag_rel_happy]
			latex_write ivhigh `ivhigh' numbers_pipe
		}
}

logit part1_choice rel_* *_resid if part==1 & inlist(treatment,"main","cs"), ///
	vce(cluster mturkid) nocons
	ereturn list
local ivgroup=e(N_clust)

logit part1_choice rel_* if part==1 & inlist(treatment,"main","cs"), ///
	 vce(cluster mturkid) nocons
local group=e(N_clust) 
restore	

* Put in table
esttab logit iv logit2 using "$output_dir/ivlogit_part1.tex", /// //logit2
	keep(rel_* ) collabels(none) eqlabels(none) noobs ///
	replace cell(b(star fmt(2)) se(par fmt(2))) star(* 0.1 ** 0.05 *** 0.01) ///
	nonote booktabs label $rel_label_tex  ///
	mlabels("\shortstack{Logit\\Choosing\\More Equitably}" ///
	"\shortstack{IV Logit\\Choosing\\More Equitably}" ///
	"\shortstack{Logit\\Choosing\\More Equitably}") ///
	postfoot(`"\midrule"' `"N. Participants & `group' & `ivgroup' & `group'  \\"' `"\bottomrule \\"' `"\end{tabular} }"') ///
	prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\adjustbox{max height=\dimexpr\textheight-5.5cm\relax, max width=\textwidth}{"'`"\begin{tabular}{l*{8}{c}}"' `"\toprule"') 
eststo clear



* Do same as above but some with a constant term _______________________________
** Bootstrap SEs using percentiles
bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair) rel_happy=r(rel_happy) ///
	rel_satis=r(rel_satis), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: iv_logit_lo
estat bootstrap, all
eststo iv1

bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair) rel_happy=r(rel_happy) ///
	rel_satis=r(rel_satis), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: rlogit
estat bootstrap, all
eststo logit1

bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: rlogit2
estat bootstrap, all
eststo logit12

bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair) rel_happy=r(rel_happy) ///
	rel_satis=r(rel_satis) _cons=r(cons), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: iv_logit_constant
estat bootstrap, all
eststo iv

bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair) rel_happy=r(rel_happy) ///
	rel_satis=r(rel_satis) _cons=r(cons), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: rlogit_cons
estat bootstrap, all
eststo logit

bootstrap rel_guilt=r(rel_guilt) rel_pride=r(rel_pride) rel_finan=r(rel_finan) ///
	rel_fair=r(rel_fair) rel_unfair=r(rel_unfair) _cons=r(cons), reps(1000) seed(123450) cluster(mturkid) ///
	idcluster(newid) nodrop: rlogit_cons2
estat bootstrap, all
eststo logit2
local obs = e(N)
local group = e(N_clust)

* Put in table
esttab logit1 logit iv1 iv logit12 logit2 using "$output_dir/ivlogit_part1_cons.tex", /// //logit2
	keep(rel_* _cons) collabels(none) eqlabels(none) noobs ///
	replace cell(b(star fmt(2)) se(par fmt(2))) star(* 0.1 ** 0.05 *** 0.01) ///
	nonote booktabs label  ///
	mlabels("\shortstack{Logit (no cons)\\Choosing\\More Equitably}" ///
	"\shortstack{Logit (w cons)\\Choosing\\More Equitably}" ///
	"\shortstack{IV Logit (no cons)\\Choosing\\More Equitably}" ///
	"\shortstack{IV Logit (w cons)\\Choosing\\More Equitably}" ///
	"\shortstack{Logit (no cons)\\Choosing\\More Equitably}" ///
	"\shortstack{Logit (w cons)\\Choosing\\More Equitably}") ///
	varlabels(rel_guilt "$\Delta$ Guilt" rel_pride "$\Delta$ Pride" ///
	rel_finan "$\Delta$ Finan. Satis." rel_fair "$\Delta$ Fairness" ///
	rel_unfair "$\Delta$ Unfairness" rel_happy "$\Delta$ Happiness" ///
	rel_satis "$\Delta$ Satisfaction" cons "Constant") ///
	postfoot(`"\midrule"' `"\multicolumn{1}{l}{N. Participants: `group'}  \\"' `"\bottomrule"' `"\end{tabular}"' `"}"') ///
	prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\adjustbox{max height=\dimexpr\textheight-5.5cm\relax, max width=\textwidth}{"'`"\begin{tabular}{l*{8}{c}}"' `"\toprule"') 












































