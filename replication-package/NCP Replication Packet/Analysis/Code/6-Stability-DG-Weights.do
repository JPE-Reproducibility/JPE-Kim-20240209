/* _____________________________________________________________________________

	TESTING STABILITY OF WEIGHTS
_____________________________________________________________________________ */

* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Globals for table properties
global bin_disp			mcolor(magenta%50) lcolor(midblue) ///
						yscale(range(0 1)) ylab(0(.2)1) xscale(range(0 1)) xlab(0(.2)1)
global emotions			"guilt pride finan fair unfair happy satis"
global binsreg_axis		yscale(range(0 1)) ylab(0(.2)1) xscale(range(0 1)) xlab(0(.2)1) 


* Construct money metric utility
cap program drop prog_lu_mmu_long
program define prog_lu_mmu_long, rclass
	* Get reg coefficients for relative weights of each CSA
	logit part1_choice rel_* if part==1, r nocons
	
	* Multiply the CSA scores by coefficients and create utility measure
	gen lu=$lu_calc
	
	* Now reg latent utility on the payoff and get mmu
	reg lu payoff if part==2 & inlist(choice_set,4,5,6,7) & treatment=="main", r
	gen mmu = lu/_b[payoff] //money-metric utility
	
end
		
		
* ---------------------------------------------- *
* 	Predicted Probabilities with CSA weights
* ---------------------------------------------- *

* Open data and clean
use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
keep if inlist(treatment,"main","cs")
qui {
	* Make descriptive variables and xtset
	egen id=group(mturkid)
	xtset id
	egen part_cs = tag(mturkid part choice_set)

	** Relative emotions 
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

	* Create a payoff variable for choice set 4, 5, 6, and 7
	gen payoff=4 if choice_set==4 & part==2 & prosocial==0
	replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
	replace payoff=3 if choice_set==6 & part==2 & prosocial==0
	replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
	
	* Drop choices with no data
	drop if guilt==.
}

* Predict probability of choosing with logit DG weights
logit part1_choice rel_* if part==1, r nocons
predict pred

* Replace pred in OO games with exp(lu of outcome)/exp(sum of lu in cs)
prog_lu_mmu_long
gen exp_lu=exp(lu)
bys mturkid part choice_set: egen denom=total(exp_lu)
replace pred=exp_lu/denom if part==3
drop denom exp_lu mmu lu

* Replace pred in DG/CC games with 1-pr(Choose More Equitable)
replace pred=1-pred if (part==1 | part==2) & prosocial==0


* Predict probability of choosing with logit OO weights
egen group=group(mturkid choice_set part)
gen choice1=(part1_choice==prosocial)
gen choice3=(part3_choice==prosocial)
asclogit choice3 $emotions if part==3 & inlist(treatment,"main","cs"), ///
	case(group) alt(prosocial) cluster(mturkid) nocons
predict pred_oo	

* Plot observed probs vs predicted probs from OO
gen pr_oo0=part3_choice==0
gen pr_oo1=part3_choice==1
gen pr_oo2=part3_choice==2


* PLOT PREDICTED PROBABILITIES OVER ACTUAL _____________________________________

* Plot predicted against actual probabilities in DG
** First get slope to report on graph
reg part1_choice pred if part==1 & prosocial==1
local eq = `"`: display %4.2f _b[pred]'"' 
** Then graph
binscatter part1_choice pred if part==1 & prosocial==1, ///
		ytitle("Fraction Choosing More Equitable in the DG") ///
		xtitle("Predicted Pr(Choosing More Equitable) in the DG" "DG-estimated CSA coefficients") ///
		text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_pred_dg_dgweights.pdf", replace

* Plot pr(Choosing More Equitable in DG) with pred_oo against actual probabilities
reg part1_choice pred_oo if part==1 & prosocial==1
local eq = `" `: display %4.2f _b[pred_oo]'"' // the constant
binscatter part1_choice pred_oo if part==1 & prosocial==1, ///
	ytitle("Fraction Choosing More Equitable in the DG") ///
	xtitle("Predicted Pr(Choosing More Equitable) in the DG" "OO-estimated CSA coefficients") ///
	text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_pred_dg_ooweights.pdf", replace

* Plot predicted OO against actual probabilities in OO using OO weights
reg pr_oo1 pred_oo if part==3 & prosocial==1
local eq = `"`: display %4.2f _b[pred_oo]'"' // the constant
binscatter pr_oo1 pred_oo if part==3 & prosocial==1, ///
	ytitle("Fraction Choosing More Equitable in the OO") ///
	xtitle("Predicted Pr(Choosing More Equitable) in the OO" "OO-estimated CSA coefficients") ///
	text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_pred_oo_ooweights.pdf", replace

* Plot predicted prosocial in OO against actual probabilities in OO using DG weights
reg pr_oo1 pred if part==3 & prosocial==1
local eq = `"`: display %4.2f _b[pred]'"' // the constant
binscatter pr_oo1 pred if part==3 & prosocial==1, ///
	ytitle("Fraction Choosing More Equitable in the OO") ///
	xtitle("Predicted Pr(Choosing More Equitable) in the OO" "DG-estimated CSA coefficients") ///
	text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_pred_oo_dgweights.pdf", replace

* Plot predicted opt out in OO against actual probabilities in OO using OO weights
reg pr_oo2 pred_oo if part==3 & prosocial==2
local eq = `"`: display %4.2f _b[pred_oo]'"' // the constant
binscatter pr_oo2 pred_oo if part==3 & prosocial==2, ///
	ytitle("Fraction Opting Out in the OO") ///
	xtitle("Predicted Pr(Opt Out) in the OO" "OO-estimated CSA coefficients") ///
	text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_predoo_oo_ooweights.pdf", replace

* Plot predicted opt out in OO against actual probabilities in OO using DG weights
reg pr_oo2 pred if part==3 & prosocial==2
local eq = `"`: display %4.2f _b[pred]'"' // the constant
binscatter pr_oo2 pred if part==3 & prosocial==2, ///
	ytitle("Fraction Opting Out in the OO") ///
	xtitle("Predicted Pr(Opt Out) in the OO" "DG-estimated CSA coefficients") ///
	text(.2 .8 `"{&beta} = `eq'"') $bin_disp
graph export "$output_dir/binscatter_obs_predoo_oo_dgweights.pdf", replace


	
	
	
	

