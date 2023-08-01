*script name: cdmm_13.do
*script author: Teri North
*date created: 06.9.20
*date last edited: 04.4.22
*script purpose: Complete data flag creation & data characterization tables
*notes: (1) Statistics for individual splits: exposures are still post-scaled values (e.g. divided by 5 etc) 


local edu_sd = 
local smok_sd = 
 
*****************************
*Complete data flag creation*
*****************************

*********
*split 1*
*********

use "$xxxxx\self_report_phenotypes_v3.dta", clear
gen main_dataset_1=0
replace main_dataset_1=1 if age_1!=. & sex_1!=. & pc1_1!=. & ///
pc2_1!=. & ///
pc3_1!=. & ///
pc4_1!=. & ///
pc5_1!=. & ///
pc6_1!=. & ///
pc7_1!=. & ///
pc8_1!=. & ///
pc9_1!=. & ///
pc10_1!=. & ///
pc11_1!=. & ///
pc12_1!=. & ///
pc13_1!=. & ///
pc14_1!=. & ///
pc15_1!=. & ///
pc16_1!=. & ///
pc17_1!=. & ///
pc18_1!=. & ///
pc19_1!=. & ///
pc20_1!=. & ///
pc21_1!=. & ///
pc22_1!=. & ///
pc23_1!=. & ///
pc24_1!=. & ///
pc25_1!=. & ///
pc26_1!=. & ///
pc27_1!=. & ///
pc28_1!=. & ///
pc29_1!=. & ///
pc30_1!=. & ///
pc31_1!=. & ///
pc32_1!=. & ///
pc33_1!=. & ///
pc34_1!=. & ///
pc35_1!=. & ///
pc36_1!=. & ///
pc37_1!=. & ///
pc38_1!=. & ///
pc39_1!=. & ///
pc40_1!=. & ///
centre_1!=. & ///
out_multimorbid_SR_2_1!=. & ///
out_multimorbid_SRnoalc_2_1!=. & ///
out_multimorbid_SR_3_1!=. & ///
out_multimorbid_SRnoalc_3_1!=. & ///
out_multimorbid_SR_4_1!=. & ///
out_multimorbid_SRnoalc_4_1!=. & ///
out_multimorb_index_SR_1!=. & ///
out_multimorb_index_noalcSR_1!=. & ///
((phe_alcohol_intake_1!=. & grs_alcohol2!=.)| ///
(phe_bmi_1!=. & grs_bmi2!=.)| ///
(phe_eduyears_scaled_1!=. & grs_education2!=.)| ///
(phe_lifetime_smoking_1!=. & grs_lifetime_smoking2!=.))

  
*double check numbers stratified by exposure

*alcohol
count if age_1!=. & sex_1!=. & pc1_1!=. & ///
pc2_1!=. & ///
pc3_1!=. & ///
pc4_1!=. & ///
pc5_1!=. & ///
pc6_1!=. & ///
pc7_1!=. & ///
pc8_1!=. & ///
pc9_1!=. & ///
pc10_1!=. & ///
pc11_1!=. & ///
pc12_1!=. & ///
pc13_1!=. & ///
pc14_1!=. & ///
pc15_1!=. & ///
pc16_1!=. & ///
pc17_1!=. & ///
pc18_1!=. & ///
pc19_1!=. & ///
pc20_1!=. & ///
pc21_1!=. & ///
pc22_1!=. & ///
pc23_1!=. & ///
pc24_1!=. & ///
pc25_1!=. & ///
pc26_1!=. & ///
pc27_1!=. & ///
pc28_1!=. & ///
pc29_1!=. & ///
pc30_1!=. & ///
pc31_1!=. & ///
pc32_1!=. & ///
pc33_1!=. & ///
pc34_1!=. & ///
pc35_1!=. & ///
pc36_1!=. & ///
pc37_1!=. & ///
pc38_1!=. & ///
pc39_1!=. & ///
pc40_1!=. & ///
centre_1!=. & ///
phe_alcohol_intake_1!=. & ///
out_multimorbid_SR_2_1!=. & ///
out_multimorbid_SRnoalc_2_1!=. & ///
out_multimorbid_SR_3_1!=. & ///
out_multimorbid_SRnoalc_3_1!=. & ///
out_multimorbid_SR_4_1!=. & ///
out_multimorbid_SRnoalc_4_1!=. & ///
out_multimorb_index_SR_1!=. & ///
out_multimorb_index_noalcSR_1!=. & ///
grs_alcohol2!=.

*smoking
count if age_1!=. & sex_1!=. & pc1_1!=. & ///
pc2_1!=. & ///
pc3_1!=. & ///
pc4_1!=. & ///
pc5_1!=. & ///
pc6_1!=. & ///
pc7_1!=. & ///
pc8_1!=. & ///
pc9_1!=. & ///
pc10_1!=. & ///
pc11_1!=. & ///
pc12_1!=. & ///
pc13_1!=. & ///
pc14_1!=. & ///
pc15_1!=. & ///
pc16_1!=. & ///
pc17_1!=. & ///
pc18_1!=. & ///
pc19_1!=. & ///
pc20_1!=. & ///
pc21_1!=. & ///
pc22_1!=. & ///
pc23_1!=. & ///
pc24_1!=. & ///
pc25_1!=. & ///
pc26_1!=. & ///
pc27_1!=. & ///
pc28_1!=. & ///
pc29_1!=. & ///
pc30_1!=. & ///
pc31_1!=. & ///
pc32_1!=. & ///
pc33_1!=. & ///
pc34_1!=. & ///
pc35_1!=. & ///
pc36_1!=. & ///
pc37_1!=. & ///
pc38_1!=. & ///
pc39_1!=. & ///
pc40_1!=. & ///
centre_1!=. & ///
phe_lifetime_smoking_1!=. & ///
out_multimorbid_SR_2_1!=. & ///
out_multimorbid_SRnoalc_2_1!=. & ///
out_multimorbid_SR_3_1!=. & ///
out_multimorbid_SRnoalc_3_1!=. & ///
out_multimorbid_SR_4_1!=. & ///
out_multimorbid_SRnoalc_4_1!=. & ///
out_multimorb_index_SR_1!=. & ///
out_multimorb_index_noalcSR_1!=. & ///
grs_lifetime_smoking2!=.

