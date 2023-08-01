*script name: cdmm_15.do
*script author: Teri North
*date created: 20.10.20
*date last edited: 22.2.22
*script purpose: main split sample observational & genetic analyses, incl meta-analysis 


cd 

use "$xxxxxx\self_report_phenotypes_v5.dta", clear
program drop _all

*set seed for bootstrapping so we obtain the same SEs when re-running the code
set seed 271210971

*set number of repeats for bootstrapping 
local nbootstrap = 200 



********************************************************************************
**********************define programs*******************************************

*define program to calculate the indirect effect & propn mediated of an exposure given one or more mediators (mv lin regression)
program calc_indirect_pm, rclass
	args cellcode1 cellcode2 outv expv medv covsv
	
	regress `outv' `expv' `covsv', vce(robust)
	scalar tot_eff = _b[`expv'] // total effect
	di tot_eff
	
	regress `outv' `expv' `medv' `covsv', vce(robust)
	scalar di_eff = _b[`expv'] // direct effect
	di di_eff
	
	scalar temp_ind_eff = tot_eff - di_eff
	di temp_ind_eff
	return scalar ind_eff = tot_eff - di_eff // indirect effect
	
	
	return scalar propn_med = temp_ind_eff/tot_eff // propn mediated
	
	
end


*now define analagous program for MR in each split
program mrcalc_indirect_pm, rclass
	args mcellcode1 mcellcode2 moutv mexpv mmedv mcovsv prsmedv prsexpv msplit
	
	ivreg2 `moutv' (`mexpv' = `prsexpv') `mcovsv', robust endog(`mexpv')
	scalar mtot_eff = _b[`mexpv'] // total effect (MR)
	di mtot_eff
	
	ivreg2 `moutv' (`mexpv' `mmedv' = `prsexpv' `prsmedv') `mcovsv', robust endog(`mexpv' `mmedv')
	scalar mdi_eff = _b[`mexpv'] // direct effect [MR]
	di mdi_eff
	
	scalar mtemp_ind_eff = mtot_eff - mdi_eff
	di mtemp_ind_eff
	return scalar R_mind_eff = mtot_eff - mdi_eff
	
	return scalar R_mpropn_med =  mtemp_ind_eff/mtot_eff
	
end 





********************************************************************************

*housekeeping
rename phe_eduyears_scaled_1 phe_education_1
rename phe_eduyears_scaled_2 phe_education_2
rename phe_alcohol_intake_1 phe_alcohol_1
rename phe_alcohol_intake_2 phe_alcohol_2

*Create table
gen exposure1 = ""
gen exposure2 = ""
gen outcome = ""
gen type = ""
gen beta_int = .
gen se_int = .
gen double p_int = .
gen p_endog = .
gen f_stat = .
gen n = .
gen r2 = .
gen beta_exp1 = . 
gen se_exp1 = .
gen double p_exp1 = .
gen beta_exp2 = .
gen se_exp2 = .
gen double p_exp2 = .

dis "Observational analysis begins"
local i = 1

*Observational analysis on whole sample
*Multivariable adjusted linear estimates 

*set up excel file for writing results
putexcel set table2, replace sheet("table2")
putexcel A1 = "Exposure"
putexcel B1 = "Outcome"
putexcel C1 = "Beta* (3 d.p.)"
putexcel D1 = "95% CI (3 d.p.)"
putexcel E1 = "p-value (3 d.p.)"
putexcel F1 = "N"
putexcel G1 = "lower ci"
putexcel H1 = "upper ci"

local comb_phe = "phe_alcohol_intake phe_bmi phe_eduyears_scaled phe_lifetime_smoking"
local comb_outc = "out_multimorbid_SR_2 out_multimorbid_SRnoalc_2 out_multimorbid_SR_3 out_multimorbid_SRnoalc_3 out_multimorbid_SR_4 out_multimorbid_SRnoalc_4 out_multimorb_index_SR out_multimorb_index_noalcSR"
local pos = 2

foreach phe of varlist `comb_phe' {
	foreach var of varlist `comb_outc' { 
		if ((strpos("`var'","noalc")==0 & strpos("`phe'","alcohol")==0)|(strpos("`var'","noalc")>0 & strpos("`phe'","alcohol")>0)){
			local pclist = ""
			foreach num of numlist 1/40 {
				local pc`num' = "pc`num'"
				local pclist = "`pclist' `pc`num''" 
			}
			reg `var' `phe' age sex `pclist' i.centre, vce(robust)
			local exposure1 = substr("`phe'",5,.)
			local exposure1 = subinstr("`exposure1'","_"," ",.)
			local exposure2 = "na"
			local outcome = substr("`var'",5,.)
			matrix a = e(b)
			matrix b = e(V)
			local beta_exp1 = round(a[1,1],0.001)
			local se_exp1 = round(sqrt(b[1,1]),0.001)
			local p_exp1 = 2*ttail(e(df_r),abs(a[1,1]/sqrt(b[1,1])))
			di `p_exp1'
			local n = e(N)
			local CIlower_exp1 = round(a[1,1] - invttail(e(df_r),0.025)*sqrt(b[1,1]),0.001)
			local CIupper_exp1 = round(a[1,1] + invttail(e(df_r),0.025)*sqrt(b[1,1]),0.001)
			di "`CIlower_exp1'"
			di "`CIupper_exp1'"
			local CIinterval_exp1 = "(`CIlower_exp1',`CIupper_exp1')"
			foreach x in exposure1 exposure2 outcome beta_exp1 se_exp1 p_exp1 n {
				if "`x'" == "beta_exp1" | "`x'" == "se_exp1" | "`x'" == "p_exp1" | "`x'" == "n" {
					qui replace `x' = ``x'' in `i'
				}
				else {
					qui replace `x' = "``x''" in `i'
				}
			}
			qui replace type = "One sample Multivariable Adjusted" in `i'
			local i = `i'+1
			
			local expcell = "A`pos'"
			putexcel `expcell' = "`exposure1'"
			
			local outcell = "B`pos'"
			putexcel `outcell' = "`outcome'"
			
			local betacell = "C`pos'"
			putexcel `betacell' = "`beta_exp1'"
			
			local CIcell = "D`pos'"
			putexcel `CIcell' = "`CIinterval_exp1'"
			
			local pvalcell = "E`pos'"
			if (`p_exp1'<0.001){
			    local p_exp1="<0.001"
			}
			else {
				local p_exp1=round(`p_exp1',0.001)
			}
			putexcel `pvalcell' = "`p_exp1'"
	
			local Ncell = "F`pos'"
			putexcel `Ncell' = "`n'"
			
			local lcicell = "G`pos'"
			putexcel `lcicell'= "`CIlower_exp1'"
			
			local ucicell = "H`pos'"
			putexcel `ucicell'= "`CIupper_exp1'"
				
			local pos = `pos' +1
			
		}
	}

}


putexcel save
putexcel clear




*Observational analysis on whole sample
*Multivariable adjusted linear estimate for interaction term

*set up excel file for writing results
putexcel set table4a, replace sheet("table4a")
putexcel A1 = "Exposure 1"
putexcel B1 = "Exposure 2"
putexcel C1 = "Outcome"
putexcel D1 = "Beta* (3 d.p.) [I2]"
putexcel E1 = "95% CI (3 d.p.)"

putexcel F1 = "Beta* (3 d.p.) [I2]"
putexcel G1 = "95% CI (3 d.p.)"

putexcel H1 = "Beta* (3 d.p.) [I2]"
putexcel I1 = "95% CI (3 d.p.)"


putexcel J1 = "p-value for interaction (2 s.f.)"
putexcel K1 = "N"

local comb_interac = "phe_bmi_smok phe_bmi_alc phe_bmi_edu phe_smok_alc phe_smok_edu phe_alc_edu"
local comb_out = "out_multimorbid_SR_2 out_multimorbid_SRnoalc_2 out_multimorb_index_SR out_multimorb_index_noalcSR"
local pos = 2

foreach interac of varlist `comb_interac' {
	foreach var of varlist `comb_out' { 
		if ((strpos("`var'","noalc")==0 & strpos("`interac'","alc")==0)|(strpos("`var'","noalc")>0 & strpos("`interac'","alc")>0)){
			local pclist = ""
			foreach num of numlist 1/40 {
				local pc`num' = "pc`num'"
				local pclist = "`pclist' `pc`num''" 
			}
			
			if ("`interac'"=="phe_bmi_smok") {
				local phe1 = "phe_bmi"
				local phe2 = "phe_lifetime_smoking"
			}
			else if ("`interac'"=="phe_bmi_alc"){
				local phe1 = "phe_bmi"
				local phe2 = "phe_alcohol_intake"
			}
			else if ("`interac'"=="phe_bmi_edu"){
				local phe1 = "phe_bmi"
				local phe2 = "phe_eduyears_scaled"
			}
			else if ("`interac'"=="phe_smok_alc"){
				local phe1 = "phe_lifetime_smoking"
				local phe2 = "phe_alcohol_intake"
			}
			else if ("`interac'"=="phe_smok_edu"){
				local phe1 = "phe_lifetime_smoking"
				local phe2 = "phe_eduyears_scaled"
			}
			else if ("`interac'"=="phe_alc_edu"){
				local phe1 = "phe_alcohol_intake"
				local phe2 = "phe_eduyears_scaled"
			}
			
			reg `var' `interac' `phe1' `phe2' age sex `pclist' i.centre, vce(robust)
							
			
			local exposure1 = substr("`phe1'",5,.)
			local exposure1 = subinstr("`exposure1'","_"," ",.)
			local exposure2 = substr("`phe2'",5,.)
			local exposure2 = subinstr("`exposure2'","_"," ",.)
			
			local outcome = substr("`var'",5,.)
			
			matrix a = e(b)
			matrix b = e(V)
			local beta_int = round(a[1,1],0.001)
			di `beta_int'
			local se_int = round(sqrt(b[1,1]),0.001)
			di `se_int'
			local p_int = 2*ttail(e(df_r),abs(a[1,1]/sqrt(b[1,1])))
			di `p_int'
			local n = e(N)
			local CIlower_int = round(a[1,1] - invttail(e(df_r),0.025)*sqrt(b[1,1]),0.001)
			local CIupper_int = round(a[1,1] + invttail(e(df_r),0.025)*sqrt(b[1,1]),0.001)
			di "`CIlower_int'"
			di "`CIupper_int'"
			local CIinterval_int = "(`CIlower_int',`CIupper_int')"
			
			local beta_exp1 = round(a[1,2],0.001)
			di `beta_exp1'
			di sqrt(b[2,2])
			local CIlower_exp1 = round(a[1,2] - invttail(e(df_r),0.025)*sqrt(b[2,2]),0.001)
			local CIupper_exp1 = round(a[1,2] + invttail(e(df_r),0.025)*sqrt(b[2,2]),0.001)
			di "`CIlower_exp1'"
			di "`CIupper_exp1'"
			local CIinterval_exp1 = "(`CIlower_exp1',`CIupper_exp1')"
			
			local beta_exp2 = round(a[1,3],0.001)
			di `beta_exp2'
			di sqrt(b[3,3])
			local CIlower_exp2 = round(a[1,3] - invttail(e(df_r),0.025)*sqrt(b[3,3]),0.001)
			local CIupper_exp2 = round(a[1,3] + invttail(e(df_r),0.025)*sqrt(b[3,3]),0.001)
			di "`CIlower_exp2'"
			di "`CIupper_exp2'"
			local CIinterval_exp2 = "(`CIlower_exp2',`CIupper_exp2')"
			
			
			
			
			foreach x in exposure1 exposure2 outcome beta_int se_int p_int n {
				if "`x'" == "beta_int" | "`x'" == "se_int" | "`x'" == "p_int" | "`x'" == "n" {
					qui replace `x' = ``x'' in `i'
				}
				else {
					qui replace `x' = "``x''" in `i'
				}
			}
			qui replace type = "One sample Multivariable Adjusted with interaction term" in `i'
			local i = `i'+1
			
			local expcell1 = "A`pos'"
			putexcel `expcell1' = "`exposure1'"
			
			local expcell2 = "B`pos'"
			putexcel `expcell2' = "`exposure2'"
			
			local outcell = "C`pos'"
			putexcel `outcell' = "`outcome'"
			
			local betacell1 = "D`pos'"
			putexcel `betacell1' = "`beta_exp1'"
			
			local CIcell1 = "E`pos'"
			putexcel `CIcell1' = "`CIinterval_exp1'"
			
						
			local betacell2 = "F`pos'"
			putexcel `betacell2' = "`beta_exp2'"
			
			local CIcell2 = "G`pos'"
			putexcel `CIcell2' = "`CIinterval_exp2'"
			
			
			local betacell_int = "H`pos'"
			putexcel `betacell_int' = "`beta_int'"
			
			local CIcell_int = "I`pos'"
			putexcel `CIcell_int' = "`CIinterval_int'"
			
			
			
			
			local pvalcell = "J`pos'"
			if (`p_int'<0.001){
			    local p_int="<0.001"
			}
			else {
				local p_int=round(`p_int',0.001)
			}
			putexcel `pvalcell' = "`p_int'"
	
			local Ncell = "K`pos'"
			putexcel `Ncell' = "`n'"
			
				
			local pos = `pos' +1
			
		}
	}

}


putexcel save
putexcel clear


save "$xxxxxx\self_report_phenotypes_v5_boot.dta", replace


*********************
*Mediation analyses *
*********************

*set up excel file for writing results
putexcel set med_obs, replace sheet("med_obs")
putexcel A1 = "Outcome"
putexcel B1 = "Exposure"
putexcel C1 = "Mediator1"
putexcel D1 = "Mediator2"
putexcel E1 = "Mediator3"
putexcel F1 = "Indirect effect"
putexcel G1 = "Indirect se"
putexcel H1 = "Proportion mediated"
putexcel I1 = "Proportion mediated se"
putexcel J1 = "N"
putexcel K1 = "Indirect effect 95% lower ci"
putexcel L1 = "Indirect effect 95% upper ci"
putexcel M1 = "Propn mediated 95% lower ci"
putexcel N1 = "Propn mediated 95% upper ci"

local pos = 2

foreach medout in out_multimorbid_SR_2 out_multimorb_index_SR  {
    
	if "`medout'"=="out_multimorbid_SR_2" {
		local new_med_out="out_multimorbid_SRnoalc_2"
	}
	else if "`medout'"=="out_multimorb_index_SR" {
		local new_med_out="out_multimorb_index_noalcSR"
	}


	*mediator = BMI
	use "$xxxxxx\self_report_phenotypes_v5_boot.dta", clear
	
	putexcel A`pos' = "`medout'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "BMI"
	putexcel D`pos' = "NA"
	putexcel E`pos' = "NA"
	
	*restrict dataset to non-missing variables of interest
	count if `medout'!=. & phe_eduyears_scaled!=. & phe_bmi!=. & age!=. & sex!=. & pc40!=. & centre!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	putexcel J`pos' = "`bootsize'"
	
	keep if  `medout'!=. & phe_eduyears_scaled!=. & phe_bmi!=. & age!=. & sex!=. & pc40!=. & centre!=.

	
	
	*first write the main regression coeffs
	local pclist=""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_bmi" "age sex `pclist' i.centre"
	return list

	local fpos = round(r(ind_eff),0.001)
	putexcel F`pos' = "`fpos'"
	local hpos = round(r(propn_med),0.001)
	putexcel H`pos' = "`hpos'"
	
	return clear
	scalar drop _all

	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	local pclist = ""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	bootstrap indirect_eff_est=r(ind_eff), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_bmi" "age sex `pclist' i.centre"
	matrix results_indeff = r(table)
	local boot_indeff_ll = round(results_indeff[5,1],0.001)
	local boot_indeff_ul = round(results_indeff[6,1],0.001)
	di "`boot_indeff_ul'"
	local boot_indeff_ci = "(`boot_indeff_ll',`boot_indeff_ul')"
	di "`boot_indeff_ci'"
	
	local gpos = round(results_indeff[2,1],0.0001) 
	putexcel G`pos' = "`gpos'"
	putexcel K`pos' = "`boot_indeff_ll'"
	putexcel L`pos' = "`boot_indeff_ul'"

	return clear
	scalar drop _all

	bootstrap proportion_med_est = r(propn_med), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_bmi" "age sex `pclist' i.centre"
	matrix results_propmed = r(table)
	local boot_propmed_ll = round(results_propmed[5,1],0.001)
	local boot_propmed_ul = round(results_propmed[6,1],0.001)
	di "`boot_propmed_ul'"
	local boot_propmed_ci = "(`boot_propmed_ll',`boot_propmed_ul')"
	di "`boot_propmed_ci'"
	
	local ipos = round(results_propmed[2,1],0.0001) 
	putexcel I`pos' = "`ipos'"
	putexcel M`pos' = "`boot_propmed_ll'"
	putexcel N`pos' = "`boot_propmed_ul'"
	

	return clear
	scalar drop _all

	local pos = `pos' +1
	
	 
	*mediator = alcohol	
	use "$xxxxxx\self_report_phenotypes_v5_boot.dta", clear
	*macro list _all 
	macro drop _pclist _bootsize _boot_indeff_ll _boot_indeff_ul _boot_indeff_ci _boot_propmed_ll _boot_propmed_ul _boot_propmed_ci _fpos _hpos _gpos _ipos
	matrix drop results_indeff results_propmed
	*macro list _all
	
	putexcel A`pos' = "`new_med_out'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "Alcohol"
	putexcel D`pos' = "NA"
	putexcel E`pos' = "NA"
	
	*restrict dataset
	count if `new_med_out'!=. & phe_eduyears_scaled!=. & phe_alcohol_intake!=. & age!=. & sex!=. & pc40!=. & centre!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	putexcel J`pos' = "`bootsize'"
	
	keep if `new_med_out'!=. & phe_eduyears_scaled!=. & phe_alcohol_intake!=. & age!=. & sex!=. & pc40!=. & centre!=.

	
	*first write the main regression coeffs
	di "`pclist'" //CHECK THIS IS EMPTY
	local pclist="" 
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	calc_indirect_pm "XX" "XX" "`new_med_out'" "phe_eduyears_scaled" "phe_alcohol_intake" "age sex `pclist' i.centre"
	
	local fpos = round(r(ind_eff),0.001)
	putexcel F`pos' = "`fpos'"
	local hpos = round(r(propn_med),0.001)
	putexcel H`pos' = "`hpos'"

	return clear
	scalar drop _all

	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	local pclist=""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	bootstrap indirect_eff_est=r(ind_eff), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`new_med_out'" "phe_eduyears_scaled" "phe_alcohol_intake" "age sex `pclist' i.centre"
	matrix results_indeff = r(table)
	local boot_indeff_ll = round(results_indeff[5,1],0.001)
	local boot_indeff_ul = round(results_indeff[6,1],0.001)
	di "`boot_indeff_ul'"
	local boot_indeff_ci = "(`boot_indeff_ll',`boot_indeff_ul')"
	di "`boot_indeff_ci'"
	
	local gpos = round(results_indeff[2,1],0.0001) 
	putexcel G`pos' = "`gpos'"
	putexcel K`pos' = "`boot_indeff_ll'"
	putexcel L`pos' = "`boot_indeff_ul'"

	return clear
	scalar drop _all

	bootstrap proportion_med_est = r(propn_med), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`new_med_out'" "phe_eduyears_scaled" "phe_alcohol_intake" "age sex `pclist' i.centre"
	matrix results_propmed = r(table)
	local boot_propmed_ll = round(results_propmed[5,1],0.001)
	local boot_propmed_ul = round(results_propmed[6,1],0.001)
	di "`boot_propmed_ul'"
	local boot_propmed_ci = "(`boot_propmed_ll',`boot_propmed_ul')"
	di "`boot_propmed_ci'"
	
	local ipos = round(results_propmed[2,1],0.0001) 
	putexcel I`pos' = "`ipos'"
	putexcel M`pos' = "`boot_propmed_ll'"
	putexcel N`pos' = "`boot_propmed_ul'"

	return clear
	scalar drop _all

	local pos = `pos' +1
	

	*mediator = lifetime smoking
	use "$xxxx\self_report_phenotypes_v5_boot.dta", clear
	macro drop _pclist _bootsize _boot_indeff_ll _boot_indeff_ul _boot_indeff_ci _boot_propmed_ll _boot_propmed_ul _boot_propmed_ci _fpos _hpos _gpos _ipos
	matrix drop results_indeff results_propmed
	
	putexcel A`pos' = "`medout'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "Lifetime smoking"
	putexcel D`pos' = "NA"
	putexcel E`pos' = "NA"
	
	*restrict dataset
	count if `medout'!=. & phe_eduyears_scaled!=. & phe_lifetime_smoking!=. & age!=. & sex!=. & pc40!=. & centre!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	putexcel J`pos' = "`bootsize'"
	
	keep if `medout'!=. & phe_eduyears_scaled!=. & phe_lifetime_smoking!=. & age!=. & sex!=. & pc40!=. & centre!=.

	
	*first write the main regression coeffs
	local pclist=""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_lifetime_smoking" "age sex `pclist' i.centre"
	local fpos = round(r(ind_eff),0.001)
	putexcel F`pos' = "`fpos'"
	local hpos = round(r(propn_med),0.001)
	putexcel H`pos' = "`hpos'"

	return clear
	scalar drop _all

	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	local pclist=""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	bootstrap indirect_eff_est=r(ind_eff), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_lifetime_smoking" "age sex `pclist' i.centre"
	matrix results_indeff = r(table)
	local boot_indeff_ll = round(results_indeff[5,1],0.001)
	local boot_indeff_ul = round(results_indeff[6,1],0.001)
	di "`boot_indeff_ul'"
	local boot_indeff_ci = "(`boot_indeff_ll',`boot_indeff_ul')"
	di "`boot_indeff_ci'"
	
	local gpos = round(results_indeff[2,1],0.0001) 
	putexcel G`pos' = "`gpos'"
	putexcel K`pos' = "`boot_indeff_ll'"
	putexcel L`pos' = "`boot_indeff_ul'"

	return clear
	scalar drop _all

	bootstrap proportion_med_est = r(propn_med), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_lifetime_smoking" "age sex `pclist' i.centre"
	matrix results_propmed = r(table)
	local boot_propmed_ll = round(results_propmed[5,1],0.001)
	local boot_propmed_ul = round(results_propmed[6,1],0.001)
	di "`boot_propmed_ul'"
	local boot_propmed_ci = "(`boot_propmed_ll',`boot_propmed_ul')"
	di "`boot_propmed_ci'"

	local ipos = round(results_propmed[2,1],0.0001) 
	putexcel I`pos' = "`ipos'"
	putexcel M`pos' = "`boot_propmed_ll'"
	putexcel N`pos' = "`boot_propmed_ul'"

	return clear
	scalar drop _all


	local pos = `pos' +1
	
	
	*mediators = BMI and smoking combined
	use "$xxxx\self_report_phenotypes_v5_boot.dta", clear
	macro drop _pclist _bootsize _boot_indeff_ll _boot_indeff_ul _boot_indeff_ci _boot_propmed_ll _boot_propmed_ul _boot_propmed_ci _fpos _hpos _gpos _ipos
	matrix drop results_indeff results_propmed

	putexcel A`pos' = "`medout'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "BMI"
	putexcel D`pos' = "NA"
	putexcel E`pos' = "Lifetime smoking"
	
	*restrict dataset
	count if `medout'!=. & phe_eduyears_scaled!=. & phe_bmi!=. & phe_lifetime_smoking!=. & age!=. & sex!=. & pc40!=. & centre!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	putexcel J`pos' = "`bootsize'"
	
	keep if `medout'!=. & phe_eduyears_scaled!=. & phe_bmi!=. & phe_lifetime_smoking!=. & age!=. & sex!=. & pc40!=. & centre!=.


	*first write the main regression coeffs
	local pclist=""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_bmi phe_lifetime_smoking" "age sex `pclist' i.centre"
	return list
	local fpos = round(r(ind_eff),0.001)
	putexcel F`pos' = "`fpos'"
	local hpos = round(r(propn_med),0.001)
	putexcel H`pos' = "`hpos'"

	return clear
	scalar drop _all

	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	local pclist=""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'"
		local pclist = "`pclist' `pc`num''" 
	}
	bootstrap indirect_eff_est=r(ind_eff), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_bmi phe_lifetime_smoking" "age sex `pclist' i.centre"
	matrix results_indeff = r(table)
	local boot_indeff_ll = round(results_indeff[5,1],0.001)
	local boot_indeff_ul = round(results_indeff[6,1],0.001)
	di "`boot_indeff_ul'"
	local boot_indeff_ci = "(`boot_indeff_ll',`boot_indeff_ul')"
	di "`boot_indeff_ci'"
	
	local gpos = round(results_indeff[2,1],0.0001) 
	putexcel G`pos' = "`gpos'"
	putexcel K`pos' = "`boot_indeff_ll'"
	putexcel L`pos' = "`boot_indeff_ul'"
	
	return clear
	scalar drop _all

	bootstrap proportion_med_est = r(propn_med), reps(`nbootstrap') size(`bootsize') nodrop: calc_indirect_pm "XX" "XX" "`medout'" "phe_eduyears_scaled" "phe_bmi phe_lifetime_smoking" "age sex `pclist' i.centre"
	di `e(N)'
	matrix results_propmed = r(table)
	local boot_propmed_ll = round(results_propmed[5,1],0.001)
	local boot_propmed_ul = round(results_propmed[6,1],0.001)
	di "`boot_propmed_ul'"
	local boot_propmed_ci = "(`boot_propmed_ll',`boot_propmed_ul')"
	di "`boot_propmed_ci'"
	
	local ipos = round(results_propmed[2,1],0.0001) 
	putexcel I`pos' = "`ipos'"
	putexcel M`pos' = "`boot_propmed_ll'"
	putexcel N`pos' = "`boot_propmed_ul'"

	return clear
	scalar drop _all

	local pos = `pos' +1

}

putexcel save
putexcel clear


*******************************************************************************
use "$xxxx\self_report_phenotypes_v5_boot.dta", clear
*drop combined variables made in cdmm_13.do
drop age sex out_multimorbid_SR_2 out_multimorbid_SR_3 out_multimorbid_SR_4 out_multimorb_index_SR out_multimorbid_SRnoalc_2 out_multimorbid_SRnoalc_3 out_multimorbid_SRnoalc_4 out_multimorb_index_noalcSR phe_alcohol_intake phe_bmi phe_eduyears_scaled phe_lifetime_smoking grs_bmi grs_alcohol grs_lifetime_smoking grs_education

*drop combined interaction terms made in cdmm_14.do
drop phe_bmi_smok phe_bmi_alc phe_bmi_edu phe_smok_alc phe_smok_edu phe_alc_edu


*IV reg
dis "IV reg begins"
qui sum beta_exp1


*set up the excel table for depositing results
putexcel set tableS3, replace sheet("tableS3")
putexcel A1 = "Exposure"
putexcel B1 = "Outcome"
putexcel C1 = "Beta* (3 d.p.) "
putexcel D1 = "95% CI (3 d.p.)"
putexcel E1 = "p-value (3 d.p.)"
putexcel F1 = "N"
putexcel G1 = "lci"
putexcel H1 = "uci"

local pos = 2


*MR analysis
foreach grs of varlist grs* {
	local phe = substr("`grs'",4,.)
	local phe = "phe`phe'"
	di "`phe'"
	*now the suffix of the grs needs to be alternate split to the exposure/outcome
	if (strpos("`phe'","1")>0){
	    local phe = subinstr("`phe'","1","_2",.)
	} 
	else if (strpos("`phe'","2")>0) {
	    local phe = subinstr("`phe'","2","_1",.)
	}
	
	di "Phenotype = `phe'"
	
	foreach var of varlist out_* { 
		di "`var'"
		di "`grs'"
		if (substr("`phe'",-1,1)==substr("`var'",-1,1)) {
			di "proceed"
			if ((strpos("`var'","noalc")==0 & strpos("`phe'","alcohol")==0)|(strpos("`var'","noalc")>0 & strpos("`phe'","alcohol")>0)){
				
				local suffix = substr("`phe'",-1,1)
				local age="age_`suffix'"
				di "`age'"
				local sex="sex_`suffix'"
				local centre="centre_`suffix'"
				local pclist = ""
				
				foreach num of numlist 1/40 {
					local pc`num' = "pc`num'_`suffix'"
					local pclist = "`pclist' `pc`num''"  
				}
				display "`pclist'"
				ivreg2 `var' (`phe' = `grs') `age' `sex' `pclist' i.`centre', robust endog(`phe')
				di "`var'" " " "`phe'" " " "`grs'"  
				local exposure1 = substr("`phe'",5,.)
				local exposure1 = subinstr("`exposure1'","_"," ",.)
				local exposure2 = "na"
				local outcome = substr("`var'",5,.)
				local f_stat = e(widstat)
				matrix a = e(b)
				matrix b = e(V)
				local beta_exp1 = a[1,1]
				local se_exp1 = sqrt(b[1,1])
				local p_exp1 = 2*normal(-abs(a[1,1]/sqrt(b[1,1])))
				di `p_exp1'
				local p_endog = e(estatp)
				local n = e(N)
				
				local quick_check = a[1,1] - invnorm(0.975)*sqrt(b[1,1])
				di `quick_check'
				
				local CIlower_exp1 = round(a[1,1] - invnorm(0.975)*sqrt(b[1,1]),0.001)
				local CIupper_exp1 = round(a[1,1] + invnorm(0.975)*sqrt(b[1,1]),0.001)
				di "`CIlower_exp1'"
				di "`CIupper_exp1'"
				local CIinterval_exp1 = "(`CIlower_exp1',`CIupper_exp1')"
			
			
			
				
				foreach x in exposure1 exposure2 outcome beta_exp1 se_exp1 p_exp1 p_endog n f_stat {
					if "`x'" == "beta_exp1" | "`x'" == "se_exp1" | "`x'" == "p_exp1" | "`x'" == "p_endog" | "`x'" == "n" | "`x'" == "f_stat" {
						qui replace `x' = ``x'' in `i'
					}
					else {
						qui replace `x' = "``x''" in `i'
					}	
				}
				qui replace type = "IV reg" in `i'
				local i = `i'+1
				
				local expcell1 = "A`pos'"
				putexcel `expcell1' = "`exposure1'"
				
				local outcell = "B`pos'"
				putexcel `outcell' = "`outcome'"
			
				local betacell = "C`pos'"
				local round_beta = round(`beta_exp1',0.001)
				putexcel `betacell' = `round_beta'
			
				local CIcell = "D`pos'"
				putexcel `CIcell' = "`CIinterval_exp1'"
			
				local pvalcell = "E`pos'"
				if (`p_exp1'<0.001){
					local p_exp1="<0.001"
				}
				else {
					local p_exp1=round(`p_exp1',0.001)
				}
				putexcel `pvalcell' = "`p_exp1'"
	
				local Ncell = "F`pos'"
				putexcel `Ncell' = "`n'"
				
				local lcicell = "G`pos'"
				putexcel `lcicell' = `CIlower_exp1'
				
				local ucicell = "H`pos'"
				putexcel `ucicell' = `CIupper_exp1'
			
				
				local pos = `pos' +1
				
				
				
			}
		}
		
	}
	
}


putexcel save
putexcel clear


*MR for interactions

*now make interaction variables for the GRS scores (in splits only)
*note that these will actually be grs scores in everyone, but when the iv regressions are run it will be limited to the relevant
*splits due to the availability of the exposures/outcomes
gen int_grs_bmi_smok_1=grs_bmi1*grs_lifetime_smoking1
gen int_grs_bmi_smok_2=grs_bmi2*grs_lifetime_smoking2

gen int_grs_bmi_alc_1=grs_bmi1*grs_alcohol1
gen int_grs_bmi_alc_2=grs_bmi2*grs_alcohol2

gen int_grs_bmi_edu_1=grs_bmi1 * grs_education1
gen int_grs_bmi_edu_2=grs_bmi2 * grs_education2

gen int_grs_smok_alc_1=grs_lifetime_smoking1*grs_alcohol1
gen int_grs_smok_alc_2=grs_lifetime_smoking2*grs_alcohol2

gen int_grs_smok_edu_1=grs_lifetime_smoking1*grs_education1 
gen int_grs_smok_edu_2=grs_lifetime_smoking2*grs_education2

gen int_grs_alc_edu_1=grs_alcohol1*grs_education1 
gen int_grs_alc_edu_2=grs_alcohol2*grs_education2

gen int_grs_bmi_bmi_1=grs_bmi1*grs_bmi1
gen int_grs_alc_alc_1=grs_alcohol1*grs_alcohol1
gen int_grs_edu_edu_1=grs_education1*grs_education1
gen int_grs_smok_smok_1=grs_lifetime_smoking1*grs_lifetime_smoking1

gen int_grs_bmi_bmi_2=grs_bmi2*grs_bmi2
gen int_grs_alc_alc_2=grs_alcohol2*grs_alcohol2
gen int_grs_edu_edu_2=grs_education2*grs_education2
gen int_grs_smok_smok_2=grs_lifetime_smoking2*grs_lifetime_smoking2

putexcel set tableS4b, replace sheet("tableS4b")
putexcel A1 = "Exposure 1"
putexcel B1 = "Exposure 2"
putexcel C1 = "Outcome"
putexcel D1 = "Beta* (3 d.p.) [I2]"
putexcel E1 = "95% CI (3 d.p.)"
putexcel F1 = "Beta* (3 d.p.) [I2]"
putexcel G1 = "95% CI (3 d.p.)"
putexcel H1 = "Beta* (3 d.p.) [I2]"
putexcel I1 = "95% CI (3 d.p.)"
putexcel J1 = "p-value for interaction (3 d.p.)"
putexcel K1 = "N"

local pos = 2

*MR analysis - interactions 
local split_out = "out_multimorbid_SR_2_1 out_multimorb_index_SR_1 out_multimorbid_SRnoalc_2_1 out_multimorb_index_noalcSR_1 out_multimorbid_SR_2_2 out_multimorb_index_SR_2 out_multimorbid_SRnoalc_2_2 out_multimorb_index_noalcSR_2"
foreach int of varlist int* {
	
	if "`int'"!="int_grs_bmi_bmi_1" & "`int'"!="int_grs_alc_alc_1" & "`int'"!="int_grs_edu_edu_1" & "`int'"!="int_grs_smok_smok_1" & "`int'"!="int_grs_bmi_bmi_2" & "`int'"!="int_grs_alc_alc_2" & "`int'"!="int_grs_edu_edu_2" & "`int'"!="int_grs_smok_smok_2" {
		
		
	
		if ("`int'"=="int_grs_bmi_smok_1") {
			local phe1 = "phe_bmi_2"
			local phe2 = "phe_lifetime_smoking_2"
			local phe = "phe_bmi_smok_2"
			local grs1 = "grs_bmi1"
			local grs2 = "grs_lifetime_smoking1"
			local same_int = "int_grs_smok_smok_1" // based on mediation assumption smok -> bmi
		}
		else if ("`int'"=="int_grs_bmi_smok_2"){
			local phe1 = "phe_bmi_1"
			local phe2 = "phe_lifetime_smoking_1"
			local phe = "phe_bmi_smok_1"
			local grs1 = "grs_bmi2"
			local grs2 = "grs_lifetime_smoking2"
			local same_int = "int_grs_smok_smok_2" // based on mediation assumption smok -> bmi 
		}
		else if ("`int'"=="int_grs_bmi_alc_1"){
			local phe1 = "phe_bmi_2"
			local phe2 = "phe_alcohol_2"
			local phe = "phe_bmi_alc_2"
			local grs1 = "grs_bmi1"
			local grs2 = "grs_alcohol1"
			local same_int = "int_grs_bmi_bmi_1" // based on mediation assumotion bmi -> alcohol
		}
		else if ("`int'"=="int_grs_bmi_alc_2"){
			local phe1 = "phe_bmi_1"
			local phe2 = "phe_alcohol_1"
			local phe = "phe_bmi_alc_1"
			local grs1 = "grs_bmi2"
			local grs2 = "grs_alcohol2"
			local same_int = "int_grs_bmi_bmi_2" // based on mediation assumption bmi - > alcohol 
		}
		else if ("`int'"=="int_grs_bmi_edu_1"){
			local phe1 = "phe_bmi_2"
			local phe2 = "phe_education_2"
			local phe = "phe_bmi_edu_2"
			local grs1 = "grs_bmi1"
			local grs2 = "grs_education1"
			local same_int = "int_grs_edu_edu_1" // based on mediation assumption education -> bmi
		}
		else if ("`int'"=="int_grs_bmi_edu_2"){
			local phe1 = "phe_bmi_1"
			local phe2 = "phe_education_1"
			local phe = "phe_bmi_edu_1"
			local grs1 = "grs_bmi2"
			local grs2 = "grs_education2"
			local same_int = "int_grs_edu_edu_2" // based on mediation assumption education -> bmi
		}
		else if ("`int'"=="int_grs_smok_alc_1"){
			local phe1 = "phe_lifetime_smoking_2"
			local phe2 = "phe_alcohol_2"
			local phe = "phe_smok_alc_2"
			local grs1 = "grs_lifetime_smoking1"
			local grs2 = "grs_alcohol1"
			local same_int = "int_grs_alc_alc_1" // based on mediation assumption  alcohol -> smoking
		}
		else if ("`int'"=="int_grs_smok_alc_2"){
			local phe1 = "phe_lifetime_smoking_1"
			local phe2 = "phe_alcohol_1"
			local phe = "phe_smok_alc_1"
			local grs1 = "grs_lifetime_smoking2"
			local grs2 = "grs_alcohol2"
			local same_int = "int_grs_alc_alc_2" // based on mediation assumption alcohol -> smoking
		}
		else if ("`int'"=="int_grs_smok_edu_1"){
			local phe1 = "phe_lifetime_smoking_2"
			local phe2 = "phe_education_2"
			local phe = "phe_smok_edu_2"
			local grs1 = "grs_lifetime_smoking1"
			local grs2 = "grs_education1"
			local same_int = "int_grs_edu_edu_1" // based on mediation assumption education -> smoking
		}
		else if ("`int'"=="int_grs_smok_edu_2"){
			local phe1 = "phe_lifetime_smoking_1"
			local phe2 = "phe_education_1"
			local phe = "phe_smok_edu_1"
			local grs1 = "grs_lifetime_smoking2"
			local grs2 = "grs_education2"
			local same_int = "int_grs_edu_edu_2" // based on mediation assumption education -> smoking
		}
		else if ("`int'"=="int_grs_alc_edu_1"){
			local phe1 = "phe_alcohol_2"
			local phe2 = "phe_education_2"
			local phe = "phe_alc_edu_2"
			local grs1 = "grs_alcohol1"
			local grs2 = "grs_education1"
			local same_int = "int_grs_edu_edu_1" // based on mediation assumption education -> alcohol
		}
		else if ("`int'"=="int_grs_alc_edu_2"){
			local phe1 = "phe_alcohol_1"
			local phe2 = "phe_education_1"
			local phe = "phe_alc_edu_1"
			local grs1 = "grs_alcohol2"
			local grs2 = "grs_education2"
			local same_int = "int_grs_edu_edu_2" // based on mediation assumption education -> alcohol
		}
	
		
		foreach var of varlist `split_out' { 
			di "`var'"
			di "`phe'"
			di "`int'"
			if (substr("`phe'",-1,1)==substr("`var'",-1,1)) {
				di "proceed"
				if ((strpos("`var'","noalc")==0 & strpos("`phe'","alc")==0)|(strpos("`var'","noalc")>0 & strpos("`phe'","alc")>0)){
				
					local suffix = substr("`phe'",-1,1)
					local age="age_`suffix'"
					di "`age'"
					local sex="sex_`suffix'"
					local centre="centre_`suffix'"
					local pclist = ""
					foreach num of numlist 1/40 {
						local pc`num' = "pc`num'_`suffix'"
						local pclist = "`pclist' `pc`num''"  
					}
					display "`pclist'"
					ivreg2 `var' (`phe' `phe1' `phe2' = `int' `grs1' `grs2' `same_int') `age' `sex' `pclist' i.`centre', robust endog(`phe' `phe1' `phe2')
					di "`var'" " " "`phe'" " " "`int'"  
					local interaction_term = substr("`phe'",5,.)
					local exposure1 = substr("`phe1'",5,.)
					local exposure1 = subinstr("`exposure1'","_"," ",.)
					local exposure2 = substr("`phe2'",5,.)
					local exposure2 = subinstr("`exposure2'","_"," ",.)
					local outcome = substr("`var'",5,.)
					local f_stat = e(widstat)
					matrix a = e(b) 
					matrix b = e(V)
					local beta_int = a[1,1] 
					di `beta_int'
					local se_int = sqrt(b[1,1])
					di `se_int'
					local p_int = 2*normal(-abs(a[1,1]/sqrt(b[1,1])))
					di `p_int'
					local p_endog = e(estatp)
					local n = e(N)
					
					local quick_check = a[1,1] - invnorm(0.975)*sqrt(b[1,1])
					di `quick_check'
					
					local CIlower_int = round(a[1,1] - invnorm(0.975)*sqrt(b[1,1]),0.001)
					local CIupper_int = round(a[1,1] + invnorm(0.975)*sqrt(b[1,1]),0.001)
					di "`CIlower_int'"
					di "`CIupper_int'"
					local CIinterval_int = "(`CIlower_int',`CIupper_int')"
				
					local beta_exp1 = a[1,2]
					di `beta_exp1'
					local CIlower_exp1 = round(a[1,2] - invnorm(0.975)*sqrt(b[2,2]),0.001)
					local CIupper_exp1 = round(a[1,2] + invnorm(0.975)*sqrt(b[2,2]),0.001)
					di "`CIlower_exp1'"
					di "`CIupper_exp1'"
					local CIinterval_exp1 = "(`CIlower_exp1',`CIupper_exp1')"
					local se_exp1 = sqrt(b[2,2])
					di `se_exp1'
					
					local beta_exp2 = a[1,3]
					di `beta_exp2'
					local CIlower_exp2 = round(a[1,3] - invnorm(0.975)*sqrt(b[3,3]),0.001)
					local CIupper_exp2 = round(a[1,3] + invnorm(0.975)*sqrt(b[3,3]),0.001)
					di "`CIlower_exp2'"
					di "`CIupper_exp2'"
					local CIinterval_exp2 = "(`CIlower_exp2',`CIupper_exp2')"
					local se_exp2 = sqrt(b[3,3])
					di `se_exp2'
					
					
					foreach x in exposure1 exposure2 outcome beta_int se_int p_int p_endog beta_exp1 se_exp1 beta_exp2 se_exp2 n f_stat  {
						if "`x'" == "beta_int" | "`x'" == "se_int" | "`x'" == "p_int" | "`x'" == "p_endog" |"`x'" == "beta_exp1" | "`x'" == "se_exp1"|"`x'" == "beta_exp2" | "`x'" == "se_exp2"| "`x'" == "n" | "`x'" == "f_stat" {
							qui replace `x' = ``x'' in `i'
						}
						else {
							qui replace `x' = "``x''" in `i'
						}	
					}
					qui replace type = "IV reg interaction" in `i'
					local i = `i'+1
					
					
					local expcell1 = "A`pos'"
					putexcel `expcell1' = "`exposure1'"
			
					local expcell2 = "B`pos'"
					putexcel `expcell2' = "`exposure2'"
			
					local outcell = "C`pos'"
					putexcel `outcell' = "`outcome'"
			
					local betacell1 = "D`pos'"
					local round_beta_exp1 = round(`beta_exp1',0.001)
					putexcel `betacell1' = "`round_beta_exp1'"
			
					local CIcell1 = "E`pos'"
					putexcel `CIcell1' = "`CIinterval_exp1'"
			
						
					local betacell2 = "F`pos'"
					local round_beta_exp2 = round(`beta_exp2',0.001)
					putexcel `betacell2' = "`round_beta_exp2'"
			
					local CIcell2 = "G`pos'"
					putexcel `CIcell2' = "`CIinterval_exp2'"
			
			
					local betacell_int = "H`pos'"
					local round_beta_int = round(`beta_int',0.001)
					putexcel `betacell_int' = "`round_beta_int'"
			
					local CIcell_int = "I`pos'"
					putexcel `CIcell_int' = "`CIinterval_int'"
				
								
			
					local pvalcell = "J`pos'"
					if (`p_int'<0.001){
						local p_int="<0.001"
					}
					else {
						local p_int=round(`p_int',0.001)
					}
					putexcel `pvalcell' = "`p_int'"
	
					local Ncell = "K`pos'"
					putexcel `Ncell' = "`n'"
			
				
					local pos = `pos' +1
				
				
				
				}
			}
		
		}
	
	
	
	
	
	
	}
}


putexcel save
putexcel clear




************************
*MR mediation analyses *
************************

save "$xxxxx\self_report_phenotypes_v5_boot_2.dta", replace
macro drop _bootsize


*open excel file for depositing mr split sample mediation results
putexcel set tableSmed, replace sheet("tableSmed")
putexcel A1 = "Outcome"
putexcel B1 = "Exposure"
putexcel C1 = "Mediator1"
putexcel D1 = "Mediator2"
putexcel E1 = "Mediator3"
putexcel F1 = "Indirect effect"
putexcel G1 = "Indirect se"
putexcel H1 = "Proportion mediated"
putexcel I1 = "Proportion mediated se"
putexcel J1 = "N"
putexcel K1 = "Split"


local pos = 2

foreach medout in out_multimorbid_SR_2_1 out_multimorbid_SR_2_2 out_multimorb_index_SR_1 out_multimorb_index_SR_2 {
    
	local split = substr("`medout'",-1,1)
	if "`split'" == "1" {
		local alt_split = "2"
	}
	else if "`split'" == "2" {
		local alt_split = "1"
	}
	
	if "`medout'"=="out_multimorbid_SR_2_1" {
		local new_med_out="out_multimorbid_SRnoalc_2_1"
	}
	else if "`medout'"=="out_multimorbid_SR_2_2" {
		local new_med_out="out_multimorbid_SRnoalc_2_2"
	}
	else if "`medout'"=="out_multimorb_index_SR_1" {
		local new_med_out="out_multimorb_index_noalcSR_1"
	}
	else if "`medout'"=="out_multimorb_index_SR_2" {
		local new_med_out="out_multimorb_index_noalcSR_2"
	}
	
	local pclist = ""
	foreach num of numlist 1/40 {
		local pc`num' = "pc`num'_`split'"
		local pclist = "`pclist' `pc`num''"  
	}
	
	
	
	****************
	*mediator = BMI*
	****************
	use "$xxxxxxxxx\self_report_phenotypes_v5_boot_2.dta", clear
	
	*restrict dataset
	count if `medout'!=. & phe_education_`split'!=. & phe_bmi_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_bmi`alt_split'!=. & grs_education`alt_split'!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	keep if `medout'!=. & phe_education_`split'!=. & phe_bmi_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_bmi`alt_split'!=. & grs_education`alt_split'!=.
	
	*first write the main regression coeffs
	mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_bmi_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_bmi`alt_split'" "grs_education`alt_split'" "`split'"
	return list
		
	local out_medcell = "A`pos'"
	putexcel `out_medcell' = "`medout'"
	
	local exp_medcell = "B`pos'"
	putexcel `exp_medcell' = "Years of education"
	
	local med1_medcell = "C`pos'"
	putexcel `med1_medcell' = "BMI"
	
	local med2_medcell = "D`pos'"
	putexcel `med2_medcell' = "NA"
	
	local med3_medcell = "E`pos'"
	putexcel `med3_medcell' = "NA"
	
	local coef_indirect_eff = "F`pos'"
	putexcel `coef_indirect_eff' = "`r(R_mind_eff)'"
	
	local prop_med = r(R_mpropn_med)
	
	return clear
	scalar drop _all
	
	
	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	bootstrap mrindirect_eff_est=r(R_mind_eff), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_bmi_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_bmi`alt_split'" "grs_education`alt_split'" "`split'"
	matrix mresults_indeff = r(table)
	local mr_boot_indeff_ll = round(mresults_indeff[5,1],0.0001)
	local mr_boot_indeff_ul = round(mresults_indeff[6,1],0.0001)
	di "`mr_boot_indeff_ul'"
	local mr_boot_indeff_ci = "(`mr_boot_indeff_ll',`mr_boot_indeff_ul')"
	di "`mr_boot_indeff_ci'"
		
	*write the bootstrapped se to file
	local se_indirect_eff = "G`pos'"
	putexcel `se_indirect_eff' = mresults_indeff[2,1]  
	
	return clear
	scalar drop _all

	bootstrap mr_proportion_med_est = r(R_mpropn_med), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_bmi_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_bmi`alt_split'" "grs_education`alt_split'" "`split'"
	matrix mresults_propmed = r(table)
	local mr_boot_propmed_ll = round(mresults_propmed[5,1],0.0001)
	local mr_boot_propmed_ul = round(mresults_propmed[6,1],0.0001)
	di "`mr_boot_propmed_ul'"
	local mr_boot_propmed_ci = "(`mr_boot_propmed_ll',`mr_boot_propmed_ul')"
	di "`mr_boot_propmed_ci'"
	
	*write the bootstrapped se to file
	local coef_propn_med = "H`pos'"
	putexcel `coef_propn_med' = "`prop_med'"
	
	local se_propn_med = "I`pos'"
	putexcel `se_propn_med' = mresults_propmed[2,1]  
	
	local n_med = "J`pos'"
	putexcel `n_med' = "`bootsize'"
	
	local split_med = "K`pos'"
	putexcel `split_med' = "`split'"
	
	local pos = `pos' +1
	
	return clear
	scalar drop _all
	

	******************
	*mediator=alcohol*
	******************
	
	use "$xxxxxx\self_report_phenotypes_v5_boot_2.dta", clear
	*macro list _all 
	macro drop _out_medcell _exp_medcell _med1_medcell _med2_medcell _med3_medcell _coef_indirect_eff _prop_med _se_indirect_eff _coef_propn_med _se_propn_med _n_med _split_med
	macro drop _bootsize _mr_boot_indeff_ll _mr_boot_indeff_ul _mr_boot_indeff_ci _mr_boot_propmed_ll _mr_boot_propmed_ul _mr_boot_propmed_ci
	matrix drop mresults_indeff mresults_propmed
	
	
	
	*restrict dataset
	count if `new_med_out'!=. & phe_education_`split'!=. & phe_alcohol_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_alcohol`alt_split'!=. & grs_education`alt_split'!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	
	keep if `new_med_out'!=. & phe_education_`split'!=. & phe_alcohol_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_alcohol`alt_split'!=. & grs_education`alt_split'!=.
	
	*first write the main regression coeffs
	mrcalc_indirect_pm "XX" "XX" "`new_med_out'" "phe_education_`split'" "phe_alcohol_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_alcohol`alt_split'" "grs_education`alt_split'" "`split'"
	
	local out_medcell = "A`pos'"
	putexcel `out_medcell' = "`new_med_out'"
	
	local exp_medcell = "B`pos'"
	putexcel `exp_medcell' = "Years of education"
	
	local med1_medcell = "C`pos'"
	putexcel `med1_medcell' = "Alcohol"
	
	local med2_medcell = "D`pos'"
	putexcel `med2_medcell' = "NA"
	
	local med3_medcell = "E`pos'"
	putexcel `med3_medcell' = "NA"
	
	local coef_indirect_eff = "F`pos'"
	putexcel `coef_indirect_eff' = "`r(R_mind_eff)'"
	
	local prop_med = r(R_mpropn_med)
	
	return clear
	scalar drop _all


	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	bootstrap mrindirect_eff_est=r(R_mind_eff), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`new_med_out'" "phe_education_`split'" "phe_alcohol_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_alcohol`alt_split'" "grs_education`alt_split'" "`split'"
	matrix mresults_indeff = r(table)
	local mr_boot_indeff_ll = round(mresults_indeff[5,1],0.0001)
	local mr_boot_indeff_ul = round(mresults_indeff[6,1],0.0001)
	di "`mr_boot_indeff_ul'"
	local mr_boot_indeff_ci = "(`mr_boot_indeff_ll',`mr_boot_indeff_ul')"
	di "`mr_boot_indeff_ci'"
	
	*write the bootstrapped se to file
	local se_indirect_eff = "G`pos'"
	putexcel `se_indirect_eff' = mresults_indeff[2,1] 
	
	return clear
	scalar drop _all

	bootstrap mr_proportion_med_est = r(R_mpropn_med), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`new_med_out'" "phe_education_`split'" "phe_alcohol_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_alcohol`alt_split'" "grs_education`alt_split'" 
	matrix mresults_propmed = r(table)
	local mr_boot_propmed_ll = round(mresults_propmed[5,1],0.0001)
	local mr_boot_propmed_ul = round(mresults_propmed[6,1],0.0001)
	di "`mr_boot_propmed_ul'"
	local mr_boot_propmed_ci = "(`mr_boot_propmed_ll',`mr_boot_propmed_ul')"
	di "`mr_boot_propmed_ci'"
	
	*write the bootstrapped se to file
	local coef_propn_med = "H`pos'"
	putexcel `coef_propn_med' = "`prop_med'"
	
	local se_propn_med = "I`pos'"
	putexcel `se_propn_med' = mresults_propmed[2,1]  
	
	local n_med = "J`pos'"
	putexcel `n_med' = "`bootsize'"
	
	local split_med = "K`pos'"
	putexcel `split_med' = "`split'"
	
	local pos = `pos' +1
	
	return clear
	scalar drop _all
	
	
	
	*****************************
	*mediator = lifetime smoking*
	*****************************
	use "$xxxxx\self_report_phenotypes_v5_boot_2.dta", clear
	
	*macro list _all 
	macro drop _out_medcell _exp_medcell _med1_medcell _med2_medcell _med3_medcell _coef_indirect_eff _prop_med _se_indirect_eff _coef_propn_med _se_propn_med _n_med _split_med 
	macro drop _bootsize _mr_boot_indeff_ll _mr_boot_indeff_ul _mr_boot_indeff_ci _mr_boot_propmed_ll _mr_boot_propmed_ul _mr_boot_propmed_ci
	matrix drop mresults_indeff mresults_propmed
	*macro list _all
	
	*restrict dataset
	count if `medout'!=. & phe_education_`split'!=. & phe_lifetime_smoking_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_lifetime_smoking`alt_split'!=. & grs_education`alt_split'!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	
	keep if `medout'!=. & phe_education_`split'!=. & phe_lifetime_smoking_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_lifetime_smoking`alt_split'!=. & grs_education`alt_split'!=.
		
		
	*first write the main regression coeffs
	mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_lifetime_smoking_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_lifetime_smoking`alt_split'" "grs_education`alt_split'" "`split'"
	

	local out_medcell = "A`pos'"
	putexcel `out_medcell' = "`medout'"
	
	local exp_medcell = "B`pos'"
	putexcel `exp_medcell' = "Years of education"
	
	local med1_medcell = "C`pos'"
	putexcel `med1_medcell' = "Lifetime smoking"
	
	local med2_medcell = "D`pos'"
	putexcel `med2_medcell' = "NA"
	
	local med3_medcell = "E`pos'"
	putexcel `med3_medcell' = "NA"
	
	local coef_indirect_eff = "F`pos'"
	putexcel `coef_indirect_eff' = "`r(R_mind_eff)'"
	
	local prop_med = r(R_mpropn_med)
	
	return clear
	scalar drop _all

	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	bootstrap mrindirect_eff_est=r(R_mind_eff), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_lifetime_smoking_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_lifetime_smoking`alt_split'" "grs_education`alt_split'" "`split'"
	matrix mresults_indeff = r(table)
	local mr_boot_indeff_ll = round(mresults_indeff[5,1],0.0001)
	local mr_boot_indeff_ul = round(mresults_indeff[6,1],0.0001)
	di "`mr_boot_indeff_ul'"
	local mr_boot_indeff_ci = "(`mr_boot_indeff_ll',`mr_boot_indeff_ul')"
	di "`mr_boot_indeff_ci'"
	
	*write the bootstrapped se to file
	local se_indirect_eff = "G`pos'"
	putexcel `se_indirect_eff' = mresults_indeff[2,1]  
	
	return clear
	scalar drop _all


	bootstrap mr_proportion_med_est = r(R_mpropn_med), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_lifetime_smoking_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_lifetime_smoking`alt_split'" "grs_education`alt_split'" "`split'"
	matrix mresults_propmed = r(table)
	local mr_boot_propmed_ll = round(mresults_propmed[5,1],0.0001)
	local mr_boot_propmed_ul = round(mresults_propmed[6,1],0.0001)
	di "`mr_boot_propmed_ul'"
	local mr_boot_propmed_ci = "(`mr_boot_propmed_ll',`mr_boot_propmed_ul')"
	di "`mr_boot_propmed_ci'"
	

	*write the bootstrapped se to file
	local coef_propn_med = "H`pos'"
	putexcel `coef_propn_med' = "`prop_med'"
	
	local se_propn_med = "I`pos'"
	putexcel `se_propn_med' = mresults_propmed[2,1]  
	
	local n_med = "J`pos'"
	putexcel `n_med' = "`bootsize'"
	
	local split_med = "K`pos'"
	putexcel `split_med' = "`split'"
	
	local pos = `pos' +1
	
	return clear
	scalar drop _all
		
		
	***************************************
	*mediators = BMI and smoking combined *
	***************************************
	
	use "$xxxxx\self_report_phenotypes_v5_boot_2.dta", clear
	*macro list _all 
	macro drop _out_medcell _exp_medcell _med1_medcell _med2_medcell _med3_medcell _coef_indirect_eff _prop_med _se_indirect_eff _coef_propn_med _se_propn_med _n_med _split_med
	macro drop _bootsize _mr_boot_indeff_ll _mr_boot_indeff_ul _mr_boot_indeff_ci _mr_boot_propmed_ll _mr_boot_propmed_ul _mr_boot_propmed_ci
	matrix drop mresults_indeff mresults_propmed

	
	*restrict dataset
	count if `medout'!=. & phe_education_`split'!=. & phe_bmi_`split'!=. & phe_lifetime_smoking_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_bmi`alt_split'!=. & grs_lifetime_smoking`alt_split'!=. & grs_education`alt_split'!=.
	return list
	local bootsize = r(N) 
	di `bootsize'
	
	keep if `medout'!=. & phe_education_`split'!=. & phe_bmi_`split'!=. & phe_lifetime_smoking_`split'!=. & age_`split'!=. & sex_`split'!=. & pc40_`split'!=. & centre_`split'!=. & grs_bmi`alt_split'!=. & grs_lifetime_smoking`alt_split'!=. & grs_education`alt_split'!=.
	
	*first write the main regression coeffs
	mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_bmi_`split' phe_lifetime_smoking_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_bmi`alt_split' grs_lifetime_smoking`alt_split'" "grs_education`alt_split'" "`split'"
		
	local out_medcell = "A`pos'"
	putexcel `out_medcell' = "`medout'"
	
	local exp_medcell = "B`pos'"
	putexcel `exp_medcell' = "Years of education"
	
	local med1_medcell = "C`pos'"
	putexcel `med1_medcell' = "BMI"
	
	local med2_medcell = "D`pos'"
	putexcel `med2_medcell' = "NA"
	
	local med3_medcell = "E`pos'"
	putexcel `med3_medcell' = "Lifetime smoking"
	
	local coef_indirect_eff = "F`pos'"
	putexcel `coef_indirect_eff' = "`r(R_mind_eff)'"
	
	local prop_med = r(R_mpropn_med)
	
	return clear
	scalar drop _all

	*now bootstrap - so repeat the regressions re-sampling from the data, and calculate a bootstrapped 95% CI for the coeffs
	bootstrap mrindirect_eff_est=r(R_mind_eff), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_bmi_`split' phe_lifetime_smoking_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_bmi`alt_split' grs_lifetime_smoking`alt_split'" "grs_education`alt_split'" "`split'"
	matrix mresults_indeff = r(table)
	local mr_boot_indeff_ll = round(mresults_indeff[5,1],0.0001)
	local mr_boot_indeff_ul = round(mresults_indeff[6,1],0.0001)
	di "`mr_boot_indeff_ul'"
	local mr_boot_indeff_ci = "(`mr_boot_indeff_ll',`mr_boot_indeff_ul')"
	di "`mr_boot_indeff_ci'"

	*write the bootstrapped se to file
	local se_indirect_eff = "G`pos'"
	putexcel `se_indirect_eff' = mresults_indeff[2,1]  
	
	return clear
	scalar drop _all
	
	bootstrap mr_proportion_med_est = r(R_mpropn_med), reps(`nbootstrap') size(`bootsize') nodrop: mrcalc_indirect_pm "XX" "XX" "`medout'" "phe_education_`split'" "phe_bmi_`split' phe_lifetime_smoking_`split'" "age_`split' sex_`split' `pclist' centre_`split'" "grs_bmi`alt_split'  grs_lifetime_smoking`alt_split'" "grs_education`alt_split'" "`split'"
	matrix mresults_propmed = r(table)
	local mr_boot_propmed_ll = round(mresults_propmed[5,1],0.0001)
	local mr_boot_propmed_ul = round(mresults_propmed[6,1],0.0001)
	di "`mr_boot_propmed_ul'"
	local mr_boot_propmed_ci = "(`mr_boot_propmed_ll',`mr_boot_propmed_ul')"
	di "`mr_boot_propmed_ci'"

	*write the bootstrapped se to file
	local coef_propn_med = "H`pos'"
	putexcel `coef_propn_med' = "`prop_med'"
	
	local se_propn_med = "I`pos'"
	putexcel `se_propn_med' = mresults_propmed[2,1]  
	
	local n_med = "J`pos'"
	putexcel `n_med' = "`bootsize'"
	
	local split_med = "K`pos'"
	putexcel `split_med' = "`split'"
	
	local pos = `pos' +1
	
	return clear
	scalar drop _all
	
		
	
	
}




putexcel save
putexcel clear


************************************meta-analysis********************************

use "$xxxxx\self_report_phenotypes_v5_boot_2.dta", clear
keep exposure1-p_exp2
drop if exposure1 == ""
replace outcome = subinstr(outcome,"_"," ",.)

replace exposure1 = strproper(exposure1)
replace exposure2 = strproper(exposure2)
replace outcome = strproper(outcome)

*Replace "/" in the outcomes (causes problems)
qui replace outcome = subinstr(outcome,"/"," or ",.)

*Create a sample variable
gen sample = substr(exposure1,-1,1), a(outcome)
replace sample="" if type =="One sample Multivariable Adjusted"
replace sample="" if type=="One sample Multivariable Adjusted with interaction term"

*Hyphens also cause problems, if you run into any


*Meta-analyse across the 2 samples - single exposure MR

*set-up putexcel
putexcel set table3, replace sheet("table3")
putexcel A1 = "Exposure"
putexcel B1 = "Outcome"
putexcel C1 = "Beta* (3 d.p.) [I2 statistic]"
putexcel D1 = "95% CI (3 d.p.)"
putexcel E1 = "p-value (3 d.p.)"
putexcel F1 = "N"
putexcel G1 = "lower ci"
putexcel H1 = "upper ci"

local pos = 2


local N = c(N)
local N2 = `N'*2
set obs `N2'
local i = `N'+1

gen root_outcome=.

foreach exp in "Alcohol 1" "Bmi 1" "Education 1" "Lifetime Smoking 1" {
	di "`exp'"
    
	local length = length("`exp'")-2
	local e1 = "`exp'"
	local e2 = substr("`exp'",1,`length')
	local e2 = "`e2' 2" 
	local ex = substr("`exp'",1,`length')
	dis "trait = `ex'"
				
	qui replace exposure1 = "`ex'" if (exposure1 == "`e1'" | exposure1 == "`e2'") & type=="IV reg" & sample!=""
	
	replace root_outcome=length(outcome) - 2 if exposure1=="`ex'" & type=="IV reg" & sample!=""
		
	foreach out in "Multimorbid Sr 2" "Multimorbid Srnoalc 2" "Multimorbid Sr 3" "Multimorbid Srnoalc 3" "Multimorbid Sr 4" "Multimorbid Srnoalc 4" "Multimorb Index Sr" "Multimorb Index Noalcsr" {
			   
		qui count if exposure1 == "`ex'" & substr(outcome,1,root_outcome) == "`out'" & type=="IV reg" & sample!=""
		if r(N) > 0 {
			qui replace exposure1 = "`ex'" in `i'
			qui replace outcome = "`out'" in `i'
			qui replace sample = "Combined" in `i'
			qui replace type = "IV reg" in `i'
			metan beta_exp1 se_exp1 if exposure1 == "`ex'" & substr(outcome,1,root_outcome) == "`out'" & type == "IV reg" & sample!="" & sample!="Combined", nograph
			return list
			qui replace beta_exp1 = r(ES) in `i'
			qui replace se_exp1 = r(seES) in `i'
			qui replace p_exp1 = r(p_z) in `i'
			
			local expcell = "A`pos'"
			putexcel `expcell' = "`ex'"
			**
			local outcell = "B`pos'"
			putexcel `outcell' = "`out'"
			**
			local betacell = "C`pos'"
			local round_beta = round(`r(ES)',0.001)
			local round_I2 = round(`r(Isq)',0.01)
			putexcel `betacell' = "`round_beta' [`round_I2']"
			**
			local CIcell = "D`pos'"
			local quick_check = `r(ES)' - invnorm(0.975)*`r(seES)'
			di `r(ES)' "vs" `r(eff)'
			di `r(Isq)'
			di `r(seES)' "vs" `r(se_eff)'
			di `r(p_z)'
			di `quick_check'
			di `r(ci_low)'
				
			local CIlower = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
			local CIupper = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
			di "`CIlower'"
			di "`CIupper'"
			local CIinterval = "(`CIlower',`CIupper')"
			
			putexcel `CIcell' = "`CIinterval'"
			
					
			**
			local pvalcell = "E`pos'"
			local p = `r(p_z)'
			if (`p'<0.001){
			    local p="<0.001"
			}
			else {
				local p=round(`p',0.001)
			}
			putexcel `pvalcell' = "`p'"
			
			sum n if exposure1 == "`ex'" & substr(outcome,1,root_outcome) == "`out'" & type == "IV reg" & sample!="" & sample!="Combined"
			qui replace n = r(sum) in `i' 
			local i = `i' + 1
			
			local Ncell = "F`pos'"
			putexcel `Ncell' = "`r(sum)'"
			
			local lcicell = "G`pos'"
			putexcel `lcicell' = `CIlower'
			
			local ucicell = "H`pos'"
			putexcel `ucicell' = `CIupper'
			
			
			local pos = `pos' +1
			
			
					
		}
			
	}		
	
}

putexcel save
putexcel clear



*Meta-analyse across two samples - interaction MR


*set up excel file for writing results
putexcel set table4b, replace sheet("table4b")
putexcel A1 = "Exposure 1"
putexcel B1 = "Exposure 2"
putexcel C1 = "Outcome"
putexcel D1 = "Beta* (3 d.p.) [I2]"
putexcel E1 = "95% CI (3 d.p.)"
putexcel F1 = "Beta* (3 d.p.) [I2]"
putexcel G1 = "95% CI (3 d.p.)"
putexcel H1 = "Beta* (3 d.p.) [I2]"
putexcel I1 = "95% CI (3 d.p.)"
putexcel J1 = "p-value for interaction (3 d.p.)"
putexcel K1 = "N"

local pos = 2

foreach exp in "Alcohol 1" "Bmi 1" "Education 1" "Lifetime Smoking 1" {
	di "`exp'"
    
	local length = length("`exp'")-2
	local e1 = "`exp'"
	local e2 = substr("`exp'",1,`length')
	local e2 = "`e2' 2" 
	local ex = substr("`exp'",1,`length')
	dis "trait = `ex'"
				
	replace exposure1 = "`ex'" if (exposure1 == "`e1'" | exposure1 == "`e2'") & type=="IV reg interaction" & sample!=""
	
	replace root_outcome=length(outcome) - 2 if exposure1=="`ex'" & type=="IV reg interaction" & sample!=""
	
	foreach oth in "Alcohol 1" "Bmi 1" "Education 1" "Lifetime Smoking 1" {
		di "`oth'"
    
		local tlength = length("`oth'")-2
		local te1 = "`oth'"
		local te2 = substr("`oth'",1,`tlength')
		local te2 = "`te2' 2" 
		local tex = substr("`oth'",1,`tlength')
		dis "trait = `tex'"
				
		replace exposure2 = "`tex'" if (exposure2 == "`te1'" | exposure2 == "`te2'") & type=="IV reg interaction" & sample!=""
	

	
	
		foreach out in "Multimorbid Sr 2" "Multimorbid Srnoalc 2" "Multimorb Index Sr" "Multimorb Index Noalcsr" {
			   
			qui count if exposure1 == "`ex'" & exposure2 == "`tex'" & substr(outcome,1,root_outcome) == "`out'" & type=="IV reg interaction" & sample!=""
			if r(N) > 0 {
				qui replace exposure1 = "`ex'" in `i'
				qui replace exposure2 = "`tex'" in `i'
				qui replace outcome = "`out'" in `i'
				qui replace sample = "Combined" in `i'
				qui replace type = "IV reg interaction" in `i'
				di "`ex'" " " "`tex'" " " "`out'"
				
				local expcell1 = "A`pos'"
				putexcel `expcell1' = "`ex'"
				**
				local expcell2 = "B`pos'"
				putexcel `expcell2' = "`tex'"
				**
				local outcell = "C`pos'"
				putexcel `outcell' = "`out'"
				**
				
				
				metan beta_exp1 se_exp1 if exposure1 == "`ex'" & exposure2 == "`tex'" & substr(outcome,1,root_outcome) == "`out'" & type == "IV reg interaction" & sample!="" & sample!="Combined", nograph
				return list
				qui replace beta_exp1 = r(ES) in `i'
				qui replace se_exp1 = r(seES) in `i'
				qui replace p_exp1 = r(p_z) in `i'
				
				**
				local beta1cell = "D`pos'"
				local round_beta1 = round(`r(ES)',0.001)
				local round_I21 = round(`r(Isq)',0.01)
				putexcel `beta1cell' = "`round_beta1' [`round_I21']"
				**
				local CIcell1 = "E`pos'"
				local quick_check1 = `r(ES)' - invnorm(0.975)*`r(seES)'
				di `quick_check1'
				
				local CIlower1 = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
				local CIupper1 = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
				di "`CIlower1'"
				di "`CIupper1'"
				local CIinterval1 = "(`CIlower1',`CIupper1')"
			
				putexcel `CIcell1' = "`CIinterval1'"
				
				
				
				metan beta_exp2 se_exp2 if exposure1 == "`ex'" & exposure2 == "`tex'" & substr(outcome,1,root_outcome) == "`out'" & type == "IV reg interaction" & sample!="" & sample!="Combined", nograph
				return list
				qui replace beta_exp2 = r(ES) in `i'
				qui replace se_exp2 = r(seES) in `i'
				qui replace p_exp2 = r(p_z) in `i'
				
				**
				local beta2cell = "F`pos'"
				local round_beta2 = round(`r(ES)',0.001)
				local round_I22 = round(`r(Isq)',0.01)
				putexcel `beta2cell' = "`round_beta2' [`round_I22']"
				
				**
				local CIcell2 = "G`pos'"
				local quick_check2 = `r(ES)' - invnorm(0.975)*`r(seES)'
				di `quick_check2'
				
				local CIlower2 = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
				local CIupper2 = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
				di "`CIlower2'"
				di "`CIupper2'"
				local CIinterval2 = "(`CIlower2',`CIupper2')"
			
				putexcel `CIcell2' = "`CIinterval2'"
				
				
				
				
				
				metan beta_int se_int if exposure1 == "`ex'" & exposure2 == "`tex'" & substr(outcome,1,root_outcome) == "`out'" & type == "IV reg interaction" & sample!="" & sample!="Combined", nograph
				return list
				qui replace beta_int = r(ES) in `i'
				qui replace se_int = r(seES) in `i'
				qui replace p_int = r(p_z) in `i'
				
				**
				local betaintcell = "H`pos'"
				local round_betaint = round(`r(ES)',0.001)
				local round_I2int = round(`r(Isq)',0.01)
				putexcel `betaintcell' = "`round_betaint' [`round_I2int']"
					
				**
				local CIcellint = "I`pos'"
				local quick_checkint = `r(ES)' - invnorm(0.975)*`r(seES)'
				di `quick_checkint'
				
				local CIlowerint = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
				local CIupperint = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
				di "`CIlowerint'"
				di "`CIupperint'"
				local CIintervalint = "(`CIlowerint',`CIupperint')"
			
				putexcel `CIcellint' = "`CIintervalint'"
				
				
				

				
						
			
				**
				local pvalcell = "J`pos'"
			
				local p_int = `r(p_z)'
				if (`p_int'<0.001){
					local p_int="<0.001"
				}
				else {
					local p_int=round(`p_int',0.001)
				}
				putexcel `pvalcell' = "`p_int'"
							
				
				
				sum n if exposure1 == "`ex'" & exposure2 == "`tex'" & substr(outcome,1,root_outcome) == "`out'" & type == "IV reg interaction" & sample!="" & sample!="Combined"
				qui replace n = r(sum) in `i' 
				local i = `i' + 1
				
				local Ncell = "K`pos'"
				putexcel `Ncell' = "`r(sum)'"
			
				local pos = `pos' +1
				
				
				
				
				
			}
			
		}			
	}
}


putexcel save
putexcel clear
clear


*********************************
*Meta-analyse mediation results *
*********************************

*NOW READ IN CSV FILE SPECIFIC FOR MEDIATION RESULTS IN EACH SPLIT AND PERFORM META ANALYSIS
import excel tableSmed.xlsx, firstrow clear

*set up excel file for writing results
putexcel set tableSmed_meta, replace sheet("tableSmed_meta")
putexcel A1 = "Outcome"
putexcel B1 = "Exposure"
putexcel C1 = "Mediator1"
putexcel D1 = "Mediator2"
putexcel E1 = "Mediator3"
putexcel F1 = "Indirect effect (I2)"
putexcel G1 = "95% CI"
putexcel H1 = "p-value"
putexcel I1 = "Proportion mediated (I2)"
putexcel J1 = "95% CI"
putexcel K1 = "p-value"
putexcel L1 = "N"
putexcel M1 = "lower ci IE"
putexcel N1 = "upper ci IE"
putexcel O1 = "lower ci PM"
putexcel P1 = "upper ci PM"

local pos = 2

destring Indirecteffect, replace
destring N, replace
destring Proportionmediated, replace

*****************
*mediator = BMI *
*****************


foreach med_out_val in "out_multimorbid_SR_2_" "out_multimorb_index_SR_" { 
	
	if "`med_out_val'" == "out_multimorbid_SR_2_" {
		local table_out="2+ conditions"
	}
	else if "`med_out_val'" == "out_multimorb_index_SR_" {
		local table_out="CMMI"
	}

	putexcel A`pos' = "`table_out'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "BMI"
	putexcel D`pos' = "NA"
	putexcel E`pos' = "NA"

	*indirect effect meta*
	metan Indirecteffect Indirectse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="BMI" & Mediator2=="NA" & Mediator3=="NA", nograph
	return list
	local beta_ID_cell = "F`pos'"
	local round_beta_indirect = round(`r(ES)',0.001)
	local round_I2_indirect = round(`r(Isq)',0.01)
	putexcel `beta_ID_cell' = "`round_beta_indirect' [`round_I2_indirect']"
	local CIcell_ID = "G`pos'"
	local quick_check_ID = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_ID'
	local CIlower_ID = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_ID = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_ID'"
	di "`CIupper_ID'"
	local CIinterval_ID = "(`CIlower_ID',`CIupper_ID')"
	putexcel `CIcell_ID' = "`CIinterval_ID'"
	local pvalcell_ID = "H`pos'"
	local p_ID = `r(p_z)'
	if (`p_ID'<0.001){
		local p_ID="<0.001"
	}
	else {
	    local p_ID=round(`p_ID',0.001)
	}
	putexcel `pvalcell_ID' = "`p_ID'"
							
	sum N if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="BMI" & Mediator2=="NA" & Mediator3=="NA" 
	local Ncell_ID = "L`pos'"
	putexcel `Ncell_ID' = "`r(sum)'"
	
	putexcel M`pos' = "`CIlower_ID'"
	putexcel N`pos' = "`CIupper_ID'"
	

	*prop mediated meta*
	metan Proportionmediated Proportionmediatedse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="BMI" & Mediator2=="NA" & Mediator3=="NA", nograph
	return list
	local beta_PM_cell = "I`pos'"
	local round_beta_PM = round(`r(ES)',0.001)
	local round_I2_PM = round(`r(Isq)',0.01)
	putexcel `beta_PM_cell' = "`round_beta_PM' [`round_I2_PM']"
	local CIcell_PM = "J`pos'"
	local quick_check_PM = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_PM'
	local CIlower_PM = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_PM = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_PM'"
	di "`CIupper_PM'"
	local CIinterval_PM = "(`CIlower_PM',`CIupper_PM')"
	putexcel `CIcell_PM' = "`CIinterval_PM'"
	local pvalcell_PM = "K`pos'"
	local p_PM = `r(p_z)'
	if (`p_PM'<0.001){
		local p_PM="<0.001"
	}
	else {
	    local p_PM=round(`p_PM',0.001)
	}
	putexcel `pvalcell_PM' = "`p_PM'"
	
	putexcel O`pos' = "`CIlower_PM'"
	putexcel P`pos' = "`CIupper_PM'"

	local pos = `pos' +1


}


********************
*mediator = alcohol*
********************

macro drop _table_out
macro drop _beta_ID_cell _round_beta_indirect _round_I2_indirect _CIcell_ID _quick_check_ID _CIlower_ID _CIupper_ID _CIinterval_ID _pvalcell_ID _p_ID _Ncell_ID _beta_PM_cell _round_beta_PM _round_I2_PM _CIcell_PM _quick_check_PM _CIlower_PM _CIupper_PM _CIinterval_PM _pvalcell_PM _p_PM

foreach med_out_val in "out_multimorbid_SRnoalc_2_" "out_multimorb_index_noalcSR_" { 
    	
	if "`med_out_val'" == "out_multimorbid_SRnoalc_2_" {
		local table_out="2+ conditions"
	}
	else if "`med_out_val'" == "out_multimorb_index_noalcSR_" {
		local table_out="CMMI"
	}
    
	putexcel A`pos' = "`table_out'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "Alcohol"
	putexcel D`pos' = "NA"
	putexcel E`pos' = "NA"

	*indirect effect meta*
	metan Indirecteffect Indirectse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="Alcohol" & Mediator2=="NA" & Mediator3=="NA", nograph
	return list
	local beta_ID_cell = "F`pos'"
	local round_beta_indirect = round(`r(ES)',0.001)
	local round_I2_indirect = round(`r(Isq)',0.01)
	putexcel `beta_ID_cell' = "`round_beta_indirect' [`round_I2_indirect']"
	local CIcell_ID = "G`pos'"
	local quick_check_ID = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_ID'
	local CIlower_ID = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_ID = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_ID'"
	di "`CIupper_ID'"
	local CIinterval_ID = "(`CIlower_ID',`CIupper_ID')"
	putexcel `CIcell_ID' = "`CIinterval_ID'"
	local pvalcell_ID = "H`pos'"
	local p_ID = `r(p_z)'
	if (`p_ID'<0.001){
		local p_ID="<0.001"
	}
	else {
	    local p_ID=round(`p_ID',0.001)
	}
	putexcel `pvalcell_ID' = "`p_ID'"
							
	sum N if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="Alcohol" & Mediator2=="NA" & Mediator3=="NA" 
	local Ncell_ID = "L`pos'"
	putexcel `Ncell_ID' = "`r(sum)'"
	
	putexcel M`pos' = "`CIlower_ID'"
	putexcel N`pos' = "`CIupper_ID'"

	*prop mediated meta*
	metan Proportionmediated Proportionmediatedse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="Alcohol" & Mediator2=="NA" & Mediator3=="NA", nograph
	return list
	local beta_PM_cell = "I`pos'"
	local round_beta_PM = round(`r(ES)',0.001)
	local round_I2_PM = round(`r(Isq)',0.01)
	putexcel `beta_PM_cell' = "`round_beta_PM' [`round_I2_PM']"
	local CIcell_PM = "J`pos'"
	local quick_check_PM = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_PM'
	local CIlower_PM = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_PM = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_PM'"
	di "`CIupper_PM'"
	local CIinterval_PM = "(`CIlower_PM',`CIupper_PM')"
	putexcel `CIcell_PM' = "`CIinterval_PM'"
	local pvalcell_PM = "K`pos'"
	local p_PM = `r(p_z)'
	if (`p_PM'<0.001){
		local p_PM="<0.001"
	}
	else {
	    local p_PM=round(`p_PM',0.001)
	}
	putexcel `pvalcell_PM' = "`p_PM'"
	
	putexcel O`pos' = "`CIlower_PM'"
	putexcel P`pos' = "`CIupper_PM'"
	

	local pos = `pos' +1

}


*****************************
*mediator = lifetime smoking*
*****************************

macro drop _table_out
macro drop _beta_ID_cell _round_beta_indirect _round_I2_indirect _CIcell_ID _quick_check_ID _CIlower_ID _CIupper_ID _CIinterval_ID _pvalcell_ID _p_ID _Ncell_ID _beta_PM_cell _round_beta_PM _round_I2_PM _CIcell_PM _quick_check_PM _CIlower_PM _CIupper_PM _CIinterval_PM _pvalcell_PM _p_PM
 
foreach med_out_val in "out_multimorbid_SR_2_" "out_multimorb_index_SR_" { 
	
	if "`med_out_val'" == "out_multimorbid_SR_2_" {
		local table_out="2+ conditions"
	}
	else if "`med_out_val'" == "out_multimorb_index_SR_" {
		local table_out="CMMI"
	}
 
	putexcel A`pos' = "`table_out'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "Lifetime smoking"
	putexcel D`pos' = "NA"
	putexcel E`pos' = "NA"

	*indirect effect meta*
	metan Indirecteffect Indirectse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="Lifetime smoking" & Mediator2=="NA" & Mediator3=="NA", nograph
	return list
	local beta_ID_cell = "F`pos'"
	local round_beta_indirect = round(`r(ES)',0.001)
	local round_I2_indirect = round(`r(Isq)',0.01)
	putexcel `beta_ID_cell' = "`round_beta_indirect' [`round_I2_indirect']"
	local CIcell_ID = "G`pos'"
	local quick_check_ID = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_ID'
	local CIlower_ID = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_ID = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_ID'"
	di "`CIupper_ID'"
	local CIinterval_ID = "(`CIlower_ID',`CIupper_ID')"
	putexcel `CIcell_ID' = "`CIinterval_ID'"
	local pvalcell_ID = "H`pos'"
	local p_ID = `r(p_z)'
	if (`p_ID'<0.001){
		local p_ID="<0.001"
	}
	else {
	    local p_ID=round(`p_ID',0.001)
	}
	putexcel `pvalcell_ID' = "`p_ID'"
							
	sum N if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="Lifetime smoking" & Mediator2=="NA" & Mediator3=="NA" 
	local Ncell_ID = "L`pos'"
	putexcel `Ncell_ID' = "`r(sum)'"
	
	putexcel M`pos' = "`CIlower_ID'"
	putexcel N`pos' = "`CIupper_ID'"

	*prop mediated meta*
	metan Proportionmediated Proportionmediatedse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="Lifetime smoking" & Mediator2=="NA" & Mediator3=="NA", nograph
	return list
	local beta_PM_cell = "I`pos'"
	local round_beta_PM = round(`r(ES)',0.001)
	local round_I2_PM = round(`r(Isq)',0.01)
	putexcel `beta_PM_cell' = "`round_beta_PM' [`round_I2_PM']"
	local CIcell_PM = "J`pos'"
	local quick_check_PM = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_PM'
	local CIlower_PM = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_PM = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_PM'"
	di "`CIupper_PM'"
	local CIinterval_PM = "(`CIlower_PM',`CIupper_PM')"
	putexcel `CIcell_PM' = "`CIinterval_PM'"
	local pvalcell_PM = "K`pos'"
	local p_PM = `r(p_z)'
	if (`p_PM'<0.001){
		local p_PM="<0.001"
	}
	else {
	    local p_PM=round(`p_PM',0.001)
	}
	putexcel `pvalcell_PM' = "`p_PM'"
	
	putexcel O`pos' = "`CIlower_PM'"
	putexcel P`pos' = "`CIupper_PM'"

	local pos = `pos' +1

}



***********************************************
*mediators = BMI and lifetime smoking combined*
***********************************************

macro drop _table_out
macro drop _beta_ID_cell _round_beta_indirect _round_I2_indirect _CIcell_ID _quick_check_ID _CIlower_ID _CIupper_ID _CIinterval_ID _pvalcell_ID _p_ID _Ncell_ID _beta_PM_cell _round_beta_PM _round_I2_PM _CIcell_PM _quick_check_PM _CIlower_PM _CIupper_PM _CIinterval_PM _pvalcell_PM _p_PM
 
foreach med_out_val in "out_multimorbid_SR_2_" "out_multimorb_index_SR_" { 
    	
	if "`med_out_val'" == "out_multimorbid_SR_2_" {
		local table_out="2+ conditions"
	}
	else if "`med_out_val'" == "out_multimorb_index_SR_" {
		local table_out="CMMI"
	}
 
 
	putexcel A`pos' = "`table_out'"
	putexcel B`pos' = "Years of education"
	putexcel C`pos' = "BMI" // note that code here depends on these mediators being in this order in the component analyses every time
	putexcel D`pos' = "NA"
	putexcel E`pos' = "Lifetime smoking"

	*indirect effect meta*
	metan Indirecteffect Indirectse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="BMI" & Mediator2=="NA" & Mediator3=="Lifetime smoking", nograph
	return list
	local beta_ID_cell = "F`pos'"
	local round_beta_indirect = round(`r(ES)',0.001)
	local round_I2_indirect = round(`r(Isq)',0.001)
	putexcel `beta_ID_cell' = "`round_beta_indirect' [`round_I2_indirect']"
	local CIcell_ID = "G`pos'"
	local quick_check_ID = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_ID'
	local CIlower_ID = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_ID = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_ID'"
	di "`CIupper_ID'"
	local CIinterval_ID = "(`CIlower_ID',`CIupper_ID')"
	putexcel `CIcell_ID' = "`CIinterval_ID'"
	local pvalcell_ID = "H`pos'"
	local p_ID = `r(p_z)'
	if (`p_ID'<0.001){
		local p_ID="<0.001"
	}
	else {
	    local p_ID=round(`p_ID',0.001)
	}
	putexcel `pvalcell_ID' = "`p_ID'"
							
	sum N if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="BMI" & Mediator2=="NA" & Mediator3=="Lifetime smoking" 
	local Ncell_ID = "L`pos'"
	putexcel `Ncell_ID' = "`r(sum)'"
	
	putexcel M`pos' = "`CIlower_ID'"
	putexcel N`pos' = "`CIupper_ID'"

	*prop mediated meta*
	metan Proportionmediated Proportionmediatedse if substr(Outcome,1,(length(Outcome)-1)) == "`med_out_val'" & Exposure=="Years of education" & Mediator1=="BMI" & Mediator2=="NA" & Mediator3=="Lifetime smoking", nograph
	return list
	local beta_PM_cell = "I`pos'"
	local round_beta_PM = round(`r(ES)',0.001)
	local round_I2_PM = round(`r(Isq)',0.001)
	putexcel `beta_PM_cell' = "`round_beta_PM' [`round_I2_PM']"
	local CIcell_PM = "J`pos'"
	local quick_check_PM = `r(ES)' - invnorm(0.975)*`r(seES)'
	di `quick_check_PM'
	local CIlower_PM = round(`r(ES)' - invnorm(0.975)*`r(seES)',0.001)
	local CIupper_PM = round(`r(ES)' + invnorm(0.975)*`r(seES)',0.001)
	di "`CIlower_PM'"
	di "`CIupper_PM'"
	local CIinterval_PM = "(`CIlower_PM',`CIupper_PM')"
	putexcel `CIcell_PM' = "`CIinterval_PM'"
	local pvalcell_PM = "K`pos'"
	local p_PM = `r(p_z)'
	if (`p_PM'<0.001){
		local p_PM="<0.001"
	}
	else {
	    local p_PM=round(`p_PM',0.001)
	}
	putexcel `pvalcell_PM' = "`p_PM'"
	
	putexcel O`pos' = "`CIlower_PM'"
	putexcel P`pos' = "`CIupper_PM'"

	local pos = `pos' +1

}




putexcel save
putexcel clear
clear





