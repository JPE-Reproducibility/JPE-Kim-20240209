/* _____________________________________________________________________________

	ROBUSTNESS ANALYSIS
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

global rel_label_tex	varlabels(rel_guilt "$\Delta$ Guilt" rel_pride "$\Delta$ Pride" ///
						rel_finan "$\Delta$ Finan. Satis." rel_fair "$\Delta$ Fairness" ///
						rel_unfair "$\Delta$ Unfairness" rel_happy "$\Delta$ Happiness" ///
						rel_satis "$\Delta$ Satisfaction" 
global table_order 		order(rel_guilt rel_pride rel_finan rel_fair rel_unfair rel_happy rel_satis)
global emotions 		guilt pride finan fair unfair happy satis



* ---------------------------------------------- *
* 		Ex-Ante Analysis
* ---------------------------------------------- *

* Open data
use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear

* Make xtset
egen id=group(mturkid)
xtset id

** Relative emotions 
foreach emotion in guilt pride finan fair unfair happy satis {
	gen rel_`emotion' = `emotion'_p1-`emotion'_p0
}

* Ex-ante indicator
gen ea=treatment=="exante"
eststo sumstats: estpost sum rel_*


* Run OLS to see how ex-ante affects CSAs ____________________________________

* Over all choice sets for each emotion
foreach emotion in $emotions {
	* Indicator for ea
	reg `emotion'_p0 ea if part==1 & inlist(treatment,"main","cs","exante"), r cluster(mturkid)
	table_details
	eststo reg1_`emotion'
}

* Place in tables
esttab  reg1_guilt reg1_pride reg1_finan reg1_fair ///
	reg1_unfair reg1_happy reg1_satis ///
	using "$output_dir/reg_ea_csa_part1.tex", replace ///
	noobs nomtitle label booktabs nonote collabels(none) ///
	cell(b(fmt(3) star) se(par fmt(3)))  ///
	$tablefit $mlabels varlabels(ea "Ex-Ante" _cons "Constant") ///
	scalars("obs Observations" "group N. Participants")  
eststo clear


* Run CSA weights logit w ex-ante interactions _________________________________

* Regular logit
logit part1_choice rel_* if part==1 & treatment!="pf", r cluster(mturkid) nocons
eststo reg1: margins, dydx(*) post
table_details

* Make interactions
foreach var in $emotions {
	gen rel_`var'_ea=ea*rel_`var'
}

* Run logit with interactions
logit part1_choice rel_* if part==1 & treatment!="pf", r cluster(mturkid) nocons
eststo reg2: margins, dydx(*) post
table_details

* Compile into table
esttab reg1 reg2 ///
	using "$output_dir/logit_prosocial_ea_interaction.tex", replace ///
	noobs nomtitle label booktabs nonote collabels(none) eqlabels(none) ///
	cell(b(fmt(2) star) se(par fmt(2))) $tablefit $table_order ///
	mlabels("\shortstack{Logit\\Choosing\\More Equitably}" ///
	"\shortstack{Logit\\Choosing\\More Equitably}", lhs(Dependent Var.)) ///
	scalars("group N. Participants") ///
	$rel_label_tex rel_guilt_ea "$\Delta$ Guilt $\times$ Ex-Ante Arm" ///
	rel_pride_ea "$\Delta$ Pride $\times$ Ex-Ante Arm" ///
	rel_finan_ea "$\Delta$ Finan. Satis. $\times$ Ex-Ante Arm" ///
	rel_fair_ea "$\Delta$ Fairness $\times$ Ex-Ante Arm" ///
	rel_unfair_ea "$\Delta$ Unfairness $\times$ Ex-Ante Arm" ///
	rel_happy_ea "$\Delta$ Happiness $\times$ Ex-Ante Arm" ///
	rel_satis_ea "$\Delta$ Satis. $\times$ Ex-Ante Arm")
eststo clear



* ---------------------------------------------- *
* 		Present v Future
* ---------------------------------------------- *

drop *_ea


* Run separate models for present vs future CSAs _______________________________

* Do analysis on present-future CSAs
foreach p in 0 1 {
	** Y = choose equitable option; X = relative emotions
	logit part1_choice rel_* if part==1 & present==`p', r cluster(mturkid) nocons
	eststo mod1_`p': margins, dydx(*) post
	logit_table_details
}

* Compile into one table		
esttab mod1_1 mod1_0  ///
	using "$output_dir/logit_prosocial_present_col12.tex", replace keep(rel*) ///
	$tablefit $table_order $rel_label_tex) eqlabels(none) collabels(none) ///
	noobs nomtitle label booktabs nonote cell(b(fmt(2) star) se(par fmt(2))) ///
	mlabels("\shortstack{Logit\\Choosing\\More Equitably\\(Present)}" ///
	"\shortstack{Logit\\Choosing\\More Equitably\\(Future)}", lhs(Dependent Var.)) ///
	scalars("choicedummy Choice Set FE" "k \hline" "obs Observations" "group N. Participants")
eststo clear


* 	Correlation matrix for present and future CSAs _____________________________
capture confirm file "$output_dir/corr_matrix_pf.tex" 
if _rc!=0 {
	
	* Clean and reshape data
	keep if treatment=="pf"
	drop tag* rel*
	reshape long guilt_p pride_p finan_p fair_p unfair_p happy_p satis_p, i(mturkid choice_set part present) j(prosocial)
	reshape wide guilt_p pride_p finan_p fair_p unfair_p happy_p satis_p, i(mturkid choice_set part prosocial) j(present)

	* Get correlations
	foreach e in $emotions {
		corr `e'_p1 `e'_p0
		local corr_`e' = string(r(rho),"%9.2fc")
	}
	unique id
	local obs= r(N)

	* Manually write in table
	preserve
	postfile desc str15 CSA str5 Corr using "$output_dir/corr_matrix_rel.dta", replace
	post desc ("Guilt") ("`corr_guilt'") 
	post desc ("Pride") ("`corr_pride'") 
	post desc ("Financial Satis.") ("`corr_finan'") 
	post desc ("Fairness") ("`corr_fair'") 
	post desc ("Unfairness") ("`corr_unfair'") 
	post desc ("Happiness") ("`corr_happy'") 
	post desc ("Satisfaction") ("`corr_satis'") 
	post desc ("Observations") ("`obs'") 
	postclose desc 

	use "$output_dir/corr_matrix_rel.dta", clear
	label variable CSA "" 
	label variable Corr "Present-Future Correlation"
	list
	texsave using "$output_dir/corr_matrix_pf.tex", replace nofix varlabels ///
		align(lc) frag
	eststo clear
	restore
}












