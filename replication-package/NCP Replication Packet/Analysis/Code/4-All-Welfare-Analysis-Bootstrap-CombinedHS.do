/* _____________________________________________________________________________

	WELFARE ANALYSIS
_____________________________________________________________________________ */


*log using "$output_dir/logit_Welfare_Log.smcl", replace


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Graphing options
local overline = uchar(773)
global yscale 	yscale(range(0 8)) ylab(0(1)8)  
global ytitle 	"u`overline'{sub:jc} (in $ rel. to Computer Choice (0,0))"
local legend1 	legend(order(2 "More Equitable" 4 "Less Equitable") size(vsmall))
local legend2 	legend(order(2 "All CSAs, More Equitable" 4 "All CSAs, Less Equitable" ///
				6 "Happiness, More Equitable" 8 "Happiness, Less Equitable" ///
				10 "Satisfaction, More Equitable" 12 "Satisfaction, Less Equitable") size(vsmall))
local legend3 	legend(order(2 "More Equitable" 4 "Less Equitable") size(vsmall))
local legend4 	legend(order(2 "All CSAs, More Equitable" 4 "All CSAs, Less Equitable" ///
				6 "Happiness, More Equitable" 8 "Happiness, Less Equitable" ///
				10 "Satisfaction, More Equitable" 12 "Satisfaction, Less Equitable") size(vsmall))

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

cap program drop prog_lu_mmu_wide
program define prog_lu_mmu_wide, rclass
	* Get reg coefficients for relative weights of each CSA
	logit part1_choice rel_*1, r nocons
	
	* Multiply the CSA scores by coefficients and create utility measure
	gen lu1=$lu_calc_wide1
	gen lu2=$lu_calc_wide2
	gen lu3=$lu_calc_wide3
	
	* Get mmu for each game
	reg lu2 payoff if inlist(choice_set,4,5,6,7) & treatment=="main", r
	gen mmu1=lu1/_b[payoff]
	gen mmu2=lu2/_b[payoff]
	gen mmu3=lu3/_b[payoff]
	

end

* Get average money metric utilities
cap program drop prog_util
program define prog_util, rclass
	preserve
	
	* Generate LU and MMU
	prog_lu_mmu_long

	* Make mmu rel to (0,0)
	** For CS treatment, use the average of (0,0) mmu
	sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	replace mmu=mmu-r(mean)+4 if treatment=="cs"
	** For main treatment, subtract individual (0,0) mmu
	gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	bys mturkid: egen temp2=min(temp)
	replace mmu=mmu-temp2+4 if !(treatment=="cs")
	drop temp*
		
	* Loop through each choice set and option
	foreach p of numlist 0/1 {
		foreach c of numlist 1/7 {
			* DG averages
			sum mmu if choice_set==`c' & prosocial==`p' & part==1 
			return scalar mmu_c`c'_p`p'_part1 = r(mean)
			
			* CC main
			if `p'==1 {
				sum mmu if choice_set==`c' & prosocial==`p' & part==2 & treatment=="main"
				return scalar mmu_c`c'_p`p'_part2 = r(mean)
			}
			if `p'==0 & inrange(`c',1,4) {
				return scalar mmu_c`c'_p`p'_part2 = 4
			}
			if `p'==0 & `c'==5 {
				return scalar mmu_c`c'_p`p'_part2 = 3.5
			}
			if `p'==0 & `c'==6 {
				return scalar mmu_c`c'_p`p'_part2 = 3
			}
			if `p'==0 & `c'==7 {
				return scalar mmu_c`c'_p`p'_part2 = 2.5
			}
			
			* CC CS
			sum mmu if choice_set==`c' & prosocial==`p' & part==2 & treatment=="cs"
			return scalar mmu_c`c'_p`p'_part2_cs = r(mean)
		}
	}
	
	* OO averages
	foreach o of numlist 3/5 {
		foreach p of numlist 0/2 {
			foreach c of numlist 1/4 {
				sum mmu if choice_set==`c' & prosocial==`p' & part==3 & optout==`o' 
				return scalar mmu_c`c'_p`p'_part3_o`o' = r(mean)
			}
		}
	}
	
	* OO averages, averaging over all subgames in OO
	foreach p of numlist 0/2 {
		* Overall
		sum mmu if prosocial==`p' & part==3 
		return scalar mmu_p`p'_part3 = r(mean)
	}
		
	restore
end

* Get average money metric utilities, by chosen option
cap program drop prog_util_chosen
program define prog_util_chosen, rclass
	preserve
	
	* Generate LU and MMU
	prog_lu_mmu_long
	
	* Make relative to (0,0) for the relevant groups (those who chose a specific option)
	forval c=1/7 {
		* Divide sample by who chose what on each choice set
		gen temp=part1_choice if choice_set==`c' 
		bys mturkid: egen choice1_c`c'=min(temp)
		
		* Make relative to the group's (0,0)
		gen mmu1_c`c'=.
		forval p=0/1 {
			* Normalize MMU for each divide
			sum mmu if part==2 & choice_set==4 & prosocial==0 & choice1_c`c'==`p' & treatment=="main"
			replace mmu1_c`c'=mmu-r(mean)+4 if choice1_c`c'==`p' & part==1
		}
		drop temp
	}
	
	* Get averages of mmu for each option in the DG
	foreach p of numlist 0/1 {
		foreach c of numlist 1/7 {
			sum mmu1_c`c' if choice_set==`c' & prosocial==`p' & part==1 & choice1_c`c'==`p'
			return scalar chosen_mmu_c`c'_p`p'_part1 = r(mean)
		}
	}
	
	restore
end