*bmi
count if age_1!=. & sex_1!=. & pc1_1!=. & ///
pc2_1!=. & ///
pc3_1!=. & ///
pc4_1!=. & ///
pc5_1!=. & ///
pc6_1!=. & ///
pc7_1!=. & ///
pc8_1!=. & ///
pc9_1!=. & ///
pc10_1!=. & ///
pc11_1!=. & ///
pc12_1!=. & ///
pc13_1!=. & ///
pc14_1!=. & ///
pc15_1!=. & ///
pc16_1!=. & ///
pc17_1!=. & ///
pc18_1!=. & ///
pc19_1!=. & ///
pc20_1!=. & ///
pc21_1!=. & ///
pc22_1!=. & ///
pc23_1!=. & ///
pc24_1!=. & ///
pc25_1!=. & ///
pc26_1!=. & ///
pc27_1!=. & ///
pc28_1!=. & ///
pc29_1!=. & ///
pc30_1!=. & ///
pc31_1!=. & ///
pc32_1!=. & ///
pc33_1!=. & ///
pc34_1!=. & ///
pc35_1!=. & ///
pc36_1!=. & ///
pc37_1!=. & ///
pc38_1!=. & ///
pc39_1!=. & ///
pc40_1!=. & ///
centre_1!=. & ///
phe_bmi_1!=. & ///
out_multimorbid_SR_2_1!=. & ///
out_multimorbid_SRnoalc_2_1!=. & ///
out_multimorbid_SR_3_1!=. & ///
out_multimorbid_SRnoalc_3_1!=. & ///
out_multimorbid_SR_4_1!=. & ///
out_multimorbid_SRnoalc_4_1!=. & ///
out_multimorb_index_SR_1!=. & ///
out_multimorb_index_noalcSR_1!=. & ///
grs_bmi2!=.

*education
count if age_1!=. & sex_1!=. & pc1_1!=. & ///
pc2_1!=. & ///
pc3_1!=. & ///
pc4_1!=. & ///
pc5_1!=. & ///
pc6_1!=. & ///
pc7_1!=. & ///
pc8_1!=. & ///
pc9_1!=. & ///
pc10_1!=. & ///
pc11_1!=. & ///
pc12_1!=. & ///
pc13_1!=. & ///
pc14_1!=. & ///
pc15_1!=. & ///
pc16_1!=. & ///
pc17_1!=. & ///
pc18_1!=. & ///
pc19_1!=. & ///
pc20_1!=. & ///
pc21_1!=. & ///
pc22_1!=. & ///
pc23_1!=. & ///
pc24_1!=. & ///
pc25_1!=. & ///
pc26_1!=. & ///
pc27_1!=. & ///
pc28_1!=. & ///
pc29_1!=. & ///
pc30_1!=. & ///
pc31_1!=. & ///
pc32_1!=. & ///
pc33_1!=. & ///
pc34_1!=. & ///
pc35_1!=. & ///
pc36_1!=. & ///
pc37_1!=. & ///
pc38_1!=. & ///
pc39_1!=. & ///
pc40_1!=. & ///
centre_1!=. & ///
phe_eduyears_scaled_1!=. & ///
out_multimorbid_SR_2_1!=. & ///
out_multimorbid_SRnoalc_2_1!=. & ///
out_multimorbid_SR_3_1!=. & ///
out_multimorbid_SRnoalc_3_1!=. & ///
out_multimorbid_SR_4_1!=. & ///
out_multimorbid_SRnoalc_4_1!=. & ///
out_multimorb_index_SR_1!=. & ///
out_multimorb_index_noalcSR_1!=. & ///
grs_education2!=.

*********
*split 2*
*********

gen main_dataset_2=0
replace main_dataset_2=1 if age_2!=. & sex_2!=. & pc1_2!=. & ///
pc2_2!=. & ///
pc3_2!=. & ///
pc4_2!=. & ///
pc5_2!=. & ///
pc6_2!=. & ///
pc7_2!=. & ///
pc8_2!=. & ///
pc9_2!=. & ///
pc10_2!=. & ///
pc11_2!=. & ///
pc12_2!=. & ///
pc13_2!=. & ///
pc14_2!=. & ///
pc15_2!=. & ///
pc16_2!=. & ///
pc17_2!=. & ///
pc18_2!=. & ///
pc19_2!=. & ///
pc20_2!=. & ///
pc21_2!=. & ///
pc22_2!=. & ///
pc23_2!=. & ///
pc24_2!=. & ///
pc25_2!=. & ///
pc26_2!=. & ///
pc27_2!=. & ///
pc28_2!=. & ///
pc29_2!=. & ///
pc30_2!=. & ///
pc31_2!=. & ///
pc32_2!=. & ///
pc33_2!=. & ///
pc34_2!=. & ///
pc35_2!=. & ///
pc36_2!=. & ///
pc37_2!=. & ///
pc38_2!=. & ///
pc39_2!=. & ///
pc40_2!=. & ///
centre_2!=. & ///
out_multimorbid_SR_2_2!=. & ///
out_multimorbid_SRnoalc_2_2!=. & ///
out_multimorbid_SR_3_2!=. & ///
out_multimorbid_SRnoalc_3_2!=. & ///
out_multimorbid_SR_4_2!=. & ///
out_multimorbid_SRnoalc_4_2!=. & ///
out_multimorb_index_SR_2!=. & ///
out_multimorb_index_noalcSR_2!=. & ///
((phe_alcohol_intake_2!=. & grs_alcohol1!=.)| ///
(phe_bmi_2!=. & grs_bmi1!=.)| ///
(phe_eduyears_scaled_2!=. & grs_education1!=.)| ///
(phe_lifetime_smoking_2!=. & grs_lifetime_smoking1!=.)) 
  
*double check numbers stratified by exposure

*alcohol
count if age_2!=. & sex_2!=. & pc1_2!=. & ///
pc2_2!=. & ///
pc3_2!=. & ///
pc4_2!=. & ///
pc5_2!=. & ///
pc6_2!=. & ///
pc7_2!=. & ///
pc8_2!=. & ///
pc9_2!=. & ///
pc10_2!=. & ///
pc11_2!=. & ///
pc12_2!=. & ///
pc13_2!=. & ///
pc14_2!=. & ///
pc15_2!=. & ///
pc16_2!=. & ///
pc17_2!=. & ///
pc18_2!=. & ///
pc19_2!=. & ///
pc20_2!=. & ///
pc21_2!=. & ///
pc22_2!=. & ///
pc23_2!=. & ///
pc24_2!=. & ///
pc25_2!=. & ///
pc26_2!=. & ///
pc27_2!=. & ///
pc28_2!=. & ///
pc29_2!=. & ///
pc30_2!=. & ///
pc31_2!=. & ///
pc32_2!=. & ///
pc33_2!=. & ///
pc34_2!=. & ///
pc35_2!=. & ///
pc36_2!=. & ///
pc37_2!=. & ///
pc38_2!=. & ///
pc39_2!=. & ///
pc40_2!=. & ///
centre_2!=. & ///
phe_alcohol_intake_2!=. & ///
out_multimorbid_SR_2_2!=. & ///
out_multimorbid_SRnoalc_2_2!=. & ///
out_multimorbid_SR_3_2!=. & ///
out_multimorbid_SRnoalc_3_2!=. & ///
out_multimorbid_SR_4_2!=. & ///
out_multimorbid_SRnoalc_4_2!=. & ///
out_multimorb_index_SR_2!=. & ///
out_multimorb_index_noalcSR_2!=. & ///
grs_alcohol1!=.

