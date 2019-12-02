

*Purpose: calculate sample weights

********************************************************

global ddtah="D:\Data\Data Clean\Wave9\dtah"
global ddo="D:\Data\Data Clean\Wave9"
global dlog="D:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\weights.log", replace

********************************************************

use "${ddtah}\temp_all.dta", clear

********************************************************

tempfile cs_weights l_weights w9response

*************************
*Cross sectional weights*
*************************

tempfile doc2016 w9m w9p w9res asgc1 asgc2 doc2015

preserve 

keep if sdtype!=-1

keep listeeid piyrbi pigeni sdtype asgc cheque state glpcw csclid cspret 
renvars piyrbi pigeni sdtype asgc cheque state glpcw csclid cspret, pref(res_)

save "`w9res'"

use "D:\Data\Samples\Wave 9\Alldocs2016\Alldocs2016.dta", clear  


keep listeeid dtstate personsex  personage dtpostcode type
ren dtstate state
ren personsex gender
ren personage age
*ren type2014 type
ren dtpostcode postcode

save "`doc2016'"

use "D:\Data\Samples\Wave 9\W9final.dta", clear
drop typeW7p    // applicable for Wave 9. Check in next waves
renvars _all, lower
keep listeeid dtstate dtpostcode dtdpid personage type specialty employmentdetailpractisingstatus asgc_cat ///
      personsex doctormedicaldiscipline

ren dtstate m_state
ren dtpostcode m_postcode
ren personsex m_gender
ren personage m_age
ren type m_type
ren asgc_cat m_asgc
ren employmentdetailpractisingstatus status
ren doctormedicaldiscipline discipline

save "`w9m'"


use "D:\Data\Samples\Wave 9 Pilot\W9Pfinal.dta", clear

*drop chequew7 chequeW7
*drop typeW7p    // only for Wave 8. Remove this line for wave 9
renvars _all, lower
keep listeeid dtstate dtpostcode dtdpid personage personsex /*v21*/ type asgc_cat //IT LOOKS LIKE V21 IS PERSONAGE

ren dtstate p_state
ren dtpostcode p_postcode
*ren dtdpid p_gender //***************THIS VARIABLE DOESN'T LOOK LIKE GENDER. SHOULD IT BE personsex INSTEAD?**********
replace personsex = trim(personsex)
ren personsex p_gender
ren /*v21*/ personage p_age
destring p_age, replace
ren type p_type
ren asgc_cat p_asgc

save "`w9p'"

use "D:\Data\Samples\Wave 9\W9final.dta", clear
drop typeW7p    // applicable for Wave 9. Check in next waves
renvars _all, lower
keep dtpostcode asgc_cat
ren dtpostcode postcode
ren asgc_cat asgc
drop if postcode==.
duplicates drop postcode, force

save "`asgc1'"

use "D:\Data\Samples\Wave 9 Pilot\W9Pfinal.dta", clear
*drop typeW7p    // only for Wave 8. Remove this line for wave 9
*drop chequew7 chequeW7
renvars _all, lower
keep dtpostcode asgc_cat
ren dtpostcode postcode
ren asgc_cat asgc

drop if postcode==.
duplicates drop postcode, force

save "`asgc2'"

use "D:\Data\Samples\Wave 8\W8_All", clear
drop _merge
merge 1:1 listeeid using "D:\Data\Samples\Wave 8\W8_All_wRur", keepusing(ASGC_Cat RRMA)

*tt added this line on 11/6/2015 in order to produce weights for Wave 7 data
*save "D:\Data\Data Clean\Wave4\dtah\Alldocs2014_ASGC.dta", replace

*use "D:\Data\Data Clean\Wave8\dtah\Alldocs2014_ASGC.dta", clear     // this file was created by adding a line in W6.do. Check how it was done and do the same in W7b.do for Wave 8
keep listeeid dtstate ASGC_Cat personage personsex dtdpid RRMA
*replace	postcode="4558" if listeeid==400496
*replace	personsex="M" if listeeid==400496
*replace	personage="53" if listeeid==400496
*replace	doctormedicaldiscipline="Surgery - Plastic & Reconst" if listeeid==400496
destring personage, replace
ren dtstate state2015
ren ASGC_Cat asgc2015
*ren dtdpid gender2015 //***************THIS VARIABLE DOESN'T LOOK LIKE GENDER. SHOULD IT BE personsex INSTEAD?**********
replace personsex = trim(personsex)
ren personsex gender2015
*ren v21 dob2014
rename personage age2015

