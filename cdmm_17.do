*script name: cdmm_17.do
*script author: Teri North
*date created: 11.6.21
*date last edited: 10.12.22
*script purpose: run sensitivity analyses for MR 

clear
cd 

*This code regresses all SNPs against all outcomes for each trait
*Then does all the MR sensitivity analyses (IVW, Egger, median, mode)

** note the only outcome we consider here is multimorbidity defined by 2+ chronic conditions***

*Create id list - move to start of do file 15 before other variables are created. Trim to where main_dataset=1 and then just id_ieu column
use "$xxxxx\self_report_phenotypes_v5.dta", clear
keep if main_dataset==1
keep id_ieu
save "id_list.dta", replace
clear

import delim "$xxxxxx\snp_ipd_ss.raw", delim("") clear 

drop iid-phenotype
rename fid id_ieu

*Remove participants if not in main analysis
merge 1:1 id_ieu using "id_list.dta", keep(3) nogen

save "$xxxxxx\snp_ipd_ss.dta", replace
clear

*Need to create smaller datasets for each trait to regress on all outcomes
use "$xxxxxxx\self_report_phenotypes_v5.dta", clear
keep if main_dataset==1
keep id_ieu age* sex* pc* out_multimorbid_SR_2* out_multimorbid_SRnoalc_2* phe_alcohol_intake phe_eduyears_scaled phe_bmi phe_lifetime_smoking  

*sex
drop sex_1 sex_2
count if sex!=.
*age 
drop age_1 age_2
count if age!=.
*pcs
foreach val of numlist 1[1]40 {

	drop pc`val'_1 pc`val'_2
	count if pc`val' !=.
}

*outcomes 
drop out_multimorbid_SR_2_1 out_multimorbid_SR_2_2
count if out_multimorbid_SR_2!=.


drop out_multimorbid_SRnoalc_2_1 out_multimorbid_SRnoalc_2_2
count if out_multimorbid_SRnoalc_2!=.


*Also need to know which sample the participants were in:
merge 1:1 id_ieu using "$xxxxxxx\sample IDs.dta", nogen keep(3)
save "$xxxxxxxx\outcomes.dta", replace
clear
*Run the code from R to strip down the SNPs into datasets
rsource using "$xxxxxx\mr_snps_to_keep_generation_split_TLN.R", rpath(`""') roptions(`"--vanilla"')

qui do "$xxxxxxx\snps_to_keep_ss.do"

clear 
cd 

local list "BMI_split_sample_split2 edu_split_sample_split1 edu_split_sample_split2 csi_split_sample_split1 csi_split_sample_split2 alcohol_split_sample_split1 alcohol_split_sample_split2"
use $xxxxxxx\results_BMI_split_sample_split1.dta, clear
foreach trait in `list' {
	append using "$xxxxxxxx\results_`trait'.dta"
}



*Make things look better

replace outcome = strproper(outcome)
drop cases controls
replace trait = subinstr(trait,"_"," ",.)
replace trait = proper(trait)


save "$xxxxxxxx\ss_MR_data.dta", replace

********

use "$xxxxxxxxx\ss_MR_data.dta", clear

gen exp = ""
gen out = ""
gen genotypes = .
gen ivw = .
gen ivw_se = .
gen ivw_p = .
gen heterogeneity_p = .
gen egger_slope = .
gen egger_slope_se = .
gen egger_slope_p = .
gen egger_cons = .
gen egger_cons_se = .
gen egger_cons_p = .
gen median = .
gen median_se = .
gen median_p = .
gen mode = .
gen mode_se = .
gen mode_p = .


