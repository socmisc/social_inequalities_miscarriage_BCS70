/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION SWEEP 7

This programme uses datafiles from sweep 7 to extract and edit relevant variables and combine them to the combined dataset bcs_miscuk.dta

*/

/*
Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen
*/

// Section 1. Load sweep 7 data, select and recode relevant variables

use bcs_2004_followup.dta, clear

rename bd7sex sex // harmonise variable names
keep if sex==2 // keep women only

** variables to keep (id, SES, education, income, relationships, smoking, pregnancies, health)

keep bcsid sex b7rage11 b7intmon b7intyr b7intwho bd7ms bd7spphh b7everpg b7pregn* bd7smk* bd7smk* bd7smk* b7preg* b7prgm* b7prgy* b7sc* b7cnetpy b7cnetpd b7cgropy b7cgropd b7agele* b7actal* b7lftme* b7es2001 b7lsiany b7lsge b7lsge2 b7lsge3 b7more11 b7more13 b7more12 b7lsge4 b7more14 b7lsge5 b7more15 b7lsge6 b7more16 b7lsge7 b7more17 b7smokig b7nfcigs b7exsmer b7agequt
drop b7schoos 

** reciode smoking variable into binary

gen smoking = 0 if b7smokig > 0 & b7smokig <3
replace smoking = 1 if b7smokig == 4
*la de smoking 0 "Not smoking" 1 "Smoking every day"
la val smoking smoking
la var smoking "Smoking every day"

** edit variable names so that they include s6 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)

rename * s7_*
rename s7_bcsid bcsid
rename s7_sex sex

* drop irrelevant variables

drop s7_b7pregox s7_b7sc12 s7_b7ageled s7_b7lftmed

gen sweep=7 // generate variable indicating which sweep these data were extracted
gen age=34 // generate variable indicating respondent age at data collection

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome

save bcs_miscuk.dta, replace

// Section 2. Load derived variables dataset for sweep 7, select and recode relevant variables

** clean variable names
use bcs7derived.dta, clear

rename	BCSID	bcsid
rename	BD7CNTRY	bd7cntry
rename	BD7REGN	bd7regn
rename	BD7GOR	bd7gor
rename	BD7MAL	bd7mal
rename	BD7MALG	bd7malg
rename	BD7ACHQ1	bd7achq1
rename	BD7ANVQ1	bd7anvq1
rename	BD7VNVQ1	bd7vnvq1
rename	BD7NVQ1	bd7nvq1
rename	BD7HACHQ	bd7hachq
rename	BD7HANVQ	bd7hanvq
rename	BD7HVNVQ	bd7hvnvq
rename	BD7HNVQ	bd7hnvq

** keep relevant variables only (country, region, governement office region, highest education level)
keep bcsid bd7cntry bd7regn bd7gor bd7hnvq 

rename bd7cntry bdcntry
rename bd7regn bdregn
rename bd7gor bdgor
rename bd7hnvq hiaca

gen sweep=7 // generate variable indicating which sweep these data were extracted
gen age=34 // generate variable indicating respondent age at data collection

sort bcsid sweep

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome hiaca

save bcs_miscuk.dta, replace