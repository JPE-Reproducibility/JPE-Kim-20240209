## Code Quality

### Stata

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Clean-cs.do, line 141)
  → drop if rating==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Clean-exante.do, line 110)
  → drop if rating==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Clean-main.do, line 140)
  → drop if rating==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1-Summary-Statistics.do, line 241)
  → drop if prosocial==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1-Summary-Statistics.do, line 242)
  → drop if `emotion'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1-Summary-Statistics.do, line 283)
  → keep if part==3 & (treatment=="main" | treatment=="cs")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4-All-Welfare-Analysis-Bootstrap-CombinedHS.do, line 194)
  → drop if prosocial==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7-Stability-DG-Weights-2.do, line 37)
  → drop if part==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 1 Analysis.do, line 13)
  → drop if _n ==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 1 Analysis.do, line 16)
  → drop if attention_check != "" // Drop those who failed attention check

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 1 Analysis.do, line 17)
  → drop if progress!="100"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 1 Analysis.do, line 18)
  → drop if id==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 1 Analysis.do, line 19)
  → drop if id == 96 // Sophie's ID

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 1 Analysis.do, line 32)
  → drop if ai_flag ==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 2 Analysis.do, line 12)
  → drop if _n ==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 2 Analysis.do, line 15)
  → drop if attention_check != "" // Drop those who failed attention check

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 2 Analysis.do, line 17)
  → drop if progress!="100"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 2 Analysis.do, line 18)
  → drop if id==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 2 Analysis.do, line 27)
  → drop if ai_flag ==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 62)
  → drop if progress!="100"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 63)
  → drop if id==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 64)
  → drop if attention_check != "" // Drop those who failed attention check

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 315)
  → drop if csa_`e'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 512)
  → keep if s2_choice == `s2choice'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 582)
  → keep if s2_choice == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 586)
  → drop if csa_`e'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 804)
  → keep if s2_choice == 2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Supplementary Survey 3 Analysis.do, line 808)
  → drop if csa_`e'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (X_DG-vs-OO-Weights.do, line 18)
  → drop if ratingguilt==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (X_PCA.do, line 19)
  → keep if inlist(treatment,"main","cs")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (comp_OO_CC.do, line 50)
  → drop if part==2 & prosocial==1 // get rid of prosocial allocations

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (comp_OO_CC.do, line 51)
  → drop if part==3 & prosocial!=2 // only keep opt-out option in part 3

