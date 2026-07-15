/* _____________________________________________________________________________

	CLEAN PRESENT-FUTURE MODULE

	Objective: Data is very wide and staggered; collapse and shorten data for
	analysis by renaming and reshaping. 
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
		* Loop through the PF module
		foreach pf in 1 2 {
			* Stack the equitable/less equitable ratings in one column
			replace part1_q`q'_p1`pf'_`e'=part1_q`q'_p12`pf'_`e' if part1_q`q'_p12`pf'_`e'!=.
			replace part1_q`q'_p0`pf'_`e'=part1_q`q'_p02`pf'_`e' if part1_q`q'_p02`pf'_`e'!=.
			
			drop part1_q`q'_p12`pf'_`e' part1_q`q'_p02`pf'_`e'
		}
	}
}



* ---------------------------------------------- *
* 	Reshape to person-choice set level
* ---------------------------------------------- *

* Make long ____________________________________________________________________
* We want the data to be person-choice set level
* Must first disaggregate by CSAs
reshape long ///
	part1_q1_p01_ part1_q1_p11_ part1_q1_p02_ part1_q1_p12_ ///
	part1_q2_p01_ part1_q2_p11_ part1_q2_p02_ part1_q2_p12_ ///
	part1_q3_p01_ part1_q3_p11_ part1_q3_p02_ part1_q3_p12_ ///
	part1_q4_p01_ part1_q4_p11_ part1_q4_p02_ part1_q4_p12_ ///
	part1_q5_p01_ part1_q5_p11_ part1_q5_p02_ part1_q5_p12_ ///
	part1_q6_p01_ part1_q6_p11_ part1_q6_p02_ part1_q6_p12_ ///
	part1_q7_p01_ part1_q7_p11_ part1_q7_p02_ part1_q7_p12_ ///
	part2_q1_p01_ part2_q1_p11_ part2_q1_p02_ part2_q1_p12_ ///
	part2_q2_p01_ part2_q2_p11_ part2_q2_p02_ part2_q2_p12_ ///
	part2_q3_p01_ part2_q3_p11_ part2_q3_p02_ part2_q3_p12_ ///
	part2_q4_p01_ part2_q4_p11_ part2_q4_p02_ part2_q4_p12_ ///
	part2_q5_p01_ part2_q5_p11_ part2_q5_p02_ part2_q5_p12_ ///
	part2_q6_p01_ part2_q6_p11_ part2_q6_p02_ part2_q6_p12_ ///
	part2_q7_p01_ part2_q7_p11_ part2_q7_p02_ part2_q7_p12_, ///	
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
	
* Separate by present/future
reshape long ///
	part1_q1_p0 part1_q1_p1 part1_q2_p0 part1_q2_p1 ///
	part1_q3_p0 part1_q3_p1 part1_q4_p0 part1_q4_p1 ///
	part1_q5_p0 part1_q5_p1 part1_q6_p0 part1_q6_p1 ///
	part1_q7_p0 part1_q7_p1 part2_q1_p0 part2_q1_p1 ///
	part2_q2_p0 part2_q2_p1 part2_q3_p0 part2_q3_p1 ///
	part2_q4_p0 part2_q4_p1 part2_q5_p0 part2_q5_p1 ///
	part2_q6_p0 part2_q6_p1 part2_q7_p0 part2_q7_p1, ///	
	i(mturkid emotion) j(present) string	
replace present="1" if present=="1_"
replace present="0" if present=="2_"
destring present, replace
	
* Now disaggregate by equitable vs less equitable
reshape long ///
	part1_q1_p part1_q2_p part1_q3_p part1_q4_p ///
	part1_q5_p part1_q6_p part1_q7_p part2_q1_p ///
	part2_q2_p part2_q3_p part2_q4_p part2_q5_p ///
	part2_q6_p part2_q7_p, ///		
	i(mturkid emotion present) j(prosocial)

* Reshape long (again again) to get CSAs with each choice set
reshape long part1_a part1_q part2_q, ///
	i(mturkid emotion prosocial present) j(choice_set) string
replace choice_set = subinstr(choice_set, "_p", "",.) 
destring choice_set, replace

* Rename variables to be more descriptive
rename part1_q rating1
rename part2_q rating2
bys mturkid emotion prosocial present choice_set: egen part1_choice=min(part1_a)
drop part1_a

* Get part which tells us if we are looking at DG, CC, or OO
drop if rating1==. & rating2==.
reshape long rating, i(mturkid emotion prosocial choice_set present) j(part)

* Merge in the question order data
drop if rating==.

save "$prepped_data_dir/mturk_pf_long.dta", replace


* Make wide ____________________________________________________________________
* Create person-choice set level data
reshape wide rating, i(mturk part choice_set prosocial present) j(emotion) string
reshape wide rating*, i(mturk part choice_set present) j(prosocial) 

* Rename CSA ratings to be shorter and more descriptive
foreach emotion in guilt pride finan fair unfair happy satis {
	rename rating`emotion'1 `emotion'_p1
	rename rating`emotion'0 `emotion'_p0
}

drop temp
save "$prepped_data_dir/mturk_pf_wide.dta", replace













