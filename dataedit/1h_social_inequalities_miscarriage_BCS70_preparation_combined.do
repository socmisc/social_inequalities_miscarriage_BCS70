/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION: COMBINED DATA SWEEPS 4-9

This programme uses datafiles from sweeps 4-9 to modify data structure, create a pregnancy history variables, impute missing values for sweep 7 miscarriage/abortion dates, and edit+keep relevant variables in the combined dataset bcs_miscuk_alt.dta

*/

/*
Created: 13/11/2024
Last modified: 11/02/2026
Author: Heini Väisänen
*/

// Section 1. Load combined data, create correct data structure

use bcs_miscuk.dta, clear 

** Generate the longitudinal data structure

* create variable for calendar years
gen year=1986 if sweep==4
replace year=1996 if sweep==5
replace year=2000 if sweep==6
replace year=2004 if sweep==7
replace year=2008 if sweep==8
replace year=2012 if sweep==9
replace year=2016 if sweep==10

* generate data structure with one line for each calendar year
expand 10 if sweep==4
expand 4 if sweep==5
expand 4 if sweep==6
expand 4 if sweep==7
expand 4 if sweep==8
expand 4 if sweep==9

* edit age variable so that it increases by 1 each year
sort bcsid sweep age
replace age=age[_n-1]+1 if sweep==sweep[_n-1] & bcsid==bcsid[_n-1]
replace year=year[_n-1]+1 if sweep==sweep[_n-1] & bcsid==bcsid[_n-1]

// Section 2. Generate fertility history including the most common pregnancy outcomes: miscarriages, abortions and live births. This is done by sweep, as there are inconsistencies in how variables are named and coded.

*****************************************************************************
** Start from the oldest sweep including a pregnancy history module: sweep 6
*****************************************************************************

* data cleaning
drop s6_prega4 s6_prega5 s6_prega8 // these pregnany variables contain only missing values --> drop

recode s6_pregey* (9999=.) (9998=.) // harmonise coding for missing data for pregnancy year
recode s6_pregem* (99=.) (98=.) // harmonise coding for missing data for pregnancy month

rename s6_prega s6_prega1 // harmonise variable naming for different pregnancy variables
rename s6_pregey s6_pregey1 // harmonise variable naming for different pregnancy variables
rename s6_pregem s6_pregem1 // harmonise variable naming for different pregnancy variables


foreach i in 1 2 3 6 7 11 12 16 17 21 22 23 26 27 31 36 {
replace s6_pregem`i' = 99 if s6_pregey`i'<. & s6_pregem`i'==.
} // pregnancy month is missing more often than year, and since we will ultimately only use information on prgnancy year, replace month with 99 if year is not missing but month is to avoid dropping observations

gsort bcsid -year // copy pregnancy outcome, month and year to all rows preceding survey year
foreach i in 1 2 3 6 7 11 12 16 17 21 22 23 26 27 31 36 {
replace s6_prega`i'=s6_prega`i'[_n-1] if bcsid==bcsid[_n-1] & s6_prega`i'[_n-1]<.
replace s6_pregey`i'=s6_pregey`i'[_n-1] if bcsid==bcsid[_n-1] & s6_pregey`i'[_n-1]<.
replace s6_pregem`i'=s6_pregem`i'[_n-1] if bcsid==bcsid[_n-1] & s6_pregem`i'[_n-1]<.
}

sort bcsid year // go back to chronological order

foreach i in 1 2 3 6 7 11 12 16 17 21 22 23 26 27 31 36 {
replace s6_prega`i'=. if s6_pregey`i'!=year		// include pregnancy outcome only for the relevant year
replace s6_pregey`i'=. if s6_pregey`i'!=year	// include pregnancy year only for the relevant year
replace s6_pregem`i'=. if s6_pregey`i'!=year	// include pregnancy month only for the relevant year
}

* generate miscarriage history: create variable showing number of miscarriages per year (but not counting multiple foetuses per pregnancy)

gen misc_count_yr = 0 // outcome 3 = miscarriage in s6_prega*, select only variables that have non-missing information for that year in the loop below; the loops further down add information for later pregnancies until no new information available
foreach i in 1 2 3 6 7 11 12 16 17 21 22 23 26 27 31 36 {
replace misc_count_yr = misc_count_yr + 1 if s6_prega`i' == 3
} 

foreach i in 2 3 6 7 11 12 16 17 21 22 23 26 27 31 36 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s6_pregem1==s6_pregem`i' & s6_prega1==3
}

foreach i in 7 11 12 16 17 21 22 23 26 27 31 36 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s6_pregem6==s6_pregem`i' & s6_prega6==3
}

foreach i in 12 16 17 21 22 23 26 27 31 36 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s6_pregem11==s6_pregem`i' & s6_prega11==3
}

foreach i in 17 21 22 23 26 27 31 36 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s6_pregem16==s6_pregem`i' & s6_prega16==3
}

foreach i in 22 23 26 27 31 36 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s6_pregem21==s6_pregem`i' & s6_prega21==3
}

foreach i in 27 31 36 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s6_pregem26==s6_pregem`i' & s6_prega26==3
}

* generate abortion history: create variable showing number of abortions per year (but not counting multiple foetuses per pregnancy)

gen abort_count_yr = 0 // outcome 4 = abortion in s6_prega*, select only variables that have non-missing information for that year in the loop below
foreach i in 1 6 11 16 36 {
replace abort_count_yr = abort_count_yr + 1 if s6_prega`i' == 4	
}

* generate live birth history: create variable showing number of live birth per year (including counting multiple foetuses per pregnancy)

