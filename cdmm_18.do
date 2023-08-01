*script name: cdmm_18.do
*script author: Teri North
*date created: 23.7.21
*date last edited: 3.3.22
*script purpose: Obtain various summary stats for paper

cd 
use "xxxxxxxx\self_report_phenotypes_v5.dta", clear


//ABSTRACT

tab main_dataset sex, missing
count if sex==1 // male
count if sex==0 // female


*age stratified by sex
tab main_dataset, missing


sum age if sex==1 // male

sum age if sex==0 // female

clear
//

//CONDITION % BREAKDOWN

use "$xxxxxxxx\self_report_phenotypes_v5.dta", clear
keep if main_dataset==1
keep id_ieu

merge 1:1 id_ieu using "$xxxxxxx\linker2.dta"
keep if _merge==3
drop _merge

rename id_phe n_eid
merge 1:1 n_eid using "$XXXXXXXXX\self_report_phenotypes.dta"
keep if _merge==3

keep hyperten_0 anx_neur_stress_somato_depr_0 painful_cond_0 hearing_loss_0 irritable_bowel_syn_0 asth_0 diab_0 prostate_disorder_0 thyroid_disorders_0 chd_0 ///
chronic_kid_dis_0 diverticular_dis_0 chron_sinusitis_0 atrial_fib_0 constip_0 stroke_and_TIA_0 chronic_obs_pul_dis_0 RA_inflam_polyarth_SCTD_0 cancer_5_yrs_0 ///
peptic_ulcer_dis_0 alcohol_problems_0 psychoactive_sub_misuse_0 psoriasis_eczema_0 heart_failure_0 dementia_0 schiz_bipol_0 epil_0 IBD_0 ///
peripheral_vas_dis_0 anorexia_or_bulimia_0 chron_livdis_viralhep_0 migr_0 bronchiecta_0 multiple_sclerosis_0 parkinsons_dis_0 

*make excel table for writing conditon %s
putexcel set condition_breakdown, replace sheet("condition_breakdown")
putexcel A1 = "Conditon"
putexcel B1 = "N"
putexcel C1 = "Percentage"

***
putexcel A2="Alcohol problems"
tab alcohol_problems_0, matcell(thismat)
local N=thismat[2,1]
putexcel B2="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C2="`perc'"
***
putexcel A3="Anorexia or bulimia"
tab anorexia_or_bulimia_0, matcell(thismat)
local N=thismat[2,1]
putexcel B3="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C3="`perc'"
***
putexcel A4="Atrial fibrillation"
tab atrial_fib_0, matcell(thismat)
local N=thismat[2,1]
putexcel B4="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C4="`perc'"

***
putexcel A5="Blindness and low vision"
***
putexcel A6="Bronchiectasis"
tab bronchiecta_0, matcell(thismat)
local N=thismat[2,1]
putexcel B6="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C6="`perc'"

***
putexcel A7="Chronic liver disease and viral hepatitis"
tab chron_livdis_viralhep_0, matcell(thismat)
local N=thismat[2,1]
putexcel B7="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C7="`perc'"

***
putexcel A8="Chronic sinusitis"
tab chron_sinusitis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B8="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C8="`perc'"

***
putexcel A9="COPD"
tab chronic_obs_pul_dis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B9="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C9="`perc'"

***
putexcel A10="Coronary heart disease"
tab chd_0, matcell(thismat)
local N=thismat[2,1]
putexcel B10="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C10="`perc'"

***
putexcel A11="Dementia"
tab dementia_0, matcell(thismat)
local N=thismat[2,1]
putexcel B11="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C11="`perc'"

***
putexcel A12="Diabetes"
tab diab_0, matcell(thismat)
local N=thismat[2,1]
putexcel B12="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C12="`perc'"

***
putexcel A13="Diverticular disease of intestine"
tab diverticular_dis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B13="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C13="`perc'"

***
putexcel A14="Hearing loss"
tab hearing_loss_0, matcell(thismat)
local N=thismat[2,1]
putexcel B14="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C14="`perc'"

