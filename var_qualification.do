**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 18 August 2017
*Purpose: clean the qualification variables
********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

*capture clear
capture log close
set more off

log using "${dlog}\var_qualification.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

tempfile temp 

*merge m:1 id using "${ddtah}\w6_listeeid.dta"
*drop if _merge==2
*drop _merge

*replace listeeid=112065 if id==81086&listeeid==.

save "`temp'"

********************************************************

/*Clean up the qualification data from MABEL Waves 1-4 */
*tempfile temp w1temp w2temp w3temp w4temp

foreach n of num 1 2 3 4 {

use "L:\Data\Data Clean\Wave7\dtah\Internal release\w`n'_internal_Feb2016.dta", clear 

gen fellow=""
replace pipqa1= upper(pipqa1)
replace pipqa2= upper(pipqa2)
replace pipqa3= upper(pipqa3)
replace pipqa4= upper(pipqa4)
replace pipqa5= upper(pipqa5)


foreach x of var pipqa* {

*Keep all original qualification text responses in generated *_comment variables



gen `x'_comment = `x'

replace `x'=subinstr(`x', ",", " ", .)
replace `x'=subinstr(`x', ".", " ", .)
replace `x'=subinstr(`x', ";", " ", .)
replace `x'=subinstr(`x', "/", " ", .)
replace `x'=subinstr(`x', "-", " ", .)
replace `x'=subinstr(`x', ">", " ", .)
replace `x'=subinstr(`x', "}", " ", .)
replace `x'=subinstr(`x', "?", " ", .)
replace `x'=regexr(`x', "[(].*[)]", "")

replace `x'=itrim(`x')
replace `x'=trim(`x')

*tab `x'_comment, sort

*Extract Fellowship from all degree title variables

local fellow RACGP RACP ANZCA RACS RANZCP ACEM RANZCOG RANZCR RCPA ACRRM RANZCO CICM ACHPM FPMANZCA AFRM /// 
	  ARGP FARACS ACD AFPHM RACMA AFOEM ACHSHM ACNEM JFICM ACHAM ACCS ACOM ACSHP AFOM ASMF CSANZ FICANZCA /// 
	  RACDS SDRA ACTM ACRM SCCANZ ACSP AORTHA ANZAPNM AANMS ACLM RACR AFMM ACPSYCHMED ASPM ACHI ACASM /// 
	  AAQHC ACHSM RANZCPSYCH AMAC ACSCM AACB

	foreach i in `fellow' {
	
	gen a=1 if regexm(`x', "(F`i')$")

	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "(F`i')$", "")
	drop a

	gen a=1 if regexm(`x', "(F`i')[ ]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "(F`i')[ ]", "")
	drop a
	
	gen a=1 if regexm(`x', "(F`i')[(]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "(F`i')[(]", "")
	drop a	
	
	gen a=1 if regexm(`x', "^(`i')[ ]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "^(`i')[ ]", "")
	drop a

	gen a=1 if regexm(`x', "^(`i')$")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "^(`i')$", "")
	drop a

	gen a=1 if regexm(`x', "[ ](`i')[ ]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "[ ](`i')[ ]", "")
	drop a
	
	}

replace `x'=itrim(`x')
replace `x'=trim(`x')


}
keep id listeeid fellow
keep if fellow!=""
rename fellow w`n'fellow
save "L:\Data\Data Clean\Wave8\dtah\w`n'fellow.dta", replace

}


*************************************************************
*Comment added by Wenda

