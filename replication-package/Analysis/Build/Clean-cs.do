/* _____________________________________________________________________________

	CLEAN CS MODULE

	Objective: Data is very wide and staggered; collapse and shorten data for
	analysis by renaming and reshaping. This file is the same as Clean-main.do
	but the only difference is the name of the file that is saved
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Clean choice data
* ---------------------------------------------- *
* Ratings are split according to their choice
* We want all data under one variable so we can match the emotions and reshape
* Loop through each repeated variable to put under one column

* Looping through CSAs
foreach e of numlist 1/7 {
	* DG
	* Loop through choice sets
	foreach q of numlist 1/7 {
		* Stack the equitable/less equitable ratings in one column
		replace part1_q`q'_p1_`e'=part1_q`q'_p12_`e' if part1_q`q'_p12_`e'!=.
		replace part1_q`q'_p0_`e'=part1_q`q'_p02_`e' if part1_q`q'_p02_`e'!=.
		
		drop part1_q`q'_p12_`e' part1_q`q'_p02_`e'
	}
	
	* OO
	* Loop through choice sets
	foreach q of numlist 3/5 {
		* Loop through opt-out allocations
		foreach o of numlist 1/4 {
			* Stack the equitable/less equitable/oo ratings in one column
			replace part3_q`q'_o`o'_p1_`e'=part3_q`q'_o`o'_p12_`e' if part3_q`q'_o`o'_p12_`e'!=.
			replace part3_q`q'_o`o'_p0_`e'=part3_q`q'_o`o'_p02_`e' if part3_q`q'_o`o'_p02_`e'!=.
			replace part3_q`q'_o`o'_p2_`e'=part3_q`q'_o`o'_p22_`e' if part3_q`q'_o`o'_p22_`e'!=.
			
			drop part3_q`q'_o`o'_p12_`e' part3_q`q'_o`o'_p02_`e' part3_q`q'_o`o'_p22_`e'
		}
	}
}


* Make one variable for part 3 choice
* Loop through each choice sets
foreach q of numlist 3/5 {
	* Loop through opt out allocations
	foreach o of numlist 1/4 {
		gen part3_a`q'_o`o'=part3_q`q'_in`o'
		replace part3_a`q'_o`o'=part3_q`q'_out`o' if part3_q`q'_out`o'!=.
		drop part3_q`q'_in`o' part3_q`q'_out`o'
	}
}


* ---------------------------------------------- *
* 	Reshape to person-choice set level
* ---------------------------------------------- *

* Make long ____________________________________________________________________
* We want the data to be person-choice set level
* Must first disaggregate by CSAs
reshape long ///
	part1_q1_p0_ part1_q1_p1_ part1_q2_p0_ part1_q2_p1_ ///
	part1_q3_p0_ part1_q3_p1_ part1_q4_p0_ part1_q4_p1_ ///
	part1_q5_p0_ part1_q5_p1_ part1_q6_p0_ part1_q6_p1_ ///
	part1_q7_p0_ part1_q7_p1_  ///
	part2_q1_p0_ part2_q1_p1_ part2_q2_p0_ part2_q2_p1_ ///
	part2_q3_p0_ part2_q3_p1_ part2_q4_p0_ part2_q4_p1_ ///
	part2_q5_p0_ part2_q5_p1_ part2_q6_p0_ part2_q6_p1_ ///
	part2_q7_p0_ part2_q7_p1_  ///
	part3_q3_o1_p0_ part3_q3_o1_p1_ part3_q3_o1_p2_ ///
	part3_q4_o1_p0_ part3_q4_o1_p1_ part3_q4_o1_p2_ ///
	part3_q5_o1_p0_ part3_q5_o1_p1_ part3_q5_o1_p2_ ///
	part3_q3_o2_p0_ part3_q3_o2_p1_ part3_q3_o2_p2_ ///
	part3_q4_o2_p0_ part3_q4_o2_p1_ part3_q4_o2_p2_ ///
	part3_q5_o2_p0_ part3_q5_o2_p1_ part3_q5_o2_p2_ ///
	part3_q3_o3_p0_ part3_q3_o3_p1_ part3_q3_o3_p2_ ///
	part3_q4_o3_p0_ part3_q4_o3_p1_ part3_q4_o3_p2_ ///
	part3_q5_o3_p0_ part3_q5_o3_p1_ part3_q5_o3_p2_ ///
	part3_q3_o4_p0_ part3_q3_o4_p1_ part3_q3_o4_p2_ ///
	part3_q4_o4_p0_ part3_q4_o4_p1_ part3_q4_o4_p2_ ///
	part3_q5_o4_p0_ part3_q5_o4_p1_ part3_q5_o4_p2_, ///	
	i(mturkid) j(emotion) string

* Now we want to assign the right CSAs (CSA orders were randomized by person)
foreach num of numlist 1/7 {
	replace emotion="guilt"  if e`num'=="Guilt" & emotion=="`num'"
	replace emotion="pride"  if e`num'=="Pride" & emotion=="`num'"
	replace emotion="finan"  if e`num'=="Financial Satisfaction" & emotion=="`num'"
	replace emotion="fair" 	 if e`num'=="A Sense of Fairness" & emotion=="`num'"
	replace emotion="unfair" if e`num'=="A Sense of Unfairness" & emotion=="`num'"
	replace emotion="happy"  if e`num'=="Happiness" & emotion=="`num'"
	replace emotion="satis"  if e`num'=="Satisfaction with Study Experience" & emotion=="`num'"
}
drop e1-e7
	
* Now disaggregate by equitable vs less equitable
reshape long part1_q1 part1_q2 part1_q3 part1_q4 part1_q5 part1_q6 part1_q7 ///
	part2_q1 part2_q2 part2_q3 part2_q4 part2_q5 part2_q6 part2_q7 ///
	part3_q3_o1 part3_q4_o1 part3_q5_o1 ///
	part3_q3_o2 part3_q4_o2 part3_q5_o2 ///
	part3_q3_o3 part3_q4_o3 part3_q5_o3 ///
	part3_q3_o4 part3_q4_o4 part3_q5_o4, ///	
	i(mturkid emotion) j(type) string
	
* Get a prosocial variable (1 if equitable or 0 is less equitable)
gen prosocial=.
replace prosocial=1 if type=="_p1_"
replace prosocial=0 if type=="_p0_"
replace prosocial=2 if type=="_p2_"
drop type
	
* Reshape long (again again) to get CSAs with each choice set
reshape long part1_a part3_a3_o part3_a4_o part3_a5_o ///
	part1_q part2_q part3_q3_o part3_q4_o part3_q5_o, ///
	i(mturkid emotion prosocial) j(choice_set) 

* Rename variables to be more descriptive
rename part1_q rating1
rename part2_q rating2

* Put CSA ratings in OO in one column, regardless of opt out choice
gen rating3=part3_q3_o
replace rating3=part3_q4_o if rating3==.
replace rating3=part3_q5_o if rating3==.
gen part3_a=part3_a3_o
replace part3_a=part3_a4_o if part3_a==.
replace part3_a=part3_a5_o if part3_a==.

* Generate choice variable for DG and OO for all choice sets
bys mturkid choice_set: egen part1_choice=min(part1_a)
bys mturkid choice_set: egen part3_choice=min(part3_a)
drop *_a *_o

* Get part which tells us if we are looking at DG, CC, or OO
drop if rating1==. & rating2==. & rating3==.
reshape long rating, i(mturkid emotion prosocial choice_set) j(part)
drop if rating==.

save "$prepped_data_dir/mturk_cs_long.dta", replace


* Make wide ____________________________________________________________________
* Create person-choice set level data
reshape wide rating, i(mturk part choice_set prosocial) j(emotion) string
reshape wide rating*, i(mturk part choice_set) j(prosocial) 

* Rename CSA ratings to be shorter and more descriptive
foreach emotion in guilt pride finan fair unfair happy satis {
	rename rating`emotion'1 `emotion'_p1
	rename rating`emotion'0 `emotion'_p0
	rename rating`emotion'2 `emotion'_p2
}

save "$prepped_data_dir/mturk_cs_wide.dta", replace
