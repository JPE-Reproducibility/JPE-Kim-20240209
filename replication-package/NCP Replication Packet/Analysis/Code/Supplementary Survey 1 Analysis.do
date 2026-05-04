*------------------------------------
*	Supplementary Survey 1
*------------------------------------


********************
* SURVEY 1 CLEANING
********************

* Import final data
import excel "$raw_data_dir/JPE Revision Survey 1 Final.xlsx", firstrow case(lower) clear

drop if _n ==1
keep in -500/l 

drop if attention_check != "" // Drop those who failed attention check
drop if progress!="100"
drop if id==.
drop if id == 96 // Sophie's ID

keep durationinseconds p1_self_avoid1_1_1 - e11 id

destring durationinseconds, replace
replace durationinseconds = durationinseconds/60
rename durationinseconds durationinmins

* Drop AI-generated responses
preserve 

do "$code_dir/AI-flag-Survey1.do"

drop if ai_flag ==1

keep id

tempfile ids

save `ids', replace

restore

merge 1:1 id using `ids', keep(match) nogen

* Save number of participants 
local soneparticipants = _N

latex_write soneparticipants `soneparticipants' survey_numbers

* Reshape long
reshape long category p1_self_avoid1_ p1_self_avoid2_, i(id) j(ob_num) string

* Reformat responses by type of decision, emotion
forval i = 1/10 {
	replace e`i' = "selfworth" if e`i' == "Self-Worth"
}

* Generate e11
foreach e in Satisfaction Fear selfworth Pride Anxiety Guilt Dignity Happiness Regret Anger Irritation {
	gen missing_`e' = 1 if (e1 != "`e'" & e2 != "`e'" & e3 != "`e'" & e4 != "`e'" & e5 != "`e'" & e6 != "`e'" & e7 != "`e'" & e8 != "`e'" & e9 != "`e'" & e10 != "`e'") & e11 ==""
	
	replace e11 = "`e'" if e11 == "" & missing_`e' == 1
	
}

drop missing*

* Recode types of decisions 
replace category = "1" if category == "Financial"
replace category = "2" if category == "Health"
replace category = "3" if category == "Education"
replace category = "4" if category == "Career"
replace category = "5" if category == "Personal Development"
replace category = "6" if category == "Family"
replace category = "7" if category == "Daily Tasks"
replace category = "8" if category == "Legal"
replace category = "9" if category == "Social"
replace category = "10" if category == "None of the above"

destring category, replace

la define categories 1 "Financial" 2 "Health" 3 "Education" 4 "Career" 5 `""Personal" "Development""' ///
6 "Family" 7 `""Daily" "Tasks""' 8 "Legal" 9 "Social" 10 "None of the above"

la val category categories
la val category categories

* Recode scores for each emotion
foreach emotion in Satisfaction Fear selfworth Pride Anxiety Guilt Dignity Happiness Regret Anger Irritation {
	
	gen `emotion'_self_yes = csa_self_yes_1 if e1 == "`emotion'"
	gen `emotion'_govt_yes = csa_govt_yes_1 if e1 == "`emotion'"
	
	destring `emotion'_self_yes `emotion'_govt_yes, replace
	
	forval i = 2/10 {
	destring csa_self_yes_`i' csa_govt_yes_`i', replace	
		
	replace `emotion'_self_yes = csa_self_yes_`i' if e`i' == "`emotion'" & `emotion'_self_yes ==.
	replace `emotion'_govt_yes = csa_govt_yes_`i' if e`i' == "`emotion'" & `emotion'_govt_yes ==.
	}
}

rename *, lower

