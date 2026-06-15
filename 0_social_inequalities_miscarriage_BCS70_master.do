/*
Study: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom

MASTER FILE

*/

/*

Created: 13/11/2024
Last modified: 04/02/2026
Author: Heini Väisänen

Research question: Are there social inequalities in miscarriage prevalence among women in BCS70 cohort?

This code contains the data preparation and analyses of the BCS70 cohort study (https://cls.ucl.ac.uk/cls-studies/1970-british-cohort-study/)
which s explores social inequalities, as measured by education, income and occupational status, in miscarriage risk separately among all women and pregnant women. We use sweeps 4 to 9 (ages 16-42)

This work has been published in:
Väisänen, Heini, and Katherine Keenan (2025). Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom. Journal of Critical Public Health, 2(3), pp. 6-24, DOI: 10.55016/ojs/jcph.vi.79555.

Data access: see https://datacatalogue.ukdataservice.ac.uk/series/series/200001#abstract
Files needed: 
- 1970 British Cohort Study Response Dataset, 1970-2016 (or a newer version)
- 1970 British Cohort Study: Age 16, Sweep 4, 1986
- 1970 British Cohort Study: Age 26, Sweep 5, 1996
- 1970 British Cohort Study: Age 29, Sweep 6, 1999-2000
- 1970 British Cohort Study: Age 34, Sweep 7, 2004-2005
- 1970 British Cohort Study: Age 38, Sweep 8, 2008-2009
- 1970 British Cohort Study: Age 42, Sweep 9, 2012

*/

* System set-up
clear all                                                   // clear everything in memory
version 18.0                                                // set Stata version
capture log close                                           // close any open log files
set more off                                                // allow program to scroll freely

* Necessary user-written packages
** Check if -estpost- and -unstack- are installed -- if not, install them. 
/* these are user written commands that make it easier to store results from certain commands. */

capture which estpost                                      // checks if estpost exists
if  _rc==111 ssc install estout.pkg                        // if it doesn't, installs it

capture which unstack                                      // checks if unstack exists
if  _rc==111 net install unstack, from("https://raw.githubusercontent.com/imaddowzimet/StataPrograms/master/")                        // if it doesn't, installs it

* Set home directory (assuming all relevant files are in the same folder)

cd "..." // fill in the relevant directory

// 1. DATA PREPARATION
* The programmes in this section select and edit the relevant variables from each sweep and combine them into one longitudinal dataset

** 1a. Data preparation master response dataset
* This dataset records which participants took part in each sweep and is used as the basis for combibing sweeps 4-9

run "1a_social_inequalities_miscarriage_BCS70_preparation_response.do"

** 1b. Data preparation sweep 4
* Selects and edits variables needed from this sweep and merges the data into the combined file

run "1b_social_inequalities_miscarriage_BCS70_preparation_sweep4.do"

** 1c. Data preparation sweep 5
* Selects and edits variables needed from this sweep and merges the data into the combined file

run "1c_social_inequalities_miscarriage_BCS70_preparation_sweep5.do"

** 1d. Data preparation sweep 6
* Selects and edits variables needed from this sweep and merges the data into the combined file

run "1d_social_inequalities_miscarriage_BCS70_preparation_sweep6.do"

** 1e. Data preparation sweep 7
* Selects and edits variables needed from this sweep and merges the data into the combined file

run "1e_social_inequalities_miscarriage_BCS70_preparation_sweep7.do"

** 1f. Data preparation sweep 8
* Selects and edits variables needed from this sweep and merges the data into the combined file

run "1f_social_inequalities_miscarriage_BCS70_preparation_sweep8.do"

** 1g. Data preparation sweep 9
* Selects and edits variables needed from this sweep and merges the data into the combined file

run "1g_social_inequalities_miscarriage_BCS70_preparation_sweep9.do"

** 1h. Data preparation: edit and create new variables for combinded data (sweeps 4-9)

run "1h_social_inequalities_miscarriage_BCS70_preparation_combined.do"

// 2. ANALYSIS

* The programme in this section runs the analyses that we report in the paper mentioned above.

do "2_social_inequalities_miscarriage_BCS70_analyses.do"
