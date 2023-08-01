*script name: cdmm_6.do
*script author: Teri North
*date created: 7.5.20
*date last edited: 09.02.22
*script purpose: defines the UKBB 'assessment centre' morbidities as per the Cambridge MM Score (Payne et al., 2020)
*notes: Payne et al. 2020 table A3.2 provides definitions of the morbidities and here we match as closely as possible using the 
*		data available from the UKBB baseline assessment centre. 
*CMAJ February 03, 2020 192 (5) E107-E114; DOI: https://doi.org/10.1503/cmaj.190757



cd 


******Morbidities based on read code ever recorded******

*******************
*Alcohol problems *
*******************

gen alcohol_problems_0=0
replace alcohol_problems_0=1 if alcohol_depen_0_20002==1


*********************
*Anorexia or bulimia*
*********************

gen anorexia_or_bulimia_0=0
replace anorexia_or_bulimia_0=1 if anorex_bulim_otheatdis_0_20002==1


*********************
*Atrial fibrillation*
*********************

gen atrial_fib_0=0
replace atrial_fib_0=1 if a_fib_0_20002==1
replace atrial_fib_0=1 if a_flutter_0_20002==1


**************************
*Blindness and low vision*
**************************




****************
*Bronchiectasis*
****************

gen bronchiecta_0=0
replace bronchiecta_0=1 if bronchiectasis_0_20002==1



*******************************************
*Chronic liver disease and viral hepatitis*
*******************************************


gen chron_livdis_viralhep_0=0
replace chron_livdis_viralhep_0=1 if hepatitis_0_20002==1
replace chron_livdis_viralhep_0=1 if inf_vir_hepatitis_0_20002==1
replace chron_livdis_viralhep_0=1 if non_inf_hepatitis_0_20002==1
replace chron_livdis_viralhep_0=1 if liver_failure_cirrhosis_0_20002==1
*replace chron_livdis_viralhep_0=1 if hep_a_0_20002==1
replace chron_livdis_viralhep_0=1 if hep_b_0_20002==1
replace chron_livdis_viralhep_0=1 if hep_c_0_20002==1
*replace chron_livdis_viralhep_0=1 if hep_d_0_20002==1 
*replace chron_livdis_viralhep_0=1 if hep_e_0_20002==1
replace chron_livdis_viralhep_0=1 if alc_liver_dis_alc_cirrho_0_20002==1
replace chron_livdis_viralhep_0=1 if primary_biliary_cirr_0_20002==1


*******************
*Chronic sinusitis*
*******************


gen chron_sinusitis_0=0
replace chron_sinusitis_0=1 if chronic_sinusitis_0_20002==1
replace chron_sinusitis_0=1 if nas_polyps_0_20002==1
replace chron_sinusitis_0=1 if nas_sin_disord_0_20002==1


******
*COPD*
******

gen chronic_obs_pul_dis_0=0
replace chronic_obs_pul_dis_0=1 if copd_0_20002==1
replace chronic_obs_pul_dis_0=1 if emphysema_chronic_bron_0_20002==1
replace chronic_obs_pul_dis_0=1 if emphysema_0_20002==1
replace chronic_obs_pul_dis_0=1 if n_6152_0_0==6
replace chronic_obs_pul_dis_0=1 if n_6152_0_1==6
replace chronic_obs_pul_dis_0=1 if n_6152_0_2==6
replace chronic_obs_pul_dis_0=1 if n_6152_0_3==6
replace chronic_obs_pul_dis_0=1 if n_6152_0_4==6


************************
*Coronary heart disease*
************************

gen chd_0=0
replace chd_0=1 if angina_0_20002==1
replace chd_0=1 if heartattack_mi_0_20002==1
replace chd_0=1 if n_6150_0_0==1|n_6150_0_0==2
replace chd_0=1 if n_6150_0_1==1|n_6150_0_1==2
replace chd_0=1 if n_6150_0_2==1|n_6150_0_2==2
replace chd_0=1 if n_6150_0_3==1|n_6150_0_3==2
replace chd_0=1 if cardiomyop_0_20002==1
replace chd_0=1 if hypertroph_cardiomyop_0_20002==1
replace chd_0=1 if aortic_aneurysm_0_20002==1
replace chd_0=1 if aort_an_rupt_0_20002==1
replace chd_0=1 if aort_valve_dis_0_20002==1
replace chd_0=1 if aortic_regurg_incom_0_20002==1


**********
*Dementia*
**********

gen dementia_0=0
replace dementia_0=1 if dementia_alz_cogimp_0_20002==1



***********
*Diabetes *
***********

gen diab_0=0
replace diab_0=1 if diab_eye_dis_0_20002==1
replace diab_0=1 if n_2443_0_0==1
replace diab_0=1 if diabetes_0_20002==1
replace diab_0=1 if diab_neuropath_ulcers_0_20002==1
replace diab_0=1 if diab_nephropathy_0_20002==1



*************************************
*Diverticular disease of intestine  *
*************************************

gen diverticular_dis_0=0
replace diverticular_dis_0=1 if diverticular_0_20002==1