*smoking
count if age_2!=. & sex_2!=. & pc1_2!=. & ///
pc2_2!=. & ///
pc3_2!=. & ///
pc4_2!=. & ///
pc5_2!=. & ///
pc6_2!=. & ///
pc7_2!=. & ///
pc8_2!=. & ///
pc9_2!=. & ///
pc10_2!=. & ///
pc11_2!=. & ///
pc12_2!=. & ///
pc13_2!=. & ///
pc14_2!=. & ///
pc15_2!=. & ///
pc16_2!=. & ///
pc17_2!=. & ///
pc18_2!=. & ///
pc19_2!=. & ///
pc20_2!=. & ///
pc21_2!=. & ///
pc22_2!=. & ///
pc23_2!=. & ///
pc24_2!=. & ///
pc25_2!=. & ///
pc26_2!=. & ///
pc27_2!=. & ///
pc28_2!=. & ///
pc29_2!=. & ///
pc30_2!=. & ///
pc31_2!=. & ///
pc32_2!=. & ///
pc33_2!=. & ///
pc34_2!=. & ///
pc35_2!=. & ///
pc36_2!=. & ///
pc37_2!=. & ///
pc38_2!=. & ///
pc39_2!=. & ///
pc40_2!=. & ///
centre_2!=. & ///
phe_lifetime_smoking_2!=. & ///
out_multimorbid_SR_2_2!=. & ///
out_multimorbid_SRnoalc_2_2!=. & ///
out_multimorbid_SR_3_2!=. & ///
out_multimorbid_SRnoalc_3_2!=. & ///
out_multimorbid_SR_4_2!=. & ///
out_multimorbid_SRnoalc_4_2!=. & ///
out_multimorb_index_SR_2!=. & ///
out_multimorb_index_noalcSR_2!=. & ///
grs_lifetime_smoking1!=.

*bmi
count if age_2!=. & sex_2!=. & pc1_2!=. & ///
pc2_2!=. & ///
pc3_2!=. & ///
pc4_2!=. & ///
pc5_2!=. & ///
pc6_2!=. & ///
pc7_2!=. & ///
pc8_2!=. & ///
pc9_2!=. & ///
pc10_2!=. & ///
pc11_2!=. & ///
pc12_2!=. & ///
pc13_2!=. & ///
pc14_2!=. & ///
pc15_2!=. & ///
pc16_2!=. & ///
pc17_2!=. & ///
pc18_2!=. & ///
pc19_2!=. & ///
pc20_2!=. & ///
pc21_2!=. & ///
pc22_2!=. & ///
pc23_2!=. & ///
pc24_2!=. & ///
pc25_2!=. & ///
pc26_2!=. & ///
pc27_2!=. & ///
pc28_2!=. & ///
pc29_2!=. & ///
pc30_2!=. & ///
pc31_2!=. & ///
pc32_2!=. & ///
pc33_2!=. & ///
pc34_2!=. & ///
pc35_2!=. & ///
pc36_2!=. & ///
pc37_2!=. & ///
pc38_2!=. & ///
pc39_2!=. & ///
pc40_2!=. & ///
centre_2!=. & ///
phe_bmi_2!=. & ///
out_multimorbid_SR_2_2!=. & ///
out_multimorbid_SRnoalc_2_2!=. & ///
out_multimorbid_SR_3_2!=. & ///
out_multimorbid_SRnoalc_3_2!=. & ///
out_multimorbid_SR_4_2!=. & ///
out_multimorbid_SRnoalc_4_2!=. & ///
out_multimorb_index_SR_2!=. & ///
out_multimorb_index_noalcSR_2!=. & ///
grs_bmi1!=.

*education
count if age_2!=. & sex_2!=. & pc1_2!=. & ///
pc2_2!=. & ///
pc3_2!=. & ///
pc4_2!=. & ///
pc5_2!=. & ///
pc6_2!=. & ///
pc7_2!=. & ///
pc8_2!=. & ///
pc9_2!=. & ///
pc10_2!=. & ///
pc11_2!=. & ///
pc12_2!=. & ///
pc13_2!=. & ///
pc14_2!=. & ///
pc15_2!=. & ///
pc16_2!=. & ///
pc17_2!=. & ///
pc18_2!=. & ///
pc19_2!=. & ///
pc20_2!=. & ///
pc21_2!=. & ///
pc22_2!=. & ///
pc23_2!=. & ///
pc24_2!=. & ///
pc25_2!=. & ///
pc26_2!=. & ///
pc27_2!=. & ///
pc28_2!=. & ///
pc29_2!=. & ///
pc30_2!=. & ///
pc31_2!=. & ///
pc32_2!=. & ///
pc33_2!=. & ///
pc34_2!=. & ///
pc35_2!=. & ///
pc36_2!=. & ///
pc37_2!=. & ///
pc38_2!=. & ///
pc39_2!=. & ///
pc40_2!=. & ///
centre_2!=. & ///
phe_eduyears_scaled_2!=. & ///
out_multimorbid_SR_2_2!=. & ///
out_multimorbid_SRnoalc_2_2!=. & ///
out_multimorbid_SR_3_2!=. & ///
out_multimorbid_SRnoalc_3_2!=. & ///
out_multimorbid_SR_4_2!=. & ///
out_multimorbid_SRnoalc_4_2!=. & ///
out_multimorb_index_SR_2!=. & ///
out_multimorb_index_noalcSR_2!=. & ///
grs_education1!=.


*keep if all variables non-missing in one of the splits
keep if main_dataset_1==1|main_dataset_2==1

*save dataset
save "$xxxxxxxx\self_report_phenotypes_v4.dta", replace



***********************
*TABULATIONS FOR PAPER*
***********************

drop if related==1 // remove relateds

*self-report dataset characteristics
*reporting using the inclalc outcome variables because same N as noalc outcomes

*********
*split 1*
*********

***0 or 1 conditons***
*N 
count if (out_multimorbid_SR_2_1==0 & main_dataset_1==1)
return list
di r(N)