* Diff in utility in DG vs OO
cap program drop prog_dg_oo_diff
program define prog_dg_oo_diff, rclass
	preserve
	
	* Generate LU and MMU
	prog_lu_mmu_long

	* Make rel to (0,0)
	** For CS treatment, use the average of (0,0) mmu
	sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	replace mmu=mmu-r(mean)+4 if treatment=="cs"
	** For main treatment, subtract individual (0,0) mmu
	gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	bys mturkid: egen temp2=min(temp)
	replace mmu=mmu-temp2+4 if !(treatment=="cs")
	drop temp*
	
	* Diff of utility in equitable option in DG vs OO
	sum mmu if part==1 & inrange(choice_set,3,5) & prosocial==1
	local dg_mmu = r(mean)
	sum mmu if part==3 & prosocial==1
	return scalar me_diff = `dg_mmu'-r(mean)
		
	* Find difference between opting out for $x and opting in for ($x,0)
	** For dg subgame (3.5,0): cs=1
	** For dg subgame (4,0): cs=2
	keep if part==3
	keep if (optout_all==3 & choice_set==2) | (optout_all==4 & choice_set==2) | (optout_all==5 & choice_set==3)
	drop if prosocial==1
	
	* Get MMU of opting in and opting out
	gen mmu_optout=mmu if optout_all==3 & choice_set==2 & prosocial==2
	replace mmu_optout=mmu if optout_all==4 & choice_set==2 & prosocial==2
	replace mmu_optout=mmu if optout_all==5 & choice_set==3 & prosocial==2
	
	gen mmu_optin=mmu if optout_all==3 & choice_set==2 & prosocial==0
	replace mmu_optin=mmu if optout_all==4 & choice_set==2 & prosocial==0
	replace mmu_optin=mmu if optout_all==5 & choice_set==3 & prosocial==0
	
	* Get the difference
	bys mturkid: egen mmu_oo=min(mmu_optout)
	bys mturkid: egen mmu_pm=min(mmu_optin)
	gen oo_diff=mmu_oo-mmu_pm
	
	sum oo_diff if prosocial==2
	return scalar le_diff = r(mean)
	
	restore
end

* How much better off if computer chooses your DG
cap program drop prog_welfare_graph2
program define prog_welfare_graph2, rclass	

	preserve
	* Get LU/MMU
	prog_lu_mmu_wide
	
	* Make MMU relative to (0,0) based on what participants chose in the DG
	forval c=1/7 {
		* Divide sample by who chose what on each choice set
		gen temp=part1_choice if choice_set==`c' 
		bys mturkid: egen choice_c`c'=min(temp)
			
		gen mmu1_c`c'=.
		gen mmu2_c`c'=.
		
		forval p=0/1 {
			* Normalize MMU in DG and CC
			sum mmu2 if choice_set==4 & prosocial==0 & choice_c`c'==`p' & treatment=="main"
			replace mmu1_c`c'=mmu1-r(mean)+4 if choice_c`c'==`p'
			replace mmu2_c`c'=mmu2-r(mean)+4 if choice_c`c'==`p'
			
			** By definition, the MMU of the less equitbale options in CS treatment is the amount you receive
			replace mmu2_c`c'=4 if choice_c`c'==`p' & inrange(choice_set,1,4)  & prosocial==0 & treatment=="main"
			replace mmu2_c`c'=3.5 if choice_c`c'==`p' & choice_set==5 & prosocial==0 & treatment=="main"
			replace mmu2_c`c'=3 if choice_c`c'==`p' & choice_set==6 & prosocial==0 & treatment=="main"
			replace mmu2_c`c'=2.5 if choice_c`c'==`p' & choice_set==7 & prosocial==0 & treatment=="main"	
		}
		
		drop temp*
	} 
	
	* How much better off if the computer chose selfish option by each type of option
	forval c=1/7 {
		* Selfish option with no alternative
		sum mmu2_c`c' if choice_set==`c' & prosocial==0  & treatment=="main" & part1_choice==prosocial
		local selfish = r(mean)
		
		* Selfish option with equitable alternative
		sum mmu2_c`c' if choice_set==`c' & prosocial==0 & treatment=="cs" & part1_choice==prosocial
		local selfish_cs = r(mean)
		
		* MMU in DG if less equitable chosen
		sum mmu1_c`c' if choice_set==`c' & part1_choice==0 & prosocial==0
		
		* MMU difference of when computer chooses your option for you without an alternative shown
		return scalar mmudiff0_c`c' = `selfish'-r(mean)
		* MMU difference when a computer chooses your option for you with the alternative shown
		return scalar mmudiff0_c`c'_cs= `selfish_cs'-r(mean)
	}
	
	* How much better off if computer chose equitably
	forval c=1/7 {
		* Equitable option with no alternative
		sum mmu2_c`c' if choice_set==`c' & part1_choice==prosocial & treatment=="main" & prosocial==1
		local mmu2 = r(mean)
		* Equitable option with less equitable alternative
		sum mmu2_c`c' if choice_set==`c' & part1_choice==prosocial & treatment=="cs" & prosocial==1
		local mmu2_cs = r(mean)
		
		* MMU in DG if more equitable option chosen
		sum mmu1_c`c' if choice_set==`c' & part1_choice==1  & prosocial==1
		
		* MMU difference of when computer chooses your option for you without an alternative shown
		return scalar mmudiff1_c`c'_type2 = `mmu2'-r(mean)
		* MMU difference when a computer chooses your option for you with the alternative shown
		return scalar mmudiff1_c`c'_type2_cs = `mmu2_cs'-r(mean)
		
	}
	
	* Average of when cc chooses your choice for you in the main and CS treatment
	gen cc_choice=.
	forval c=1/7 {
		replace cc_choice=mmu2_c`c'-mmu1_c`c' if choice_set==`c'
	}
	sum cc_choice if treatment=="main" & prosocial==0 & part1_choice==0
	return scalar ave_cc_choice_p0 = r(mean)
	
	sum cc_choice if treatment=="main" & prosocial==1 & part1_choice==1
	return scalar ave_cc_choice_p1 = r(mean)

	sum cc_choice if treatment=="cs" & prosocial==1 & part1_choice==1
	return scalar ave_cs_choice_p1 = r(mean)
	
	sum cc_choice if treatment=="cs" & prosocial==0 & part1_choice==0
	return scalar ave_cs_choice_p0 = r(mean)
		
	restore
