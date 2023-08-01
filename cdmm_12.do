*script name: cdmm_12.do
*script author: Teri North
*date created: 24.8.20
*date last edited: 10.2.22
*script purpose: define exposures, outcomes and covariates for analysis - using baseline assessment centre variables

cd 
use "$xxx\self_report_phenotypes.dta", clear

*age at baseline biobank (age when attended assessment centre)
rename n_21003_0_0 age

*sex 
rename n_31_0_0 sex

*genetic principal components
forvalues i=1/40 {
	rename n_22009_0_`i' pc`i'
}

*recruitment centre
rename n_54_0_0 centre

*alcohol intake

foreach var of varlist n_1568_0_0 n_1578_0_0 n_1588_0_0 n_1598_0_0 n_1608_0_0 n_5364_0_0 {
	replace `var' = . if `var' < 0
}

foreach var of varlist n_1568_0_0 n_1578_0_0 n_1588_0_0 n_1598_0_0 n_1608_0_0 n_5364_0_0 {
	gen x_`var' = 0 if `var' == .
	replace x_`var' = `var' if `var' != .
}

gen phe_alcohol_intake = x_n_1568_0_0*1.75 + x_n_1578_0_0*1.75 + x_n_1588_0_0*2 + x_n_1598_0_0*1 + x_n_1608_0_0*1.2 + x_n_5364_0_0*1

