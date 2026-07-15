

/* _____________________________________________________________________________

	TESTING STABILITY OF WEIGHTS
_____________________________________________________________________________ */

* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Graph properties
global bin_disp			mcolor(magenta%50) lcolor(midblue) ///
						yscale(range(0 1)) ylab(0(.2)1) xscale(range(0 1)) xlab(0(.2)1)
global emotions			"guilt pride finan fair unfair happy satis"
global binsreg_axis		yscale(range(0 1)) ylab(0(.2)1) xscale(range(0 1)) xlab(0(.2)1) 

* Get diff in predicted for DG - CC over DG
cap program drop prog_diff_pred
program define prog_diff_pred, rclass

	preserve 
	
	* Predict probability of choosing with logit DG weights
	logit part1_choice rel_* if part==1, r nocons
	predict pred

	* Replace pred in DG/CC games with 1-pr(Choose More Equitable)
	replace pred=1-pred if prosocial==0

	* Compare 
	keep if prosocial==1 & !(part==3) & treatment=="main"

	* Get pred from part 2 in a different column
	gen temp=pred if part==2
	bys mturkid choice_set: egen pred2=min(temp)
	drop if part==2
	drop temp

	*gen diff_prob=(pred-pred2)/pred2 
	
	forval c=1/7 {
		sum pred if choice_set==`c' & part==1
		local p1=r(mean)
		sum pred2 if choice_set==`c' & part==1
		local p2=r(mean)

		return scalar c`c' = (`p1'-`p2')/`p2'
	}
	
	restore
	
end

					
* ---------------------------------------------- *
* 	Pred prob. using DG and OO CSAs
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


* Bootstrap standard errors
bootstrap c1=r(c1) c2=r(c2) c3=r(c3) c4=r(c4) c5=r(c5) c6=r(c6) c7=r(c7), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_diff_pred
estat bootstrap, all	

* Make graph
prog_mat

* Make into percentages
foreach v in upper lower coef {
	replace `v'=`v'*100
}
tw (rspike upper lower n) (sc coef n, mcolor(navy)), ///
	ytitle("Predicted percent increase in preferring the more equitable allocation" "using DG CSAs versus CC CSAs", ///
	size(small)) xtitle("") ylab(5 "5%" 10 "10%" 15 "15%" 20 "20%") ///
	xlab(1 `""DG1" "(2,0.5), (4,0)""' ///
	2 `""DG2" "(2,1), (4,0)""' 3 `""DG3" "(2,1.5), (4,0)""' ///
	4 `""DG4" "(2,2), (4,0)""' 5 `""DG5" "(2,2), (3.5,0)""' ///
	6 `""DG6" "(2,2), (3,0)""' 7 `""DG7" "(2,2), (2.5,0)""', labsize(vsmall)) ///
	legend(off) 
graph export "$output_dir/pred2_diff_prob_dg_cc.pdf", replace


