save "`doc2015'"


*********************************************

use "`doc2016'", clear

merge 1:1 listeeid using "`w9res'"

gen response=1 if _merge==2|_merge==3
replace response=0 if response==.
drop _merge

merge 1:1 listeeid using "`w9m'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w9p'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`doc2015'"
drop if _merge==2
drop _merge

*Drop those doctors who were retired according to AMPCo

replace status=trim(status)

*merge ASGC info from survey sample to population data

replace postcode = res_glpcw if postcode==.&res_glpcw!=.&res_glpcw>0

merge m:1 postcode using "`asgc1'"
drop if _merge==2
drop _merge

merge m:1 postcode using "`asgc2'", update
drop if _merge==2
drop _merge

merge m:1 postcode using "D:\Data\Data Clean\Wave6\dtah\postcode_asgc.dta", update     // this file stays the same from year to year (more or less) - can check with Matthew
drop if _merge==2
drop _merge

********************************************


*replace missing values in the population data

*gender
tostring gender2015, replace
replace gender="M" if gender=="" &res_pigeni==0
replace gender="F" if gender=="" &res_pigeni==1
replace gender=m_gender if gender==""&m_gender!=""
replace gender=p_gender if gender==""&p_gender!=""

replace gender="F" if		///  this is based on givenname where one is known
listeeid	==	237865	|	///
listeeid	==	417085	|	///
listeeid	==	418904	|	///
listeeid	==	612585	

replace gender=gender2015 if gender==""&gender2015!=""

replace gender="M" if gender=="" 		/*assume all missing gender is male*/

*age

destring age m_age p_age, replace
replace age = m_age if age==.

replace age = age2015 if age==.
*replace age = 2015 - real(regexs(1)) if regexm(dob2014, "^([0-9][0-9][0-9][0-9])")&age==.
*from 2015 we were only given age and not dob so the above line will have to change in W9 cleaning

*state

replace state="ACT" if state==""&res_state==1
replace state="NSW" if state==""&res_state==2
replace state="NT" if state==""&res_state==3
replace state="QLD" if state==""&res_state==4
replace state="SA" if state==""&res_state==5
replace state="TAS" if state==""&res_state==6
replace state="VIC" if state==""&res_state==7
replace state="WA" if state==""&res_state==8

replace state=m_state if state==""&m_state!=""
replace state=p_state if state==""&p_state!=""
replace state=state2015 if state==""&state2015!=""

replace state="NSW" if state=="" 	/*assume missing state all values are "NSW"*/

*asgc

replace asgc="Major city" if asgc==""&res_asgc==1
replace asgc="Inner regional" if asgc==""&res_asgc==2
replace asgc="Outer regional" if asgc==""&res_asgc==3
replace asgc="Remote" if asgc==""&res_asgc==4
replace asgc="Very remote" if asgc==""&res_asgc==5

replace asgc=m_asgc if asgc==""&m_asgc!=""
replace asgc=p_asgc if asgc==""&p_asgc!=""
replace asgc=asgc2015 if asgc==""&asgc2015!=""

replace asgc="Major city" if asgc=="" 		/*assume missing asgc all values are "Major city"*/

*cheque

gen cheque=(res_cheque==1)

*type

replace type=res_sdtype if type==.

*************************************************

gen female=(gender=="F")

gen age29=(age>=20&age<30)
gen age3039=(age>=30&age<40)
gen age4049=(age>=40&age<50)
gen age5059=(age>=50&age<60)
gen age6069=(age>=60&age<70)
gen age70=(age>=70&age!=.)
gen agemiss=(age==.)

gen ACT=(state=="ACT")
gen NSW=(state=="NSW")
gen NT=(state=="NT")
gen QLD=(state=="QLD")
gen SA=(state=="SA")
gen TAS=(state=="TAS")
gen VIC=(state=="VIC")
gen WA=(state=="WA")

