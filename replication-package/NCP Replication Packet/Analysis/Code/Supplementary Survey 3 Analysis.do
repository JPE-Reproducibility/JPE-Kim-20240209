*------------------------------------
*	Supplementary Survey 3
*------------------------------------


***********
* CLEANING
***********
* Get CSA weights first ________________________________________________________

global emotions satis happy unfair fair finan pride guilt

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
	
	* Drop choices with no data
	drop if guilt==.
}

* Get CSA weights with logit regression
logit part1_choice rel_* if part==1, r nocons
	
* Get coefficients
global guilt=_b[rel_guilt]
global pride=_b[rel_pride]
global finan=_b[rel_finan]
global fair=_b[rel_fair]
global unfair=_b[rel_unfair]
global happy=_b[rel_happy]
global satis=_b[rel_satis]


*------------------------------------------------------*
*		SURVEY 3: Donations
*------------------------------------------------------*

* Clean data ___________________________________________________________________
import excel "$raw_data_dir/JPE Revision Survey 3 Final.xlsx", firstrow case(lower) clear

keep in -500/l

drop if progress!="100"
drop if id==.
drop if attention_check != "" // Drop those who failed attention check
rename fl_11_do order
drop progress

* Save number of participants 
local sthreeparticipants = _N

latex_write sthreeparticipants `sthreeparticipants' survey_numbers

destring durationinseconds, replace
replace durationinseconds = durationinseconds/60
rename durationinseconds durationinmins

* Save duration
sum durationinmins
local sthreeduration : di %3.1f r(mean) 

latex_write sthreeduration `sthreeduration' survey_numbers


* Replace choice CSA in the right place
* Scenario 1
forval i=1/7 {
	forval j=1/3 {
		replace s1_csa`j'_`i'=s1_choice_csa_`i' if s1_choice=="`j'" & s1_csa`j'_`i'==""
	}
}

* Scenario 2
forval i=1/7 {
	forval j=1/2 {
		replace s2_csa`j'_`i'=s2_choice_csa_`i' if s2_choice=="`j'" & s2_csa`j'_`i'==""
	}
}

drop s1_choice_csa* s2_choice_csa*

* REFORMAT _____________________________________________________________________
* Reshape long
reshape long s1_csa1 s1_csa2 s1_csa3 s2_csa1 s2_csa2 s3_csa3, i(id) j(csa) string

* Replace csa with csa name
forval i=1/7 {
	replace csa=e`i' if csa=="_`i'"
}
replace csa="fair" if csa=="A Sense of Fairness"
replace csa="unfair" if csa=="A Sense of Unfairness"
replace csa="finan" if csa=="Financial Satisfaction"
replace csa="happy" if csa=="Happiness"
replace csa="satis" if csa=="Satisfaction"
replace csa=lower(csa)


* Reshape long again
reshape long s1_csa s2_csa s3_csa, i(id csa) j(option)
drop e1-e7
rename s1_csa csa_rating1 
rename s2_csa csa_rating2
rename s3_csa csa_rating3
reshape long csa_rating, i(id csa option) j(scenario)

destring csa_rating, replace 

* Normalize emotions from 0 to 1 
replace csa_rating=(csa_rating-1)/4

* Reshape
rename csa_rating csa_
reshape wide csa_, i(id scenario option s1_choice s2_choice) j(csa) string
reshape wide csa_guilt csa_pride csa_finan csa_fair csa_unfair ///
	csa_satis csa_happy, i(id scenario s1_choice s2_choice) j(option)

* Get relative csas
foreach emotion in guilt pride finan fair unfair happy satis  {
	gen rel_`emotion' = csa_`emotion'1-csa_`emotion'2
}
* Reshape long
reshape long csa_guilt csa_pride csa_finan csa_fair csa_unfair csa_happy csa_satis, ///
	i(id scenario s1_choice s2_choice) j(option)

* Get CSA weights
* Multiply the CSA scores by coefficients and create utility measure
gen lu=csa_guilt*$guilt +csa_pride*$pride +csa_finan*$finan ///
	+csa_fair*$fair +csa_unfair*$unfair +csa_happy*$happy ///
	+csa_satis*$satis
	
********************
* SURVEY 3 ANALYSIS
********************

* Save numbers
preserve 

duplicates drop id, force

sum scenario if s2_choice == "1"
local supplrespondentsthreegive = r(N)

sum scenario if s2_choice == "2"
local supplrespondentsthreenotgive = r(N)

latex_write supplrespondentsthreegive `supplrespondentsthreegive' survey_numbers
latex_write supplrespondentsthreenotgive `supplrespondentsthreenotgive' survey_numbers

restore

* Graph difference in "don't open" options for everyone
preserve
drop lu rel*