*Clean the qualification data from AMPCo to MABEL Wave 7
*the AMPCo data file used here ampco_qualification.dta is generated from the excel file AMPCo us (Mabel Doctor's Qualifications.xlsx)
*changed from long format to wide, all the source files can be found in 'L:\Data\Data Clean\Wave5\AMPCo doc qualification'
*the most recent AMPCo data with qualification i can find is dated 17/01/2013, you may want to request an update from AMPCo

*For the qualifications, you only need to clean up the number of qualificaions, and in terms of the name of qual, undergradute/gradute entry 
*medical degree/fellowships are cleaned up using the following codes

********************************************************

/*Set the qualification categories: 1 = Bachelor
									2 = Masters
									3 = PhD
									4 = Postgraudate Diploma / Certificate
									5 = Fellowship
*/


*This file is given to us by AMPCo at the time of drawing the sample 

do "${ddo}\AMPCo doc qualification\convertquals.do " 
save "${ddo}\AMPCo doc qualification\ampco_qualification.dta", replace

foreach i of num 1 2 3 4 5 6 7 8 10 {

use "L:\Data\Data Clean\Wave8\AMPCo doc qualification\ampco_qualification.dta", clear


ren qual_description qual

*keep if location=="ACT"|location=="AUSTRALIA"|location=="NSW"|location=="NT"|location=="QLD"|location=="SA"|location=="TAS"|location=="VIC"|location=="WA"

replace qual="Doctor of Philosophy (Medical Oncology)" if qual=="Doctor of Philosophy (Medical Oncology)"
replace qual=trim(qual)
replace qual=itrim(qual)

gen group=.

replace group=1 if regexm(qual, "(Bachelor)")
replace group=2 if regexm(qual, "(Master)")
replace group=3 if regexm(qual, "(Doctor)")
replace group=4 if regexm(qual, "(Diploma)|(Certificate)|(Graduate Certificate)|(Graduate Diploma)|(Post Grad)|(Postgrad Diploma)")
replace group=5 if regexm(qual, "(Fellow)")

tab group

sort listeeid group

by listeeid: gen N=_N
by listeeid: gen n=_n

tab N

tempfile quan`i'

keep if N==`i'

save "`quan`i''"

	foreach j of num 1/`i' {
	
	tempfile qua`i'_`j'
	
	preserve
	
	keep if n==`j'
	
	renvars qual - group, postf(_`j')
	drop n
	
	save "`qua`i'_`j''"
	
	restore
	
	}
	
}

use "`qua1_1'", clear

foreach i of num 2/8 10 {

append using "`qua`i'_1'"

	foreach j of num 2/`i' {

	merge 1:1 listeeid using "`qua`i'_`j''"
	drop _merge
	
	}
	
}

save "${ddtah}\AMPCo_qualification.dta", replace

*******************************************************************

/*Clean up the qualification data from MABEL Wave 8*/

use "`temp'", clear

*1. Standardise number of qualifications and titles, clean up mixed numbers and text

foreach x of var piqanm piqanph piqandc piqanf {

replace `x' = upper(`x')
replace `x' = "0" if `x'=="NIL"|`x'=="NA"|`x'=="N/A"| `x'=="NO"

gen m_`x'=1 if regexm(`x', "[A-Z]")

}

foreach x of var piqadm piqadph piqaddc piqadf  {

replace `x' = upper(`x')
gen m_`x'=1 if regexm(`x', "[0-9]")

}



*1.3 Masters Degree

list id dtimage continue piqanm  piqadm  if m_piqanm==1|m_piqadm==1
replace piqadm="" if m_piqadm==1
replace piqanm="0" if m_piqanm==1  //need to check this is valid. I checked and came across the 2 exceptions (below) in w7.


	replace piqanm="1" if id==1000186|id==1000536
*replace piqanm="1" if id==48093
*replace piqadm="MASTER OF SURGERY" if id==48093
*replace piqanm="2" if id==97931

*replace piqadm="MSC ENDOCRINOLOGY; MSC APPLIED NUTRITION" if id==97631



*1.4 PhD


list dtimage id piqanph piqadph if m_piqanph==1|m_piqadph==1

replace piqadph="" if m_piqadph==1
replace piqanph="0" if m_piqanph==1  //need to check this is valid. 

list dtimage id piqanph piqadph if piqanph!=""

	replace piqanph="0" if id==48915|id==1000666