gen city=(asgc=="Major city")
gen inner=(asgc=="Inner regional")
gen outer=(asgc=="Outer regional")
gen remote=(asgc=="Remote")
gen veryremote=(asgc=="Very remote")

save "${ddtah}\w9_population.dta", replace

*************************************************

*CROSS SECTIONAL WEIGHTS

replace cheque=0 if cheque==1

replace age3039=1 if age29==1&type==1
replace age29=0 if age29==1&type==1

replace remote=1 if veryremote==1&(type==1|type==4)
replace veryremote=0 if veryremote==1&(type==1|type==4)

replace age6069=1 if age70==1&type==4
replace age70=0 if age70==1&type==4

gen prob_cs=.

foreach x of num 1/4 {

logit response female age29 age3039 age5059 age6069 age70 agemiss ACT NT QLD SA TAS VIC WA 	///
				 inner outer remote veryremote cheque if type==`x', or

predict prob_`x' if e(sample)
replace prob_cs=prob_`x' if e(sample)
drop prob_`x'

}

gen weight_cs = 1/prob_cs

keep listeeid weight_cs postcode response
ren postcode w9_postcode
ren response w9response

save "`w9response'"

keep if w9response==1
keep listeeid weight_cs

save "`cs_weights'"

restore

merge 1:1 listeeid using "`cs_weights'"
drop _merge

replace weight_cs=-1 if weight_cs==.

label var weight_cs 	"Cross Sectional Weigths"

*************************************************************
*************************************************************
*************************************************************

**********************
*Longitudinal weights*
**********************

preserve

use "D:\Data\Data Clean\Wave8\dtah\w8_weights.dta", clear

merge 1:1 listeeid using "`w9response'"
drop if _merge==2
drop _merge

drop panel
gen panel=(w1w2w3==1 & w4response==1 & w5response==1 & w6response==1 & w7response==1 & w8response==1 & w9response==1)

gen w1w9=(w9response==1)

drop change

gen change=((w1_postcode!=w2_postcode)|(w2_postcode!=w3_postcode)|(w3_postcode!=w4_postcode)|(w4_postcode!=w5_postcode)| /// 
(w5_postcode!=w6_postcode)|(w6_postcode!=w7_postcode)|(w7_postcode!=w8_postcode)|(w8_postcode!=w9_postcode))&w1_postcode!=. & w2_postcode!=. & w3_postcode!=. & w4_postcode!=. ///
&w5_postcode!=. & w6_postcode!=. & w7_postcode!=. & w8_postcode!=. & w9_postcode!=.
		   

save "${ddtah}\w9_weights.dta", replace

**************************************************

*longitudinal weights

replace remote=1 if veryremote==1&type==2
replace veryremote=0 if veryremote==1&type==2

replace age5059=1 if (age6069==1|age70==1)&type==3
replace age6069=0 if age6069==1&type==3
replace age70=0 if age70==1&type==3

gen prob_l=.

foreach x of num 1/4 {

logit w1w8 female age29 age3039 age5059 age6069 age70 agemiss ACT NT QLD SA TAS VIC WA inner outer remote veryremote 	/// 
		   cheque change if type==`x', or

predict prob_`x' if e(sample)
replace prob_l=prob_`x' if e(sample)
drop prob_`x'

}

**************************************************

*balanced panel weights

gen prob_panel=.

foreach x of num 1/4 {

logit panel female age29 age3039 age5059 age6069 age70 agemiss ACT NT QLD SA TAS VIC WA inner outer remote veryremote 	/// 
		   cheque change if type==`x', or

predict prob_`x' if e(sample)
replace prob_panel=prob_`x' if e(sample)
drop prob_`x'

}

**************************************************

gen weight_l=w1_weight*(1/prob_l) if w1w9==1
gen weight_panel=w1_weight*(1/prob_panel) if panel==1

keep if w9response==1
keep listeeid weight_l weight_panel

save "`l_weights'"

restore

merge 1:1 listeeid using "`l_weights'"
drop _merge

label var weight_l 			"Longitudinal Weights"
label var weight_panel 		"Balanced Panel Weights"

replace weight_l=-1 if weight_l==.
replace weight_panel=-1 if weight_panel==.

**************************************************


