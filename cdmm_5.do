*script name: cdmm_5.do
*script author: Teri North
*date created: 1.5.20
*date last edited: 15.6.20
*script purpose: converts variable n_20001_0_* (self reported cancer at nurse interview) to a 'cancer in last 5 yrs'/no/missing variable
*notes: -This do file uses the file coding3.tsv from the biobank website (downloaded from http://biobank.ctsu.ox.ac.uk/crystal/coding.cgi?id=3)
*		as a key for the values in the n_20001_0_* variables



*change back to the data folder
cd 


*assume everyone hasn't had cancer to begin with
gen cancer_20001_0=0 

*if someone has an unclassifiable category in n_20001_0_*, change them to missing cancer status unless they have already been coded as non-missing
*(see below)
*note that as the code below comes AFTER this code, any instance of unclassifiable will change cancer_20001_0 to missing here
forvalues i = 0/5 {
	replace cancer_20001_0=. if n_20001_0_`i'==99999 & cancer_20001_0==0
}


*if someone has a non-missing value for the variables n_20001_0_*, which also isn't =99999 (unclassifiable), then record them as ever had cancer
forvalues i = 0/5 {
	replace cancer_20001_0=1 if n_20001_0_`i'!=99999 & n_20001_0_`i'!=.
}


*The above can be used to create an ever/never/missing cancer variable (missing when all instances 0/5 are unclassifiable). What we actually need for the Cam MM score is a new cancer diagnosis in the last 5 years, 
*excluding non-melanoma skin cancer. This requires matching of dates first diagnosed to cancers, then sorting to those in the last 5 years, and
*excluding non-melanoma skin cancer.

*Firstly make an indicator variable signalling whether the n_20001_0_`i' cancer first occured in the last 5 years
*date of attending assessment centre recorded in variable ts_53_0_0 (in %td format)
*interpolated year of first occurence of each cancer recorded in n_20001_0_`i' is recorded in variables n_20006_0_* (type double, format %f)
*interpolated age of participant when cancer in n_20001_0_`i' first diagnosed is recorded in variables n_20007_0_* (type double, format %f)

*now calculate binary variable to indicate whether cancer in n_20001_0_`i' first occurred within last 5 years of assessment centre 

*translate interpolated age at first cancer diagnosis to interpolated date of first cancer diagnosis by adding the age*365.25 to the 
*date of birth, then formatting as a date (note date of birth accurate to nearest month, approximate day as the 15th for everyone)

forvalues i = 0/5 {
	gen days_n_20007_0_`i'=365.25*n_20007_0_`i' //approximate days old at cancer diagnosis
	replace days_n_20007_0_`i'=-99999 if n_20007_0_`i'==-1
	gen date_n_20007_0_`i'=days_n_20007_0_`i'+ mdy(n_52_0_0, 15, n_34_0_0) //approximate date (in days since 1 jan 1960) of cancer diagnosis
	replace date_n_20007_0_`i'=-99999 if days_n_20007_0_`i'==-99999
	format date_n_20007_0_`i' %td //format as a date
}
*have a sense check across feeder and resultant variables
sort n_20007_0_1 //remember the data have been sorted moving forwards!
list n_20007_0_1 days_n_20007_0_1 date_n_20007_0_1 n_52_0_0 n_34_0_0 in 1/25 

*now sense check this against the interpolated year of first diagnosis - are these congruent?
list date_n_20007_0_1 n_20006_0_1 in 1/25

*now subtract the date of first cancer diagnosis from the assessment centre date - is the difference less than 5*365.25? (i.e. approximately within
*the last 5 years to our best guess)? Note this is an approximation 
forvalues i = 0/5 {
	gen diff_n_20007_0_`i'=ts_53_0_0 - date_n_20007_0_`i' // date of assessment centre minus approximate date of first cancer diagnosis (in days)
	replace diff_n_20007_0_`i'=-99999 if date_n_20007_0_`i'==-99999
	gen yrsdiff_n_20007_0_`i'=diff_n_20007_0_`i'/365.25 // years between first cancer diagnosis and assessment centre date
	replace yrsdiff_n_20007_0_`i'=-99999 if diff_n_20007_0_`i'==-99999
	gen L5Y_n_20001_0_`i'=0
	replace L5Y_n_20001_0_`i'=1 if yrsdiff_n_20007_0_`i'<5 & yrsdiff_n_20007_0_`i' !=. // indicator variable - is yearly difference <5 years?
	replace L5Y_n_20001_0_`i'=. if yrsdiff_n_20007_0_`i'==.
	replace L5Y_n_20001_0_`i'=-99999 if yrsdiff_n_20007_0_`i'==-99999
}

*so L5Y_n_20001_0_`i' has values 0 (not within 5 yrs), 1 (yes within 5 yrs), -99999 (had cancer but uncertain timing), '.' (missing - no cancer)

*sense check the above
list date_n_20007_0_1 ts_53_0_0 diff_n_20007_0_1 yrsdiff_n_20007_0_1 L5Y_n_20001_0_1 in 1/25

*now L5Y_n_20001_0_0-L5Y_n_20001_0_5 can be used as case control variables for the cancers specified in n_20001_0_0/5
*however, we need to replace case status with missing if the corresponding cancer is non-melanoma skin cancer as this is excluded from 
*the CAM MM definition

forvalues i = 0/5 {
	replace L5Y_n_20001_0_`i'=. if n_20001_0_`i'==1060  
}


*now collapse the 6 indicator variables into 1 variable: 0 if all 6 are 0 or missing (no cancer or cancer more than 5 years ago), 1 if at least 
*1 is 1 (has had a cancer (excl non melanoma skin) in the last 5 years), -99999 if at least one is -99999 and the remainder not equal to 1 (so 
*cannot exclude possibility that the -99999 entry was within 5 years)

*note that here we allow missing values for L5Y_n_20001_0_`i' to be 0 in the collapsed variable, because generally this is 
*where individual has never had a cancer diagnosis. ?could use n_2012_0_* instead for unknowns?

gen colL5Y_n_20001_0=0 //haven't had cancer in last 5 years (or at all)
forvalues i = 0/5 {
	replace colL5Y_n_20001_0=-99999 if colL5Y_n_20001_0==0 & L5Y_n_20001_0_`i'==-99999
	replace colL5Y_n_20001_0=1 if L5Y_n_20001_0_`i'==1
}

*Final variable for analysis is colL5Y_n_20001_0, indictor for whether individual has had a cancer (excl non-melanoma skin cancer)
*in the last 5 years from baseline assessment centre (to our best possible approximation). -99999 represents individuals who have had cancer
*but we do not have a date. This should be changed to missing in future analysis.
*Note that unclassifiable cancers are counted if they occurred in the last 5 years. 