gen birth_count_yr = 0 // outcome 1 = live birth in s6_prega*, select only variables that have non-missing information for that year in the loop below
foreach i in 1 2 3 6 7 11 12 16 17 21 22 23 26 27 31 36 {
replace birth_count_yr = birth_count_yr + 1 if s6_prega`i' == 1
} 

save bcs_miscuk.dta, replace // save to avoid losing changes

*****************************************************************************
**** NB! sweep 7 will be coded last, as miscarriage dates not recorded correctly in raw data and need to be imputed using information from other sweeps ****
*****************************************************************************
** Generate pregnancy history for sweep 8
*****************************************************************************

* data cleaning
recode s8_b8prgy* (-9=.) (-8=.) (-1=.) // harmonise coding for missing data
recode s8_b8prgm* (-9=.) (-8=.) (-1=.) // harmonise coding for missing data
recode s8_b8preg* (-9=.) (-8=.) (-7=.) (-1=.) // harmonise coding for missing data
 
drop s8_b8preg62 s8_b8prgm62 s8_b8prgy62 // these pregnany variables contain only missing values --> drop

foreach i in 11 12 13 21 22 31 32 41 42 43 44 51 61 71 81 {
replace s8_b8prgm`i' = 99 if s8_b8prgy`i'<. & s8_b8prgm`i'==.
} // pregnancy month is missing more often than year, and since we will ultimately only use information on prgnancy year, replace month with 99 if year is not missing but month is to avoid dropping observations

gsort bcsid -year // copy pregnancy outcome, month and year to all rows preceding survey year

foreach i in 11 12 13 21 22 31 32 41 42 43 44 51 61 71 81 {
replace s8_b8preg`i'=s8_b8preg`i'[_n-1] if bcsid==bcsid[_n-1] & s8_b8preg`i'[_n-1]<.
replace s8_b8prgy`i'=s8_b8prgy`i'[_n-1] if bcsid==bcsid[_n-1] & s8_b8prgy`i'[_n-1]<.
replace s8_b8prgm`i'=s8_b8prgm`i'[_n-1] if bcsid==bcsid[_n-1] & s8_b8prgm`i'[_n-1]<.
}

sort bcsid year // go back to chronological order

foreach i in 11 12 13 21 22 31 32 41 42 43 44 51 61 71 81 {
replace s8_b8preg`i'=. if s8_b8prgy`i'!=year	// include pregnancy outcome only for the relevant year
replace s8_b8prgy`i'=. if s8_b8prgy`i'!=year	// include pregnancy year only for the relevant year
replace s8_b8prgm`i'=. if s8_b8prgy`i'!=year	// include pregnancy month only for the relevant year
}

* generate miscarriage history: create variable showing number of miscarriages per year (but not counting multiple foetuses per pregnancy)

foreach i in 11 12 13 21 22 31 32 41 42 43 44 51 61 71 81  {
replace misc_count_yr = misc_count_yr + 1 if s8_b8preg`i' == 3
}  // outcome 3 = miscarriage, select only variables that have non-missing information for that year in the loop below; the loops further down add information for later pregnancies until no new information available

foreach i in 12 13 21 22 31 32 41 42 43 44 51 61 71 81 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s8_b8prgm11==s8_b8prgm`i' & s8_b8preg11==3
}

foreach i in 22 31 32 41 42 43 44 51 61 71 81 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s8_b8prgm21==s8_b8prgm`i' & s8_b8preg21==3
}

foreach i in 32 41 42 43 44 51 61 71 81 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s8_b8prgm31==s8_b8prgm`i' & s8_b8preg31==3
}

foreach i in 42 43 44 51 61 71 81 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s8_b8prgm41==s8_b8prgm`i' & s8_b8preg41==3
}

* generate abortion history: create variable showing number of abortions per year (but not counting multiple foetuses per pregnancy)

foreach i in 11 21 41 {
replace abort_count_yr = abort_count_yr + 1 if s8_b8preg`i' == 4	
} // outcome 4 = abortion, select only variables that have non-missing information for that year

* generate live birth history: create variable showing number of live birth per year (including counting multiple foetuses per pregnancy)

foreach i in 11 12 13 21 22 31 32 41 42 43 44 51 61 71 81 {
replace birth_count_yr = birth_count_yr + 1 if s8_b8preg`i' == 1
}  // outcome 1 = live birth, select only variables that have non-missing information for that year

save bcs_miscuk.dta, replace // save to avoid losing changes

*****************************************************************************
** Generate pregnancy history for sweep 9 
*****************************************************************************

** NB - since no live birth history in main questionnaire file, person grid was used to find out new birth years and months. We add these data first before adding other pregnancies (i.e. order differs from other sweeps)

* data cleaning

order bcsid sweep age year sex bdcntry bdregn bdgor cob-twincode outcome s4_* s5_* s6_* s7_* s8_* s9_* // order variables

drop s9_byr_grid7 s9_byr_grid8 s9_byr_grid9 s9_bmo_grid7 s9_bmo_grid8 s9_bmo_grid9 // contain only missing vals

* add live births from person grid

forvalues i=1/6 {
replace s9_bmo_grid`i' = 99 if s9_byr_grid`i'<. & s9_byr_grid`i'==.
} // pregnancy month is missing more often than year, and since we will ultimately only use information on prgnancy year, replace month with 99 if year is not missing but month is to avoid dropping observations

gsort bcsid -year // copy pregnancy month and year to all rows prceding survey year

forvalues i=1/6 {
replace s9_byr_grid`i'=s9_byr_grid`i'[_n-1] if bcsid==bcsid[_n-1] & s9_byr_grid`i'[_n-1]<.
replace s9_bmo_grid`i'=s9_bmo_grid`i'[_n-1] if bcsid==bcsid[_n-1] & s9_bmo_grid`i'[_n-1]<.
}

sort bcsid year // go back to chronological order

forvalues i=1/6 {
replace s9_byr_grid`i'=. if s9_byr_grid`i'!=year	// pregnancy year only for the relevant year
replace s9_bmo_grid`i'=. if s9_byr_grid`i'!=year	// pregnancy month only for the relevant year
}

* generate live birth history: variable showing number of births per year (including multiple foetuses per preg)