*1.5 Postgraduate diploma/certificate

list id dtimage piqandc piqaddc if m_piqandc==1|m_piqaddc==1

replace piqaddc="" if m_piqaddc==1
replace piqandc="0" if m_piqandc==1  //need to check this is valid. I checked and came across the exceptions (below) in w8.

	replace piqandc="2" if id==14811
	replace piqandc="1" if id==82287
	replace piqaddc="PGDIPCU" if id==82287

*id==21462 listed "Dip Herbal Medicine" but they listed this in wave 7 as well so it is not from past 12 months, so will not count this.

/*replace piqandc="1" if id==7778
replace piqaddc="ALS2" if id==7778
replace piqandc="1" if id==10167
replace piqaddc="GRAD DIP PALLIATIVE CARE" if id==10167
replace piqandc="1" if id==21462
replace piqaddc="DIP HERBAL MEDICINE" if id==21462
replace piqandc="6" if id==58571
replace piqaddc="VARIETY" if id==58571
replace piqandc="1" if id==74963
replace piqaddc="ECFMG CERTIFICATION" if id==74963
replace piqandc="1" if id==97156
replace piqaddc="PALLIATIVE MEDICINE DIPLOMA" if id==97156
replace piqandc="2" if id==97931
replace piqaddc="DIPLOMA DIABETEOLOGY; PG CERT MED EDUCATION" if id==97931*/

*1.6 Fellowship of college

list id dtimage continue piqanf piqadf if m_piqanf==1|m_piqadf==1

replace piqadf="" if m_piqadf==1
replace piqanf="0" if m_piqanf==1  //need to check this is valid. I checked and came across the exceptions (below) in w8.

	replace piqanf="1" if id==11113
	replace piqadf="FRACGP" if id==11113
*id==21462 listed "FRACGP" but they listed this in wave 7 as well so it is not from past 12 months, so will not count this.
	replace piqanf="1" if id==22357
	replace piqanf="1" if id==25054
	replace piqadf="FRACP" if id==25054
	replace piqadf="FACHPM" if id==44499
	replace piqanf="1" if id==44499
	replace piqanf="1" if id==46512
	replace piqadf="FRACP" if id==46512
	replace piqanf="1" if id==48010
	replace piqadf="FACEM" if id==48010
	replace piqanf="1" if id==55930
	replace piqadf="FRACP" if id==55930
	replace piqanf="1" if id==60066
	replace piqadf="FRANZCOG" if id==60066
	replace piqanf="1" if id==61584
	replace piqadf="FRACGP" if id==61584
	replace piqadf="FACD" if id==61585 
	replace piqanf="1" if id==63455
	replace piqadf="FAFPHM" if id==63455
	replace piqadf="FRACGP" if id==68113
	replace piqanf="0" if id==70209
	replace piqadf="" if id==70209
	replace piqanf="1" if id==71312
	replace piqadf="FRACP" if id==71312
	replace piqanf="1" if id==71562
	replace piqadf="FRACGP" if id==71562	
	replace piqanf="1" if id==97399
	replace piqadf="FRACGP" if id==97399
	replace piqanf="1" if id==1000008
	replace piqadf="FRANZCR" if id==100008
	replace piqanf="1" if id==1000186
	replace piqadf="FRACGP" if id==1000186




drop m_piqa*

******************************************************************

*2.Standardise numeric response to question of number of qualifications

foreach x of var piqanm piqanph piqandc piqanf {

ren `x' `x'_comment

gen `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9])$")
replace `x'=0 if `x'_comment=="-"&`x'==.
replace `x'=1 if `x'_comment=="*"&`x'==.

tab `x'_comment if `x'==.
list `x'_comment dtimage id if `x'==. &`x'_comment!=""

}


