/* _____________________________________________________________________________

	CLEAN MTURK DATA
	
	Objective: We want to clean the MTurk data so it is in the person-question 
	(long) level and the person-choice set level (wide).
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

* Open each treatment
foreach treatment in main pf cs exante {
	* Open data
	use "$raw_data_dir/`treatment'.dta", clear

	* Clean
	do "$build_dir/Clean-`treatment'.do"
}




* ---------------------------------------------- *
* 			Clean analysis dataset
* ---------------------------------------------- *

* Wide
capture confirm file "$prepped_data_dir/mturk_all_wide_analysis.dta"
if _rc!=0 {
	
	* APPEND DATA ______________________________________________________________
	use "$prepped_data_dir/mturk_main_wide.dta", clear
	gen treatment = "main"
	append using "$prepped_data_dir/mturk_cs_wide.dta"
	replace treatment = "cs" if treatment==""
	append using "$prepped_data_dir/mturk_exante_wide.dta"
	replace treatment = "exante" if treatment==""
	append using "$prepped_data_dir/mturk_pf_wide.dta"
	replace treatment = "pf" if treatment==""
	drop prosocial_p2

	* Label variables
	prog_label

	* REFORMAT _________________________________________________________________
	* Normalize emotions 
	foreach var of varlist guilt* pride*  finan* fair* unfair* happy* satis* {
		replace `var'=(`var'-1)/4 
	}

	* Tag one obs per mturkid to get person-level indicator
	egen tag_id = tag(mturkid)
	
	* Repeat CC ratings across choice sets that have the same choice (for graphing)
	foreach emotion in guilt pride finan fair unfair happy satis {
		* Assign (4,0) to less equitable choices of choice set 1-4
		gen temp=`emotion'_p0 if choice_set==4 & part==2
		bys mturkid: egen temp2=min(temp)
		replace `emotion'_p0=temp2 if choice_set<4 & part==2 & `emotion'_p0==. & treatment!="cs"
		drop temp*
		
		* Assign (2,2) to equitable choices of choice set 5-7
		gen temp=`emotion'_p1 if choice_set==4  & part==2
		bys mturkid: egen temp2=min(temp)
		replace `emotion'_p1=temp2 if choice_set>4 & part==2 & `emotion'_p1==. & treatment!="cs"
		drop temp*
	}
	
	* Indicator if they saw OO (i.e. part 3)
	bys mturkid: egen part3=min(part3_choice)
	replace part3=1 if part3!=.
	replace part3=0 if part3==.
	
	* Save
	save "$prepped_data_dir/mturk_all_wide_analysis.dta", replace
}

* Long
capture confirm file "$prepped_data_dir/mturk_all_long_analysis.dta"
if _rc!=0 {
	
	* APPEND DATA ______________________________________________________________
	use "$prepped_data_dir/mturk_main_long.dta", clear
	gen treatment = "main"
	append using "$prepped_data_dir/mturk_cs_long.dta"
	replace treatment = "cs" if treatment==""
	append using "$prepped_data_dir/mturk_exante_long.dta"
	replace treatment = "exante" if treatment==""
	append using "$prepped_data_dir/mturk_pf_long.dta"
	replace treatment = "pf" if treatment==""
	drop temp prosocial_p2
	
	* Label variables
	prog_label

	* REFORMAT _________________________________________________________________
	* Normalize emotions from 0 to 1 
	replace rating=(rating-1)/4

	* Reshape
	reshape wide rating, i(mturkid prosocial choice_set part present) j(emotion) string
	reshape wide ratingguilt ratingpride ratingfinan ratingfair ratingunfair ///
		ratingsatis ratinghappy, i(mturkid prosocial choice_set present) j(part)

	* Repeat CC ratings across choice sets that have the same choice (for graphing)
	foreach emotion in guilt pride finan fair unfair happy satis {
		
		* Assign (4,0) to less equitable choices of choice set 1-4
		gen temp=rating`emotion'2 if choice_set==4 & prosocial==0
		bys mturkid: egen temp2=min(temp)
		replace rating`emotion'2=temp2 if choice_set<4 & prosocial==0 & rating`emotion'2==. & treatment!="cs"
		drop temp*
		
		* Assign (2,2) to equitable choices of choice set 5-7
		gen temp=rating`emotion'2 if choice_set==4 & prosocial==1
		bys mturkid: egen temp2=min(temp)
		replace rating`emotion'2=temp2 if choice_set>4 & prosocial==1 & rating`emotion'2==. & treatment!="cs"
		drop temp*
	}

	* Save
	save "$prepped_data_dir/mturk_all_long_analysis.dta", replace
}
	






























