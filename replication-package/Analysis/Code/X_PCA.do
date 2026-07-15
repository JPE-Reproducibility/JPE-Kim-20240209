/* _____________________________________________________________________________

	Principal Components Analysis
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 		Globals and Programs
* ---------------------------------------------- *

* Globals for figure properties
local overline = uchar(773) 
global ytitle 	"u`overline'{sub:jc} (in $ rel. to Computer Choice (0,0))"

* Clean the data
cap program drop prog_clean_data
program define prog_clean_data, rclass
	use "$prepped_data_dir/mturk_all_wide_analysis.dta", clear
	keep if inlist(treatment,"main","cs")
	
	* Make descriptive variables and xtset
	egen id=group(mturkid)
	xtset id
	egen part_cs = tag(mturkid part choice_set)

	** Relative emotions 
	foreach emotion in guilt pride finan fair unfair happy satis {
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
end

* Construct money metric utility and differences in EV
cap program drop prog_pca_graph
program define prog_pca_graph, rclass
	
	preserve
	* Get reg coefficients for relative weights of each emotion
	logit part1_choice rel_* if part==1, r nocons
	
	* Multiply the emotion scores by coefficients and create utility measure
	gen lu=guilt*_b[rel_guilt]+pride*_b[rel_pride]+finan*_b[rel_finan] ///
		+fair*_b[rel_fair]+unfair*_b[rel_unfair]+happy*_b[rel_happy]+satis*_b[rel_satis]
	
	* PCA
	pca guilt pride finan fair unfair happy satis
	predict pc1 pc2 pc3 pc4 pc5
	egen group=group(`0' choice_set part)
	asclogit choice1 pc1 pc2 if part==1 & inlist(treatment,"main","cs"), ///
		case(group) alt(prosocial) cluster(`0') 
	gen lu2=pc1*_b[pc1]+pc2*_b[pc2] //+pc3*_b[pc3]
	
	* Now reg latent utility on the payoff and get mmu
	reg lu payoff if part==2 & inlist(choice_set,4,5,6,7) & treatment=="main", r
	gen mmu = lu/_b[payoff] //money-metric utility
	reg lu2 payoff if part==2 & inlist(choice_set,4,5,6,7) & treatment=="main", r
	gen mmu2 = lu2/_b[payoff] //money-metric utility
	
	* Make rel to (0,0)
	sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	replace mmu=mmu-r(mean)+4
	sum mmu2 if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
	replace mmu2=mmu2-r(mean)+4
	
	* Get averages
	forval c=1/7 {
		forval p=0/1 {
			sum mmu if part==1 & choice_set==`c' & prosocial==`p'
			return scalar mmu_c`c'_p`p'=r(mean)
			sum mmu2 if part==1 & choice_set==`c' & prosocial==`p'
			return scalar mmu2_c`c'_p`p'=r(mean)
		}
	}
	restore
	
end


*---------------------------------------------*
*	PCA Analysis
*---------------------------------------------*

* Open data and clean
prog_clean_data

* Get components
pca guilt pride finan fair unfair happy satis, components(2)
predict pc1 pc2 pc3 pc4 pc5

* Put in table
matrix ev = e(Ev)'
matrix roweq ev = ""
matrix colnames ev = "Eigenvalue"
matrix p = ev[1...,1] / e(trace)
matrix colnames p = "Proportion of Variance"
matrix c = J(e(trace),1,0)
matrix c[1,1] = p[1,1]
forvalues i=2/`e(trace)' {
	matrix c[`i',1] = c[`=`i'-1',1] + p[`i',1]
}
matrix colnames c = "Cumulative"
matrix t = (ev,p,c)
matrix list t
estadd matrix table = t
eststo t

* Save cumulative variance 
mat c = e(table)
local pcacum = round(c[2,3]*100,1)
local pcacum: di %9.2f `pcacum'
latex_write pcacum `pcacum' numbers_pipe
local pcalow = round(c[7,2]*100,1)
local pcalow: di %9.2f `pcalow'
latex_write pcalow `pcalow' numbers_pipe

* Put in table
esttab t using "$output_dir/pca_ev.tex", replace  ///
	nogap noobs nonumber nomtitle nonote booktabs label $tablefit ///
	cells("table[Eigenvalue](t fmt(2)) table[Proportion of Variance](t fmt(2)) table[Cumulative](t fmt(2))") ///
	varlabels(Comp1 "Component 1" Comp2 "Component 2" Comp3 "Component 3" ///
	Comp4 "Component 4" Comp5 "Component 5" Comp6 "Component 6" Comp7 "Component 7") 
eststo clear	


*---------------------------------------------*
*	Graph PCA vs CSAs on EV
*---------------------------------------------*
	
* Compare EVs from PCA vs 7 CSAs
capture confirm file "$bootstrapped_data/pca2.dta"
if _rc!=0 {
	* Open data and clean
	prog_clean_data
	gen choice1=(part1_choice==prosocial)
	gen choice3=(part3_choice==prosocial)

	* Get regular MMU
	bootstrap mmu_c1_p1=r(mmu_c1_p1) mmu_c1_p0=r(mmu_c1_p0) ///
		mmu_c2_p1=r(mmu_c2_p1) mmu_c2_p0=r(mmu_c2_p0) ///
		mmu_c3_p1=r(mmu_c3_p1) mmu_c3_p0=r(mmu_c3_p0) ///
		mmu_c4_p1=r(mmu_c4_p1) mmu_c4_p0=r(mmu_c4_p0) ///
		mmu_c5_p1=r(mmu_c5_p1) mmu_c5_p0=r(mmu_c5_p0) ///
		mmu_c6_p1=r(mmu_c6_p1) mmu_c6_p0=r(mmu_c6_p0) ///
		mmu_c7_p1=r(mmu_c7_p1) mmu_c7_p0=r(mmu_c7_p0), ///
		reps(1000) seed(123450) cluster(mturkid) idcluster(newid) nodrop: ///
		prog_pca_graph newid
	estat bootstrap, all

	* Put graph format
	preserve
	prog_mat
	gen prosocial = mod(n,2)

	* Format x axis
	gen graph_order=n
	foreach num of numlist 2(2)28 {
		replace graph_order=graph_order+1 if n>`num'
	}
	gen sample="CSA"

	* Temp file
	save "$bootstrapped_data/pca1.dta", replace
	restore

	* With PCAs
	bootstrap mmu2_c1_p1=r(mmu2_c1_p1) mmu2_c1_p0=r(mmu2_c1_p0) ///
		mmu2_c2_p1=r(mmu2_c2_p1) mmu2_c2_p0=r(mmu2_c2_p0) ///
		mmu2_c3_p1=r(mmu2_c3_p1) mmu2_c3_p0=r(mmu2_c3_p0) ///
		mmu2_c4_p1=r(mmu2_c4_p1) mmu2_c4_p0=r(mmu2_c4_p0) ///
		mmu2_c5_p1=r(mmu2_c5_p1) mmu2_c5_p0=r(mmu2_c5_p0) ///
		mmu2_c6_p1=r(mmu2_c6_p1) mmu2_c6_p0=r(mmu2_c6_p0) ///
		mmu2_c7_p1=r(mmu2_c7_p1) mmu2_c7_p0=r(mmu2_c7_p0), ///
		reps(1000) seed(123450) cluster(mturkid) idcluster(newid) nodrop: ///
		prog_pca_graph newid
	estat bootstrap, all

	preserve
	prog_mat
	gen prosocial = mod(n,2)

	* Format x axis
	gen graph_order=n
	foreach num of numlist 2(2)28 {
		replace graph_order=graph_order+1 if n>`num'
	}
	gen sample="PCA"

	* Temp file
	save "$bootstrapped_data/pca2.dta", replace
	restore
}

* Graph
use "$bootstrapped_data/pca1.dta", clear
append using "$bootstrapped_data/pca2.dta"

tw (rspike upper lower graph_order if prosocial==1 & sample=="CSA", lcolor(ebblue%40)) ///
	(sc coef graph_order if prosocial==1 & sample=="CSA", mcolor(ebblue%40)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="CSA", lcolor(orange%40)) ///
	(sc coef graph_order if prosocial==0 & sample=="CSA", mcolor(orange%40)) ///
	(rspike upper lower graph_order if prosocial==1 & sample=="PCA", lcolor(magenta%40)) ///
	(sc coef graph_order if prosocial==1 & sample=="PCA", mcolor(magenta%40) m(T)) ///
	(rspike  upper lower graph_order if prosocial==0 & sample=="PCA", lcolor(midgreen%40)) ///
	(sc coef graph_order if prosocial==0 & sample=="PCA", mcolor(midgreen%40) m(T)), ///
	$xaxis_p1 xtitle("") ytitle("$ytitle", size(small)) $yscale ///
	legend(order(2 "CSAs, More Equitable" 4 "CSAs, Less Equitable" ///
	6 "Two Factors, More Equitable" 8 "Two Factors, Less Equitable") size(vsmall))
graph export "$output_dir/pca_csas_dg_ev.pdf", replace





	
	
	
	
	
	
	
	
