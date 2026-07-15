## Appendix: Detailed PII Detection Results

*Generated on 2026-07-15 12:24:06*

This appendix lists all detected instances of potential personally identifiable information (PII) in the project files. Each entry shows the matched PII terms and, for data files, sample values to help verify whether the flagged content is indeed sensitive.

### Data Files

**/replication-package/Analysis/Raw_Data/JPE Revision Survey 1 Final.xlsx**

- Variable: `durationinseconds`
  - Matched terms: second
  - Sample values: Duration (in seconds), 28, 85
- Variable: `gender`
  - Matched terms: gender
  - Sample values: What is your gender?, Female, Male

**/replication-package/Analysis/Raw_Data/JPE Revision Survey 2 Final.xlsx**

- Variable: `durationinseconds`
  - Matched terms: second
  - Sample values: Duration (in seconds), 48, 9
- Variable: `gender`
  - Matched terms: gender
  - Sample values: What is your gender?, Female, Male
- Variable: `p1_career_reason`
  - Matched terms: son
  - Sample values: Please list the main reasons why you may not spend more time on career planning., I am still in school and trying to focus on graduation before my career, Lack of spare time
- Variable: `p1_finan_reason`
  - Matched terms: son
  - Sample values: Please list the main reasons why you may not spend more time on financial planning., I do not make enough money to plan., Financial planning is not me for me, but for my kids. It's for the future, which shortens for me every day.
- Variable: `p1_health_reason`
  - Matched terms: son
  - Sample values: Please list the main reasons why you may not spend more time making plans to invest in your health., I don’t have the time. My insurance is not good so it’s hard to find providers with coverage. I am scared to know the status of my health., Humans only live so long and after a certain point, natural health declines. Investing into my health is more like sustaining my health. If something goes bad, it's likely not getting better. Correction becomes mitigation; if you start going blind, you can only prolong the inevitable.

**/replication-package/Analysis/Raw_Data/JPE Revision Survey 3 Final.xlsx**

- Variable: `durationinseconds`
  - Matched terms: second
  - Sample values: Duration (in seconds), 13, 22
- Variable: `gender`
  - Matched terms: gender
  - Sample values: What is your gender?, 1, 2

**/replication-package/Analysis/Raw_Data/cs.csv**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1, 2, 4
- Variable: `optout_allocation`
  - Matched terms: loc, location
  - Sample values: 3, 5, 4
- Variable: `prosocial_p2`
  - Matched terms: social
  - Sample values: 0, 1

**/replication-package/Analysis/Raw_Data/cs.dta**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1.0, 2.0, 4.0
- Variable: `optout_allocation`
  - Matched terms: loc, location
  - Sample values: 3.0, 5.0, 4.0
- Variable: `prosocial_p2`
  - Matched terms: social
  - Sample values: 0.0, 1.0

**/replication-package/Analysis/Raw_Data/exante.csv**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1, 2
- Variable: `optout_allocation`
  - Matched terms: loc, location
  - Sample values: 3, 4, 5

**/replication-package/Analysis/Raw_Data/exante.dta**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1.0, 2.0
- Variable: `optout_allocation`
  - Matched terms: loc, location
  - Sample values: 3.0, 4.0, 5.0

**/replication-package/Analysis/Raw_Data/main.csv**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1, 2, 4
- Variable: `optout_allocation`
  - Matched terms: loc, location
  - Sample values: 4, 5, 3

**/replication-package/Analysis/Raw_Data/main.dta**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1.0, 2.0, 4.0
- Variable: `optout_allocation`
  - Matched terms: loc, location
  - Sample values: 4.0, 5.0, 3.0

**/replication-package/Analysis/Raw_Data/pf.csv**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1, 2
- Variable: `optout_allocation`
  - Matched terms: loc, location

**/replication-package/Analysis/Raw_Data/pf.dta**

- Variable: `gender`
  - Matched terms: gender
  - Sample values: 1.0, 2.0
- Variable: `optout_allocation`
  - Matched terms: loc, location

### Code Files

**/replication-package/Analysis/Build/Clean-MTurk.do**

- Line 5: son
  ```
  Objective: We want to clean the MTurk data so it is in the person-question
  ```
- Line 6: lon, son
  ```
  (long) level and the person-choice set level (wide).
  ```
- Line 16: house
  ```
  * Household income
  ```
- Line 27: school
  ```
  label define educ 1 "High school graduate" ///
  ```
- Line 29: school
  ```
  3 "Vocational / trade / technical school" ///
  ```
- Line 30: degree
  ```
  4 "Bachelor's degree" ///
  ```
- Line 31: degree
  ```
  5 "Advanced degree" ///
  ```
- Line 33: school
  ```
  7 "Less than high school"
  ```
- Line 36: gender
  ```
  * Gender
  ```
- Line 37: gender
  ```
  label define gender 1 "Female" 2 "Male" ///
  ```
- Line 39: gender
  ```
  label val gender gender
  ```
- Line 91: social
  ```
  drop prosocial_p2
  ```
- Line 102: son
  ```
  * Tag one obs per mturkid to get person-level indicator
  ```
- Line 129: lon
  ```
  * Long
  ```
- Line 130: lon
  ```
  capture confirm file "$prepped_data_dir/mturk_all_long_analysis.dta"
  ```
- Line 134: lon
  ```
  use "$prepped_data_dir/mturk_main_long.dta", clear
  ```
- Line 142: social
  ```
  drop temp prosocial_p2
  ```
- Line 152: social
  ```
  reshape wide rating, i(mturkid prosocial choice_set part present) j(emotion) string
  ```
- Line 154: social
  ```
  ratingsatis ratinghappy, i(mturkid prosocial choice_set present) j(part)
  ```
- Line 160: social
  ```
  gen temp=rating`emotion'2 if choice_set==4 & prosocial==0
  ```
- Line 162: social
  ```
  replace rating`emotion'2=temp2 if choice_set<4 & prosocial==0 & rating`emotion'2==. & treatment!="cs
  ```
- Line 166: social
  ```
  gen temp=rating`emotion'2 if choice_set==4 & prosocial==1
  ```
