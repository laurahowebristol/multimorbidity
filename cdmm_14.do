*script name: cdmm_14.do
*script author: Teri North
*date created: 11.9.20
*date last edited: 7.4.21
*script purpose: create interaction variables
*notes:


use "$xxxxxxx\self_report_phenotypes_v5.dta", clear

*make interaction variables for each pairwise combination of exposures

generate phe_bmi_smok_1=phe_bmi_1*phe_lifetime_smoking_1
generate phe_bmi_smok_2=phe_bmi_2*phe_lifetime_smoking_2
generate phe_bmi_smok=phe_bmi*phe_lifetime_smoking

generate phe_bmi_alc_1=phe_bmi_1*phe_alcohol_intake_1
generate phe_bmi_alc_2=phe_bmi_2*phe_alcohol_intake_2
generate phe_bmi_alc=phe_bmi*phe_alcohol_intake

generate phe_bmi_edu_1=phe_bmi_1*phe_eduyears_scaled_1
generate phe_bmi_edu_2=phe_bmi_2*phe_eduyears_scaled_2
generate phe_bmi_edu=phe_bmi*phe_eduyears_scaled

generate phe_smok_alc_1=phe_lifetime_smoking_1*phe_alcohol_intake_1
generate phe_smok_alc_2=phe_lifetime_smoking_2*phe_alcohol_intake_2
generate phe_smok_alc=phe_lifetime_smoking*phe_alcohol_intake

generate phe_smok_edu_1=phe_lifetime_smoking_1*phe_eduyears_scaled_1
generate phe_smok_edu_2=phe_lifetime_smoking_2*phe_eduyears_scaled_2
generate phe_smok_edu=phe_lifetime_smoking*phe_eduyears_scaled

generate phe_alc_edu_1=phe_alcohol_intake_1*phe_eduyears_scaled_1
generate phe_alc_edu_2=phe_alcohol_intake_2*phe_eduyears_scaled_2
generate phe_alc_edu=phe_alcohol_intake*phe_eduyears_scaled


save "$xxxxxxx\self_report_phenotypes_v5.dta", replace




