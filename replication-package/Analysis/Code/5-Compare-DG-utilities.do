/* _____________________________________________________________________________

	COMPARE UTILITIES OF SUBGAMES USING DG VS OO 
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Emotions
global emotions guilt pride finan fair unfair happy satis
global lu_calc 			"guilt*_b[rel_guilt]+pride*_b[rel_pride]+finan*_b[rel_finan]+fair*_b[rel_fair]+unfair*_b[rel_unfair]+happy*_b[rel_happy]+satis*_b[rel_satis]"


* Clean the data
cap program drop prog_clean_data
program define prog_clean_data, rclass
	* Open all data
	use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
	keep if inlist(treatment,"main","cs")
	
	* Make descriptive variables and xtset
	egen id=group(mturkid)
	xtset id
	egen part_cs = tag(mturkid part choice_set)

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
	logit part1_choice rel_* if part==1, r nocons
	
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
		logit optin payout if part==3 & prosocial==2 & optout_all==`c'
		return scalar logit_`c' = _b[_cons]/_b[payout]*-1
		local logit = _b[_cons]/_b[payout]*-1
		
		* Actual EV
		sum mmu if part==1 & prosocial==part1_choice & choice_set==`c' 
		return scalar ev_`c' = r(mean)
		local ev_`c' = r(mean)
		
		* OO EV
		sum mmu if part==3 & prosocial==part1_choice & optout_all==`c'
		return scalar ev3_`c' = r(mean)
		local ev3_`c' = r(mean)
		
		* Difference
		return scalar diff_`c'= `logit' - `ev_`c''
		return scalar diff3_`c'= `ev_`c'' - `ev3_`c''
	}
	restore
end



* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Run logit vs hybrid method estimates
** Traditional logit analysis
qui prog_clean_data
bootstrap c3=r(logit_3) c4=r(logit_4) c5=r(logit_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap1
local obs = e(N)
local group = e(N_clust)

** EV of DG
bootstrap c3=r(ev_3) c4=r(ev_4) c5=r(ev_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap2

** EV of choice of DG in OO
bootstrap c3=r(ev3_3) c4=r(ev3_4) c5=r(ev3_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap3

** Difference in 1 and 2
bootstrap c3=r(diff_3) c4=r(diff_4) c5=r(diff_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap4

** Difference in 2 and 3
bootstrap c3=r(diff3_3) c4=r(diff3_4) c5=r(diff3_5), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_logit_ev
estat bootstrap, all
eststo bootstrap5

* Put in table
esttab bootstrap1 bootstrap2 bootstrap3 bootstrap4 bootstrap5 using ///
	"$output_dir/logit_vs_ev_dg.tex", replace cell(b(star fmt(2)) ///
	`"ci_percentile[ll](fmt(2) par("[" ",")) & ci_percentile[ul](fmt(2) par("" "]"))"') ///
	nonote booktabs label noobs nonum nomtitle collabel(none) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabels("\shortstack{(1)\\Choice-based inference\\of the DG's value,\\using the Opt-Out Game}" ///
	"\shortstack{(2)\\ $\bar{u}_{jc}$ of playing\\in the DG using\\CSAs in the DG}" ///
	"\shortstack{(3)\\ $\bar{u}_{jc}$ of playing\\in the DG using\\CSAs in the OO}" ///
	"\shortstack{(4)\\Difference\\(1)-(2)}" "\shortstack{(5)\\Difference\\(2)-(3)}") ///
	varlabels(c3 "Subgame: (2,1.5) vs. (4,0)" ///
	c4 "Subgame: (2,2) vs. (4,0)" c5 "Subgame: (2,2) vs. (3.5,0)") ///
	prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	`"\adjustbox{max height=\dimexpr\textheight-5.5cm\relax, max width=\textwidth}{"' ///
	`"\begin{tabular}{l*{5}{c}}"' `"\toprule"') ///
	postfoot(`"\midrule"' `"\multicolumn{1}{l}{Observations: `obs'}"'  `"\midrule"' ///
	`"\multicolumn{1}{l}{N. Participants: `group'}"' `"\bottomrule"' `"\end{tabular}"' `"}"')
eststo clear







































