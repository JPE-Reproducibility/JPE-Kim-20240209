/* _____________________________________________________________________________

	ORDER EFFECTS
_____________________________________________________________________________ */

* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Globals for table properties
global bin_disp			mcolor(magenta%50) lcolor(midblue) ///
						yscale(range(0 1)) ylab(0(.2)1) xscale(range(0 1)) xlab(0(.2)1)
global emotions			"guilt pride finan fair unfair happy satis"
global binsreg_axis		yscale(range(0 1)) ylab(0(.2)1) xscale(range(0 1)) xlab(0(.2)1) 
global lu_calc 			"guilt*_b[rel_guilt]+pride*_b[rel_pride]+finan*_b[rel_finan]+fair*_b[rel_fair]+unfair*_b[rel_unfair]+happy*_b[rel_happy]+satis*_b[rel_satis]"



* Clean the data
cap program drop prog_clean_data
program define prog_clean_data, rclass
	* Open all data
	use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
	keep if inlist(treatment,"main","cs") // main treatments
	
	* Merge order data
	merge m:1 mturkid using "$raw_data_dir/mturk_module_order.dta", nogen keep(matched master) 

	** Relative emotions 
	foreach emotion in $emotions {
		gen rel_`emotion' = `emotion'_p1-`emotion'_p0
	}
	
	* Reshape
	reshape long guilt pride finan fair unfair happy satis, ///
		i(mturkid choice_set part present) j(prosocial) string
	replace prosocial="1" if prosocial=="_p1"
	replace prosocial="0" if prosocial=="_p0"
	replace prosocial="2" if prosocial=="_p2"
	destring prosocial, force replace

	* Create a payoff variable for choice set 4, 5, 6, and 7
	gen payoff=4 if choice_set==4 & part==2 & prosocial==0
	replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
	replace payoff=3 if choice_set==6 & part==2 & prosocial==0
	replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
	
	* Drop choices with no data
	drop if guilt==.
end

* Construct money metric utility and differences 
cap program drop prog_lu_mmu_long
program define prog_lu_mmu_long
	
	* Get reg coefficients for relative weights of each emotion
	logit part1_choice rel_* if part==1 `1', r nocons
	
	* Multiply the emotion scores by coefficients and create utility measure
	gen lu=$lu_calc
	
	* Now reg latent utility on the payoff and get mmu
	reg lu payoff if part==2 & inlist(choice_set,4,5,6,7) & treatment=="main", r
	gen mmu = lu/_b[payoff] //money-metric utility

	* Gen equivalent variation
	sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	replace mmu=mmu-r(mean)+4 if treatment=="cs" 
	gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	bys mturkid: egen temp2=min(temp)
	replace mmu=mmu-temp2+4 if !(treatment=="cs")
	
	drop temp*

end

* Get logit est of sharing vs actual DG estimate
cap program drop prog_logit_ev
program define prog_logit_ev, rclass
	
	preserve
	* Get money metric utility
	qui prog_lu_mmu_long
	
	* Get a variable for opting in
	gen optin=part3_choice!=2
	
	* Get variables for payout amount
	gen payout=5 if choice_set==1 & part==3
	replace payout=4 if choice_set==2 & part==3
	replace payout=3.5 if choice_set==3 & part==3
	replace payout=3 if choice_set==4 & part==3
	
	* Get opt-in values from three different methods
	forval c=3/5 {
		* Infer from logit reg
		logit optin payout if part==3 & prosocial==2 & optout_all==`c' & oo_first==1 //OO first
		return scalar logit1_`c' = _b[_cons]/_b[payout]*-1
		local logit1 = _b[_cons]/_b[payout]*-1
		
		* Actual EV
		sum mmu if part==1 & prosocial==part1_choice & choice_set==`c' & dg_first==1 // DG first
		return scalar ev1_`c' = r(mean)
		local ev1_`c' = r(mean)
		
		* Difference
		return scalar diff1_`c'= `logit1' - `ev1_`c''
	}
	restore
end

		
		
* ---------------------------------------------- *
* 	Predicted Probabilities with CSA weights
* ---------------------------------------------- *

* Open data and clean
prog_clean_data

* Predict probability of choosing with logit DG weights, if DG comes first
logit part1_choice rel_* if part==1 & arm==1, r nocons
predict pred

