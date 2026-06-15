/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

ANALYIS: USING COMBINED DATA SWEEPS 4-9

This programme uses the combined data built earlier (sweeps 4-9) to analyse the likelihood of miscarriage among women respondents of BCS70 by age left education, relative income, and occupational social status.

*/

/*
Created: 13/11/2024
Last modified: 13/02/2026
Author: Heini Väisänen
*/

// Section 1. Load combined data and housekeeping

clear all
use bcs_miscuk_alt.dta, clear // load final dataset (NB! You have to run do-files 1a-1h first)
*use bcs_miscuk.dta, clear // load final dataset (NB! You have to run do-files 1a-1h first)

* Ghange graphics settings
graph set window fontface "Times New Roman"
graph set ps fontface "Times New Roman"
set scheme plotplain
set scheme plotplainblind

// Section 2. Descriptive statistics

********************************************************************************
/* Table 1: Number and percentage of respondents reporting at least one pregnancy or miscarriage by age.
Notes: * % miscarried calculated based on reporting at least one pregnancy/miscarriage within each age group rather than the 'raw' pregnancy/miscarriage numbers. */
********************************************************************************

tab agec pregnant, matcell(P) // N of pregnancies by age group
tab agec misc_bin, matcell(M)  // N of miscarriages by age group

display M[1,2]/P[1,2]*100 // % of miscarriages out of pregnancies for age 16-25
display M[2,2]/P[2,2]*100 // % of miscarriages out of pregnancies for age 26-29
display M[3,2]/P[3,2]*100 // % of miscarriages out of pregnancies for age 30-33
display M[4,2]/P[4,2]*100 // % of miscarriages out of pregnancies for age 34-38
display M[5,2]/P[5,2]*100 // % of miscarriages out of pregnancies for age 39-41

/*Figure 2: Percentage of respondents reporting at least one miscarriage by age and socioeconomic position (occupational class, relative income and age left education).*/

/*Notes: we use 'putexcel' to create tables in Excel after which we did some rearranging by hand to produce the figures seen in the publication. These commands produce the basis for that work, but one needs to independently pick the relevant data in Excel to reproduce the figures. */

* Create Excel file for the tables
putexcel set misc_tables_figures.xlsx, sheet(Fig2) modify

* Figure 2, panel a: full sample (i.e. all women) -- columns A-E in Excel

putexcel A2 = "Age 16-25" // create relevant labels
putexcel A7 = "Age 26-29"
putexcel A12 = "Age 30-33"
putexcel A17 = "Age 34-37"
putexcel A22 = "Age 38-41"

** miscarriage percentages by age and occupational status, full sample
estpost tab ses_red misc_bin if agec==1 // FYI: ssc install estout.pkg
unstack // FYI: net install unstack, from("https://raw.githubusercontent.com/imaddowzimet/StataPrograms/master/")
putexcel B2 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==2
unstack
putexcel B7 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==3
unstack
putexcel B12 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==4
unstack
putexcel B17 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==5
unstack
putexcel B22 = matrix(row), names nformat(number_d2)

putexcel A28 = "Age 16-25" // create relevant labels
putexcel A33 = "Age 26-29"
putexcel A38 = "Age 30-33"
putexcel A43 = "Age 34-37"
putexcel A48 = "Age 38-41"

** miscarriage percentages by age and income, full sample
estpost tab relinc_red misc_bin if agec==1
unstack
putexcel B28 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==2
unstack
putexcel B33 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==3
unstack
putexcel B38 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==4
unstack
putexcel B43 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==5
unstack
putexcel B48 = matrix(row), names nformat(number_d2)

putexcel A54 = "Age 16-25" // create relevant labels
putexcel A59 = "Age 26-29"
putexcel A64 = "Age 30-33"
putexcel A69 = "Age 34-37"
putexcel A74 = "Age 38-41"

** miscarriage percentages by age and age left education, full sample
estpost tab eduage_red misc_bin if agec==1
unstack
putexcel B54 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==2
unstack
putexcel B59 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==3
unstack
putexcel B64 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==4
unstack
putexcel B69 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==5
unstack
putexcel B74 = matrix(row), names nformat(number_d2)

********************************************************************************
* Figure 2, panel b: pregnancy sample (i.e. only including pregnancy episodes) -- columns G-K in Excel
********************************************************************************
putexcel G2 = "Age 16-25" // create relevant labels
putexcel G7 = "Age 26-29"
putexcel G12 = "Age 30-33"
putexcel G17 = "Age 34-37"
putexcel G22 = "Age 38-41"

