*script name: cdmm_1.do
*script author: Teri North
*date created: 1.4.20
*date last edited:27.02.22
*script purpose: reads in the relevant data and creates datasets for the causal determinants of multimorbidity paper analysis
*notes: some scripts use Sean Harrison's code with subsequent edits by Teri North


*Set verison of Stata
version 16


*Install packages

*Running R from Stata
ssc install rsource, replace

*For IV regression
ssc install ivreg2
ssc install ranktest

*MR analysis (MR robust)
*https://remlapmot.github.io/mrrobust/#installing-and-updating-mrrobust
net install mrrobust, from("https://raw.github.com/remlapmot/mrrobust/master/") replace
mrdeps // runs dependencies

*set some global macros with folder locations





*change directory to the project data folder
cd ""

*Sean's code for reading in variables of interest from split phenotype files and appending
*Do ONCE
*Load in phenotypes

forvalues i = 1/51 {
	clear all
	set maxvar 15000
	
	*Excel code from "Phenotypes.xlsx" goes here
	
	use n_eid  n_31_*  n_34_*  n_52_*  ts_53_*  n_54_*  n_84_*  n_93_*  n_134_*  n_189_*  n_845_*  n_1239_*  n_1249_*  n_1558_*  n_1568_*  n_1578_*  n_1588_*  n_1598_*  n_1608_*  n_1920_*  n_1930_*  n_1940_*  n_1950_*  n_1960_*  n_1970_*  n_1980_*  n_1990_*  n_2000_*  n_2010_*  n_2020_*  n_2030_*  n_2040_*  n_2050_*  n_2060_*  n_2070_*  n_2080_*  n_2090_*  n_2100_*  n_2110_*  n_2207_*  n_2217_*  n_2227_*  n_2247_*  n_2257_*  n_2443_*  n_2453_*  n_2644_*  n_2867_*  n_2877_*  n_2887_*  n_2897_*  n_2907_*  n_2926_*  n_2936_*  n_2956_*  n_2966_*  n_2976_*  n_3079_*  n_3393_*  n_3404_*  n_3414_*  n_3436_*  n_3446_*  n_3456_*  n_3466_*  n_3476_*  n_3486_*  n_3496_*  n_3506_*  n_3571_*  n_3606_*  n_3616_*  n_3627_*  n_3731_*  n_3741_*  n_3751_*  n_3761_*  n_3773_*  n_3786_*  n_3799_*  n_3859_*  n_3894_*  n_3992_*  n_4041_*  n_4056_*  n_4067_*  n_4079_*  n_4080_*  n_4268_*  n_4269_*  n_4270_*  n_4272_*  n_4275_*  n_4276_*  n_4277_*  n_4279_*  n_4407_*  n_4418_*  n_4429_*  n_4440_*  n_4451_*  n_4462_*  n_4526_*  n_4537_*  n_4548_*  n_4559_*  n_4570_*  n_4581_*  n_4598_*  n_4609_*  n_4620_*  n_4631_*  n_4642_*  n_4653_*  n_4689_*  n_4700_*  n_4717_*  n_4728_*  n_4792_*  n_4803_*  n_4814_*  n_4849_*  n_5181_*  n_5182_*  n_5183_*  n_5185_*  n_5186_*  n_5187_*  n_5188_*  n_5324_*  n_5325_*  n_5326_*  n_5327_*  n_5328_*  n_5364_*  n_5375_*  n_5386_*  n_5408_*  n_5419_*  n_5430_*  n_5441_*  n_5452_*  n_5463_*  n_5474_*  n_5485_*  n_5496_*  n_5507_*  n_5518_*  n_5529_*  n_5540_*  n_5610_*  n_5663_*  n_5674_*  n_5832_*  n_5843_*  n_5855_*  n_5877_*  n_5890_*  n_5901_*  n_5912_*  n_5923_*  n_5934_*  n_5945_*  n_5959_*  n_6014_*  n_6015_*  n_6016_*  n_6119_*  n_6138_*  n_6145_*  n_6147_*  n_6148_*  n_6149_*  n_6150_*  n_6152_*  n_6153_*  n_6154_*  n_6156_*  n_6157_*  n_6158_*  n_6159_*  n_6177_*  n_6183_*  n_6194_*  n_6205_*  n_10004_*  n_10005_*  n_10006_*  n_10115_*  n_10721_*  n_10722_*  n_10793_*  n_10818_*  n_10827_*  n_10853_*  n_10895_*  n_20001_*  n_20002_*  n_20003_*  n_20006_*  n_20007_*  n_20008_*  n_20009_*  n_20012_*  n_20013_*  n_20116_*  n_20117_*  n_20122_*  n_20123_*  n_20124_*  n_20125_*  n_20126_*  n_20127_*  n_20160_*  n_20494_*  n_20496_*  n_20528_*  n_21000_*  n_21001_*  n_21002_*  n_21003_*  n_21022_*  n_22000_*  n_22001_*  s_22002_*  n_22003_*  n_22004_*  n_22005_*  n_22006_*  s_22007_*  s_22008_*  n_22009_*  n_22010_*  n_22011_*  n_22012_*  n_22013_*  n_22018_*  n_22051_*  n_22052_*  n_22126_*  n_22127_*  n_22128_*  n_22129_*  n_22130_*  n_22131_*  n_22132_*  n_22133_*  n_22134_*  n_22135_*  n_22136_*  n_22137_*  n_22138_*  n_22139_*  n_22140_*  n_22141_*  n_22146_*  n_22147_*  n_22148_*  n_22149_*  n_22150_*  n_22151_*  n_22152_*  n_22153_*  n_22154_*  n_22155_*  n_22156_*  n_22157_*  n_22158_*  n_22159_*  n_22160_*  n_22161_*  n_22166_*  n_22167_*  n_22168_*  n_22169_*  n_22170_*  n_22171_*  n_22172_*  n_22173_*  n_22174_*  n_22175_*  n_22176_*  n_22177_*  n_22178_*  n_22179_*  n_22180_*  n_22181_*  n_22501_*  n_22502_*  n_22503_*  n_22504_*  n_22505_*  n_22506_*  n_22507_*  n_22508_*  n_23016_*  n_23017_*  n_23018_*  n_23019_*  n_23060_*  n_23061_*  n_23098_*  n_23104_*  n_23201_*  n_30500_*  ts_30502_*  s_30503_*  s_30505_*  n_30510_*  ts_30512_*  s_30513_*  s_30515_*  n_30600_*  ts_30601_*  n_30602_*  n_30603_*  n_30604_*  n_30605_*  n_30606_*  n_30700_*  ts_30701_*  n_30702_*  n_30703_*  n_30704_*  n_30705_*  n_30706_*  ts_40000_*  s_40001_*  s_40002_*  ts_40005_*  s_40006_*  n_40007_*  n_40008_*  n_40009_*  n_40011_*  n_40012_*  s_40013_*  n_40018_*  n_40019_*  using ""
	save "z`i'.dta", replace

}	
	

