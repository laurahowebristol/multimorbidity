*script name: cdmm_16.do
*script author: Teri North
*date created: 11.5.21
*date last edited: 1.3.22
*script purpose: make plots 

clear
cd 

**************************************************************************
*plot showing observational and MR results for 2+ multimorbidity outcome *
**************************************************************************

*read in excel file of observational results
import excel table2.xlsx, firstrow clear

*keep only rows for 2+ outcome
keep if Outcome=="multimorbid_SR_2" |Outcome=="multimorbid_SRnoalc_2"

*save as a .dta file 
gen type = "MVR"
keep Outcome Exposure Beta3dp N lowerci upperci type
rename Beta3dp Beta 
destring Beta lowerci upperci, replace
save data_for_obs_mr_gph.dta, replace
clear

*read in excel file of MR results
import excel table3.xlsx, firstrow clear

*keep only rows for 2+ outcome
keep if Outcome=="Multimorbid Sr 2" |Outcome=="Multimorbid Srnoalc 2"
gen Beta=substr(Beta3dpI2statistic,1,strpos(Beta3dpI2statistic,"[")-2)
keep Outcome Exposure Beta N lowerci upperci
gen type = "MR"

*append the observational results 
destring Beta, replace
append using data_for_obs_mr_gph.dta



*now make a forestplot showing observational and MR result for each exposure
replace Exposure="5 BMI units (kg/m2)" if Exposure=="bmi"|Exposure=="Bmi"
replace Exposure="5 alcohol units/week" if Exposure=="Alcohol" |Exposure=="alcohol intake"
replace Exposure="1 SD of years of education" if Exposure=="Education" |Exposure=="eduyears scaled"
replace Exposure="1 SD of CSI" if Exposure=="lifetime smoking"|Exposure=="Lifetime Smoking"
rename type Method
gen ord_Exposure=.
replace ord_Exposure=1 if Exposure=="1 SD of years of education"
replace ord_Exposure=2 if Exposure=="5 BMI units (kg/m2)"
replace ord_Exposure=3 if Exposure=="1 SD of CSI"
replace ord_Exposure=4 if Exposure=="5 alcohol units/week"
gen Method2=1 if Method=="MR"
replace Method2=2 if Method=="MVR"
gen ord_Method=2 if Method=="MR"
replace ord_Method=1 if Method=="MVR"
sort ord_Exposure ord_Method

metan Beta lowerci upperci if Exposure=="1 SD of years of education", nooverall lcols(Exposure N Method) effect("RD") forestplot(plotid(Method2) ci1opts(lcolor(red)) ci2opts(lcolor(blue)) astext(65) xlabel(-0.12, -0.1, -0.08, -0.06, -0.04, -0.02) ysize(1) xsize(3.3) dp(3) fxsize(0.9) textsize(75) nobox leftjustify) graphregion(color(white) margin(zero)) 
graph save mr_vs_obs_forest_A, replace

metan Beta lowerci upperci if Exposure!="1 SD of years of education", nooverall lcols(Exposure N Method) effect("RD") forestplot(plotid(Method2) ci1opts(lcolor(red)) ci2opts(lcolor(blue)) astext(65) xlabel(0, 0.02, 0.04, 0.06, 0.08, 0.10) xsize(3.3) ysize(2) dp(3) fxsize(0.9) textsize(140) nobox leftjustify) graphregion(color(white) margin(zero))
graph save mr_vs_obs_forest_B, replace

graph combine mr_vs_obs_forest_A.gph mr_vs_obs_forest_B.gph, title("Multivariable regression versus MR", size(small)) rows(2) graphregion(color(white) margin(small)) ysize(3) xsize(3.3) iscale(0.63) imargin(zero)

*export as png
graph export mr_vs_obs_forest_comb.tif, replace width(3960)

clear



***********************************************************
*plot showing mediation results for 2+ conditions outcome *
***********************************************************

*read in excel file for mediation results (observational)
import excel med_obs.xlsx, firstrow clear
keep if Outcome=="out_multimorbid_SR_2" | Outcome=="out_multimorbid_SRnoalc_2"
replace Outcome="2+ conditions"
drop Indirectse Proportionmediatedse
gen type="MVR"
save data_for_mend_graph.dta, replace
*read in excel file for mediation results (MR)
import excel tableSmed_meta.xlsx, firstrow clear
rename CI CI_indirect
rename pvalue p_indirect
rename J CI_propmed
rename K p_propmed
drop CI_indirect p_indirect CI_propmed p_propmed
gen Proportionmediated=substr(ProportionmediatedI2,1,strpos(ProportionmediatedI2,"[")-2)
drop ProportionmediatedI2
gen Indirecteffect=substr(IndirecteffectI2,1,strpos(IndirecteffectI2,"[")-2)
drop IndirecteffectI2
rename lowerciIE Indirecteffect95lowerci
rename upperciIE Indirecteffect95upperci
rename lowerciPM Propnmediated95lowerci
rename upperciPM Propnmediated95upperci
keep if Outcome=="2+ conditions"

gen type="MR"
*append the observational mediation results
append using data_for_mend_graph.dta

 
*forest plot showing observational and MR results for mediation analyses
gen Mediators=""
replace Mediators=Mediator1 if (Mediator2=="NA" & Mediator3=="NA")
replace Mediators=Mediator1 + " & " + Mediator3 if Mediator3!="NA"
destring Indirecteffect95lowerci Indirecteffect95upperci Propnmediated95lowerci Propnmediated95upperci Proportionmediated Indirecteffect, replace
rename type Method
gen Method2=1 if Method=="MVR"
replace Method2=2 if Method=="MR"
drop if Mediator1=="Alcohol"
gen ord_Mediators=.
replace ord_Mediators=1 if Mediators=="BMI"
replace ord_Mediators=2 if Mediators=="Lifetime smoking"
*replace ord_Mediators=3 if Mediators=="Alcohol"
replace ord_Mediators=4 if Mediators=="BMI & Lifetime smoking"
*replace Mediators="All three" if ord_Mediators==4
gen ord_Method=2 if Method=="MR"
replace ord_Method=1 if Method=="MVR"
sort ord_Mediators ord_Method

metan Proportionmediated Propnmediated95lowerci Propnmediated95upperci, nooverall lcols(Mediators N Method) effect("PM") forestplot(plotid(Method2) ci1opts(lcolor(red)) ci2opts(lcolor(blue)) astext(30) ysize(1) xsize(3.3) xlabel(-0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9) title("Proportion of education-2+ conditions association mediated", size(medium)) textsize(150) nobox leftjustify) graphregion(color(white) margin(small)) 
graph export prop_mediated_forest.tif, replace width(3960)

metan Indirecteffect Indirecteffect95lowerci Indirecteffect95upperci, nooverall lcols(Mediators N Method) effect("IE") forestplot(plotid(Method2) ci1opts(lcolor(red)) ci2opts(lcolor(blue)) astext(30) ysize(1) xsize(3.3) xlabel(-0.08, -0.07, -0.06, -0.05, -0.04, -.03, -0.02, -0.01, 0, 0.01, 0.02) title("Indirect effect of education on 2+ chronic conditions", size(medium)) textsize(150) dp(3) nobox leftjustify) graphregion(color(white) margin(small)) 
graph export indirect_effect_forest.tif, replace width(3960)
clear
