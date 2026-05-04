
/* _____________________________________________________________________________

	INSTRUMENTED MLOGIT ANALYSIS
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Make a program to save observation numbers, unique individ, and r2 in the tables
cap program drop iv_table_details
program define iv_table_details
	estat overid
	estadd scalar pval = r(J_p)
	estadd scalar j = r(J)
	estadd scalar tstat = _b[xb:rel_`1']/_se[xb:rel_`1']
end


* ---------------------------------------------- *
* 		IV Tests
* ---------------------------------------------- *

* Open data and clean
use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
keep if inlist(treatment,"main","cs")

qui {
	* Get relative emotions
	foreach emotion in guilt pride finan fair unfair happy satis {
		gen rel_`emotion' = `emotion'_p1-`emotion'_p0
	}
	* Reshape
	reshape long guilt pride finan fair unfair happy satis, ///
		i(mturkid choice_set part present) j(prosocial) string
	replace prosocial="1" if prosocial=="_p1"
	replace prosocial="0" if prosocial=="_p0"
	replace prosocial="2" if prosocial=="_p2"
	destring prosocial, force replace
	
	* Drop choices with no data
	drop if guilt==. 
}

* Run all the overid tests
local instruments rel_guilt rel_pride rel_finan rel_fair rel_unfair	
foreach e in guilt pride finan fair unfair {

	* Testing just happiness
	gmm (part1_choice - invlogit({b0} + {xb:rel_`e' rel_happy})) ///
		if part==1 & inlist(treatment,"main","cs"), vce(cluster mturkid) ///
		instruments(rel_happy `instruments') 
	iv_table_details `e'
	eststo ivlogit_`e'_happy
	
	* Testing just satisfaction
	gmm (part1_choice - invlogit({b0} + {xb:rel_`e' rel_satis})) ///
		if part==1 & inlist(treatment,"main","cs"), vce(cluster mturkid) ///
		instruments(rel_satis `instruments') 
	iv_table_details `e'
	eststo ivlogit_`e'_satis
	
}

* Test for just happiness
esttab ivlogit_guilt_happy ivlogit_pride_happy ivlogit_finan_happy ///
	ivlogit_fair_happy ivlogit_unfair_happy using "$output_dir/ivlogit_happy.tex", ///
	replace drop(b0:_cons xb:rel_happy xb:rel_guilt xb:rel_pride xb:rel_finan ///
	xb:rel_fair xb:rel_unfair) $tablefit ///
	collabels(none) eqlabels(none) noobs nonote booktabs label  ///
	mlabels("\shortstack{IV Logit\\Choosing More Equitably on\\Happiness and Guilt}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Happiness and Pride}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Happiness and Finan.}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Happiness and Fair.}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Happiness and Unfair.}") ///
	scalars("tstat T-Stat for Additional CSA" "j Hansen's J chi2" "pval Hansen's J p-value") 
	
	
* Test for just satisfaction
esttab ivlogit_guilt_satis ivlogit_pride_satis ivlogit_finan_satis ///
	ivlogit_fair_satis ivlogit_unfair_satis using "$output_dir/ivlogit_satis.tex", ///
	replace drop(b0:_cons xb:rel_satis xb:rel_guilt xb:rel_pride xb:rel_finan ///
	xb:rel_fair xb:rel_unfair) $tablefit ///
	collabels(none) eqlabels(none) noobs nonote booktabs label  ///
	mlabels("\shortstack{IV Logit\\Choosing More Equitably on\\Satisfaction and Guilt}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Satisfaction and Pride}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Satisfaction and Finan.}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Satisfaction and Fair.}" ///
	"\shortstack{IV Logit\\Choosing More Equitably on\\Satisfaction and Unfair.}") ///
	scalars("tstat T-Stat for Additional CSA" "j Hansen's J chi2" "pval Hansen's J p-value") 