gen bcount9=0 // variable using sweep 9 data only
forvalues i=1/6 {
replace bcount9 = bcount9 + 1 if s9_byr_grid`i' <.
} 

replace birth_count_yr = bcount9 if birth_count_yr==0 & bcount9>0 // update birthcount where information was not captured by previous waves

drop bcount9 // this variable is no longer needed

save bcs_miscuk.dta, replace // save to avoid losing changes

** Create pregnancy history for other pregnancies: add "unsuccesful pregnancy module"

use bcs70_2012_unsucessful_pregnancies.dta, clear

* data cleaning
rename	BCSID	bcsid
rename	B9SBID	b9sbid
rename	B9SBNUM	b9sbnum
rename	B9SBLB	b9sblb
rename	B9SBLBN	b9sblbn
rename	B9SBLBY1	b9sblby1
rename	B9SBLBM1	b9sblbm1
rename	B9SBLBY2	b9sblby2
rename	B9SBLBM2	b9sblbm2
rename	B9SBLBY3	b9sblby3
rename	B9SBLBM3	b9sblbm3
rename	B9SBLBY4	b9sblby4
rename	B9SBLBM4	b9sblbm4
rename	B9SBLBY5	b9sblby5
rename	B9SBLBM5	b9sblbm5
rename	B9SBA1	b9sba1
rename	B9SBEMY1	b9sbemy1
rename	B9SBEMM1	b9sbemm1
rename	B9SBA2	b9sba2
rename	B9SBEMY2	b9sbemy2
rename	B9SBEMM2	b9sbemm2
rename	B9SBA3	b9sba3
rename	B9SBEMY3	b9sbemy3
rename	B9SBEMM3	b9sbemm3
rename	B9SBA4	b9sba4
rename	B9SBEMY4	b9sbemy4
rename	B9SBEMM4	b9sbemm4
rename	B9SBA5	b9sba5
rename	B9SBEMY5	b9sbemy5
rename	B9SBEMM5	b9sbemm5
rename	B9SBA6	b9sba6
rename	B9SBEMY6	b9sbemy6
rename	B9SBEMM6	b9sbemm6

gen sweep=9 // variable showing which sweep we are using

sort bcsid b9sbid // sort by id and pregnancy record number

recode b9sbid-b9sbemm6 (-1=.) (-8=.) (-7=.) (-9=.) // harmonise coding of missing variables

sort bcsid b9sbid  // sort by id and pregnancy record number
bysort bcsid: gen total = _N // total number of pregnancies recorded for each id

gen id = _n // generate count within individual to help sorting data
order bcsid id // order variables

* some pregnancies have coding mistakes --> clean these data
reshape long b9sba b9sbemy b9sbemm b9sblby b9sblbm, i(id) j(preg) // generate long data structure
la var b9sba "Unsuccesful pregancy outcome"
la var b9sbemy "Unsuccesful pregancy year"
la var b9sbemm "Unsuccesful pregancy month"
la var b9sblby "Birth year"
la var b9sblbm "Birth month"

order bcsid id preg b9sbid b9sbnum b9sblb b9sblbn b9sblby b9sblbm b9sba b9sbemy b9sbemm total sweep // sort variables

drop if b9sba==. // drop rows with no pregnancy outcome
drop id preg b9sbid total // info in these variables no longer relevant --> drop
sort bcsid b9sbemy b9sbemm // sort data by pregnancy
bysort bcsid: gen pregnum=_n // generate pregnancy count

order bcsid pregnum b9sbnum b9sblb b9sblbn b9sblby b9sblbm b9sba b9sbemy b9sbemm sweep  // sort variables

gen year = b9sbemy // harmonise variable names

drop b9sblb b9sblbn b9sblby b9sblbm // only 7 cases with births with years --> dropped (births are only included in this module, if there was another foetus, which did not make it + births inferred from person grid)

order bcsid pregnum sweep year b9sbnum b9sba b9sbemy b9sbemm   // sort variables

drop if b9sbemy ==. // drop if year of pregnancy not known

sort bcsid pregnum // sort data by pregnancy count
replace b9sbemy=. if b9sbemy==b9sbemy[_n-1] & bcsid==bcsid[_n-1] // pregnancy year only for relevant year

drop b9sbnum year // drop number of children carrying and year, as no longer needed

replace b9sbemm = 99 if b9sbemy<. & b9sbemm==. // pregnancy month is missing more often than year, and since we will ultimately only use information on prgnancy year, replace month with 99 if year is not missing but month is to avoid dropping observations

rename b9sba s9_b9sba // harmonise variable names
rename b9sbemy s9_b9sbemy // harmonise variable names
rename b9sbemm s9_b9sbemm // harmonise variable names

reshape wide s9_b9sba s9_b9sbemy s9_b9sbemm, i(bcsid) j(pregnum) // go back to wide data structure

gen age=42 // generate age variable for these data

merge 1:1 bcsid age using bcs_miscuk_alt.dta // merge with main combined datafile
drop if _merge==1
drop _merge
sort bcsid age

order bcsid sweep age year sex bdcntry bdregn bdgor cob-twincode outcome s4_* s5_* s6_* s7_* s8_* s9_* // order variables

gsort bcsid -year // copy pregnancy outcome and year to all rows prceding svy year

forvalues i=1/9 {
replace s9_b9sba`i'=s9_b9sba`i'[_n-1] if bcsid==bcsid[_n-1] & s9_b9sba`i'[_n-1]<.
replace s9_b9sbemy`i'=s9_b9sbemy`i'[_n-1] if bcsid==bcsid[_n-1] & s9_b9sbemy`i'[_n-1]<.
replace s9_b9sbemm`i'=s9_b9sbemm`i'[_n-1] if bcsid==bcsid[_n-1] & s9_b9sbemm`i'[_n-1]<.
}

sort bcsid year // go back to chronological order

forvalues i=1/9 {
replace s9_b9sba`i'=. if s9_b9sbemy`i'!=year		// pregnancy outcome only for the relevant year
replace s9_b9sbemy`i'=. if s9_b9sbemy`i'!=year	// pregnancy year only for the relevant year
replace s9_b9sbemm`i'=. if s9_b9sbemy`i'!=year	// pregnancy month only for the relevant year
}

* generate miscarriage history: create variable showing number of miscarriages per year (but not counting multiple foetuses per pregnancy)

forvalues i=1/9 {
replace misc_count_yr = misc_count_yr + 1 if s9_b9sba`i' == 2
} // outcome 2 = miscarriage; the loops further down add information for later pregnancies until no new information available

forvalues i=2/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm1==s9_b9sbemm`i' & s9_b9sba1==2
}

forvalues i=3/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm2==s9_b9sbemm`i' & s9_b9sba2==2
}

forvalues i=4/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm3==s9_b9sbemm`i' & s9_b9sba3==2
}

forvalues i=5/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm4==s9_b9sbemm`i' & s9_b9sba4==2
}

forvalues i=6/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm5==s9_b9sbemm`i' & s9_b9sba5==2
}

forvalues i=7/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm6==s9_b9sbemm`i' & s9_b9sba6==2
}

forvalues i=8/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm7==s9_b9sbemm`i' & s9_b9sba7==2
}