***
putexcel A15="Heart failure"
tab heart_failure_0, matcell(thismat)
local N=thismat[2,1]
putexcel B15="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C15="`perc'"

***
putexcel A16="Hypertension"
tab hyperten_0, matcell(thismat)
local N=thismat[2,1]
putexcel B16="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C16="`perc'"

***
putexcel A17="Inflammatory bowel disease"
tab IBD_0, matcell(thismat)
local N=thismat[2,1]
putexcel B17="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C17="`perc'"

***
putexcel A18="Learning disability"
***
putexcel A19="Multiple sclerosis"
tab multiple_sclerosis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B19="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C19="`perc'"

***
putexcel A20="Parkinson's disease'"
tab parkinsons_dis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B20="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C20="`perc'"

***
putexcel A21="Peptic ulcer disease"
tab peptic_ulcer_dis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B21="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C21="`perc'"

***
putexcel A22="Peripheral vascular disease"
tab peripheral_vas_dis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B22="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C22="`perc'"

***
putexcel A23="Prostate disorders"
tab prostate_disorder_0, matcell(thismat)
local N=thismat[2,1]
putexcel B23="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C23="`perc'"

***
putexcel A24="Psychoactive substance misuse (not alcohol)"
tab psychoactive_sub_misuse_0, matcell(thismat)
local N=thismat[2,1]
putexcel B24="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C24="`perc'"

***
putexcel A25="Rheumatoid arthritis, other inflammatory polyarthropathies & systemic connective tissue disorders"
tab RA_inflam_polyarth_SCTD_0, matcell(thismat)
local N=thismat[2,1]
putexcel B25="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C25="`perc'"

***
putexcel A26="Stroke and TIA"
tab stroke_and_TIA_0, matcell(thismat)
local N=thismat[2,1]
putexcel B26="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C26="`perc'"

***
putexcel A27="Thyroid disorders"
tab thyroid_disorders_0, matcell(thismat)
local N=thismat[2,1]
putexcel B27="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C27="`perc'"

***
putexcel A28="Constipation "
tab constip_0, matcell(thismat)
local N=thismat[2,1]
putexcel B28="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C28="`perc'"

***
putexcel A29="Migraine"
tab migr_0, matcell(thismat)
local N=thismat[2,1]
putexcel B29="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C29="`perc'"

***
putexcel A30="Epilepsy"
tab epil_0, matcell(thismat)
local N=thismat[2,1]
putexcel B30="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C30="`perc'"

***
putexcel A31="Asthma"
tab asth_0, matcell(thismat)
local N=thismat[2,1]
putexcel B31="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C31="`perc'"

***
putexcel A32="Irritable bowel syndrome"
tab irritable_bowel_syn_0, matcell(thismat)
local N=thismat[2,1]
putexcel B32="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C32="`perc'"

***
putexcel A33="Psoriasis or Eczema"
tab psoriasis_eczema_0, matcell(thismat)
local N=thismat[2,1]
putexcel B33="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C33="`perc'"

***
putexcel A34="Anxiety and other neurotic, stress related and somatoform disorders OR depression"
tab anx_neur_stress_somato_depr_0, matcell(thismat)
local N=thismat[2,1]
putexcel B34="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C34="`perc'"

***
putexcel A35="Cancer - [New] diagnosis in last five years (excluding non-melanoma skin cancer)"
tab cancer_5_yrs_0, matcell(thismat)
local N=thismat[2,1]
putexcel B35="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C35="`perc'"

***
putexcel A36="Chronic kidney disease"
tab chronic_kid_dis_0, matcell(thismat)
local N=thismat[2,1]
putexcel B36="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C36="`perc'"

***
putexcel A37="Painful condition"
tab painful_cond_0, matcell(thismat)
local N=thismat[2,1]
putexcel B37="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C37="`perc'"

***
putexcel A38="Schizophrenia (and related non-organic psychosis) or bipolar disorder"
tab schiz_bipol_0, matcell(thismat)
local N=thismat[2,1]
putexcel B38="`N'"
local perc=round(100*(thismat[2,1]/(thismat[1,1]+thismat[2,1])),0.01)
putexcel C38="`perc'"


***
putexcel save
putexcel clear