end

* Difference between CC main and CC choice set for equitable and less equitable options
cap program drop prog_utilp2_diff
program define prog_utilp2_diff, rclass
	preserve
	
	* Generate LU and MMU
	prog_lu_mmu_long
	
	* Make everything rel to (0,0)
	sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	replace mmu=mmu-r(mean)+4
	** By definition, the less equitable options in the CC have MMU equivalent to payout
	replace mmu=4 if part==2 & inrange(choice_set,1,4)  & prosocial==0 & treatment=="main"
	replace mmu=3.5 if part==2 & choice_set==5 & prosocial==0 & treatment=="main"
	replace mmu=3 if part==2 & choice_set==6 & prosocial==0 & treatment=="main"
	replace mmu=2.5 if part==2 & choice_set==7 & prosocial==0 & treatment=="main"
	
	* CC main - cs
	foreach p of numlist 0/1 {
		if `p'==0 {
			* CC main
			sum mmu if prosocial==`p' & part==2 & treatment=="main" & choice_set>3
			local mmu2 = r(mean)
		}
		if `p'==1 {
			* CC main
			sum mmu if prosocial==`p' & part==2 & treatment=="main" & choice_set<5
			local mmu2 = r(mean)
		}
		
		* CC cs
		sum mmu if prosocial==`p' & part==2 & treatment=="cs"
		
		* Difference between CC main and CC CS
		return scalar mmu_part2_diff_p`p' = `mmu2'-r(mean)
	}
	restore
end