- Line 168: social
  ```
  replace rating`emotion'2=temp2 if choice_set>4 & prosocial==1 & rating`emotion'2==. & treatment!="cs
  ```
- Line 173: lon
  ```
  save "$prepped_data_dir/mturk_all_long_analysis.dta", replace
  ```

**/replication-package/Analysis/Build/Clean-cs.do**

- Line 7: name
  ```
  but the only difference is the name of the file that is saved
  ```
- Line 33: loc, location
  ```
  * Loop through opt-out allocations
  ```
- Line 49: loc, location
  ```
  * Loop through opt out allocations
  ```
- Line 59: son
  ```
  * 	Reshape to person-choice set level
  ```
- Line 62: lon
  ```
  * Make long ____________________________________________________________________
  ```
- Line 63: son
  ```
  * We want the data to be person-choice set level
  ```
- Line 65: lon
  ```
  reshape long ///
  ```
- Line 88: son
  ```
  * Now we want to assign the right CSAs (CSA orders were randomized by person)
  ```
- Line 101: lon
  ```
  reshape long part1_q1 part1_q2 part1_q3 part1_q4 part1_q5 part1_q6 part1_q7 ///
  ```
- Line 109: social
  ```
  * Get a prosocial variable (1 if equitable or 0 is less equitable)
  ```
- Line 110: social
  ```
  gen prosocial=.
  ```
- Line 111: social
  ```
  replace prosocial=1 if type=="_p1_"
  ```
- Line 112: social
  ```
  replace prosocial=0 if type=="_p0_"
  ```
- Line 113: social
  ```
  replace prosocial=2 if type=="_p2_"
  ```
- Line 116: lon
  ```
  * Reshape long (again again) to get CSAs with each choice set
  ```
- Line 117: lon
  ```
  reshape long part1_a part3_a3_o part3_a4_o part3_a5_o ///
  ```
- Line 119: social
  ```
  i(mturkid emotion prosocial) j(choice_set)
  ```
- Line 121: name
  ```
  * Rename variables to be more descriptive
  ```
- Line 122: name
  ```
  rename part1_q rating1
  ```
- Line 123: name
  ```
  rename part2_q rating2
  ```
- Line 140: lon, social
  ```
  reshape long rating, i(mturkid emotion prosocial choice_set) j(part)
  ```
- Line 143: lon
  ```
  save "$prepped_data_dir/mturk_cs_long.dta", replace
  ```
- Line 147: son
  ```
  * Create person-choice set level data
  ```
- Line 148: social
  ```
  reshape wide rating, i(mturk part choice_set prosocial) j(emotion) string
  ```
- Line 149: social
  ```
  reshape wide rating*, i(mturk part choice_set) j(prosocial)
  ```
- Line 151: name
  ```
  * Rename CSA ratings to be shorter and more descriptive
  ```
- Line 153: name
  ```
  rename rating`emotion'1 `emotion'_p1
  ```
- Line 154: name
  ```
  rename rating`emotion'0 `emotion'_p0
  ```
- Line 155: name
  ```
  rename rating`emotion'2 `emotion'_p2
  ```

**/replication-package/Analysis/Build/Clean-exante.do**

- Line 28: son
  ```
  * 	Reshape to person-choice set level
  ```
- Line 31: lon
  ```
  * Make long ____________________________________________________________________
  ```
- Line 32: son
  ```
  * We want the data to be person-choice set level
  ```
- Line 34: lon
  ```
  reshape long ///
  ```
- Line 57: son
  ```
  * Now we want to assign the right CSAs (CSA orders were randomized by person)
  ```
- Line 70: lon
  ```
  reshape long part1_q1 part1_q2 part1_q3 part1_q4 part1_q5 part1_q6 part1_q7 ///
  ```
- Line 78: social
  ```
  * Get a prosocial variable (1 if equitable or 0 is less equitable)
  ```
- Line 79: social
  ```
  gen prosocial=.
  ```
- Line 80: social
  ```
  replace prosocial=1 if type=="_p1_"
  ```
- Line 81: social
  ```
  replace prosocial=0 if type=="_p0_"
  ```
- Line 82: social
  ```
  replace prosocial=2 if type=="_p2_"
  ```
- Line 85: lon
  ```
  * Reshape long (again again) to get CSAs with each choice set
  ```
- Line 86: lon
  ```
  reshape long part1_a part3_a3_o part3_a4_o part3_a5_o ///
  ```
- Line 88: social
  ```
  i(mturkid emotion prosocial) j(choice_set)
  ```
- Line 90: name
  ```
  * Rename variables to be more descriptive
  ```
- Line 91: name
  ```
  rename part1_q rating1
  ```
- Line 92: name
  ```
  rename part2_q rating2
  ```
- Line 109: lon, social
  ```
  reshape long rating, i(mturkid emotion prosocial choice_set) j(part)
  ```
- Line 112: lon
  ```
  save "$prepped_data_dir/mturk_exante_long.dta", replace
  ```
- Line 116: son
  ```
  * Create person-choice set level data
  ```
- Line 117: social
  ```
  reshape wide rating, i(mturk part choice_set prosocial) j(emotion) string
  ```
- Line 118: social
  ```
  reshape wide rating*, i(mturk part choice_set) j(prosocial)
  ```
- Line 120: name
  ```
  * Rename CSA ratings to be shorter and more descriptive
  ```
- Line 122: name
  ```
  rename rating`emotion'1 `emotion'_p1
  ```
- Line 123: name
  ```
  rename rating`emotion'0 `emotion'_p0
  ```
- Line 124: name
  ```
  rename rating`emotion'2 `emotion'_p2
  ```

**/replication-package/Analysis/Build/Clean-main.do**

- Line 32: loc, location
  ```
  * Loop through opt-out allocations
  ```
- Line 48: loc, location
  ```
  * Loop through opt out allocations
  ```
- Line 58: son
  ```
  * 	Reshape to person-choice set level
  ```
- Line 61: lon
  ```
  * Make long ____________________________________________________________________
  ```
- Line 62: son
  ```
  * We want the data to be person-choice set level
  ```
- Line 64: lon
  ```
  reshape long ///
  ```
- Line 87: son
  ```
  * Now we want to assign the right CSAs (CSA orders were randomized by person)
  ```
- Line 100: lon
  ```
  reshape long part1_q1 part1_q2 part1_q3 part1_q4 part1_q5 part1_q6 part1_q7 ///
  ```
- Line 108: social
  ```
  * Get a prosocial variable (1 if equitable or 0 is less equitable)
  ```
- Line 109: social
  ```
  gen prosocial=.
  ```
- Line 110: social
  ```
  replace prosocial=1 if type=="_p1_"
  ```
- Line 111: social
  ```
  replace prosocial=0 if type=="_p0_"
  ```
- Line 112: social
  ```
  replace prosocial=2 if type=="_p2_"
  ```
- Line 115: lon
  ```
  * Reshape long (again again) to get CSAs with each choice set
  ```
- Line 116: lon
  ```
  reshape long part1_a part3_a3_o part3_a4_o part3_a5_o ///
  ```
- Line 118: social
  ```
  i(mturkid emotion prosocial) j(choice_set)
  ```
- Line 120: name
  ```
  * Rename variables to be more descriptive
  ```
- Line 121: name
  ```
  rename part1_q rating1
  ```
- Line 122: name
  ```
  rename part2_q rating2
  ```
- Line 139: lon, social
  ```
  reshape long rating, i(mturkid emotion prosocial choice_set) j(part)
  ```
- Line 142: lon
  ```
  save "$prepped_data_dir/mturk_main_long.dta", replace
  ```
- Line 146: son
  ```
  * Create person-choice set level data
  ```
- Line 147: social
  ```
  reshape wide rating, i(mturk part choice_set prosocial) j(emotion) string
  ```
- Line 148: social
  ```
  reshape wide rating*, i(mturk part choice_set) j(prosocial)
  ```
- Line 150: name
  ```
  * Rename CSA ratings to be shorter and more descriptive
  ```
- Line 152: name
  ```
  rename rating`emotion'1 `emotion'_p1
  ```
- Line 153: name
  ```
  rename rating`emotion'0 `emotion'_p0
  ```
- Line 154: name
  ```
  rename rating`emotion'2 `emotion'_p2
  ```

**/replication-package/Analysis/Build/Clean-pf.do**

- Line 36: son
  ```
  * 	Reshape to person-choice set level
  ```
- Line 39: lon
  ```
  * Make long ____________________________________________________________________
  ```
- Line 40: son
  ```
  * We want the data to be person-choice set level
  ```
- Line 42: lon
  ```
  reshape long ///
  ```
- Line 59: son
  ```
  * Now we want to assign the right CSAs (CSA orders were randomized by person)
  ```
- Line 72: lon
  ```
  reshape long ///
  ```
- Line 86: lon
  ```
  reshape long ///
  ```
- Line 91: social
  ```
  i(mturkid emotion present) j(prosocial)
  ```
- Line 93: lon
  ```
  * Reshape long (again again) to get CSAs with each choice set
  ```
- Line 94: lon
  ```
  reshape long part1_a part1_q part2_q, ///
  ```
- Line 95: social
  ```
  i(mturkid emotion prosocial present) j(choice_set) string
  ```
- Line 99: name
  ```
  * Rename variables to be more descriptive
  ```
- Line 100: name
  ```
  rename part1_q rating1
  ```
- Line 101: name
  ```
  rename part2_q rating2
  ```
- Line 102: social
  ```
  bys mturkid emotion prosocial present choice_set: egen part1_choice=min(part1_a)
  ```
- Line 107: lon, social
  ```
  reshape long rating, i(mturkid emotion prosocial choice_set present) j(part)
  ```
- Line 112: lon
  ```
  save "$prepped_data_dir/mturk_pf_long.dta", replace
  ```
- Line 116: son
  ```
  * Create person-choice set level data
  ```
- Line 117: social
  ```
  reshape wide rating, i(mturk part choice_set prosocial present) j(emotion) string
  ```
- Line 118: social
  ```
  reshape wide rating*, i(mturk part choice_set present) j(prosocial)
  ```
- Line 120: name
  ```
  * Rename CSA ratings to be shorter and more descriptive
  ```
- Line 122: name
  ```
  rename rating`emotion'1 `emotion'_p1
  ```
- Line 123: name
  ```
  rename rating`emotion'0 `emotion'_p0
  ```

**/replication-package/Analysis/Code/0a-Programs-and-Macros.do**

- Line 34: lat
  ```
  * Ensuring table fits in latex
  ```
- Line 73: lat
  ```
  * Create a program to write commands to latex files in the Output folder
  ```
- Line 74: lat
  ```
  cap program drop latex_write
  ```
- Line 75: lat
  ```
  program define latex_write
  ```
- Line 76: name
  ```
  * Arguments: (1) name of the command, (2) content of the command, (3) name
  ```
- Line 78: loc
  ```
  if "`c(os)'" == "MacOSX" local command  '\\newcommand{\\\`1'}{`2'}'
  ```
- Line 79: loc
  ```
  else local command \newcommand{\\`1'}{`2'}
  ```
- Line 86: loc
  ```
  estadd local obs = e(N), replace
  ```
- Line 87: loc
  ```
  estadd local group = e(N)/7, replace
  ```
- Line 94: loc
  ```
  estadd local obs = e(N), replace
  ```
- Line 95: loc
  ```
  estadd local group = e(N_clust), replace
  ```
- Line 111: name
  ```
  rename v1 coef
  ```
- Line 122: name
  ```
  * Rename
  ```
- Line 123: name
  ```
  rename v1 lower
  ```
- Line 124: name
  ```
  rename v2 upper
  ```

**/replication-package/Analysis/Code/1-Summary-Statistics.do**

- Line 16: lat
  ```
  *	Tabulate
  ```
- Line 21: lat
  ```
  * Get demographic counts into latex tables
  ```
- Line 30: gender
  ```
  gen female=gender==1
  ```
- Line 32: loc
  ```
  local female: di %9.0f r(mean)*100
  ```
- Line 33: lat
  ```
  latex_write demofem `female' numbers_pipe
  ```
- Line 37: loc
  ```
  local age: di %9.0f r(mean)*100
  ```
- Line 38: lat
  ```
  latex_write demoage `age' numbers_pipe
  ```
- Line 42: loc
  ```
  local educ: di %9.0f r(mean)*100
  ```
- Line 43: lat
  ```
  latex_write demoeduc `educ' numbers_pipe
  ```
- Line 47: loc
  ```
  local hhinc: di %9.0f r(mean)*100
  ```
- Line 48: lat
  ```
  latex_write demohhinc `hhinc' numbers_pipe
  ```
- Line 72: loc
  ```
  local count=0
  ```
- Line 77: loc
  ```
  local count = `count'+2
  ```
- Line 86: lat
  ```
  * Save some choices in latex file
  ```
- Line 88: loc
  ```
  local dg1: di %9.0f r(mean)
  ```
- Line 89: lat
  ```
  latex_write dgone `dg1' numbers_pipe
  ```
- Line 92: loc
  ```
  local dg7: di %9.0f r(mean)
  ```
- Line 93: lat
  ```
  latex_write dgseven `dg7' numbers_pipe
  ```
- Line 110: loc
  ```
  local count=0
  ```
- Line 116: loc
  ```
  local count = `count'+3
  ```
- Line 133: loc, location
  ```
  collapse (count) count, by(part3_choice choice_set optout_allocation)
  ```
- Line 134: loc, location
  ```
  bys choice_set optout_allocation: egen sum=total(count)
  ```
- Line 139: loc
  ```
  local count=0
  ```
- Line 145: loc
  ```
  local count = `count'+3
  ```
- Line 151: loc
  ```
  local a (2,1.5), (4,0)
  ```
- Line 154: loc
  ```
  local a (2,2), (4,0)
  ```
- Line 157: loc
  ```
  local a (2,2), (3.5,0)
  ```
- Line 176: loc, location
  ```
  * Find the DG choices made for the OO allocation
  ```
- Line 180: loc
  ```
  local count1=r(N)
  ```
- Line 182: loc
  ```
  local count0=r(N)
  ```
- Line 192: lon, social
  ```
  reshape long p3_p, i(choice_set p1_c4_choice) j(prosocial)
  ```
- Line 195: social
  ```
  replace prosocial=-1 if prosocial==1
  ```
- Line 196: social
  ```
  gsort -p1 choice_set prosocial
  ```
- Line 205: social
  ```
  tw (bar perc graph_order if prosocial==-1, fcolor(ebblue) lcolor(ebblue)) ///
  ```
- Line 206: social
  ```
  (bar perc graph_order if prosocial==0, fcolor(orange) lcolor(orange)) ///
  ```
- Line 207: social
  ```
  (bar perc graph_order if prosocial==2, fcolor(cranberry) lcolor(cranberry)), ///
  ```
- Line 224: social
  ```
  * Graph each emotion by choice set and prosocial/less prosocial in DG
  ```
- Line 232: loc, location
  ```
  * Must graph OO on the DG/CC axis, so change choice set to reflect the opt-in allocation
  ```