use "z1.dta", clear
forvalues i = 2/51 {
	append using "z`i'.dta"
}

compress

save "Phenotype_data.dta", replace

clear 
use "Phenotype_data.dta"

*remove withdrawls
merge 1:1 n_eid using xxx.dta
keep if _merge==1
drop _merge
save "Phenotype_data.dta", replace // overwrite 


*save date of assessment centre attendance at baseline
keep n_eid ts_53_0_0
save "attendance_baseline.dta", replace


*save variables for lifetime smoking measure derivation
clear
use "Phenotype_data.dta"
keep n_20116_0_0 n_3436_0_0 n_2867_0_0 n_2897_0_0 n_3456_0_0 n_2887_0_0 n_31_0_0 n_189_0_0 n_21000_0_0 n_6138_0_0 n_21003_0_0 n_eid
export delimited "lifetime_smoking_vars.csv", replace nolabel


clear 
use "Phenotype_data.dta"

*run do file to drop variables that we don't need
cd 
do cdmm_3.do
cd 

*run do file to convert variable n_20002 (non-cancer illness self reported) to condition variables
cd 
do cdmm_2.do
cd 

*run do file to create a variable - cancer in last 5 years excluding non-melanoma skin cancer (1=case)
cd 
do cdmm_5.do
cd 

*run do file to create self-reported morbidity variables
cd 
do cdmm_6.do
cd 

*run do file to define exposures and covariates for analysis
cd 
do cdmm_12.do
cd 

*run split sample gwas, clean and save genetic variables
*cd 
*do cdmm_12b.do
*cd 

*run do file to create data flags and make data characterization table
*cd 
*do cdmm_13.do
*cd 

*run do file to create interaction variables
*cd 
*do cdmm_14.do
*cd 

*run do file to run observational and genetic split sample regression and IV analyses, followed by meta-analysis across splits
*cd 
*do cdmm_15.do
*cd 

*run do file to make plots
*cd 
*do cdmm_16.do
*cd 

*run do file to run genetic sensitivities
*cd 
*do cdmm_17.do
*cd 

*run do file to extract summary statistics 
*cd 
*do cdmm_18.do
*cd 