forvalues i=9/9 {
replace misc_count_yr = misc_count_yr - 1 if misc_count_yr>1 & s9_b9sbemm8==s9_b9sbemm`i' & s9_b9sba8==2
}

* generate abortion history: create variable showing number of abortions per year (but not counting multiple foetuses per pregnancy)

foreach i in 1 2 3 4 {
replace abort_count_yr = abort_count_yr + 1 if s9_b9sba`i' == 3	
} // outcome 3 = abortion

save bcs_miscuk.dta, replace // save to avoid losing changes

*****************************************************************************
** Generate pregnancy history for sweep 7
*****************************************************************************

*** Impute missing miscarriage years ***

/* NB! There was a routing error in the survey tool meaning that most miscarriage months/years were not collected.
 We imputed the missing years by using information from preceding and later pregnancies from this and other sweeps and random integrer generation within a plausible range. */

* data cleaning
recode s7_b7prgy* (-9=.) (-8=.) (-1=.) // harmonise coding of missing variables
recode s7_b7preg* (-9=.) (-8=.) (-7=.) (-1=.)  // harmonise coding of missing variables

sort bcsid sweep year // sort data in chronological order
bysort bcsid sweep: gen sweep_count=_n // count of observations within sweeps
sort bcsid sweep year // go back to previous data sorting

gen outcome6=0 if sweep==6 // create variable showing if took part in sweep 6
replace outcome6=1 if outcome==1 & sweep==6
replace outcome6=outcome6[_n-1] if bcsid==bcsid[_n-1] & outcome6==. & sweep==7
la var outcome6 "Whether took part in sweep 6"

fre s7_b7prgy11 if s7_b7preg11 ==3 & sweep_count==1 & sweep==7 // check how many miscarriage years missing
fre s7_b7prgy21 if s7_b7preg21 ==3 & sweep_count==1 & sweep==7 
fre s7_b7prgy31 if s7_b7preg31 ==3 & sweep_count==1 & sweep==7 
fre s7_b7prgy41 if s7_b7preg41 ==3 & sweep_count==1 & sweep==7 

fre s7_b7prgy11 if s7_b7preg11 ==3 & outcome6==1  & sweep_count==1 // how many miscarriage years missing & not in sweep6 (n=32)
fre s7_b7prgy21 if s7_b7preg21 ==3 & outcome6==1  & sweep_count==1
fre s7_b7prgy31 if s7_b7preg31 ==3 & outcome6==1  & sweep_count==1
fre s7_b7prgy41 if s7_b7preg41 ==3 & outcome6==1  & sweep_count==1

* First impute years for those who took part in sweep 6 --> we can assume that miscarriage happened after sweep 6 data collection in 2000 --> will assign years 2000-03 

gen imp_year11 = . // generate variables for imputing miscarriage years for most recent miscarriage
gen imp_year21 = . // generate variables for imputing miscarriage years for 2nd most recent miscarriage
gen imp_year31 = . // generate variables for imputing miscarriage years for 3rd most recent miscarriage
gen imp_year41 = . // generate variables for imputing miscarriage years for 4th most recent miscarriage

set seed 2022 // set seed for replicable results

** a) Those who took part in sweep 6 & have other pregnancies that help on both sides of miscarriages in sweep 7
/*    We impute years within the range by pregnancies surrounding the miscarriage, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than the next pregnancy)*/

replace imp_year21 = runiformint(s7_b7prgy31,s7_b7prgy11) if s7_b7preg21 ==3 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & imp_year21==.
replace imp_year21 = runiformint(s7_b7prgy31,2004) if s7_b7preg21 ==3 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & imp_year21==. & s7_b7preg11 ==5 // currently pregnant 
replace imp_year31 = runiformint(s7_b7prgy41,s7_b7prgy21) if s7_b7preg31 ==3 & s7_b7prgy31==. & s7_b7prgy21<. & s7_b7prgy41<.  & sweep_count==1 & outcome6==1
replace imp_year41 = runiformint(s7_b7prgy51,s7_b7prgy31) if s7_b7preg41 ==3 & s7_b7prgy31<. & s7_b7prgy51<. & s7_b7prgy41==. & sweep_count==1 & outcome6==1 & imp_year41==.

** b) Those who took part in sweep 6 & have earlier pregnancies that help, but no later pregnancies
/*   We impute years within the range by pregnancies surrounding the miscarriage, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than age 16, or later than the more recent pregnancy)*/

replace imp_year21 = runiformint(2000,s7_b7prgy11) if s7_b7preg21 ==3 & s7_b7prgy11<. & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & imp_year21==.
replace imp_year31 = runiformint(2000,s7_b7prgy21) if s7_b7preg31 ==3 & s7_b7prgy21<. & s7_b7prgy31==. & sweep_count==1 & outcome6==1 & imp_year31==.
replace imp_year41 = runiformint(2000,s7_b7prgy31) if s7_b7preg41 ==3 & s7_b7prgy31<. & s7_b7prgy41==. & sweep_count==1 & outcome6==1 & imp_year41==.

** c) Those who took part in sweep 6 & have later (but not earlier) pregnancies that help
/*    We impute years within the range by pregnancies surrounding the miscarriage, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than sweep 7 interview).
There were no cases like this for 2nd-4th miscarriages, so only relevant for 1st miscarriages */

replace imp_year11 = runiformint(s7_b7prgy21,2004) if s7_b7preg11 ==3 & s7_b7prgy21<. & s7_b7prgy11==. & sweep_count==1 & outcome6==1 & imp_year11==.

* First impute years for those who did not take part in sweep 6 --> we can still use information about other pregnancies collected in other waves, if available 

** d) Those who did not take part in sweep 6 but have other earlier and later pregnancies
/*    We impute years within the range by pregnancies surrounding the miscarriage, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than the next pregnancy)*/

replace imp_year21 = runiformint(s7_b7prgy31,s7_b7prgy11) if s7_b7preg21 ==3 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==0 & imp_year21==.
replace imp_year21 = runiformint(s7_b7prgy31,2004) if s7_b7preg21 ==3 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==0 & imp_year21==. & s7_b7preg11 ==5 // currently pregnant
replace imp_year31 = runiformint(s7_b7prgy41,s7_b7prgy21) if s7_b7preg31 ==3 & s7_b7prgy31==. & s7_b7prgy21<. & s7_b7prgy41<.  & sweep_count==1 & outcome6==0
replace imp_year41 = runiformint(s7_b7prgy51,s7_b7prgy31) if s7_b7preg41 ==3 & s7_b7prgy31<. & s7_b7prgy51<. & s7_b7prgy41==. & sweep_count==1 & outcome6==0 & imp_year41==.

