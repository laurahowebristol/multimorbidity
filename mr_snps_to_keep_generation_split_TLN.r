#Folder paths
folder_path = 
snp_path = 
file_path = 
split_sample_path = 
data_path = 

setwd(folder_path)

#Write .do code to keep SNPs for each trait for MR data - SPLIT SAMPLE

#Load in harmonised data - SPLIT SAMPLE
exposure_dat_harmonised = read.csv()
traits = unique(exposure_dat_harmonised$trait[exposure_dat_harmonised$included == 1])
file = paste(file_path,"/snps_to_keep_ss.do",sep="")
write("**Do file to keep SNPs for each exposure",file,append=FALSE)
write(paste('cd "',data_path,'"',sep=""),file,append=TRUE)
for(t in traits) {
  snps = as.character(unique(exposure_dat_harmonised$SNP[exposure_dat_harmonised$trait == t & exposure_dat_harmonised$included == 1]))
  write(paste("*Trait = ",t,sep=""),file,append=TRUE)
  write('use "snp_ipd_ss.dta", clear',file,append=TRUE)
  write(" ",file,append=TRUE)
  snps_line = "keep id_ieu "
  for(s in snps){
    snps_line = paste(snps_line,s,"_ ",sep="")
  }
  write(snps_line,file,append=TRUE)
  write(paste('save "xxxxxxxx\\snps_',t,'.dta", replace',sep=""),file,append=TRUE)
  write('merge 1:1 id_ieu using "xxxxxxxx\\outcomes.dta", nogen',file,append=TRUE)
  
  #Split sample, so only need half the sample in the regressions
  x = nchar(t)
  if(substr(t,x,x) == "1"){
    write("keep if sample == 1",file,append=TRUE)
  }
  else{
    write("keep if sample == 2",file,append=TRUE)
  }
  
  if(substr(t,1,3)=="alc"){
    outcome="out_multimorbid_SRnoalc_2"
  }
  else {
    outcome="out_multimorbid_SR_2"
  }
  
  if (substr(t,1,x-1)=="BMI_split_sample_split"){
      traitval="phe_bmi"  
  } else if (substr(t,1,x-1)=="edu_split_sample_split") {
      traitval="phe_eduyears_scaled"  
  } else if (substr(t,1,x-1)=="csi_split_sample_split") {
      traitval="phe_lifetime_smoking"
  } else if (substr(t,1,x-1)=="alcohol_split_sample_split") {
      traitval="phe_alcohol_intake"
  }
  
  write(paste('gen snp = ""
        gen effect_allele = ""
        gen eaf = .
        gen outcome = ""
        gen beta = .
        gen se = .
        gen p = .
        gen cases = .
        gen controls = .
        gen n_total = .
		gen trait = ""
		gen beta_exposure = .
		gen se_exposure = .
		
		
        local i = 1

        local out = substr("',outcome,'",5,.)
		
        qui regress ', outcome,' rs* age sex pc*
                
        foreach snp of varlist rs* {
        local snpx = substr("`snp\'",1,length("`snp\'")-2)
        qui replace snp = "`snpx\'" in `i\'  
        qui replace outcome = "`out\'" in `i\'
        
        qui replace beta = _b[`snp\'] if snp == "`snpx\'" & outcome == "`out\'"
        qui replace se = _se[`snp\'] if snp == "`snpx\'" & outcome == "`out\'"
        qui sum `snp\'  
        qui replace eaf = r(mean)/2 if snp == "`snpx\'"  
        local effect_allele = upper(substr("`snp\'",length("`snp\'"),1))
        qui replace effect_allele = "`effect_allele\'" if snp == "`snpx\'" 
		
		local i = `i\'+1        
        }
        
        *Ns

        qui sum ', outcome,'
        qui replace n_total = r(N) if outcome == "`out\'"
		 
        qui regress ', traitval,' rs* age sex pc*
		
		replace trait="', t,'" if outcome == "`out\'"
		
		foreach snp of varlist rs* {
		    local snpx = substr("`snp\'",1,length("`snp\'")-2)
			
		    qui replace beta_exposure = _b[`snp\'] if snp == "`snpx\'" & outcome == "`out\'"
			qui replace se_exposure = _se[`snp\'] if snp == "`snpx\'" & outcome == "`out\'"
		
		}
		
		
        keep snp-se_exposure 
        keep if snp != ""
        qui replace p = 2*normal(-abs(beta/se))',sep=""),file,append=TRUE)
  write(paste('save "xxxxx\\results_',t,'.dta", replace',sep=""),file,append=TRUE)
  
  write("",file,append=TRUE)
}

#End of code

rm(list=ls())