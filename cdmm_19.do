*script name: cdmm_19.do
*script author: Teri North
*date created: 23.5.23
*date last edited: 02.7.23
*script purpose: Re-run observational regressions with logistic regression, and use gformula for mediation analyses
*notes: Stata version 17 used for these analyes 

which gformula

* change to correct folder
cd 

* load dataset
use "XXXXXXXXX\self_report_phenotypes_v5.dta", clear

* double check withdrawals are excluded
gen n_eid=id_phe
merge 1:1 n_eid using XXXXXX.dta
keep if _merge==1
drop _merge
drop n_eid

* run observational logistic regressions - no interactions

*Observational analysis on whole sample
*logistic regression

local pclist = ""
foreach num of numlist 1/40 {
	local pc`num' = "pc`num'"
	local pclist = "`pclist' `pc`num''"
}
logistic out_multimorbid_SR_2 phe_bmi age sex `pclist' i.centre, vce(robust)
logistic out_multimorbid_SR_2 phe_eduyears_scaled age sex `pclist' i.centre, vce(robust)
logistic out_multimorbid_SR_2 phe_lifetime_smoking age sex `pclist' i.centre, vce(robust)
logistic out_multimorbid_SRnoalc_2 phe_alcohol_intake age sex `pclist' i.centre, vce(robust)
			

* run observational logistic regressions - with interactions

local pclist = ""
foreach num of numlist 1/40 {
	local pc`num' = "pc`num'"
	local pclist = "`pclist' `pc`num''" 
}

		
logistic out_multimorbid_SR_2 phe_bmi_smok phe_bmi phe_lifetime_smoking age sex `pclist' i.centre, vce(robust)

logistic out_multimorbid_SR_2 phe_smok_edu phe_lifetime_smoking phe_eduyears_scaled age sex `pclist' i.centre, vce(robust)

logistic out_multimorbid_SR_2 phe_bmi_edu phe_bmi phe_eduyears_scaled age sex `pclist' i.centre, vce(robust)

logistic out_multimorbid_SRnoalc_2 phe_alc_edu phe_alcohol_intake phe_eduyears_scaled age sex `pclist' i.centre, vce(robust)

logistic out_multimorbid_SRnoalc_2 phe_smok_alc phe_lifetime_smoking phe_alcohol_intake age sex `pclist' i.centre, vce(robust)

logistic out_multimorbid_SRnoalc_2 phe_bmi_alc phe_bmi phe_alcohol_intake age sex `pclist' i.centre, vce(robust)
						
			
* run mediation analyses using gformula
* Report the NIE and the PM from output table

*outcome=out_multimorbid_SR_2 or out_multimorbid_SRnoalc_2
*exposure=phe_eduyears_scaled
*confounders= age sex `pclist' i.centre

local pclist = ""
foreach num of numlist 1/40 {
	local pc`num' = "pc`num'"
	local pclist = "`pclist' `pc`num''" 
}

*mediator=phe_lifetime_smoking

