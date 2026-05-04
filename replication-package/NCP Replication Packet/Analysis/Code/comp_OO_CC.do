*------------------------------------
*	Compare OO and CC w Survey
*------------------------------------

* Open data and clean (person by choice set level)
use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
* Keep main treatment
keep if inlist(treatment,"main")
qui {
	
	* Make descriptive variables and xtset
	egen id=group(mturkid)
	xtset id
	
	* Reshape - person by choice level
	reshape long guilt pride finan fair unfair happy satis, ///
		i(mturkid choice_set part present) j(prosocial) string
	replace prosocial="1" if prosocial=="_p1"
	replace prosocial="0" if prosocial=="_p0"
	replace prosocial="2" if prosocial=="_p2"
	destring prosocial, force replace
	
	* Drop choices with no data
	drop if guilt==.
	drop present randomid *_description
}

* Within person analysis
* Opt out for $4, $3.50 or $3.00 -> choice_set = 2, 3, 4 of part = 3
* CC -> part==2 -> choice_set = 4($4), 5($3.5), 6($3)
* part3_choice = 0 (less equitable), 1 (equitable), 2 (opt out)

replace choice_set=6 if choice_set==4 & part==3
replace choice_set=5 if choice_set==3 & part==3
replace choice_set=4 if choice_set==2 & part==3

replace part1_choice=. if part!=1
bys mturkid choice_set: egen temp=min(part1_choice)
replace part1_choice=temp
drop temp

* Make a variable that says what choice you made in the DG for the same game you were offered in the opt-out
gen temp=part1_choice if choice_set==optout_allocation
bys mturkid: egen dgoo_choice=min(temp)
drop temp

* Keep only less equitable choice set in part 2, and opt out choice in part 3
keep if inlist(part,2,3) // computer choice and opt-out
keep if inrange(choice_set,4,6) // $4, $3.50 or $3.00
drop if part==2 & prosocial==1 // get rid of prosocial allocations
drop if part==3 & prosocial!=2 // only keep opt-out option in part 3
drop prosocial

replace part3_choice=. if part!=3

* Make part 3 choice a global variable so it will reshape better
bys mturkid choice_set: egen temp=min(part3_choice)
replace part3_choice=temp

* Reshape so that we have person by $4/$3.5/$3
reshape wide guilt pride finan fair unfair happy satis, ///
		i(mturkid choice_set part1_choice part3_choice dgoo_choice) j(part)

* Make a payoff variable
gen payoff=4 if choice_set==4 
replace payoff=3.5 if choice_set==5
replace payoff=3 if choice_set==6 

* optout_allocation = other choice set in opt out game (in case you need but not immediate)

* (4i) = splitting by what they chose in part 1 (part1_choice) and if they have the same allocation
** same thing as above, but keep if dgoo_choice==1
* (4ii) same thing as above, but keep if dgoo_choice==0


* Graph difference in options for everyone
drop if dgoo_choice ==. // drop those that did not see the OO module

* Save values
sum dgoo_choice if dgoo_choice==1
local mainthreegive = r(N)/3

sum dgoo_choice if dgoo_choice==0
local mainthreenotgive = r(N)/3

latex_write mainthreegive `mainthreegive' survey_numbers
latex_write mainthreenotgive `mainthreenotgive' survey_numbers

est clear

foreach e in guilt pride fair unfair finan satis happy {
	
	* All participants
	gen diff_`e' = `e'3 - `e'2
	eststo m_all_`e' : mean diff_`e'
	
	drop diff*
	
	* Only those who chose to share in part 3
	gen diff_`e' = `e'3 - `e'2 if part3_choice==1 
	eststo m_share3_`e' : mean diff_`e'
	
	drop diff*
	
	* Only those who chose not to share or OO in part 3 
	gen diff_`e' = `e'3 - `e'2 if (part3_choice==0 | part3_choice ==2)
	eststo m_noshare3_`e' : mean diff_`e'
	
	drop diff*
	
	* Only those who chose to share in 1
	gen diff_`e' = `e'3 - `e'2 if dgoo_choice==1
	eststo m_share1_`e' : mean diff_`e'
	
	drop diff*
	
	* Only those who chose not to share in 1
	gen diff_`e' = `e'3 - `e'2 if dgoo_choice==0
	eststo m_noshare1_`e' : mean diff_`e'
}

foreach prefix in m_share1 m_noshare1 {

coefplot (`prefix'_happy, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
	(`prefix'_satis, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
	(`prefix'_finan, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
	(`prefix'_pride, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
	(`prefix'_fair, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///	
	(`prefix'_guilt, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
	(`prefix'_unfair, mcolor(midblue) ciopts(color(midblue) recast(rcap))) , ///
	ytitle("Mean Difference in Ratings") xsc(range(0.5 7.5)) vertical ///
	xlab(1 "Happiness" 2 "Satisfaction" 3 `""Financial" "Satisfaction""' 4 "Pride" ///
	5 "Fair" 6 "Guilt" 7 "Unfair", labsize(small)) ///
	legend(off) graphregion(fcolor(white)) ylab(-0.2(0.1)0.4) ysc(range(-0.2 0.4))
	
graph export "$output_dir/mean_diff_`prefix'.png", replace
}