- Line 237: lon, social
  ```
  reshape long `emotion'_ , i(choice_set part treatment) j(prosocial) string
  ```
- Line 238: social
  ```
  replace prosocial="1" if prosocial=="p1"
  ```
- Line 239: social
  ```
  replace prosocial="0" if prosocial=="p0"
  ```
- Line 240: social
  ```
  destring prosocial, replace force
  ```
- Line 241: social
  ```
  drop if prosocial==.
  ```
- Line 245: social
  ```
  gsort part treatment choice_set -prosocial
  ```
- Line 252: social
  ```
  gsort choice_set -prosocial part -treatment
  ```
- Line 253: social
  ```
  replace graph_order=graph_order[_n-1]+1/5 if choice_set==choice_set[_n-1] & prosocial==prosocial[_n-
  ```
- Line 254: social
  ```
  replace graph_order=graph_order-.5 if prosocial==1
  ```
- Line 255: social
  ```
  replace graph_order=graph_order-.2 if prosocial==0
  ```
- Line 258: social
  ```
  twoway (sc `emotion' graph_order if prosocial==1 & part==1, mcolor(ebblue%60)) ///
  ```
- Line 259: social
  ```
  (sc `emotion' graph_order if prosocial==0 & part==1, mcolor(orange%60)) ///
  ```
- Line 260: social
  ```
  (sc `emotion' graph_order if prosocial==1 & part==2 & treatment=="main", mcolor(ebblue%60) m(T)) ///
  ```
- Line 261: social
  ```
  (sc `emotion' graph_order if prosocial==0 & part==2 & treatment=="main", mcolor(orange%60) m(T)) ///
  ```
- Line 262: social
  ```
  (sc `emotion' graph_order if prosocial==1 & part==2 & treatment=="cs", mcolor(ebblue%60) m(S)) ///
  ```
- Line 263: social
  ```
  (sc `emotion' graph_order if prosocial==0 & part==2 & treatment=="cs", mcolor(orange%60) m(S)) ///
  ```
- Line 264: social
  ```
  (sc `emotion' graph_order if prosocial==1 & part==3, mcolor(ebblue%60) m(D)) ///
  ```
- Line 265: social
  ```
  (sc `emotion' graph_order if prosocial==0 & part==3, mcolor(orange%60) m(D)), ///
  ```
- Line 295: lon
  ```
  * Reshape to reformat xaxis (if time permits, move this analysis on long data)
  ```
- Line 296: lon, social
  ```
  reshape long `emotion'_ u_ l_, i(choice_set) j(prosocial) string
  ```
- Line 297: social
  ```
  replace prosocial="1" if prosocial=="p1"
  ```
- Line 298: social
  ```
  replace prosocial="0" if prosocial=="p0"
  ```
- Line 299: social
  ```
  replace prosocial="2" if prosocial=="p2"
  ```
- Line 300: social
  ```
  destring prosocial, replace
  ```
- Line 304: loc
  ```
  local count=0
  ```
- Line 307: social
  ```
  replace graph_choice=choice_set+`count' if choice_set==`choice' & prosocial==1
  ```
- Line 308: social
  ```
  replace graph_choice=choice_set+`count'+1 if choice_set==`choice' & prosocial==0
  ```
- Line 309: social
  ```
  replace graph_choice=choice_set+`count'+2 if choice_set==`choice' & prosocial==2
  ```
- Line 310: loc
  ```
  local count = `count'+3
  ```
- Line 314: social
  ```
  twoway (rspike u_ l_ graph_choice if prosocial==1, lcolor(ebblue)) ///
  ```
- Line 315: social
  ```
  (rspike u_ l_ graph_choice if prosocial==0, lcolor(orange)) ///
  ```
- Line 316: social
  ```
  (rspike u_ l_ graph_choice if prosocial==2, lcolor(cranberry)) ///
  ```
- Line 317: social
  ```
  (sc `emotion' graph_choice if prosocial==1, mcolor(ebblue)) ///
  ```
- Line 318: social
  ```
  (sc `emotion' graph_choice if prosocial==0, mcolor(orange)) ///
  ```
- Line 319: social
  ```
  (sc `emotion' graph_choice if prosocial==2, mcolor(cranberry)), ///
  ```

**/replication-package/Analysis/Code/2-Analysis.do**

- Line 18: lat
  ```
  * Instrumented logit program, where the instrument is the lagged relative CSA
  ```
- Line 30: second
  ```
  * Second stage
  ```
- Line 60: second
  ```
  * Second stage
  ```
- Line 88: second
  ```
  * Second stage
  ```
- Line 246: lat
  ```
  * Relative emotions
  ```
- Line 255: loc
  ```
  local title Happiness
  ```
- Line 258: loc
  ```
  local title Satisfaction
  ```
- Line 296: loc
  ```
  local group = e(N)/7
  ```
- Line 316: lon
  ```
  * Reshape data longer
  ```
- Line 318: lon
  ```
  * Reshape long
  ```
- Line 319: lon
  ```
  reshape long $emotions, ///
  ```
- Line 320: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 321: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 322: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 323: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 324: social
  ```
  destring prosocial, force replace
  ```
- Line 330: social
  ```
  sort mturkid part prosocial choice_set
  ```
- Line 335: social
  ```
  sort mturkid part prosocial choice_set
  ```
- Line 379: loc
  ```
  local ivlow : di %4.2g _b[lag_rel_unfair]
  ```
- Line 380: lat
  ```
  latex_write ivlow `ivlow' numbers_pipe
  ```
- Line 383: loc
  ```
  local ivhigh : di %4.2g _b[lag_rel_happy]
  ```
- Line 384: lat
  ```
  latex_write ivhigh `ivhigh' numbers_pipe
  ```
- Line 391: loc
  ```
  local ivgroup=e(N_clust)
  ```
- Line 395: loc
  ```
  local group=e(N_clust)
  ```
- Line 453: loc
  ```
  local obs = e(N)
  ```
- Line 454: loc
  ```
  local group = e(N_clust)
  ```

**/replication-package/Analysis/Code/3-Robustness.do**

- Line 31: lat
  ```
  ** Relative emotions
  ```
- Line 109: lat
  ```
  ** Y = choose equitable option; X = relative emotions
  ```
- Line 126: lat
  ```
  * 	Correlation matrix for present and future CSAs _____________________________
  ```
- Line 133: lon, social
  ```
  reshape long guilt_p pride_p finan_p fair_p unfair_p happy_p satis_p, i(mturkid choice_set part pres
  ```
- Line 134: social
  ```
  reshape wide guilt_p pride_p finan_p fair_p unfair_p happy_p satis_p, i(mturkid choice_set part pros
  ```
- Line 136: lat
  ```
  * Get correlations
  ```
- Line 139: loc
  ```
  local corr_`e' = string(r(rho),"%9.2fc")
  ```
- Line 142: loc
  ```
  local obs= r(N)
  ```
- Line 159: lat
  ```
  label variable Corr "Present-Future Correlation"
  ```

**/replication-package/Analysis/Code/4-All-Welfare-Analysis-Bootstrap-CombinedHS.do**

- Line 15: loc
  ```
  local overline = uchar(773)
  ```
- Line 18: loc
  ```
  local legend1 	legend(order(2 "More Equitable" 4 "Less Equitable") size(vsmall))
  ```
- Line 19: loc
  ```
  local legend2 	legend(order(2 "All CSAs, More Equitable" 4 "All CSAs, Less Equitable" ///
  ```
- Line 22: loc
  ```
  local legend3 	legend(order(2 "More Equitable" 4 "Less Equitable") size(vsmall))
  ```
- Line 23: loc
  ```
  local legend4 	legend(order(2 "All CSAs, More Equitable" 4 "All CSAs, Less Equitable" ///
  ```
- Line 28: lon
  ```
  cap program drop prog_lu_mmu_long
  ```
- Line 29: lon
  ```
  program define prog_lu_mmu_long, rclass
  ```
- Line 30: lat
  ```
  * Get reg coefficients for relative weights of each CSA
  ```
- Line 36: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 44: lat
  ```
  * Get reg coefficients for relative weights of each CSA
  ```
- Line 67: lon
  ```
  prog_lu_mmu_long
  ```
- Line 71: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 74: social
  ```
  gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 83: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==1
  ```
- Line 88: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==2 & treatment=="main"
  ```
- Line 105: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==2 & treatment=="cs"
  ```
- Line 114: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==3 & optout==`o'
  ```
- Line 123: social
  ```
  sum mmu if prosocial==`p' & part==3
  ```
- Line 136: lon
  ```
  prog_lu_mmu_long
  ```
- Line 138: lat
  ```
  * Make relative to (0,0) for the relevant groups (those who chose a specific option)
  ```
- Line 144: lat
  ```
  * Make relative to the group's (0,0)
  ```
- Line 148: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & choice1_c`c'==`p' & treatment=="main"
  ```
- Line 157: social
  ```
  sum mmu1_c`c' if choice_set==`c' & prosocial==`p' & part==1 & choice1_c`c'==`p'
  ```
- Line 171: lon
  ```
  prog_lu_mmu_long
  ```
- Line 175: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 178: social
  ```
  gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 184: social
  ```
  sum mmu if part==1 & inrange(choice_set,3,5) & prosocial==1
  ```
- Line 185: loc
  ```
  local dg_mmu = r(mean)
  ```
- Line 186: social
  ```
  sum mmu if part==3 & prosocial==1
  ```
- Line 194: social
  ```
  drop if prosocial==1
  ```
- Line 197: social
  ```
  gen mmu_optout=mmu if optout_all==3 & choice_set==2 & prosocial==2
  ```
- Line 198: social
  ```
  replace mmu_optout=mmu if optout_all==4 & choice_set==2 & prosocial==2
  ```
- Line 199: social
  ```
  replace mmu_optout=mmu if optout_all==5 & choice_set==3 & prosocial==2
  ```
- Line 201: social
  ```
  gen mmu_optin=mmu if optout_all==3 & choice_set==2 & prosocial==0
  ```
- Line 202: social
  ```
  replace mmu_optin=mmu if optout_all==4 & choice_set==2 & prosocial==0
  ```
- Line 203: social
  ```
  replace mmu_optin=mmu if optout_all==5 & choice_set==3 & prosocial==0
  ```
- Line 210: social
  ```
  sum oo_diff if prosocial==2
  ```
- Line 224: lat
  ```
  * Make MMU relative to (0,0) based on what participants chose in the DG
  ```
- Line 235: social
  ```
  sum mmu2 if choice_set==4 & prosocial==0 & choice_c`c'==`p' & treatment=="main"
  ```
- Line 240: social
  ```
  replace mmu2_c`c'=4 if choice_c`c'==`p' & inrange(choice_set,1,4)  & prosocial==0 & treatment=="main
  ```
- Line 241: social
  ```
  replace mmu2_c`c'=3.5 if choice_c`c'==`p' & choice_set==5 & prosocial==0 & treatment=="main"
  ```
- Line 242: social
  ```
  replace mmu2_c`c'=3 if choice_c`c'==`p' & choice_set==6 & prosocial==0 & treatment=="main"
  ```
- Line 243: social
  ```
  replace mmu2_c`c'=2.5 if choice_c`c'==`p' & choice_set==7 & prosocial==0 & treatment=="main"
  ```
- Line 252: social
  ```
  sum mmu2_c`c' if choice_set==`c' & prosocial==0  & treatment=="main" & part1_choice==prosocial
  ```
- Line 253: loc
  ```
  local selfish = r(mean)
  ```
- Line 256: social
  ```
  sum mmu2_c`c' if choice_set==`c' & prosocial==0 & treatment=="cs" & part1_choice==prosocial
  ```
- Line 257: loc
  ```
  local selfish_cs = r(mean)
  ```
- Line 260: social
  ```
  sum mmu1_c`c' if choice_set==`c' & part1_choice==0 & prosocial==0
  ```
- Line 271: social
  ```
  sum mmu2_c`c' if choice_set==`c' & part1_choice==prosocial & treatment=="main" & prosocial==1
  ```
- Line 272: loc
  ```
  local mmu2 = r(mean)
  ```
- Line 274: social
  ```
  sum mmu2_c`c' if choice_set==`c' & part1_choice==prosocial & treatment=="cs" & prosocial==1
  ```
- Line 275: loc
  ```
  local mmu2_cs = r(mean)
  ```
- Line 278: social
  ```
  sum mmu1_c`c' if choice_set==`c' & part1_choice==1  & prosocial==1
  ```
- Line 292: social
  ```
  sum cc_choice if treatment=="main" & prosocial==0 & part1_choice==0
  ```
- Line 295: social
  ```
  sum cc_choice if treatment=="main" & prosocial==1 & part1_choice==1
  ```
- Line 298: social
  ```
  sum cc_choice if treatment=="cs" & prosocial==1 & part1_choice==1
  ```
- Line 301: social
  ```
  sum cc_choice if treatment=="cs" & prosocial==0 & part1_choice==0
  ```
- Line 313: lon
  ```
  prog_lu_mmu_long
  ```
- Line 316: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 319: social
  ```
  replace mmu=4 if part==2 & inrange(choice_set,1,4)  & prosocial==0 & treatment=="main"
  ```
- Line 320: social
  ```
  replace mmu=3.5 if part==2 & choice_set==5 & prosocial==0 & treatment=="main"
  ```
- Line 321: social
  ```
  replace mmu=3 if part==2 & choice_set==6 & prosocial==0 & treatment=="main"
  ```
- Line 322: social
  ```
  replace mmu=2.5 if part==2 & choice_set==7 & prosocial==0 & treatment=="main"
  ```
- Line 328: social
  ```
  sum mmu if prosocial==`p' & part==2 & treatment=="main" & choice_set>3
  ```
- Line 329: loc
  ```
  local mmu2 = r(mean)
  ```
- Line 333: social
  ```
  sum mmu if prosocial==`p' & part==2 & treatment=="main" & choice_set<5
  ```
- Line 334: loc
  ```
  local mmu2 = r(mean)
  ```
- Line 338: social
  ```
  sum mmu if prosocial==`p' & part==2 & treatment=="cs"
  ```
- Line 352: lon
  ```
  prog_lu_mmu_long
  ```
- Line 355: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 358: social
  ```
  replace mmu=4 if part==2 & inrange(choice_set,1,4)  & prosocial==0 & treatment=="main"
  ```
- Line 359: social
  ```
  replace mmu=3.5 if part==2 & choice_set==5 & prosocial==0 & treatment=="main"
  ```
- Line 360: social
  ```
  replace mmu=3 if part==2 & choice_set==6 & prosocial==0 & treatment=="main"
  ```
- Line 361: social
  ```
  replace mmu=2.5 if part==2 & choice_set==7 & prosocial==0 & treatment=="main"
  ```
- Line 367: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==1
  ```
- Line 368: loc
  ```
  local mmu1_p`p'_c`c' = r(mean)
  ```
- Line 371: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==2 & treatment=="main"
  ```
- Line 372: loc
  ```
  local mmu2_p`p'_c`c' = r(mean)
  ```
- Line 391: social
  ```
  sum mmu if  prosocial==`p' & part==1
  ```
- Line 392: loc
  ```
  local mmu1_p`p' = r(mean)
  ```
- Line 395: social
  ```
  sum mmu if prosocial==`p' & part==2 & treatment=="main"
  ```
- Line 396: loc
  ```
  local mmu2_p`p' = r(mean)
  ```
- Line 412: lat
  ```
  * Globals to simplify the LU calculations and CSA list
  ```
- Line 445: lat
  ```
  ** Relative emotions
  ```
- Line 451: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 452: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 453: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 454: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 455: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 456: social
  ```
  destring prosocial, force replace
  ```
- Line 459: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 460: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 461: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 462: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 487: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 524: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 554: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 585: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 608: lat
  ```
  * Save some choices in latex file
  ```
- Line 610: loc
  ```
  local dgcceq=round(b[1,1],0.01)
  ```
- Line 611: loc
  ```
  local dgcceq: di %9.2f `dgcceq'
  ```
- Line 612: lat
  ```
  latex_write dgcceq `dgcceq' numbers_pipe
  ```
- Line 613: loc
  ```
  local dgccleq=round(b[1,2],0.01)
  ```
- Line 614: loc
  ```
  local dgccleq: di %9.2f `dgccleq'
  ```
- Line 615: lat
  ```
  latex_write dgccleq `dgccleq' numbers_pipe
  ```
- Line 618: loc
  ```
  local dgcceql=round(c[1,1],0.01)
  ```
- Line 619: loc
  ```
  local dgcceql: di %9.2f `dgcceql'
  ```
- Line 620: lat
  ```
  latex_write dgcceql `dgcceql' numbers_pipe
  ```
- Line 622: loc
  ```
  local dgccleql=round(c[1,2],0.01)
  ```
- Line 623: loc
  ```
  local dgccleql: di %9.2f `dgccleql'
  ```
- Line 624: lat
  ```
  latex_write dgccleql `dgccleql' numbers_pipe
  ```
- Line 626: loc
  ```
  local dgcceqh=round(c[2,1],0.01)
  ```
- Line 627: loc
  ```
  local dgcceqh: di %9.2f `dgcceqh'
  ```
- Line 628: lat
  ```
  latex_write dgcceqh `dgcceqh' numbers_pipe
  ```
- Line 630: loc
  ```
  local dgccleqh=round(c[2,2],0.01)
  ```
- Line 631: loc
  ```
  local dgccleqh: di %9.2f `dgccleqh'
  ```
- Line 632: lat
  ```
  latex_write dgccleqh `dgccleqh' numbers_pipe
  ```
- Line 693: lat
  ```
  * Save some outcomes in latex file
  ```
- Line 695: loc
  ```
  local dgccdiff: di %9.2f b[1,1]
  ```
- Line 696: lat
  ```
  latex_write dgccdiff `dgccdiff' numbers_pipe
  ```
- Line 698: loc
  ```
  local dgccdiffl: di %9.2f c[1,1]
  ```
- Line 699: lat
  ```
  latex_write dgccdiffl `dgccdiffl' numbers_pipe
  ```
- Line 700: loc
  ```
  local dgccdiffh: di %9.2f c[2,1]
  ```
- Line 701: lat
  ```
  latex_write dgccdiffh `dgccdiffh' numbers_pipe
  ```
- Line 710: lat
  ```
  * Save some choices in latex file
  ```
- Line 712: loc
  ```
  local mediff: di %9.2f b[1,1]
  ```
- Line 713: lat
  ```
  latex_write mediff `mediff' numbers_pipe
  ```
- Line 714: loc
  ```
  local lediff: di %9.2f b[1,2]
  ```
- Line 715: lat
  ```
  latex_write lediff `lediff' numbers_pipe
  ```
- Line 718: loc
  ```
  local mediffl: di %9.2f c[1,1]
  ```
- Line 719: lat
  ```
  latex_write mediffl `mediffl' numbers_pipe
  ```
- Line 720: loc
  ```
  local lediffl: di %9.2f c[1,2]
  ```
- Line 721: lat
  ```
  latex_write lediffl `lediffl' numbers_pipe
  ```
- Line 722: loc
  ```
  local mediffh: di %9.2f c[2,1]
  ```
- Line 723: lat
  ```
  latex_write mediffh `mediffh' numbers_pipe
  ```
- Line 724: loc
  ```
  local lediffh: di %9.2f c[2,2]
  ```
- Line 725: lat
  ```
  latex_write lediffh `lediffh' numbers_pipe
  ```
- Line 734: social
  ```
  bys mturkid choice_set prosocial: egen part1_choice_all=min(part1_choice)
  ```
- Line 735: social
  ```
  keep rel* mturkid choice_set part1_choice_all prosocial part guilt pride finan fair unfair happy sat
  ```
- Line 736: social
  ```
  reshape wide rel* guilt pride finan fair unfair happy satis, i(mturkid choice_set part1_choice_all p
  ```
- Line 740: social
  ```
  gen payoff=4 if choice_set==4 & prosocial==0
  ```
- Line 741: social
  ```
  replace payoff=3.5 if choice_set==5 & prosocial==0
  ```
- Line 742: social
  ```
  replace payoff=3 if choice_set==6 & prosocial==0
  ```
- Line 743: social
  ```
  replace payoff=2.5 if choice_set==7 & prosocial==0
  ```
- Line 746: social
  ```
  sort mturkid choice_set prosocial
  ```
- Line 747: social
  ```
  egen part_cs=tag(mturkid choice_set prosocial)
  ```
- Line 766: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 779: lat, social
  ```
  * Save average values of the prosocial choices above and save in latex
  ```
- Line 789: lat
  ```
  * Save some choices in latex file
  ```
- Line 791: loc
  ```
  local dgcc: di %9.2f b[1,1]
  ```
- Line 792: lat
  ```
  latex_write dgcc `dgcc' numbers_pipe
  ```
- Line 793: loc
  ```
  local dgcs: di %9.2f b[1,2]
  ```
- Line 794: lat
  ```
  latex_write dgcs `dgcs' numbers_pipe
  ```
- Line 795: loc
  ```
  local dgccle: di %9.2f b[1,3]
  ```
- Line 796: lat
  ```
  latex_write dgccle `dgccle' numbers_pipe
  ```
- Line 797: loc
  ```
  local dgcsle: di %9.2f b[1,4]
  ```
- Line 798: lat
  ```
  latex_write dgcsle `dgcsle' numbers_pipe
  ```
- Line 801: loc
  ```
  local dgccl: di %9.2f c[1,1]
  ```
- Line 802: lat
  ```
  latex_write dgccl `dgccl' numbers_pipe
  ```
- Line 803: loc
  ```
  local dgcsl: di %9.2f c[1,2]
  ```
- Line 804: lat
  ```
  latex_write dgcsl `dgcsl' numbers_pipe
  ```
- Line 805: loc
  ```
  local dgcclel: di %9.2f c[1,3]
  ```
- Line 806: lat
  ```
  latex_write dgcclel `dgcclel' numbers_pipe
  ```
- Line 807: loc
  ```
  local dgcslel: di %9.2f c[1,4]
  ```
- Line 808: lat
  ```
  latex_write dgcslel `dgcslel' numbers_pipe
  ```
- Line 809: loc
  ```
  local dgcch: di %9.2f c[2,1]
  ```
- Line 810: lat
  ```
  latex_write dgcch `dgcch' numbers_pipe
  ```
- Line 811: loc
  ```
  local dgcsh: di %9.2f c[2,2]
  ```
- Line 812: lat
  ```
  latex_write dgcsh `dgcsh' numbers_pipe
  ```
- Line 813: loc
  ```
  local dgccleh: di %9.2f c[2,3]
  ```
- Line 814: lat
  ```
  latex_write dgccleh `dgccleh' numbers_pipe
  ```
- Line 815: loc
  ```
  local dgcsleh: di %9.2f c[2,4]
  ```
- Line 816: lat
  ```
  latex_write dgcsleh `dgcsleh' numbers_pipe
  ```
- Line 835: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 859: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 860: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 861: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 862: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
  ```
- Line 866: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 867: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 868: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 869: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)) ///
  ```
- Line 870: social
  ```
  (rspike upper lower graph_order if prosocial==1 & sample=="happy", lcolor(ebblue%40)) ///
  ```
- Line 871: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="happy", mcolor(ebblue%40) m(T)) ///
  ```
- Line 872: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="happy", lcolor(orange%40)) ///
  ```
- Line 873: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="happy", mcolor(orange%40) m(T)) ///
  ```
- Line 874: social
  ```
  (rspike upper lower graph_order if prosocial==1 & sample=="satis", lcolor(ebblue%40)) ///
  ```
- Line 875: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="satis", mcolor(ebblue%40) m(X)) ///
  ```
- Line 876: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="satis", lcolor(orange%40)) ///
  ```
- Line 877: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="satis", mcolor(orange%40) m(X)), ///
  ```
- Line 886: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 887: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 888: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 889: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
  ```
- Line 899: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 900: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 901: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 902: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
  ```
- Line 906: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 907: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 908: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 909: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)) ///
  ```
- Line 910: social
  ```
  (rspike upper lower graph_order if prosocial==1 & sample=="happy", lcolor(ebblue%40)) ///
  ```
- Line 911: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="happy", mcolor(ebblue%40) m(T)) ///
  ```
- Line 912: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="happy", lcolor(orange%40)) ///
  ```
- Line 913: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="happy", mcolor(orange%40) m(T)) ///
  ```
- Line 914: social
  ```
  (rspike upper lower graph_order if prosocial==1 & sample=="satis", lcolor(ebblue%40)) ///
  ```
- Line 915: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="satis", mcolor(ebblue%40) m(X)) ///
  ```
- Line 916: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="satis", lcolor(orange%40)) ///
  ```
- Line 917: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="satis", mcolor(orange%40) m(X)), ///
  ```
- Line 928: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 929: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 930: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 931: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
  ```