foreach var of varlist n_1568_0_0 n_1578_0_0 n_1588_0_0 n_1598_0_0 n_1608_0_0 n_5364_0_0 {
	drop x_`var'
}

*Remove former drinkers
replace phe_alcohol_intake = . if n_3731_0_0 == 1

*Remove excess numbers of units (>200)
replace phe_alcohol_intake = . if phe_alcohol_intake >= 200

*Replace missing if ALL drinks are missing
replace phe_alcohol_intake = . if n_1568_0_0 == . & n_1578_0_0 == . & n_1588_0_0 == . & n_1598_0_0 == . & n_1608_0_0 == . & n_5364_0_0==.

*Re-fill those who said they don't drink
replace phe_alcohol_intake = 0 if n_20117_0_0 == 0

*Re-scale - divide by 5
replace phe_alcohol_intake = phe_alcohol_intake/5

label variable phe_alcohol_intake "5 units of alcohol per week, from weekly details, missing values set to 0"




*BMI
rename n_21001_0_0 phe_bmi

*Re-scale - divide by 5
replace phe_bmi = phe_bmi/5

label variable phe_bmi "5 BMI units (kg/m2)"


*(education) years of schooling 
//Clean years of full time education
//Use Okbay et al. (Nature. 2016;533:539) method for defining years of education

gen eduyears=.
ds n_6138_0_* 
foreach i in `r(varlist)'{
	replace eduyears=20 if `i'==1
	replace eduyears=19 if `i'==5 & (eduyears<19|eduyears==.) 
	replace eduyears=15 if `i'==6 & (eduyears<15|eduyears==.)
	replace eduyears=13 if `i'==2 & (eduyears<13|eduyears==.)
	replace eduyears=10 if (`i'==3|`i'==4) & (eduyears<10|eduyears==.)
	replace eduyears=7 if `i'==-7 & (eduyears<7|eduyears==.)
	}



sum eduyears
return list
di r(sd)
gen eduyears_scaled=(eduyears/r(sd)) 

rename eduyears_scaled phe_eduyears_scaled

*update self report dataset
save "$xxx\self_report_phenotypes.dta", replace
clear

*lifetime smoking index
cd 
rsource using "Creating_lifetime_smoking_phenotype_revision_1_tlneditv2.R", rpath(`"xxxxxx"') roptions(`"--vanilla"')
cd 

clear
import delimited using lifetime_smoking_phenotype_Feb22.csv
rename dataid n_eid
replace datacsi="" if datacsi=="NA"
destring datacsi, generate(phe_lifetime_smoking)
drop datacsi
merge 1:1 n_eid using "$xxx\self_report_phenotypes.dta"
keep if _merge==3
drop _merge

*Re-scale smoking exposure - lifetime smoking index / sd
sum phe_lifetime_smoking
return list
di r(sd)
replace phe_lifetime_smoking = phe_lifetime_smoking/r(sd)

*update self report dataset (now includes exposures and covariates)
save "$xxx\self_report_phenotypes.dta", replace
clear

*****************
*Define outcomes*
*****************
/*note that the no alcohol outcomes are defined as missing even if the alcohol variable is missing, so that we have them in the same individuals as the main outcome variables*/

**SELF REPORT DATA**
use "$xxx\self_report_phenotypes.dta", clear

*blindness_low_vision & learning_disability not included (2/37 conditions)

local condition_list `" "hyperten_0" "anx_neur_stress_somato_depr_0" "painful_cond_0" "hearing_loss_0" "irritable_bowel_syn_0" "asth_0" "diab_0" "prostate_disorder_0" "thyroid_disorders_0" "chd_0" "chronic_kid_dis_0" "diverticular_dis_0" "chron_sinusitis_0" "atrial_fib_0" "constip_0" "stroke_and_TIA_0" "chronic_obs_pul_dis_0" "RA_inflam_polyarth_SCTD_0" "cancer_5_yrs_0" "peptic_ulcer_dis_0" "alcohol_problems_0" "psychoactive_sub_misuse_0" "psoriasis_eczema_0" "heart_failure_0" "dementia_0" "schiz_bipol_0" "epil_0" "IBD_0" "peripheral_vas_dis_0" "anorexia_or_bulimia_0" "chron_livdis_viralhep_0" "migr_0" "bronchiecta_0" "multiple_sclerosis_0" "parkinsons_dis_0" "'

*multimorbidity count
gen multimorbid_SR_count=0
replace multimorbid_SR_count=. if (hyperten_0==. | anx_neur_stress_somato_depr_0==. | painful_cond_0==. | hearing_loss_0==. | irritable_bowel_syn_0==. | asth_0==. | diab_0==. | prostate_disorder_0==. | thyroid_disorders_0==. | chd_0==. | chronic_kid_dis_0==. | diverticular_dis_0==. | chron_sinusitis_0==. | atrial_fib_0==. | constip_0==. | stroke_and_TIA_0==. | chronic_obs_pul_dis_0==. | RA_inflam_polyarth_SCTD_0==. | cancer_5_yrs_0==. | peptic_ulcer_dis_0==. | alcohol_problems_0==. | psychoactive_sub_misuse_0==. | psoriasis_eczema_0==. | heart_failure_0==. | dementia_0==. | schiz_bipol_0==. | epil_0==. | IBD_0==. | peripheral_vas_dis_0==. | anorexia_or_bulimia_0==. | chron_livdis_viralhep_0==. | migr_0==. | bronchiecta_0==. | multiple_sclerosis_0==. | parkinsons_dis_0==.)
count if multimorbid_SR_count==.
foreach z in `condition_list' {
	replace multimorbid_SR_count=multimorbid_SR_count+1 if `z'==1
}
count if multimorbid_SR_count==.

*repeat excl alcohol for the alcohol exposures
local alc_condition_list `" "hyperten_0" "anx_neur_stress_somato_depr_0" "painful_cond_0" "hearing_loss_0" "irritable_bowel_syn_0" "asth_0" "diab_0" "prostate_disorder_0" "thyroid_disorders_0" "chd_0" "chronic_kid_dis_0" "diverticular_dis_0" "chron_sinusitis_0" "atrial_fib_0" "constip_0" "stroke_and_TIA_0" "chronic_obs_pul_dis_0" "RA_inflam_polyarth_SCTD_0" "cancer_5_yrs_0" "peptic_ulcer_dis_0" "psychoactive_sub_misuse_0" "psoriasis_eczema_0" "heart_failure_0" "dementia_0" "schiz_bipol_0" "epil_0" "IBD_0" "peripheral_vas_dis_0" "anorexia_or_bulimia_0" "chron_livdis_viralhep_0" "migr_0" "bronchiecta_0" "multiple_sclerosis_0" "parkinsons_dis_0" "'

*multimorbidity count
gen multimorbid_SRnoalc_count=0
replace multimorbid_SRnoalc_count=. if (hyperten_0==. | anx_neur_stress_somato_depr_0==. | painful_cond_0==. | hearing_loss_0==. | irritable_bowel_syn_0==. | asth_0==. | diab_0==. | prostate_disorder_0==. | thyroid_disorders_0==. | chd_0==. | chronic_kid_dis_0==. | diverticular_dis_0==. | chron_sinusitis_0==. | atrial_fib_0==. | constip_0==. | stroke_and_TIA_0==. | chronic_obs_pul_dis_0==. | RA_inflam_polyarth_SCTD_0==. | cancer_5_yrs_0==. | peptic_ulcer_dis_0==. | alcohol_problems_0==. | psychoactive_sub_misuse_0==. | psoriasis_eczema_0==. | heart_failure_0==. | dementia_0==. | schiz_bipol_0==. | epil_0==. | IBD_0==. | peripheral_vas_dis_0==. | anorexia_or_bulimia_0==. | chron_livdis_viralhep_0==. | migr_0==. | bronchiecta_0==. | multiple_sclerosis_0==. | parkinsons_dis_0==.)
count if multimorbid_SRnoalc_count==.
foreach z in `alc_condition_list' {
	replace multimorbid_SRnoalc_count=multimorbid_SRnoalc_count+1 if `z'==1
}
count if multimorbid_SRnoalc_count==.


