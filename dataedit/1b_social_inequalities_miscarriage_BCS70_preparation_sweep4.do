/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION SWEEP 4

This programme uses datafiles from sweep 4 to extract and edit relevant variables and combine them to the combined dataset bcs_miscuk.dta

*/

/*
Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen
*/

// Section 1. Load sweep 4 data, select and recode relevant variables

use bcs7016x.dta, clear

** variable codings

la de sex 1 man 2 woman
la val sex sex
keep if sex==2

** variables to keep (id, SES, education, relationships, smoking)

keep bcsid sex86 dob86 t11_2 t11_9 jb33 pb4_4 t1a_1 t1a_4a ///
t1a_4b t7_1 t7_2 l2_1 pb3_1 q12_1 q12_2 q22_8 ha7 ha7_1 t7_1 t7_2 f46a rb2 gh11

** reciode smoking variable into binary

gen smoking = 0 if gh11>0 & gh11<.
replace smoking = 1 if gh11>0 & gh11<6
la de smoking 0 "Not smoking" 1 "Smoked past year"
la val smoking smoking
la var smoking "Smoked past year"

** edit variable names so that they include s4 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)

rename * s4_* // rename all vars so that they start with s4_
rename s4_sex86 sex // take out s4_ from time invariant variables
rename s4_dob86 dob // take out s4_ from time invariant variables
rename s4_bcsid bcsid // take out s4_ from time invariant variables

** merge sweep 4 to combined file bcs_miscuk.dta + some housekeeping

gen sweep=4 // generate variable indicating which sweep these data were extracted
gen age=16 // generate variable indicating respondent age at data collection

sort bcsid sweep

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge

order bcsid sweep
sort bcsid sweep

save bcs_miscuk.dta, replace

// Section 2. Load derived variables dataset for sweep 4, select and recode relevant variables

use bcs4derived.dta, clear

** clean variable names
rename	BCSID	bcsid
rename	BD4CNTRY	bd4cntry
rename	BD4REGN	bd4regn
rename	BD4GOR	bd4gor
rename	BD4PSOC	bd4psoc
rename	BD4AGE	bd4age
rename	BD4RREAD	bd4rread
rename	BD4READ	bd4read
rename	BD4RDAGE	bd4rdage
rename	BD4MMAL	bd4mmal
rename	BD4MMALA	bd4mmala
rename	BD4MMALB	bd4mmalb
rename	BD4MAL	bd4mal
rename	BD4MALG	bd4malg
rename	BD4IN	bd4in
rename	BD4RUTT	bd4rutt
rename	BD4MRUTG	bd4mrutg
rename	BD4STYPE	bd4stype

** keep relevant variables only (country, region, governement office region, social class)
keep bcsid bd4cntry bd4regn bd4gor bd4psoc

** edit variable names so that they include s4 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)

rename bd4cntry bdcntry
rename bd4regn bdregn
rename bd4gor bdgor

rename bd4psoc s4_bd4psoc

gen sweep=4 // generate variable indicating which sweep these data were extracted
gen age=16 // generate variable indicating respondent age at data collection

sort bcsid sweep

** merge to combined data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob multipno twincode outcome

save bcs_miscuk.dta, replace

// Section 3. Add education, income, tenure dataset for sweep 4, select and recode relevant variables

use bcs7016x.dta, clear

** keep relevant variables only (parents' income and education)
keep bcsid t7* oe2

** edit variable names so that they include s4 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)
rename t7* s4_t7*
rename oe2 s4_oe2

gen sweep=4 // generate variable indicating which sweep these data were extracted
gen age=16 // generate variable indicating respondent age at data collection

sort bcsid sweep

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob multipno twincode outcome

save bcs_miscuk.dta, replace