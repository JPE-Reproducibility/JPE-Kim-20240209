

keep id p1_self_avoid1* p1_self_avoid2*

* 2. Then flag people with title case
** Loop through all free-response
gen case_flag=0
foreach var in p1_self_avoid1_1_1 p1_self_avoid1_2_1 p1_self_avoid1_3_1 ///
	p1_self_avoid1_4_1 p1_self_avoid1_5_1 p1_self_avoid2_1_1 p1_self_avoid2_2_1 ///
	p1_self_avoid2_3_1 p1_self_avoid2_4_1 p1_self_avoid2_5_1 {
	** Get string length to loop over every character to check if it's capitalized
	gen slength = strlen(`var')
	quiet sum slength
	local maxlen = r(max)
	gen count_upper = 0
	gen str next = ""
	forval i = 1/`maxlen' {
	  replace next = substr(`var', `i', 1) if (`i' <= slength)
	  replace count_upper = count_upper+1 if (`i' <= slength) & inrange(next, "A", "Z")
	}
	** Count the number of periods
	gen count_period = slength - strlen(subinstr(`var', ".", "", .))
	replace count_period=1 if count_period==0 // If the sentence does not end in period
	** If the number of periods exceeds the number of capital letters, flag
	replace case_flag=1 if count_upper>count_period

	drop slength-count_period
}

* 3. Flag anyone without any first person pronouns
gen personal=0
foreach var in p1_self_avoid1_1_1 p1_self_avoid1_2_1 p1_self_avoid1_3_1 ///
	p1_self_avoid1_4_1 p1_self_avoid1_5_1 p1_self_avoid2_1_1 p1_self_avoid2_2_1 ///
	p1_self_avoid2_3_1 p1_self_avoid2_4_1 p1_self_avoid2_5_1 {
	foreach pron in i I me my My mine we We us our Our ours {
		replace personal=1 if strpos(`var', " `pron' ")
		replace personal=1 if strpos(`var', " `pron'.")
	}
}
gen pron_flag=personal==0
drop personal

* 4. Flag anyone who lists 
gen list_flag=0
foreach var in p1_self_avoid1_1_1 p1_self_avoid1_2_1 p1_self_avoid1_3_1 ///
	p1_self_avoid1_4_1 p1_self_avoid1_5_1 p1_self_avoid2_1_1 p1_self_avoid2_2_1 ///
	p1_self_avoid2_3_1 p1_self_avoid2_4_1 p1_self_avoid2_5_1 {
	replace list_flag=1 if strpos(`var', "1.")
	replace list_flag=1 if strpos(`var', "1)")
}

* 5. Need at least 350 characters for accuracy
gen character_flag=strlen(p1_self_avoid1_1_1)+strlen(p1_self_avoid1_2_1)+ ///
	strlen(p1_self_avoid1_3_1)+strlen(p1_self_avoid1_4_1)+strlen(p1_self_avoid1_5_1)+ ///
	strlen(p1_self_avoid2_1_1)+strlen(p1_self_avoid2_2_1)+strlen(p1_self_avoid2_3_1)+ ///
	strlen(p1_self_avoid2_4_1)+strlen(p1_self_avoid2_5_1)>=350

gen ai_flag=(case_flag+pron_flag+list_flag>=2 & character_flag==1)