foreach x of var  piqanm piqanph piqandc piqanf {
tab `x'
*replace `x'=1 if `x'_comment=="*"&`x'==.
}


*2.3 Masters degree

list id dtimage piqanm_comment piqadm if piqanm_comment!=""&piqanm==.
* all ok - wave 8

*2.4 PhD

list id dtimage piqanph_comment piqadph if piqanph_comment!=""&piqanph==.
* all oK - wave 8


*2.5 Postgraduate diploma/certifcate

list id dtimage piqandc_comment piqaddc if piqandc_comment!=""&piqandc==.
replace piqandc=0 if id==82943

*2.6 Fellowship of college

list id dtimage piqanf_comment piqadf if piqanf_comment!=""&piqanf==.
replace piqanf=1 if id==1000185


******************************************************************

*3 link the qualification from AMPCo to MABEL data


merge m:1 listeeid using "${ddtah}\ampco_qualification.dta"

drop if _merge==2

tab N



drop recno_8 - group_10

egen N_master = anycount(group_1 group_2 group_3 group_4 group_5 group_6 group_7) if _merge==3, values(2)
egen N_phd = anycount(group_1 group_2 group_3 group_4 group_5 group_6 group_7) if _merge==3, values(3)
egen N_dipcert = anycount(group_1 group_2 group_3 group_4 group_5 group_6 group_7) if _merge==3, values(4)
egen N_fellow = anycount(group_1 group_2 group_3 group_4 group_5 group_6 group_7) if _merge==3, values(5)

*use medical school from ampco where medical school not available from MABEL. 
*New docs only, as data for continuing docs is imputed in crosswave_ampco.do

list id pims school_1 if pims<0 & continue=="New" & school_1!=""

	replace pims=11 if id==1000635|id==1000337  //Sydney
	replace pims=1 if id==1000606   //Newcastle
	replace pims=2 if id==1000813
	replace pims=19 if id==1001000|id==1000908
	replace pims=8 if id==1000144
	replace pims=9 if id==1000615|id==1000389
	replace pims=16 if id==1000674
	
	


replace pims=0 if  continue=="New" & school_1!=""  //all other are non-australian unis
replace picmda=0 if pims==0 &picmda==-2

*some schools are invalid
list id source response continue sdtype pims dtimage school_1 if pims > 23&pims<.


***********************************************************************

*3. Standardise the text responses to question of qualification titles

gen fellow=""

foreach x of var piqadm piqadph piqaddc piqadf {

*Keep all original qualification text responses in generated *_comment variables



gen `x'_comment = `x'

replace `x'=subinstr(`x', ",", " ", .)
replace `x'=subinstr(`x', ".", " ", .)
replace `x'=subinstr(`x', ";", " ", .)
replace `x'=subinstr(`x', "/", " ", .)
replace `x'=subinstr(`x', "-", " ", .)
replace `x'=subinstr(`x', ">", " ", .)
replace `x'=subinstr(`x', "}", " ", .)
replace `x'=subinstr(`x', "?", " ", .)
replace `x'=regexr(`x', "[(].*[)]", "")

replace `x'=itrim(`x')
replace `x'=trim(`x')

*tab `x'_comment, sort

*Extract Fellowship from all degree title variables

local fellow RACGP RACP ANZCA RACS RANZCP ACEM RANZCOG RANZCR RCPA ACRRM RANZCO CICM ACHPM FPMANZCA AFRM /// 
	  ARGP FARACS ACD AFPHM RACMA AFOEM ACHSHM ACNEM JFICM ACHAM ACCS ACOM ACSHP AFOM ASMF CSANZ FICANZCA /// 
	  RACDS SDRA ACTM ACRM SCCANZ ACSP AORTHA ANZAPNM AANMS ACLM RACR AFMM ACPSYCHMED ASPM ACHI ACASM /// 
	  AAQHC ACHSM RANZCPSYCH AMAC ACSCM AACB

	foreach i in `fellow' {
	
	gen a=1 if regexm(`x', "(F`i')$")

	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "(F`i')$", "")
	drop a

	gen a=1 if regexm(`x', "(F`i')[ ]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "(F`i')[ ]", "")
	drop a
	
	gen a=1 if regexm(`x', "(F`i')[(]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "(F`i')[(]", "")
	drop a	
	
	gen a=1 if regexm(`x', "^(`i')[ ]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "^(`i')[ ]", "")
	drop a

	gen a=1 if regexm(`x', "^(`i')$")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "^(`i')$", "")
	drop a

	gen a=1 if regexm(`x', "[ ](`i')[ ]")
	replace fellow=fellow+", F`i'" if a==1&fellow!="" & (fellow!="F`i'")
	replace fellow="F`i'" if a==1&fellow==""
	replace `x' = regexr(`x', "[ ](`i')[ ]", "")
	drop a
	
	}

replace `x'=itrim(`x')
replace `x'=trim(`x')

}