*(% TOTAL)
tab out_multimorbid_SR_2_1 if main_dataset_1==1, matcell(out_mat)
matrix list out_mat
di (out_mat[1,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_1 if (out_multimorbid_SR_2_1==0 & main_dataset_1==1), matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_1 if (out_multimorbid_SR_2_1==0 & main_dataset_1==1), detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_1 if (out_multimorbid_SR_2_1==0 & main_dataset_1==1)
*mean bmi
sum phe_bmi_1 if (out_multimorbid_SR_2_1==0 & main_dataset_1==1 & grs_bmi2!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_1 if (out_multimorbid_SR_2_1==0 & main_dataset_1==1 & grs_lifetime_smoking2!=.)
*mean alcohol intake
sum phe_alcohol_intake_1 if (out_multimorbid_SR_2_1==0 & main_dataset_1==1 & grs_alcohol2!=.)
*mean years education
sum phe_eduyears_scaled_1 if (out_multimorbid_SR_2_1==0 & main_dataset_1==1 & grs_education2!=.)

***2+ conditions***
*N 
count if (out_multimorbid_SR_2_1==1 & main_dataset_1==1)
return list
di r(N)
*(% TOTAL)
tab out_multimorbid_SR_2_1 if main_dataset_1==1, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_1 if (out_multimorbid_SR_2_1==1 & main_dataset_1==1), matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_1 if (out_multimorbid_SR_2_1==1 & main_dataset_1==1), detail
di r(mean)
di "`r(p25)'-`r(p75)''"
*mean cambridge MM Index
sum out_multimorb_index_SR_1 if (out_multimorbid_SR_2_1==1 & main_dataset_1==1)
*mean bmi
sum phe_bmi_1 if (out_multimorbid_SR_2_1==1 & main_dataset_1==1 & grs_bmi2!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_1 if (out_multimorbid_SR_2_1==1 & main_dataset_1==1 & grs_lifetime_smoking2!=.)
*mean alcohol intake
sum phe_alcohol_intake_1 if (out_multimorbid_SR_2_1==1 & main_dataset_1==1 & grs_alcohol2!=.)
*mean years education
sum phe_eduyears_scaled_1 if (out_multimorbid_SR_2_1==1 & main_dataset_1==1 & grs_education2!=.)




***3+ conditions***
*N 
count if (out_multimorbid_SR_3_1==1 & main_dataset_1==1)
return list
di r(N)
*(% TOTAL)
tab out_multimorbid_SR_3_1 if main_dataset_1==1, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_1 if (out_multimorbid_SR_3_1==1 & main_dataset_1==1), matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_1 if (out_multimorbid_SR_3_1==1 & main_dataset_1==1), detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_1 if (out_multimorbid_SR_3_1==1 & main_dataset_1==1)
*mean bmi
sum phe_bmi_1 if (out_multimorbid_SR_3_1==1 & main_dataset_1==1 & grs_bmi2!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_1 if (out_multimorbid_SR_3_1==1 & main_dataset_1==1 & grs_lifetime_smoking2!=.)
*mean alcohol intake
sum phe_alcohol_intake_1 if (out_multimorbid_SR_3_1==1 & main_dataset_1==1 & grs_alcohol2!=.)
*mean years education
sum phe_eduyears_scaled_1 if (out_multimorbid_SR_3_1==1 & main_dataset_1==1 & grs_education2!=.)


***4+ conditions***
*N 
count if (out_multimorbid_SR_4_1==1 & main_dataset_1==1)
return list
di r(N)
*(% TOTAL)
tab out_multimorbid_SR_4_1 if main_dataset_1==1, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_1 if (out_multimorbid_SR_4_1==1 & main_dataset_1==1), matcell(female_mat)
matrix list female_mat
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_1 if (out_multimorbid_SR_4_1==1 & main_dataset_1==1), detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_1 if (out_multimorbid_SR_4_1==1 & main_dataset_1==1)
*mean bmi
sum phe_bmi_1 if (out_multimorbid_SR_4_1==1 & main_dataset_1==1 & grs_bmi2!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_1 if (out_multimorbid_SR_4_1==1 & main_dataset_1==1 & grs_lifetime_smoking2!=.)
*mean alcohol intake
sum phe_alcohol_intake_1 if (out_multimorbid_SR_4_1==1 & main_dataset_1==1 & grs_alcohol2!=.)
*mean years education
sum phe_eduyears_scaled_1 if (out_multimorbid_SR_4_1==1 & main_dataset_1==1 & grs_education2!=.)


***ALL***
*N 
count if main_dataset_1==1
return list
di r(N)

*% FEMALE
tab sex_1 if main_dataset_1==1, matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_1 if main_dataset_1==1, detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_1 if main_dataset_1==1
*mean bmi
sum phe_bmi_1 if (main_dataset_1==1 & grs_bmi2!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_1 if (main_dataset_1==1 & grs_lifetime_smoking2!=.)
*mean alcohol intake
sum phe_alcohol_intake_1 if (main_dataset_1==1 & grs_alcohol2!=.)
*mean years education
sum phe_eduyears_scaled_1 if (main_dataset_1==1 & grs_education2!=.)


*********
*split 2*
*********


***0 or 1 conditons***
*N 
count if (out_multimorbid_SR_2_2==0 & main_dataset_2==1)
return list
di r(N)
*(% TOTAL)
tab out_multimorbid_SR_2_2 if main_dataset_2==1, matcell(out_mat)
matrix list out_mat
di (out_mat[1,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_2 if (out_multimorbid_SR_2_2==0 & main_dataset_2==1), matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_2 if (out_multimorbid_SR_2_2==0 & main_dataset_2==1), detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_2 if (out_multimorbid_SR_2_2==0 & main_dataset_2==1)
*mean bmi
sum phe_bmi_2 if (out_multimorbid_SR_2_2==0 & main_dataset_2==1 & grs_bmi1!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_2 if (out_multimorbid_SR_2_2==0 & main_dataset_2==1 & grs_lifetime_smoking1!=.)
*mean alcohol intake
sum phe_alcohol_intake_2 if (out_multimorbid_SR_2_2==0 & main_dataset_2==1 & grs_alcohol1!=.)
*mean years education
sum phe_eduyears_scaled_2 if (out_multimorbid_SR_2_2==0 & main_dataset_2==1 & grs_education1!=.)

***2+ conditions***
*N 
count if (out_multimorbid_SR_2_2==1 & main_dataset_2==1)
return list
di r(N)
*(% TOTAL)
tab out_multimorbid_SR_2_2 if main_dataset_2==1, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_2 if (out_multimorbid_SR_2_2==1 & main_dataset_2==1), matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_2 if (out_multimorbid_SR_2_2==1 & main_dataset_2==1), detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_2 if (out_multimorbid_SR_2_2==1 & main_dataset_2==1)
*mean bmi
sum phe_bmi_2 if (out_multimorbid_SR_2_2==1 & main_dataset_2==1 & grs_bmi1!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_2 if (out_multimorbid_SR_2_2==1 & main_dataset_2==1 & grs_lifetime_smoking1!=.)
*mean alcohol intake
sum phe_alcohol_intake_2 if (out_multimorbid_SR_2_2==1 & main_dataset_2==1 & grs_alcohol1!=.)
*mean years education
sum phe_eduyears_scaled_2 if (out_multimorbid_SR_2_2==1 & main_dataset_2==1 & grs_education1!=.)




***3+ conditions***
*N 
count if (out_multimorbid_SR_3_2==1 & main_dataset_2==1)
return list
di r(N)
*(% TOTAL)
tab out_multimorbid_SR_3_2 if main_dataset_2==1, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_2 if (out_multimorbid_SR_3_2==1 & main_dataset_2==1), matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_2 if (out_multimorbid_SR_3_2==1 & main_dataset_2==1), detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_2 if (out_multimorbid_SR_3_2==1 & main_dataset_2==1)
*mean bmi
sum phe_bmi_2 if (out_multimorbid_SR_3_2==1 & main_dataset_2==1 & grs_bmi1!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_2 if (out_multimorbid_SR_3_2==1 & main_dataset_2==1 & grs_lifetime_smoking1!=.)
*mean alcohol intake
sum phe_alcohol_intake_2 if (out_multimorbid_SR_3_2==1 & main_dataset_2==1 & grs_alcohol1!=.)
*mean years education
sum phe_eduyears_scaled_2 if (out_multimorbid_SR_3_2==1 & main_dataset_2==1 & grs_education1!=.)





***4+ conditions***
*N 
count if (out_multimorbid_SR_4_2==1 & main_dataset_2==1)
return list
di r(N)
*(% TOTAL)
tab out_multimorbid_SR_4_2 if main_dataset_2==1, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
*% FEMALE
tab sex_2 if (out_multimorbid_SR_4_2==1 & main_dataset_2==1), matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_2 if (out_multimorbid_SR_4_2==1 & main_dataset_2==1), detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_2 if (out_multimorbid_SR_4_2==1 & main_dataset_2==1)
*mean bmi
sum phe_bmi_2 if (out_multimorbid_SR_4_2==1 & main_dataset_2==1 & grs_bmi1!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_2 if (out_multimorbid_SR_4_2==1 & main_dataset_2==1 & grs_lifetime_smoking1!=.)
*mean alcohol intake
sum phe_alcohol_intake_2 if (out_multimorbid_SR_4_2==1 & main_dataset_2==1 & grs_alcohol1!=.)
*mean years education
sum phe_eduyears_scaled_2 if (out_multimorbid_SR_4_2==1 & main_dataset_2==1 & grs_education1!=.)


***ALL***
*N 
count if main_dataset_2==1
return list
di r(N)

*% FEMALE
tab sex_2 if main_dataset_2==1, matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
*mean age, IQR age
sum age_2 if main_dataset_2==1, detail
di r(mean)
di "`r(p25)'-`r(p75)'"
*mean cambridge MM Index
sum out_multimorb_index_SR_2 if main_dataset_2==1
*mean bmi
sum phe_bmi_2 if (main_dataset_2==1 & grs_bmi1!=.)
*mean lifetime smoking
sum phe_lifetime_smoking_2 if (main_dataset_2==1 & grs_lifetime_smoking1!=.)
*mean alcohol intake
sum phe_alcohol_intake_2 if (main_dataset_2==1 & grs_alcohol1!=.)
*mean years education
sum phe_eduyears_scaled_2 if (main_dataset_2==1 & grs_education1!=.)


*****************
*splits combined*
*****************

*make combined variables
gen main_dataset=0
replace main_dataset=1 if main_dataset_1==1|main_dataset_2==1

gen age=.
replace age=age_1 if sample==2
replace age=age_2 if sample==1
gen sex=.
replace sex=sex_1 if sample==2
replace sex=sex_2 if sample==1
gen centre=.
replace centre=centre_1 if sample==2
replace centre=centre_2 if sample==1
foreach num of numlist 1/40 {
    gen pc`num'=.
	replace pc`num'=pc`num'_1 if sample==2
	replace pc`num'=pc`num'_2 if sample==1
}
gen out_multimorbid_SR_2=.
replace out_multimorbid_SR_2=out_multimorbid_SR_2_1 if sample==2
replace out_multimorbid_SR_2=out_multimorbid_SR_2_2 if sample==1
gen out_multimorbid_SR_3=.
replace out_multimorbid_SR_3=out_multimorbid_SR_3_1 if sample==2
replace out_multimorbid_SR_3=out_multimorbid_SR_3_2 if sample==1
gen out_multimorbid_SR_4=.
replace out_multimorbid_SR_4=out_multimorbid_SR_4_1 if sample==2
replace out_multimorbid_SR_4=out_multimorbid_SR_4_2 if sample==1
gen out_multimorb_index_SR=.
replace out_multimorb_index_SR=out_multimorb_index_SR_1 if sample==2
replace out_multimorb_index_SR=out_multimorb_index_SR_2 if sample==1
gen out_multimorbid_SRnoalc_2=.
replace out_multimorbid_SRnoalc_2=out_multimorbid_SRnoalc_2_1 if sample==2
replace out_multimorbid_SRnoalc_2=out_multimorbid_SRnoalc_2_2 if sample==1
gen out_multimorbid_SRnoalc_3=.
replace out_multimorbid_SRnoalc_3=out_multimorbid_SRnoalc_3_1 if sample==2
replace out_multimorbid_SRnoalc_3=out_multimorbid_SRnoalc_3_2 if sample==1
gen out_multimorbid_SRnoalc_4=.
replace out_multimorbid_SRnoalc_4=out_multimorbid_SRnoalc_4_1 if sample==2
replace out_multimorbid_SRnoalc_4=out_multimorbid_SRnoalc_4_2 if sample==1
gen out_multimorb_index_noalcSR=.
replace out_multimorb_index_noalcSR=out_multimorb_index_noalcSR_1 if sample==2
replace out_multimorb_index_noalcSR=out_multimorb_index_noalcSR_2 if sample==1
gen phe_alcohol_intake=.
replace phe_alcohol_intake=phe_alcohol_intake_1 if sample==2
replace phe_alcohol_intake=phe_alcohol_intake_2 if sample==1
gen phe_bmi=.
replace phe_bmi=phe_bmi_1 if sample==2
replace phe_bmi=phe_bmi_2 if sample==1
gen phe_eduyears_scaled=.
replace phe_eduyears_scaled=phe_eduyears_scaled_1 if sample==2
replace phe_eduyears_scaled=phe_eduyears_scaled_2 if sample==1
gen phe_lifetime_smoking=.
replace phe_lifetime_smoking=phe_lifetime_smoking_1 if sample==2
replace phe_lifetime_smoking=phe_lifetime_smoking_2 if sample==1
/*now switch the sample ordering for the grs variables because we want the grs to have been derived in the opposite sample - see cdmm_12b.do*/
gen grs_bmi=.
replace grs_bmi=grs_bmi1 if sample==1
replace grs_bmi=grs_bmi2 if sample==2
gen grs_alcohol=.
replace grs_alcohol=grs_alcohol1 if sample==1
replace grs_alcohol=grs_alcohol2 if sample==2
gen grs_education=.
replace grs_education=grs_education1 if sample==1
replace grs_education=grs_education2 if sample==2
gen grs_lifetime_smoking=.
replace grs_lifetime_smoking=grs_lifetime_smoking1 if sample==1
replace grs_lifetime_smoking=grs_lifetime_smoking2 if sample==2

replace out_multimorbid_SR_2=. if ((out_multimorbid_SR_2_1!=. & main_dataset_1==0)|(out_multimorbid_SR_2_2!=. & main_dataset_2==0))
replace out_multimorbid_SR_3=. if ((out_multimorbid_SR_3_1!=. & main_dataset_1==0)|(out_multimorbid_SR_3_2!=. & main_dataset_2==0))
replace out_multimorbid_SR_4=. if ((out_multimorbid_SR_4_1!=. & main_dataset_1==0)|(out_multimorbid_SR_4_2!=. & main_dataset_2==0))
replace out_multimorb_index_SR=. if ((out_multimorb_index_SR_1!=. & main_dataset_1==0)|(out_multimorb_index_SR_2!=. & main_dataset_2==0))
replace out_multimorbid_SRnoalc_2=. if ((out_multimorbid_SRnoalc_2_1!=. & main_dataset_1==0)|(out_multimorbid_SRnoalc_2_2!=. & main_dataset_2==0))
replace out_multimorbid_SRnoalc_3=. if ((out_multimorbid_SRnoalc_3_1!=. & main_dataset_1==0)|(out_multimorbid_SRnoalc_3_2!=. & main_dataset_2==0))
replace out_multimorbid_SRnoalc_4=. if ((out_multimorbid_SRnoalc_4_1!=. & main_dataset_1==0)|(out_multimorbid_SRnoalc_4_2!=. & main_dataset_2==0))
replace out_multimorb_index_noalcSR=. if ((out_multimorb_index_noalcSR_1!=. & main_dataset_1==0)|(out_multimorb_index_noalcSR_2!=. & main_dataset_2==0))

replace phe_bmi=. if ((phe_bmi_1!=. & main_dataset_1==0)|(phe_bmi_2!=. & main_dataset_2==0)|(phe_bmi_1!=. & grs_bmi2==.)|(phe_bmi_2!=. & grs_bmi1==.))
replace phe_alcohol_intake=. if ((phe_alcohol_intake_1!=. & main_dataset_1==0)|(phe_alcohol_intake_2!=. & main_dataset_2==0)|(phe_alcohol_intake_1!=. & grs_alcohol2==.)|(phe_alcohol_intake_2!=. & grs_alcohol1==.))
replace phe_eduyears_scaled=. if ((phe_eduyears_scaled_1!=. & main_dataset_1==0)|(phe_eduyears_scaled_2!=. & main_dataset_2==0)|(phe_eduyears_scaled_1!=. & grs_education2==.)|(phe_eduyears_scaled_2!=. & grs_education1==.))
replace phe_lifetime_smoking=. if ((phe_lifetime_smoking_1!=. & main_dataset_1==0)|(phe_lifetime_smoking_2!=. & main_dataset_2==0)|(phe_lifetime_smoking_1!=. & grs_lifetime_smoking2==.)|(phe_lifetime_smoking_2!=. & grs_lifetime_smoking1==.))

*set up excel file for writing results
putexcel set table1, replace sheet("table1")
putexcel A1 = "Number of conditions"
putexcel B1 = "Number of individuals (% total)"
putexcel C1 = "% Female"
putexcel D1 = "Mean age (years, 1 d.p.) (Age Inter-quartile Range)*"
putexcel E1 = "Mean Cambridge Multimorbidity Index (1 d.p.), SD"
putexcel F1 = "Mean BMI (1 d.p.) (SD); N"
putexcel G1 = "Mean Alcohol units per week (1 d.p.) (SD); N"
putexcel H1 = "Mean years education (1 d.p.) (SD); N"
putexcel I1 = "Mean lifetime smoking index (2 d.p.) (SD); N"
putexcel A2 = "0 or 1"
putexcel A3 = ">=2"
putexcel A4 = ">=3"
putexcel A5 = ">=4"
putexcel A6 = "Total"
putexcel A7 = "25th centile - 75th centile"

***0 or 1 conditons***
*N 
count if (out_multimorbid_SR_2==0 & ((out_multimorbid_SR_2_1==0 & main_dataset_1==1)|(out_multimorbid_SR_2_2==0 & main_dataset_2==1)))
return list
di r(N)

local b2a=r(N)
di `b2'

*(% TOTAL)
tab out_multimorbid_SR_2, matcell(out_mat)
matrix list out_mat
local b2b = (out_mat[1,1]/(out_mat[1,1]+out_mat[2,1]))*100
local rb2b = round((out_mat[1,1]/(out_mat[1,1]+out_mat[2,1]))*100,0.1)
di `rb2b'
di `b2b'
di %12.1f `b2b'

local middle =" ("
local end =")"
di "`middle'"
di "`end'"

local b2ab2b "`b2a'`middle'`rb2b'`end'"
di "`b2ab2b'"
putexcel B2 = "`b2ab2b'"

*% FEMALE
tab sex if out_multimorbid_SR_2==0, matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
local c2 =round((female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100,0.1)
putexcel C2 = "`c2'"

*mean age, IQR age
sum age if out_multimorbid_SR_2==0, detail
di r(mean)
di "`r(p25)'-`r(p75)'"
local d2a = round(r(mean),0.1)
local d2b = round(r(p25),1)
local d2c = round(r(p75),1)
local dash = "-"
local d2ad2bd2c = "`d2a'`middle'`d2b'`dash'`d2c'`end'"
putexcel D2 = "`d2ad2bd2c'"

*mean cambridge MM Index
sum out_multimorb_index_SR if out_multimorbid_SR_2==0, detail 
di r(mean)
di r(sd)
local e2a =round(r(mean),0.1)
local e2b =round(r(sd),0.1)
local e2ae2b = "`e2a'`middle'`e2b'`end'"
*putexcel E2 = "`e2ae2b'"
di "`r(p25)'-`r(p75)'"
local e2c = round(r(p25),0.1)
local e2d = round(r(p75),0.1)
local e2ae2ce2d = "`e2a'`middle'`e2c'`dash'`e2d'`end'"
di "`e2ae2ce2d'"
putexcel E2 = "`e2ae2ce2d'"

local colon ="; "

*mean years education
sum phe_eduyears_scaled if out_multimorbid_SR_2==0 
di r(N)
di r(mean)
di r(sd)
local h2a = round((r(mean)*`edu_sd'),0.1)
local h2b = r(N)
local h2c = round((r(sd)*`edu_sd'),0.1)
local h2ah2bh2c = "`h2a'`middle'`h2c'`end'`colon'`h2b'"
putexcel H2 = "`h2ah2bh2c'"


*mean bmi
sum phe_bmi if out_multimorbid_SR_2==0 
di r(N)
di r(mean)
di r(sd)
local f2a = round((r(mean)*5),0.1)
local f2b = r(N)
local f2c = round(r(sd)*5,0.1)
local f2af2bf2c = "`f2a'`middle'`f2c'`end'`colon'`f2b'"
putexcel F2 = "`f2af2bf2c'"


*mean alcohol intake
sum phe_alcohol_intake if out_multimorbid_SR_2==0
di r(N)
di r(mean)
di r(sd)
local g2a = round((r(mean)*5),0.1)
local g2b = r(N)
local g2c = round((r(sd)*5),0.1)
local g2ag2bg2c = "`g2a'`middle'`g2c'`end'`colon'`g2b'"
putexcel G2 = "`g2ag2bg2c'"


*mean lifetime smoking
sum phe_lifetime_smoking if out_multimorbid_SR_2==0 
di r(N)
di r(mean)
di r(sd)
local i2a = round((r(mean)*`smok_sd'),0.01)
local i2b = r(N)
local i2c = round((r(sd)*`smok_sd'),0.01)
local i2ai2bi2c = "`i2a'`middle'`i2c'`end'`colon'`i2b'"
putexcel I2 = "`i2ai2bi2c'"





***2+ conditions***
*N 
count if (out_multimorbid_SR_2==1 & ((out_multimorbid_SR_2_1==1 & main_dataset_1==1)|(out_multimorbid_SR_2_2==1 & main_dataset_2==1)))
return list
di r(N)
local b3a = r(N)

*(% TOTAL)
tab out_multimorbid_SR_2, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
local rb3b = round((out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100,0.1)
local b3arb3b = "`b3a'`middle'`rb3b'`end'"
putexcel B3 = "`b3arb3b'"

*% FEMALE
tab sex if out_multimorbid_SR_2==1, matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
local c3 =round(((female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100),0.1)
putexcel C3 = "`c3'"


*mean age, IQR age
sum age if out_multimorbid_SR_2==1, detail
di r(mean)
di "`r(p25)'-`r(p75)'"
local d3a = round(r(mean),0.1)
local d3b = round(r(p25),1)
local d3c = round(r(p75),1)
local d3ad3bd3c = "`d3a'`middle'`d3b'`dash'`d3c'`end'"
putexcel D3 = "`d3ad3bd3c'"

*mean cambridge MM Index
sum out_multimorb_index_SR if out_multimorbid_SR_2==1, detail 
di r(mean)
di r(sd)
local e3a = round(r(mean),0.1)
local e3b = round(r(sd),0.1)
local e3ae3b = "`e3a'`middle'`e3b'`end'"
*putexcel E3 = "`e3ae3b'"
di "`r(p25)'-`r(p75)'"
local e3c = round(r(p25),0.1)
local e3d = round(r(p75),0.1)
local e3ae3ce3d = "`e3a'`middle'`e3c'`dash'`e3d'`end'"
di "`e3ae3ce3d'"
putexcel E3 = "`e3ae3ce3d'"


*mean years education
sum phe_eduyears_scaled if out_multimorbid_SR_2==1 
di r(mean)
di r(N)
di r(sd)
local h3a = round((r(mean)*`edu_sd'),0.1)
local h3b = r(N)
local h3c = round((r(sd)*`edu_sd'),0.1)
local h3ah3bh3c = "`h3a'`middle'`h3c'`end'`colon'`h3b'"
putexcel H3 = "`h3ah3bh3c'"


*mean bmi
sum phe_bmi if out_multimorbid_SR_2==1
di r(mean)
di r(N)
di r(sd)
local f3a = round((r(mean)*5),0.1)
local f3b = r(N)
local f3c = round((r(sd)*5),0.1)
local f3af3bf3c = "`f3a'`middle'`f3c'`end'`colon'`f3b'"
putexcel F3 = "`f3af3bf3c'"

*mean alcohol intake
sum phe_alcohol_intake if out_multimorbid_SR_2==1 
di r(mean)
di r(N)
di r(sd)
local g3a = round((r(mean)*5),0.1)
local g3b = r(N)
local g3c = round((r(sd)*5),0.1)
local g3ag3bg3c = "`g3a'`middle'`g3c'`end'`colon'`g3b'"
putexcel G3 = "`g3ag3bg3c'"


*mean lifetime smoking
sum phe_lifetime_smoking if out_multimorbid_SR_2==1
di r(mean)
di r(N)
di r(sd)
local i3a = round((r(mean)*`smok_sd'),0.01)
local i3b = r(N)
local i3c = round((r(sd)*`smok_sd'),0.01)
local i3ai3bi3c = "`i3a'`middle'`i3c'`end'`colon'`i3b'"
putexcel I3 = "`i3ai3bi3c'"



 
***3+ conditions***
*N 
count if out_multimorbid_SR_3==1 & ((out_multimorbid_SR_3_1==1 & main_dataset_1==1)|(out_multimorbid_SR_3_2==1 & main_dataset_2==1))
return list
di r(N)
local b4a = r(N)


*(% TOTAL)
tab out_multimorbid_SR_3, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
local rb4b = round(((out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100),0.1)
local b4arb4b = "`b4a'`middle'`rb4b'`end'"
putexcel B4 = "`b4arb4b'"


*% FEMALE
tab sex if out_multimorbid_SR_3==1, matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
local c4 = round(((female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100),0.1)
putexcel C4 = "`c4'"


*mean age, IQR age
sum age if out_multimorbid_SR_3==1, detail
di r(mean)
di "`r(p25)'-`r(p75)'"
local d4a = round(r(mean),0.1)
local d4b = round(r(p25),1)
local d4c = round(r(p75),1)
local d4ad4bd4c = "`d4a'`middle'`d4b'`dash'`d4c'`end'"
putexcel D4 = "`d4ad4bd4c'"


*mean cambridge MM Index
sum out_multimorb_index_SR if out_multimorbid_SR_3==1, detail
di r(mean)
di r(sd)
local e4a = round(r(mean),0.1)
local e4b = round(r(sd),0.1)
local e4ae4b = "`e4a'`middle'`e4b'`end'"
*putexcel E4 = "`e4ae4b'"
di "`r(p25)'-`r(p75)'"
local e4c = round(r(p25),0.1)
local e4d = round(r(p75),0.1)
local e4ae4ce4d = "`e4a'`middle'`e4c'`dash'`e4d'`end'"
di "`e4ae4ce4d'"
putexcel E4 = "`e4ae4ce4d'"

*mean years education
sum phe_eduyears_scaled if out_multimorbid_SR_3==1 
local h4a = round((r(mean)*`edu_sd'),0.1)
local h4b = r(N)
local h4c = round((r(sd)*`edu_sd'),0.1)
local h4ah4bh4c = "`h4a'`middle'`h4c'`end'`colon'`h4b'"
putexcel H4 = "`h4ah4bh4c'"

*mean bmi
sum phe_bmi if out_multimorbid_SR_3==1
local f4a = round((r(mean)*5),0.1)
local f4b = r(N)
local f4c = round((r(sd)*5),0.1)
local f4af4bf4c = "`f4a'`middle'`f4c'`end'`colon'`f4b'"
putexcel F4 = "`f4af4bf4c'"
 
*mean alcohol intake
sum phe_alcohol_intake if out_multimorbid_SR_3==1 
local g4a = round((r(mean)*5),0.1)
local g4b = r(N)
local g4c = round((r(sd)*5),0.1)
local g4ag4bg4c = "`g4a'`middle'`g4c'`end'`colon'`g4b'"
putexcel G4 = "`g4ag4bg4c'"


*mean lifetime smoking
sum phe_lifetime_smoking if out_multimorbid_SR_3==1 
local i4a = round((r(mean)*`smok_sd'),0.01)
local i4b = r(N)
local i4c = round((r(sd)*`smok_sd'),0.01)
local i4ai4bi4c = "`i4a'`middle'`i4c'`end'`colon'`i4b'"
putexcel I4 = "`i4ai4bi4c'"




***4+ conditions***
*N 
count if out_multimorbid_SR_4==1 & ((out_multimorbid_SR_4_1==1 & main_dataset_1==1)|(out_multimorbid_SR_4_2==1 & main_dataset_2==1))
return list
di r(N)
local b5a = r(N)


*(% TOTAL)
tab out_multimorbid_SR_4, matcell(out_mat)
matrix list out_mat
di (out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100
local rb5b = round(((out_mat[2,1]/(out_mat[1,1]+out_mat[2,1]))*100),0.1)
local b5arb5b = "`b5a'`middle'`rb5b'`end'"
putexcel B5 = "`b5arb5b'"

*% FEMALE
tab sex if out_multimorbid_SR_4==1, matcell(female_mat)
matrix list female_mat 
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
local c5 = round(((female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100),0.1)
putexcel C5 = "`c5'"

*mean age, IQR age
sum age if out_multimorbid_SR_4==1, detail
di r(mean)
di "`r(p25)'-`r(p75)'"
local d5a = round(r(mean),0.1)
local d5b = round(r(p25),1)
local d5c = round(r(p75),1)
local d5ad5bd5c = "`d5a'`middle'`d5b'`dash'`d5c'`end'"
putexcel D5 = "`d5ad5bd5c'"

*mean cambridge MM Index
sum out_multimorb_index_SR if out_multimorbid_SR_4==1, detail
local e5a = round(r(mean),0.1)
local e5b = round(r(sd),0.1)
local e5ae5b = "`e5a'`middle'`e5b'`end'"
*putexcel E5 = "`e5ae5b'"
di "`r(p25)'-`r(p75)'"
local e5c = round(r(p25),0.1)
local e5d = round(r(p75),0.1)
local e5ae5ce5d = "`e5a'`middle'`e5c'`dash'`e5d'`end'"
di "`e5ae5ce5d'"
putexcel E5 = "`e5ae5ce5d'"


*mean years education
sum phe_eduyears_scaled if out_multimorbid_SR_4==1 
local h5a = round((r(mean)*`edu_sd'),0.1)
local h5b = r(N)
local h5c = round((r(sd)*`edu_sd'),0.1)
local h5ah5bh5c = "`h5a'`middle'`h5c'`end'`colon'`h5b'"
putexcel H5 = "`h5ah5bh5c'"

*mean bmi
sum phe_bmi if out_multimorbid_SR_4==1
local f5a = round((r(mean)*5),0.1)
local f5b = r(N)
local f5c = round((r(sd)*5),0.1)
local f5af5bf5c = "`f5a'`middle'`f5c'`end'`colon'`f5b'"
putexcel F5 = "`f5af5bf5c'"

*mean alcohol intake
sum phe_alcohol_intake if out_multimorbid_SR_4==1 
local g5a = round((r(mean)*5),0.1)
local g5b = r(N)
local g5c = round((r(sd)*5),0.1)
local g5ag5bg5c = "`g5a'`middle'`g5c'`end'`colon'`g5b'"
putexcel G5 = "`g5ag5bg5c'"


*mean lifetime smoking
sum phe_lifetime_smoking if out_multimorbid_SR_4==1 
local i5a = round((r(mean)*`smok_sd'),0.01)
local i5b = r(N)
local i5c = round((r(sd)*`smok_sd'),0.01)
local i5ai5bi5c = "`i5a'`middle'`i5c'`end'`colon'`i5b'"
putexcel I5 = "`i5ai5bi5c'"


***ALL***
*N 
count if main_dataset==1
return list
di r(N)
local b6a = r(N)
local b6b = "(100)"
local b6ab6b = "`b6a'`b6b'"
putexcel B6 = "`b6ab6b'"

*% FEMALE
tab sex if main_dataset==1, matcell(female_mat)
matrix list female_mat
di (female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100
local c6 = round(((female_mat[1,1]/(female_mat[1,1]+female_mat[2,1]))*100),0.1)
putexcel C6 = `c6'


*mean age, IQR age
sum age if main_dataset==1, detail
di r(mean)
di "`r(p25)'-`r(p75)'"
local d6a = round(r(mean),0.1)
local d6b = round(r(p25),1)
local d6c = round(r(p75),1)
local d6ad6bd6c="`d6a'`middle'`d6b'`dash'`d6c'`end'"
putexcel D6 = "`d6ad6bd6c'"

*mean cambridge MM Index
sum out_multimorb_index_SR if main_dataset==1, detail
local e6a = round(r(mean),0.1)
local e6b = round(r(sd),0.1)
local e6ae6b = "`e6a'`middle'`e6b'`end'"
*putexcel E6 = "`e6ae6b'"
di "`r(p25)'-`r(p75)'"
local e6c = round(r(p25),0.1)
local e6d = round(r(p75),0.1)
local e6ae6ce6d = "`e6a'`middle'`e6c'`dash'`e6d'`end'"
di "`e6ae6ce6d'"
putexcel E6 = "`e6ae6ce6d'"




*mean years education
sum phe_eduyears_scaled if main_dataset==1 
local h6a = round((r(mean)*`edu_sd'),0.1)
local h6b = r(N)
local h6c = round((r(sd)*`edu_sd'),0.1)
local h6ah6bh6c = "`h6a'`middle'`h6c'`end'`colon'`h6b'"
putexcel H6 = "`h6ah6bh6c'"

*mean bmi
sum phe_bmi if main_dataset==1 
local f6a = round((r(mean)*5),0.1)
local f6b = r(N)
local f6c = round((r(sd)*5),0.1)
local f6af6bf6c = "`f6a'`middle'`f6c'`end'`colon'`f6b'"
putexcel F6 = "`f6af6bf6c'"

*mean alcohol intake
sum phe_alcohol_intake if main_dataset==1 
local g6a = round((r(mean)*5),0.1)
local g6b = r(N)
local g6c = round((r(sd)*5),0.1)
local g6ag6bg6c = "`g6a'`middle'`g6c'`end'`colon'`g6b'"
putexcel G6 = "`g6ag6bg6c'"


*mean lifetime smoking
sum phe_lifetime_smoking if main_dataset==1 
local i6a = round((r(mean)*`smok_sd'),0.01)
local i6b = r(N)
local i6c = round((r(sd)*`smok_sd'),0.01)
local i6ai6bi6c = "`i6a'`middle'`i6c'`end'`colon'`i6b'"
putexcel I6 = "`i6ai6bi6c'"

putexcel save
putexcel clear

save "$xxxxxx\self_report_phenotypes_v5.dta", replace