** e) Those who did not take part in sweep 6 but have earlier pregnancies
/*   We impute years within the range by pregnancies surrounding the miscarriage, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than age 16, or later than the next pregnancy)*/
replace imp_year21 = runiformint(1986,s7_b7prgy11) if s7_b7preg21 ==3 & s7_b7prgy11<. & s7_b7prgy21==. & sweep_count==1 & outcome6==0 & imp_year21==.
replace imp_year31 = runiformint(1986,s7_b7prgy21) if s7_b7preg31 ==3 & s7_b7prgy21<. & s7_b7prgy31==. & sweep_count==1 & outcome6==0 & imp_year31==.
replace imp_year41 = runiformint(1986,s7_b7prgy31) if s7_b7preg41 ==3 & s7_b7prgy31<. & s7_b7prgy41==. & sweep_count==1 & outcome6==0 & imp_year41==.

** f) Those who did not take part in sweep 6 & have earlier (but not later) pregnancies that help
/*    We impute years within the range by pregnancies surrounding the miscarriage, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than sweep 7 interview).
There were no cases like this for 2nd-4th miscarriages, so only relevant for most recent miscarriages */
 
replace imp_year11 = runiformint(s7_b7prgy21,2004) if s7_b7preg11 ==3 & s7_b7prgy21<. & s7_b7prgy11==. & sweep_count==1 & outcome6==0 & imp_year11==.

** g) Impute years for the few remaining miscarriages, for which a year has not yet been imputed in sections a-f above. Force years to be in the right order to preserve the pregnancy order.

replace imp_year11 = 2003 if s7_b7preg11 ==3 & s7_b7prgy11==. & sweep_count==1 & outcome6==1 & imp_year11==.
replace imp_year21 = 2002 if s7_b7preg21 ==3 & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & imp_year21==.
replace imp_year31 = 2001 if s7_b7preg31 ==3 & s7_b7prgy31==. & sweep_count==1 & outcome6==1 & imp_year31==.
replace imp_year41 = 2000 if s7_b7preg41 ==3 & s7_b7prgy41==. & sweep_count==1 & outcome6==1 & imp_year41==.

