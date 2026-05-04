# Welfare and the Act of Choosing

## Data Availability Statement

This paper uses only primary data collected by the authors. The replication package includes the de-identified raw data and code required to reproduce all tables, figures, and in-text quantitative results in the paper and online appendix. No proprietary datasets are required for replication.

The package contains data from six online studies. Three are motivating surveys fielded through Prolific Academic on March 31, 2025. Each survey enrolled 500 participants. After applying the attention-check and AI-detection procedures described in the paper, 482, 468, and 496 participants remained in the analysis samples for Surveys 1, 2, and 3, respectively. Participants were paid \$2.50, \$3.50, and \$1.50, respectively. Average completion times were 11.3, 14.4, and 5.8 minutes, respectively.

The package also contains data from three online experimental studies fielded through Amazon Mechanical Turk (MTurk) between late August 2021 and early September 2021. In total, 2,800 individuals completed the study: 2,400 in the main treatment and 200 each in two alternative treatments. As described in the paper, 60 participants were excluded from the analysis. Participants received a base payment of \$2 and could earn up to an additional \$4 to incentivize truthful responses. Typical completion time was approximately 10 to 15 minutes.

All studies included attention checks in which participants were instructed to leave a question blank. There was no deception in any study or experiment.

To comply with IRB and platform confidentiality requirements, the public replication files have been de-identified. Direct subject identifiers, including Prolific participant IDs and MTurk worker IDs, have been transformed and are not included in the public package. The public package is sufficient to reproduce the analysis in the paper and appendix. Because the identifying variables in the original internal files were removed or transformed before public release, exact bootstrap resamples may differ from those produced from the authors' original files, and some bootstrapped standard errors may therefore differ slightly. These differences do not affect the substantive results (effect sizes) or conclusions.

There are no monetary, licensing, or application costs to access the public replication package once it is deposited in the JPE Dataverse.

## Package Contents

The replication package contains the following folders:\
- `Analysis/`: data, code, intermediate files, and generated outputs for the analysis.\
- `Docs/`: IRB approval documentation and additional supporting materials such as study instructions.

Within `Analysis/`, there are six subfolders:\
- `Build/` and `Raw_Data/`: scripts and source files used to construct the main experimental datasets.\
- `Code/`, `Bootstrapped_Data/`, and `Prepped_Data/`: analysis code and intermediate files used to create the paper's tables and figures.\
- `Output/`: generated tables, figures, and in-text-number files used in the manuscript.

The main analysis driver is currently [0-Master.do] in `Analysis/Code/`. This file runs the analysis scripts for the main paper, appendix, and supplementary surveys.

The experimental raw data are stored in `Analysis/Raw_Data/`:

-   `main.dta`: main experimental treatment.
-   `cs.dta`: alternative computer-choice treatment in which the unchosen alternative is displayed.
-   `exante.dta`: treatment in which CSAs are elicited before choices.
-   `pf.dta`: present-future treatment in which participants separately report present and future CSAs.

The raw survey data are also stored in `Analysis/Raw_Data/`:

-   `JPE Revision Survey 1 Final.xlsx`: author-collected raw responses for motivating Survey 1 fielded on Prolific on March 31, 2025.
-   `JPE Revision Survey 2 Final.xlsx`: author-collected raw responses for motivating Survey 2 fielded on Prolific on March 31, 2025.
-   `JPE Revision Survey 3 Final.xlsx`: author-collected raw responses for motivating Survey 3 fielded on Prolific on March 31, 2025.

The raw files are wide, respondent-level Qualtrics exports after de-identification. The cleaning scripts in `Analysis/Build/` reshape them into the analysis files in `Analysis/Prepped_Data/`. The key raw-variable naming conventions are:

-   `mturkid`: de-identified participant identifier.
-   `part1`, `part2`, and `part3`: survey modules. `part1` is the Dictator Game (DG), `part2` is the Computer Choice module (CC), and `part3` is the Opt-Out Game (OO).
-   `q#`: choice-set number. For example, `q1` refers to choice set 1.
-   `part1_a#`: participant's choice in DG choice set `#` (`0 = less equitable`, `1 = equitable`). For example, `part1_a1` is the participant's choice in DG choice set 1.
-   `part3_q#_in#` and `part3_q#_out#`: raw OO choice variables for OO choice set `q#` and opt-out allocation `#`. These are combined during cleaning into a single OO choice variable, where `0 = less equitable`, `1 = equitable`, and `2 = opt-out`.
-   `p0`, `p1`, and `p2`: the option being rated. `p0` refers to the less equitable option, `p1` refers to the equitable option, and `p2` refers to the opt-out option. `p2` appears only for OO ratings.
-   `_1` through `_7`: CSA display-order index. The variables `e1` through `e7` record which CSA each index represents for that participant. The possible CSAs are guilt, pride, financial satisfaction, sense of fairness, sense of unfairness, happiness, and satisfaction with the study experience.
-   Variables such as `part1_q1_p1_3` should be read as: DG, choice set 1, equitable option, CSA shown in display position 3. The `e3` variable identifies which CSA was shown in display position 3 for that participant.
-   In `pf.dta`, the suffix after `p` combines option and timing. For example, `p11` means equitable option, present CSA; `p12` means equitable option, future CSA; `p01` means less equitable option, present CSA; and `p02` means less equitable option, future CSA. The cleaned files store this timing as the `present` indicator.
-   `age`, `gender`, `education`, and `hhincome`: demographic variables.

The cleaned analysis data in `Analysis/Prepped_Data/` use a more compact structure. The two main combined analysis files are `mturk_all_wide_analysis.dta` and `mturk_all_long_analysis.dta`. They include:

-   `treatment`: treatment assignment (`main`, `cs`, `exante`, `pf`).
-   `part`: game module (`1 = DG`, `2 = CC`, `3 = OO`).
-   `choice_set`: choice-set identifier corresponding to the sets discussed in the paper.
-   `optout_allocation`: DG subgame shown in the OO condition.
-   `part1_choice`: DG choice for a given choice set (`0 = less equitable`, `1 = equitable`).
-   `part3_choice`: OO choice for a given choice set (`0 = less equitable`, `1 = equitable`, `2 = opt-out`).
-   `present`: indicator for whether CSA ratings refer to the present or future in the present-future treatment.

For `mturk_all_wide_analysis.dta`, CSA ratings are stored in variables such as `guilt_p0`, `guilt_p1`, and `guilt_p2`, where the suffix identifies the option rated (`p0 = less equitable`, `p1 = equitable`, `p2 = opt-out`). The same convention applies to `pride`, `finan`, `fair`, `unfair`, `happy`, and `satis`.

For `mturk_all_long_analysis.dta`, CSA ratings are stored in variables such as `ratingguilt1`, `ratingguilt2`, and `ratingguilt3`, where the final number identifies the module (`1 = DG`, `2 = CC`, `3 = OO`). The same convention applies to `ratingpride`, `ratingfinan`, `ratingfair`, `ratingunfair`, `ratinghappy`, and `ratingsatis`.

## Mapping Figures and Tables

The following table maps the paper's tables and figures to the corresponding file(s) in `Analysis/Output/` and the Stata script that creates them.