{
qui replace trait = "Body Mass Index (5 kg/m2) 1" if trait == "Bmi Split Sample Split1"
qui replace trait = "Body Mass Index (5 kg/m2) 2" if trait == "Bmi Split Sample Split2"

qui replace trait = "5 units alcohol/week 1" if trait == "Alcohol Split Sample Split1"
qui replace trait = "5 units alcohol/week 2" if trait == "Alcohol Split Sample Split2"

qui replace trait = "SD years education 1" if trait == "Edu Split Sample Split1"
qui replace trait = "SD years education 2" if trait == "Edu Split Sample Split2"

qui replace trait = "SD CSI 1" if trait == "Csi Split Sample Split1"
qui replace trait = "SD CSI 2" if trait == "Csi Split Sample Split2"

}


*Make all the exposure betas positive
qui replace beta = -beta if beta_exposure < 0
qui replace beta_exposure = -beta_exposure if beta_exposure < 0


qui levelsof trait, local(trait)
qui levelsof outcome, local(outcome)
local i = 1
foreach exp in `trait' {
	foreach out in `outcome' {
		qui count if outcome == "`out'" & trait == "`exp'"
		if r(N) >= 3 {
			*MR robust takes the outcome before the phenotype
			qui replace genotypes = r(N) in `i'
			qui replace exp = "`exp'" in `i'
			qui replace out = "`out'" in `i'
			capture qui mregger beta beta_exposure [aw=1/(se^2)] if trait == "`exp'" & outcome == "`out'", ivw heterogi
			
			qui mregger beta beta_exposure [aw=1/(se^2)] if trait == "`exp'" & outcome == "`out'", ivw heterogi
			qui replace heterogeneity_p = e(pval) in `i'
			qui replace ivw = _b[beta_exposure] in `i'
			qui replace ivw_se = _se[beta_exposure] in `i'
			qui mregger beta beta_exposure [aw=1/(se^2)] if trait == "`exp'" & outcome == "`out'"
			qui replace egger_slope = _b[slope] in `i'
			qui replace egger_slope_se = _se[slope] in `i'
			qui replace egger_cons = _b[_cons] in `i'
			qui replace egger_cons_se = _se[_cons] in `i'
			qui mrmedian beta se beta_exposure se_exposure if trait == "`exp'" & outcome == "`out'"
			qui replace median = _b[beta] in `i'
			qui replace median_se = _se[beta] in `i'
			qui mrmodal beta se beta_exposure se_exposure if trait == "`exp'" & outcome == "`out'"
			qui replace mode = _b[beta] in `i'
			qui replace mode_se = _se[beta] in `i'
			
			local i = `i' + 1
		}
	}
}


foreach var of varlist ivw egger_slope egger_cons median mode {
	qui replace `var'_p = 2*normal(-abs(`var'/`var'_se))
}

keep exp-mode_p
keep if exp != ""

save "$xxxxxxxx\ss_MR_results.dta", replace

*Meta-analyse summary MR analysis

use "$xxxxxxx\ss_MR_results.dta", clear
rename exp exposure
rename out outcome

*Create a sample variable
gen sample = substr(exposure,-1,1), a(outcome) // analysis performed in sample='sample', GWAS performed in alternate to sample

*Need to meta-analyse across the 2 samples
qui levelsof exposure, local(exposure)
qui levelsof outcome, local(outcome)
local N = r(N)
local N2 = `N'*2
set obs `N2'

local i = `N'+1

*make a table for supplement
cd 
putexcel set tableS9, replace sheet("tableS9")
putexcel A1 = "Exposure"
putexcel B1 = "Outcome"
putexcel C1 = "IVW Beta [SE]"
putexcel D1 = "IVW p-value"
putexcel E1 = "IVW p-value het"
putexcel F1 = "MR-Egger Slope [SE]"
putexcel G1 = "MR-Egger Slope SE"
putexcel H1 = "MR-Egger Slope p-value"
putexcel I1 = "MR-Egger Constant [SE]"
putexcel J1 = "MR-Egger Constant SE"
putexcel K1 = "MR-Egger Constant p-value"
putexcel L1 = "Simple Modal Beta [SE]"
putexcel M1 = "Simple Modal SE"
putexcel N1 = "Simple Modal p-value"
putexcel O1 = "Unweighted Median Beta [SE]"
putexcel P1 = "Unweighted Median SE"
putexcel Q1 = "Unweighted Median p-value"
putexcel R1 = "Split"

local pos = 2

foreach exp in `exposure' {
    
	*Only do things for the first sample 
	if substr("`exp'",-1,1) == "1" {
		local length = length("`exp'")-1
		local e1 = "`exp'"
		local e2 = substr("`exp'",1,`length')
		local e2 = "`e2'2"
		local ex = substr("`exp'",1,`length')
		
		dis "trait = `ex'"
		dis "`e1'"
		dis "`e2'"
		
		qui replace exposure = "`ex'" if exposure == "`e1'" | exposure == "`e2'"
		
		foreach out in `outcome' {
		    
			qui count if outcome == "`out'" & exposure == "`ex'"
			if r(N) >= 2 {
			    putexcel A`pos' = "`ex'"
				putexcel B`pos' = "`out'"
				putexcel R`pos' = "Combined"
				qui replace exposure = "`ex'" in `i'
				qui replace outcome = "`out'" in `i'
				qui replace sample = "Combined" in `i'
				
				qui metan ivw ivw_se if exposure == "`ex'" & outcome == "`out'" & sample!="Combined", nograph
				qui replace ivw = r(ES) in `i'
				qui replace ivw_se = r(seES) in `i'
				qui replace ivw_p = 2*normal(-abs(r(ES)/r(seES))) in `i'
				local c_ivw = round(`r(ES)',0.001)
				local d_ivw = round(`r(seES)',0.001)
				putexcel C`pos' = "`c_ivw'[`d_ivw']"
				
				if ((2*normal(-abs(r(ES)/r(seES))))<0.001){
					local p_ivw="<0.001"
				}
				else {
					local p_ivw=round((2*normal(-abs(r(ES)/r(seES)))),0.001)
				}
				putexcel D`pos' = "`p_ivw'"
				putexcel E`pos' = "NA"
				
			
				qui metan egger_slope egger_slope_se if exposure == "`ex'" & outcome == "`out'" & sample!="Combined" , nograph
				qui replace egger_slope = r(ES) in `i'
				qui replace egger_slope_se = r(seES) in `i'
				qui replace egger_slope_p = 2*normal(-abs(r(ES)/r(seES))) in `i'
				local f_eg_sl = round(`r(ES)',0.001)
				local g_eg_sl = round(`r(seES)',0.001)
				putexcel F`pos' = "`f_eg_sl'[`g_eg_sl']"
				putexcel G`pos' = "`g_eg_sl'"
				if ((2*normal(-abs(r(ES)/r(seES))))<0.001){
					local p_eg_sl="<0.001"
				}
				else {
					local p_eg_sl=round((2*normal(-abs(r(ES)/r(seES)))),0.001)
				}
				putexcel H`pos' = "`p_eg_sl'"
				
				
					
				qui metan egger_cons egger_cons_se if exposure == "`ex'" & outcome == "`out'" & sample!="Combined" , nograph
				qui replace egger_cons = r(ES) in `i'
				qui replace egger_cons_se = r(seES) in `i'
				qui replace egger_cons_p = 2*normal(-abs(r(ES)/r(seES))) in `i'
				local i_eg_co = round(`r(ES)',0.001)
				local j_eg_co =  round(`r(seES)',0.001)
				putexcel I`pos' = "`i_eg_co'[`j_eg_co']"
				putexcel J`pos' = "`j_eg_co'"
				if ((2*normal(-abs(r(ES)/r(seES))))<0.001){
					local p_eg_co="<0.001"
				}
				else {
					local p_eg_co=round((2*normal(-abs(r(ES)/r(seES)))),0.001)
				}
				putexcel K`pos' = "`p_eg_co'"
				
				
				
				
				
				
				local i = `i' + 1
				local pos = `pos' + 1
				
				
			}
		}
	}
}


*also post the individual split results to file
save "$xxxxxxxxx\ss_MR_results_temp.dta", replace

foreach exp in `exposure' {
    local length = length("`exp'")-1
	local ex = substr("`exp'",1,`length')
	foreach out in `outcome' {
		foreach numb in 1 2 {
			use "$xxxxxxxx\ss_MR_results_temp.dta", clear
			di "`ex'"
			di "`out'"
			di "`numb'"
			keep if exposure=="`ex'" & outcome=="`out'" & sample=="`numb'" // should retain one row each time - if results table is missing a row we know something has gone wrong here
			count if exposure=="`ex'" & outcome=="`out'" & sample=="`numb'"
			if (r(N)==1) {
				
				putexcel A`pos' = "`ex'"
				putexcel B`pos' = "`out'"
				putexcel R`pos' = "`numb'"
				local split_ivw_beta = round(ivw[1],0.001)
				local split_ivw_se = round(ivw_se[1],0.001)
				putexcel C`pos' = "`split_ivw_beta'[`split_ivw_se']" // IVW Beta [SE]
				
				if (ivw_p[1]<0.001){
					local split_p_ivw = "<0.001"
				}
				else {
					local split_p_ivw = round(ivw_p[1],0.001)
				}
				putexcel D`pos' = "`split_p_ivw'" // IVW p-value

				
				if (heterogeneity_p[1]<0.001){
					local split_p_het = "<0.001"
				}
				else {
					local split_p_het = round(heterogeneity_p[1],0.001)
				}
				putexcel E`pos' = "`split_p_het'" // IVW het p
				
				local split_egg_slope_beta = round(egger_slope[1],0.001)
				local split_egg_slope_se = round(egger_slope_se[1],0.001)
				putexcel F`pos' = "`split_egg_slope_beta'[`split_egg_slope_se']" // Egger slope Beta [SE]
				putexcel G`pos' = "`split_egg_slope_se'"
				
				if (egger_slope_p[1]<0.001){
					local split_egg_slope_p = "<0.001"
				}
				else {
					local split_egg_slope_p = round(egger_slope_p[1],0.001)
				}
				putexcel H`pos' = "`split_egg_slope_p'"
				
				local split_egg_con_beta = round(egger_cons[1],0.001)
				local split_egg_con_se = round(egger_cons_se[1],0.001)
				putexcel I`pos' = "`split_egg_con_beta'[`split_egg_con_se']"
				putexcel J`pos' = "`split_egg_con_se'"
				
				if (egger_cons_p[1]<0.001){
					local split_egg_cons_p = "<0.001"
				}
				else{
					local split_egg_cons_p = round(egger_cons_p[1],0.001)
				}
				putexcel K`pos' = "`split_egg_cons_p'"
				
				local split_mode_beta = round(mode[1],0.001)
				local split_mode_se = round(mode_se[1],0.001)
				putexcel L`pos' = "`split_mode_beta'[`split_mode_se']"
				putexcel M`pos' = "`split_mode_se'"
				
				if (mode_p[1]<0.001){
				    local split_mode_p = "<0.001"
				}
				else{
				    local split_mode_p = round(mode_p[1],0.001)
				}
				putexcel N`pos' = "`split_mode_p'"
				
				local split_median_beta = round(median[1],0.001)
				local split_median_se = round(median_se[1],0.001)
				putexcel O`pos' = "`split_median_beta'[`split_median_se']"
				putexcel P`pos' = "`split_median_se'"
				
				if (median_p<0.001){
				    local split_median_p = "<0.001"
				}
				else {
				    local split_median_p = round(median_p,0.001)
				}
				putexcel Q`pos' = "`split_median_p'"
				
				
				local pos = `pos' + 1
				
			} 
		}
	}
}

putexcel save
putexcel clear
clear


