*------------------------------------
*	Supplementary Survey 2
*------------------------------------


***********
* CLEANING
***********

import excel "$raw_data_dir/JPE Revision Survey 2 Final.xlsx", firstrow case(lower) clear

drop if _n ==1
keep in -500/l

drop if attention_check != "" // Drop those who failed attention check
drop attention_check
drop if progress!="100"
drop if id==.

keep durationinseconds p1_health_choice - id

* Drop AI-generated responses
preserve 

do "$code_dir/AI-flag-Survey2.do"

drop if ai_flag ==1

keep id

tempfile ids

save `ids', replace

restore

merge 1:1 id using `ids', keep(match) nogen

* Save number of participants 
local stwoparticipants = _N

latex_write stwoparticipants `stwoparticipants' survey_numbers

destring durationinseconds, replace
replace durationinseconds = durationinseconds/60
rename durationinseconds durationinmins

sum durationinmins
local stwoduration : di %3.1f r(mean) 

latex_write stwoduration `stwoduration' survey_numbers

* Prep to reshape long
foreach choicetype in finan career health {
	split p1_`choicetype'_category, parse(.,) generate(p1_`choicetype'_category)
	
	drop p1_`choicetype'_category
}

* Reshape long
reshape long p1_finan_category p1_career_category p1_health_category, i(id) j(ob_num) string

* Recode emotion categories
la define p1_cats 1 `" "I experience negative emotions" "such as stress, anxiety, fear." "' ///
			2 "It makes me feel overwhelmed." 3 "I don't have the time." ///
			4 `" "I am averse to how" "complex this task is." "' ///
			5 "I procrastinate." 6 "I think this kind of planning is futile." ///
			7 `" "I do not need to spend a lot of time" "on this to make good decisions." "' 8 "Other"

foreach choicetype in finan career health {
	replace p1_`choicetype'_category=subinstr(p1_`choicetype'_category,".","",.)
	
	replace p1_`choicetype'_category = "1" if p1_`choicetype'_category == ///
		"I experience negative emotions such as stress, anxiety, fear"
	replace p1_`choicetype'_category = "2" if p1_`choicetype'_category == ///
		"It makes me feel overwhelmed"
	replace p1_`choicetype'_category = "3" if substr(p1_`choicetype'_category,9,4) == "t ha"
	replace p1_`choicetype'_category = "4" if p1_`choicetype'_category == ///
		"I am averse to how complex this task is"
	replace p1_`choicetype'_category = "5" if p1_`choicetype'_category == ///
		"I procrastinate"
	replace p1_`choicetype'_category = "6" if p1_`choicetype'_category == ///
		"I think this kind of planning is futile"
	replace p1_`choicetype'_category = "7" if substr(p1_`choicetype'_category,9,4) =="t ne"
	replace p1_`choicetype'_category = "8" if p1_`choicetype'_category == "Other"
	
	destring p1_`choicetype'_category, replace

	la val p1_`choicetype'_category p1_cats
}

* Destring, recode
la define yesno 1 "Yes" 2 "No"

foreach choicetype in finan career health {
	replace p1_`choicetype'_choice = "1" if p1_`choicetype'_choice == "Yes"
	replace p1_`choicetype'_choice = "2" if p1_`choicetype'_choice == "No"

	destring p1_`choicetype'_choice, replace
	
	la val p1_`choicetype'_choice yesno
	la val p1_`choicetype'_choice yesno
}

forval i = 1/11 {
	rename q90_`i' p2_reminder_signup_health_`i'
	rename q92_`i' p2_reminder_govt_health_`i'
	rename q94_`i' p2_reminder_signup_career_`i'
	rename q96_`i' p2_reminder_govt_career_`i'
	rename p2_reminder_signup_`i' p2_reminder_signup_finan_`i' 
	rename p2_reminder_govt_`i' p2_reminder_govt_finan_`i'
}

forval num = 1/11 {
	replace e`num' = "selfworth" if e`num' == "Self-Worth"
}

* Recode scores for each emotion
foreach emotion in Satisfaction Fear selfworth Pride Anxiety Guilt Dignity Happiness Regret Anger Irritation {
	
	foreach type in finan career health {
		gen `emotion'_`type'_plan = p2_`type'_csa1_1 if e1 == "`emotion'"	
		gen `emotion'_`type'_pl_t = p2_`type'_csa2_1 if e1 == "`emotion'"
		gen `emotion'_remind_`type'_y = p2_reminder_signup_`type'_1 if e1 == "`emotion'"
		gen `emotion'_remind_`type'_gov = p2_reminder_govt_`type'_1 if e1 == "`emotion'"

	
		forval i = 2/11 {
			replace `emotion'_`type'_plan = p2_`type'_csa1_`i' ///
			if e`i' == "`emotion'" & `emotion'_`type'_plan ==""
			
			replace `emotion'_`type'_pl_t = p2_`type'_csa2_`i' ///
			if e`i' == "`emotion'" & `emotion'_`type'_pl_t ==""
			
			replace `emotion'_remind_`type'_y = p2_reminder_signup_`type'_`i' ///
			if e`i' == "`emotion'" & `emotion'_remind_`type'_y ==""
			
			replace `emotion'_remind_`type'_gov = p2_reminder_govt_`type'_`i' ///
			if e`i' == "`emotion'" & `emotion'_remind_`type'_gov ==""
		}

	destring `emotion'_`type'_plan `emotion'_`type'_pl_t `emotion'_remind_`type'_y ///
	`emotion'_remind_`type'_gov, replace
	}
}

rename *, lower

* Recode demographics
gen female = (gender == "Female")
gen bachelors = (substr(educ,1,4) =="Bach" | educ == "Advanced degree")

replace age = "1" if age == "18-24 years"
replace age = "2" if age == "25-39 years"
replace age = "3" if age == "40-60 years"
replace age = "4" if age == "60+ years"
replace age = "" if age == "Decline to state"

destring age, replace

* Recode scores to be between 0 and 1
foreach emotion in satisfaction fear selfworth pride anxiety guilt dignity happiness regret anger irritation {
	foreach type in finan career  health {
			replace `emotion'_`type'_plan = (`emotion'_`type'_plan - 1) /4
			replace `emotion'_`type'_pl_t = (`emotion'_`type'_pl_t - 1) /4
			
			foreach dec in y gov {
				replace `emotion'_remind_`type'_`dec' = (`emotion'_remind_`type'_`dec' - 1) /4
			}
	}
}

* Destring better off vars
foreach choicetype in finan career health {
	replace better_self_`choicetype' = "1" if better_self_`choicetype' == "Yes"
	replace better_self_`choicetype' = "2" if better_self_`choicetype' == "No"
	
	replace better_gov_`choicetype' = "1" if better_gov_`choicetype' == "Yes"
	replace better_gov_`choicetype' = "2" if better_gov_`choicetype' == "No"
	
	destring better_*, replace
	
	la val better_gov_`choicetype' yesno
	la val better_self_`choicetype' yesno
}

* Label everything
la var p1_finan_choice "Better Financial Shape if Spent More Time Financial Planning"
la var p1_health_choice "Healthier if Spent More Time Investing in Health"
la var p1_career_choice "Better Career if Spent More Time Career Planning"
la var p1_finan_category "Reasons for Not Spending Time Financial Planning"
la var p1_career_category "Reasons for Not Spending Time Career Planning"
la var p1_health_category "Reasons for Not Spending Time Investing in Health"


********************
* SURVEY 2 ANALYSIS
********************

* Calculate number of respondents that selected only "other"
foreach cat in finan health career {
	by id: egen min_`cat' = min(p1_`cat'_category)
	gen only_other_`cat' = (min_`cat' ==8)
}

* Save numbers to latex file
preserve

collapse (max) only_other_finan only_other_health only_other_career, by(id)

sum only_other_finan
scalar N = r(N)

foreach cat in finan health career {
	sum only_other_`cat' if only_other_`cat' ==1
	scalar other_`cat' = r(N)
	
	local p_other_`cat' = (other_`cat'/N)*100
	local p_other_`cat' : display %3.1f `p_other_`cat''
	
	latex_write other`cat' `p_other_`cat'' survey_numbers
}

restore

foreach choicetype in finan career health {
	
	* Save percent that reported "Yes"
	sum p1_`choicetype'_choice if p1_`choicetype'_choice ==1
	local `choicetype'yes : display %3.1f (r(N)/_N)*100
	local `choicetype'yesnum = r(N)/7
	
	* Write to Latex file
	latex_write `choicetype'yes ``choicetype'yes' survey_numbers
	latex_write `choicetype'yesnum ``choicetype'yesnum' survey_numbers
}

* Average number of responses selected 
foreach qtype in finan health career {
	gen `qtype'_resp_temp = 1 if p1_`qtype'_category !=.
	by id: egen `qtype'_resp_no = sum(`qtype'_resp_temp)
	
	sum `qtype'_resp_no
	local `qtype'avgrespno : display %3.1f r(mean)
	
	latex_write `qtype'avgrespno ``qtype'avgrespno' survey_numbers
}

* Prep data to plot results
preserve

keep id ob_num p1_finan_category p1_career_category p1_health_category

forval i = 1/8 {
	gen finan_`i' = 100 if p1_finan_category ==`i'
	by id: egen financat_`i' = max(finan_`i')
	drop finan_*
	
	gen career_`i' = 100 if p1_career_category ==`i'
	by id: egen careercat_`i' = max(career_`i')
	drop career_*
	
	gen health_`i' = 100 if p1_health_category ==`i'
	by id: egen healthcat_`i' = max(health_`i')
	drop health_*
}

collapse (max) financat* careercat* healthcat*, by(id)

forval i = 1/8 {
	replace financat_`i' = 0 if financat_`i' ==.
	replace careercat_`i' = 0 if careercat_`i' ==.
	replace healthcat_`i' = 0 if healthcat_`i' ==.
}

est clear

forval i = 1/8 {
	eststo finan`i': mean financat_`i'
	eststo career`i': mean careercat_`i'
	eststo health`i': mean healthcat_`i'
}

* Plot results at the respondent level

foreach qtype in finan career health {
	
	if "`qtype'" == "finan" {
		local label "Financial"
	}
	
	if "`qtype'" == "career" {
		local label "Career"
	}
	
	if "`qtype'" == "health" {
		local label "Health"
	}
		
	coefplot (`qtype'1) (`qtype'2) (`qtype'3) (`qtype'4) (`qtype'5) (`qtype'6) (`qtype'7) (`qtype'8) ///
			, graphregion(color(white)) xlab(0(10)50, labsize(small)) noci ///
			xtitle("Percent of Respondents", size(small)) ///
			color(navy) legend(off) recast(bar) ///
			ylab(1 `" "I experience negative emotions" "such as stress, anxiety, fear." "' ///
			2 "It makes me feel overwhelmed." 3 "I don't have the time." ///
			4 `" "I am averse to how" "complex this task is." "' ///
			5 "I procrastinate." 6 "I think this kind of planning is futile." ///
			7 `" "I do not need to spend a lot of time" "on this to make good decisions." "' 8 "Other" ///
			, labsize(small)) ///
			ytitle(, size(small)) ///
			 xsc(range(0 50)) barwidth(0.8) ///			 
			addplot(scatter @at @b, m(i) mlabel(@b) mlabpos(3) mlabcolor(black)) 
			
			graph export "$output_dir/`qtype'_cat_respondent_level.png", replace
}

* Identify those that said they were experiencing stress or feeling overwhelmed
foreach qtype in finan career health {
	gen `qtype'cat_1_2 = (`qtype'cat_1 ==100 | `qtype'cat_2 ==100)
	sum `qtype'cat_1_2
	scalar `qtype'cat_1_2 = 100*r(mean)
	local `qtype'cattwo = string(100*(r(mean)), "%4.1g")

	gen `qtype'cat_1_2_4 = (`qtype'cat_1 ==100 | `qtype'cat_2 ==100 | `qtype'cat_4 ==100)`'
	sum `qtype'cat_1_2_4
	local `qtype'catfour = string(100*(r(mean)), "%4.1g")
	
	sum `qtype'cat_2
	local `qtype'cattwo = string((r(mean)), "%4.1g")
	
	sum `qtype'cat_3
	local `qtype'catthree = string((r(mean)), "%4.1g")
	
	sum `qtype'cat_5
	local `qtype'catfive = string((r(mean)), "%4.1g")
}

* Write to Latex file
foreach name in financattwo financatfour financatthree financatfive ///
	careercattwo careercatfour careercatthree careercatfive ///
	healthcattwo healthcatfour healthcatthree healthcatfive {
	latex_write `name' ``name'' survey_numbers
}

restore

* MEAN PLOTS *
*-------------
* Plot means of emotions when planning
foreach emotion in satisfaction fear selfworth pride anxiety guilt dignity happiness regret anger irritation {
	
	foreach type in finan health career {
		mean `emotion'_`type'_plan
		eststo `emotion'_`type'_plan
		
		mean `emotion'_`type'_pl_t
		eststo `emotion'_`type'_pl_t
		
		mean `emotion'_remind_`type'_y
		eststo `emotion'_rem_`type'_y
		
		sum `emotion'_remind_`type'_y
		scalar `emotion'_remind_`type'_yes = r(mean)
		
		mean `emotion'_remind_`type'_gov
		eststo `emotion'_rem_`type'_g
		
		sum `emotion'_remind_`type'_gov
		scalar `emotion'_remind_`type'_govt = r(mean)	
		
	}
}

foreach suffix in finan health career {
	
	coefplot (satisfaction_`suffix'_plan, offset(0.25) pstyle(p1)) ///
		(satisfaction_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(happiness_`suffix'_plan, offset(0.25) pstyle(p1)) (happiness_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(selfworth_`suffix'_plan, offset(0.25) pstyle(p1)) (selfworth_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(pride_`suffix'_plan, offset(0.25) pstyle(p1)) (pride_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(dignity_`suffix'_plan, offset(0.25) pstyle(p1)) (dignity_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(fear_`suffix'_plan, offset(0.25) pstyle(p1)) (fear_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(anxiety_`suffix'_plan, offset(0.25) pstyle(p1)) (anxiety_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(guilt_`suffix'_plan, offset(0.25) pstyle(p1)) (guilt_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(regret_`suffix'_plan, offset(0.25) pstyle(p1)) (regret_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(anger_`suffix'_plan, offset(0.25) pstyle(p1)) (anger_`suffix'_pl_t, offset(-0.25) pstyle(p9)) ///
		(irritation_`suffix'_plan, offset(0.25) pstyle(p1)) (irritation_`suffix'_pl_t, offset(-0.25) pstyle(p9)) , ///
		vertical graphregion(color(white)) ylab(0(0.25)1, labsize(small)) ///
		ciopts(recast(rcap)) xlab(1.5 "Satisfaction" 3.5 "Happiness" ///
		5.5 "Self-Worth" 7.5 "Pride" 9.5 "Dignity" 11.5 "Fear" 13.5 "Anxiety" 15.5 "Guilt"  ///
		17.5 "Regret" 19.5 "Anger" 21.5 "Irritation", labsize(vsmall)) ytitle("Mean Score", size(small)) ///
		legend(order(2 "During Planning" 4 "When Thinking of Allocating Time") size(small)) ///
		xtitle(, size(small)) yscale(range(0, 1))
		
	graph export "$output_dir/emotions_`suffix'_mean_plot.png", replace
}


* Plot means of emotions related to reminder program
* T-tests 
foreach emotion in satisfaction fear selfworth pride anxiety guilt dignity happiness regret anger irritation {
	
	foreach type in finan career health {
		
		ttest `emotion'_remind_`type'_y = `emotion'_remind_`type'_gov
		local `emotion'_`type'_p_g = `" `: display %4.2f r(p)'"'
		local `emotion'_`type'_diff_g = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
		
		if ``emotion'_`type'_diff_g' >= 0 {
			local `emotion'_`type'_x_g = `emotion'_remind_`type'_govt - 0.08
			local `emotion'_`type'_x_g_2 = ``emotion'_`type'_x_g' - 0.04
		}
		
		if 	``emotion'_`type'_diff_g' < 0 {
			local `emotion'_`type'_x_g = `emotion'_remind_`type'_yes - 0.08
			local `emotion'_`type'_x_g_2 = ``emotion'_`type'_x_g' - 0.04
		}
		
		if ``emotion'_`type'_p_g' < 0.01 {
			local `emotion'_`type'_p_g =  `" `: display %4.2f 0.01'"'
		}
		
		if ``emotion'_`type'_p_g' < 0.001 {
			local `emotion'_`type'_p_g =  `" `: display %4.2f 0.001'"'
		}
		
		if ``emotion'_`type'_p_g' > 0.01 {
			local `emotion'_`type'_g_psym = "="
		}
		
		if ``emotion'_`type'_p_g' <= 0.01 {
			local `emotion'_`type'_g_psym = "<"
		}
		
	}
}