- Line 939: loc
  ```
  local a "(2,1.5), (4,0)"
  ```
- Line 942: loc
  ```
  local a "(2,2), (4,0)"
  ```
- Line 945: loc
  ```
  local a "(2,2), (3.5,0)"
  ```
- Line 1004: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 1005: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 1006: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 1007: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
  ```
- Line 1014: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="all", lcolor(ebblue)) ///
  ```
- Line 1015: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="all", mcolor(ebblue)) ///
  ```
- Line 1016: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="all", lcolor(orange)) ///
  ```
- Line 1017: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="all", mcolor(orange)), ///
  ```

**/replication-package/Analysis/Code/5-Compare-DG-utilities.do**

- Line 28: lat
  ```
  ** Relative emotions
  ```
- Line 34: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 35: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 36: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 37: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 38: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 39: social
  ```
  destring prosocial, force replace
  ```
- Line 42: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 43: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 44: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 45: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 52: lon
  ```
  cap program drop prog_lu_mmu_long
  ```
- Line 53: lon
  ```
  program define prog_lu_mmu_long
  ```
- Line 55: lat
  ```
  * Get reg coefficients for relative weights of each emotion
  ```
- Line 61: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 66: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 68: social
  ```
  gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 82: lon
  ```
  qui prog_lu_mmu_long
  ```