| Exhibit    | Output file(s)                                                                                                                                                                                                                                                                                       | Originating code file(s)                                                        |
|------------------------|------------------------|------------------------|
| Figure 1   | `finan_cat_respondent_level.png`; `health_cat_respondent_level.png`; `career_cat_respondent_level.png`                                                                                                                                                                                               | `Supplementary Survey 2 Analysis.do`                                            |
| Figure 2   | `emotions_finan_mean_plot.png`; `emotions_health_mean_plot.png`; `emotions_career_mean_plot.png`                                                                                                                                                                                                     | `Supplementary Survey 2 Analysis.do`                                            |
| Figure 4   | `main_sumstat_cs_part1.pdf`; `sumstat_cs_part3.pdf`; `sumstat_part1_part3.pdf`                                                                                                                                                                                                                       | `1-Summary-Statistics.do`                                                       |
| Figure 5   | `main_sumstat_guilt.pdf`; `main_sumstat_pride.pdf`; `main_sumstat_finan.pdf`; `main_sumstat_fair.pdf`; `main_sumstat_unfair.pdf`; `main_sumstat_happy.pdf`; `main_sumstat_satis.pdf`                                                                                                                 | `1-Summary-Statistics.do`                                                       |
| Table 1    | `ivlogit_part1.tex`                                                                                                                                                                                                                                                                                  | `2-Analysis.do`                                                                 |
| Figure 6   | `binscatter_obs_pred_dg_dgweights.pdf`; `binscatter_obs_pred_dg_ooweights.pdf`                                                                                                                                                                                                                       | `6-Stability-DG-Weights.do`                                                     |
| Figure 7   | `logit_mmup1_means.pdf`; `logit_chosen_mmu_means_p1.pdf`                                                                                                                                                                                                                                             | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`                                |
| Figure 8   | `logit_mmup2_means.pdf`; `logit_mmudiff2_part2.pdf`                                                                                                                                                                                                                                                  | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`                                |
| Figure 9   | `logit_mmudiff_p0p1_part12.pdf`; `pred2_diff_prob_dg_cc.pdf`                                                                                                                                                                                                                                         | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`; `7-Stability-DG-Weights-2.do` |
| Figure 10  | `logit_mmup3_o3_means.pdf`; `logit_mmup3_o4_means.pdf`; `logit_mmup3_o5_means.pdf`                                                                                                                                                                                                                   | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`                                |
| Table 2    | `logit_vs_ev_dg.tex`                                                                                                                                                                                                                                                                                 | `5-Compare-DG-utilities.do`                                                     |
| Figure A1  | `emotions_y_mean_plot.png`                                                                                                                                                                                                                                                                           | `Supplementary Survey 1 Analysis.do`                                            |
| Figure A2  | `emotions_remind_g_finan_mean_plot.png`; `emotions_remind_g_career_mean_plot.png`; `emotions_remind_g_health_mean_plot.png`                                                                                                                                                                          | `Supplementary Survey 2 Analysis.do`                                            |
| Figure A3  | `mean_diff_m_s2donate.png`; `mean_diff_m_share1.png`                                                                                                                                                                                                                                                 | `Supplementary Survey 3 Analysis.do`; `comp_OO_CC.do`                           |
| Figure A4  | `mean_diff_m_s2nodonate.png`; `mean_diff_m_noshare1.png`                                                                                                                                                                                                                                             | `Supplementary Survey 3 Analysis.do`; `comp_OO_CC.do`                           |
| Figure A5  | `s1_choice_hist.png`; `s2_choice_hist.png`                                                                                                                                                                                                                                                           | `Supplementary Survey 3 Analysis.do`                                            |
| Figure A6  | `mean_fair_survey3.png`; `mean_unfair_survey3.png`; `mean_finan_survey3.png`; `mean_guilt_survey3.png`; `mean_happy_survey3.png`; `mean_pride_survey3.png`; `mean_satis_survey3.png`                                                                                                                 | `Supplementary Survey 3 Analysis.do`                                            |
| Figure A7  | `mean_fair_survey3_origchoice_s2_1.png`; `mean_unfair_survey3_origchoice_s2_1.png`; `mean_finan_survey3_origchoice_s2_1.png`; `mean_guilt_survey3_origchoice_s2_1.png`; `mean_happy_survey3_origchoice_s2_1.png`; `mean_pride_survey3_origchoice_s2_1.png`; `mean_satis_survey3_origchoice_s2_1.png` | `Supplementary Survey 3 Analysis.do`                                            |
| Figure A8  | `mean_fair_survey3_origchoice_s2_2.png`; `mean_unfair_survey3_origchoice_s2_2.png`; `mean_finan_survey3_origchoice_s2_2.png`; `mean_guilt_survey3_origchoice_s2_2.png`; `mean_happy_survey3_origchoice_s2_2.png`; `mean_pride_survey3_origchoice_s2_2.png`; `mean_satis_survey3_origchoice_s2_2.png` | `Supplementary Survey 3 Analysis.do`                                            |
| Table A1   | `all_sumstats_demo.tex`                                                                                                                                                                                                                                                                              | `1-Summary-Statistics.do`                                                       |
| Figure A9  | `main_sumstat_guilt_part3.pdf`; `main_sumstat_pride_part3.pdf`; `main_sumstat_finan_part3.pdf`; `main_sumstat_fair_part3.pdf`; `main_sumstat_unfair_part3.pdf`; `main_sumstat_happy_part3.pdf`; `main_sumstat_satis_part3.pdf`                                                                       | `1-Summary-Statistics.do`                                                       |
| Figure A10 | `main_sumstat_part3_optout3.pdf`; `main_sumstat_part3_optout4.pdf`; `main_sumstat_part3_optout5.pdf`                                                                                                                                                                                                 | `1-Summary-Statistics.do`                                                       |
| Table A2   | `ivlogit_part1_cons.tex`                                                                                                                                                                                                                                                                             | `2-Analysis.do`                                                                 |
| Table A3   | `pca_ev.tex`                                                                                                                                                                                                                                                                                         | `X_PCA.do`                                                                      |
| Figure A11 | `pca_csas_dg_ev.pdf`                                                                                                                                                                                                                                                                                 | `X_PCA.do`                                                                      |
| Table A4   | `ivlogit_happy.tex`                                                                                                                                                                                                                                                                                  | `X_IV-test-for-happiness-satisfaction.do`                                       |
| Table A5   | `ivlogit_satis.tex`                                                                                                                                                                                                                                                                                  | `X_IV-test-for-happiness-satisfaction.do`                                       |
| Table A6   | `logit_part13_all.tex`                                                                                                                                                                                                                                                                               | `X_DG-vs-OO-Weights.do`                                                         |
| Figure A12 | `binscatter_obs_pred_oo_ooweights.pdf`; `binscatter_obs_pred_oo_dgweights.pdf`                                                                                                                                                                                                                       | `6-Stability-DG-Weights.do`                                                     |
| Figure A13 | `binscatter_obs_predoo_oo_ooweights.pdf`; `binscatter_obs_predoo_oo_dgweights.pdf`                                                                                                                                                                                                                   | `6-Stability-DG-Weights.do`                                                     |
| Table A7   | `reg_happy_satis_main.tex`                                                                                                                                                                                                                                                                           | `2-Analysis.do`                                                                 |
| Table A8   | `reg_happy_satis_logit.tex`                                                                                                                                                                                                                                                                          | `2-Analysis.do`                                                                 |
| Figure A14 | `logit_mmup1_means_hs.pdf`                                                                                                                                                                                                                                                                           | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`                                |
| Figure A15 | `logit_mmup2_means_hs.pdf`                                                                                                                                                                                                                                                                           | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`                                |
| Figure A16 | `logit_mmup3_o3_means_hs.pdf`; `logit_mmup3_o4_means_hs.pdf`; `logit_mmup3_o5_means_hs.pdf`                                                                                                                                                                                                          | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`                                |
| Table A9   | `reg_ea_csa_part1.tex`                                                                                                                                                                                                                                                                               | `3-Robustness.do`                                                               |
| Table A10  | `logit_prosocial_ea_interaction.tex`                                                                                                                                                                                                                                                                 | `3-Robustness.do`                                                               |
| Table A11  | `corr_matrix_pf.tex`                                                                                                                                                                                                                                                                                 | `3-Robustness.do`                                                               |
| Table A12  | `logit_prosocial_present_col12.tex`                                                                                                                                                                                                                                                                  | `3-Robustness.do`                                                               |
| Table A13  | `ludiff_csfe.tex`                                                                                                                                                                                                                                                                                    | `X_Test-OVB.do`                                                                 |
| Table A14  | `ivlogit_part1_csfe_short.tex`                                                                                                                                                                                                                                                                       | `X_Test-OVB.do`                                                                 |
| Figure A17 | `logit_mmup1_means_fe.pdf`; `logit_chosen_mmup1_means_fe.pdf`                                                                                                                                                                                                                                        | `X_Test-OVB.do`                                                                 |
| Figure A18 | `binscatter_obs_pred_dg_dgweights_ccfirst.pdf`; `binscatter_obs_pred_dg_ccweights_dgfirst.pdf`                                                                                                                                                                                                       | `X_Order-effects.do`                                                            |
| Table A15  | `logit_vs_ev_dg_order_dgoo.tex`                                                                                                                                                                                                                                                                      | `X_Order-effects.do`                                                            |
| Figure A19 | `logit_mmup2_means_cs.pdf`; `logit_mmudiff2_part2_cs.pdf`                                                                                                                                                                                                                                            | `4-All-Welfare-Analysis-Bootstrap-CombinedHS.do`                                |

## Software and Computational Requirements

### Software requirement

Stata/MP 14.0 or 19.0 for Mac

A licensed copy of Stata is required to run the replication code. The code also uses the following user-written Stata packages:

-   `estout`
-   `coefplot`
-   `binscatter`
-   `tabout`
-   `texsave`
-   `unique`

These packages can be installed from within Stata using:

``` stata
ssc install estout
ssc install grstyle
ssc install coefplot
ssc install binscatter
ssc install tabout
ssc install texsave
ssc install unique
```

### Computational platform and hardware

The code was developed on the authors' local Mac environment. No GPU or specialized hardware is required. A standard modern laptop or desktop that can run Stata and store the intermediate bootstrap files is sufficient for replication.

### Expected runtime

A full rerun of the analysis from the master script takes approximately 3 to 4 hours, depending on machine speed. Most of this runtime comes from the bootstrap procedures in the welfare analysis and appendix scripts.

## Instructions for Data Analysis

To reproduce the analysis:

1.  Preserve the folder structure of the replication package after unzipping.
2.  Open `Analysis/Code/0-Master.do`.
3.  Edit line 14 so that `cd "..."` points to the local `Analysis` folder inside the replication package.
4.  Install the required Stata packages listed above if they are not already installed.
5.  In Stata, run `do "0-Master.do"` from within `Analysis/Code/`, or open and execute `0-Master.do` directly.
6.  The master file rebuilds the cleaned experimental datasets, runs the main paper analysis, runs the appendix analysis, runs the three supplementary survey scripts, and writes the resulting tables and figures to `Analysis/Output/`.

## Supporting Materials

### Ethics

IRB approval documentation is included in the `Docs/` folder:

-   ApprovalLetter-IRB2024-08-17741.pdf
-   ApprovalLetter-IRB2021-07-14494.pdf

These cover CPHS Protocol Numbers `2024-08-17741` and `2021-07-14494`.

### Pre-registration

The pre-registration link for the survey analysis is:

-   [OSF pre-registration](https://osf.io/cdgx7/overview?view_only=3c0649d98f6a460eb07f06905e36c98e)

### Additional supporting materials to include before submission

-   Experiment Instructions

-   Survey Instructions

## License Agreement

Copyright 2026, B. Douglas Bernheim, Kristy Kim, and Dmitry Taubinsky.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.
