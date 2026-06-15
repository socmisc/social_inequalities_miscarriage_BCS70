# social_inequalities_miscarriage_BCS70
This code prepares the British Cohort Study (BCS70) data to study social inequalities in self-reported miscarriage experiences 

# Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom 

DOI: https://doi.org/10.55016/ojs/jcph.vi.79555

Authors: Heini Väisänen and Katherine Keenan

Journal: Journal of Critical Public Health

Full citation: Väisänen, H., & Keenan, K. (2025) Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom. Journal of Critical Public Health, 2(3), 6–24. https://doi.org/10.55016/ojs/jcph.vi.79555

And correction: Väisänen, H., & Keenan, K. (2026) Correction: Measuring social inequalities in self-reported miscarriage experiences in the United Kingdom. Journal of Critical Public Health, online first: https://doi.org/10.55016/m1c52c04 

## OVERVIEW

This repository contains Stata code used for data processing and statistical analysis reported in the above publication. The paper used the British Cohort Study (1970) to investigate whether individuals’ socioeconomic characteristics (education, income, occupational class) were associated with their likelihood of self-reporting a miscarriage over the reproductive life course. The paper conducted descriptive analyses and multi-level discrete-time event-history models first among all women and then only taking into account pregnancy episodes. The code shows how the dataset was built and how the analyses were conducted.


## DATA
The 1970 British Cohort Study (BCS70) is following the lives of around 17,000 people born in England, Scotland and Wales in a single week of 1970. Please see more information about the study here: https://cls.ucl.ac.uk/cls-studies/1970-british-cohort-study/

Data access via UK Data Service: https://datacatalogue.ukdataservice.ac.uk/series/series/200001#abstract

## USAGE

*Quick start

To reproduce all analyses:
1) Clone or download this repository
2) Download relevant data from UK Data Service
3) Open Stata and set the working directory (including the relevant data files)
4) Run the master do-file:
   <!-- -->

    source("0_social_inequalities_miscarriage_BCS70_master.do")

*Running Individual Do-files

Data preparation/recoding:

source("1a_social_inequalities_miscarriage_BCS70_preparation_response.do")
source("1b_social_inequalities_miscarriage_BCS70_preparation_sweep4.do")
source("1c_social_inequalities_miscarriage_BCS70_preparation_sweep5.do")
source("1d_social_inequalities_miscarriage_BCS70_preparation_sweep6.do")
source("1e_social_inequalities_miscarriage_BCS70_preparation_sweep7.do")
source("1f_social_inequalities_miscarriage_BCS70_preparation_sweep8.do")
source("1g_social_inequalities_miscarriage_BCS70_preparation_sweep9.do")
source("1h_social_inequalities_miscarriage_BCS70_preparation_combined.do")

Statistical analyses:

source("2_social_inequalities_miscarriage_BCS70_analyses.do")

Note: Scripts should be run in the order specified in 0_social_inequalities_miscarriage_BCS70_master.do as later scripts may depend on outputs from earlier ones.

## FILE DESCRIPTIONS
Master Script

    source("0_social_inequalities_miscarriage_BCS70_master.do") # - Coordinates execution of all recoding and analysis do-files in the correct sequence

# Recoding Scripts

source("1a_social_inequalities_miscarriage_BCS70_preparation_response.do") # - creates the base that is used to build the relevant datafile
source("1b_social_inequalities_miscarriage_BCS70_preparation_sweep4.do") # - extracts the relevant variables from sweep 4 and combines them to the main datafile
source("1c_social_inequalities_miscarriage_BCS70_preparation_sweep5.do") # - extracts the relevant variables from sweep 5 and combines them to the main datafile
source("1d_social_inequalities_miscarriage_BCS70_preparation_sweep6.do") # - extracts the relevant variables from sweep 6 and combines them to the main datafile
source("1e_social_inequalities_miscarriage_BCS70_preparation_sweep7.do") # - extracts the relevant variables from sweep 7 and combines them to the main datafile
source("1f_social_inequalities_miscarriage_BCS70_preparation_sweep8.do") # - extracts the relevant variables from sweep 8 and combines them to the main datafile
source("1g_social_inequalities_miscarriage_BCS70_preparation_sweep9.do") # - extracts the relevant variables from sweep 9 and combines them to the main datafile
source("1h_social_inequalities_miscarriage_BCS70_preparation_combined.do") # - delets variables not used, recodes variables for analysis

# Analysis Scripts

source("2_social_inequalities_miscarriage_BCS70_analyses.do") # - runs the descriptive statistics and multi-level discrete-time event-history models used in this paper

## LICENSE

This code is made available for research purposes. Please cite our paper if you use or adapt this code.

## CONTACT

For questions about the code or analysis, please contact:

Heini Väisänen
Email: heini.vaisanen@ined.fr

## ACKNOWLEDGEMENTS

This work was funded by the European Union (ERC, SOC-MISC, Grant agreement ID: 101077594). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council Executive Agency. Neither the European Union nor the granting authority can be held responsible for them.