sort id

foreach x of var piqadm piqadph piqaddc piqadf {

gen `x'_fellow =  `x' if regexm(`x', "(FELLOW)")
replace `x'_fellow = `x' if regexm(`x', "^(F)")
list id listeeid dtimage fellow N_fellow `x'_fellow if `x'_fellow!=""

}


foreach x of var piqadm piqadph piqaddc piqadf {
list id listeeid dtimage fellow N_fellow `x'_fellow if `x'_fellow!=""

}
*use the list of fellowships to recode any errors. Only include Australian Fellowships
	replace fellow = "FRACGP" if id==2283
	replace fellow = "FACASM" if id==2288
	*6514
	*11905
	*13429
	replace fellow = "FACRRM" if id==14036
	replace fellow = "FRACGP" if id==18609
	replace fellow = "FRCPA FFCFM" if id==19541
	*20843
	replace fellow = "FRCPA FFCFM" if id==25206
	replace fellow = "FRACS" if id==25640
	replace fellow = "FRANZCOG" if id==26510
	*26723
	*26978
	*27034
	*28540
	*28778
	*30402
	*30656
	replace fellow = "FRACS FAORTHA" if id==30766
	*31319
	*32283
	*34862
	*36710
	*37155
	*37556
	*37974
	*38447
	*40630
	*40700
	replace fellow = "FRACMA" if id==40752
	replace fellow = "FRACMA" if id==41401
	replace fellow = "FRACGP, FRANZCOG" if id==41794
	replace fellow = "FACEM, FACRRM" if id==42141
	*43037
	*43655
	*51651
	*54979
	*55393
	replace fellow = "FAFRM" if id==57364
	replace fellow = "FACEM" if id==57552
	replace fellow = "FRACGP" if id==58570
	*59033
	replace fellow = "FRACS, FACCS" if id==59063
	*59372
	replace fellow = "FRACGP" if id==60725
	replace fellow = "FRANZCR" if id==61512
	*62840
	*64904
	replace fellow = "FAHMS" if id==68963   //THIS IS A FELLOWSHIP IN MEDICAL RESEARCH. NOT ON STANDARD LIST BUT SEEMS RELEVANT - TT 23/8/16
	replace fellow = "FRANZCOG, FRACGP" if id==72621
	*73181
	*73287
	*73657
	*79419
	replace fellow = "FRACP" if id==77047
	replace fellow = "FFCFM" if id==82885
	replace fellow = "FRACGP" if id==84443
	replace fellow = "FRANZCOG" if id==85851
	*91639
	replace fellow = "FFPMANZCA" if id==97913
	replace fellow = "FACEM" if id==1000041
	*1000379
	replace fellow = "FRANZCP" if id==1000432
	*1000542
		
	


*merge with previous waves to get 
preserve


*tt amended next bit - 18/0/16
tempfile w7 w4 w3 w2 w1 

use "L:\Data\Data Clean\Wave7\dtah\Internal release\w7_internal_Feb2016.dta", clear
drop if sdtype==-1
keep listeeid id piqanm piqanph piqandc piqanf  piqadf
renvars _all, pref(w7_)
ren w7_listeeid listeeid
save "`w7'"

