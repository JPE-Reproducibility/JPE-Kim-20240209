/* _____________________________________________________________________________

	MASTER DO-FILE
	
	Objective: Centralize code to run all analysis
_____________________________________________________________________________ */



* ---------------------------------------------- *
* 			Set directories
* ---------------------------------------------- *
*cd ".../NCP-Replication-Packet/Analysis" // enter the folder directory in the "..."
cd "..."
global raw_data_dir 		"Raw_Data"
global prepped_data_dir 	"Prepped_Data"
global bootstrapped_data	"Bootstrapped_Data"
global assignment_dir 		"Assignment_Payments"
global output_dir			"Output"
global code_dir				"Code"
global build_dir			"Build"



* ---------------------------------------------- *
* 			Clean data
* ---------------------------------------------- *

do "$build_dir/Clean-MTurk.do"


* ---------------------------------------------- *
* 			Run main analysis
* ---------------------------------------------- *

* Run common programs and macros
do "$code_dir/0a-Programs-and-Macros.do"

* Summary statistics
do "$code_dir/1-Summary-Statistics.do"

* Basic analysis
do "$code_dir/2-Analysis.do"

* Robustness analysis
do "$code_dir/3-Robustness.do"

* Welfare analysis
do "$code_dir/4-All-Welfare-Analysis-Bootstrap-CombinedHS.do"

* Compare DG and OO utilities
do "$code_dir/5-Compare-DG-utilities.do"

* Stability of DG weights
do "$code_dir/6-Stability-DG-Weights.do"
do "$code_dir/7-Stability-DG-Weights-2.do"



* ---------------------------------------------- *
* 	Run analysis for supplementary surveys
* ---------------------------------------------- *

do "$code_dir/Supplementary Survey 1 Analysis.do"

do "$code_dir/Supplementary Survey 2 Analysis.do"

do "$code_dir/Supplementary Survey 3 Analysis.do"



* ---------------------------------------------- *
* 			Run appendix analysis
* ---------------------------------------------- *

* PCA Analysis
do "$code_dir/X_PCA.do"

* Over ID test for happiness and satisfaction
do "$code_dir/X_IV-test-for-happiness-satisfaction.do"

* Graph difference between DG and OO weights in EV
do "$code_dir/X_DG-vs-OO-Weights.do"

* Graph difference between DG and OO weights in EV
do "$code_dir/X_Test-OVB.do"

* Analysis on order effects
do "$code_dir/X_Order-effects.do"
