/*2+ diseases*/

gen multimorbid_SR_2=.
replace multimorbid_SR_2=0 if multimorbid_SR_count==0|multimorbid_SR_count==1
replace multimorbid_SR_2=1 if multimorbid_SR_count>=2 & multimorbid_SR_count<.
rename multimorbid_SR_2 out_multimorbid_SR_2 

gen multimorbid_SRnoalc_2=.
replace multimorbid_SRnoalc_2=0 if multimorbid_SRnoalc_count==0|multimorbid_SRnoalc_count==1
replace multimorbid_SRnoalc_2=1 if multimorbid_SRnoalc_count>=2 & multimorbid_SRnoalc_count<.
rename multimorbid_SRnoalc_2 out_multimorbid_SRnoalc_2

/*3+ diseases*/

gen multimorbid_SR_3=.
replace multimorbid_SR_3=0 if multimorbid_SR_count==0|multimorbid_SR_count==1|multimorbid_SR_count==2
replace multimorbid_SR_3=1 if multimorbid_SR_count>=3 & multimorbid_SR_count<.
rename multimorbid_SR_3 out_multimorbid_SR_3

gen multimorbid_SRnoalc_3=.
replace multimorbid_SRnoalc_3=0 if multimorbid_SRnoalc_count==0|multimorbid_SRnoalc_count==1|multimorbid_SRnoalc_count==2
replace multimorbid_SRnoalc_3=1 if multimorbid_SRnoalc_count>=3 & multimorbid_SRnoalc_count<.
rename multimorbid_SRnoalc_3 out_multimorbid_SRnoalc_3



/*4+ diseases*/

gen multimorbid_SR_4=.
replace multimorbid_SR_4=0 if multimorbid_SR_count==0|multimorbid_SR_count==1|multimorbid_SR_count==2|multimorbid_SR_count==3
replace multimorbid_SR_4=1 if multimorbid_SR_count>=4 & multimorbid_SR_count<.
rename multimorbid_SR_4 out_multimorbid_SR_4

gen multimorbid_SRnoalc_4=.
replace multimorbid_SRnoalc_4=0 if multimorbid_SRnoalc_count==0|multimorbid_SRnoalc_count==1|multimorbid_SRnoalc_count==2|multimorbid_SRnoalc_count==3
replace multimorbid_SRnoalc_4=1 if multimorbid_SRnoalc_count>=4 & multimorbid_SRnoalc_count<.
rename multimorbid_SRnoalc_4 out_multimorbid_SRnoalc_4