foreach i in 11 21 31 41 {
replace imp_year`i' =imp_year`i'[_n-1] if imp_year`i'[_n-1]<. & imp_year`i'==. & bcsid==bcsid[_n-1] & sweep==7
} // include imputed years in all rows

* replace missing miscarriage year by imputed year
replace s7_b7prgy11=imp_year11 if s7_b7preg11 ==3 & s7_b7prgy11==.
replace s7_b7prgy21=imp_year21 if s7_b7preg21 ==3 & s7_b7prgy21==. 
replace s7_b7prgy31=imp_year31 if s7_b7preg31 ==3 & s7_b7prgy31==. 
replace s7_b7prgy41=imp_year41 if s7_b7preg41 ==3 & s7_b7prgy41==. 

gsort bcsid -year // copy pregnancy outcome and year to all rows preceding survey year

foreach i in 11 12 13 21 22 23 31 32 41 51 61 71 81 {
replace s7_b7preg`i'=s7_b7preg`i'[_n-1] if bcsid==bcsid[_n-1] & s7_b7preg`i'[_n-1]<. 
replace s7_b7prgy`i'=s7_b7prgy`i'[_n-1] if bcsid==bcsid[_n-1] & s7_b7prgy`i'[_n-1]<.
}

gsort bcsid year // go back to chronological order

*** Impute missing abortion years ***

* how many abortion years missing
fre s7_b7prgy11 if s7_b7preg11 ==4 & sweep_count==1 & sweep==7
fre s7_b7prgy21 if s7_b7preg21 ==4 & sweep_count==1 & sweep==7
fre s7_b7prgy31 if s7_b7preg31 ==4 & sweep_count==1 & sweep==7
fre s7_b7prgy41 if s7_b7preg41 ==4 & sweep_count==1 & sweep==7

* how many abortion years missing and did not participate in sweep 6
fre s7_b7prgy11 if s7_b7preg11 ==4 & outcome6==0  & sweep_count==1
fre s7_b7prgy21 if s7_b7preg21 ==4 & outcome6==0  & sweep_count==1
fre s7_b7prgy31 if s7_b7preg31 ==4 & outcome6==0  & sweep_count==1
fre s7_b7prgy41 if s7_b7preg41 ==4 & outcome6==0  & sweep_count==1


* First impute years for those who took part in sweep 6 --> we can assume that abortion happened after sweep 6 data collection in 2000

gen abimp_year11 = .  // generate variables for imputing miscarriage years for most recent abortion
gen abimp_year21 = .  // generate variables for imputing miscarriage years for 2nd most recent abortion
gen abimp_year31 = .  // generate variables for imputing miscarriage years for 3rd most recent abortion
gen abimp_year41 = .  // generate variables for imputing miscarriage years for 4th most recent abortion

set seed 2022  // set seed for replicable results

** a) Those who took part in sweep 6 & have other pregnancies that help on both sides of abortions in sweep 7
/*    We impute years within the range by pregnancies surrounding the abortion, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than the next pregnancy)*/

replace abimp_year21 = runiformint(s7_b7prgy31,s7_b7prgy11) if s7_b7preg21 ==4 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & abimp_year21==.
replace abimp_year21 = runiformint(s7_b7prgy31,2004) if s7_b7preg21 ==4 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & abimp_year21==. & s7_b7preg11 ==5 // currently preg 
replace abimp_year31 = runiformint(s7_b7prgy41,s7_b7prgy21) if s7_b7preg31 ==4 & s7_b7prgy31==. & s7_b7prgy21<. & s7_b7prgy41<.  & sweep_count==1 & outcome6==1
replace abimp_year41 = runiformint(s7_b7prgy51,s7_b7prgy31) if s7_b7preg41 ==4 & s7_b7prgy31<. & s7_b7prgy51<. & s7_b7prgy41==. & sweep_count==1 & outcome6==1 & abimp_year41==.

** b) Those who took part in sweep 6 & have earlier pregnancies that help, but no later pregnancies
/*   We impute years within the range by pregnancies surrounding the abortion, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than age 16, or later than the more recent pregnancy)*/

replace abimp_year21 = runiformint(2000,s7_b7prgy11) if s7_b7preg21 ==4 & s7_b7prgy11<. & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & abimp_year21==.
replace abimp_year31 = runiformint(2000,s7_b7prgy21) if s7_b7preg31 ==4 & s7_b7prgy21<. & s7_b7prgy31==. & sweep_count==1 & outcome6==1 & abimp_year31==.
replace abimp_year41 = runiformint(2000,s7_b7prgy31) if s7_b7preg41 ==4 & s7_b7prgy31<. & s7_b7prgy41==. & sweep_count==1 & outcome6==1 & abimp_year41==.

** c) Those who took part in sweep 6 & have later (but not earlier) pregnancies that help
/*    We impute years within the range by pregnancies surrounding the abortion, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than sweep 7 interview).
There were no cases like this for 2nd-4th abortions, so only relevant for 1st abortions */

replace abimp_year11 = runiformint(s7_b7prgy21,2004) if s7_b7preg11 ==4 & s7_b7prgy21<. & s7_b7prgy11==. & sweep_count==1 & outcome6==1 & abimp_year11==.

** d) Those who did not take part in sweep 6 but have other earlier and later pregnancies
/*    We impute years within the range by pregnancies surrounding the abortion, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than the next pregnancy)*/

replace abimp_year21 = runiformint(s7_b7prgy31,s7_b7prgy11) if s7_b7preg21 ==4 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==0 & abimp_year21==.
replace abimp_year21 = runiformint(s7_b7prgy31,2004) if s7_b7preg21 ==4 & s7_b7prgy11<. & s7_b7prgy31<. & s7_b7prgy21==. & sweep_count==1 & outcome6==0 & abimp_year21==. & s7_b7preg11 ==5 // currently pregnant
replace abimp_year31 = runiformint(s7_b7prgy41,s7_b7prgy21) if s7_b7preg31 ==4 & s7_b7prgy31==. & s7_b7prgy21<. & s7_b7prgy41<.  & sweep_count==1 & outcome6==0
replace abimp_year41 = runiformint(s7_b7prgy51,s7_b7prgy31) if s7_b7preg41 ==4 & s7_b7prgy31<. & s7_b7prgy51<. & s7_b7prgy41==. & sweep_count==1 & outcome6==0 & abimp_year41==.

** e) Those who did not take part in sweep 6 but have earlier pregnancies
/*   We impute years within the range by pregnancies surrounding the abortion, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than age 16, or later than the next pregnancy)*/

replace abimp_year21 = runiformint(1986,s7_b7prgy11) if s7_b7preg21 ==4 & s7_b7prgy11<. & s7_b7prgy21==. & sweep_count==1 & outcome6==0 & abimp_year21==.
replace abimp_year31 = runiformint(1986,s7_b7prgy21) if s7_b7preg31 ==4 & s7_b7prgy21<. & s7_b7prgy31==. & sweep_count==1 & outcome6==0 & abimp_year31==.
replace abimp_year41 = runiformint(1986,s7_b7prgy31) if s7_b7preg41 ==4 & s7_b7prgy31<. & s7_b7prgy41==. & sweep_count==1 & outcome6==0 & abimp_year41==.

** f) Those who did not take part in sweep 6 & have earlier (but not later) pregnancies that help
/*    We impute years within the range by pregnancies surrounding the abortion, as we know the pregnancy order for all pregnancies (i.e. cannot be earlier than preceding pregnancy, or later than sweep 7 interview).
There were no cases like this for 2nd-4th abortions, so only relevant for most recent abortions */

replace abimp_year11 = runiformint(s7_b7prgy21,2004) if s7_b7preg11 ==4 & s7_b7prgy21<. & s7_b7prgy11==. & sweep_count==1 & outcome6==0 & abimp_year11==.

** g) Impute years for the few remaining abortions, for which a year has not yet been imputed in sections a-f above. Force years to be in the right order to preserve the pregnancy order.

replace abimp_year11 = 2003 if s7_b7preg11 ==4 & s7_b7prgy11==. & sweep_count==1 & outcome6==1 & abimp_year11==.
replace abimp_year21 = 2002 if s7_b7preg21 ==4 & s7_b7prgy21==. & sweep_count==1 & outcome6==1 & abimp_year21==.
replace abimp_year31 = 2001 if s7_b7preg31 ==4 & s7_b7prgy31==. & sweep_count==1 & outcome6==1 & abimp_year31==.
replace abimp_year41 = 2000 if s7_b7preg41 ==4 & s7_b7prgy41==. & sweep_count==1 & outcome6==1 & abimp_year41==.

foreach i in 11 21 31 41 {
replace abimp_year`i' =abimp_year`i'[_n-1] if abimp_year`i'[_n-1]<. & abimp_year`i'==. & bcsid==bcsid[_n-1] & sweep==7
} // include imputed years in all rows

* replace missing abortion year by imputed year
replace s7_b7prgy11=abimp_year11 if s7_b7preg11 ==4 & s7_b7prgy11==.
replace s7_b7prgy21=abimp_year21 if s7_b7preg21 ==4 & s7_b7prgy21==.
replace s7_b7prgy31=abimp_year31 if s7_b7preg31 ==4 & s7_b7prgy31==.
replace s7_b7prgy41=abimp_year41 if s7_b7preg41 ==4 & s7_b7prgy41==.

gsort bcsid -year // copy pregnancy outcome and year to all rows preceding survey year

foreach i in 11 21 31 41 51 {
replace s7_b7preg`i'=s7_b7preg`i'[_n-1] if bcsid==bcsid[_n-1] & s7_b7preg`i'[_n-1]<. 
replace s7_b7prgy`i'=s7_b7prgy`i'[_n-1] if bcsid==bcsid[_n-1] & s7_b7prgy`i'[_n-1]<.
}

sort bcsid year // go back to chronological order

foreach i in 11 12 13 21 22 23 31 32 41 51 61 71 81 {
replace s7_b7preg`i'=. if s7_b7prgy`i'!=year		// preg outcome only for the relevant year
replace s7_b7prgy`i'=. if s7_b7prgy`i'!=year	// preg year only for the relevant year
}

*** Generate pregnancy history ***

