/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION SWEEP 9

This programme uses datafiles from sweep 9 to extract and edit relevant variables and combine them to the combined dataset bcs_miscuk.dta

*/

/*
Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen
*/

// Section 1. Load sweep 9 data, select and recode relevant variables

** NB! file structure is different compared to previous sweeps

use bcs70_2012_flatfile.dta, clear

rename B9CMSEX sex // harmonise variable names
keep if sex==2 // keep women only

** variables to keep (id, SES, education, income, relationships, smoking, pregnancies, health)

keep sex BCSID B9INTM B9INTY B9HMS B9HMSDR B9MORECH B9MCHMNY B9TEN B9GROA B9GROP ///
B9NETA B9NETP B9CSC B9TOTNCP B9TTNCNP B9TNCPDR B9TTNPDR ///
B9HLTHGN B9SFDA B9LOIL B9LOLM B9SMOKIG B9NFCIGS B9EXSMER B9AGESTR B9AGEQUT ///
B9CURPRG B9BABNUM

** clean variable names
rename	BCSID	bcsid
rename	B9INTM	b9intm
rename	B9INTY	b9inty
rename	B9HMS	b9hms
rename	B9HMSDR	b9hmsdr
rename	B9MORECH	b9morech
rename	B9MCHMNY	b9mchmny
rename	B9TEN	b9ten
rename	B9GROA	b9groa
rename	B9GROP	b9grop
rename	B9NETA	b9neta
rename	B9NETP	b9netp
rename	B9CSC	b9csc
rename	B9TOTNCP	b9totncp
rename	B9TTNCNP	b9ttncnp
rename	B9TNCPDR	b9tncpdr
rename	B9TTNPDR	b9ttnpdr
rename	B9HLTHGN	b9hlthgn
rename	B9SFDA	b9sfda
rename	B9LOIL	b9loil
rename	B9LOLM	b9lolm
rename	B9SMOKIG	b9smokig
rename	B9NFCIGS	b9nfcigs
rename	B9EXSMER	b9exsmer
rename	B9AGESTR	b9agestr
rename	B9AGEQUT	b9agequt
rename	B9CURPRG	b9curprg
rename	B9BABNUM	b9babnum

** edit variable names so that they include s9 to identify sweeps in the combined file (except for variables that do not change over time: sex, date of birth, id)

rename * s9_*
rename s9_bcsid bcsid
rename s9_sex sex

gen sweep=9 // generate variable indicating which sweep these data were extracted
gen age=42 // generate variable indicating respondent age at data collection

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome

save bcs_miscuk.dta, replace

// Section 2. Load derived variables dataset for sweep 9, select and recode relevant variables

use bcs70_2012_derived.dta, clear