reshape wide csa_fair csa_finan csa_guilt csa_happy csa_pride csa_satis csa_unfair, ///
i(id option) j(scenario)

est clear

foreach e in guilt pride fair unfair finan satis happy {
	
	gen diff_`e' = csa_`e'1 - csa_`e'3 if option==3 // everyone
	eststo m_all_`e' : mean diff_`e'
	
	gen diff_s1donate_`e' = csa_`e'1 - csa_`e'3 if option==3 & s1_choice =="1" // donated scenario 1
	eststo m_s1donate_`e' : mean diff_s1donate_`e'
	
	gen diff_s1nodonate_`e' = csa_`e'1 - csa_`e'3 if option==3 & (s1_choice =="2" | s1_choice =="3") // didn't donate scenario 1
	eststo m_s1nodonate_`e' : mean diff_s1nodonate_`e'
	
	gen diff_s2donate_`e' = csa_`e'1 - csa_`e'3 if option==3 & (s2_choice =="1") // donated scenario 2
	eststo m_s2donate_`e' : mean diff_s2donate_`e'
	
	gen diff_s2nodonate_`e' = csa_`e'1 - csa_`e'3 if option==3 & (s2_choice =="2") // didn't donate scenario 2
	eststo m_s2nodonate_`e' : mean diff_s2nodonate_`e'
}