* generate variable showing number of miscarriages per year (excluding multiple featuses preg pregnancy)
foreach i in 11 12 13 21 22 23 31 32 41 51 61 71 81 {
replace misc_count_yr = misc_count_yr + 1 if s7_b7preg`i' == 3
} 

* generate variable showing number of abortions per year (excluding multiple featuses preg pregnancy)
foreach i in 11 21 31 41 {
replace abort_count_yr = abort_count_yr + 1 if s7_b7preg`i' == 4	
}

* generate variable showing number of births per year (including multiple foetuses per preg)
foreach i in 11 12 13 21 22 23 31 32 41 51 61 71 81 {
replace birth_count_yr = birth_count_yr + 1 if s7_b7preg`i' == 1
} 

save bcs_miscuk.dta, replace // save to avoid losing changes

*****************************************************************************
** Generate cross-sweep pregnancy history variables
*****************************************************************************

// create variable counting parity across sweeps

gen parity=birth_count if year == 1986	
replace parity=parity[_n-1]+birth_count if bcsid==bcsid[_n-1]

// create variable counting miscarriages across sweeps

gen misc_sum = misc_count_yr if year ==1986
replace misc_sum=misc_sum[_n-1]+misc_count_yr if bcsid==bcsid[_n-1]

// create variable counting abortions across sweeps

gen abort_sum = abort_count_yr if year ==1986
replace abort_sum=abort_sum[_n-1]+abort_count_yr if bcsid==bcsid[_n-1]

// create variable indicating when any pregnancy was experienced

gen pregnant=0

* sweep 6
foreach i in 1 2 3 6 7 11 12 16 17 21 22 23 26 27 31 36 {
replace pregnant =1 if s6_prega`i'<.
} 

* sweep 7
foreach i in 11 12 13 21 22 23 31 32 41 51 61 71 81 {
replace pregnant =1 if s7_b7preg`i'<.
}

* sweep 8
foreach i in 11 12 13 21 22 31 32 41 42 43 44 51 61 71 81  {
replace pregnant =1 if  s8_b8preg`i'<.
} 

* sweep 9
forvalues i=1/9 {
replace pregnant =1 if  s9_b9sba`i'<.
} 

replace pregnant = 1 if birth_c==1
replace pregnant = 1 if birth_c==2

la de pregnant 0 "Not pregnant" 1 "Pregnant"
la val pregnant pregnant

// create variable counting pregnancies across sweeps

gen preg_sum = pregnant if year ==1986
replace preg_sum=preg_sum[_n-1]+pregnant if bcsid==bcsid[_n-1]

save bcs_miscuk.dta, replace // save to avoid losing changes

// Section 3. Generate final data structure, select and recode relevant variables for analysis

****************************************************************************
** Create final data structure
****************************************************************************

/* Since the analyses will be conducted by age-groups that are determined by sweep interview times, we only keep observations at the end of each sweep */

drop if age<19
drop if age>42

foreach i in 20 21 22 23 24 26 27 28 30 31 32 34 35 36 38 39 40 42 {
drop if age == `i'
}

tab age // only keep ages 25 29 33 37 41

save bcs_miscuk.dta, replace // save to avoid losing changes

****************************************************************************
** Final variable edits
****************************************************************************

// Recode socioeconomic variables to be more suitable for our analyses

* Create variable for age left education

** Sweep 4 uses data from parents: create average age that parents left education
gen s4_edu_f = s4_t7_1 if s4_t7_1>0 & s4_t7_1<.
gen s4_edu_m = s4_t7_2 if s4_t7_2>0 & s4_t7_2<.
gen s4_edu_avg = (s4_t7_1+s4_t7_2)/2 if s4_edu_f<. & s4_edu_m<.
replace s4_edu_avg = s4_edu_f if s4_edu_avg==. & s4_edu_m==.
replace s4_edu_avg = s4_edu_m if s4_edu_avg==. & s4_edu_f==.

** Generate variable (eduage) for sweeps 4, 6-8, continuous age
gen eduage = s4_edu_avg if sweep == 4
replace eduage = s6_actagel2 if sweep == 6
replace eduage = 26 if s6_agelfte2== 2 & sweep == 6
replace eduage = s7_b7lftme2 if sweep == 7 & s7_b7lftme2>0 & s7_b7lftme2<. & sweep == 7
replace eduage = s8_b8actal2  if sweep == 8 & s8_b8actal2>0 & s8_b8actal2<. & sweep == 8

** Generate variable (eduage_cat) for sweep 5 (coding is different from other waves), categorical variable
gen eduage_cat = s5_leftedg
replace eduage_cat = 5 if s5_leftedg==6

** Recode earlier eduage variable into the categorical variable created above
replace eduage_cat = 1 if eduage<16 & eduage_cat==.
replace eduage_cat = 2 if eduage==16 & eduage_cat==.
replace eduage_cat = 3 if eduage>16 & eduage<19 & eduage_cat==.
replace eduage_cat = 4 if eduage>18 & eduage<21 & eduage_cat==.
replace eduage_cat = 5 if eduage>21 & eduage<. & eduage_cat==.

** Copy eduage_cat information to rows below
sort bcsid sweep
replace eduage_cat = eduage_cat[_n-1] if bcsid==bcsid[_n-1] & eduage_cat ==. & sweep>5

** variable lables and name
la val eduage_cat leftedg
la var eduage_cat "Age left education (parent, CM) categorical"

* reduce categories from age left education (eduage_cat)
gen eduage_red = 1 if eduage_cat <3
replace eduage_red = 2 if eduage_cat==3
replace eduage_red = 3 if eduage_cat==4
replace eduage_red = 3 if eduage_cat==5

** variable lables and name
la de eduage_red 1 "under/at 16" 2 "Post 16" 3 "Post 18"
la val eduage_red eduage_red 
la var eduage_red "Age left education, 3 categories"

* Occupational ses
gen ses=s4_bd4psoc if sweep==4
replace ses=s5_rgsc91 if sweep==5
replace ses=. if ses<0
recode ses (6=1) (5=2) (4=3) (2=4) (1=5)
replace ses=s6_sc if sweep==6
recode ses (10=1) (20=2) (31=3) (32=3) (40=4) (50=5)
replace ses=s7_b7sc if sweep==7
recode ses (3.2=3) (3.1=3)
replace ses=s8_b8sc if sweep==8
recode ses (3.2=3) (3.1=3)
replace ses=. if ses<1
replace ses=. if ses==6

la de ses 1 "Professional" 2 "Managerial" 3 "Skilled" 4 "Partly skilled" 5 "Unskilled"
la val ses ses
la var ses "Occupational status"

