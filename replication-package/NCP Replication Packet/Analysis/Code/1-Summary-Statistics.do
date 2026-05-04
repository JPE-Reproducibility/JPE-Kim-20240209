/* _____________________________________________________________________________

	SUMMARY STATISTICS
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* X axis labels and range
global yaxis ylab(0(10)100) yscale(range(0 100)) ytitle("Percent")


*-------------------------------------*
*	Tabulate
*-------------------------------------*

use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear

* Get demographic counts into latex tables
capture confirm file "$output_dir/all_sumstats_demo.tex"
if _rc!=0 {
	tabout gender age educ hhinc if tag==1 using "$output_dir/all_sumstats_demo.tex", ///
		replace style(tex) font(bold) oneway c(freq col) bt topstr(8cm) ///
		f(0c) clab(Count Col_%) topf($code_dir/top.tex) botf($code_dir/bot.tex) 
}

* Save some stats in a tex file to use in the paper
gen female=gender==1
sum female
local female: di %9.0f r(mean)*100
latex_write demofem `female' numbers_pipe

gen age_2560=inlist(age,2,3)
sum age_2560
local age: di %9.0f r(mean)*100
latex_write demoage `age' numbers_pipe

gen educ_bac=inlist(educ,4,5)
sum educ_bac
local educ: di %9.0f r(mean)*100
latex_write demoeduc `educ' numbers_pipe

gen hhinc_28=inlist(hhinc,2,3,4)
sum hhinc_28
local hhinc: di %9.0f r(mean)*100
latex_write demohhinc `hhinc' numbers_pipe
	


*-------------------------------------*
*	Choices made/seen
*-------------------------------------*

* Only keep the ones with the main CSA elicitations
keep if inlist(treatment,"main","cs")

* DG ___________________________________________________________________________
* Graph choices in the DG
preserve
keep if part==1
	
* Get counts
gen count=1
collapse (count) count, by(part1_choice choice_set)
bys choice_set: egen sum=total(count)
gen perc = (count/sum)*100

* Change the axis so each type in each choice set lies together
* Want 7 clusters of 4 bars (will relabel axis)
local count=0
gen graph_choice=choice_set
foreach choice of numlist 1/7 {
	replace graph_choice=choice_set+`count' if choice_set==`choice' & part1==1
	replace graph_choice=choice_set+`count'+1 if choice_set==`choice' & part1==0
	local count = `count'+2
}

* Graph DG choice with CI for each part
twoway (bar perc graph_choice if part1==1, fcolor(ebblue) lcolor(ebblue)) ///
	(bar perc graph_choice if part1==0, fcolor(orange) lcolor(orange)), ///
	$legend_p1 $yaxis $xaxis_p1 xtitle("")
graph export "$output_dir/main_sumstat_cs_part1.pdf", replace

* Save some choices in latex file
sum perc if choice_set==1 & part1==1
local dg1: di %9.0f r(mean)
latex_write dgone `dg1' numbers_pipe

sum perc if choice_set==7 & part1==1
local dg7: di %9.0f r(mean)
latex_write dgseven `dg7' numbers_pipe
restore


* OO ___________________________________________________________________________
* Graph choice, averaged over all subgames
preserve
keep if part==3
	
* Get counts
gen count=1
collapse (count) count, by(part3_choice choice_set)
bys choice_set: egen sum=total(count)
gen perc = (count/sum)*100

* Change the axis so each type in each choice set lies together
* Want 7 clusters of 4 bars (will relabel axis)
local count=0
gen graph_choice=choice_set
foreach choice of numlist 1/4 {
	replace graph_choice=choice_set+`count' if choice_set==`choice' & part3==1
	replace graph_choice=choice_set+`count'+1 if choice_set==`choice' & part3==0
	replace graph_choice=choice_set+`count'+2 if choice_set==`choice' & part3==2
	local count = `count'+3
}

twoway (bar perc graph_choice if part3==1, fcolor(ebblue) lcolor(ebblue)) ///
	(bar perc graph_choice if part3==0, fcolor(orange) lcolor(orange)) ///
	(bar perc graph_choice if part3==2, fcolor(cranberry) lcolor(cranberry)), ///
	$yaxis $legend_p3 $xaxis_p3 xtitle("")
graph export "$output_dir/sumstat_cs_part3.pdf", replace
restore


* Graph choice, separated  by subgames
preserve
keep if part==3
	
* Get counts
gen count=1
collapse (count) count, by(part3_choice choice_set optout_allocation)
bys choice_set optout_allocation: egen sum=total(count)
gen perc = (count/sum)*100

* Change the axis so each type in each choice set lies together
* Want 7 clusters of 4 bars (will relabel axis)
local count=0
gen graph_choice=choice_set
foreach choice of numlist 1/4 {
	replace graph_choice=choice_set+`count' if choice_set==`choice' & part3==1
	replace graph_choice=choice_set+`count'+1 if choice_set==`choice' & part3==0
	replace graph_choice=choice_set+`count'+2 if choice_set==`choice' & part3==2
	local count = `count'+3
}

* Graph scatter with CI for each part
foreach o of numlist 3/5 {
	if `o'==3 {
		local a (2,1.5), (4,0)
	}
	if `o'==4 {
		local a (2,2), (4,0)
	}
	if `o'==5 {
		local a (2,2), (3.5,0)
	}
	
	twoway (bar perc graph_choice if part3==1 & opt==`o', fcolor(ebblue) lcolor(ebblue)) ///
		(bar perc graph_choice if part3==0 & opt==`o', fcolor(orange) lcolor(orange)) ///
		(bar perc graph_choice if part3==2 & opt==`o', fcolor(cranberry) lcolor(cranberry)), ///
		$yaxis  $legend_p3 $xaxis_p3  xtitle("Opt-In Subgame: `a'", height(5))
	graph export "$output_dir/main_sumstat_part3_optout`o'.pdf", replace
}
restore




* OO vs DG _____________________________________________________________________

* Separate by more/less equitable in DG and graph OO choices
preserve

* Find the DG choices made for the OO allocation
replace part1_choice=. if choice_set!=optout_all
bys mturkid: egen p1_c4_choice=min(part1_choice)
count if part1_choice==1 & part==1
local count1=r(N)
count if part1_choice==0 & part==1
local count0=r(N)

* Collapse by OO choices sets and choice in DG
keep if part==3
gen p3_p0=part3_choice==0
gen p3_p1=part3_choice==1
gen p3_p2=part3_choice==2

collapse (count) n=part3_choice (sum) p3_*, by(choice_set p1_c4_choice)
list
reshape long p3_p, i(choice_set p1_c4_choice) j(prosocial)

* Format the xaxis
replace prosocial=-1 if prosocial==1
gsort -p1 choice_set prosocial
gen order=_n
gen graph_order=_n
forvalue i=3(3)21 {
	replace graph_order=graph_order+1 if order>`i'
}

* Graph
gen perc=p3_p/n*100
tw (bar perc graph_order if prosocial==-1, fcolor(ebblue) lcolor(ebblue)) ///
	(bar perc graph_order if prosocial==0, fcolor(orange) lcolor(orange)) ///
	(bar perc graph_order if prosocial==2, fcolor(cranberry) lcolor(cranberry)), ///
	$legend_p3 xlab(2 "OO1" 6 "OO2" 10 "OO3" 14 "OO4" 18 "OO1" 22 "OO2" ///
	26 "OO3" 30 "OO4", labsize(small)) xline(16) xtitle("") $yaxis ///
	text(100 8 "More Equitable in the DG" "n=`count1'" ///
	100 25 "Less Equitable in the DG" "n=`count0'", size(small))
graph export "$output_dir/sumstat_part1_part3.pdf", replace
restore


	
*-------------------------------------*
*	CSA ratings
*-------------------------------------*

* Graph average CSA ratings for each of the choice sets in the DG, CC and OO
use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear

* Graph each emotion by choice set and prosocial/less prosocial in DG 
foreach emotion in guilt pride finan fair unfair happy satis {
	preserve
	
	* The DG and OO are the same in main treatment vs CS treatment, make all "main" treatment
	replace treatment="main" if treatment=="cs" & (part==1 | part==3)
	keep if treatment=="main" | treatment=="cs"

	* Must graph OO on the DG/CC axis, so change choice set to reflect the opt-in allocation
	replace choice_set=optout_al if part==3
	collapse (mean) `emotion'*, by(choice_set part treatment)
			
	* Reshape to reformat xaxis
	reshape long `emotion'_ , i(choice_set part treatment) j(prosocial) string
	replace prosocial="1" if prosocial=="p1"
	replace prosocial="0" if prosocial=="p0"
	destring prosocial, replace force
	drop if prosocial==.
	drop if `emotion'==.
	
	* Get xaxis so all the CSAs for different parts are clumped around the same choice set
	gsort part treatment choice_set -prosocial
	egen graph_order = seq(), f(1) t(14)
	gen n=graph_order
	forval i=2(2)14 {
		replace graph_order=graph_order+1 if n>`i'
	}
	replace graph_order=graph_order+6 if part==3
	gsort choice_set -prosocial part -treatment
	replace graph_order=graph_order[_n-1]+1/5 if choice_set==choice_set[_n-1] & prosocial==prosocial[_n-1]
	replace graph_order=graph_order-.5 if prosocial==1
	replace graph_order=graph_order-.2 if prosocial==0

	* Graph
	twoway (sc `emotion' graph_order if prosocial==1 & part==1, mcolor(ebblue%60)) ///
		(sc `emotion' graph_order if prosocial==0 & part==1, mcolor(orange%60)) ///
		(sc `emotion' graph_order if prosocial==1 & part==2 & treatment=="main", mcolor(ebblue%60) m(T)) ///
		(sc `emotion' graph_order if prosocial==0 & part==2 & treatment=="main", mcolor(orange%60) m(T)) ///
		(sc `emotion' graph_order if prosocial==1 & part==2 & treatment=="cs", mcolor(ebblue%60) m(S)) ///
		(sc `emotion' graph_order if prosocial==0 & part==2 & treatment=="cs", mcolor(orange%60) m(S)) ///
		(sc `emotion' graph_order if prosocial==1 & part==3, mcolor(ebblue%60) m(D)) ///
		(sc `emotion' graph_order if prosocial==0 & part==3, mcolor(orange%60) m(D)), ///
		ylab(0(.1)1) yscale(range(0 1)) ytitle("Normalized CSA Ratings", size(small)) ///
		xtitle("") xscale(range(0.5 7.5)) xlab(1.5 `""CS1" "(2,0.5), (4,0)""' ///
		4.5 `""CS2" "(2,1), (4,0)""' 7.5 `""CS3" "(2,1.5), (4,0)""' ///
		10.5 `""CS4" "(2,2), (4,0)""' 13.5 `""CS5" "(2,2), (3.5,0)""' ///
		16.5 `""CS6" "(2,2), (3,0)""' 19.5 `""CS7" "(2,2), (2.5,0)""', labsize(vsmall)) ///
		legend(order(1 "DG More Equitable"  3 "CC More Equitable" 5 "CC Choice Set More Equitable" ///
		7 "OO More Equitable" 2 "DG Less Equitable" 4 "CC Less Equitable" ///
		6 "CC Choice Set Less Equitable" 8 "OO Less Equitable") size(vsmall))
	graph export "$output_dir/main_sumstat_`emotion'.pdf", replace
	
	restore
}


* Graph each emotion by choice set and equitable/less equitable in OO
foreach emotion in guilt pride finan fair unfair happy satis {
	preserve
	keep if part==3 & (treatment=="main" | treatment=="cs")
	
	* Get means and se's
	collapse (mean) `emotion'* (semean) se_p0 = `emotion'_p0 ///
	se_p1 = `emotion'_p1 se_p2 = `emotion'_p2, by(choice_set)
	
	* Get the confidence intervals
	foreach type in p0 p1 p2 {	
		gen u_`type' = `emotion'_`type' + 1.96*se_`type'
		gen l_`type' = `emotion'_`type' - 1.96*se_`type'
	}
	
	* Reshape to reformat xaxis (if time permits, move this analysis on long data)
	reshape long `emotion'_ u_ l_, i(choice_set) j(prosocial) string
	replace prosocial="1" if prosocial=="p1"
	replace prosocial="0" if prosocial=="p0"
	replace prosocial="2" if prosocial=="p2"
	destring prosocial, replace
	
	* Change the axis so each type in each choice set lies together
	* Want 7 clusters of 4 bars (will relabel axis)
	local count=0
	gen graph_choice=choice_set
	foreach choice of numlist 1/4 {
		replace graph_choice=choice_set+`count' if choice_set==`choice' & prosocial==1
		replace graph_choice=choice_set+`count'+1 if choice_set==`choice' & prosocial==0
		replace graph_choice=choice_set+`count'+2 if choice_set==`choice' & prosocial==2
		local count = `count'+3
	}
		
	* Graph scatter with CI for each part
	twoway (rspike u_ l_ graph_choice if prosocial==1, lcolor(ebblue)) ///
		(rspike u_ l_ graph_choice if prosocial==0, lcolor(orange)) ///
		(rspike u_ l_ graph_choice if prosocial==2, lcolor(cranberry)) ///
		(sc `emotion' graph_choice if prosocial==1, mcolor(ebblue)) ///
		(sc `emotion' graph_choice if prosocial==0, mcolor(orange)) ///
		(sc `emotion' graph_choice if prosocial==2, mcolor(cranberry)), ///
		$legend_p3_2 ylab(0(.1)1) yscale(range(0 1)) $xaxis_p3 /// 
		xtitle("Opt-In Subgame: `a'", height(5)) ytitle("")
	graph export "$output_dir/main_sumstat_`emotion'_part3.pdf", replace

	restore
}



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