*THE NEXTBIT WILL BE UNECCESSARY IN WAVE 9
/*use "L:\Data\Data Clean\Wave8\dtah\", clear
drop if sdtype==-1
keep listeeid id piqanm piqanph piqandc piqanf  piqadf
renvars _all, pref(w6_)
ren w6_listeeid listeeid
save "`w6'"

use "L:\Data\Data Clean\Wave7\dtah\Internal release\w5_internal_Feb2016.dta", clear
drop if sdtype==-1
drop *_c *_multi*
keep listeeid id piqanm piqanph piqandc piqanf  piqadf
renvars _all, pref(w5_)
ren w5_listeeid listeeid
save "`w5'"*/

restore

drop _merge 

merge 1:1 listeeid using "`w7'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "L:\Data\Data Clean\Wave8\dtah\w4fellow.dta"
drop if _merge==2
drop _merge
merge 1:1 listeeid using "L:\Data\Data Clean\Wave8\dtah\w3fellow.dta"
drop if _merge==2
drop _merge
merge 1:1 listeeid using "L:\Data\Data Clean\Wave8\dtah\w2fellow.dta"
drop if _merge==2
drop _merge
merge 1:1 listeeid using "L:\Data\Data Clean\Wave8\dtah\w1fellow.dta"
drop if _merge==2
drop _merge

*impute piqanm piqanph piqandc if they are 0 in W7
* code to either 0 or 1 for W7. No longer need actual number for these quals

foreach x of var piqanm piqanph piqandc {
*replace `x'=1 if w5_`x'>0 & w5_`x'!=.
*replace `x'=1 if w6_`x'>0 & w6_`x'!=.
replace `x'=1 if w7_`x'>0 & w7_`x'!=.
replace `x'=1 if `x'>0 & `x'!=.
tab `x' w7_`x'
}



*several fellowships are duplicated in w8- must remove (there should be an automatic way of doing this but there are so few it seems quicker to do individually
	replace fellow="FCICM FJFICM" if id==68716


list id qual_1 qual_2 qual_3 N_fellow fellow piqadf w7_piqadf if N_fellow==1 & fellow=="" &w7_piqadf==""
*some in qual_1 qual_2 qual_3 were not carried over - add in here.
	replace fellow="FRACS" if id==1417
	replace fellow="FAFOEM" if id==13325
	replace fellow="FRANZCOG" if id==28961
	replace fellow="FAFRM" if id==29562
	replace fellow="FAFRM" if id==30981
	replace fellow="FAFRM" if id==31983
	replace fellow="FACEM" if id==38869
	replace fellow="FAFRM" if id==42148
	replace fellow="FRACGP" if id==46682
	replace fellow="FRACP" if id==53364
	replace fellow="FRANZCP" if id==53740
	replace fellow="FRANZCP" if id==55214
	replace fellow="FRACGP" if id==82822	


*replace fellow = w7_piqadf if fellow=="" & w7_piqadf!="" & continue=="Continue"
*replace fellow = w5_piqadf if fellow=="" & w5_piqadf!="" & continue=="Continue"




****added for wave 8 to combine responses from w1-w4 and w7 and w8

foreach x in  w7_piqadf fellow w4fellow w3fellow w2fellow w1fellow {	
gen `x'1=""
	  gen `x'2=""
	  gen `x'3=""
	  gen `x'4=""
	  gen `x'5=""
	  
replace `x'=subinstr(`x', ",", "", .)	  
  
replace `x'1=" " + regexs(1) if regexm(`x', "^([A-Z]+)")	  
replace `x'2=" " + regexs(2) if regexm(`x', "^([A-Z]+)[ ]([A-Z]+)")
replace `x'3=" " + regexs(3) if regexm(`x', "^([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)")
replace `x'4=" " + regexs(4) if regexm(`x', "^([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)")
replace `x'5=" " + regexs(5) if regexm(`x', "^([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)")	  
}