* Plot
foreach type in finan career health {
		
		local legend1 "Signed Up for Reminder Program"
		
		local legend2 "Gov. Mandated Everyone Sign Up for Program"
		
		coefplot (satisfaction_rem_`type'_y, offset(0.25) pstyle(p1)) ///
		(satisfaction_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(happiness_rem_`type'_y, offset(0.25) pstyle(p1)) (happiness_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(selfworth_rem_`type'_y, offset(0.25) pstyle(p1)) ///
		(selfworth_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(pride_rem_`type'_y, offset(0.25) pstyle(p1)) (pride_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(dignity_rem_`type'_y, offset(0.25) pstyle(p1)) (dignity_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(fear_rem_`type'_y, offset(0.25) pstyle(p1)) (fear_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(anxiety_rem_`type'_y, offset(0.25) pstyle(p1)) (anxiety_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(guilt_rem_`type'_y, offset(0.25) pstyle(p1)) (guilt_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(regret_rem_`type'_y, offset(0.25) pstyle(p1)) (regret_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(anger_rem_`type'_y, offset(0.25) pstyle(p1)) (anger_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		(irritation_rem_`type'_y, offset(0.25) pstyle(p1)) (irritation_rem_`type'_g, offset(-0.25) pstyle(p9)) ///
		, vertical graphregion(color(white)) ylab(0(0.25)1, labsize(small)) ciopts(recast(rcap)) ///
		xlab(1.5 "Satisfaction" 3.5 "Happiness" 5.5 "Self-Worth" 7.5 "Pride" 9.5 "Dignity" 11.5 "Fear" ///
		13.5 "Anxiety" 15.5 "Guilt" 17.5 "Regret" 19.5 "Anger" 21.5 "Irritation" ///
		, labsize(vsmall)) ytitle("Mean Score", size(small)) ///
		legend(order(2 "`legend1'" 4 "`legend2'") ///
		size(small)) xtitle(, size(small)) yscale(range(0, 1)) ///
		text(`satisfaction_`type'_x_g' 1.5  "‾‾‾‾‾‾‾‾" "d=`satisfaction_`type'_diff_g'" ///
		`satisfaction_`type'_x_g_2' 1.5 "p`satisfaction_`type'_g_psym'`satisfaction_`type'_p_g'" ///
		`happiness_`type'_x_g' 3.5  "‾‾‾‾‾‾‾‾" "d=`happiness_`type'_diff_g'" ///
		`happiness_`type'_x_g_2' 3.5 "p`happiness_`type'_g_psym'`happiness_`type'_p_g'" ///
		`selfworth_`type'_x_g' 5.5  "‾‾‾‾‾‾‾‾" "d=`selfworth_`type'_diff_g'"  ///
		`selfworth_`type'_x_g_2' 5.5 "p`selfworth_`type'_g_psym'`selfworth_`type'_p_g'" ///
		`pride_`type'_x_g' 7.5  "‾‾‾‾‾‾‾‾" "d=`pride_`type'_diff_g'"  ///
		`pride_`type'_x_g_2' 7.5 "p`pride_`type'_g_psym'`pride_`type'_p_g'" ///
		`dignity_`type'_x_g' 9.5  "‾‾‾‾‾‾‾‾" "d=`dignity_`type'_diff_g'" ///
		`dignity_`type'_x_g_2' 9.5 "p`dignity_`type'_g_psym'`dignity_`type'_p_g'" ///
		`fear_`type'_x_g' 11.5  "‾‾‾‾‾‾‾‾" "d=`fear_`type'_diff_g'" ///
		`fear_`type'_x_g_2' 11.5 "p`fear_`type'_g_psym'`fear_`type'_p_g'" ///
		`anxiety_`type'_x_g' 13.5  "‾‾‾‾‾‾‾‾" "d=`anxiety_`type'_diff_g'"   ///
		`anxiety_`type'_x_g_2' 13.5 "p`anxiety_`type'_g_psym'`anxiety_`type'_p_g'" ///
		`guilt_`type'_x_g' 15.5  "‾‾‾‾‾‾‾‾" "d=`guilt_`type'_diff_g'"   ///
		`guilt_`type'_x_g_2' 15.5 "p`guilt_`type'_g_psym'`guilt_`type'_p_g'" ///
		`regret_`type'_x_g' 17.5  "‾‾‾‾‾‾‾‾" "d=`regret_`type'_diff_g'" ///
		`regret_`type'_x_g_2' 17.5 "p`regret_`type'_g_psym'`regret_`type'_p_g'" ///
		`anger_`type'_x_g' 19.5  "‾‾‾‾‾‾‾‾" "d=`anger_`type'_diff_g'"  ///
		`anger_`type'_x_g_2' 19.5 "p`anger_`type'_g_psym'`anger_`type'_p_g'" ///
		`irritation_`type'_x_g' 21.5  "‾‾‾‾‾‾‾‾" "d=`irritation_`type'_diff_g'"  ///
		`irritation_`type'_x_g_2' 21.5 "p`irritation_`type'_g_psym'`irritation_`type'_p_g'" ///
		, size(vsmall))
		
			
		graph export "$output_dir/emotions_remind_g_`type'_mean_plot.png", replace
	}