* Compare DG and CC differences in equitable and less equitable utilities
cap program drop prog_util_pdiff
program define prog_util_pdiff, rclass
	preserve
	
	* Generate LU and MMU
	prog_lu_mmu_long
	
	* Make everything rel to (0,0)
	sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	replace mmu=mmu-r(mean)+4
	** By definition, the less equitable options in the CC have MMU equivalent to payout
	replace mmu=4 if part==2 & inrange(choice_set,1,4)  & prosocial==0 & treatment=="main"
	replace mmu=3.5 if part==2 & choice_set==5 & prosocial==0 & treatment=="main"
	replace mmu=3 if part==2 & choice_set==6 & prosocial==0 & treatment=="main"
	replace mmu=2.5 if part==2 & choice_set==7 & prosocial==0 & treatment=="main"
		
	* Loop through each choice set
	foreach c of numlist 1/7  {
		foreach p of numlist 0/1 {
			* DG averages
			sum mmu if choice_set==`c' & prosocial==`p' & part==1 
			local mmu1_p`p'_c`c' = r(mean)

			* CC main
			sum mmu if choice_set==`c' & prosocial==`p' & part==2 & treatment=="main"
			local mmu2_p`p'_c`c' = r(mean)
		}
	
		* Get differences in equitable and less equitable options in DG and CC
		** DG
		return scalar diff1_c`c'=`mmu1_p1_c`c''-`mmu1_p0_c`c''
		** CC
		return scalar diff2_c`c'=`mmu2_p1_c`c''-`mmu2_p0_c`c''
		** CC - DG equitable
		return scalar diff3_c`c'=`mmu2_p1_c`c''-`mmu1_p1_c`c''
		** CC - DG less equitable
		return scalar diff4_c`c'=`mmu2_p0_c`c''-`mmu1_p0_c`c''
		** Difference in difference in options (equitable - less equitable) DG vs CC
		return scalar diff_`c' = (`mmu1_p1_c`c''-`mmu1_p0_c`c'') - (`mmu2_p1_c`c''-`mmu2_p0_c`c'')
	}
	
	* Across all choice sets
	foreach p of numlist 0/1 {
		* DG averages
		sum mmu if  prosocial==`p' & part==1 
		local mmu1_p`p' = r(mean)

		* CC main
		sum mmu if prosocial==`p' & part==2 & treatment=="main"
		local mmu2_p`p' = r(mean)
	}
	* (Equitable - less equitable in DG) - (equitable - less equitable in CC)
	return scalar diff = (`mmu1_p1'-`mmu1_p0') - (`mmu2_p1'-`mmu2_p0')
	restore
end




* ---------------------------------------------- *
* 		Bootstrap Programs
* ---------------------------------------------- *

* Do analysis for all CSAs, just happiness, and just satis
foreach sample in all happy satis { 
	* Globals to simplify the LU calculations and CSA list
	if "`sample'"=="all" {
		global lu_calc 			"guilt*_b[rel_guilt]+pride*_b[rel_pride]+finan*_b[rel_finan]+fair*_b[rel_fair]+unfair*_b[rel_unfair]+happy*_b[rel_happy]+satis*_b[rel_satis]"
		global lu_calc_wide1 	"guilt1*_b[rel_guilt]+pride1*_b[rel_pride]+finan1*_b[rel_finan]+fair1*_b[rel_fair]+unfair1*_b[rel_unfair]+happy1*_b[rel_happy]+satis1*_b[rel_satis]"
		global lu_calc_wide2 	"guilt2*_b[rel_guilt]+pride2*_b[rel_pride]+finan2*_b[rel_finan]+fair2*_b[rel_fair]+unfair2*_b[rel_unfair]+happy2*_b[rel_happy]+satis2*_b[rel_satis]"
		global lu_calc_wide3 	"guilt3*_b[rel_guilt]+pride3*_b[rel_pride]+finan3*_b[rel_finan]+fair3*_b[rel_fair]+unfair3*_b[rel_unfair]+happy3*_b[rel_happy]+satis3*_b[rel_satis]"
		global emotions			"guilt pride finan fair unfair happy satis"
	}
	if "`sample'"=="happy" {
		global lu_calc 			"happy*_b[rel_happy]"
		global lu_calc_wide1 	"happy1*_b[rel_happy]"
		global lu_calc_wide2 	"happy2*_b[rel_happy]"
		global lu_calc_wide3 	"happy3*_b[rel_happy]"
		global emotions			"happy"
	}
	if "`sample'"=="satis" {
		global lu_calc 			"satis*_b[rel_satis]"
		global lu_calc_wide1 	"satis1*_b[rel_satis]"
		global lu_calc_wide2 	"satis2*_b[rel_satis]"
		global lu_calc_wide3 	"satis3*_b[rel_satis]"
		global emotions			"satis"
	}
	
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
	}
	
	
	
	* DG AVERAGES --------------------------------------------------------------
	* All 
	bootstrap ///
		mmu_c1_p1_part1=r(mmu_c1_p1_part1) mmu_c1_p0_part1=r(mmu_c1_p0_part1) ///
		mmu_c2_p1_part1=r(mmu_c2_p1_part1) mmu_c2_p0_part1=r(mmu_c2_p0_part1) ///
		mmu_c3_p1_part1=r(mmu_c3_p1_part1) mmu_c3_p0_part1=r(mmu_c3_p0_part1) ///
		mmu_c4_p1_part1=r(mmu_c4_p1_part1) mmu_c4_p0_part1=r(mmu_c4_p0_part1) ///
		mmu_c5_p1_part1=r(mmu_c5_p1_part1) mmu_c5_p0_part1=r(mmu_c5_p0_part1) ///
		mmu_c6_p1_part1=r(mmu_c6_p1_part1) mmu_c6_p0_part1=r(mmu_c6_p0_part1) ///
		mmu_c7_p1_part1=r(mmu_c7_p1_part1) mmu_c7_p0_part1=r(mmu_c7_p0_part1), ///
		reps(1000) saving("$output_dir/logit_bootstrap_mmu_graphs_`sample'.dta", replace) ///
		seed(123450) cluster(mturkid) nodrop: prog_util
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
	gen sample="`sample'"
	
	* Temp file
	save "$bootstrapped_data/p1_`sample'.dta", replace
	restore
	
	* Chosen
	set seed 123
	bootstrap ///
		chosen_mmu_c1_p1_part1=r(chosen_mmu_c1_p1_part1) ///
		chosen_mmu_c1_p0_part1=r(chosen_mmu_c1_p0_part1) ///
		chosen_mmu_c2_p1_part1=r(chosen_mmu_c2_p1_part1) ///
		chosen_mmu_c2_p0_part1=r(chosen_mmu_c2_p0_part1) ///
		chosen_mmu_c3_p1_part1=r(chosen_mmu_c3_p1_part1) ///
		chosen_mmu_c3_p0_part1=r(chosen_mmu_c3_p0_part1) ///
		chosen_mmu_c4_p1_part1=r(chosen_mmu_c4_p1_part1) ///
		chosen_mmu_c4_p0_part1=r(chosen_mmu_c4_p0_part1) ///
		chosen_mmu_c5_p1_part1=r(chosen_mmu_c5_p1_part1) ///
		chosen_mmu_c5_p0_part1=r(chosen_mmu_c5_p0_part1) ///
		chosen_mmu_c6_p1_part1=r(chosen_mmu_c6_p1_part1) ///
		chosen_mmu_c6_p0_part1=r(chosen_mmu_c6_p0_part1) ///
		chosen_mmu_c7_p1_part1=r(chosen_mmu_c7_p1_part1) ///
		chosen_mmu_c7_p0_part1=r(chosen_mmu_c7_p0_part1), /// 
		reps(1000 ) saving("$output_dir/logit_bootstrap_chosen_mmu.dta", ///
		replace) seed(123450) cluster(mturkid) nodrop: prog_util_chosen
	estat bootstrap, all

	* Put in dataframe to graph
	preserve
	prog_mat
	gen prosocial = mod(n,2)

	* Make xaxis
	gen graph_order=n 
	foreach num of numlist 2(2)28 {
		replace graph_order=graph_order+1 if n>`num'
	}
	gen sample="`sample'"
	
	* Temp file
	save "$bootstrapped_data/chosenp1_`sample'.dta", replace
	restore
	
	
	* CC AVERAGES --------------------------------------------------------------
	bootstrap ///
		mmu_c1_p1_part2=r(mmu_c1_p1_part2) mmu_c1_p0_part2=r(mmu_c1_p0_part2) ///
		mmu_c2_p1_part2=r(mmu_c2_p1_part2) mmu_c2_p0_part2=r(mmu_c2_p0_part2) ///
		mmu_c3_p1_part2=r(mmu_c3_p1_part2) mmu_c3_p0_part2=r(mmu_c3_p0_part2) ///
		mmu_c4_p1_part2=r(mmu_c4_p1_part2) mmu_c4_p0_part2=r(mmu_c4_p0_part2) ///
		mmu_c5_p1_part2=r(mmu_c5_p1_part2) mmu_c5_p0_part2=r(mmu_c5_p0_part2) ///
		mmu_c6_p1_part2=r(mmu_c6_p1_part2) mmu_c6_p0_part2=r(mmu_c6_p0_part2) ///
		mmu_c7_p1_part2=r(mmu_c7_p1_part2) mmu_c7_p0_part2=r(mmu_c7_p0_part2), ///
		reps(1000) saving("$output_dir/logit_bootstrap_mmu_graphs_`sample'.dta", replace) ///
		seed(123450) cluster(mturkid) nodrop: prog_util
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
	gen sample="`sample'"
	
	* Temp file
	save "$bootstrapped_data/p2_`sample'.dta", replace
	restore

	
	* CC CS AVERAGES -----------------------------------------------------------
	set seed 123
	bootstrap ///
		mmu_c1_p1_part2_cs=r(mmu_c1_p1_part2_cs) mmu_c1_p0_part2_cs=r(mmu_c1_p0_part2_cs) ///
		mmu_c2_p1_part2_cs=r(mmu_c2_p1_part2_cs) mmu_c2_p0_part2_cs=r(mmu_c2_p0_part2_cs) ///
		mmu_c3_p1_part2_cs=r(mmu_c3_p1_part2_cs) mmu_c3_p0_part2_cs=r(mmu_c3_p0_part2_cs) ///
		mmu_c4_p1_part2_cs=r(mmu_c4_p1_part2_cs) mmu_c4_p0_part2_cs=r(mmu_c4_p0_part2_cs) ///
		mmu_c5_p1_part2_cs=r(mmu_c5_p1_part2_cs) mmu_c5_p0_part2_cs=r(mmu_c5_p0_part2_cs) ///
		mmu_c6_p1_part2_cs=r(mmu_c6_p1_part2_cs) mmu_c6_p0_part2_cs=r(mmu_c6_p0_part2_cs) ///
		mmu_c7_p1_part2_cs=r(mmu_c7_p1_part2_cs) mmu_c7_p0_part2_cs=r(mmu_c7_p0_part2_cs), ///
		reps(1000) saving("$output_dir/logit_bootstrap_mmu_graphs_`sample'_cs.dta", replace) ///
		seed(123450) cluster(mturkid) nodrop: prog_util
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
	gen sample="`sample'"
	
	* Temp file
	save "$bootstrapped_data/p2cs_`sample'.dta", replace
	restore
	
	
	* CC MAIN - CS -------------------------------------------------------------
	bootstrap mmu_part2_diff_p1=r(mmu_part2_diff_p1) ///
		mmu_part2_diff_p0=r(mmu_part2_diff_p0), ///
		reps(1000) saving("$output_dir/mmu_part2_diff.dta", replace) ///
		seed(123450) cluster(mturkid) nodrop: prog_utilp2_diff
	estat bootstrap, all	
	eststo bootstrap_mmu_`sample'_p2diff
	
	if "`sample'"=="all" {
		* Save some choices in latex file
		mat b = e(b)
		local dgcceq=round(b[1,1],0.01)
		local dgcceq: di %9.2f `dgcceq' 
		latex_write dgcceq `dgcceq' numbers_pipe
		local dgccleq=round(b[1,2],0.01)
		local dgccleq: di %9.2f `dgccleq' 
		latex_write dgccleq `dgccleq' numbers_pipe
		
		mat c = e(ci_percentile)
		local dgcceql=round(c[1,1],0.01)
		local dgcceql: di %9.2f `dgcceql' 
		latex_write dgcceql `dgcceql' numbers_pipe
		
		local dgccleql=round(c[1,2],0.01)
		local dgccleql: di %9.2f `dgccleql' 
		latex_write dgccleql `dgccleql' numbers_pipe
		
		local dgcceqh=round(c[2,1],0.01)
		local dgcceqh: di %9.2f `dgcceqh' 
		latex_write dgcceqh `dgcceqh' numbers_pipe
		
		local dgccleqh=round(c[2,2],0.01)
		local dgccleqh: di %9.2f `dgccleqh' 
		latex_write dgccleqh `dgccleqh' numbers_pipe
	}
	
	
	* OO AVERAGES --------------------------------------------------------------
	foreach o of numlist 3/5 {
		** Chosen and unchosen **
		set seed 123
		bootstrap ///	
			mmu_c1_p1_part3_o`o'=r(mmu_c1_p1_part3_o`o') mmu_c1_p0_part3_o`o'=r(mmu_c1_p0_part3_o`o') ///
			mmu_c1_p2_part3_o`o'=r(mmu_c1_p2_part3_o`o') mmu_c2_p1_part3_o`o'=r(mmu_c2_p1_part3_o`o') ///
			mmu_c2_p0_part3_o`o'=r(mmu_c2_p0_part3_o`o') mmu_c2_p2_part3_o`o'=r(mmu_c2_p2_part3_o`o') ///
			mmu_c3_p1_part3_o`o'=r(mmu_c3_p1_part3_o`o') mmu_c3_p0_part3_o`o'=r(mmu_c3_p0_part3_o`o') ///
			mmu_c3_p2_part3_o`o'=r(mmu_c3_p2_part3_o`o') mmu_c4_p1_part3_o`o'=r(mmu_c4_p1_part3_o`o') ///
			mmu_c4_p0_part3_o`o'=r(mmu_c4_p0_part3_o`o') mmu_c4_p2_part3_o`o'=r(mmu_c4_p2_part3_o`o'), /// 
			reps(1000) saving("$output_dir/logit_bootstrap_mmu_graphs_part3_o`o'_`sample'.dta", replace) ///
			seed(123450) cluster(mturkid) nodrop: prog_util
		estat bootstrap, all

		* Put in dataframe to graph
		preserve
		prog_mat

		* Format x axis
		gen graph_order=n
		replace graph_order=graph_order+1 if n>3
		replace graph_order=graph_order+1 if n>6
		replace graph_order=graph_order+1 if n>9
		gen sample="`sample'"
	
		* Temp file
		save "$bootstrapped_data/p3_o`o'_`sample'.dta", replace
		restore
	}
	
	
	* DIFFERENCES IN GAMES _____________________________________________________
	if "`sample'"=="all" {
		
		* Difference between the difference in equitable and less equitable mmu in DG and CC
		bootstrap diff_1=r(diff_1) diff_2=r(diff_2) diff_3=r(diff_3) ///
			diff_4=r(diff_4) diff_5=r(diff_5) diff_6=r(diff_6) ///
			diff_7=r(diff_7), ///
			reps(1000) seed(123456) cluster(mturkid) nodrop: prog_util_pdiff
		estat bootstrap, all

		preserve
		prog_mat

		gen sample="all"

		* Temp file
		save "$bootstrapped_data/diff8_all.dta", replace
		restore
		
		
		* Difference between the difference in equitable and less equitable mmu in DG and CC (average by all choice sets)
		bootstrap diff=r(diff), ///
			reps(1000) seed(123456) cluster(mturkid) nodrop: prog_util_pdiff
		estat bootstrap, all

		* Save some outcomes in latex file
		mat b = e(b)
		local dgccdiff: di %9.2f b[1,1]
		latex_write dgccdiff `dgccdiff' numbers_pipe		
		mat c = e(ci_percentile)
		local dgccdiffl: di %9.2f c[1,1]
		latex_write dgccdiffl `dgccdiffl' numbers_pipe
		local dgccdiffh: di %9.2f c[2,1]
		latex_write dgccdiffh `dgccdiffh' numbers_pipe
		
		
		* Difference between DG and OO EVs by option type
		set seed 123
		bootstrap me_diff=r(me_diff) le_diff=r(le_diff), ///
			reps(1000) seed(123456) cluster(mturkid) nodrop: prog_dg_oo_diff
		estat bootstrap, all

		* Save some choices in latex file
		mat b = e(b)
		local mediff: di %9.2f b[1,1]
		latex_write mediff `mediff' numbers_pipe
		local lediff: di %9.2f b[1,2]
		latex_write lediff `lediff' numbers_pipe
		
		mat c = e(ci_percentile)
		local mediffl: di %9.2f c[1,1]
		latex_write mediffl `mediffl' numbers_pipe
		local lediffl: di %9.2f c[1,2]
		latex_write lediffl `lediffl' numbers_pipe
		local mediffh: di %9.2f c[2,1]
		latex_write mediffh `mediffh' numbers_pipe
		local lediffh: di %9.2f c[2,2]
		latex_write lediffh `lediffh' numbers_pipe
	}
	

	
	* DG & CC DIFF -------------------------------------------------------------
	* Dataset needs to be wider (by part)
	qui {
		* Have to reshape the data a bit first
		bys mturkid choice_set prosocial: egen part1_choice_all=min(part1_choice)
		keep rel* mturkid choice_set part1_choice_all prosocial part guilt pride finan fair unfair happy satis present treatment
		reshape wide rel* guilt pride finan fair unfair happy satis, i(mturkid choice_set part1_choice_all prosocial present) j(part)

		* Create a payoff variable for choice set 4, 5, 6, and 7
		* ($4.00, $0.00), ($3.50, $0.00), ($3.00, $0.00), and ($2.00, $0.00)
		gen payoff=4 if choice_set==4 & prosocial==0
		replace payoff=3.5 if choice_set==5 & prosocial==0
		replace payoff=3 if choice_set==6 & prosocial==0
		replace payoff=2.5 if choice_set==7 & prosocial==0
		
		* Tags
		sort mturkid choice_set prosocial
		egen part_cs=tag(mturkid choice_set prosocial)
	}
	
	* When the computer chooses your option for you
	bootstrap ///
		mmudiff1_c1=r(mmudiff1_c1_type2) mmudiff0_c1=r(mmudiff0_c1) ///
		mmudiff1_c2=r(mmudiff1_c2_type2) mmudiff0_c2=r(mmudiff0_c2) ///
		mmudiff1_c3=r(mmudiff1_c3_type2) mmudiff0_c3=r(mmudiff0_c3) ///
		mmudiff1_c4=r(mmudiff1_c4_type2) mmudiff0_c4=r(mmudiff0_c4) ///
		mmudiff1_c5=r(mmudiff1_c5_type2) mmudiff0_c5=r(mmudiff0_c5) ///
		mmudiff1_c6=r(mmudiff1_c6_type2) mmudiff0_c6=r(mmudiff0_c6) ///
		mmudiff1_c7=r(mmudiff1_c7_type2) mmudiff0_c7=r(mmudiff0_c7), ///
		reps(1000) saving("$output_dir/logit_bootstrap_welfare_graphs3_`sample'.dta", ///
		replace) seed(67890) cluster(mturkid) nodrop: prog_welfare_graph2
	estat bootstrap, all
	
	* Put in dataframe to graph
	preserve
	prog_mat
	gen prosocial = mod(n,2)

	* Format x axis
	gen graph_order=n
	foreach num of numlist 2(2)14 {
		replace graph_order=graph_order+1 if n>`num'
	}
	gen sample="`sample'"
	
	* Temp file
	save "$bootstrapped_data/diff4_`sample'.dta", replace
	restore
	
	* Save average values of the prosocial choices above and save in latex
	if "`sample'"=="all" {
		bootstrap ///
			ave_cc_choice_p1=r(ave_cc_choice_p1) ///
			ave_cs_choice_p1=r(ave_cs_choice_p1) ///
			ave_cc_choice_p0=r(ave_cc_choice_p0) ///
			ave_cs_choice_p0=r(ave_cs_choice_p0), ///
			reps(1000) seed(67890) cluster(mturkid) nodrop: prog_welfare_graph2
		estat bootstrap, all
		
		* Save some choices in latex file
		mat b = e(b)
		local dgcc: di %9.2f b[1,1]
		latex_write dgcc `dgcc' numbers_pipe
		local dgcs: di %9.2f b[1,2]
		latex_write dgcs `dgcs' numbers_pipe
		local dgccle: di %9.2f b[1,3]
		latex_write dgccle `dgccle' numbers_pipe
		local dgcsle: di %9.2f b[1,4]
		latex_write dgcsle `dgcsle' numbers_pipe
		
		mat c = e(ci_percentile)
		local dgccl: di %9.2f c[1,1]
		latex_write dgccl `dgccl' numbers_pipe
		local dgcsl: di %9.2f c[1,2]
		latex_write dgcsl `dgcsl' numbers_pipe
		local dgcclel: di %9.2f c[1,3]
		latex_write dgcclel `dgcclel' numbers_pipe
		local dgcslel: di %9.2f c[1,4]
		latex_write dgcslel `dgcslel' numbers_pipe
		local dgcch: di %9.2f c[2,1]
		latex_write dgcch `dgcch' numbers_pipe
		local dgcsh: di %9.2f c[2,2]
		latex_write dgcsh `dgcsh' numbers_pipe
		local dgccleh: di %9.2f c[2,3]
		latex_write dgccleh `dgccleh' numbers_pipe
		local dgcsleh: di %9.2f c[2,4]
		latex_write dgcsleh `dgcsleh' numbers_pipe
	}
	
	* MMU differences between CC cs and DG
	bootstrap ///
		mmudiff1_c1=r(mmudiff1_c1_type2_cs) mmudiff0_c1=r(mmudiff0_c1_cs) ///
		mmudiff1_c2=r(mmudiff1_c2_type2_cs) mmudiff0_c2=r(mmudiff0_c2_cs) ///
		mmudiff1_c3=r(mmudiff1_c3_type2_cs) mmudiff0_c3=r(mmudiff0_c3_cs) ///
		mmudiff1_c4=r(mmudiff1_c4_type2_cs) mmudiff0_c4=r(mmudiff0_c4_cs) ///
		mmudiff1_c5=r(mmudiff1_c5_type2_cs) mmudiff0_c5=r(mmudiff0_c5_cs) ///
		mmudiff1_c6=r(mmudiff1_c6_type2_cs) mmudiff0_c6=r(mmudiff0_c6_cs) ///
		mmudiff1_c7=r(mmudiff1_c7_type2_cs) mmudiff0_c7=r(mmudiff0_c7_cs), ///
		reps(1000) saving("$output_dir/logit_bootstrap_welfare_graphs4_`sample'.dta", ///
		replace) seed(67890) cluster(mturkid) nodrop: prog_welfare_graph2
	estat bootstrap, all

	* Put in dataframe to graph
	preserve
	prog_mat
	gen prosocial = mod(n,2)

	* Format x axis
	gen graph_order=n
	foreach num of numlist 2(2)14 {
		replace graph_order=graph_order+1 if n>`num'
	}
	gen sample="`sample'"
	
	* Temp file
	save "$bootstrapped_data/diff5_`sample'.dta", replace
	restore
}


* OUTPUT _______________________________________________________________________


* DG Utilities -----------------------------------------------------------------
** Chosen and unchosen
use "$bootstrapped_data/p1_all.dta", clear
foreach sample in happy satis {
	append using "$bootstrapped_data/p1_`sample'.dta"
}
tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) $yscale `legend1'
graph export "$output_dir/logit_mmup1_means.pdf", replace

tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)) ///
	(rspike upper lower graph_order if prosocial==1 & sample=="happy", lcolor(ebblue%40)) ///
	(sc coef graph_order if prosocial==1 & sample=="happy", mcolor(ebblue%40) m(T)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="happy", lcolor(orange%40)) ///
	(sc coef graph_order if prosocial==0 & sample=="happy", mcolor(orange%40) m(T)) ///
	(rspike upper lower graph_order if prosocial==1 & sample=="satis", lcolor(ebblue%40)) ///
	(sc coef graph_order if prosocial==1 & sample=="satis", mcolor(ebblue%40) m(X)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="satis", lcolor(orange%40)) ///
	(sc coef graph_order if prosocial==0 & sample=="satis", mcolor(orange%40) m(X)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) $yscale `legend2'
graph export "$output_dir/logit_mmup1_means_hs.pdf", replace

** Chosen
use "$bootstrapped_data/chosenp1_all.dta", clear
foreach sample in happy satis {
	append using "$bootstrapped_data/chosenp1_`sample'.dta"
}
tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) $yscale `legend1'
graph export "$output_dir/logit_chosen_mmu_means_p1.pdf", replace


* CC Utilities -----------------------------------------------------------------
use "$bootstrapped_data/p2_all.dta", clear
foreach sample in happy satis {
	append using "$bootstrapped_data/p2_`sample'.dta"
}
tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) $yscale `legend3'
graph export "$output_dir/logit_mmup2_means.pdf", replace

tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)) ///
	(rspike upper lower graph_order if prosocial==1 & sample=="happy", lcolor(ebblue%40)) ///
	(sc coef graph_order if prosocial==1 & sample=="happy", mcolor(ebblue%40) m(T)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="happy", lcolor(orange%40)) ///
	(sc coef graph_order if prosocial==0 & sample=="happy", mcolor(orange%40) m(T)) ///
	(rspike upper lower graph_order if prosocial==1 & sample=="satis", lcolor(ebblue%40)) ///
	(sc coef graph_order if prosocial==1 & sample=="satis", mcolor(ebblue%40) m(X)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="satis", lcolor(orange%40)) ///
	(sc coef graph_order if prosocial==0 & sample=="satis", mcolor(orange%40) m(X)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) $yscale `legend4'
