/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION SWEEP 8

This programme uses datafiles from sweep 8 to extract and edit relevant variables and combine them to the combined dataset bcs_miscuk.dta

*/

/*
Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen
*/

// Section 1. Load sweep 8 data, select and recode relevant variables
use bcs_2008_followup.dta, clear

rename bd8sex sex // harmonise variable name
keep if sex==2 // keep women only

** variables to keep (id, SES, education, income, relationships, smoking, pregnancies, health)

keep bcsid sex b8ms b8cohab b8everpg b8pgmany b8pregn1 b8preg* b8prgm* b8prgy* b8es2001 b8iamtc b8sc* b8EndY* b8EndM* b8Econ02 b8cnetpy b8cnetpd b8cnetwk b8cgropy b8cgropd b8cgrowk b8agele2 b8actal2 b8furtd2 b8lftme2 b8khldl2 b8khllt b8smokig b8nfcigs bd8spphh bd8ms b8cohab b8lsiotr

** reciode smoking variable into binary

gen smoking = 0 if b8smokig > 0 & b8smokig <3
replace smoking = 1 if b8smokig == 4
*la de smoking 0 "Not smoking" 1 "Smoking every day"
la val smoking smoking
la var smoking "Smoking every day"

** edit variable names so that they include s8 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)

rename * s8_*
rename s8_bcsid bcsid
rename s8_sex sex

gen sweep=8 // generate variable indicating which sweep these data were extracted
gen age=38 // generate variable indicating respondent age at data collection

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome

save bcs_miscuk.dta, replace

// Section 2. Load derived variables dataset for sweep 8, select and recode relevant variables

use bcs8derived.dta, clear

** clean variable names
rename	BCSID	bcsid
rename	BD8CNTRY	bd8cntry
rename	BD8REGN	bd8regn
rename	BD8GOR	bd8gor
rename	BD8MALIVE	bd8malive
rename	BD8PALIVE	bd8palive
rename	BD8NUMRM	bd8numrm
rename	BD8ECACT	bd8ecact
rename	BD8POTHA	bd8potha
rename	BD8STBE	bd8stbe
rename	BD8SMOKE	bd8smoke
rename	BD8ACHQ1	bd8achq1
rename	BD8ANVQ1	bd8anvq1
rename	BD8VNVQ1	bd8vnvq1
rename	BD8NVQ1	bd8nvq1
rename	BD8HACHQ	bd8hachq
rename	BD8HANVQ	bd8hanvq
rename	BD8HVNVQ	bd8hvnvq
rename	BD8HNVQ	bd8hnvq

** keep relevant variables only (country, region, governement office region, highest education level)
keep bcsid bd8cntry bd8regn bd8gor bd8hnvq 

** harmonise variable names
rename bd8cntry bdcntry
rename bd8regn bdregn
rename bd8gor bdgor
rename bd8hnvq hiaca

gen sweep=8 // generate variable indicating which sweep these data were extracted
gen age=38 // generate variable indicating respondent age at data coll

sort bcsid sweep

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome hiaca

save bcs_miscuk.dta, replace

