*script name: cdmm_2.do
*script author: Teri North
*date created: 24.4.20
*date last edited: 16.2.22
*script purpose: converts variable n_20002_0_* (non-cancer illness self reported) to binary condition variables for analysis
*notes: This do file uses the file coding6.tsv from the biobank website (downloaded from http://biobank.ctsu.ox.ac.uk/crystal/coding.cgi?id=6)
*		as a key for the values in the n_20002_0_* variables


*change back to the data folder
cd 

tab n_21003_0_0 , missing

*loop over the relevant variables for self reported non-cancer illness at initial assessment centre

***************
*hypertension *
***************

*1065	hypertension
*1072	essential hypertension

gen hypertension_0_20002=0
forvalues i = 0/28 {
	replace hypertension_0_20002=1 if n_20002_0_`i'==1065
}
forvalues i = 0/28 {
	replace hypertension_0_20002=1 if n_20002_0_`i'==1072
}



*******************************
*peripheral vascular disease  *
*******************************

*1067	peripheral vascular disease
gen pvd_0_20002=0
forvalues i = 0/28 {
	replace pvd_0_20002=1 if n_20002_0_`i'==1067
}

*****************
*stroke and TIA *
*****************

*1081	stroke
*1082	transient ischaemic attack (tia)

gen stroke_TIA_0_20002=0
forvalues i = 0/28 {
	replace stroke_TIA_0_20002=1 if n_20002_0_`i'==1081
}
forvalues i = 0/28 {
	replace stroke_TIA_0_20002=1 if n_20002_0_`i'==1082
}

**********************************************
*leg claudication/intermittent claudication  * 
**********************************************

*1087	leg claudication/ intermittent claudication

gen claudication_0_20002=0
forvalues i = 0/28 {
	replace claudication_0_20002=1 if n_20002_0_`i'==1087
}


*********
*asthma *
*********

*1111	asthma

gen asthma_0_20002=0
forvalues i = 0/28 {
	replace asthma_0_20002=1 if n_20002_0_`i'==1111
}

*******
*copd *
*******

*1112	chronic obstructive airways disease/copd

gen copd_0_20002=0
forvalues i = 0/28 {
	replace copd_0_20002=1 if n_20002_0_`i'==1112
}


*******************************
*emphysema/chronic bronchitis * 
*******************************

*1113	emphysema/chronic bronchitis

gen emphysema_chronic_bron_0_20002=0
forvalues i = 0/28 {
	replace emphysema_chronic_bron_0_20002=1 if n_20002_0_`i'==1113
}


*****************
*bronchiectasis *
*****************

*1114	bronchiectasis

gen bronchiectasis_0_20002=0
forvalues i = 0/28 {
	replace bronchiectasis_0_20002=1 if n_20002_0_`i'==1114
}


******
*IBS *
******

*1154	irritable bowel syndrome

gen IBS_0_20002=0
forvalues i = 0/28 {
	replace IBS_0_20002=1 if n_20002_0_`i'==1154
}


*******************************
*Prostate problem (not cancer)*
*******************************

*1207	prostate problem (not cancer)

gen prostate_notcancer_0_20002=0
forvalues i = 0/28 {
	replace prostate_notcancer_0_20002=1 if n_20002_0_`i'==1207
}


**********
*diabetes* 
**********

*1220	diabetes

gen diabetes_0_20002=0
forvalues i = 0/28 {
	replace diabetes_0_20002=1 if n_20002_0_`i'==1220
}

*1222	type 1 diabetes

forvalues i = 0/28 {
	replace diabetes_0_20002=1 if n_20002_0_`i'==1222
}

*1223	type 2 diabetes
forvalues i = 0/28 {
	replace diabetes_0_20002=1 if n_20002_0_`i'==1223
}


*********************
*parkinsons disease *
*********************

*1262	parkinsons disease

gen parkinsons_0_20002=0
forvalues i = 0/28 {
	replace parkinsons_0_20002=1 if n_20002_0_`i'==1262
}


********************
*multiple sclerosis*
********************

*1261	multiple sclerosis

gen ms_0_20002=0
forvalues i = 0/28 {
	replace ms_0_20002=1 if n_20002_0_`i'==1261
}

******************************************
*dementia/alzheimers/cognitive impairment*
******************************************

*1263	dementia/alzheimers/cognitive impairment

gen dementia_alz_cogimp_0_20002=0
forvalues i = 0/28 {
	replace dementia_alz_cogimp_0_20002=1 if n_20002_0_`i'==1263
}


***********
*epilepsy *
***********

*1264	epilepsy

gen epilepsy_0_20002=0
forvalues i = 0/28 {
	replace epilepsy_0_20002=1 if n_20002_0_`i'==1264
}


***********
*migraine * 
***********

*1265	migraine

gen migraine_0_20002=0
forvalues i = 0/28 {
	replace migraine_0_20002=1 if n_20002_0_`i'==1265
}


************
*depression*
************

*1286	depression

gen depression_0_20002=0
forvalues i = 0/28 {
	replace depression_0_20002=1 if n_20002_0_`i'==1286
}


***********************
*anxiety/panic attacks*
***********************

*1287	anxiety/panic attacks

gen anxiety_panic_att_0_20002=0
forvalues i = 0/28 {
	replace anxiety_panic_att_0_20002=1 if n_20002_0_`i'==1287
}

*******************
*nervous breakdown*
*******************

*1288	nervous breakdown

gen nervous_breakdn_0_20002=0
forvalues i = 0/28 {
	replace nervous_breakdn_0_20002=1 if n_20002_0_`i'==1288
}


***************
*schizophrenia*
***************

*1289	schizophrenia

gen schizophrenia_0_20002=0
forvalues i = 0/28 {
	replace schizophrenia_0_20002=1 if n_20002_0_`i'==1289
}


****************************************
*deliberate self harm/ suicide attempt *
****************************************

*1290	deliberate self-harm/suicide attempt

gen selfharm_suicide_0_20002=0
forvalues i = 0/28 {
	replace selfharm_suicide_0_20002=1 if n_20002_0_`i'==1290
}


*****************************************
*mania/bipolar disorder/manic depression*
*****************************************

*1291	mania/bipolar disorder/manic depression

gen mania_bipol_manicdp_0_20002=0
forvalues i = 0/28 {
	replace mania_bipol_manicdp_0_20002=1 if n_20002_0_`i'==1291
}



*****************************
*spine arthritis/spondylitis*
*****************************

*1311	spine arthritis/spondylitis

gen spinearth_spondy_0_20002=0
forvalues i = 0/28 {
	replace spinearth_spondy_0_20002=1 if n_20002_0_`i'==1311
}

****************************
*connective tissue disorder*
****************************

*1373	connective tissue disorder

gen ctd_0_20002=0
forvalues i = 0/28 {
	replace ctd_0_20002=1 if n_20002_0_`i'==1373
}


**************
*peptic ulcer*
**************

*1400	peptic ulcer

gen peptic_ulcer_0_20002=0
forvalues i = 0/28 {
	replace peptic_ulcer_0_20002=1 if n_20002_0_`i'==1400
}


***********
*hepatitis*
***********

*1155	hepatitis

gen hepatitis_0_20002=0
forvalues i = 0/28 {
	replace hepatitis_0_20002=1 if n_20002_0_`i'==1155
}



***************************
*infective/viral hepatitis*
***************************

*1156	infective/viral hepatitis

gen inf_vir_hepatitis_0_20002=0
forvalues i = 0/28 {
	replace inf_vir_hepatitis_0_20002=1 if n_20002_0_`i'==1156
}



**************************
*non-infective hepatitis *
**************************

*1157	non-infective hepatitis

gen non_inf_hepatitis_0_20002=0
forvalues i = 0/28 {
	replace non_inf_hepatitis_0_20002=1 if n_20002_0_`i'==1157
}


*************************
*liver failure/cirrhosis*
*************************

*1158	liver failure/cirrhosis

gen liver_failure_cirrhosis_0_20002=0
forvalues i = 0/28 {
	replace liver_failure_cirrhosis_0_20002=1 if n_20002_0_`i'==1158
}



**********************
*renal/kidney failure* 
**********************

*1192	renal/kidney failure

gen renal_kidney_failure_0_20002=0
forvalues i = 0/28 {
	replace renal_kidney_failure_0_20002=1 if n_20002_0_`i'==1192
}



**********************************
*renal failure requiring dialysis*
**********************************

*1193	renal failure requiring dialysis

gen renal_failure_dial_0_20002=0
forvalues i = 0/28 {
	replace renal_failure_dial_0_20002=1 if n_20002_0_`i'==1193
}


**************************************
*renal failure not requiring dialysis*
**************************************

*1194	renal failure not requiring dialysis

gen renal_failure_nodial_0_20002=0
forvalues i = 0/28 {
	replace renal_failure_nodial_0_20002=1 if n_20002_0_`i'==1194
}


******************
*thyroid problem *
******************

*1224	thyroid problem (not cancer)

gen thyroid_notcancer_0_20002=0
forvalues i = 0/28 {
	replace thyroid_notcancer_0_20002=1 if n_20002_0_`i'==1224
}


*********************************
*hyperthyroidism/thyrotoxicosis *
*********************************

*1225	hyperthyroidism/thyrotoxicosis

gen hyperthyroid_thyrotoxico_0_20002=0
forvalues i = 0/28 {
	replace hyperthyroid_thyrotoxico_0_20002=1 if n_20002_0_`i'==1225
}


**************************
*hypothyroidism/myxoedema*
**************************

*1226	hypothyroidism/myxoedema

gen hypothyroid_myxoed_0_20002=0
forvalues i = 0/28 {
	replace hypothyroid_myxoed_0_20002=1 if n_20002_0_`i'==1226
}

*******************************
*thyroid radioablation therapy*
*******************************

*1228	thyroid radioablation therapy

gen thyroid_radioablation_0_20002=0
forvalues i = 0/28 {
	replace thyroid_radioablation_0_20002=1 if n_20002_0_`i'==1228
}


********************
*alcohol dependency*
********************

*1408	alcohol dependency

gen alcohol_depen_0_20002=0
forvalues i = 0/28 {
	replace alcohol_depen_0_20002=1 if n_20002_0_`i'==1408
}


*******************
*opioid dependency*
*******************

*1409	opioid dependency

gen opioid_depen_0_20002=0
forvalues i = 0/28 {
	replace opioid_depen_0_20002=1 if n_20002_0_`i'==1409
}


***********************************
*other substance abuse/dependency *
***********************************

*1410	other substance abuse/dependency

gen oth_subst_abuse_depen_0_20002=0
forvalues i = 0/28 {
	replace oth_subst_abuse_depen_0_20002=1 if n_20002_0_`i'==1410
}

************
*bronchitis*
************

*1412	bronchitis

gen bronchitis_0_20002=0
forvalues i = 0/28 {
	replace bronchitis_0_20002=1 if n_20002_0_`i'==1412
}

*******************
*eczema/dermatitis*
*******************

*1452	eczema/dermatitis

gen eczema_dermatitis_0_20002=0
forvalues i = 0/28 {
	replace eczema_dermatitis_0_20002=1 if n_20002_0_`i'==1452
}


************
*psoriasis *
************

*1453	psoriasis

gen psoriasis_0_20002=0
forvalues i = 0/28 {
	replace psoriasis_0_20002=1 if n_20002_0_`i'==1453
}


**************************************
*diverticular disease/diverticulitis *
**************************************

*1458	diverticular disease/diverticulitis

gen diverticular_0_20002=0
forvalues i = 0/28 {
	replace diverticular_0_20002=1 if n_20002_0_`i'==1458
}

******************************************
*colitis/not crohns or ulcertive colitis *
******************************************

*1459	colitis/not crohns or ulcerative colitis

gen colitis_ntcrohn_ntulcera_0_20002=0
forvalues i = 0/28 {
	replace colitis_ntcrohn_ntulcera_0_20002=1 if n_20002_0_`i'==1459
}



****************************
*inflammatory bowel disease*
****************************

*1461	inflammatory bowel disease

gen inflam_bowel_dis_0_20002=0
forvalues i = 0/28 {
	replace inflam_bowel_dis_0_20002=1 if n_20002_0_`i'==1461
}


*****************
*crohns disease *
*****************

*1462	crohns disease

gen crohns_0_20002=0
forvalues i = 0/28 {
	replace crohns_0_20002=1 if n_20002_0_`i'==1462
}


********************
*ulcerative colitis*
********************

*1463	ulcerative colitis

gen ulcerative_col_0_20002=0
forvalues i = 0/28 {
	replace ulcerative_col_0_20002=1 if n_20002_0_`i'==1463
}


***********************
*rheumatoid arthritis *
***********************

*1464	rheumatoid arthritis

gen rheumatoid_arth_0_20002=0
forvalues i = 0/28 {
	replace rheumatoid_arth_0_20002=1 if n_20002_0_`i'==1464
}

*******
*ptsd *
*******

*1469	post-traumatic stress disorder

gen ptsd_0_20002=0
forvalues i = 0/28 {
	replace ptsd_0_20002=1 if n_20002_0_`i'==1469
}


****************************************
*anorexia/bulimia/other eating disorder*
****************************************

*1470	anorexia/bulimia/other eating disorder

gen anorex_bulim_otheatdis_0_20002=0
forvalues i = 0/28 {
	replace anorex_bulim_otheatdis_0_20002=1 if n_20002_0_`i'==1470
}


*********************
*atrial fibrillation*
*********************

*1471	atrial fibrillation

gen a_fib_0_20002=0
forvalues i = 0/28 {
	replace a_fib_0_20002=1 if n_20002_0_`i'==1471
}


*****************
*atrial flutter *
*****************

*1483	atrial flutter

gen a_flutter_0_20002=0
forvalues i = 0/28 {
	replace a_flutter_0_20002=1 if n_20002_0_`i'==1483
}


************
*emphysema *
************

*1472	emphysema

gen emphysema_0_20002=0
forvalues i = 0/28 {
	replace emphysema_0_20002=1 if n_20002_0_`i'==1472
}


***********************
*post-natal depression*
***********************

*1531	post-natal depression

gen pnd_0_20002=0
forvalues i = 0/28 {
	replace pnd_0_20002=1 if n_20002_0_`i'==1531
}


*****************
*arthritis (nos)* 
*****************

*1538	arthritis (nos)

gen arthritis_nos_0_20002=0
forvalues i = 0/28 {
	replace arthritis_nos_0_20002=1 if n_20002_0_`i'==1538
}


*************
*hepatitis a*
*************

*1578	hepatitis a

gen hep_a_0_20002=0
forvalues i = 0/28 {
	replace hep_a_0_20002=1 if n_20002_0_`i'==1578
}


*************
*hepatitis b*
*************

*1579	hepatitis b

gen hep_b_0_20002=0
forvalues i = 0/28 {
	replace hep_b_0_20002=1 if n_20002_0_`i'==1579
}


*************
*hepatitis c*
*************

*1580	hepatitis c

gen hep_c_0_20002=0
forvalues i = 0/28 {
	replace hep_c_0_20002=1 if n_20002_0_`i'==1580
}



*************
*hepatitis d*
*************

*1581	hepatitis d

gen hep_d_0_20002=0
forvalues i = 0/28 {
	replace hep_d_0_20002=1 if n_20002_0_`i'==1581
}


*************
*hepatitis e*
*************

*1582	hepatitis e

gen hep_e_0_20002=0
forvalues i = 0/28 {
	replace hep_e_0_20002=1 if n_20002_0_`i'==1582
}


******************
*ischaemic stroke*
******************

*1583	ischaemic stroke

gen isch_stroke_0_20002=0
forvalues i = 0/28 {
	replace isch_stroke_0_20002=1 if n_20002_0_`i'==1583
}

***********
*tinnitus *
***********

*1597	tinnitus / tiniitis

gen tinnitus_0_20002=0
forvalues i = 0/28 {
	replace tinnitus_0_20002=1 if n_20002_0_`i'==1597
}


**************
*constipation*
**************

*1599	constipation

gen constipation_0_20002=0
forvalues i = 0/28 {
	replace constipation_0_20002=1 if n_20002_0_`i'==1599
}


**********************************************
*alcoholic liver disease/ alcoholic cirrhosis*
**********************************************

*1604	alcoholic liver disease / alcoholic cirrhosis

gen alc_liver_dis_alc_cirrho_0_20002=0
forvalues i = 0/28 {
	replace alc_liver_dis_alc_cirrho_0_20002=1 if n_20002_0_`i'==1604
}



*********
*stress *
*********

*1614	stress

gen stress_0_20002=0
forvalues i = 0/28 {
	replace stress_0_20002=1 if n_20002_0_`i'==1614
}


*****
*ocd*
*****

*1615	obsessive compulsive disorder (ocd)

gen ocd_0_20002=0
forvalues i = 0/28 {
	replace ocd_0_20002=1 if n_20002_0_`i'==1615
}


********
*angina*
********

*1074	angina

gen angina_0_20002=0
forvalues i = 0/28 {
	replace angina_0_20002=1 if n_20002_0_`i'==1074
}


*************************************
*heart attack/myocardial infarction *
*************************************

*1075	heart attack/myocardial infarction

gen heartattack_mi_0_20002=0
forvalues i = 0/28 {
	replace heartattack_mi_0_20002=1 if n_20002_0_`i'==1075
}


********************************
*heart failure/pulmonary odema * ??typo EDEMA??
********************************

*1076	heart failure/pulmonary odema

gen heartfail_pulodema_0_20002=0
forvalues i = 0/28 {
	replace heartfail_pulodema_0_20002=1 if n_20002_0_`i'==1076
}

****************************************
*parathyroid gland problem (not cancer)* 
****************************************

*1229	parathyroid gland problem (not cancer)

gen parathyroid_gland_prob_0_20002=0
forvalues i = 0/28 {
	replace parathyroid_gland_prob_0_20002=1 if n_20002_0_`i'==1229
}


**********************************
*parathyroid hyperplasia/adenoma * 
**********************************

*1230	parathyroid hyperplasia/adenoma

gen parathyroid_hyprpla_aden_0_20002=0
forvalues i = 0/28 {
	replace parathyroid_hyprpla_aden_0_20002=1 if n_20002_0_`i'==1230
}


********************
*eye/eyelid problem* 
********************

*1242	eye/eyelid problem

gen eye_eyelid_problem_0_20002=0
forvalues i = 0/28 {
	replace eye_eyelid_problem_0_20002=1 if n_20002_0_`i'==1242
}

*****************
*retinal problem*
*****************

*1275	retinal problem

gen retinal_problem_0_20002=0
forvalues i = 0/28 {
	replace retinal_problem_0_20002=1 if n_20002_0_`i'==1275
}


**********************
*diabetic eye disease*
**********************

*1276	diabetic eye disease

gen diab_eye_dis_0_20002=0
forvalues i = 0/28 {
	replace diab_eye_dis_0_20002=1 if n_20002_0_`i'==1276
}


**********
*cataract*
**********

*1278	cataract

gen cataract_0_20002=0
forvalues i = 0/28 {
	replace cataract_0_20002=1 if n_20002_0_`i'==1278
}


********************
*retinal detachment*
********************

*1281	retinal detachment

gen retinal_detach_0_20002=0
forvalues i = 0/28 {
	replace retinal_detach_0_20002=1 if n_20002_0_`i'==1281
}


*******************************
*retinal artery/vein occlusion*
*******************************

*1282	retinal artery/vein occlusion

gen retinal_artvein_occ_0_20002=0
forvalues i = 0/28 {
	replace retinal_artvein_occ_0_20002=1 if n_20002_0_`i'==1282
}


****************************
*hayfever/allergic rhinitis*
****************************

*1387	hayfever/allergic rhinitis

gen hayfev_allergic_rhin_0_20002=0
forvalues i = 0/28 {
	replace hayfev_allergic_rhin_0_20002=1 if n_20002_0_`i'==1387
}



*****************
*osteoarthritis *
*****************

*1465	osteoarthritis

gen osteoarth_0_20002=0
forvalues i = 0/28 {
	replace osteoarth_0_20002=1 if n_20002_0_`i'==1465
}


**********************************
*systemic lupus erythematosis/sle*
**********************************

*1381	systemic lupus erythematosis/sle            

gen sle_0_20002=0
forvalues i = 0/28 {
	replace sle_0_20002=1 if n_20002_0_`i'==1381
}



********************
*enlarged prostate *
********************

*1396	enlarged prostate

gen enlarged_prostate_0_20002=0
forvalues i = 0/28 {
	replace enlarged_prostate_0_20002=1 if n_20002_0_`i'==1396
}




*******************
*chronic sinusitis*
*******************

*1416	chronic sinusitis

gen chronic_sinusitis_0_20002=0
forvalues i = 0/28 {
	replace chronic_sinusitis_0_20002=1 if n_20002_0_`i'==1416
}


**************
*otosclerosis*
**************

*1420	otosclerosis //common cause of hearing loss in young adults

gen otosclerosis_0_20002=0
forvalues i = 0/28 {
	replace otosclerosis_0_20002=1 if n_20002_0_`i'==1420
}



*******************
*meniere's disease* 
*******************

*1421	meniere's disease

gen meniere_0_20002=0
forvalues i = 0/28 {
	replace meniere_0_20002=1 if n_20002_0_`i'==1421
}


*************
*thyroiditis*
*************

*1428	thyroiditis

gen thyroiditis_0_20002=0
forvalues i = 0/28 {
	replace thyroiditis_0_20002=1 if n_20002_0_`i'==1428
}


****************
*optic neuritis*
****************

*1435	optic neuritis

gen optic_neuritis_0_20002=0
forvalues i = 0/28 {
	replace optic_neuritis_0_20002=1 if n_20002_0_`i'==1435
}


***********************
*other joint disorder *
***********************

*1467	other joint disorder

gen other_joint_disorder_0_20002=0
forvalues i = 0/28 {
	replace other_joint_disorder_0_20002=1 if n_20002_0_`i'==1467
}


****************************
*diabetic neuropathy/ulcers*
****************************

*1468	diabetic neuropathy/ulcers

gen diab_neuropath_ulcers_0_20002=0
forvalues i = 0/28 {
	replace diab_neuropath_ulcers_0_20002=1 if n_20002_0_`i'==1468
}


************************
*sclerosing cholangitis*
************************

*1475	sclerosing cholangitis

gen sclero_cholang_0_20002=0
forvalues i = 0/28 {
	replace sclero_cholang_0_20002=1 if n_20002_0_`i'==1475
}


***********************
*psoriatic arthropathy*
***********************

*1477	psoriatic arthropathy

gen psoriatic_arthropathy_0_20002=0
forvalues i = 0/28 {
	replace psoriatic_arthropathy_0_20002=1 if n_20002_0_`i'==1477
}


****************************
*primary biliary cirrhosis *
****************************

*1506	primary biliary cirrhosis

gen primary_biliary_cirr_0_20002=0
forvalues i = 0/28 {
	replace primary_biliary_cirr_0_20002=1 if n_20002_0_`i'==1506
}


*****
*bph*
*****

*1516	bph / benign prostatic hypertrophy

gen bph_0_20002=0
forvalues i = 0/28 {
	replace bph_0_20002=1 if n_20002_0_`i'==1516
}



*************
*prostatitis*
*************

*1517	prostatitis

gen prostatitis_0_20002=0
forvalues i = 0/28 {
	replace prostatitis_0_20002=1 if n_20002_0_`i'==1517
}


*****************
*grave's disease*
*****************

*1522	grave's disease

gen graves_0_20002=0
forvalues i = 0/28 {
	replace graves_0_20002=1 if n_20002_0_`i'==1522
}


*********************
*kidney nephropathy *
*********************

*1519	kidney nephropathy

gen kidney_neph_0_20002=0
forvalues i = 0/28 {
	replace kidney_neph_0_20002=1 if n_20002_0_`i'==1519
}


*****************
*iga nephropathy*
*****************

*1520	iga nephropathy

gen iga_neph_0_20002=0
forvalues i = 0/28 {
	replace iga_neph_0_20002=1 if n_20002_0_`i'==1520
}


**********************
*retinitis pigmentosa*
**********************

*1527	retinitis pigmentosa

gen retinitis_pigmentosa_0_20002=0
forvalues i = 0/28 {
	replace retinitis_pigmentosa_0_20002=1 if n_20002_0_`i'==1527
}


***********************
*macular degeneration *
***********************

*1528	macular degeneration

gen macular_degeneration_0_20002=0
forvalues i = 0/28 {
	replace macular_degeneration_0_20002=1 if n_20002_0_`i'==1528
}



********
*iritis*
********

*1530	iritis

gen iritis_0_20002=0
forvalues i = 0/28 {
	replace iritis_0_20002=1 if n_20002_0_`i'==1530
}


**********************
*nasal/sinus disorder*
**********************

*1413	nasal/sinus disorder

gen nas_sin_disord_0_20002=0
forvalues i = 0/28 {
	replace nas_sin_disord_0_20002=1 if n_20002_0_`i'==1413
}


***************
*nasal polyps *
***************

*1417	nasal polyps

gen nas_polyps_0_20002=0
forvalues i = 0/28 {
	replace nas_polyps_0_20002=1 if n_20002_0_`i'==1417
}



**********************
*diabetic nephropathy*
**********************

*1607	diabetic nephropathy

gen diab_nephropathy_0_20002=0
forvalues i = 0/28 {
	replace diab_nephropathy_0_20002=1 if n_20002_0_`i'==1607
}


***********
*nephritis*
***********

*1608	nephritis

gen nephritis_0_20002=0
forvalues i = 0/28 {
	replace nephritis_0_20002=1 if n_20002_0_`i'==1608
}


********************
*glomerulnephritis *
********************

*1609	glomerulnephritis

gen glomerulnephritis_0_20002=0
forvalues i = 0/28 {
	replace glomerulnephritis_0_20002=1 if n_20002_0_`i'==1609
}


*****************
*thyroid goitre *
*****************

*1610	thyroid goitre

gen thyroid_goitre_0_20002=0
forvalues i = 0/28 {
	replace thyroid_goitre_0_20002=1 if n_20002_0_`i'==1610
}


**********************
*hyperparathyroidism *
**********************

*1611	hyperparathyroidism

gen hyperparathyroidism_0_20002=0
forvalues i = 0/28 {
	replace hyperparathyroidism_0_20002=1 if n_20002_0_`i'==1611
}


************************
*ankylosing spondylitis*
************************

*1313	ankylosing spondylitis

gen ankylosing_spond_0_20002=0
forvalues i = 0/28 {
	replace ankylosing_spond_0_20002=1 if n_20002_0_`i'==1313
}


**************************
*polymyalgia rheumatica  *
**************************

*1377	polymyalgia rheumatica

gen polymyalgia_rheumatica_0_20002=0
forvalues i = 0/28 {
	replace polymyalgia_rheumatica_0_20002=1 if n_20002_0_`i'==1377
}


***************
*fibromyalgia *
***************

*1542	fibromyalgia

gen fibromyalgia_0_20002=0
forvalues i = 0/28 {
	replace fibromyalgia_0_20002=1 if n_20002_0_`i'==1542
}


*******************
*myositis/myopathy*
*******************

*1322	myositis/myopathy

gen myositis_myopathy_0_20002=0
forvalues i = 0/28 {
	replace myositis_myopathy_0_20002=1 if n_20002_0_`i'==1322
}



**********************
*dermatopolymyositis *
**********************

*1383	dermatopolymyositis


gen dermatopolymyositis_0_20002=0
forvalues i = 0/28 {
	replace dermatopolymyositis_0_20002=1 if n_20002_0_`i'==1383
}




******************
*dermatomyositis *
******************

*1480	dermatomyositis

gen dermatomyositis_0_20002=0
forvalues i = 0/28 {
	replace dermatomyositis_0_20002=1 if n_20002_0_`i'==1480
}



**************
*polymyositis*
**************

*1481	polymyositis

gen polymyositis_0_20002=0
forvalues i = 0/28 {
	replace polymyositis_0_20002=1 if n_20002_0_`i'==1481
}



********************************
*scleroderma/systemic sclerosis*
********************************

*1384	scleroderma/systemic sclerosis

gen sclerod_sys_sclerosis_0_20002=0
forvalues i = 0/28 {
	replace sclerod_sys_sclerosis_0_20002=1 if n_20002_0_`i'==1384
}

*********************
*contact dermatitis *
*********************

*1669	contact dermatitis

gen contact_dermat_0_20002=0
forvalues i = 0/28 {
	replace contact_dermat_0_20002=1 if n_20002_0_`i'==1669
}


*****************
*duodenal ulcer *
*****************

*1457	duodenal ulcer

gen duodenal_ul_0_20002=0
forvalues i = 0/28 {
	replace duodenal_ul_0_20002=1 if n_20002_0_`i'==1457
}


************************
*gastric/stomach ulcers*
************************

*1142	gastric/stomach ulcers

gen gas_stom_ulcers_0_20002=0
forvalues i = 0/28 {
	replace gas_stom_ulcers_0_20002=1 if n_20002_0_`i'==1142
}


*************
*vasculitis *
*************

*1372	vasculitis

gen vasculitis_0_20002=0
forvalues i = 0/28 {
	replace vasculitis_0_20002=1 if n_20002_0_`i'==1372
}


*******************
*brain haemorrhage*
*******************

*1491	brain haemorrhage

gen brain_haem_0_20002=0
forvalues i = 0/28 {
	replace brain_haem_0_20002=1 if n_20002_0_`i'==1491
}


*****************
*cardiomyopathy *
*****************

*1079	cardiomyopathy

gen cardiomyop_0_20002=0
forvalues i = 0/28 {
	replace cardiomyop_0_20002=1 if n_20002_0_`i'==1079
}



******************************
*hypertrophic cardiomyopathy *
******************************

*1588	hypertrophic cardiomyopathy (hcm / hocm)

gen hypertroph_cardiomyop_0_20002=0
forvalues i = 0/28 {
	replace hypertroph_cardiomyop_0_20002=1 if n_20002_0_`i'==1588
}


******************
*aortic aneurysm *
******************

*1492	aortic aneurysm

gen aortic_aneurysm_0_20002=0
forvalues i = 0/28 {
	replace aortic_aneurysm_0_20002=1 if n_20002_0_`i'==1492
}



*************************
*aortic aneurysm rupture*
*************************

*1591	aortic aneurysm rupture

gen aort_an_rupt_0_20002=0
forvalues i = 0/28 {
	replace aort_an_rupt_0_20002=1 if n_20002_0_`i'==1591
}


***********************
*aortic valve disease *
***********************

*1586	aortic valve disease

gen aort_valve_dis_0_20002=0
forvalues i = 0/28 {
	replace aort_valve_dis_0_20002=1 if n_20002_0_`i'==1586
}


***********************************
*aortic regurgitation/incompetence*
***********************************

*1587	aortic regurgitation / incompetence

gen aortic_regurg_incom_0_20002=0
forvalues i = 0/28 {
	replace aortic_regurg_incom_0_20002=1 if n_20002_0_`i'==1587
}