* Recode occupational status variable into fewer categories
gen ses_red = 1 if ses>3 & ses<.
replace ses_red = 2 if ses==3
replace ses_red = 3 if ses<3

** variable lables and name
la de ses_red 1 "Un-/partly skilled" 2 "Skilled" 3 "Managerial/professional"
la val ses_red ses_red
la var ses_red "Social class, 3 categories"

* Generate income quintiles variable
gen inc4 = s4_oe2 if s4_oe2<.
replace inc4=. if s4_oe2<0
replace inc4=. if s4_oe2>11
la val inc4 oe2 
xtile rel_inc4=inc4, n(5)

gen inc5=s5_wklypayc if sweep==5
xtile rel_inc5=inc5, n(5)

gen inc6=s6_cnetpay if s6_cnetprd==1
replace inc6=s6_cnetpay/2 if s6_cnetprd==2
replace inc6=s6_cnetpay/4 if s6_cnetprd==3
replace inc6=s6_cnetpay/30*7 if s6_cnetprd==4
replace inc6=s6_cnetpay/52 if s6_cnetprd==5
replace inc6=. if s6_cnetprd==6
xtile rel_inc6=inc6, n(5)

gen inc7=s7_b7cnetpy if s7_b7cnetpd==1
replace inc7=s7_b7cnetpy/2 if s7_b7cnetpd==2
replace inc7=s7_b7cnetpy/4 if s7_b7cnetpd==3
replace inc7=s7_b7cnetpy/30*7 if s7_b7cnetpd==4
replace inc7=s7_b7cnetpy/52 if s7_b7cnetpd==5
replace inc7=. if s7_b7cnetpd==6
xtile rel_inc7=inc7, n(5)

gen inc8=s8_b8cnetwk
xtile rel_inc8=inc8, n(5)

gen relincome = rel_inc4 if sweep == 4
replace relincome = rel_inc5 if relincome==. & sweep==5
replace relincome = rel_inc6 if relincome==. & sweep==6
replace relincome = rel_inc7 if relincome==. & sweep==7
replace relincome = rel_inc8 if relincome==. & sweep==8

la var relincome "Income quantiles"
la de relincome 1 "Lowest 20%" 2 "2nd lowest" 3 "Middle 20%" 4 "2nd highest" 5 "Highest 20%"
la val relincome relincome

drop inc* s6_cnetpay s6_cnetprd s7_b7cnetpy s7_b7cnetpd s8_b8cnetpy s8_b8cnetpd ///
s9_b9neta s9_b9netp s6_cgropay s6_cgroprd s7_b7cgropy s7_b7cgropd s8_b8iamtc ///
s8_b8cnetwk s8_b8cgropy s8_b8cgropd s8_b8cgrowk s9_b9groa s9_b9grop s9_b9totncp ///
s9_b9ttncnp s9_b9tncpdr s9_b9ttnpdr

** Recode income variable into three categories
gen relinc_red = 1 if relincome ==1
replace relinc_red = 2 if relincome==2
replace relinc_red = 2 if relincome==3
replace relinc_red = 2 if relincome==4
replace relinc_red = 3 if relincome==5

** variable lables and name
la de relinc_red 1 "Lowest 20%" 2 "Middle 60%" 3 "Highest 20%"
la val relinc_red relinc_red
la var relinc_red "Relative income, 3 categories"

* Generate dummy variables for occulational status, income, and age left education
tab ses_red, gen(catses)
tab relincome, gen (catinc)
tab eduage_red, gen (cateduage)

// Create variable indicating if in partnership

recode s4_f46a (-1=.) (-2=.)

gen partner=0
replace partner=1 if s4_f46a==1 & sweep==4
replace partner=1 if s5_b960321<3 & sweep==5
replace partner=1 if s6_ms<3  & sweep==6
replace partner=1 if s7_bd7ms<3  & sweep==7
replace partner=1 if s8_bd8ms==2 & sweep==8
replace partner=1 if s8_b8cohab==2 & sweep==8

la de partner 0 "No/missing" 1 "Has partner"
la val partner partner
la var partner "Partnership status"

// Create variable indicating smoking status

gen smoking = s4_smoking if sweep ==4
replace smoking = s5_smoking if sweep ==5
replace smoking = s6_smoking if sweep ==6
replace smoking = s7_smoking if sweep ==7
replace smoking = s8_smoking if sweep ==8
la drop smoking
la de smoking 0 "Nonsmoker" 1 "Smoker"
la val smoking smoking
la var smoking "Smoker past yr (s4) or daily (s5+)"

// Recode pregnancy variables to be more suitable for our analyses

* Top code parity
gen parity_cat=parity
replace parity_cat=3 if parity>3 & parity<.
la var parity_cat "Parity top coded at 3"

* Create variables showing mean values for miscarriage, parity and births
egen meanmisc = mean(misc_count_yr), by(age)
egen meanpari = mean(parity), by(age)
egen meanbirth = mean(birth_count_yr), by(age)

* Create a binary variable indicating if a miscarriage was experienced between waves
sort bcsid year

gen misc_bin = 0 if misc_sum==0
replace misc_bin = 1 if age==19 & misc_sum>0 & misc_sum<.
replace misc_bin = 1 if misc_sum>misc_sum[_n-1] & bcsid==bcsid[_n-1]
replace misc_bin = 0 if misc_sum==misc_sum[_n-1] & bcsid==bcsid[_n-1] & misc_bin==.
la var misc_bin "At least 1 miscarriage reported"
la de misc_bin 0 "None" 1 "1+ miscarriage"
la val misc_bin misc_bin 

* Data structure has changed, so need to create pregnancy indicator variable again
drop pregnant

gen pregnant=0
replace pregnant=1 if preg_sum>preg_sum[_n-1] & bcsid==bcsid[_n-1]

* Create a categorical age variable
gen agec = 1 if age==25
replace agec = 2 if age==29
replace agec = 3 if age==33
replace agec = 4 if age==37
replace agec = 5 if age==41

** variable lables and name
la de agec  1 "16-25" 2 "26-29" 3 "30-33" 4 "34-38" 5 "39-41"
la val agec agec
la var agec "Age categories"

// Keep only relevant variables

** drop variables not needed
drop s4_* s5_* s6_* s7_* s8_* s9_* rel_inc*

save bcs_miscuk.dta, replace // save final dataset for analyses