** miscarriage percentages by age and occupational status, pregnancy sample
estpost tab ses_red misc_bin if agec==1 & pregnant==1
unstack
putexcel H2 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==2 & pregnant==1
unstack
putexcel H7 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==3 & pregnant==1
unstack
putexcel H12 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==4 & pregnant==1
unstack
putexcel H17 = matrix(row), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==5 & pregnant==1
unstack
putexcel H22 = matrix(row), names nformat(number_d2)

putexcel G28 = "Age 16-25" // create relevant labels
putexcel G33 = "Age 26-29"
putexcel G38 = "Age 30-33"
putexcel G43 = "Age 34-37"
putexcel G48 = "Age 38-41"

** miscarriage percentages by age and income, pregnancy sample
estpost tab relinc_red misc_bin if agec==1 & pregnant==1
unstack
putexcel H28 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==2 & pregnant==1
unstack
putexcel H33 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==3 & pregnant==1
unstack
putexcel H38 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==4 & pregnant==1
unstack
putexcel H43 = matrix(row), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==5 & pregnant==1
unstack
putexcel H48 = matrix(row), names nformat(number_d2)

putexcel G54 = "Age 16-25" // create relevant labels
putexcel G59 = "Age 26-29"
putexcel G64 = "Age 30-33"
putexcel G69 = "Age 34-37"
putexcel G74 = "Age 38-41"

** miscarriage percentages by age and age left education, full sample
estpost tab eduage_red misc_bin if agec==1 & pregnant==1
unstack
putexcel H54 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==2 & pregnant==1
unstack
putexcel H59 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==3 & pregnant==1
unstack
putexcel H64 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==4 & pregnant==1
unstack
putexcel H69 = matrix(row), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==5 & pregnant==1
unstack
putexcel H74 = matrix(row), names nformat(number_d2)

********************************************************************************
/*Appendix I – Percentage of respondents in `full' and `pregnancy' samples reporting a miscarriage by socioeconomic variables and age, N of miscarriages and respondents*/
********************************************************************************
/*Notes: The percentages shown in Appendix I can be copied from the tables produced above for Fig 2, the code below adds the counts. as above, these commands produce the basis for that work, but one needs to independently pick the relevant data in Excel to reproduce the appendix table seen in the publication. */
*/

* Create a new Excel tab in the file created earlier for appendix table I
putexcel set misc_tables_figures.xlsx, sheet(ATable1) modify

* Appendix I two last columns: N miscarriages, N total -- columns D-E in Excel

putexcel A2 = "Age 16-25" // create relevant labels
putexcel A7 = "Age 26-29"
putexcel A12 = "Age 30-33"
putexcel A17 = "Age 34-37"
putexcel A22 = "Age 38-41"

** N miscarriage, N total by age and occupational status
estpost tab ses_red misc_bin if agec==1
unstack
putexcel B2 = matrix(count), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==2
unstack
putexcel B7 = matrix(count), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==3
unstack
putexcel B12 = matrix(count), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==4
unstack
putexcel B17 = matrix(count), names nformat(number_d2)
estpost tab ses_red misc_bin if agec==5
unstack
putexcel B22 = matrix(count), names nformat(number_d2)

putexcel A28 = "Age 16-25" // create relevant labels
putexcel A33 = "Age 26-29"
putexcel A38 = "Age 30-33"
putexcel A43 = "Age 34-37"
putexcel A48 = "Age 38-41"

** N miscarriage, N total by age and income
estpost tab relinc_red misc_bin if agec==1
unstack
putexcel B28 = matrix(count), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==2
unstack
putexcel B33 = matrix(count), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==3
unstack
putexcel B38 = matrix(count), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==4
unstack
putexcel B43 = matrix(count), names nformat(number_d2)
estpost tab relinc_red misc_bin if agec==5
unstack
putexcel B48 = matrix(count), names nformat(number_d2)

putexcel A54 = "Age 16-25" // create relevant labels
putexcel A59 = "Age 26-29"
putexcel A64 = "Age 30-33"
putexcel A69 = "Age 34-37"
putexcel A74 = "Age 38-41"

** N miscarriage, N total by age and age left education
estpost tab eduage_red misc_bin if agec==1
unstack
putexcel B54 = matrix(count), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==2
unstack
putexcel B59 = matrix(count), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==3
unstack
putexcel B64 = matrix(count), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==4
unstack
putexcel B69 = matrix(count), names nformat(number_d2)
estpost tab eduage_red misc_bin if agec==5
unstack
putexcel B74 = matrix(count), names nformat(number_d2)