- Line 96: social
  ```
  logit optin payout if part==3 & prosocial==2 & optout_all==`c'
  ```
- Line 98: loc
  ```
  local logit = _b[_cons]/_b[payout]*-1
  ```
- Line 101: social
  ```
  sum mmu if part==1 & prosocial==part1_choice & choice_set==`c'
  ```
- Line 103: loc
  ```
  local ev_`c' = r(mean)
  ```
- Line 106: social
  ```
  sum mmu if part==3 & prosocial==part1_choice & optout_all==`c'
  ```
- Line 108: loc
  ```
  local ev3_`c' = r(mean)
  ```
- Line 130: loc
  ```
  local obs = e(N)
  ```
- Line 131: loc
  ```
  local group = e(N_clust)
  ```

**/replication-package/Analysis/Code/6-Stability-DG-Weights.do**

- Line 18: lon
  ```
  cap program drop prog_lu_mmu_long
  ```
- Line 19: lon
  ```
  program define prog_lu_mmu_long, rclass
  ```
- Line 20: lat
  ```
  * Get reg coefficients for relative weights of each CSA
  ```
- Line 26: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 46: lat
  ```
  ** Relative emotions
  ```
- Line 52: lon
  ```
  reshape long $emotions, ///
  ```
- Line 53: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 54: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 55: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 56: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 57: social
  ```
  destring prosocial, force replace
  ```
- Line 60: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 61: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 62: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 63: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 74: lon
  ```
  prog_lu_mmu_long
  ```
- Line 81: social
  ```
  replace pred=1-pred if (part==1 | part==2) & prosocial==0
  ```
- Line 86: social
  ```
  gen choice1=(part1_choice==prosocial)
  ```
- Line 87: social
  ```
  gen choice3=(part3_choice==prosocial)
  ```
- Line 89: social
  ```
  case(group) alt(prosocial) cluster(mturkid) nocons
  ```
- Line 102: social
  ```
  reg part1_choice pred if part==1 & prosocial==1
  ```
- Line 103: loc
  ```
  local eq = `"`: display %4.2f _b[pred]'"'
  ```
- Line 105: social
  ```
  binscatter part1_choice pred if part==1 & prosocial==1, ///
  ```
- Line 112: social
  ```
  reg part1_choice pred_oo if part==1 & prosocial==1
  ```
- Line 113: loc
  ```
  local eq = `" `: display %4.2f _b[pred_oo]'"' // the constant
  ```
- Line 114: social
  ```
  binscatter part1_choice pred_oo if part==1 & prosocial==1, ///
  ```
- Line 121: social
  ```
  reg pr_oo1 pred_oo if part==3 & prosocial==1
  ```
- Line 122: loc
  ```
  local eq = `"`: display %4.2f _b[pred_oo]'"' // the constant
  ```
- Line 123: social
  ```
  binscatter pr_oo1 pred_oo if part==3 & prosocial==1, ///
  ```
- Line 130: social
  ```
  reg pr_oo1 pred if part==3 & prosocial==1
  ```
- Line 131: loc
  ```
  local eq = `"`: display %4.2f _b[pred]'"' // the constant
  ```
- Line 132: social
  ```
  binscatter pr_oo1 pred if part==3 & prosocial==1, ///
  ```
- Line 139: social
  ```
  reg pr_oo2 pred_oo if part==3 & prosocial==2
  ```
- Line 140: loc
  ```
  local eq = `"`: display %4.2f _b[pred_oo]'"' // the constant
  ```
- Line 141: social
  ```
  binscatter pr_oo2 pred_oo if part==3 & prosocial==2, ///
  ```
- Line 148: social
  ```
  reg pr_oo2 pred if part==3 & prosocial==2
  ```
- Line 149: loc
  ```
  local eq = `"`: display %4.2f _b[pred]'"' // the constant
  ```
- Line 150: social
  ```
  binscatter pr_oo2 pred if part==3 & prosocial==2, ///
  ```

**/replication-package/Analysis/Code/7-Stability-DG-Weights-2.do**

- Line 29: social
  ```
  replace pred=1-pred if prosocial==0
  ```
- Line 32: social
  ```
  keep if prosocial==1 & !(part==3) & treatment=="main"
  ```
- Line 44: loc
  ```
  local p1=r(mean)
  ```
- Line 46: loc
  ```
  local p2=r(mean)
  ```
- Line 69: lat
  ```
  ** Relative emotions
  ```
- Line 75: lon
  ```
  reshape long $emotions, ///
  ```
- Line 76: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 77: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 78: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 79: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 80: social
  ```
  destring prosocial, force replace
  ```
- Line 83: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 84: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 85: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 86: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```

**/replication-package/Analysis/Code/AI-flag-Survey1.do**

- Line 14: loc
  ```
  local maxlen = r(max)
  ```
- Line 30: son
  ```
  * 3. Flag anyone without any first person pronouns
  ```
- Line 31: son
  ```
  gen personal=0
  ```