graph export "$output_dir/logit_mmup2_means_hs.pdf", replace


* CC CS Utilities --------------------------------------------------------------
use "$bootstrapped_data/p2cs_all.dta", clear
foreach sample in happy satis {
	append using "$bootstrapped_data/p2cs_`sample'.dta"
}

tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) $yscale `legend3'
graph export "$output_dir/logit_mmup2_means_cs.pdf", replace


* OO Utilities -----------------------------------------------------------------
foreach o of numlist 3/5 {
	if `o'==3 {
		local a "(2,1.5), (4,0)"
	}
	if `o'==4 {
		local a "(2,2), (4,0)"
	}
	if `o'==5 {
		local a "(2,2), (3.5,0)"
	}
	
	** Chosen and unchosen
	use "$bootstrapped_data/p3_o`o'_all.dta", clear
	foreach sample in happy satis {
		append using "$bootstrapped_data/p3_o`o'_`sample'.dta"
	}
	tw (rspike upper lower graph_order if inlist(n,1,4,7,10) & sample=="all", lcolor(ebblue)) ///
		(sc coef graph_order if inlist(n,1,4,7,10) & sample=="all", mcolor(ebblue)) ///
		(rspike  upper lower graph_order if inlist(n,2,5,8,11) & sample=="all", lcolor(orange)) ///
		(sc coef graph_order if inlist(n,2,5,8,11) & sample=="all", mcolor(orange)) ///
		(rspike  upper lower graph_order if inlist(n,3,6,9,12) & sample=="all", lcolor(cranberry)) ///
		(sc coef graph_order if inlist(n,3,6,9,12) & sample=="all", mcolor(cranberry)), ///
		ytitle("$ytitle", size(small)) $yscale $xaxis_p3 ///
		xtitle("Opt-In Subgame: `a'", height(5)) ///
		legend(order(2 "More Equitable" "in DG Subgame" 4 "Less Equitable" ///
		"in DG Subgame" 6 "Opt-Out") size(vsmall))
	graph export "$output_dir/logit_mmup3_o`o'_means.pdf", replace
	
	tw (rspike upper lower graph_order if inlist(n,1,4,7,10) & sample=="all", lcolor(ebblue)) ///
		(sc coef graph_order if inlist(n,1,4,7,10) & sample=="all", mcolor(ebblue)) ///
		(rspike  upper lower graph_order if inlist(n,2,5,8,11) & sample=="all", lcolor(orange)) ///
		(sc coef graph_order if inlist(n,2,5,8,11) & sample=="all", mcolor(orange)) ///
		(rspike  upper lower graph_order if inlist(n,3,6,9,12) & sample=="all", lcolor(cranberry)) ///
		(sc coef graph_order if inlist(n,3,6,9,12) & sample=="all", mcolor(cranberry)) ///
		(rspike upper lower graph_order if inlist(n,1,4,7,10) & sample=="happy", lcolor(ebblue%40)) ///
		(sc coef graph_order if inlist(n,1,4,7,10) & sample=="happy", mcolor(ebblue%40) m(T)) ///
		(rspike  upper lower graph_order if inlist(n,2,5,8,11) & sample=="happy", lcolor(orange%40)) ///
		(sc coef graph_order if inlist(n,2,5,8,11) & sample=="happy", mcolor(orange%40) m(T)) ///
		(rspike  upper lower graph_order if inlist(n,3,6,9,12) & sample=="happy", lcolor(cranberry%40)) ///
		(sc coef graph_order if inlist(n,3,6,9,12) & sample=="happy", mcolor(cranberry%40) m(T)) ///
		(rspike upper lower graph_order if inlist(n,1,4,7,10) & sample=="satis", lcolor(ebblue%40)) ///
		(sc coef graph_order if inlist(n,1,4,7,10) & sample=="satis", mcolor(ebblue%40) m(X)) ///
		(rspike  upper lower graph_order if inlist(n,2,5,8,11) & sample=="satis", lcolor(orange%40)) ///
		(sc coef graph_order if inlist(n,2,5,8,11) & sample=="satis", mcolor(orange%40) m(X)) ///
		(rspike  upper lower graph_order if inlist(n,3,6,9,12) & sample=="satis", lcolor(cranberry%40)) ///
		(sc coef graph_order if inlist(n,3,6,9,12) & sample=="satis", mcolor(cranberry%40) m(X)), ///
		ytitle("$ytitle", size(small)) $yscale $xaxis_p3 ///
		xtitle("Opt-In Subgame: `a'", height(5))  ///
		legend(order(2 "All CSAs, More Equitable" 4 ///
		"All CSAs, Less Equitable" "in DG Subgame" ///
		6 "All CSAs, Opt-Out" 8 "Happiness, More Equitable" "in DG Subgame" ///
		10 "Happiness, Less Equitable" "in DG Subgame" 12 "Happiness, Opt-Out" ///
		14 "Satisfaction, More Equitable" "in DG Subgame" 16 ///
		"Satisfaction, Less Equitable" "in DG Subgame" ///
		18 "Satisfaction, Opt-Out") size(vsmall))
	graph export "$output_dir/logit_mmup3_o`o'_means_hs.pdf", replace
	
}



