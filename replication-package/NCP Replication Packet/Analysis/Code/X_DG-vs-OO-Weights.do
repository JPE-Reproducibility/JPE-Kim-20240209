/* _____________________________________________________________________________

	COMPARING DG VS OO WEIGHTS
_____________________________________________________________________________ */


*------------------------------------------------------------*
*	CSA Weights with interaction dummies for whether it was in OO
*------------------------------------------------------------*

* Open data
use "$prepped_data_dir/mturk_all_long_analysis.dta", clear
keep if inlist(treatment,"main","cs")

* Reshape long
reshape long ratingguilt ratingpride ratingfinan ratingfair ratingunfair ///
	ratingsatis ratinghappy, i(mturkid prosocial choice_set present) j(part)
drop if ratingguilt==. 

* Make variable which combines both DG and OO
egen group=group(mturkid choice_set part)
gen choice=(part1_choice==prosocial) if part==1
replace choice=(part3_choice==prosocial) if part==3
gen dummy=part==3

* Interaction terms between CSA and if an OO game
foreach e in finan pride fair unfair guilt happy satis {
	gen `e'_part3=rating`e'*dummy
}

* Logit with DG and OO +  OO dummy interactions
asclogit choice ratingguilt ratingpride ratingfinan ratingfair ///
	ratingunfair ratinghappy ratingsatis guilt_part3 pride_part3 finan_part3 ///
	fair_part3 unfair_part3 happy_part3 satis_part3 if part!=2 & ///
	inlist(treatment,"main","cs"), case(group) alt(prosocial) cluster(mturkid) nocons
logit_table_details
estadd scalar pval = r(p)
eststo mod1

* Place in table
esttab mod1 using "$output_dir/logit_part13_all.tex", ///
	replace noobs nomtitle label booktabs nonote collabels(none) noomitted ///
	eqlabels(none) cell(b(fmt(3) star) se(par fmt(3))) ///
	mlabels("\shortstack{Mult. Logit\\Choice}" ///
	"\shortstack{Mult. Logit\\Choice}" "\shortstack{Mult. Logit\\Choice}" ///
	"\shortstack{Mult. Logit\\Choice}", lhs(Dependent Var.)) ///
	varlabels(ratingguilt "Guilt" ratingpride "Pride" ///
	ratingfinan "Finan. Satis." ratingfair "Fairness" ///
	ratingunfair "Unfairness" ratinghappy "Happiness" ///
	ratingsatis "Satis." guilt_part3 "Guilt $\times$ (Opt-Out Game)" ///
	pride_part3 "Pride $\times$ (Opt-Out Game)" finan_part3 "Finan. $\times$ (Opt-Out Game)" ///
	fair_part3 "Fairness $\times$ (Opt-Out Game)" unfair_part3 "Unfairness $\times$ (Opt-Out Game)" ///
	happy_part3 "Happiness $\times$ (Opt-Out Game)" satis_part3 "Satis. $\times$ (Opt-Out Game)" ///
	1 "Prosocial Constant" 2 "Opt-Out Constant")  ///
	scalars("group N. Participants") 


	

	
	
	
	
	
	
	
	
	
	
	
	
	






