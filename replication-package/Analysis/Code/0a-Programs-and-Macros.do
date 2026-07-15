
/* _____________________________________________________________________________

	MACROS AND PROGRAMS
	
	Objective: Save common macros and programs that will be used throughout 
	the analysis.
_____________________________________________________________________________ */


* ---------------------------------------------- *
* 			Stylize the graphs
* ---------------------------------------------- *

grstyle clear
grstyle init
grstyle color background white
grstyle color major_grid dimgray
grstyle linewidth major_grid thin
grstyle yesno draw_major_hgrid yes
grstyle yesno grid_draw_min yes
grstyle yesno grid_draw_max yes
grstyle set legend 4, nobox



* ---------------------------------------------- *
* 		Macros for common code chunks
* ---------------------------------------------- *

* Table properties
global tableprop	b(2) se(2) nonote booktabs label ///
					star(* 0.10 ** 0.05 *** 0.01) noobs nomtitle				
* Ensuring table fits in latex
global tablefit		prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
					`"\adjustbox{max height=\dimexpr\textheight-5.5cm\relax, max width=\textwidth}{"' ///
					`"\begin{tabular}{l*{8}{c}}"' `"\toprule"') ///
					postfoot(`"\bottomrule"' `"\end{tabular}"' `"}"')
* X axis graph labels					
global xaxis_p1		xlab(1.5 `""DG1" "(2,0.5), (4,0)""' ///
					4.5 `""DG2" "(2,1), (4,0)""' ///
					7.5 `""DG3" "(2,1.5), (4,0)""' ///
					10.5 `""DG4" "(2,2), (4,0)""' ///
					13.5 `""DG5" "(2,2), (3.5,0)""' ///
					16.5 `""DG6" "(2,2), (3,0)""' ///
					19.5 `""DG7" "(2,2), (2.5,0)""', labsize(vsmall))
global xaxis_p2		xlab(1.5 `""CC1" "(2,0.5), (4,0)""' ///
					4.5 `""CC2" "(2,1), (4,0)""' ///
					7.5 `""CC3" "(2,1.5), (4,0)""' ///
					10.5 `""CC4" "(2,2), (4,0)""' ///
					13.5 `""CC5" "(2,2), (3.5,0)""' ///
					16.5 `""CC6" "(2,2), (3,0)""' ///
					19.5 `""CC7" "(2,2), (2.5,0)""', labsize(vsmall))
global xaxis_p3		xlab(2 `""OO1" "(Opt-Out $5)""' 6 `""OO2" "(Opt-Out $4)""' ///
					10 `""OO3" "(Opt-Out $3.50)""' 14 `""OO4" "(Opt-Out $3)""', ///
					labsize(vsmall))
* Graph legends
global legend_p1	legend(order(1 "More Equitable" 2 "Less Equitable") size(vsmall)) 
global legend_p2	legend(order(1 `""More Equitable""' 2 `""Less Equitable""') size(vsmall)) 
global legend_p1_2	legend(order(3 "More Equitable" 4 "Less Equitable") size(vsmall)) 
global legend_p2_2	legend(order(3 `""More Equitable""' 4 `""Less Equitable""') size(vsmall)) 
global legend_p3	legend(order(1 "More Equitable" "in DG Subgame" ///
					2 "Less Equitable" "in DG Subgame" 3 "Opt-Out") size(vsmall)) 
global legend_p3_2	legend(order(4 "More Equitable" "in DG Subgame" ///
					5 "Less Equitable" "in DG Subgame" 6 "Opt-Out") size(vsmall)) 

					
					
* ---------------------------------------------- *
* 				Common programs
* ---------------------------------------------- *	
		
* Create a program to write commands to latex files in the Output folder
cap program drop latex_write
program define latex_write
	* Arguments: (1) name of the command, (2) content of the command, (3) name
	* of the file to which the command will be written
	if "`c(os)'" == "MacOSX" local command  '\\newcommand{\\\`1'}{`2'}'
	else local command \newcommand{\\`1'}{`2'}
	! echo `command'  >> "$output_dir/`3'.tex"
end

* Make a program to save observation numbers, unique individ, and r2 from regs 
cap program drop table_details
program define table_details
	estadd local obs = e(N), replace
	estadd local group = e(N)/7, replace
	estadd scalar r2 = e(r2_a), replace
end

* Same as above but for logits
cap program drop logit_table_details
program define logit_table_details
	estadd local obs = e(N), replace
	estadd local group = e(N_clust), replace
	estadd scalar r2 = e(r2_p), replace
end

* Take the bootstrap estimates and CI into a new dataframe
cap program drop prog_mat
program define prog_mat
	* Get the matrices of coef and CI
	mat B = e(b)
	mat CI = e(ci_percentile)
	
	* Convert it to dta
	** Coef
	clear
	svmat double B
	xpose, clear
	rename v1 coef
	gen n=_n
	tempfile coef
	save `coef'
	** CI
	clear
	svmat double CI
	xpose, clear
	gen n=_n
	merge 1:1 n using `coef', nogen
	
	* Rename
	rename v1 lower
	rename v2 upper
end 





