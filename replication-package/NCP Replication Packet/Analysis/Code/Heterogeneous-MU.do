/* _____________________________________________________________________________

	Test for Heterogeneous MU 
_____________________________________________________________________________ */

global emotions 		guilt pride finan fair unfair happy satis
global lu_calc 			"guilt*_b[rel_guilt]+pride*_b[rel_pride]+finan*_b[rel_finan]+fair*_b[rel_fair]+unfair*_b[rel_unfair]+happy*_b[rel_happy]+satis*_b[rel_satis]"


* ------------------------------- *
* 	Programs
* ------------------------------- *

cap program drop prog_var
program define prog_var, rclass
	preserve
	* Get LU
	logit part1_choice rel_* if part==1, r nocons
	gen lu=$lu_calc	
	
	* Get mixed coef
	mixed lu payoff if treatment=="main" & inlist(choice_set,4,5,6,7) || newid: payoff
	matrix x = e(b)
	return scalar mixed = x[1,1]
	return scalar mixed_var = exp(x[1, colnumb(x, "lns1_1_1:_cons")])^2
	
	reg lu payoff if inlist(choice_set,4,5,6,7) & treatment=="main"
	return scalar payoff = _b[payoff]
	restore
end


* Run estimates ________________________________________________________________

* Open data
use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
keep if inlist(treatment,"main","cs")

* Clean
qui {

	* Make xtset
	egen id=group(mturkid)
	xtset id

	* Relative emotions 
	foreach emotion in $emotions {
		gen rel_`emotion' = `emotion'_p1-`emotion'_p0
	}

	* Reshape
	reshape long $emotions, ///
		i(mturkid choice_set part present) j(prosocial) string
	replace prosocial="1" if prosocial=="_p1"
	replace prosocial="0" if prosocial=="_p0"
	replace prosocial="2" if prosocial=="_p2"
	destring prosocial, force replace
	
	* Drop choices with no data
	drop if guilt==. 

	* Create a payoff variable for choice set 4, 5, 6, and 7
	gen payoff=4 if choice_set==4 & part==2 & prosocial==0
	replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
	replace payoff=3 if choice_set==6 & part==2 & prosocial==0
	replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
	
	* Drop choices with no data
	drop if guilt==.
}	

* Get est and CI of regular and random effects marginal utility
set seed 123
bootstrap payoff=r(payoff) mixed=r(mixed) mixed_var=r(mixed_var), ///
	reps(1000) seed(12345) cluster(mturkid) nodrop idcluster(newid):prog_var
estat bootstrap, all


mat b = e(b)
local mud=round(b[1,1],0.01)
local mud: di %9.2f `mud' 
latex_write mud `mud' numbers_pipe
local mixedb=round(b[1,2],0.01)
local mixedb: di %9.2f `mixedb' 
latex_write mixedb `mixedb' numbers_pipe
local mixed_var=round(b[1,3],0.01)
local mixed: di %9.2f `mixed_var'
latex_write mixed `mixed' numbers_pipe

mat c = e(ci_percentile)
local mudlo=round(c[1,1],0.01)
local mudlo: di %9.2f `mudlo' 
latex_write mudlo `mudlo' numbers_pipe

local mudhi=round(c[2,1],0.01)
local mudhi: di %9.2f `mudhi' 
latex_write mudhi `mudhi' numbers_pipe

local mixedblo=round(c[1,2],0.01)
local mixedblo: di %9.2f `mixedblo' 
latex_write mixedblo `mixedblo' numbers_pipe

local mixedbhi=round(c[2,2],0.01)
local mixedbhi: di %9.2f `mixedbhi' 
latex_write mixedbhi `mixedbhi' numbers_pipe

local mixedlo=round(c[1,3],0.01)
local mixedlo: di %9.2f `mixedlo'
latex_write mixedlo `mixedlo' numbers_pipe

local mixedhi=round(c[2,3],0.01)
local mixedhi: di %9.2f `mixedhi'
latex_write mixedhi `mixedhi' numbers_pipe