- Line 36: son
  ```
  replace personal=1 if strpos(`var', " `pron' ")
  ```
- Line 37: son
  ```
  replace personal=1 if strpos(`var', " `pron'.")
  ```
- Line 40: son
  ```
  gen pron_flag=personal==0
  ```
- Line 41: son
  ```
  drop personal
  ```

**/replication-package/Analysis/Code/AI-flag-Survey2.do**

- Line 3: son
  ```
  keep id *_reason
  ```
- Line 6: son
  ```
  drop if p1_health_reason=="" & p1_career_reason=="" & p1_finan_reason==""
  ```
- Line 11: son
  ```
  foreach var in p1_health_reason p1_career_reason p1_finan_reason {
  ```
- Line 15: loc
  ```
  local maxlen = r(max)
  ```
- Line 31: son
  ```
  * 3. Flag anyone without any first person pronouns
  ```
- Line 32: son
  ```
  gen personal=0
  ```
- Line 33: son
  ```
  foreach var in p1_health_reason p1_career_reason p1_finan_reason {
  ```
- Line 35: son
  ```
  replace personal=1 if strpos(`var', " `pron' ")
  ```
- Line 36: son
  ```
  replace personal=1 if strpos(`var', " `pron'.")
  ```
- Line 39: son
  ```
  gen pron_flag=personal==0
  ```
- Line 40: son
  ```
  drop personal
  ```
- Line 44: son
  ```
  foreach var in p1_health_reason p1_career_reason p1_finan_reason {
  ```
- Line 50: son
  ```
  gen character_flag=strlen(p1_health_reason)+strlen(p1_career_reason)+strlen(p1_finan_reason)>=350
  ```

**/replication-package/Analysis/Code/Heterogeneous-MU.do**

- Line 46: lat
  ```
  * Relative emotions
  ```
- Line 52: lon
  ```
  reshape long $emotions, ///
  ```
- Line 53: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 54: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 55: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 56: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 57: social
  ```
  destring prosocial, force replace
  ```
- Line 63: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 64: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 65: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 66: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 80: loc
  ```
  local mud=round(b[1,1],0.01)
  ```
- Line 81: loc
  ```
  local mud: di %9.2f `mud'
  ```
- Line 82: lat
  ```
  latex_write mud `mud' numbers_pipe
  ```
- Line 83: loc
  ```
  local mixedb=round(b[1,2],0.01)
  ```
- Line 84: loc
  ```
  local mixedb: di %9.2f `mixedb'
  ```
- Line 85: lat
  ```
  latex_write mixedb `mixedb' numbers_pipe
  ```
- Line 86: loc
  ```
  local mixed_var=round(b[1,3],0.01)
  ```
- Line 87: loc
  ```
  local mixed: di %9.2f `mixed_var'
  ```
- Line 88: lat
  ```
  latex_write mixed `mixed' numbers_pipe
  ```
- Line 91: loc
  ```
  local mudlo=round(c[1,1],0.01)
  ```
- Line 92: loc
  ```
  local mudlo: di %9.2f `mudlo'
  ```
- Line 93: lat
  ```
  latex_write mudlo `mudlo' numbers_pipe
  ```
- Line 95: loc
  ```
  local mudhi=round(c[2,1],0.01)
  ```
- Line 96: loc
  ```
  local mudhi: di %9.2f `mudhi'
  ```
- Line 97: lat
  ```
  latex_write mudhi `mudhi' numbers_pipe
  ```
- Line 99: loc
  ```
  local mixedblo=round(c[1,2],0.01)
  ```
- Line 100: loc
  ```
  local mixedblo: di %9.2f `mixedblo'
  ```
- Line 101: lat
  ```
  latex_write mixedblo `mixedblo' numbers_pipe
  ```
- Line 103: loc
  ```
  local mixedbhi=round(c[2,2],0.01)
  ```
- Line 104: loc
  ```
  local mixedbhi: di %9.2f `mixedbhi'
  ```
- Line 105: lat
  ```
  latex_write mixedbhi `mixedbhi' numbers_pipe
  ```
- Line 107: loc
  ```
  local mixedlo=round(c[1,3],0.01)
  ```
- Line 108: loc
  ```
  local mixedlo: di %9.2f `mixedlo'
  ```
- Line 109: lat
  ```
  latex_write mixedlo `mixedlo' numbers_pipe
  ```
- Line 111: loc
  ```
  local mixedhi=round(c[2,3],0.01)
  ```
- Line 112: loc
  ```
  local mixedhi: di %9.2f `mixedhi'
  ```
- Line 113: lat
  ```
  latex_write mixedhi `mixedhi' numbers_pipe
  ```

**/replication-package/Analysis/Code/Supplementary Survey 1 Analysis.do**

- Line 21: second
  ```
  keep durationinseconds p1_self_avoid1_1_1 - e11 id
  ```
- Line 23: second
  ```
  destring durationinseconds, replace
  ```
- Line 24: second
  ```
  replace durationinseconds = durationinseconds/60
  ```
- Line 25: name, second
  ```
  rename durationinseconds durationinmins
  ```
- Line 45: loc, son
  ```
  local soneparticipants = _N
  ```
- Line 47: lat, son
  ```
  latex_write soneparticipants `soneparticipants' survey_numbers
  ```
- Line 49: lon
  ```
  * Reshape long
  ```
- Line 50: lon
  ```
  reshape long category p1_self_avoid1_ p1_self_avoid2_, i(id) j(ob_num) string
  ```
- Line 72: son
  ```
  replace category = "5" if category == "Personal Development"
  ```
- Line 76: social
  ```
  replace category = "9" if category == "Social"
  ```
- Line 81: son
  ```
  la define categories 1 "Financial" 2 "Health" 3 "Education" 4 "Career" 5 `""Personal" "Development""
  ```
- Line 82: social
  ```
  6 "Family" 7 `""Daily" "Tasks""' 8 "Legal" 9 "Social" 10 "None of the above"
  ```
- Line 103: name
  ```
  rename *, lower
  ```
- Line 133: lat
  ```
  * Calculate average number of decisions listed
  ```
- Line 141: loc
  ```
  local avg_no_decisions = round(avg_no_decisions, 0.2)
  ```
- Line 143: lat
  ```
  * Write to Latex file
  ```
- Line 144: lat
  ```
  latex_write avgnodecisions `avg_no_decisions' survey_numbers
  ```
- Line 147: loc, son
  ```
  local soneduration : di %3.1f r(mean)
  ```
- Line 149: lat, son
  ```
  latex_write soneduration `soneduration' survey_numbers
  ```
- Line 162: loc
  ```
  local mean1: di %4.1g r(mean)
  ```
- Line 163: lat
  ```
  latex_write catrespfinan `mean1' survey_numbers
  ```
- Line 165: loc
  ```
  local mean6: di %4.1g r(mean)
  ```
- Line 166: lat
  ```
  latex_write catrespfam `mean6' survey_numbers
  ```
- Line 168: loc
  ```
  local mean9: di %4.1g r(mean)
  ```
- Line 169: lat
  ```
  latex_write catrespsoc `mean9' survey_numbers
  ```
- Line 171: loc
  ```
  local mean2: di %4.1g r(mean)
  ```
- Line 172: lat
  ```
  latex_write catresphealth `mean2' survey_numbers
  ```
- Line 174: loc
  ```
  local mean4: di %4.1g r(mean)
  ```
- Line 175: lat
  ```
  latex_write catrespcareer `mean4' survey_numbers
  ```
- Line 177: loc
  ```
  local mean5: di %4.1g r(mean)
  ```
- Line 178: lat
  ```
  latex_write catrespdev `mean5' survey_numbers
  ```
- Line 180: loc
  ```
  local mean7: di %4.1g r(mean)
  ```
- Line 181: lat
  ```
  latex_write catrespdaily `mean7' survey_numbers
  ```
- Line 183: loc
  ```
  local mean3: di %4.1g r(mean)
  ```
- Line 184: lat
  ```
  latex_write catrespeduc `mean3' survey_numbers
  ```
- Line 186: loc
  ```
  local mean8: di %4.1g r(mean)
  ```
- Line 187: lat
  ```
  latex_write catresplegal `mean8' survey_numbers
  ```
- Line 191: loc
  ```
  local noneoftheabove = r(mean)
  ```
- Line 193: lat
  ```
  * Write to Latex file
  ```
- Line 194: lat
  ```
  latex_write noneoftheabove `noneoftheabove' survey_numbers
  ```
- Line 198: lat
  ```
  * Save numbers Latex file
  ```
- Line 200: loc
  ```
  local N = r(N)
  ```
- Line 203: loc
  ```
  local pctchoiceself = (r(N)/`N')*100
  ```
- Line 204: loc
  ```
  local pctchoiceself : di %3.1f `pctchoiceself'
  ```
- Line 207: loc
  ```
  local pctchoicegovt = (r(N)/`N')*100
  ```
- Line 208: loc
  ```
  local pctchoicegovt : di %3.1f `pctchoicegovt'
  ```
- Line 210: lat
  ```
  latex_write pctchoiceself `pctchoiceself' survey_numbers
  ```
- Line 211: lat
  ```
  latex_write pctchoicegovt `pctchoicegovt' survey_numbers
  ```
- Line 231: loc
  ```
  local `emotion'_p_y = `"`: display %4.2f r(p)'"'
  ```
- Line 232: loc
  ```
  local `emotion'_diff_y = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
  ```
- Line 235: loc
  ```
  local `emotion'_x_yes = `emotion'_y_govt - 0.08
  ```
- Line 236: loc
  ```
  local `emotion'_x_yes_2 = ``emotion'_x_yes' - 0.04
  ```
- Line 240: loc
  ```
  local `emotion'_x_yes = `emotion'_y_self - 0.08
  ```
- Line 241: loc
  ```
  local `emotion'_x_yes_2 = ``emotion'_x_yes' - 0.04
  ```
- Line 245: loc
  ```
  local `emotion'_p_y =  `" `: display %4.2f 0.01'"'
  ```
- Line 249: loc
  ```
  local `emotion'_p_y =  `" `: display %4.2f 0.001'"'
  ```
- Line 253: loc
  ```
  local `emotion'_p_y_psym = "="
  ```
- Line 257: loc
  ```
  local `emotion'_p_y_psym = "<"
  ```
- Line 319: loc
  ```
  local choice`suff'yes: di %3.1f (r(N)/_N)*100
  ```
- Line 321: lat
  ```
  latex_write choice`suff'yes `choice`suff'yes' survey_numbers
  ```

**/replication-package/Analysis/Code/Supplementary Survey 2 Analysis.do**

- Line 20: second
  ```
  keep durationinseconds p1_health_choice - id
  ```
- Line 40: loc
  ```
  local stwoparticipants = _N
  ```
- Line 42: lat
  ```
  latex_write stwoparticipants `stwoparticipants' survey_numbers
  ```
- Line 44: second
  ```
  destring durationinseconds, replace
  ```
- Line 45: second
  ```
  replace durationinseconds = durationinseconds/60
  ```
- Line 46: name, second
  ```
  rename durationinseconds durationinmins
  ```
- Line 49: loc
  ```
  local stwoduration : di %3.1f r(mean)
  ```
- Line 51: lat
  ```
  latex_write stwoduration `stwoduration' survey_numbers
  ```
- Line 53: lon
  ```
  * Prep to reshape long
  ```
- Line 60: lon
  ```
  * Reshape long
  ```
- Line 61: lon
  ```
  reshape long p1_finan_category p1_career_category p1_health_category, i(id) j(ob_num) string
  ```
- Line 106: name
  ```
  rename q90_`i' p2_reminder_signup_health_`i'
  ```
- Line 107: name
  ```
  rename q92_`i' p2_reminder_govt_health_`i'
  ```
- Line 108: name
  ```
  rename q94_`i' p2_reminder_signup_career_`i'
  ```
- Line 109: name
  ```
  rename q96_`i' p2_reminder_govt_career_`i'
  ```
- Line 110: name
  ```
  rename p2_reminder_signup_`i' p2_reminder_signup_finan_`i'
  ```
- Line 111: name
  ```
  rename p2_reminder_govt_`i' p2_reminder_govt_finan_`i'
  ```
- Line 147: name
  ```
  rename *, lower
  ```
- Line 150: gender
  ```
  gen female = (gender == "Female")
  ```
- Line 151: degree
  ```
  gen bachelors = (substr(educ,1,4) =="Bach" | educ == "Advanced degree")
  ```
- Line 191: son
  ```
  la var p1_finan_category "Reasons for Not Spending Time Financial Planning"
  ```
- Line 192: son
  ```
  la var p1_career_category "Reasons for Not Spending Time Career Planning"
  ```
- Line 193: son
  ```
  la var p1_health_category "Reasons for Not Spending Time Investing in Health"
  ```
- Line 200: lat
  ```
  * Calculate number of respondents that selected only "other"
  ```
- Line 206: lat
  ```
  * Save numbers to latex file
  ```
- Line 218: loc
  ```
  local p_other_`cat' = (other_`cat'/N)*100
  ```
- Line 219: loc
  ```
  local p_other_`cat' : display %3.1f `p_other_`cat''
  ```
- Line 221: lat
  ```
  latex_write other`cat' `p_other_`cat'' survey_numbers
  ```
- Line 230: loc
  ```
  local `choicetype'yes : display %3.1f (r(N)/_N)*100
  ```
- Line 231: loc
  ```
  local `choicetype'yesnum = r(N)/7
  ```
- Line 233: lat
  ```
  * Write to Latex file
  ```
- Line 234: lat
  ```
  latex_write `choicetype'yes ``choicetype'yes' survey_numbers
  ```
- Line 235: lat
  ```
  latex_write `choicetype'yesnum ``choicetype'yesnum' survey_numbers
  ```
- Line 244: loc
  ```
  local `qtype'avgrespno : display %3.1f r(mean)
  ```
- Line 246: lat
  ```
  latex_write `qtype'avgrespno ``qtype'avgrespno' survey_numbers
  ```
- Line 289: loc
  ```
  local label "Financial"
  ```
- Line 293: loc
  ```
  local label "Career"
  ```
- Line 297: loc
  ```
  local label "Health"
  ```
- Line 322: loc
  ```
  local `qtype'cattwo = string(100*(r(mean)), "%4.1g")
  ```
- Line 326: loc
  ```
  local `qtype'catfour = string(100*(r(mean)), "%4.1g")
  ```
- Line 329: loc
  ```
  local `qtype'cattwo = string((r(mean)), "%4.1g")
  ```
- Line 332: loc
  ```
  local `qtype'catthree = string((r(mean)), "%4.1g")
  ```
- Line 335: loc
  ```
  local `qtype'catfive = string((r(mean)), "%4.1g")
  ```
- Line 338: lat
  ```
  * Write to Latex file
  ```
- Line 339: name
  ```
  foreach name in financattwo financatfour financatthree financatfive ///
  ```
- Line 342: lat, name
  ```
  latex_write `name' ``name'' survey_numbers
  ```
- Line 392: loc
  ```
  legend(order(2 "During Planning" 4 "When Thinking of Allocating Time") size(small)) ///
  ```
- Line 399: lat
  ```
  * Plot means of emotions related to reminder program
  ```
- Line 406: loc
  ```
  local `emotion'_`type'_p_g = `" `: display %4.2f r(p)'"'
  ```
- Line 407: loc
  ```
  local `emotion'_`type'_diff_g = `"`: display %4.2f (r(mu_1) -  r(mu_2))'"'
  ```
- Line 410: loc
  ```
  local `emotion'_`type'_x_g = `emotion'_remind_`type'_govt - 0.08
  ```
- Line 411: loc
  ```
  local `emotion'_`type'_x_g_2 = ``emotion'_`type'_x_g' - 0.04
  ```
- Line 415: loc
  ```
  local `emotion'_`type'_x_g = `emotion'_remind_`type'_yes - 0.08
  ```
- Line 416: loc
  ```
  local `emotion'_`type'_x_g_2 = ``emotion'_`type'_x_g' - 0.04
  ```
- Line 420: loc
  ```
  local `emotion'_`type'_p_g =  `" `: display %4.2f 0.01'"'
  ```
- Line 424: loc
  ```
  local `emotion'_`type'_p_g =  `" `: display %4.2f 0.001'"'
  ```
- Line 428: loc
  ```
  local `emotion'_`type'_g_psym = "="
  ```
- Line 432: loc
  ```
  local `emotion'_`type'_g_psym = "<"
  ```
- Line 441: loc
  ```
  local legend1 "Signed Up for Reminder Program"
  ```
- Line 443: loc
  ```
  local legend2 "Gov. Mandated Everyone Sign Up for Program"
  ```

**/replication-package/Analysis/Code/Supplementary Survey 3 Analysis.do**

- Line 23: lat
  ```
  ** Relative emotions
  ```
- Line 29: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 30: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 31: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 32: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 33: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 34: social
  ```
  destring prosocial, force replace
  ```
- Line 65: name
  ```
  rename fl_11_do order
  ```
- Line 69: loc
  ```
  local sthreeparticipants = _N
  ```
- Line 71: lat
  ```
  latex_write sthreeparticipants `sthreeparticipants' survey_numbers
  ```
- Line 73: second
  ```
  destring durationinseconds, replace
  ```
- Line 74: second
  ```
  replace durationinseconds = durationinseconds/60
  ```
- Line 75: name, second
  ```
  rename durationinseconds durationinmins
  ```
- Line 79: loc
  ```
  local sthreeduration : di %3.1f r(mean)
  ```
- Line 81: lat
  ```
  latex_write sthreeduration `sthreeduration' survey_numbers
  ```
- Line 102: lon
  ```
  * Reshape long
  ```
- Line 103: lon
  ```
  reshape long s1_csa1 s1_csa2 s1_csa3 s2_csa1 s2_csa2 s3_csa3, i(id) j(csa) string
  ```
- Line 105: name
  ```
  * Replace csa with csa name
  ```
- Line 117: lon
  ```
  * Reshape long again
  ```
- Line 118: lon
  ```
  reshape long s1_csa s2_csa s3_csa, i(id csa) j(option)
  ```
- Line 120: name
  ```
  rename s1_csa csa_rating1
  ```
- Line 121: name
  ```
  rename s2_csa csa_rating2
  ```
- Line 122: name
  ```
  rename s3_csa csa_rating3
  ```
- Line 123: lon
  ```
  reshape long csa_rating, i(id csa option) j(scenario)
  ```
- Line 131: name
  ```
  rename csa_rating csa_
  ```
- Line 136: lat
  ```
  * Get relative csas
  ```
- Line 140: lon
  ```
  * Reshape long
  ```
- Line 141: lon
  ```
  reshape long csa_guilt csa_pride csa_finan csa_fair csa_unfair csa_happy csa_satis, ///
  ```
- Line 160: loc
  ```
  local supplrespondentsthreegive = r(N)
  ```
- Line 163: loc
  ```
  local supplrespondentsthreenotgive = r(N)
  ```
- Line 165: lat
  ```
  latex_write supplrespondentsthreegive `supplrespondentsthreegive' survey_numbers
  ```
- Line 166: lat
  ```
  latex_write supplrespondentsthreenotgive `supplrespondentsthreenotgive' survey_numbers
  ```
- Line 291: loc
  ```
  local title "Guilt"
  ```
- Line 294: loc
  ```
  local title "Pride"
  ```
- Line 297: loc
  ```
  local title "Fairness"
  ```
- Line 300: loc
  ```
  local title "Unfairness"
  ```
- Line 303: loc
  ```
  local title "Financial Satisfaction"
  ```
- Line 306: loc
  ```
  local title "Satisfaction"
  ```
- Line 309: loc
  ```
  local title "Happiness"
  ```
- Line 406: loc
  ```
  local `e'_psym_1 = "="
  ```
- Line 410: loc
  ```
  local `e'_psym_2 = "="
  ```
- Line 414: loc
  ```
  local `e'_psym_3 = "="
  ```
- Line 418: loc
  ```
  local `e'_psym_4 = "="
  ```
- Line 422: loc
  ```
  local `e'_psym_5 = "="
  ```
- Line 426: loc
  ```
  local `e'_psym_1 = "<"
  ```
- Line 430: loc
  ```
  local `e'_psym_2 = "<"
  ```
- Line 434: loc
  ```
  local `e'_psym_3 = "<"
  ```
- Line 438: loc
  ```
  local `e'_psym_4 = "<"
  ```
- Line 442: loc
  ```
  local `e'_psym_5 = "<"
  ```
- Line 559: loc
  ```
  local title "Guilt"
  ```
- Line 562: loc
  ```
  local title "Pride"
  ```
- Line 565: loc
  ```
  local title "Fairness"
  ```
- Line 568: loc
  ```
  local title "Unfairness"
  ```
- Line 571: loc
  ```
  local title "Financial Satisfaction"
  ```
- Line 574: loc
  ```
  local title "Satisfaction"
  ```
- Line 577: loc
  ```
  local title "Happiness"
  ```
- Line 678: loc
  ```
  local `e'_psym_1 = "="
  ```
- Line 682: loc
  ```
  local `e'_psym_2 = "="
  ```
- Line 686: loc
  ```
  local `e'_psym_3 = "="
  ```
- Line 690: loc
  ```
  local `e'_psym_4 = "="
  ```
- Line 694: loc
  ```
  local `e'_psym_5 = "="
  ```
- Line 698: loc
  ```
  local `e'_psym_1 = "<"
  ```
- Line 702: loc
  ```
  local `e'_psym_2 = "<"
  ```
- Line 706: loc
  ```
  local `e'_psym_3 = "<"
  ```
- Line 710: loc
  ```
  local `e'_psym_4 = "<"
  ```
- Line 714: loc
  ```
  local `e'_psym_5 = "<"
  ```
- Line 781: loc
  ```
  local title "Guilt"
  ```
- Line 784: loc
  ```
  local title "Pride"
  ```
- Line 787: loc
  ```
  local title "Fairness"
  ```
- Line 790: loc
  ```
  local title "Unfairness"
  ```
- Line 793: loc
  ```
  local title "Financial Satisfaction"
  ```
- Line 796: loc
  ```
  local title "Satisfaction"
  ```
- Line 799: loc
  ```
  local title "Happiness"
  ```
- Line 899: loc
  ```
  local `e'_psym_1 = "="
  ```
- Line 903: loc
  ```
  local `e'_psym_2 = "="
  ```
- Line 907: loc
  ```
  local `e'_psym_3 = "="
  ```
- Line 911: loc
  ```
  local `e'_psym_4 = "="
  ```
- Line 915: loc
  ```
  local `e'_psym_5 = "="
  ```
- Line 919: loc
  ```
  local `e'_psym_1 = "<"
  ```
- Line 923: loc
  ```
  local `e'_psym_2 = "<"
  ```
- Line 927: loc
  ```
  local `e'_psym_3 = "<"
  ```
- Line 931: loc
  ```
  local `e'_psym_4 = "<"
  ```
- Line 935: loc
  ```
  local `e'_psym_5 = "<"
  ```

**/replication-package/Analysis/Code/Welfare-values.do**

- Line 21: lon
  ```
  cap program drop prog_lu_mmu_long
  ```
- Line 22: lon
  ```
  program define prog_lu_mmu_long, rclass
  ```
- Line 23: lat
  ```
  * Get reg coefficients for relative weights of each CSA
  ```
- Line 29: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 44: lon
  ```
  prog_lu_mmu_long
  ```
- Line 47: social
  ```
  sum mmu if choice_set==1 & prosocial==0 & part==1
  ```
- Line 48: loc
  ```
  local mean1=r(mean)
  ```
- Line 49: social
  ```
  sum mmu if choice_set==4 & prosocial==0 & part==1
  ```
- Line 53: social
  ```
  reg mmu choice_set if part==1 & prosocial==0 & inrange(choice_set,1,4)
  ```
- Line 67: lon
  ```
  prog_lu_mmu_long
  ```
- Line 70: social
  ```
  sum mmu if choice_set==4 & prosocial==1 & part==1
  ```
- Line 71: loc
  ```
  local mean1=r(mean)
  ```
- Line 72: social
  ```
  sum mmu if choice_set==7 & prosocial==1 & part==1
  ```
- Line 76: social
  ```
  reg mmu choice_set if part==1 & prosocial==1 & inrange(choice_set,4,7)
  ```
- Line 92: lat
  ```
  ** Relative emotions
  ```
- Line 98: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 99: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 100: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 101: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 102: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 103: social
  ```
  destring prosocial, force replace
  ```
- Line 106: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 107: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 108: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 109: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 117: lon
  ```
  prog_lu_mmu_long
  ```
- Line 120: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 123: social
  ```
  gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 128: social
  ```
  sum mmu if choice_set==1 & prosocial==0 & part==1
  ```
- Line 129: loc
  ```
  local mean1: di %3.2f r(mean)
  ```
- Line 130: lat
  ```
  latex_write dgonea `mean1' numbers_pipe
  ```
- Line 132: social
  ```
  sum mmu if choice_set==4 & prosocial==0 & part==1
  ```
- Line 133: loc
  ```
  local mean4: di %3.2f r(mean)
  ```
- Line 134: lat
  ```
  latex_write dgfour `mean4' numbers_pipe
  ```
- Line 136: social
  ```
  sum mmu if choice_set==4 & prosocial==1 & part==1
  ```
- Line 137: loc
  ```
  local mean4e: di %3.2f r(mean)
  ```
- Line 138: lat
  ```
  latex_write dgfoure `mean4e' numbers_pipe
  ```
- Line 140: social
  ```
  sum mmu if choice_set==7 & prosocial==1 & part==1
  ```
- Line 141: loc
  ```
  local mean7: di %3.2f r(mean)
  ```
- Line 142: lat
  ```
  latex_write dgsevena `mean7' numbers_pipe
  ```
- Line 144: social
  ```
  reg mmu choice_set if part==1 & prosocial==1 & inrange(choice_set,4,7)
  ```
- Line 145: loc
  ```
  local mean8: di %3.2f _b[choice_set]
  ```
- Line 146: lat
  ```
  latex_write coefdge `mean8' numbers_pipe
  ```
- Line 148: social
  ```
  reg mmu choice_set if part==1 & prosocial==0 & inrange(choice_set,1,4)
  ```
- Line 149: loc
  ```
  local mean9: di %3.2f _b[choice_set]
  ```
- Line 150: lat
  ```
  latex_write coefdgle `mean9' numbers_pipe
  ```
- Line 158: loc, url
  ```
  local dgonefourlo: di %4.2g CI[1,1]
  ```
- Line 159: lat, url
  ```
  latex_write dgonefourlo `dgonefourlo' numbers_pipe
  ```
- Line 160: loc
  ```
  local dgonefourhi: di %4.2g CI[2,1]
  ```
- Line 161: lat
  ```
  latex_write dgonefourhi `dgonefourhi' numbers_pipe
  ```
- Line 162: loc
  ```
  local coefdglelo: di %4.2g CI[1,2]
  ```
- Line 163: lat
  ```
  latex_write coefdglelo `coefdglelo' numbers_pipe
  ```
- Line 164: loc
  ```
  local coefdglehi: di %4.2g CI[2,2]
  ```
- Line 165: lat
  ```
  latex_write coefdglehi `coefdglehi' numbers_pipe
  ```
- Line 172: loc
  ```
  local dgfoursevenlo: di %4.2g CI[1,1]
  ```
- Line 173: lat
  ```
  latex_write dgfoursevenlo `dgfoursevenlo' numbers_pipe
  ```
- Line 174: loc
  ```
  local dgfoursevenhi: di %4.2g CI[2,1]
  ```
- Line 175: lat
  ```
  latex_write dgfoursevenhi `dgfoursevenhi' numbers_pipe
  ```
- Line 176: loc
  ```
  local coefdgelo: di %4.2g CI[1,2]
  ```
- Line 177: lat
  ```
  latex_write coefdgelo `coefdgelo' numbers_pipe
  ```
- Line 178: loc
  ```
  local coefdgehi: di %4.2g CI[2,2]
  ```
- Line 179: lat
  ```
  latex_write coefdgehi `coefdgehi' numbers_pipe
  ```

**/replication-package/Analysis/Code/X_DG-vs-OO-Weights.do**

- Line 12: lon
  ```
  use "$prepped_data_dir/mturk_all_long_analysis.dta", clear
  ```
- Line 15: lon
  ```
  * Reshape long
  ```
- Line 16: lon
  ```
  reshape long ratingguilt ratingpride ratingfinan ratingfair ratingunfair ///
  ```
- Line 17: social
  ```
  ratingsatis ratinghappy, i(mturkid prosocial choice_set present) j(part)
  ```
- Line 22: social
  ```
  gen choice=(part1_choice==prosocial) if part==1
  ```
- Line 23: social
  ```
  replace choice=(part3_choice==prosocial) if part==3
  ```
- Line 35: social
  ```
  inlist(treatment,"main","cs"), case(group) alt(prosocial) cluster(mturkid) nocons
  ```
- Line 54: social
  ```
  1 "Prosocial Constant" 2 "Opt-Out Constant")  ///
  ```

**/replication-package/Analysis/Code/X_IV-test-for-happiness-satisfaction.do**

- Line 31: lat
  ```
  * Get relative emotions
  ```
- Line 36: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 37: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 38: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 39: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 40: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 41: social
  ```
  destring prosocial, force replace
  ```
- Line 48: loc
  ```
  local instruments rel_guilt rel_pride rel_finan rel_fair rel_unfair
  ```

**/replication-package/Analysis/Code/X_Order-effects.do**

- Line 29: lat
  ```
  ** Relative emotions
  ```
- Line 35: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 36: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 37: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 38: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 39: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 40: social
  ```
  destring prosocial, force replace
  ```
- Line 43: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 44: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 45: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 46: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 53: lon
  ```
  cap program drop prog_lu_mmu_long
  ```
- Line 54: lon
  ```
  program define prog_lu_mmu_long
  ```
- Line 56: lat
  ```
  * Get reg coefficients for relative weights of each emotion
  ```
- Line 62: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 67: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 69: social
  ```
  gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 83: lon
  ```
  qui prog_lu_mmu_long
  ```
- Line 97: social
  ```
  logit optin payout if part==3 & prosocial==2 & optout_all==`c' & oo_first==1 //OO first
  ```
- Line 99: loc
  ```
  local logit1 = _b[_cons]/_b[payout]*-1
  ```
- Line 102: social
  ```
  sum mmu if part==1 & prosocial==part1_choice & choice_set==`c' & dg_first==1 // DG first
  ```
- Line 104: loc
  ```
  local ev1_`c' = r(mean)
  ```
- Line 126: lon
  ```
  prog_lu_mmu_long "& arm==1"
  ```
- Line 133: social
  ```
  replace pred=1-pred if (part==1 | part==2) & prosocial==0
  ```
- Line 140: lon
  ```
  prog_lu_mmu_long  "& arm==0"
  ```
- Line 147: social
  ```
  replace pred2=1-pred2 if (part==1 | part==2) & prosocial==0
  ```
- Line 154: social
  ```
  reg part1_choice pred if part==1 & prosocial==1 & arm==0
  ```
- Line 155: loc
  ```
  local eq = `"`: display %4.2f _b[pred]'"'
  ```
- Line 157: social
  ```
  binscatter part1_choice pred if part==1 & prosocial==1 & arm==0, ///
  ```
- Line 166: social
  ```
  reg part1_choice pred2 if part==1 & prosocial==1 & arm==1
  ```
- Line 167: loc
  ```
  local eq = `"`: display %4.2f _b[pred2]'"'
  ```
- Line 169: social
  ```
  binscatter part1_choice pred2 if part==1 & prosocial==1 & arm==1, ///
  ```

**/replication-package/Analysis/Code/X_PCA.do**

- Line 12: loc
  ```
  local overline = uchar(773)
  ```
- Line 26: lat
  ```
  ** Relative emotions
  ```
- Line 32: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 33: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 34: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 35: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 36: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 37: social
  ```
  destring prosocial, force replace
  ```
- Line 40: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 41: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 42: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 43: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 54: lat
  ```
  * Get reg coefficients for relative weights of each emotion
  ```
- Line 66: social
  ```
  case(group) alt(prosocial) cluster(`0')
  ```
- Line 69: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 76: social
  ```
  sum mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 78: social
  ```
  sum mmu2 if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 84: social
  ```
  sum mmu if part==1 & choice_set==`c' & prosocial==`p'
  ```
- Line 86: social
  ```
  sum mmu2 if part==1 & choice_set==`c' & prosocial==`p'
  ```
- Line 109: lname, name
  ```
  matrix colnames ev = "Eigenvalue"
  ```
- Line 111: lname, name
  ```
  matrix colnames p = "Proportion of Variance"
  ```
- Line 117: lat, lname, name
  ```
  matrix colnames c = "Cumulative"
  ```
- Line 123: lat
  ```
  * Save cumulative variance
  ```
- Line 125: loc
  ```
  local pcacum = round(c[2,3]*100,1)
  ```
- Line 126: loc
  ```
  local pcacum: di %9.2f `pcacum'
  ```
- Line 127: lat
  ```
  latex_write pcacum `pcacum' numbers_pipe
  ```
- Line 128: loc
  ```
  local pcalow = round(c[7,2]*100,1)
  ```
- Line 129: loc
  ```
  local pcalow: di %9.2f `pcalow'
  ```
- Line 130: lat
  ```
  latex_write pcalow `pcalow' numbers_pipe
  ```
- Line 135: lat
  ```
  cells("table[Eigenvalue](t fmt(2)) table[Proportion of Variance](t fmt(2)) table[Cumulative](t fmt(2
  ```
- Line 150: social
  ```
  gen choice1=(part1_choice==prosocial)
  ```
- Line 151: social
  ```
  gen choice3=(part3_choice==prosocial)
  ```
- Line 168: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 195: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 213: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & sample=="CSA", lcolor(ebblue%40)) ///
  ```
- Line 214: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="CSA", mcolor(ebblue%40)) ///
  ```
- Line 215: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="CSA", lcolor(orange%40)) ///
  ```
- Line 216: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="CSA", mcolor(orange%40)) ///
  ```
- Line 217: social
  ```
  (rspike upper lower graph_order if prosocial==1 & sample=="PCA", lcolor(magenta%40)) ///
  ```
- Line 218: social
  ```
  (sc coef graph_order if prosocial==1 & sample=="PCA", mcolor(magenta%40) m(T)) ///
  ```
- Line 219: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & sample=="PCA", lcolor(midgreen%40)) ///
  ```
- Line 220: social
  ```
  (sc coef graph_order if prosocial==0 & sample=="PCA", mcolor(midgreen%40) m(T)), ///
  ```

**/replication-package/Analysis/Code/X_Test-OVB.do**

- Line 17: lon
  ```
  cap program drop prog_lu_mmu_long
  ```
- Line 18: lon
  ```
  program define prog_lu_mmu_long, rclass
  ```
- Line 19: lat
  ```
  * Get reg coefficients for relative weights of each emotion
  ```
- Line 25: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 32: lon
  ```
  cap program drop prog_lu_mmu_long_fe
  ```
- Line 33: lon
  ```
  program define prog_lu_mmu_long_fe, rclass
  ```
- Line 34: lat
  ```
  * Get reg coefficients for relative weights of each emotion
  ```
- Line 40: lat
  ```
  * Now reg latent utility on the payoff and get mmu
  ```
- Line 55: social
  ```
  gen temp=mmu if part==2 & choice_set==4 & prosocial==0 & treatment=="main"
  ```
- Line 65: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==1
  ```
- Line 68: social
  ```
  sum mmu if choice_set==`c' & prosocial==`p' & part==1 & part1_choice==prosocial
  ```
- Line 92: lat
  ```
  * Relative emotions
  ```
- Line 98: lon
  ```
  reshape long $emotions, ///
  ```
- Line 99: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 100: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 101: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 102: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 103: social
  ```
  destring prosocial, force replace
  ```
- Line 109: social
  ```
  gen payoff=4 if choice_set==4 & part==2 & prosocial==0
  ```
- Line 110: social
  ```
  replace payoff=3.5 if choice_set==5 & part==2 & prosocial==0
  ```
- Line 111: social
  ```
  replace payoff=3 if choice_set==6 & part==2 & prosocial==0
  ```
- Line 112: social
  ```
  replace payoff=2.5 if choice_set==7 & part==2 & prosocial==0
  ```
- Line 127: loc
  ```
  local PR2: di %9.2f 1-(l1/l0)
  ```
- Line 132: loc
  ```
  local obs_logit = e(N)
  ```
- Line 133: loc
  ```
  local group_logit = e(N_clust)
  ```
- Line 135: loc
  ```
  estadd local cs "No", replace
  ```
- Line 148: loc
  ```
  local PR2: di %9.2f 1-(l1/l0)
  ```
- Line 153: loc
  ```
  local obs_fe = e(N)
  ```
- Line 154: loc
  ```
  local group_fe = e(N_clust)
  ```
- Line 156: loc
  ```
  estadd local cs "Yes", replace
  ```
- Line 182: lat
  ```
  * Get reg coefficients for relative weights of each emotion
  ```
- Line 189: social
  ```
  keep mturkid part choice_set prosocial $emotions lu csfe*
  ```
- Line 190: social
  ```
  reshape wide $emotions lu, i(mturkid part choice_set csfe*) j(prosocial)
  ```
- Line 197: loc
  ```
  local pr2=round(e(r2_a),0.01)
  ```
- Line 199: lat
  ```
  latex_write csfers `pr2' numbers_pipe
  ```
- Line 200: loc
  ```
  local obs = e(N)
  ```
- Line 201: loc
  ```
  local group = e(N_clust)
  ```
- Line 234: lon
  ```
  reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long
  ```
- Line 240: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 264: lon
  ```
  reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long_fe
  ```
- Line 270: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 281: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & fe==0, lcolor(ebblue)) ///
  ```
- Line 282: social
  ```
  (sc coef graph_order if prosocial==1 & fe==0, mcolor(ebblue)) ///
  ```
- Line 283: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & fe==0, lcolor(orange)) ///
  ```
- Line 284: social
  ```
  (sc coef graph_order if prosocial==0 & fe==0, mcolor(orange)) ///
  ```
- Line 285: social
  ```
  (rspike upper lower graph_order if prosocial==1 & fe==1, lcolor(ebblue%40)) ///
  ```
- Line 286: social
  ```
  (sc coef graph_order if prosocial==1 & fe==1, mcolor(ebblue%40) m(T)) ///
  ```
- Line 287: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & fe==1, lcolor(orange%40)) ///
  ```
- Line 288: social
  ```
  (sc coef graph_order if prosocial==0 & fe==1, mcolor(orange%40) m(T)), ///
  ```
- Line 309: lon
  ```
  reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long
  ```
- Line 315: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 339: lon
  ```
  reps(1000) seed(123450) cluster(mturkid) nodrop: prog_util prog_lu_mmu_long_fe
  ```
- Line 345: social
  ```
  gen prosocial = mod(n,2)
  ```
- Line 357: social
  ```
  tw (rspike upper lower graph_order if prosocial==1 & fe==0, lcolor(ebblue)) ///
  ```
- Line 358: social
  ```
  (sc coef graph_order if prosocial==1 & fe==0, mcolor(ebblue)) ///
  ```
- Line 359: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & fe==0, lcolor(orange)) ///
  ```
- Line 360: social
  ```
  (sc coef graph_order if prosocial==0 & fe==0, mcolor(orange)) ///
  ```
- Line 361: social
  ```
  (rspike upper lower graph_order if prosocial==1 & fe==1, lcolor(ebblue%40)) ///
  ```
- Line 362: social
  ```
  (sc coef graph_order if prosocial==1 & fe==1, mcolor(ebblue%40) m(T)) ///
  ```
- Line 363: social
  ```
  (rspike  upper lower graph_order if prosocial==0 & fe==1, lcolor(orange%40)) ///
  ```
- Line 364: social
  ```
  (sc coef graph_order if prosocial==0 & fe==1, mcolor(orange%40) m(T)), ///
  ```

**/replication-package/Analysis/Code/comp_OO_CC.do**

- Line 5: son
  ```
  * Open data and clean (person by choice set level)
  ```
- Line 15: son
  ```
  * Reshape - person by choice level
  ```
- Line 16: lon
  ```
  reshape long guilt pride finan fair unfair happy satis, ///
  ```
- Line 17: social
  ```
  i(mturkid choice_set part present) j(prosocial) string
  ```
- Line 18: social
  ```
  replace prosocial="1" if prosocial=="_p1"
  ```
- Line 19: social
  ```
  replace prosocial="0" if prosocial=="_p0"
  ```
- Line 20: social
  ```
  replace prosocial="2" if prosocial=="_p2"
  ```
- Line 21: social
  ```
  destring prosocial, force replace
  ```
- Line 28: son
  ```
  * Within person analysis
  ```
- Line 43: loc, location
  ```
  gen temp=part1_choice if choice_set==optout_allocation
  ```
- Line 50: loc, location, social
  ```
  drop if part==2 & prosocial==1 // get rid of prosocial allocations
  ```
- Line 51: social
  ```
  drop if part==3 & prosocial!=2 // only keep opt-out option in part 3
  ```
- Line 52: social
  ```
  drop prosocial
  ```
- Line 60: son
  ```
  * Reshape so that we have person by $4/$3.5/$3
  ```
- Line 69: loc, location
  ```
  * optout_allocation = other choice set in opt out game (in case you need but not immediate)
  ```
- Line 71: loc, location
  ```
  * (4i) = splitting by what they chose in part 1 (part1_choice) and if they have the same allocation
  ```
- Line 81: loc
  ```
  local mainthreegive = r(N)/3
  ```
- Line 84: loc
  ```
  local mainthreenotgive = r(N)/3
  ```
- Line 86: lat
  ```
  latex_write mainthreegive `mainthreegive' survey_numbers
  ```
- Line 87: lat
  ```
  latex_write mainthreenotgive `mainthreenotgive' survey_numbers
  ```