* Destring, recode
foreach suffix in self govt {
	replace choice_`suffix' = "1" if choice_`suffix' == "Yes"
	replace choice_`suffix' = "2" if choice_`suffix' == "No"

	destring choice_`suffix', replace
}

la define yesno 1 "Yes" 2 "No"

la val choice_self yesno
la val choice_govt yesno

destring satisfaction_self_yes - irritation_govt_yes, replace

* Recode scores to be between 0 and 1
foreach emotion in satisfaction fear selfworth pride anxiety guilt dignity happiness regret anger irritation {
	foreach type in self govt {
		foreach dec in yes {
			replace `emotion'_`type'_`dec' = (`emotion'_`type'_`dec' - 1) /4
		}
	}
}

********************
* SURVEY 1 ANALYSIS
********************

* Calculate average number of decisions listed
gen dec = (p1_self_avoid1_ != "")
by id: egen num_dec = sum(dec)

drop dec

sum num_dec
scalar avg_no_decisions = r(mean)
local avg_no_decisions = round(avg_no_decisions, 0.2)

* Write to Latex file
latex_write avgnodecisions `avg_no_decisions' survey_numbers

sum durationinmins
local soneduration : di %3.1f r(mean) 

latex_write soneduration `soneduration' survey_numbers

* Compare frequency of types of decisions at respondent level
preserve

reshape wide

forval i = 1/10 {
	gen category_resp`i' = 100*(category1 == `i' | category2 ==`i' | category3 ==`i' | category4 ==`i' | category5 ==`i')

	eststo cat_resp_`i': mean category_resp`i'
}
sum category_resp1
local mean1: di %4.1g r(mean)
latex_write catrespfinan `mean1' survey_numbers
sum category_resp6
local mean6: di %4.1g r(mean)
latex_write catrespfam `mean6' survey_numbers 
sum category_resp9
local mean9: di %4.1g r(mean)
latex_write catrespsoc `mean9' survey_numbers
sum category_resp2
local mean2: di %4.1g r(mean)
latex_write catresphealth `mean2' survey_numbers
sum category_resp4
local mean4: di %4.1g r(mean)
latex_write catrespcareer `mean4' survey_numbers
sum category_resp5
local mean5: di %4.1g r(mean)
latex_write catrespdev `mean5' survey_numbers
sum category_resp7
local mean7: di %4.1g r(mean)
latex_write catrespdaily `mean7' survey_numbers
sum category_resp3
local mean3: di %4.1g r(mean)
latex_write catrespeduc `mean3' survey_numbers
sum category_resp8
local mean8: di %4.1g r(mean)
latex_write catresplegal `mean8' survey_numbers

* Save percent that reported "none of the above"
sum category_resp10
local noneoftheabove = r(mean)

* Write to Latex file
latex_write noneoftheabove `noneoftheabove' survey_numbers

restore

* Save numbers Latex file
sum choice_self
local N = r(N)

