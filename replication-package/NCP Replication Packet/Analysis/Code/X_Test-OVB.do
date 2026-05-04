/* _____________________________________________________________________________

	Testing OVB
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Globals
global lu_calc 			"guilt*_b[rel_guilt]+pride*_b[rel_pride]+finan*_b[rel_finan]+fair*_b[rel_fair]+unfair*_b[rel_unfair]+happy*_b[rel_happy]+satis*_b[rel_satis]"
global emotions			"guilt pride finan fair unfair happy satis"

* Programs
* Construct money metric utility
cap program drop prog_lu_mmu_long
program define prog_lu_mmu_long, rclass
	* Get reg coefficients for relative weights of each emotion
	logit part1_choice rel_* if part==1, r nocons
	
	* Multiply the emotion scores by coefficients and create utility measure
	gen lu=$lu_calc
	
	* Now reg latent utility on the payoff and get mmu
	reg lu payoff if part==2 & inlist(choice_set,4,5,6,7) & treatment=="main", r
	gen mmu = lu/_b[payoff] //money-metric utility
	
end

* Construct money metric utility with choice set fixed effect
cap program drop prog_lu_mmu_long_fe
program define prog_lu_mmu_long_fe, rclass
	* Get reg coefficients for relative weights of each emotion
	logit part1_choice rel_* csfe* if part==1, r nocons
	
	* Multiply the emotion scores by coefficients and create utility measure
	gen lu=$lu_calc
	
	* Now reg latent utility on the payoff and get mmu
	reg lu payoff if part==2 & inlist(choice_set,4,5,6,7) & treatment=="main", r
	gen mmu = lu/_b[payoff] //money-metric utility
	
end

* Average of utilities
cap program drop prog_util
program define prog_util, rclass
	preserve
	
	* Generate LU and MMU with programs
	`0'

	* Make rel to (0,0)
	gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	bys mturkid: egen temp2=min(temp)
	replace mmu=mmu-temp2+4 if !(treatment=="cs")
	
	drop temp*
	
	* Average welfare in DG choice set
	foreach p of numlist 0/1 {
		foreach c of numlist 1/7 {
			* Part 1 averages
			sum mmu if choice_set==`c' & prosocial==`p' & part==1 
			return scalar mmu_c`c'_p`p'_part1 = r(mean)
			** Chosen
			sum mmu if choice_set==`c' & prosocial==`p' & part==1 & part1_choice==prosocial
			return scalar chosen_mmu_c`c'_p`p'_part1 = r(mean)
		}
	}
		
	restore
end



* ---------------------------------------------- *
* 	Table of CSA weights with CS fixed effects
* ---------------------------------------------- *

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
}	

* Make a bunch of CS dummies (easier to label on tables)
forval i=2/7 {
	gen csfe`i'=choice_set==`i'
}

* Non-instrumented logit
logit part1_choice rel_* if part==1 & inlist(treatment,"main","cs"), ///
	 vce(cluster mturkid) nocons
** First get adjusted r^2 manually
scalar l1= e(ll)
qui logit `e(depvar)' if e(sample)
scalar l0= e(ll)
local PR2: di %9.0f 1-(l1/l0)
** Run again to get stored results
logit part1_choice rel_* if part==1 & inlist(treatment,"main","cs"), ///
	 vce(cluster mturkid) nocons
eststo logit: margins, dydx(*) post
estadd local cs "No", replace
estadd scalar r2 = `PR2', replace

* With cs fixed effects
logit part1_choice rel_* csfe* if part==1 & inlist(treatment,"main","cs"), ///
	 vce(cluster mturkid) nocons
** First get adjusted r^2 manually
scalar l1= e(ll)
qui logit `e(depvar)' if e(sample)
scalar l0= e(ll)
local PR2: di %9.0f 1-(l1/l0)
** Run again to get stored results
logit part1_choice rel_* csfe* if part==1 & inlist(treatment,"main","cs"), ///
	 vce(cluster mturkid) nocons
eststo logit_fe: margins, dydx(*) post
estadd local cs "Yes", replace
estadd scalar r2 = `PR2', replace
local obs = e(N)
local group = e(N_clust)

* Put in a table
esttab logit logit_fe using "$output_dir/ivlogit_part1_csfe_short.tex", keep(rel*) /// 
	collabels(none) eqlabels(none) noobs nonote booktabs label $tablefit ///
	replace cell(b(star fmt(2)) se(par fmt(2))) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabels("\shortstack{Logit\\Choosing\\More Equitably}" ///
	"\shortstack{FE Logit\\Choosing\\More Equitably}") ///
	varlabels(rel_guilt "$\Delta$ Guilt" rel_pride "$\Delta$ Pride" ///
	rel_finan "$\Delta$ Finan. Satis." rel_fair "$\Delta$ Fairness" ///
	rel_unfair "$\Delta$ Unfairness" rel_happy "$\Delta$ Happiness" ///
	rel_satis "$\Delta$ Satisfaction") scalars("cs Choice Set FE" "r2 Pseudo R-Squared" ///
	"k \hline" "obs Observations" "group N. Participants")
eststo clear



* ---------------------------------------------- *
* 	Table of choice set effects on differences in utility
* ---------------------------------------------- *

preserve
* Get reg coefficients for relative weights of each emotion
logit part1_choice rel_* if part==1, r nocons

* Multiply the emotion scores by coefficients and create utility measure
gen lu=$lu_calc

* Get difference between equitable and less equitable
keep mturkid part choice_set prosocial $emotions lu csfe*
reshape wide $emotions lu, i(mturkid part choice_set csfe*) j(prosocial)
gen lu_diff=lu1-lu0

* Reg difference on cs fixed effects
reg lu_diff csfe* if part==1, r cluster(mturkid)
eststo cs_model
estadd scalar r2 = e(r2_a), replace
local pr2=round(e(r2_a),0.01)
di `pr2'
latex_write csfers `pr2' numbers_pipe
local obs = e(N)
local group = e(N_clust)

* Put in table
esttab cs_model using "$output_dir/ludiff_csfe.tex", /// 
	collabels(none) eqlabels(none) noobs nonote booktabs label ///
	replace cell(b(star fmt(2)) se(par fmt(2))) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabels("\shortstack{Reg\\ $\Delta_{ijc}\hat{\beta}.$}") ///
	varlabels(csfe2 "Choice Set 2" csfe3 "Choice Set 3" csfe4 "Choice Set 4" ///
	csfe5 "Choice Set 5" csfe6 "Choice Set 6" csfe7 "Choice Set 7" _cons "Constant") ///
	scalars("r2 Adj. R-Squared") ///
	postfoot("\midrule \multicolumn{1}{l}{Observations: `obs'}  \\ \multicolumn{1}{l}{N. Participants: `group'}  \\ \bottomrule \\ \end{tabular} \\ }") ///
	prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\adjustbox{max height=\dimexpr\textheight-5.5cm\relax, max width=\textwidth}{"'`"\begin{tabular}{l*{8}{c}}"' `"\toprule"') 
eststo clear
restore


*------------------------------------------------------------*
*	 Welfare graphs with CS fixed effects
*------------------------------------------------------------*

*---------------------------*
*	 All Options
*---------------------------*

* Bootstrap the normal logit ___________________________________________________
bootstrap ///
	mmu_c1_p1_part1=r(mmu_c1_p1_part1) mmu_c1_p0_part1=r(mmu_c1_p0_part1) ///
	mmu_c2_p1_part1=r(mmu_c2_p1_part1) mmu_c2_p0_part1=r(mmu_c2_p0_part1) ///
	mmu_c3_p1_part1=r(mmu_c3_p1_part1) mmu_c3_p0_part1=r(mmu_c3_p0_part1) ///
	mmu_c4_p1_part1=r(mmu_c4_p1_part1) mmu_c4_p0_part1=r(mmu_c4_p0_part1) ///
	mmu_c5_p1_part1=r(mmu_c5_p1_part1) mmu_c5_p0_part1=r(mmu_c5_p0_part1) ///
	mmu_c6_p1_part1=r(mmu_c6_p1_part1) mmu_c6_p0_part1=r(mmu_c6_p0_part1) ///
	mmu_c7_p1_part1=r(mmu_c7_p1_part1) mmu_c7_p0_part1=r(mmu_c7_p0_part1), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long
estat bootstrap, all

* Put in dataframe to graph
preserve
prog_mat
gen prosocial = mod(n,2)

* Format x axis
gen graph_order=n
foreach num of numlist 2(2)28 {
	replace graph_order=graph_order+1 if n>`num'
}
gen fe=0

* Temp file
tempfile temp
save `temp'
restore


* Bootstrap the logit w FE _____________________________________________________
bootstrap ///
	mmu_c1_p1_part1=r(mmu_c1_p1_part1) mmu_c1_p0_part1=r(mmu_c1_p0_part1) ///
	mmu_c2_p1_part1=r(mmu_c2_p1_part1) mmu_c2_p0_part1=r(mmu_c2_p0_part1) ///
	mmu_c3_p1_part1=r(mmu_c3_p1_part1) mmu_c3_p0_part1=r(mmu_c3_p0_part1) ///
	mmu_c4_p1_part1=r(mmu_c4_p1_part1) mmu_c4_p0_part1=r(mmu_c4_p0_part1) ///
	mmu_c5_p1_part1=r(mmu_c5_p1_part1) mmu_c5_p0_part1=r(mmu_c5_p0_part1) ///
	mmu_c6_p1_part1=r(mmu_c6_p1_part1) mmu_c6_p0_part1=r(mmu_c6_p0_part1) ///
	mmu_c7_p1_part1=r(mmu_c7_p1_part1) mmu_c7_p0_part1=r(mmu_c7_p0_part1), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long_fe
estat bootstrap, all

* Put in dataframe to graph
preserve
prog_mat
gen prosocial = mod(n,2)

* Format x axis
gen graph_order=n
foreach num of numlist 2(2)28 {
	replace graph_order=graph_order+1 if n>`num'
}
gen fe=1
append using `temp'

* Graph
tw (rspike upper lower graph_order if prosocial==1 & fe==0, lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & fe==0, mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & fe==0, lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & fe==0, mcolor(orange)) ///
	(rspike upper lower graph_order if prosocial==1 & fe==1, lcolor(ebblue%40)) ///
	(sc coef graph_order if prosocial==1 & fe==1, mcolor(ebblue%40) m(T)) ///
	(rspike  upper lower graph_order if prosocial==0 & fe==1, lcolor(orange%40)) ///
	(sc coef graph_order if prosocial==0 & fe==1, mcolor(orange%40) m(T)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) yscale(range(0 8)) ylab(0(1)8)  ///
	legend(order(2 "Baseline" "More Equitable" 4 "Baseline" "Less Equitable" ///
	6 "Choice Set FE" "More Equitable" 8 "Choice Set FE" "Less Equitable") size(vsmall))
graph export "$output_dir/logit_mmup1_means_fe.pdf", replace
restore


*---------------------------*
*	 Chosen Options
*---------------------------*

* Bootstrap the normal logit ___________________________________________________
bootstrap ///
	chosen_mmu_c1_p1_part1=r(chosen_mmu_c1_p1_part1) chosen_mmu_c1_p0_part1=r(chosen_mmu_c1_p0_part1) ///
	chosen_mmu_c2_p1_part1=r(chosen_mmu_c2_p1_part1) chosen_mmu_c2_p0_part1=r(chosen_mmu_c2_p0_part1) ///
	chosen_mmu_c3_p1_part1=r(chosen_mmu_c3_p1_part1) chosen_mmu_c3_p0_part1=r(chosen_mmu_c3_p0_part1) ///
	chosen_mmu_c4_p1_part1=r(chosen_mmu_c4_p1_part1) chosen_mmu_c4_p0_part1=r(chosen_mmu_c4_p0_part1) ///
	chosen_mmu_c5_p1_part1=r(chosen_mmu_c5_p1_part1) chosen_mmu_c5_p0_part1=r(chosen_mmu_c5_p0_part1) ///
	chosen_mmu_c6_p1_part1=r(chosen_mmu_c6_p1_part1) chosen_mmu_c6_p0_part1=r(chosen_mmu_c6_p0_part1) ///
	chosen_mmu_c7_p1_part1=r(chosen_mmu_c7_p1_part1) chosen_mmu_c7_p0_part1=r(chosen_mmu_c7_p0_part1), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long
estat bootstrap, all

* Put in dataframe to graph
preserve
prog_mat
gen prosocial = mod(n,2)

* Format x axis
gen graph_order=n
foreach num of numlist 2(2)28 {
	replace graph_order=graph_order+1 if n>`num'
}
gen fe=0

* Temp file
tempfile temp
save `temp'
restore


* Bootstrap the logit w FE _____________________________________________________
bootstrap ///
	chosen_mmu_c1_p1_part1=r(chosen_mmu_c1_p1_part1) chosen_mmu_c1_p0_part1=r(chosen_mmu_c1_p0_part1) ///
	chosen_mmu_c2_p1_part1=r(chosen_mmu_c2_p1_part1) chosen_mmu_c2_p0_part1=r(chosen_mmu_c2_p0_part1) ///
	chosen_mmu_c3_p1_part1=r(chosen_mmu_c3_p1_part1) chosen_mmu_c3_p0_part1=r(chosen_mmu_c3_p0_part1) ///
	chosen_mmu_c4_p1_part1=r(chosen_mmu_c4_p1_part1) chosen_mmu_c4_p0_part1=r(chosen_mmu_c4_p0_part1) ///
	chosen_mmu_c5_p1_part1=r(chosen_mmu_c5_p1_part1) chosen_mmu_c5_p0_part1=r(chosen_mmu_c5_p0_part1) ///
	chosen_mmu_c6_p1_part1=r(chosen_mmu_c6_p1_part1) chosen_mmu_c6_p0_part1=r(chosen_mmu_c6_p0_part1) ///
	chosen_mmu_c7_p1_part1=r(chosen_mmu_c7_p1_part1) chosen_mmu_c7_p0_part1=r(chosen_mmu_c7_p0_part1), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long_fe
estat bootstrap, all

* Put in dataframe to graph
preserve
prog_mat
gen prosocial = mod(n,2)

* Format x axis
gen graph_order=n
foreach num of numlist 2(2)28 {
	replace graph_order=graph_order+1 if n>`num'
}
gen fe=1
append using `temp'


* Graph
tw (rspike upper lower graph_order if prosocial==1 & fe==0, lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & fe==0, mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & fe==0, lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & fe==0, mcolor(orange)) ///
	(rspike upper lower graph_order if prosocial==1 & fe==1, lcolor(ebblue%40)) ///
	(sc coef graph_order if prosocial==1 & fe==1, mcolor(ebblue%40) m(T)) ///
	(rspike  upper lower graph_order if prosocial==0 & fe==1, lcolor(orange%40)) ///
	(sc coef graph_order if prosocial==0 & fe==1, mcolor(orange%40) m(T)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) yscale(range(0 8)) ylab(0(1)8)  ///
	legend(order(2 "Baseline" "More Equitable" 4 "Baseline" "Less Equitable" ///
	6 "Choice Set FE" "More Equitable" 8 "Choice Set FE" "Less Equitable") size(vsmall))
graph export "$output_dir/logit_chosen_mmup1_means_fe.pdf", replace
restore