// Section 3 Regression models
** notes: the code below creates Figures 3 and 4, and the associated Appendix tables I and II

********************************************************************************
/*Figure 3: Predicted probabilities of reporting at least one miscarriage by age and (a) occupational status, (b) relative income, (c) age left education; full sample.*/
/*Notes: controlling for partnership and smoking. [because our preliminary analyses showed long-term illness as not significant]
The code also produces the tables for appendix II columns 'full sample'*/
********************************************************************************
********************************************************************************
/*Appendix II – Adjusted odds ratios of reporting at least one miscarriage by age and (a)
occupational status, (b) relative income, (c) age left education for full and pregnancy
samples*/
********************************************************************************
* Houskeeping: declare as panel data, need to generate ID variable that is not a string
encode bcsid, gen(id)
xtset id

* Figure 3, panel a occupational status, full sample
xtlogit misc_bin parity i.partner i.smoking i.agec##b2.ses_red, or base 
estimates store model_all_ses_red
margins agec#ses_red
marginsplot, x(agec) name(ses_red_allwomen, replace) title("3a. Occupational status, full sample") ytitle("Probability of miscarriage")

* Figure 3, panel b income, full sample
xtlogit misc_bin parity i.partner i.smoking i.agec##b2.relinc_red, or base 
estimates store model_all_relinc_red
margins agec#relinc_red
marginsplot, x(agec) name(relinc_red_allwomen, replace) title("3b. Relative income, full sample") ytitle("Probability of miscarriage")

* Figure 3, panel c age left education, full sample
xtlogit misc_bin parity i.partner i.smoking i.agec##b2.eduage_red, or base 
estimates store model_all_eduage_red
margins agec#eduage_red
marginsplot, x(agec) name(eduage_red_allwomen, replace) title("3c. Education, full sample") ytitle("Probability of miscarriage")

** Combine graphs 3a, 3b and 3c into one figure and export as TIFF
graph combine ses_red_allwomen relinc_red_allwomen eduage_red_allwomen, xcommon ycommon iscale(0.8) rows(3) cols(1) ysize(6) xsize(3) name(full, replace)

graph export fig3fullsample.tif, as(tif) width(2232) height(3157) name("full") replace

********************************************************************************
/* Figure 4: Predicted probabilities of reporting at least one miscarriage by age and (a) occupational status, (b) relative income, (c) age left education; pregnancy sample.*/
/*Notes: controlling for partnership and smoking. [because our preliminary analyses showed long-term illness as not significant]
The code also produces the tables for appendix II columns 'pregnancy sample'*/
********************************************************************************
********************************************************************************
/*Appendix II – Adjusted odds ratios of reporting at least one miscarriage by age and (a)
occupational status, (b) relative income, (c) age left education for full and pregnancy
samples*/
********************************************************************************
* Figure 4, panel a occupational status, pregnancy sample
xtlogit misc_bin parity i.partner i.smoking i.agec##b2.ses_red if pregnant==1, or base
estimates store model_pregs_ses_red
margins agec#ses_red
marginsplot, x(agec) name(ses_red_pregspells, replace) title("4a. Occupational status, pregnancy sample") ytitle("Probability of miscarriage")

* Figure 4, panel a income, pregnancy sample
xtlogit misc_bin parity i.partner i.smoking i.agec##b2.relinc_red if pregnant==1, or base
estimates store model_pregs_relinc_red
margins agec#relinc_red
marginsplot, x(agec) name(relinc_red_pregspells, replace) title("4b. Relative income, pregnancy sample") ytitle("Probability of miscarriage")

* Figure 4, panel c age left education, pregnancy sample
xtlogit misc_bin parity i.partner i.smoking i.agec##b2.eduage_red if pregnant==1, or base
estimates store model_pregs_eduage_red
margins agec#eduage_red
marginsplot, x(agec) name(eduage_red_pregspells, replace) title("4c. Education, pregnancy sample") ytitle("Probability of miscarriage")

** Combine graphs 3a, 3b and 3c into one figure and export as TIFF
graph combine ses_red_pregspells relinc_red_pregspells eduage_red_pregspells, xcommon ycommon iscale(0.8) rows(3) cols(1) ysize(6) xsize(3) name(preg, replace)

graph export fig4pregsample.tif, as(tif) width(2232) height(3157) name("preg") replace
