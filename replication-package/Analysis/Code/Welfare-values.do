/* _____________________________________________________________________________

	WELFARE VALUES
	
	Numbers reported in the text of the paper
_____________________________________________________________________________ */


global lu_calc 			"guilt*_b[rel_guilt]+pride*_b[rel_pride]+finan*_b[rel_finan]+fair*_b[rel_fair]+unfair*_b[rel_unfair]+happy*_b[rel_happy]+satis*_b[rel_satis]"
global est 				"guilt_w=r(guilt_w) pride_w=r(pride_w) finan_w=r(finan_w) fair_w=r(fair_w) unfair_w=r(unfair_w) happy_w=r(happy_w) satis_w=r(satis_w)"
global lu_calc_wide1 	"guilt1*_b[rel_guilt]+pride1*_b[rel_pride]+finan1*_b[rel_finan]+fair1*_b[rel_fair]+unfair1*_b[rel_unfair]+happy1*_b[rel_happy]+satis1*_b[rel_satis]"
global lu_calc_wide2 	"guilt2*_b[rel_guilt]+pride2*_b[rel_pride]+finan2*_b[rel_finan]+fair2*_b[rel_fair]+unfair2*_b[rel_unfair]+happy2*_b[rel_happy]+satis2*_b[rel_satis]"
global lu_calc_wide3 	"guilt3*_b[rel_guilt]+pride3*_b[rel_pride]+finan3*_b[rel_finan]+fair3*_b[rel_fair]+unfair3*_b[rel_unfair]+happy3*_b[rel_happy]+satis3*_b[rel_satis]"
global emotions			"guilt pride finan fair unfair happy satis"
global emotions_reg		"rel_guilt rel_pride rel_finan rel_fair rel_unfair rel_happy rel_satis"
global emotions_regw	"rel_guilt1 rel_pride1 rel_finan1 rel_fair1 rel_unfair1 rel_happy1 rel_satis1"



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


* Issue 1-2: regress the money-metric utility from the less equitable option from 
* DG 1,2,3,4 on the DG number. That is, the right-hand-side variable in the 
* regression is simply the number of the DG: 1,2,3 or 4. 
cap program drop prog_i12
program define prog_i12, rclass
	preserve
	
	* Generate LU and MMU
	prog_lu_mmu_long
	
	* Get difference between DG1 and DG4 less equitable
	sum mmu if choice_set==1 & prosocial==0 & part==1 
	local mean1=r(mean)
	sum mmu if choice_set==4 & prosocial==0 & part==1 
	return scalar dg1_dg4_diff = `mean1' - r(mean)
	
	* Reg choice set on mmu
	reg mmu choice_set if part==1 & prosocial==0 & inrange(choice_set,1,4)
	return scalar cs_coef = _b[choice_set]
	
	restore
end

* Issue 3-4: regress the money-metric utility from the more equitable option from 
* DG 4,5,6,7 on the DG number. That is, the right-hand-side variable in the 
* regression is simply the number of the DG: 4,5,6, or 7.
cap program drop prog_i34
program define prog_i34, rclass
	preserve
	
	* Generate LU and MMU
	prog_lu_mmu_long
	
	* Get difference between DG1 and DG4 more equitable
	sum mmu if choice_set==4 & prosocial==1 & part==1 
	local mean1=r(mean)
	sum mmu if choice_set==7 & prosocial==1 & part==1 
	return scalar dg4_dg7_diff = `mean1' - r(mean)
	
	* Reg choice set on mmu
	reg mmu choice_set if part==1 & prosocial==1 & inrange(choice_set,4,7)
	return scalar cs_coef = _b[choice_set]
	
	restore
end


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

* Get average mm for DG 1 and 4 (less equitable) and DG 4 and 7 (more equitable)
preserve
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

sum mmu if choice_set==1 & prosocial==0 & part==1 
local mean1: di %3.2f r(mean)
latex_write dgonea `mean1' numbers_pipe

sum mmu if choice_set==4 & prosocial==0 & part==1 
local mean4: di %3.2f r(mean)
latex_write dgfour `mean4' numbers_pipe

sum mmu if choice_set==4 & prosocial==1 & part==1 
local mean4e: di %3.2f r(mean)
latex_write dgfoure `mean4e' numbers_pipe
	
sum mmu if choice_set==7 & prosocial==1 & part==1 
local mean7: di %3.2f r(mean)
latex_write dgsevena `mean7' numbers_pipe

reg mmu choice_set if part==1 & prosocial==1 & inrange(choice_set,4,7)
local mean8: di %3.2f _b[choice_set]
latex_write coefdge `mean8' numbers_pipe

reg mmu choice_set if part==1 & prosocial==0 & inrange(choice_set,1,4)
local mean9: di %3.2f _b[choice_set]
latex_write coefdgle `mean9' numbers_pipe
restore

* Diff between less equitable DG 1 and 4
bootstrap dg1_dg4_diff=r(dg1_dg4_diff) cs_coef=r(cs_coef), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_i12
estat bootstrap, all
mat CI = e(ci_percentile)
local dgonefourlo: di %4.2g CI[1,1]
latex_write dgonefourlo `dgonefourlo' numbers_pipe
local dgonefourhi: di %4.2g CI[2,1]
latex_write dgonefourhi `dgonefourhi' numbers_pipe
local coefdglelo: di %4.2g CI[1,2]
latex_write coefdglelo `coefdglelo' numbers_pipe
local coefdglehi: di %4.2g CI[2,2]
latex_write coefdglehi `coefdglehi' numbers_pipe

* Diff between more equitable DG4 and 7
bootstrap dg4_dg7_diff=r(dg4_dg7_diff) cs_coef=r(cs_coef), ///
	reps(1000) seed(123450) cluster(mturkid) nodrop: prog_i34
estat bootstrap, all
mat CI = e(ci_percentile)
local dgfoursevenlo: di %4.2g CI[1,1]
latex_write dgfoursevenlo `dgfoursevenlo' numbers_pipe
local dgfoursevenhi: di %4.2g CI[2,1]
latex_write dgfoursevenhi `dgfoursevenhi' numbers_pipe
local coefdgelo: di %4.2g CI[1,2]
latex_write coefdgelo `coefdgelo' numbers_pipe
local coefdgehi: di %4.2g CI[2,2]
latex_write coefdgehi `coefdgehi' numbers_pipe


