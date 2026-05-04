/* _____________________________________________________________________________

	CLEAN MTURK DATA
	
	This is the cleaning code that will not be published
_____________________________________________________________________________ */

* ---------------------------------------------- *
* 			Programs
* ---------------------------------------------- *

* Label variables
cap program drop prog_label
program define prog_label
	* Household income
	label define hhinc 1 "\$0 - $19,999" ///
		2 "\$20,000 - $39,999" ///
		3 "\$40,000 - $59,999" ///
		4 "\$60,000 - $79,999" ///
		5 "\$80,000 - $99,999" ///
		6 "\$100,000 - $119,999" ///
		7 "\$120,000 or more"
	label val hhinc hhinc
	
	* Education group
	label define educ 1 "High school graduate" ///
		2 "Some college" ///
		3 "Vocational / trade / technical school" ///
		4 "Bachelor's degree" ///
		5 "Advanced degree" ///
		6 "Decline to state" ///
		7 "Less than high school"
	label val educ educ
	
	* Gender
	label define gender 1 "Female" 2 "Male" ///
		3 "Other" 4 "Decline to state" 
	label val gender gender
	
	* Age groups
	label define age 1 "18 - 24" 2 "25 - 39" ///
		3 "40 - 60" 4 "60+" 5 "Decline to state" 
	label val age age
	
	* Part of the experiment (DG vs CC vs OO)
	label define part 1 "DG" 2 "CC" 3 "OO"
	label val part part
	
	* Choices
	label define choice 1 "equitable" 0 "less equitable"
	label val part1_choice choice
	label val part3_choice choice
end



* ---------------------------------------------- *
* 			Clean individual raw data
* ---------------------------------------------- *

* Open each module
local count=0
foreach module in main pf cs exante {
	* Import data
	import delimited "$raw_data_dir/qualtrics_`module'.csv", bindquote(strict) varnames(1) clear

	* Keep accepted workers (workers who did not fail attention checks, etc.)
	merge m:1 mturkid using "$prepped_data_dir/accepted_workers_all.dta", keep(matched) nogen
	drop if mturkid==""
	gsort -progress //one mturker refreshed the first page on accident so has two entries, keep finished entry
	duplicates drop mturkid, force 
	
	* Drop superfluous variables
	drop startdate-q_relevantidlaststartdate randomizer_* example ///
		attention_check_* comments concerns draw* arm ///
		choice_question-backbutton_p3q3 randomid completed assignmentid  
		
	* Get order data
	tostring fl_*, replace
	
	if inlist("`module'","main","cs") {
		* Save order data under same variable to make easier
		foreach var in 524 479 432 {
			replace fl_408=fl_`var' if fl_408=="" | fl_408=="."
			drop fl_`var'
		}

		foreach var in 527 482 435 {
			replace fl_68=fl_`var' if fl_68=="" | fl_68=="."
			drop fl_`var'
		}

		foreach var in 537 492 445 {
			replace fl_283=fl_`var' if fl_283=="" | fl_283=="."
			drop fl_`var'
		}

		foreach var in 399 403 510 516 {
			replace fl_391=fl_`var' if fl_391=="" | fl_391=="."
			drop fl_`var'
		}

		* Generate a variable if DG vs CC seen first
		gen arm=(inlist(fl_408,"FL_409|FL_410|FL_420","FL_409|FL_420|FL_410","FL_420|FL_409|FL_410","FL_433|FL_443","FL_525|FL_535"))
		
		* Generate a variable if DG or CC or OO seen first
		gen dg_first=(inlist(fl_408,"FL_409|FL_410|FL_420","FL_409|FL_420|FL_410","FL_433|FL_443","FL_525|FL_535"))
		gen cc_first=(inlist(fl_408,"FL_410|FL_409|FL_420","FL_410|FL_420|FL_409","FL_443|FL_433","FL_535|FL_525"))
		gen oo_first=(inlist(fl_408,"FL_420|FL_409|FL_410","FL_420|FL_410|FL_409"))
		replace oo_first=. if inlist(fl_408,"FL_433|FL_443","FL_443|FL_433","FL_525|FL_535","FL_535|FL_525")
	}
	drop fl_*

	save "$raw_data_dir/qualtrics_`module'.dta", replace
	
	* Anonymize mturk id
	drop mturkid
	gen mturkid=_n+`count'
	
	save "$raw_data_dir/`module'.dta", replace
	
	sum mturkid
	local total=r(max)
	local count=`count'+`total'
}




















