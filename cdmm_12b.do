*script name: cdmm_12b.do
*script author: Teri North
*date created: 08.12.20
*date last edited: 27.02.22
*script purpose: Run split-sample GWAS and generate split sample PRS

cd 
*read in phenotypes 
use "$xxx\self_report_phenotypes.dta", clear

*merge with genetic ids
rename n_eid id_phe
merge 1:1 id_phe using "$xxx\linker2.dta"
keep if _merge==3
drop _merge

*remove individuals without a genetic id
drop if id_ieu==""

*remove recommended drops //  
foreach var in _recommended _highly_related _non_white_british {
	merge 1:1 id_ieu using "$xxx/exclusions`var'.dta"
	keep if _merge==1
	drop _merge
}

*Drop withdrawals - should already be excluded from previous do file
rename id_phe n_eid
merge 1:1 n_eid using xxxxx.dta
keep if _merge==1
drop _merge
rename n_eid id_phe 

*Mark relateds
merge 1:1 id_ieu using "$xxxx/exclusions_relateds.dta", keep(1 3)
rename _merge related
label drop _merge
replace related = 0 if related == 1
replace related = 1 if related == 3
label variable related "Related: 1=drop, 0=keep"

********************************************************************************
*Quick examination of multimorbidity outcomes in former alcohol drinkers
*for comment in paper

tab out_multimorbid_SRnoalc_2 if n_3731_0_0==1 & related==0
tab out_multimorbid_SRnoalc_3 if n_3731_0_0==1 & related==0
tab out_multimorbid_SRnoalc_4 if n_3731_0_0==1 & related==0
sum out_multimorb_index_noalcSR if n_3731_0_0==1 & related==0

********************************************************************************


*keep relevant variables
keep id_phe id_ieu age sex centre phe* pc* related out*
order id* age sex centre related phe* pc* out*

*save 
save "$xxxx\self_report_phenotypes_v2.dta", replace
clear

/*No need to re-run 

*only keep variables relevant to the split sample GWAS
use "$xxxxxx\self_report_phenotypes_v2.dta", clear
keep id_ieu phe* pc* sex age related
order id_ieu sex age related phe* pc* 

*set seed 681206827
*gen sample = 1 if runiform() < 0.5
*replace sample = 2 if sample == .
*tab sample

merge 1:1 id_ieu using "$xxxxxx\sample IDs.dta"
keep if _merge==3
drop _merge

rename id_ieu FID
gen IID = FID, a(FID)

*Deal with rounding errors 
*This is to do with making values strings - they need to be 1 or 2, not 0.999999
*Note: this also makes continuous measurements set to 2dp. That's probably fine.
foreach var of varlist phe* {
	gen x = `var'*100
	replace x = x+0.1
	replace x = int(x)
	gen double y = x/100, a(`var')

	drop `var' x
	rename y `var'
}

*All Binary variables need to be 1 (control) 2 (case)
*NOTE: this is only in case you have binary variables you want to GWAS
/*
foreach var of varlist {
	replace `var' = `var'+1
}
*/

*Missingness needs to be set to NA
foreach var of varlist phe* {
	tostring `var', gen(`var'2)
	order `var'2, a(`var')
	replace `var'2 = "NA" if `var' == .
	drop `var'
	rename `var'2 `var'
}



*Phenotypes_1 (REMEMBER PHENOTYPES1 CORRESPONDS TO DROP IF SAMPLE==1)
preserve
drop if sample == 1
keep FID IID phe*
export delim "$xxxxxx\phenotypes1.txt", replace delim(" ")
restore

*Phenotypes_2
preserve
drop if sample == 2
keep FID IID phe*
export delim "$xxxxxxxx\phenotypes2.txt", replace delim(" ")
restore

*covars_1
preserve
drop if sample == 1
keep FID IID sex age pc* 
export delim "$xxxxxx\covars_1.txt", replace delim(" ")
restore

*covars_2
preserve
drop if sample == 2
keep FID IID sex age pc*
export delim "$xxxxxx\covars_2.txt", replace delim(" ")
restore

*Keep track of which sample people were in. REMEMBER 1 MEANS DROP IF SAMPLE==1 AND VICE VERSA
keep FID sample
rename FID id_ieu
save "$xxxxxxx\sample IDs.dta", replace
clear

/*

RUN GWAS AND DERIVE PRSs

*/

*/

import delim "$xxxxx\grs_ss.csv", clear
rename id id_ieu
merge 1:1 id_ieu using "$xxxxx\self_report_phenotypes_v2.dta"
keep if _merge==3 // so withdrawals and recommended drops removed 
drop _merge
merge 1:1 id_ieu using "$xxxx\sample IDs.dta"
keep if _merge==3
drop _merge

rename bmi_split_sample_split1 grs_bmi1
rename bmi_split_sample_split2 grs_bmi2
rename edu_split_sample_split1 grs_education1
rename edu_split_sample_split2 grs_education2
rename csi_split_sample_split1 grs_lifetime_smoking1
rename csi_split_sample_split2 grs_lifetime_smoking2
rename alcohol_split_sample_split1 grs_alcohol1
rename alcohol_split_sample_split2 grs_alcohol2


*Restrict GRS to the correct sample & standardise
*grs_bmi1 is prs in everyone from sample=2 gwas --> hence we should restrict it to keep if sample==1 (so the prs was not discovered in this sample )

foreach var of varlist grs* { 
	
	*Restrict GRS to those not in the same sample
	local sample = substr("`var'",-1,1)
	qui replace `var' = . if sample != `sample'
	
	*Standardise
	qui sum `var'
	qui replace `var' = (`var'-r(mean))/r(sd)
	
}

*Generate Phe for samples 1 and 2 seperately (saves messing with "if sample == 1/2")
foreach var of varlist phe* {
	gen `var'_2 = `var', a(`var')
	rename `var' `var'_1
	replace `var'_1 = . if sample == 1
	replace `var'_2 = . if sample == 2
}


*Generate out for samples 1 and 2 separately
foreach var of varlist out* {
	gen `var'_2 = `var', a(`var')
	rename `var' `var'_1
	replace `var'_1 = . if sample == 1
	replace `var'_2 = . if sample == 2
}


*covariates: age, sex, pcs, and centre
gen age_2 = age, a(age)
rename age age_1
replace age_1 = . if sample == 1
replace age_2 = . if sample == 2
*
gen sex_2 = sex, a(sex)
rename sex sex_1
replace sex_1 = . if sample == 1
replace sex_2 = . if sample == 2
*
gen centre_2 = centre, a(centre)
rename centre centre_1
replace centre_1 = . if sample == 1
replace centre_2 = . if sample == 2
*
foreach var of varlist pc* {
	gen `var'_2 = `var', a(`var')
	rename `var' `var'_1
	replace `var'_1 = . if sample == 1
	replace `var'_2 = . if sample == 2
}



save "$xxxxx\self_report_phenotypes_v3.dta", replace
clear

