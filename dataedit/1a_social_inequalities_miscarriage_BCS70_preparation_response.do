/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

PREPARATION SWEEP 4

This file uses the longitudinal response file to create the base onto which we will build the combined dataset using all relevant sweeps (4-9)

*/

/*
Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen
*/

// Load data, select and recode relevant variables

use bcs70_response_1970-2016.dta, clear // original data

** clean variable names
rename	BCSID	bcsid
rename	SEX	sex
rename	COB	cob
rename	MULTIPNO	multipno
rename	TWINCODE	twincode
rename	OUTCME01	outcome1
rename	OUTCME02	outcome2
rename	OUTCME03	outcome3
rename	OUTCME04	outcome4
rename	OUTCME05	outcome5
rename	OUTCME06	outcome6
rename	OUTCME07	outcome7
rename	OUTCME08	outcome8
rename	OUTCME09	outcome9
rename	OUTCME10	outcome10

** reshape data into long format for merging and drop extra sweeps

reshape long outcome, i(bcsid) j(sweep)

drop if sweep<4
******drop if sweep>9 --> NOTE TO SELF CHECK IF THIS IS REALLY NEEDED
la var outcome "Participation in interview"

keep if sex==2 // only keep women respondents

gen age = 16 if sweep==4
replace age = 26 if sweep==5
replace age = 30 if sweep==6
replace age = 34 if sweep==7
replace age = 38 if sweep==8
replace age = 42 if sweep==9
******replace age = 46 if sweep==10 --> NOTE TO SELF CHECK IF THIS IS REALLY NEEDED

sort bcsid sweep

la var cob "Country of birth" // relabelcountry of birth variable

** save modifiable file
save bcs_response.dta, replace // modified response file alone
save bcs_miscuk.dta, replace // base dataset for starting to build the combined dataset 