**************
*Hearing loss*
**************

gen hearing_loss_0=0
replace hearing_loss_0=1 if n_2247_0_0==99 
replace hearing_loss_0=1 if n_3393_0_0==1
replace hearing_loss_0=1 if n_2257_0_0==1
replace hearing_loss_0=1 if otosclerosis_0_20002==1
replace hearing_loss_0=1 if meniere_0_20002==1



***************
*Heart failure*
***************

gen heart_failure_0=0
replace heart_failure_0=1 if heartfail_pulodema_0_20002==1



**************
*Hypertension*
**************

gen hyperten_0=0
replace hyperten_0=1 if hypertension_0_20002==1
replace hyperten_0=1 if n_6150_0_0==4
replace hyperten_0=1 if n_6150_0_1==4
replace hyperten_0=1 if n_6150_0_2==4
replace hyperten_0=1 if n_6150_0_3==4


****************************
*Inflammatory bowel disease*
****************************

gen IBD_0=0
replace IBD_0=1 if inflam_bowel_dis_0_20002==1
replace IBD_0=1 if crohns_0_20002==1
replace IBD_0=1 if ulcerative_col_0_20002==1
replace IBD_0=1 if colitis_ntcrohn_ntulcera_0_20002==1


*********************
*Learning disability*
*********************




********************
*Multiple sclerosis*
********************

gen multiple_sclerosis_0=0
replace multiple_sclerosis_0=1 if ms_0_20002==1



*********************
*Parkinson's disease*
*********************

gen parkinsons_dis_0=0
replace parkinsons_dis_0=1 if parkinsons_0_20002==1


**********************
*Peptic ulcer disease*
**********************


gen peptic_ulcer_dis_0=0
replace peptic_ulcer_dis_0=1 if peptic_ulcer_0_20002==1
replace peptic_ulcer_dis_0=1 if duodenal_ul_0_20002==1
replace peptic_ulcer_dis_0=1 if gas_stom_ulcers_0_20002==1



*****************************
*Peripheral vascular disease*
*****************************


gen peripheral_vas_dis_0=0
replace peripheral_vas_dis_0=1 if pvd_0_20002==1
replace peripheral_vas_dis_0=1 if claudication_0_20002==1


********************
*Prostate disorders*
********************

gen prostate_disorder_0=0
replace prostate_disorder_0=1 if prostate_notcancer_0_20002==1
replace prostate_disorder_0=1 if enlarged_prostate_0_20002==1
replace prostate_disorder_0=1 if bph_0_20002==1
replace prostate_disorder_0=1 if prostatitis_0_20002==1


**********************************************
*Psychoactive substance misuse (not alcohol) *
**********************************************

gen psychoactive_sub_misuse_0=0
replace psychoactive_sub_misuse_0=1 if opioid_depen_0_20002==1
replace psychoactive_sub_misuse_0=1 if oth_subst_abuse_depen_0_20002==1


***************************************************************************************************
*Rheumatoid arthritis, other inflammatory polyarthropathies & systemic connective tissue disorders*
***************************************************************************************************

gen RA_inflam_polyarth_SCTD_0=0
replace RA_inflam_polyarth_SCTD_0=1 if ctd_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if rheumatoid_arth_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if sle_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if psoriatic_arthropathy_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if ankylosing_spond_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if polymyalgia_rheumatica_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if myositis_myopathy_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if dermatopolymyositis_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if dermatomyositis_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if polymyositis_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if sclerod_sys_sclerosis_0_20002==1
replace RA_inflam_polyarth_SCTD_0=1 if vasculitis_0_20002==1



****************
*Stroke and TIA*
****************

gen stroke_and_TIA_0=0
replace stroke_and_TIA_0=1 if stroke_TIA_0_20002==1
replace stroke_and_TIA_0=1 if isch_stroke_0_20002==1
replace stroke_and_TIA_0=1 if n_6150_0_0==3
replace stroke_and_TIA_0=1 if n_6150_0_1==3
replace stroke_and_TIA_0=1 if n_6150_0_2==3
replace stroke_and_TIA_0=1 if n_6150_0_3==3
replace stroke_and_TIA_0=1 if brain_haem_0_20002==1


*******************
*Thyroid disorders*
*******************

gen thyroid_disorders_0=0
replace thyroid_disorders_0=1 if hypothyroid_myxoed_0_20002==1
replace thyroid_disorders_0=1 if hyperthyroid_thyrotoxico_0_20002==1
replace thyroid_disorders_0=1 if thyroid_goitre_0_20002==1
replace thyroid_disorders_0=1 if graves_0_20002==1


***Morbidities based on prescription in last 12 months***

**************
*Constipation*
**************


gen constip_0=0
replace constip_0=1 if constipation_0_20002==1
replace constip_0=1 if n_6154_0_0==6
replace constip_0=1 if n_6154_0_1==6
replace constip_0=1 if n_6154_0_2==6
replace constip_0=1 if n_6154_0_3==6
replace constip_0=1 if n_6154_0_4==6
replace constip_0=1 if n_6154_0_5==6