** Replace pred in OO games with exp(lu of outcome)/exp(sum of lu in order 1)
prog_lu_mmu_long "& arm==1"
gen exp_lu=exp(lu)
bys mturkid part choice_set: egen denom=total(exp_lu)
replace pred=exp_lu/denom if part==3
drop denom exp_lu mmu lu

** Replace pred in DG/CC games with 1-pr(Choose More Equitable)
replace pred=1-pred if (part==1 | part==2) & prosocial==0

* Predict probability of choosing with logit DG weights, if DG comes first
logit part1_choice rel_* if part==1 & arm==0, r nocons
predict pred2

** Replace pred in OO games with exp(lu of outcome)/exp(sum of lu in order 2)
prog_lu_mmu_long  "& arm==0"
gen exp_lu=exp(lu)
bys mturkid part choice_set: egen denom=total(exp_lu)
replace pred2=exp_lu/denom if part==3
drop denom exp_lu mmu lu

** Replace pred in DG/CC games with 1-pr(Choose More Equitable)
replace pred2=1-pred2 if (part==1 | part==2) & prosocial==0


* PLOT PREDICTED PROBABILITIES OVER ACTUAL _____________________________________

* Plot predicted against actual probabilities in DG, DG shown first weights and CC CSAs
** First get slope to report on graph
reg part1_choice pred if part==1 & prosocial==1 & arm==0
local eq = `"`: display %4.2f _b[pred]'"' 
** Then graph
binscatter part1_choice pred if part==1 & prosocial==1 & arm==0, ///
		ytitle("Fraction Choosing More Equitable in the DG", size(small)) ///
		xtitle("Predicted Pr(Choosing More Equitable) in the DG", size(small)) ///
		text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_pred_dg_dgweights_ccfirst.pdf", replace


* Plot predicted against actual probabilities in DG, CC shown first weights and CSAs
** First get slope to report on graph
reg part1_choice pred2 if part==1 & prosocial==1 & arm==1
local eq = `"`: display %4.2f _b[pred2]'"' 
** Then graph
binscatter part1_choice pred2 if part==1 & prosocial==1 & arm==1, ///
		ytitle("Fraction Choosing More Equitable in the DG", size(small)) ///
		xtitle("Predicted Pr(Choosing More Equitable) in the DG", size(small)) ///
		text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_pred_dg_ccweights_dgfirst.pdf", replace




* ---------------------------------------------- *
* 		Table 2 Order Effects
* ---------------------------------------------- *

prog_clean_data

* Run logit vs hybrid method estimates
** Traditional logit analysis
qui prog_clean_data
bootstrap c3=r(logit1_3) c4=r(logit1_4) c5=r(logit1_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap1

** EV of DG
bootstrap c3=r(ev1_3) c4=r(ev1_4) c5=r(ev1_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap2

** Difference in 1 and 2
bootstrap c3=r(diff1_3) c4=r(diff1_4) c5=r(diff1_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap3


* Put in table
esttab bootstrap1 bootstrap2 bootstrap3 using ///
	"$output_dir/logit_vs_ev_dg_order_dgoo.tex", replace cell(b(star fmt(2)) ///
	`"ci_percentile[ll](fmt(2) par("[" ",")) & ci_percentile[ul](fmt(2) par("" "]"))"') ///
	nonote booktabs label noobs nonum nomtitle collabel(none) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabels("\shortstack{(1)\\Choice-based inference\\of playing the DG\\using the Opt-Out Game\\OO first}" ///
	"\shortstack{(2)\\ $\bar{u}_{jc}$ of playing\\in the DG using\\CSAs in the DG\\DG first}" ///
	"\shortstack{(3)\\Difference\\(1)-(2)}") ///
	varlabels(c3 "Subgame: (2,1.5) vs. (4,0)" ///
	c4 "Subgame: (2,2) vs. (4,0)" c5 "Subgame: (2,2) vs. (3.5,0)") ///
	prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	`"\adjustbox{max height=\dimexpr\textheight-5.5cm\relax, max width=\textwidth}{"' ///
	`"\begin{tabular}{l*{8}{c}}"' `"\toprule"') ///
	postfoot(`"\bottomrule"' `"\end{tabular}"' `"}"')
eststo clear





