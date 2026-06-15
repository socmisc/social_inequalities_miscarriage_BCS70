/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION SWEEP 6

This programme uses datafiles from sweep 6 to extract and edit relevant variables and combine them to the combined dataset bcs_miscuk.dta

*/

/*
Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen
*/

// Section 1. Load sweep 6 data, select and recode relevant variables

use bcs2000.dta, clear

drop sex
rename dmsex sex  // harmonise variable name
keep if sex==2  // keep women only

** variables to keep (id, SES, education, income, relationships, smoking, pregnancies, health)

keep bcsid sex intdate dmsppart ethnic age ms more2* lsiimwk* lsiage* lsiany2 lsiage1*  lsilimw* lsilim1* everpreg pregnum cgprega* prega* prege* preged* pregem* pregey* nump  strtjob econact othacted cstrtjob cnetpay cnetprd cgropay cgroprd hlthgen hlthyr smoking exsmoker agequit iempstat* empstat* sc* agelfte2 actagel2

** reciode smoking variable into binary

rename smoking smoker
gen smoking = 0 if smoker <4
replace smoking = 1 if smoker==4
*la de smoking 0 "Not smoking" 1 "Smoking every day"
la val smoking smoking
la var smoking "Smoking every day"

** edit variable names so that they include s6 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)

rename * s6_*
rename s6_bcsid bcsid
rename s6_sex sex

gen sweep=6 // generate variable indicating which sweep these data were extracted
gen age=30 // generate variable indicating respondent age at data collection

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome

save bcs_miscuk.dta, replace

// Section 2. Load derived variables dataset for sweep 6, select and recode relevant variables

use bcs6derived.dta, clear

** clean variable names
rename	BCSID	bcsid
rename	BD6CNTRY	bd6cntry
rename	BD6REGN	bd6regn
rename	BD6GOR	bd6gor
rename	BD6MAL	bd6mal
rename	BD6MALG	bd6malg
rename	HIACA00	hiaca00
rename	NVQACA00	nvqaca00
rename	HIVOC00	hivoc00
rename	HINVQ00	hinvq00

** keep relevant variables only (country, region, governement office region, highest education level)
keep bcsid bd6cntry bd6regn bd6gor hinvq00

rename bd6cntry bdcntry
rename bd6regn bdregn
rename bd6gor bdgor
rename hinvq00 hiaca

gen sweep=6 // generate variable indicating which sweep these data were extracted
gen age=30 // generate variable indicating respondent age at data collection

sort bcsid sweep

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome

save bcs_miscuk.dta, replace