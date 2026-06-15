/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION SWEEP 5

This programme uses datafiles from sweep 5 to extract and edit relevant variables and combine them to the combined dataset bcs_miscuk.dta

*/

/*
Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen
*/

// Section 1. Load sweep 5 data, select and recode relevant variables

use bcs96x.dta, clear

keep if sex==2 // keep women only

** variables to keep (id, SES, education, income, relationships, smoking, kids)

keep bcsid sex b960319 b960321 b960338 b960566 b960632 rgsc91 school26 hqual26 lefted26 leftedg empstat wklypayc numkids b960265 b960266

** reciode smoking variable into binary

gen smoking = 0 if b960632>0 & b960632<.
replace smoking =1 if b960632==4
la de smoking 0 "Not smoking" 1 "Smoking every day"
la val smoking smoking
la var smoking "Smoking every day"

** edit variable names so that they include s5 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)

rename * s5_*

rename s5_bcsid bcsid
rename s5_sex sex

gen sweep=5 // generate variable indicating which sweep these data were extracted
gen age=26 // generate variable indicating respondent age at data collection

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome

save bcs_miscuk.dta, replace

// Section 2. Load derived variables dataset for sweep 5, select and recode relevant variables

use bcs5derived.dta, clear

** clean variable names
rename	BCSID	bcsid
rename	BD5CNTRY	bd5cntry
rename	BD5REGN	bd5regn
rename	BD5GOR	bd5gor
rename	BD5MAL	bd5mal
rename	BD5MALG	bd5malg

** keep relevant variables only (country, region, governement office region)
keep bcsid bd5cntry bd5regn bd5gor

rename bd5cntry bdcntry
rename bd5regn bdregn
rename bd5gor bdgor

gen sweep=5 // generate variable indicating which sweep these data were extracted
gen age=26 // generate variable indicating respondent age at data collection

sort bcsid sweep

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome

save bcs_miscuk.dta, replace