/*foreach i of num 1/5 {
replace w6_piqadf`i'="" if strpos(w5_piqadf, trim(w6_piqadf`i'))|strpos(fellow, trim(w6_piqadf`i'))
}
*/

*egen fellows = concat( w7_piqadf1 w7_piqadf2 w7_piqadf3 w7_piqadf4 w7_piqadf5 w4fellow1 w4fellow2 w4fellow3 w4fellow4 w4fellow5 w3fellow1 w3fellow2 w3fellow3 w3fellow4 w3fellow5 w2fellow1 w2fellow2 w2fellow3 w2fellow4 w2fellow5 w1fellow1 w1fellow2 w1fellow3 w1fellow4 w1fellow5 )

gen fellows=""

foreach i of num 1 2 3 4{
	foreach n of num 1 2 3 4 5 {
	replace w`i'fellow`n'="" if strpos(fellows, w`i'fellow`n')
	replace fellows=fellows  + w`i'fellow`n' 
	}
}	

foreach n of num 1 2 3 4 5 {
replace w7_piqadf`n' ="" if strpos(fellows, w7_piqadf`n')
replace fellows=fellows + w7_piqadf`n'
}

foreach n of num 1 2 3 4 5 {
replace fellow`n' ="" if strpos(fellows, fellow`n')
replace fellows=fellows + fellow`n'
}

	*
*******************************************************************

*identify the number of fellowships

*******************************************************************
gen n=wordcount(fellows)

/*replace n=5 if regexm(fellows, "^([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)$")&n==.
replace n=4 if regexm(fellows, "^([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)$")&n==.
replace n=3 if regexm(fellows, "^([A-Z]+)[ ]([A-Z]+)[ ]([A-Z]+)$")&n==.
replace n=2 if regexm(fellows, "^([A-Z]+)[ ]([A-Z]+)$")&n==.
replace n=1 if regexm(fellows, "^([A-Z]+)$")&n==.*/

drop fellow
rename fellows fellow


***************************************************************************************

*check different ones by eye
*sort id
*list id n fellow w7_piqadf qual_1  if fellow!=w7_piqadf & fellow!="" & w7_piqadf!=""

*all ok



**5/5/2015
*list id fellow piqadf_comment w7_piqadf if piqadf=="" &piqadf_comment!="" & piqadf_comment!=fellow 
*replace fellow = "FCICM" if id==49452
*none to replace in W7


*list id qual_1 qual_2 qual_3 N_fellow fellow piqadf w7_piqadf if N_fellow==1 & fellow==""

	

**********************************************************************

drop recno_1 N recno_2  recno_3 recno_4 recno_5 recno_6 recno_7 /// 
piqadm_fellow piqadph_fellow piqaddc_fellow piqadf_fellow /// 

 


*********************************************************************

*match the number of qualification and title of qualifications

list piqanf n fellow id if (piqanf==0 | piqanf==.) & fellow!=""

*******************************************************************

*drop piqad* variables so all original qualification responses retained in *_comment

drop piqadm piqadph piqaddc piqadf piqanf w7* *fellow1 *fellow2 *fellow3 *fellow4 *fellow5 w*fellow

rename n piqanf 
ren fellow piqadf


preserve

keep listeeid id sdtype continue response source dtimage /// 
	 piqadm_comment piqadph_comment piqaddc_comment piqadf_comment /// 
qual_1 qual_2 qual_3 qual_4 qual_5 qual_6 qual_7 year_grad_1 ///
  year_grad_2 year_grad_3 year_grad_4 year_grad_5 piqadf /// 
	 location_1 location_2 location_3 location_4 location_5 location_6 location_7 picmd picmda picmdo  /// 
	 group_1 group_2 group_3 group_4 group_5 group_6 group_7 N_* piqanm piqanph piqandc piqanf pims

save "${ddtah}\qualification_all.dta", replace

restore

*******************************************************************