foreach prefix in m_s2donate m_s2nodonate {

	coefplot (`prefix'_happy, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
		(`prefix'_satis, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
		(`prefix'_finan, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
		(`prefix'_pride, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
		(`prefix'_fair, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///	
		(`prefix'_guilt, mcolor(midblue) ciopts(color(midblue) recast(rcap))) ///
		(`prefix'_unfair, mcolor(midblue) ciopts(color(midblue) recast(rcap))), ///
		ytitle("Mean Difference in Ratings") xsc(range(0.5 7.5)) vertical ///
		xlab(1 "Happiness" 2 "Satisfaction" 3 `""Financial" "Satisfaction""' 4 "Pride" ///
		5 "Fair" 6 "Guilt" 7 "Unfair", labsize(small)) ylab(-0.2(0.1)0.4) ///
		legend(off) graphregion(fcolor(white)) ysc(range(-0.2 0.4))
	
	graph export "$output_dir/mean_diff_`prefix'.png", replace
}

est clear

restore

* Histograms ___________________________________________________________________

destring s1_choice s2_choice, replace

la define s1ch 1 "Donate" 2 "Don`=char(39)'t Donate" 3 "Don`=char(39)'t Open"
la define s2ch 1 "Donate" 2 "Don`=char(39)'t Donate"

la val s1_choice s1ch
la val s2_choice s2ch

hist s1_choice, percent fcolor(navy) lcolor(none) graphregion(fcolor(white)) ///
discrete xtitle("", size(small)) ytitle(, size(small)) yla(, labsize(small)) ///
addlabel addlabopts(mlabsize(small) yvarformat(%3.0f)) ///
xla(1/3, valuelabel labsize(small)) barwidth(0.8)
	
graph export "$output_dir/s1_choice_hist.png", replace


hist s2_choice, percent fcolor(navy) lcolor(none) graphregion(fcolor(white)) ///
discrete xtitle("", size(small)) ytitle(, size(small)) yla(, labsize(small)) barwidth(0.8) ///
addlabel addlabopts(mlabsize(small) yvarformat(%3.0f)) xla(1/2, valuelabel labsize(small)) 
	
graph export "$output_dir/s2_choice_hist.png", replace

* Run T-tests
preserve
drop lu rel*

reshape wide csa_fair csa_finan csa_guilt csa_happy csa_pride csa_satis csa_unfair, i(id option) j(scenario)

foreach e in guilt pride fair unfair finan satis happy {
	
ttest csa_`e'1== csa_`e'2 if option==1
	global `e'_option1 = `"`: display %4.2f r(p)'"'
	global `e'_diff1 = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
	
ttest csa_`e'1== csa_`e'2 if option==2
	global `e'_option2 = `"`: display %4.2f r(p)'"'
	global `e'_diff2 = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
	
ttest csa_`e'1== csa_`e'3 if option==3
	global `e'_option3 = `"`: display %4.2f r(p)'"'
	global `e'_diff3 = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'	
	
	gen csa_`e'_1_2_temp = csa_`e'1 if option==2
	gen csa_`e'_2_2_temp = csa_`e'2 if option==2
	gen csa_`e'_3_3_temp = csa_`e'3 if option==3
	
	by id: egen csa_`e'_1_2 = max(csa_`e'_1_2_temp)
	by id: egen csa_`e'_2_2 = max(csa_`e'_2_2_temp)
	by id: egen csa_`e'_3_3 = max(csa_`e'_3_3_temp)
	
	drop *temp
	
ttest csa_`e'_1_2 = csa_`e'_3_3
	global `e'_option4 = `"`: display %4.2f r(p)'"'
	global `e'_diff4 = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'	
	
ttest csa_`e'_2_2 = csa_`e'_3_3
	global `e'_option5 = `"`: display %4.2f r(p)'"'
	global `e'_diff5 = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
}

restore

* Gen graphs comparing means for different emotions
tempfile temp
save `temp', replace

foreach e in guilt pride fair unfair finan satis happy {
	use `temp', clear
	
	if "`e'"=="guilt" {
		local title "Guilt"
	}
	if "`e'"=="pride" {
		local title "Pride"
	}
	if "`e'"=="fair" {
		local title "Fairness"
	}
	if "`e'"=="unfair" {
		local title "Unfairness"
	}
	if "`e'"=="finan" {
		local title "Financial Satisfaction"
	}
	if "`e'"=="satis" {
		local title "Satisfaction"
	}
	if "`e'"=="happy" {
		local title "Happiness"
	}

	collapse (mean) csa_`e' (semean) se=csa_`e', by(scenario option)
	gen u = csa_`e' + 1.96*se
	gen l = csa_`e' - 1.96*se
	drop if csa_`e'==.
		
		sum csa_`e' if scenario ==1 & option ==1
		scalar csa_`e'_1_1 = r(mean)
		
		sum csa_`e' if scenario ==1 & option ==2
		scalar csa_`e'_1_2 = r(mean)
		
		sum csa_`e' if scenario ==1 & option ==3
		scalar csa_`e'_1_3 = r(mean)
		
		sum csa_`e' if scenario ==2 & option ==1
		scalar csa_`e'_2_1 = r(mean)
		
		sum csa_`e' if scenario ==2 & option ==2
		scalar csa_`e'_2_2 = r(mean)
		
		sum csa_`e' if scenario ==3 & option ==3
		scalar csa_`e'_3_3 = r(mean)
		
		if 	$`e'_diff1  >= 0 {
			global `e'_x_1 = csa_`e'_2_1 - 0.09
			global `e'_x_1_2 = $`e'_x_1 - 0.05
		}
		
		if 	$`e'_diff1  < 0 {
			global `e'_x_1 = csa_`e'_1_1 - 0.09
			global `e'_x_1_2 = $`e'_x_1 - 0.05
		}
				
		if 	$`e'_diff2 < 0 {
			global `e'_x_2 = csa_`e'_1_2 - 0.09
			global `e'_x_2_2 = $`e'_x_2 - 0.05
		}
		
		if 	$`e'_diff2  >= 0 {
			global `e'_x_2 = csa_`e'_2_2 - 0.09
			global `e'_x_2_2 = $`e'_x_2 - 0.05
		}
			
		if 	$`e'_diff3 >= 0 {
			global `e'_x_3 = csa_`e'_3_3 - 0.09
			global `e'_x_3_2 = $`e'_x_3 - 0.05
		}
		
		if 	$`e'_diff3  < 0 {
			global `e'_x_3 = csa_`e'_1_3 - 0.09
			global `e'_x_3_2 = $`e'_x_3 - 0.05
		}
		
		if $`e'_option1 < 0.01 {
				global `e'_option1 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option2 < 0.01 {
				global `e'_option2 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option3 < 0.01 {
				global `e'_option3 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option4 < 0.01 {
				global `e'_option4 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option5 < 0.01 {
				global `e'_option5 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option1 < 0.001 {
				global `e'_option1 =  `" `: display %4.2f 0.001'"'
		}
		
		if $`e'_option2 < 0.001 {
				global `e'_option2 =  `" `: display %4.2f 0.001'"'
		}
		
		if $`e'_option3 < 0.001 {
				global `e'_option3 =  `" `: display %4.2f 0.001'"'
		}	
		
		if $`e'_option4 < 0.001 {
				global `e'_option4 =  `" `: display %4.2f 0.001'"'
		}	
		
		if $`e'_option5 < 0.001 {
				global `e'_option5 =  `" `: display %4.2f 0.001'"'
		}	

		if $`e'_option1 > 0.01 {
			local `e'_psym_1 = "="
		}

		if $`e'_option2 > 0.01 {
			local `e'_psym_2 = "="
		}
		
		if $`e'_option3 > 0.01 {
			local `e'_psym_3 = "="
		}
		
		if $`e'_option4 > 0.01 {
			local `e'_psym_4 = "="
		}

		if $`e'_option5 > 0.01 {
			local `e'_psym_5 = "="
		}
		
		if $`e'_option1 <= 0.01 {
			local `e'_psym_1 = "<"
		}	
		
		if $`e'_option2 <= 0.01 {
			local `e'_psym_2 = "<"
		}
		
		if $`e'_option3 <= 0.01 {
			local `e'_psym_3 = "<"
		}
		
		if $`e'_option4 <= 0.01 {
			local `e'_psym_4 = "<"
		}
		
		if $`e'_option5 <= 0.01 {
			local `e'_psym_5 = "<"
		}
	
	sort option scenario
	gen graph_order=_n
	replace graph_order=graph_order+1 if _n>2
	replace graph_order=graph_order+1 if _n>4
	
		if 	$`e'_x_2  >= $`e'_x_3 {
			global `e'_x_4 = $`e'_x_2 + 0.25
			global `e'_x_4_2 = $`e'_x_4 - 0.05
		}
		
		if 	$`e'_x_2  < $`e'_x_3 {
			global `e'_x_4 = $`e'_x_3 + 0.25
			global `e'_x_4_2 = $`e'_x_4 - 0.05
		}
	
	gen l1 = $`e'_x_4_2 
	
		if 	$`e'_x_2  >= $`e'_x_3 {
			global `e'_x_5 = $`e'_x_3 - 0.05
			global `e'_x_5_2 = $`e'_x_5 - 0.05
		}
	
		if 	$`e'_x_2  < $`e'_x_3 {
			global `e'_x_5 = $`e'_x_2 - 0.05
			global `e'_x_5_2 = $`e'_x_5 - 0.05
		}
		
		global `e'_x_4 = $`e'_x_4 + 0.06
		global `e'_x_4_2 = $`e'_x_4 - 0.05
			
	gen l2 = $`e'_x_5_2 
	
		global `e'_x_5 = $`e'_x_5 - 0.1
		global `e'_x_5_2 = $`e'_x_5 - 0.05

	tw (rcap u l graph_order if scenario==1, lcolor(midblue)) ///
		(sc csa_`e' graph_order if scenario==1, mcolor(midblue)) ///
		(rcap u l graph_order if scenario==2, lcolor(cranberry)) ///
		(sc csa_`e' graph_order if scenario==2, mcolor(cranberry)) ///
		(rcap u l graph_order if scenario==3, lcolor(orange)) /// 
		(sc csa_`e' graph_order if scenario==3, mcolor(orange)) ///
		(line l1 graph_order if option == 2 | option == 3, lc(black) lwidth(thin)) ///
		(line l2 graph_order if (option == 2 & scenario ==2) | option == 3, lc(black) lwidth(thin)), ///
		ytitle("`title'") xtitle("") xsc(range(0.5 8.5)) ///
		xlab(1.5 "Donate" 4.5 "Don`=char(39)'t Donate" 7.5 "Don`=char(39)'t Open" , labsize(small)) ///
		legend(order(2 "Scenario 1: Don`=char(39)'t open option" 4 "Scenario 2: Opened door" ///
		6 "Scenario 3: Not home")) ylab(-0.1(.1)1) ysc(range(-0.15 1)) graphregion(fcolor(white)) ///
		text($`e'_x_1 1.5  "‾‾‾‾‾‾‾‾" "diff=$`e'_diff1" $`e'_x_1_2 1.5 "p-val``e'_psym_1'$`e'_option1" ///
		$`e'_x_4 6  "diff=$`e'_diff4" $`e'_x_4_2 6 "p-val``e'_psym_4'$`e'_option4" ///
		$`e'_x_2 4.5  "‾‾‾‾‾‾‾‾" "diff=$`e'_diff2" $`e'_x_2_2 4.5 "p-val``e'_psym_2'$`e'_option2" ///
		$`e'_x_5 6.5  "diff=$`e'_diff5" $`e'_x_5_2 6.5 "p-val``e'_psym_5'$`e'_option5" ///
		$`e'_x_3 7.5  "‾‾‾‾‾‾‾‾" "diff=$`e'_diff3" $`e'_x_3_2 7.5 "p-val``e'_psym_3'$`e'_option3" ///
		, size(vsmall))
		
		graph export "$output_dir/mean_`e'_survey3.png", replace
}

use `temp', clear

* Gen graphs by different subsamples for scenario 2

* T-tests
forval s2choice = 1/2 {

	preserve
	drop lu rel*

	keep if s2_choice == `s2choice'

	reshape wide csa_fair csa_finan csa_guilt csa_happy csa_pride csa_satis csa_unfair, ///
	i(id option) j(scenario)

	foreach e in guilt pride fair unfair finan satis happy {
		
	ttest csa_`e'1== csa_`e'2 if option==1
		global `e'_option1_`s2choice' = `"`: display %4.2f r(p)'"'
		global `e'_diff1_`s2choice' = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
		
	ttest csa_`e'1== csa_`e'2 if option==2
		global `e'_option2_`s2choice' = `"`: display %4.2f r(p)'"'
		global `e'_diff2_`s2choice' = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
		
	ttest csa_`e'1== csa_`e'3 if option==3
		global `e'_option3_`s2choice' = `"`: display %4.2f r(p)'"'
		global `e'_diff3_`s2choice' = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
		
	gen csa_`e'_1_2_temp_`s2choice' = csa_`e'1 if option==2
	gen csa_`e'_2_2_temp_`s2choice' = csa_`e'2 if option==2
	gen csa_`e'_3_3_temp_`s2choice' = csa_`e'3 if option==3
	
	by id: egen csa_`e'_1_2_`s2choice' = max(csa_`e'_1_2_temp_`s2choice')
	by id: egen csa_`e'_2_2_`s2choice' = max(csa_`e'_2_2_temp_`s2choice')
	by id: egen csa_`e'_3_3_`s2choice' = max(csa_`e'_3_3_temp_`s2choice')
	
	drop *temp*
	
	ttest csa_`e'_1_2_`s2choice' = csa_`e'_3_3_`s2choice'
	global `e'_option4_`s2choice' = `"`: display %4.2f r(p)'"'
	global `e'_diff4_`s2choice'= `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'	
	
	ttest csa_`e'_2_2_`s2choice' = csa_`e'_3_3_`s2choice'
	global `e'_option5_`s2choice' = `"`: display %4.2f r(p)'"'
	global `e'_diff5_`s2choice'= `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
		
		
	}

	restore
}

* Plots for choice 1
foreach e in guilt pride fair unfair finan satis happy {
	
	if "`e'"=="guilt" {
		local title "Guilt"
	}
	if "`e'"=="pride" {
		local title "Pride"
	}
	if "`e'"=="fair" {
		local title "Fairness"
	}
	if "`e'"=="unfair" {
		local title "Unfairness"
	}
	if "`e'"=="finan" {
		local title "Financial Satisfaction"
	}
	if "`e'"=="satis" {
		local title "Satisfaction"
	}
	if "`e'"=="happy" {
		local title "Happiness"
	}

	preserve
	
	keep if s2_choice == 1
	collapse (mean) csa_`e' (semean) se=csa_`e', by(scenario option)
	gen u = csa_`e' + 1.96*se
	gen l = csa_`e' - 1.96*se
	drop if csa_`e'==.
	
		sum csa_`e' if scenario ==1 & option ==1
		scalar csa_`e'_1_1 = r(mean)
		
		sum csa_`e' if scenario ==1 & option ==2
		scalar csa_`e'_1_2 = r(mean)
		
		sum csa_`e' if scenario ==1 & option ==3
		scalar csa_`e'_1_3 = r(mean)
		
		sum csa_`e' if scenario ==2 & option ==1
		scalar csa_`e'_2_1 = r(mean)
		
		sum csa_`e' if scenario ==2 & option ==2
		scalar csa_`e'_2_2 = r(mean)
		
		sum csa_`e' if scenario ==3 & option ==3
		scalar csa_`e'_3_3 = r(mean)
		
		if 	$`e'_diff1_1  >= 0 {
			global `e'_x_1 = csa_`e'_2_1 - 0.09
			global `e'_x_1_2 = $`e'_x_1 - 0.05
		}
		
		if 	$`e'_diff1_1  < 0 {
			global `e'_x_1 = csa_`e'_1_1 - 0.09
			global `e'_x_1_2 = $`e'_x_1 - 0.05
		}
				
		if 	$`e'_diff2_1 >= 0 {
			global `e'_x_2 = csa_`e'_2_2 - 0.09
			global `e'_x_2_2 = $`e'_x_2 - 0.05
		}
		
		if 	$`e'_diff2_1 < 0 {
			global `e'_x_2 = csa_`e'_1_2 - 0.09
			global `e'_x_2_2 = $`e'_x_2 - 0.05
		}
		
		if 	$`e'_diff3_1 >= 0 {
			global `e'_x_3 = csa_`e'_3_3 - 0.09
			global `e'_x_3_2 = $`e'_x_3 - 0.05
		}
		
		if 	$`e'_diff3_1  < 0 {
			global `e'_x_3 = csa_`e'_1_3 - 0.09
			global `e'_x_3_2 = $`e'_x_3 - 0.05
		}
	
	
		if $`e'_option1_1 < 0.01 {
				global `e'_option1_1 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option2_1 < 0.01 {
				global `e'_option2_1 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option3_1 < 0.01 {
				global `e'_option3_1 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option4_1 < 0.01 {
				global `e'_option4_1 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option5_1 < 0.01 {
				global `e'_option5_1 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option1_1 < 0.001 {
				global `e'_option1_1 =  `" `: display %4.2f 0.001'"'
		}
		
		if $`e'_option2_1 < 0.001 {
				global `e'_option2_1 =  `" `: display %4.2f 0.001'"'
		}
		
		if $`e'_option3_1 < 0.001 {
				global `e'_option3_1 =  `" `: display %4.2f 0.001'"'
		}	
		
		if $`e'_option4_1 < 0.001 {
				global `e'_option4_1 =  `" `: display %4.2f 0.001'"'
		}	
		
		if $`e'_option5_1 < 0.001 {
				global `e'_option5_1 =  `" `: display %4.2f 0.001'"'
		}		

		if $`e'_option1_1 > 0.01 {
			local `e'_psym_1 = "="
		}

		if $`e'_option2_1 > 0.01 {
			local `e'_psym_2 = "="
		}
		
		if $`e'_option3_1 > 0.01 {
			local `e'_psym_3 = "="
		}
		
		if $`e'_option4_1 > 0.01 {
			local `e'_psym_4 = "="
		}

		if $`e'_option5_1 > 0.01 {
			local `e'_psym_5 = "="
		}
		
		if $`e'_option1_1 <= 0.01 {
			local `e'_psym_1 = "<"
		}	
		
		if $`e'_option2_1 <= 0.01 {
			local `e'_psym_2 = "<"
		}
		
		if $`e'_option3_1 <= 0.01 {
			local `e'_psym_3 = "<"
		}
		
		if $`e'_option4_1 <= 0.01 {
			local `e'_psym_4 = "<"
		}
		
		if $`e'_option5_1 <= 0.01 {
			local `e'_psym_5 = "<"
		}
		
	sort option scenario
	gen graph_order=_n
	replace graph_order=graph_order+1 if _n>2
	replace graph_order=graph_order+1 if _n>4
	
		if 	$`e'_x_2  >= $`e'_x_3 {
			global `e'_x_4 = $`e'_x_2 + 0.34
			global `e'_x_4_2 = $`e'_x_4 - 0.05
		}
		
		if 	$`e'_x_2  < $`e'_x_3 {
			global `e'_x_4 = $`e'_x_3 + 0.34
			global `e'_x_4_2 = $`e'_x_4 - 0.05
		}
	
	gen l1 = $`e'_x_4_2 
	
		if 	$`e'_x_2  >= $`e'_x_3 {
			global `e'_x_5 = $`e'_x_3 - 0.05
			global `e'_x_5_2 = $`e'_x_5 - 0.05
		}
	
		if 	$`e'_x_2  < $`e'_x_3 {
			global `e'_x_5 = $`e'_x_2 - 0.05
			global `e'_x_5_2 = $`e'_x_5 - 0.05
		}
		
		global `e'_x_4 = $`e'_x_4 + 0.06
		global `e'_x_4_2 = $`e'_x_4 - 0.05
			
	gen l2 = $`e'_x_5_2 
	
		global `e'_x_5 = $`e'_x_5 - 0.1
		global `e'_x_5_2 = $`e'_x_5 - 0.05

	tw (rcap u l graph_order if scenario==1, lcolor(midblue)) ///
		(sc csa_`e' graph_order if scenario==1, mcolor(midblue)) ///
		(rcap u l graph_order if scenario==2, lcolor(cranberry)) ///
		(sc csa_`e' graph_order if scenario==2, mcolor(cranberry)) ///
		(rcap u l graph_order if scenario==3, lcolor(orange)) /// 
		(sc csa_`e' graph_order if scenario==3, mcolor(orange)) ///
		(line l1 graph_order if option == 2 | option == 3, lc(black) lwidth(thin)) ///
		(line l2 graph_order if (option == 2 & scenario ==2) | option == 3, lc(black) lwidth(thin)) , ///
		ytitle("`title'") xtitle("") xsc(range(0.5 8.5)) ///
		legend(order(2 "Scenario 1: Don`=char(39)'t open option" 4 "Scenario 2: Opened door" ///
		6 "Scenario 3: Not home")) ylab(-0.2(.1)1) ysc(range(-0.25 1)) graphregion(fcolor(white)) ///
		text($`e'_x_1 1.5  "‾‾‾‾‾‾‾‾" "diff=${`e'_diff1_1}" ///
		$`e'_x_1_2 1.5 "p-val``e'_psym_1'${`e'_option1_1}" ///
		$`e'_x_2 4.5  "‾‾‾‾‾‾‾‾" "diff=${`e'_diff2_1}" ///
		$`e'_x_2_2 4.5 "p-val``e'_psym_2'${`e'_option2_1}" ///
		$`e'_x_4 6  "diff=$`e'_diff4_1" $`e'_x_4_2 6 "p-val``e'_psym_4'$`e'_option4_1" ///
		$`e'_x_5 6.5 "diff=$`e'_diff5_1" $`e'_x_5_2 6.5 "p-val``e'_psym_5'$`e'_option5_1" ///		
		$`e'_x_3 7.5  "‾‾‾‾‾‾‾‾" "diff=${`e'_diff3_1}" ///
		$`e'_x_3_2 7.5 "p-val``e'_psym_3'${`e'_option3_1}", size(vsmall)) ///
		xlab(1.5 "Donate" 4.5 "Don`=char(39)'t Donate" 7.5 "Don`=char(39)'t Open") 
		
	graph export "$output_dir/mean_`e'_survey3_origchoice_s2_1.png", replace
	restore
}

* Plots for choice 2
foreach e in guilt pride fair unfair finan satis happy {
	
	if "`e'"=="guilt" {
		local title "Guilt"
	}
	if "`e'"=="pride" {
		local title "Pride"
	}
	if "`e'"=="fair" {
		local title "Fairness"
	}
	if "`e'"=="unfair" {
		local title "Unfairness"
	}
	if "`e'"=="finan" {
		local title "Financial Satisfaction"
	}
	if "`e'"=="satis" {
		local title "Satisfaction"
	}
	if "`e'"=="happy" {
		local title "Happiness"
	}

	preserve
	
	keep if s2_choice == 2
	collapse (mean) csa_`e' (semean) se=csa_`e', by(scenario option)
	gen u = csa_`e' + 1.96*se
	gen l = csa_`e' - 1.96*se
	drop if csa_`e'==.
	
		sum csa_`e' if scenario ==1 & option ==1
		scalar csa_`e'_1_1 = r(mean)
		
		sum csa_`e' if scenario ==1 & option ==2
		scalar csa_`e'_1_2 = r(mean)
		
		sum csa_`e' if scenario ==1 & option ==3
		scalar csa_`e'_1_3 = r(mean)
		
		sum csa_`e' if scenario ==2 & option ==1
		scalar csa_`e'_2_1 = r(mean)
		
		sum csa_`e' if scenario ==2 & option ==2
		scalar csa_`e'_2_2 = r(mean)
		
		sum csa_`e' if scenario ==3 & option ==3
		scalar csa_`e'_3_3 = r(mean)
		
		if 	$`e'_diff1_2  >= 0 {
			global `e'_x_1 = csa_`e'_2_1 - 0.09
			global `e'_x_1_2 = $`e'_x_1 - 0.05
		}
		
		if 	$`e'_diff1_2  < 0 {
			global `e'_x_1 = csa_`e'_1_1 - 0.09
			global `e'_x_1_2 = $`e'_x_1 - 0.05
		}
				
		if 	$`e'_diff2_2 >= 0 {
			global `e'_x_2 = csa_`e'_2_2 - 0.09
			global `e'_x_2_2 = $`e'_x_2 - 0.05
		}
		
		if 	$`e'_diff2_2  < 0 {
			global `e'_x_2 = csa_`e'_1_2 - 0.09
			global `e'_x_2_2 = $`e'_x_2 - 0.05
		}
		
		if 	$`e'_diff3_2 >= 0 {
			global `e'_x_3 = csa_`e'_3_3 - 0.09
			global `e'_x_3_2 = $`e'_x_3 - 0.05
		}
		
		if 	$`e'_diff3_2  < 0 {
			global `e'_x_3 = csa_`e'_1_3 - 0.09
			global `e'_x_3_2 = $`e'_x_3 - 0.05
		}
	
		if $`e'_option1_2 < 0.01 {
				global `e'_option1_2 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option2_2 < 0.01 {
				global `e'_option2_2 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option3_2 < 0.01 {
				global `e'_option3_2 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option4_2 < 0.01 {
				global `e'_option4_2 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option5_2 < 0.01 {
				global `e'_option5_2 =  `" `: display %4.2f 0.01'"'
		}
		
		if $`e'_option1_2 < 0.001 {
				global `e'_option1_2 =  `" `: display %4.2f 0.001'"'
		}
		
		if $`e'_option2_2 < 0.001 {
				global `e'_option2_2 =  `" `: display %4.2f 0.001'"'
		}
		
		if $`e'_option3_2 < 0.001 {
				global `e'_option3_2 =  `" `: display %4.2f 0.001'"'
		}	
		
		if $`e'_option4_2 < 0.001 {
				global `e'_option4_2 =  `" `: display %4.2f 0.001'"'
		}	
		
		if $`e'_option5_2 < 0.001 {
				global `e'_option5_2 =  `" `: display %4.2f 0.001'"'
		}			

		if $`e'_option1_2 > 0.01 {
			local `e'_psym_1 = "="
		}

		if $`e'_option2_2 > 0.01 {
			local `e'_psym_2 = "="
		}
		
		if $`e'_option3_2 > 0.01 {
			local `e'_psym_3 = "="
		}
		
		if $`e'_option4_2 > 0.01 {
			local `e'_psym_4 = "="
		}

		if $`e'_option5_2 > 0.01 {
			local `e'_psym_5 = "="
		}
		
		if $`e'_option1_2 <= 0.01 {
			local `e'_psym_1 = "<"
		}	
		
		if $`e'_option2_2 <= 0.01 {
			local `e'_psym_2 = "<"
		}
		
		if $`e'_option3_2 <= 0.01 {
			local `e'_psym_3 = "<"
		}
		
		if $`e'_option4_2 <= 0.01 {
			local `e'_psym_4 = "<"
		}
		
		if $`e'_option5_2 <= 0.01 {
			local `e'_psym_5 = "<"
		}
		
	sort option scenario
	gen graph_order=_n
	replace graph_order=graph_order+1 if _n>2
	replace graph_order=graph_order+1 if _n>4
	
		if 	$`e'_x_2  >= $`e'_x_3 {
			global `e'_x_4 = $`e'_x_2 + 0.28
			global `e'_x_4_2 = $`e'_x_4 - 0.05
		}
		
		if 	$`e'_x_2  < $`e'_x_3 {
			global `e'_x_4 = $`e'_x_3 + 0.28
			global `e'_x_4_2 = $`e'_x_4 - 0.05
		}
	
	gen l1 = $`e'_x_4_2 
	
		if 	$`e'_x_2  >= $`e'_x_3 {
			global `e'_x_5 = $`e'_x_3 - 0.05
			global `e'_x_5_2 = $`e'_x_5 - 0.05
		}
	
		if 	$`e'_x_2  < $`e'_x_3 {
			global `e'_x_5 = $`e'_x_2 - 0.05
			global `e'_x_5_2 = $`e'_x_5 - 0.05
		}
		
		global `e'_x_4 = $`e'_x_4 + 0.06
		global `e'_x_4_2 = $`e'_x_4 - 0.05
			
	gen l2 = $`e'_x_5_2 
	
		global `e'_x_5 = $`e'_x_5 - 0.1
		global `e'_x_5_2 = $`e'_x_5 - 0.05

	tw (rcap u l graph_order if scenario==1, lcolor(midblue)) ///
		(sc csa_`e' graph_order if scenario==1, mcolor(midblue)) ///
		(rcap u l graph_order if scenario==2, lcolor(cranberry)) ///
		(sc csa_`e' graph_order if scenario==2, mcolor(cranberry)) ///
		(rcap u l graph_order if scenario==3, lcolor(orange)) /// 
		(sc csa_`e' graph_order if scenario==3, mcolor(orange)) ///
		(line l1 graph_order if option == 2 | option == 3, lc(black) lwidth(thin)) ///
		(line l2 graph_order if (option == 2 & scenario ==2) | option == 3, lc(black) lwidth(thin)) , ///
		ytitle("`title'") xtitle("") xsc(range(0.5 8.5)) ///
		legend(order(2 "Scenario 1: Don`=char(39)'t open option" 4 "Scenario 2: Opened door" ///
		6 "Scenario 3: Not home")) ylab(-0.2(.1)1) ysc(range(-0.25 1)) graphregion(fcolor(white)) ///
		text($`e'_x_1 1.5  "‾‾‾‾‾‾‾‾" "diff=${`e'_diff1_2}" ///
		$`e'_x_1_2 1.5 "p-val``e'_psym_1'${`e'_option1_2}" ///
		$`e'_x_2 4.5  "‾‾‾‾‾‾‾‾" "diff=${`e'_diff2_2}" ///
		$`e'_x_2_2 4.5 "p-val``e'_psym_2'${`e'_option2_2}" ///
		$`e'_x_4 6  "diff=$`e'_diff4_2" $`e'_x_4_2 6 "p-val``e'_psym_4'$`e'_option4_2" ///
		$`e'_x_5 6.5 "diff=$`e'_diff5_2" $`e'_x_5_2 6.5 "p-val``e'_psym_5'$`e'_option5_2" ///
		$`e'_x_3 7.5  "‾‾‾‾‾‾‾‾" "diff=${`e'_diff3_2}" ///
		$`e'_x_3_2 7.5 "p-val``e'_psym_3'${`e'_option3_2}", size(vsmall)) ///
		xlab(1.5 "Donate" 4.5 "Don`=char(39)'t Donate" 7.5 "Don`=char(39)'t Open") 
		
	graph export "$output_dir/mean_`e'_survey3_origchoice_s2_2.png", replace
	restore
}


do $code_dir/comp_OO_CC.do