gformula out_multimorbid_SR_2 phe_eduyears_scaled phe_lifetime_smoking age sex `pclist' centre, ///
mediation outcome(out_multimorbid_SR_2) exposure(phe_eduyears_scaled) mediator(phe_lifetime_smoking) base_confs(age sex `pclist' centre)  ///
commands(out_multimorbid_SR_2:logit, phe_lifetime_smoking:regress) ///
equations(out_multimorbid_SR_2: phe_eduyears_scaled phe_lifetime_smoking age sex `pclist' i.centre, phe_lifetime_smoking: phe_eduyears_scaled age sex `pclist' i.centre) ///
control(phe_lifetime_smoking:0) linexp  ///
samples(1000) seed(40582) moreMC sim(100000) minsim logOR

 
*meditor=phe_bmi
gformula out_multimorbid_SR_2 phe_eduyears_scaled phe_bmi age sex `pclist' centre, ///
mediation outcome(out_multimorbid_SR_2) exposure(phe_eduyears_scaled) mediator(phe_bmi) base_confs(age sex `pclist' centre)  ///
commands(out_multimorbid_SR_2:logit, phe_bmi:regress) ///
equations(out_multimorbid_SR_2: phe_eduyears_scaled phe_bmi age sex `pclist' i.centre, phe_bmi: phe_eduyears_scaled age sex `pclist' i.centre) ///
control(phe_bmi:0) linexp  ///
samples(1000) seed(40582) moreMC sim(100000) minsim logOR

*mediator=phe_alcohol_intake
gformula out_multimorbid_SRnoalc_2 phe_eduyears_scaled phe_alcohol_intake age sex `pclist' centre, ///
mediation outcome(out_multimorbid_SRnoalc_2) exposure(phe_eduyears_scaled) mediator(phe_alcohol_intake) base_confs(age sex `pclist' centre)  ///
commands(out_multimorbid_SRnoalc_2:logit, phe_alcohol_intake:regress) ///
equations(out_multimorbid_SRnoalc_2: phe_eduyears_scaled phe_alcohol_intake age sex `pclist' i.centre, phe_alcohol_intake: phe_eduyears_scaled age sex `pclist' i.centre) ///
control(phe_alcohol_intake:0) linexp  ///
samples(1000) seed(40582) moreMC sim(100000) minsim logOR

*mediator=bmi+smoking combined

gformula out_multimorbid_SR_2 phe_eduyears_scaled phe_bmi phe_lifetime_smoking age sex `pclist' centre, ///
mediation outcome(out_multimorbid_SR_2) exposure(phe_eduyears_scaled) mediator(phe_bmi phe_lifetime_smoking) base_confs(age sex `pclist' centre) ///
commands(out_multimorbid_SR_2:logit, phe_bmi:regress, phe_lifetime_smoking:regress) ///
equations(out_multimorbid_SR_2: phe_eduyears_scaled phe_bmi phe_lifetime_smoking age sex `pclist' i.centre, phe_bmi: phe_eduyears_scaled age sex `pclist' i.centre, phe_lifetime_smoking: phe_eduyears_scaled age sex `pclist' i.centre) ///
control(phe_bmi:0, phe_lifetime_smoking:0) linexp  ///
samples(1000) seed(40582) moreMC sim(100000) minsim logOR


*sensitivity check - re-run with a different seed
gformula out_multimorbid_SR_2 phe_eduyears_scaled phe_bmi phe_lifetime_smoking age sex `pclist' centre, ///
mediation outcome(out_multimorbid_SR_2) exposure(phe_eduyears_scaled) mediator(phe_bmi phe_lifetime_smoking) base_confs(age sex `pclist' centre) ///
commands(out_multimorbid_SR_2:logit, phe_bmi:regress, phe_lifetime_smoking:regress) ///
equations(out_multimorbid_SR_2: phe_eduyears_scaled phe_bmi phe_lifetime_smoking age sex `pclist' i.centre, phe_bmi: phe_eduyears_scaled age sex `pclist' i.centre, phe_lifetime_smoking: phe_eduyears_scaled age sex `pclist' i.centre) ///
control(phe_bmi:0, phe_lifetime_smoking:0) linexp  ///
samples(1000) seed(596264) moreMC sim(100000) minsim logOR

*sensitivity check - re-run without moreMC

local pclist = ""
foreach num of numlist 1/40 {
	local pc`num' = "pc`num'"
	local pclist = "`pclist' `pc`num''" 
}

gformula out_multimorbid_SR_2 phe_eduyears_scaled phe_bmi phe_lifetime_smoking age sex `pclist' centre, ///
mediation outcome(out_multimorbid_SR_2) exposure(phe_eduyears_scaled) mediator(phe_bmi phe_lifetime_smoking) base_confs(age sex `pclist' centre) ///
commands(out_multimorbid_SR_2:logit, phe_bmi:regress, phe_lifetime_smoking:regress) ///
equations(out_multimorbid_SR_2: phe_eduyears_scaled phe_bmi phe_lifetime_smoking age sex `pclist' i.centre, phe_bmi: phe_eduyears_scaled age sex `pclist' i.centre, phe_lifetime_smoking: phe_eduyears_scaled age sex `pclist' i.centre) ///
control(phe_bmi:0, phe_lifetime_smoking:0) linexp  ///
samples(1000) seed(40582) minsim logOR