/*multimorbidity index*/
/*Coefficients from Appendix 5 Payne et al 2020. General outcome weights*/
*should be missing value if any of the condition variables are missing*
*https://doi.org/10.1503/cmaj.190757
gen multimorb_index_SR=.
replace multimorb_index_SR=hyperten_0*0.09+ ///
anx_neur_stress_somato_depr_0*0.47+ ///
painful_cond_0*0.87+ ///
hearing_loss_0*0.07+ ///
irritable_bowel_syn_0*0.18+ ///
asth_0*0.18+ ///
diab_0*0.71+ ///
prostate_disorder_0*0.01+ ///
thyroid_disorders_0*0.08+ ///
chd_0*0.46+ ///
chronic_kid_dis_0*0.51+ ///
(diverticular_dis_0*-0.02)+ ///
chron_sinusitis_0*0.13+ ///
atrial_fib_0*1.30+ ///
constip_0*1.03+ ///
stroke_and_TIA_0*0.77+ ///
chronic_obs_pul_dis_0*1.41+ ///
RA_inflam_polyarth_SCTD_0*0.40+ ///
cancer_5_yrs_0*1.50+ ///
peptic_ulcer_dis_0*0.20+ ///
alcohol_problems_0*0.55+ ///
psychoactive_sub_misuse_0*0.38+ ///
psoriasis_eczema_0*0.25+ ///
heart_failure_0*1.12+ ///
dementia_0*2.46+ ///
schiz_bipol_0*0.58+ ///
epil_0*0.85+ ///
IBD_0*0.44+ ///
peripheral_vas_dis_0*0.53+ ///
anorexia_or_bulimia_0*0.34+ ///
chron_livdis_viralhep_0*0.72+ ///
migr_0*0.07+ ///
bronchiecta_0*0.66+ ///
multiple_sclerosis_0*0.69+ ///
parkinsons_dis_0*1.29

hist multimorb_index_SR //non-normal distn
rename multimorb_index_SR out_multimorb_index_SR


*repeat excl alcohol for the alcohol exposure
gen multimorb_index_noalcSR=.
replace multimorb_index_noalcSR=hyperten_0*0.09+ ///
anx_neur_stress_somato_depr_0*0.47+ ///
painful_cond_0*0.87+ ///
hearing_loss_0*0.07+ ///
irritable_bowel_syn_0*0.18+ ///
asth_0*0.18+ ///
diab_0*0.71+ ///
prostate_disorder_0*0.01+ ///
thyroid_disorders_0*0.08+ ///
chd_0*0.46+ ///
chronic_kid_dis_0*0.51+ ///
(diverticular_dis_0*-0.02)+ ///
chron_sinusitis_0*0.13+ ///
atrial_fib_0*1.30+ ///
constip_0*1.03+ ///
stroke_and_TIA_0*0.77+ ///
chronic_obs_pul_dis_0*1.41+ ///
RA_inflam_polyarth_SCTD_0*0.40+ ///
cancer_5_yrs_0*1.50+ ///
peptic_ulcer_dis_0*0.20+ ///
psychoactive_sub_misuse_0*0.38+ ///
psoriasis_eczema_0*0.25+ ///
heart_failure_0*1.12+ ///
dementia_0*2.46+ ///
schiz_bipol_0*0.58+ ///
epil_0*0.85+ ///
IBD_0*0.44+ ///
peripheral_vas_dis_0*0.53+ ///
anorexia_or_bulimia_0*0.34+ ///
chron_livdis_viralhep_0*0.72+ ///
migr_0*0.07+ ///
bronchiecta_0*0.66+ ///
multiple_sclerosis_0*0.69+ ///
parkinsons_dis_0*1.29

replace multimorb_index_noalcSR=. if alcohol_problems_0==.

hist multimorb_index_noalcSR //non-normal distn
rename multimorb_index_noalcSR out_multimorb_index_noalcSR

*overwrite dataset to include new variables
save "$xxx\self_report_phenotypes.dta", replace
clear