sum choice_self if choice_self ==1
local pctchoiceself = (r(N)/`N')*100
local pctchoiceself : di %3.1f `pctchoiceself'

sum choice_govt if choice_govt ==1
local pctchoicegovt = (r(N)/`N')*100
local pctchoicegovt : di %3.1f `pctchoicegovt' 

latex_write pctchoiceself `pctchoiceself' survey_numbers
latex_write pctchoicegovt `pctchoicegovt' survey_numbers

* Compare average score given to each emotion (if chose to increase penalty)
est clear

foreach emotion in satisfaction fear selfworth pride anxiety guilt dignity happiness regret anger irritation {
	foreach suff in self govt {
	
	eststo `emotion'_`suff'_y: mean `emotion'_`suff'_yes	
	
	sum `emotion'_`suff'_yes
	scalar `emotion'_y_`suff' = r(mean)
	}
	
}

* T-tests
foreach emotion in satisfaction fear selfworth pride anxiety guilt dignity happiness regret anger irritation {
	
	ttest `emotion'_self_yes = `emotion'_govt_yes
		local `emotion'_p_y = `"`: display %4.2f r(p)'"'
		local `emotion'_diff_y = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'

	if 	``emotion'_diff_y' >= 0 {
		local `emotion'_x_yes = `emotion'_y_govt - 0.08
		local `emotion'_x_yes_2 = ``emotion'_x_yes' - 0.04
	}
	
	if 	``emotion'_diff_y' < 0 {
		local `emotion'_x_yes = `emotion'_y_self - 0.08
		local `emotion'_x_yes_2 = ``emotion'_x_yes' - 0.04
	}
	
	if ``emotion'_p_y' < 0.01 {
			local `emotion'_p_y =  `" `: display %4.2f 0.01'"'
	}
		
	if ``emotion'_p_y' < 0.001 {
		local `emotion'_p_y =  `" `: display %4.2f 0.001'"'
	}
		
	if ``emotion'_p_y' > 0.01 {
		local `emotion'_p_y_psym = "="
	}
	
	if ``emotion'_p_y' <= 0.01 {
		local `emotion'_p_y_psym = "<"
	}

}

* Graph
coefplot (satisfaction_self_y, offset(0.25) mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(satisfaction_govt_y, offset(-0.25) pstyle(p9)) ///
	(happiness_self_y, offset(0.25) mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(happiness_govt_y, offset(-0.25) pstyle(p9)) ///
	(selfworth_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(selfworth_govt_y, offset(-0.25) pstyle(p9)) ///
	(pride_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(pride_govt_y, offset(-0.25) pstyle(p9)) ///
	(dignity_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(dignity_govt_y, offset(-0.25) pstyle(p9)) ///
	(fear_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(fear_govt_y, offset(-0.25) pstyle(p9)) ///
	(anxiety_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(anxiety_govt_y, offset(-0.25) pstyle(p9)) ///
	(guilt_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(guilt_govt_y, offset(-0.25) pstyle(p9)) ///
	(regret_self_y, offset(0.25) mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(regret_govt_y, offset(-0.25) pstyle(p9)) ///
	(anger_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(anger_govt_y, offset(-0.25) pstyle(p9)) ///
	(irritation_self_y, offset(0.25)  mcolor(navy) ciopts(lcol(navy) recast(rcap))) ///
	(irritation_govt_y, offset(-0.25) pstyle(p9)) ///
	, vertical graphregion(color(white)) ylab(0(0.25)1, labsize(small)) ///
	ciopts(recast(rcap)) xlab(1.5 "Satisfaction" 3.5 "Happiness" 5.5 "Self-Worth" ///
	7.5 "Pride" 9.5 "Dignity" 11.5 "Fear" 13.5 "Anxiety" 15.5 "Guilt" ///
	17.5 "Regret" 19.5 "Anger" 21.5 "Irritation", labsize(vsmall)) ytitle("Mean Score", size(small)) ///
	legend(order(2 "Chose to Increase Penalty" 4 "Gov. Increased Penalty") size(small)) ///
	text(`satisfaction_x_yes' 1.5 "‾‾‾‾‾‾‾‾" "d=`satisfaction_diff_y'" ///
	`satisfaction_x_yes_2' 1.5 "p`satisfaction_p_y_psym'`satisfaction_p_y'" ///
	`happiness_x_yes' 3.5 "‾‾‾‾‾‾‾‾" "d=`happiness_diff_y'" ///
	`happiness_x_yes_2' 3.5 "p`happiness_p_y_psym'`happiness_p_y'" ///
	`selfworth_x_yes' 5.5 "‾‾‾‾‾‾‾‾" "d=`selfworth_diff_y'" ///
	`selfworth_x_yes_2' 5.5 "p`selfworth_p_y_psym'`selfworth_p_y'" ///
	`pride_x_yes' 7.5 "‾‾‾‾‾‾‾‾" "d=`pride_diff_y'" ///
	`pride_x_yes_2' 7.5 "p`pride_p_y_psym'`pride_p_y'" ///
	`dignity_x_yes' 9.5 "‾‾‾‾‾‾‾‾" "d=`dignity_diff_y'" ///
	`dignity_x_yes_2' 9.5 "p`dignity_p_y_psym'`dignity_p_y'" ///
	`fear_x_yes' 11.5 "‾‾‾‾‾‾‾‾" "d=`fear_diff_y'" ///
	`fear_x_yes_2' 11.5 "p`fear_p_y_psym'`fear_p_y'" ///
	`anxiety_x_yes' 13.5 "‾‾‾‾‾‾‾‾" "d=`anxiety_diff_y'" ///
	`anxiety_x_yes_2' 13.5 "p`anxiety_p_y_psym'`anxiety_p_y'" ///
	`guilt_x_yes' 15.5 "‾‾‾‾‾‾‾‾" "d=`guilt_diff_y'" ///
	`guilt_x_yes_2' 15.5 "p`guilt_p_y_psym'`guilt_p_y'" ///
	`regret_x_yes' 17.5 "‾‾‾‾‾‾‾‾" "d=`regret_diff_y'" ///
	`regret_x_yes_2' 17.5 "p`regret_p_y_psym'`regret_p_y'" ///
	`anger_x_yes' 19.5 "‾‾‾‾‾‾‾‾" "d=`anger_diff_y'" ///
	`anger_x_yes_2' 19.5 "p`anger_p_y_psym'`anger_p_y'" ///
	`irritation_x_yes' 21.5 "‾‾‾‾‾‾‾‾" "d=`irritation_diff_y'" ///
	`irritation_x_yes_2' 21.5 "p`irritation_p_y_psym'`irritation_p_y'", size(vsmall)) ///
	xtitle(, size(small)) yscale(range(0, 1))
	
graph export "$output_dir/emotions_y_mean_plot.png", replace

* Save numbers
foreach suff in self govt {
	sum choice_`suff' if choice_`suff' == 1
	local choice`suff'yes: di %3.1f (r(N)/_N)*100
	
	latex_write choice`suff'yes `choice`suff'yes' survey_numbers
}