**********
*Migraine*
**********

gen migr_0=0
replace migr_0=1 if migraine_0_20002==1


***Morbidties based on combination of Read code ever recorded and/or prescription in last 12 months***

***********
*Epilepsy * 
***********

gen epil_0=0
replace epil_0=1 if epilepsy_0_20002==1


*********
*Asthma *
*********

gen asth_0=0
replace asth_0=1 if asthma_0_20002==1
replace asth_0=1 if n_6152_0_0==8
replace asth_0=1 if n_6152_0_1==8
replace asth_0=1 if n_6152_0_2==8
replace asth_0=1 if n_6152_0_3==8
replace asth_0=1 if n_6152_0_4==8


**************************
*Irritable bowel syndrome*
**************************

gen irritable_bowel_syn_0=0
replace irritable_bowel_syn_0=1 if IBS_0_20002==1


*********************
*Psoriasis or Eczema*
*********************

gen psoriasis_eczema_0=0
replace psoriasis_eczema_0=1 if eczema_dermatitis_0_20002==1
replace psoriasis_eczema_0=1 if psoriasis_0_20002==1
replace psoriasis_eczema_0=1 if contact_dermat_0_20002==1


***Morbidities otherwise defined***

***********************************************************************************
*Anxiety and other neurotic, stress related and somatoform disorders OR depression*
***********************************************************************************

gen anx_neur_stress_somato_depr_0=0
replace anx_neur_stress_somato_depr_0=1 if n_2090_0_0==1
replace anx_neur_stress_somato_depr_0=1 if n_2100_0_0==1
replace anx_neur_stress_somato_depr_0=1 if ptsd_0_20002==1
replace anx_neur_stress_somato_depr_0=1 if ocd_0_20002==1
*replace anx_neur_stress_somato_depr_0=1 if pnd_0_20002==1
replace anx_neur_stress_somato_depr_0=1 if depression_0_20002==1
replace anx_neur_stress_somato_depr_0=1 if anxiety_panic_att_0_20002==1
replace anx_neur_stress_somato_depr_0=1 if nervous_breakdn_0_20002==1

**********************************************************************************
*Cancer - [New] Diagnosis in last five years (excluding non-melanoma skin cancer)*
**********************************************************************************

*colL5Y_n_20001_0 - variable derived in cdmm_5, -99999 is missing code


gen cancer_5_yrs_0=0
replace cancer_5_yrs=1 if colL5Y_n_20001_0==1
replace cancer_5_yrs=. if colL5Y_n_20001_0==-99999


*************************
*Chronic kidney disease *
*************************

gen chronic_kid_dis_0=0
replace chronic_kid_dis_0=1 if renal_kidney_failure_0_20002==1
replace chronic_kid_dis_0=1 if renal_failure_dial_0_20002==1
replace chronic_kid_dis_0=1 if renal_failure_nodial_0_20002==1
replace chronic_kid_dis_0=1 if kidney_neph_0_20002==1
replace chronic_kid_dis_0=1 if diab_nephropathy_0_20002==1


*******************
*Painful condition*
*******************

gen painful_cond_0=0
forvalues i = 0/5 {
	*replace painful_cond_0=1 if n_6154_0_`i'==1
	replace painful_cond_0=1 if n_6154_0_`i'==2
	replace painful_cond_0=1 if n_6154_0_`i'==3
}


************************************************************************
*Schizophrenia (and related non-organic psychosis) or bipolar disorder *
************************************************************************


gen schiz_bipol_0=0
replace schiz_bipol_0=1 if schizophrenia_0_20002==1
replace schiz_bipol_0=1 if mania_bipol_manicdp_0_20002==1


*************************************************
*save self reported & baseline variables dataset*
*************************************************

keep n_eid n_31_0_0 n_54_0_0 hyperten_0 anx_neur_stress_somato_depr_0 painful_cond_0 hearing_loss_0 irritable_bowel_syn_0 asth_0 diab_0 prostate_disorder_0 thyroid_disorders_0  chd_0 chronic_kid_dis_0 diverticular_dis_0 chron_sinusitis_0 atrial_fib_0 constip_0 stroke_and_TIA_0 chronic_obs_pul_dis_0 RA_inflam_polyarth_SCTD_0 cancer_5_yrs_0 peptic_ulcer_dis_0 alcohol_problems_0 psychoactive_sub_misuse_0 psoriasis_eczema_0 heart_failure_0 dementia_0 schiz_bipol_0 epil_0 IBD_0 peripheral_vas_dis_0 anorexia_or_bulimia_0 chron_livdis_viralhep_0 migr_0 bronchiecta_0 multiple_sclerosis_0 parkinsons_dis_0 n_54_0_0 n_31_0_0 n_21003_0_0 n_21001_0_0 n_22009_0_* n_1568_0_0 n_1578_0_0 n_1588_0_0 n_1598_0_0 n_1608_0_0 n_5364_0_0 n_3731_0_0 n_20117_0_0 n_6138_0_*

save "$xxx\self_report_phenotypes.dta", replace
clear
 


