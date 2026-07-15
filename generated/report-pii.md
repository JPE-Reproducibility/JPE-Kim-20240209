## Potential Personal Identifiable Information (PII)

⚠️ We found the following instances of potentially personally identifying information. This may be completely legitimate but might be worth checking. *As a reminder, privacy legislation in many countries (e.g. GDPR in EU) prohibits the dissemination of personal identifiable information without prior (and documented) consent of individuals.* If indeed you want to publish such information with your replication package, you should probably have obtained IRB approval for this - please check!

**Summary:**
- Data files with PII indicators: 11
- Variables flagged in data: 27
- Code files with PII references: 26
- PII references in code: 1051

### Summary of Flagged Files

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `JPE Revision Survey 1 Final.xlsx` | 2 | second, gender |
| Data | `JPE Revision Survey 2 Final.xlsx` | 5 | second, son, gender |
| Data | `JPE Revision Survey 3 Final.xlsx` | 2 | second, gender |
| Data | `cs.csv` | 3 | gender, loc, location, social |
| Data | `cs.dta` | 3 | gender, loc, location, social |
| Data | `exante.csv` | 2 | gender, loc, location |
| Data | `exante.dta` | 2 | gender, loc, location |
| Data | `main.csv` | 2 | gender, loc, location |
| Data | `main.dta` | 2 | gender, loc, location |
| Data | `pf.csv` | 2 | gender, loc, location |
| Data | `pf.dta` | 2 | gender, loc, location |
| Code | `0a-Programs-and-Macros.do` | 15 | lat, name, loc |
| Code | `1-Summary-Statistics.do` | 73 | lat, gender, loc, location, lon, social |
| Code | `2-Analysis.do` | 26 | lat, second, loc, lon, social |
| Code | `3-Robustness.do` | 9 | lat, lon, social, loc |
| Code | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do` | 225 | loc, lon, lat, social |
| Code | `5-Compare-DG-utilities.do` | 26 | lat, lon, social, loc |
| Code | `6-Stability-DG-Weights.do` | 38 | lon, lat, social, loc |
| Code | `7-Stability-DG-Weights-2.do` | 15 | social, loc, lat, lon |
| Code | `AI-flag-Survey1.do` | 7 | loc, son |
| Code | `AI-flag-Survey2.do` | 13 | son, loc |
| Code | `Clean-MTurk.do` | 24 | son, lon, house, school, degree, gender, social |
| Code | `Clean-cs.do` | 29 | name, loc, location, son, lon, social |
| Code | `Clean-exante.do` | 26 | son, lon, social, name |
| Code | `Clean-main.do` | 28 | loc, location, son, lon, social, name |
| Code | `Clean-pf.do` | 23 | son, lon, social, name |
| Code | `Heterogeneous-MU.do` | 38 | lat, lon, social, loc |
| Code | `Supplementary Survey 1 Analysis.do` | 60 | second, name, loc, son, lat, lon, social |
| Code | `Supplementary Survey 2 Analysis.do` | 60 | second, loc, lat, name, lon, gender, degree, son |
| Code | `Supplementary Survey 3 Analysis.do` | 83 | lat, lon, social, name, loc, second |
| Code | `Welfare-values.do` | 62 | lon, lat, social, loc, url |
| Code | `X_DG-vs-OO-Weights.do` | 8 | lon, social |
| Code | `X_IV-test-for-happiness-satisfaction.do` | 8 | lat, lon, social, loc |
| Code | `X_Order-effects.do` | 32 | lat, lon, social, loc |
| Code | `X_PCA.do` | 42 | loc, lat, lon, social, lname, name |
| Code | `X_Test-OVB.do` | 61 | lon, lat, social, loc |
| Code | `comp_OO_CC.do` | 20 | son, lon, social, loc, location, lat |

*See [Appendix](report-pii-appendix.md) for detailed listing of all flagged instances.*