** clean variable names
rename	BCSID	bcsid
rename	BD9CNTRY	bd9cntry
rename	BD9GOR	bd9gor
rename	BD9REGN	bd9regn
rename	BD9HSIZE	bd9hsize
rename	BD9MS	bd9ms
rename	BD9COHAB	bd9cohab
rename	BD9PARTP	bd9partp
rename	BD9PAGE	bd9page
rename	BD9PID	bd9pid
rename	BD9PSEX	bd9psex
rename	BD9NUMCH	bd9numch
rename	BD9FATHN	bd9fathn
rename	BD9MOTHN	bd9mothn
rename	BD9NOCHH	bd9nochh
rename	BD9NPCHH	bd9npchh
rename	BD9AYCHH	bd9aychh
rename	BD9NC2H	bd9nc2h
rename	BD9NC4H	bd9nc4h
rename	BD9NC11H	bd9nc11h
rename	BD9NC15H	bd9nc15h
rename	BD9NACAB	bd9nacab
rename	BD9NOCAB	bd9nocab
rename	BD9TOTAC	bd9totac
rename	BD9TOTOC	bd9totoc
rename	BD9WCDIE	bd9wcdie
rename	BD9NCDIE	bd9ncdie
rename	BD9TOTCE	bd9totce
rename	BD9WMABC	bd9wmabc
rename	BD9WMCPP	bd9wmcpp
rename	BD9MALIV	bd9maliv
rename	BD9PALIV	bd9paliv
rename	BD9ECACT	bd9ecact
rename	BD9PEACT	bd9peact
rename	BD9WRBEN	bd9wrben
rename	BD9ALFED	bd9alfed
rename	BD9ACHQ1	bd9achq1
rename	BD9ANVQ1	bd9anvq1
rename	BD9VNVQ1	bd9vnvq1
rename	BD9NVQ1	bd9nvq1
rename	BD9HACHQ	bd9hachq
rename	BD9HANVQ	bd9hanvq
rename	BD9HVNVQ	bd9hvnvq
rename	BD9HNVQ	bd9hnvq
rename	BD9NUALC	bd9nualc
rename	BD9HGHTM	bd9hghtm
rename	BD9WGHTK	bd9wghtk
rename	BD9BMI	bd9bmi
rename	BD9WHYST	bd9whyst
rename	BD9WP12M	bd9wp12m
rename	BD9ALSTP	bd9alstp
rename	BD9MAL	bd9mal
rename	BD9MALG	bd9malg
rename	BD9AUDIT	bd9audit
rename	BD9AUDG	bd9audg
rename	BD9WEMWB	bd9wemwb
rename	BD9DISEQ	bd9diseq
rename	BD9DISLS	bd9disls

** keep relevant variables only (country, region, governement office region, highest education level, relationships, children)
keep bcsid bd9cntry bd9regn bd9gor bd9ms bd9cohab bd9partp bd9totoc bd9totce bd9hnvq

** harmonise variable names
rename bd9cntry bdcntry
rename bd9regn bdregn
rename bd9gor bdgor
rename bd9hnvq hiaca

** edit variable names so that they include s9 to identify sweeps in the combined file
rename bd9ms s9_bd9ms
rename bd9cohab s9_bd9cohab
rename bd9partp s9_bd9partp
rename bd9totoc s9_bd9totoc
rename bd9totce s9_bd9totce

gen sweep=9 // generate variable indicating which sweep these data were extracted
gen age=42 // generate variable indicating respondent age at data collection

sort bcsid sweep

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome hiaca ///
s4_* s5_* s6_* s7_* s8_* s9_*

save bcs_miscuk.dta, replace

// Section 3. As live birth data not directly collected, add live births from person grid in sweep 9

use bcs70_2012_persongrid, clear

rename B9GSEX sex // harmonise variable names
keep if sex==2 // keep women only

** clean variable names
rename BCSID	bcsid
rename B9GRTOK b9grtok
rename B9GDOBM b9gdobm
rename B9GDOBY b9gdoby

** keep relevant variables only (id, sex, rhsip to respondent, year and month of birth)
keep bcsid sex b9grtok b9gdobm b9gdoby

** keep own children only
keep if b9grtok==4

** recode missing values as missing
recode b9gdobm b9gdoby (-8=.)

** rename variables
rename b9gdobm s9_bmo_grid
rename b9gdoby s9_byr_grid

gen sweep=9 // generate variable indicating which sweep these data were extracted
gen age=42 // generate variable indicating respondent age at data collection

** housekeeping to enable merging
sort bcsid s9_byr_grid
bysort bcsid: gen nid = _n

reshape wide s9_bmo_grid s9_byr_grid, i(bcsid) j(nid)

** merge to master data

merge 1:1 bcsid sweep using bcs_miscuk.dta
drop if _merge==1
drop _merge
sort bcsid sweep
order bcsid sweep age sex dob bdcntry bdregn bdgor cob-twincode outcome hiaca ///
s4_* s5_* s6_* s7_* s8_* s9_*

save bcs_miscuk.dta, replace