* DG & CC DIFF -----------------------------------------------------------------

global ytitle {&Delta}u`overline'{sub:jc} (in $)

* How much better off if computer chose your option for you
use "$bootstrapped_data/diff4_all.dta", clear
tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) yscale(range(-2 3)) ylab(-2(1)3)  ///
	`legend1' yli(0)
graph export "$output_dir/logit_mmudiff2_part2.pdf", replace

* How much better off if computer chose your option for you
use "$bootstrapped_data/diff5_all.dta", clear
tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
	(sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
	(sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) ///
	yscale(range(-2 3)) ylab(-2(1)3) yli(0) `legend1'
graph export "$output_dir/logit_mmudiff2_part2_cs.pdf", replace



* Difference between the difference in equitable and less equitable mmu in DG and CC
use "$bootstrapped_data/diff8_all.dta", clear
tw (rspike upper lower n if sample=="all", lcolor(emerald)) ///
	(sc coef n if sample=="all", mcolor(emerald)), ///
	legend(off) xtitle("") ytitle("Difference in $ytitle", size(small)) ///
	xlab(1 `""DG1" "(2,0.5), (4,0)""' 2`""DG2" "(2,1), (4,0)""' ///
	3 `""DG3" "(2,1.5), (4,0)""' 4 `""DG4" "(2,2), (4,0)""' ///
	5 `""DG5" "(2,2), (3.5,0)""' 6 `""DG6" "(2,2), (3,0)""' ///
	7 `""DG7" "(2,2), (2.5,0)""', labsize(vsmall)) 
graph export "$output_dir/logit_mmudiff_p0p1_part12.pdf", replace


* Get additional values for the paper
do "$code_dir/Welfare-values.do"
do "$code_dir/Heterogeneous-MU.do"




















