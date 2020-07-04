
**********************************************************

*Purpose: extract information from previous waves and AMPCo database for those answered "No Change" and status quo variables

********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

*log using "${dlog}\crosswave_ampco.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

/*Comments add by Wenda: remove this part if there is no mis-matches of MABEL ids and listeeids
*the purpose of this do file is bring up all the status quo variables doctors reported in the past surveys to the current one,
* filling up all the missing values

**** i may be able to remove this bit later
*gen username=id
merge m:m username using "L:\Data\Responses\Wave 7\w7responserate final\w7finalresponse.dta", keepusing(listeeid) force
drop if _merge==2


*check all respondents have a listeeid
 list listeeid id if listeeid==.
*replace listeeid=900666 if id==13140
*replace listeeid=112065 if id==81086

drop _merge*/
************* 

preserve

tempfile w8 w7 w6 w5 w4 w3 w2 w1

use "L:\Data\Data Clean\Wave8\dtah\Internal release\w8_internal_Nov2016.dta", clear
*ren employmentdetailemploymenttype empdetailemptype
*ren employmentdetailpractisingstatus empdetailpacstatus
drop if sdtype==-1
drop *_c *_multi*
replace picmdo_country="" if picmdo_country=="-2"|picmdo_country=="-4"
replace picmdo_country=upper(picmdo_country)
ren picmdo_country picmdo_text
renvars _all, pref(w8_)
ren w8_listeeid listeeid
save "`w8'"


use "L:\Data\Data Clean\Wave8\dtah\Internal release\w7_internal_Nov2016.dta", clear
ren employmentdetailemploymenttype empdetailemptype
ren employmentdetailpractisingstatus empdetailpacstatus
drop if sdtype==-1
drop *_c *_multi*
replace picmdo_country="" if picmdo_country=="-2"|picmdo_country=="-4"
replace picmdo_country=upper(picmdo_country)
ren picmdo_country picmdo_text
renvars _all, pref(w7_)
ren w7_listeeid listeeid
save "`w7'"


use "L:\Data\Data Clean\Wave8\dtah\Internal release\w6_internal_Nov2016.dta", clear
drop if sdtype==-1
drop *_c *_multi*
replace picmdo_country="" if picmdo_country=="-2"|picmdo_country=="-4"
replace picmdo_country=upper(picmdo_country)
ren picmdo_country picmdo_text
renvars _all, pref(w6_)
ren w6_listeeid listeeid
save "`w6'"

use "L:\Data\Data Clean\Wave8\dtah\Internal release\w5_internal_Nov2016.dta", clear
drop if sdtype==-1
drop *_c *_multi*
replace picmdo_country="" if picmdo_country=="-2"|picmdo_country=="-4"
replace picmdo_country=upper(picmdo_country)
ren picmdo_country picmdo_text
renvars _all, pref(w5_)
ren w5_listeeid listeeid
save "`w5'"

use "L:\Data\Data Clean\Wave8\dtah\Internal release\w4_internal_Nov2016.dta", clear
drop if sdtype==-1
keep listeeid picmdo_text picmdoi picmda picmdo picmd fracgp facrrm fwshpoth piyrbi pigeni picamc
renvars picmd picmda picmdo picmdoi fracgp facrrm fwshpoth picmdo_text piyrbi pigeni picamc, pref(w4_)
*ren w4_listeeid listeeid
save "`w4'"

use "L:\Data\Data Clean\Wave8\dtah\Internal release\w3_internal_Nov2016.dta", clear
drop if sdtype==-1
keep listeeid picmdo_country picmdoi picmda picmdo picmd fracgp facrrm fwshpoth piyrbi pigeni picamc
replace picmdo_country="" if picmdo_country=="-2"|picmdo_country=="-4"
replace picmdo_country=upper(picmdo_country)
ren picmdo_country picmdo_text
renvars picmd picmda picmdo picmdoi fracgp facrrm fwshpoth picmdo_text piyrbi pigeni picamc, pref(w3_)
save "`w3'", replace

use "L:\Data\Data Clean\Wave8\dtah\Internal release\w2_internal_Nov2016.dta", clear
drop if sdtype==-1
keep listeeid picmdo_country picmdoi picmda picmdo picmd fracgp facrrm fwshpoth piyrbi pigeni picamc
replace picmdo_country="" if picmdo_country=="-2"|picmdo_country=="-4"
replace picmdo_country=upper(picmdo_country)
ren picmdo_country picmdo_text
renvars picmd picmda picmdo picmdoi fracgp facrrm fwshpoth picmdo_text piyrbi pigeni picamc, pref(w2_)
save "`w2'", replace

use "L:\Data\Data Clean\Wave8\dtah\Internal release\w1_internal_Nov2016.dta", clear
drop if sdtype==-1
keep listeeid picmdo_text picmdoi picmda picmdo picmd fracgp facrrm fwshpoth piyrbi pigeni picamc
replace picmdo_text="" if picmdo_text=="-2"|picmdo_text=="-4"
replace picmdo_text=upper(picmdo_text)
renvars picmd picmda picmdo picmdoi fracgp facrrm fwshpoth picmdo_text piyrbi pigeni picamc, pref(w1_)
save "`w1'", replace

restore

merge 1:1 listeeid using "`w8'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w7'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w6'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w5'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w4'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w3'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w2'"
drop if _merge==2
drop _merge

merge 1:1 listeeid using "`w1'"
drop if _merge==2
drop _merge

***************************************************



*questions which are not asked of continuing doctors

*pwahnc - have your working arrangements changed since you last completed mabel
*if not changed can impute values from Wave 6 for pwpm and pwmhn
*was not imputing values for pwwyr but tt added this for w7 - 7/5/2015
*drop miss1

egen miss1=anycount(pwpm pwmhp) if sdtype==1, v(-2)

destring w8_pwmhp, replace

foreach x of var pwpm pwmhp pwmhpasgc pwmhprrma{
replace `x'=w8_`x' if pwahnc==0 & sdtype==1 & `x'==-2 & miss1==2 & w8_`x'>=0 & w8_`x'!=.
}

replace pwmhn=w8_pwmhn if miss1==2 & pwmhn=="" & w8_pwmhn!="" & w8_pwmhn!="-1" & w8_pwmhn!="-2" & w8_pwmhn!="-3" & w8_pwmhn!="-4"&sdtype==1

replace pwwyr=(w8_pwwyr+1) if pwwyr==-2 &sdtype==1 &pwahnc==0 & w8_pwwyr>-1  //added by TT 7/5/2015
replace pwwyr=(w7_pwwyr+2) if pwwyr==-2 &sdtype==1 & pwahnc==0 & w7_pwwyr>-1 & w8_pwwyr<0  //added by TT 7/5/2015
 



**************************************************

/*This is incorrect
*glmth/glyr

*replace glmth=6 if glyr==.5
*replace glyr=0 if glyr==.5

*replace glmth=6 if glyr==2.5
*replace glyr=2 if glyr==2.5

replace w6_glmth=int(w6_glmth)
replace glmth=w6_glmth if glmth==-2&glpcw==w6_glpcw&(w6_glmth==-4|(w6_glmth>=0&w6_glmth!=.))
replace glyr=w6_glyr+1 if glyr==-2&glpcw==w6_glpcw&w6_glyr>=0&w6_glyr!=. */

**************************************************

*glyrrs/glrtw/glrst/glrna

replace glyrrs=w8_glyrrs if (glyrrs==-1|glyrrs==-2)&w8_glyrrs>=0&w8_glyrrs!=.
replace glrtw=w8_glrtw if glrtw==""&w8_glrtw!=""&w8_glrtw!="-2"&w8_glrtw!="-3"
replace glrst=w8_glrst if glrst==""&w8_glrst!=""&w8_glrst!="-2"&w8_glrst!="-3"
replace glrst=upper(glrst)
replace glrna=w8_glrna if continue=="Continue"&(w8_glrna==1|w8_glrna==0)&glrna==-2
replace glrtwasgc=w8_glrtwasgc if (glrtwasgc<0|glrtwasgc==.)&w8_glrtwasgc!=.&w8_glrtwasgc!=-2&w8_glrtwasgc!=-3
replace glrtwrrma=w8_glrtwrrma if (glrtwrrma<0|glrtwrrma==.)&w8_glrtwrrma!=.&w8_glrtwrrma!=-2&w8_glrtwrrma!=-3

**************************************************

*picmdo/picmda/picmdo_text/picamc from previous waves

replace picmd=w8_picmd if (picmd<0|picmd==.)&w8_picmd>=0&w8_picmd!=.
replace picmda=w8_picmda if picmda==-2&(w8_picmda==0|w8_picmda==1)
replace picmdo=w8_picmdo if picmdo==-2&(w8_picmdo==0|w8_picmdo==1)
replace picmdo_text=upper(w8_picmdo_text) if picmdo_text=="-3"& w8_picmdo_text!="-3"

replace picmd=w7_picmd if (picmd<0|picmd==.)&w7_picmd>=0&w7_picmd!=.
replace picmda=w7_picmda if picmda==-2&(w7_picmda==0|w7_picmda==1)
replace picmdo=w7_picmdo if picmdo==-2&(w7_picmdo==0|w7_picmdo==1)
replace picmdo_text=upper(w7_picmdo_text) if picmdo_text=="-3"& w7_picmdo_text!="-3"

replace picmd=w6_picmd if (picmd<0|picmd==.)&w6_picmd>=0&w6_picmd!=.
replace picmda=w6_picmda if picmda==-2&(w6_picmda==0|w6_picmda==1)
replace picmdo=w6_picmdo if picmdo==-2&(w6_picmdo==0|w6_picmdo==1)
replace picmdo_text=upper(w6_picmdo_text) if picmdo_text=="-3"& w6_picmdo_text!="-3"

replace picmd=w5_picmd if (picmd<0|picmd==.)&w5_picmd>=0&w5_picmd!=.
replace picmda=w5_picmda if picmda==-2&(w5_picmda==0|w5_picmda==1)
replace picmdo=w5_picmdo if picmdo==-2&(w5_picmdo==0|w5_picmdo==1)
replace picmdo_text=upper(w5_picmdo_text) if picmdo_text==""& w5_picmdo_text!=""&w5_picmdo_text!="-2"&w5_picmdo_text!="-3"&w5_picmdo_text!="-4"&w5_picmdo_text!="-5"

replace picmd=w4_picmd if (picmd<0|picmd==.)&w4_picmd>=0&w4_picmd!=.
replace picmda=w4_picmda if picmda==-2&(w4_picmda==0|w4_picmda==1)
replace picmdo=w4_picmdo if picmdo==-2&(w4_picmdo==0|w4_picmdo==1)
replace picmdo_text=upper(w4_picmdo_text) if picmdo_text==""&w4_picmdo_text!="-4"

replace picmd=w3_picmd if (picmd<0|picmd==.)&w3_picmd>=0&w3_picmd!=.
replace picmda=w3_picmda if (picmda==-2|picmda==.)&(w3_picmda==0|w3_picmda==1)
replace picmdo=w3_picmdo if (picmdo==-2|picmdo==.)&(w3_picmdo==0|w3_picmdo==1)
replace picmdo_text=upper(w3_picmdo_text) if picmdo_text==""&w3_picmdo_text!=""&w3_picmdo_text!="-5"&w3_picmdo_text!="-4"

replace picmd=w2_picmd if (picmd<0|picmd==.)&w2_picmd>=0&w2_picmd!=.
replace picmda=w2_picmda if (picmda==-2|picmda==.)&(w2_picmda==0|w2_picmda==1)
replace picmdo=w2_picmdo if (picmdo==-2|picmdo==.)&(w2_picmdo==0|w2_picmdo==1)
replace picmdo_text=upper(w2_picmdo_text) if picmdo_text==""&w2_picmdo_text!=""&w2_picmdo_text!="-5"

replace picmd=w1_picmd if (picmd<0|picmd==.)&w1_picmd>=0&w1_picmd!=.
replace picmda=w1_picmda if (picmda==-2|picmda==.)&(w1_picmda==0|w1_picmda==1)
replace picmdo=w1_picmdo if (picmdo==-2|picmdo==.)&(w1_picmdo==0|w1_picmdo==1)

*check odd values for picmd and replace with values from AMPCO
tab picmd

***************
***STOP HERE***
***************

merge 1:1 listeeid using "L:\Data\Samples\Wave 8\Alldocs2015\Alldocs2015.dta", keepusing(doctoryeargraduatedmedical personage personsex)
drop if _merge==2
rename doctoryeargraduatedmedica yeargrad
tostring picmd, replace
replace picmd = yeargrad if picmd=="-4" | picmd=="-2" | picmd==""  //yeargrad is from all docs file
destring picmd, replace
replace picmd = year_grad_1 if picmd==-4 | picmd==-2 | picmd==.  //year_grad_1 is from qualification_all,dta


replace picmdo=0 if picmda==1 & picmdo==-2

replace picmdo_text="-4" if w1_picmdo_text=="AFRICA"&picmdo_text==""

replace picmdo_text="SRI LANKA" if w1_picmdo_text=="COLOMBO - SRI LANKA"&picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if w1_picmdo_text=="ENGLAND"&picmdo_text==""
replace picmdo_text="INDIA" if w1_picmdo_text=="INDIA"&picmdo_text==""
replace picmdo_text="IRAN" if w1_picmdo_text=="IRAN"&picmdo_text==""
replace picmdo_text="IRELAND" if w1_picmdo_text=="IRELAND"&picmdo_text==""
replace picmdo_text="NEW ZEALAND" if w1_picmdo_text=="NEW ZEALAND"&picmdo_text==""
replace picmdo_text="NEW ZEALAND" if w1_picmdo_text=="NZ"&picmdo_text==""
replace picmdo_text="-4" if w1_picmdo_text=="OVERSEAS"&picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if w1_picmdo_text=="SCOTLAND"&picmdo_text==""
replace picmdo_text="SOUTH AFRICA" if w1_picmdo_text=="SOUTH AFRICA"&picmdo_text==""
replace picmdo_text="SRI LANKA" if w1_picmdo_text=="SRI LANKA"&picmdo_text==""
replace picmdo_text="SYRIA" if w1_picmdo_text=="SYRIA"&picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if w1_picmdo_text=="UK"&picmdo_text==""

replace picmdo_text="UNITED KINGDOM" if picmdo_text=="UK"
replace picmdo_text="USA" if picmdo_text=="UNITED STATES"
replace picmdo_text="NEW ZEALAND" if picmdo_text=="N.Z."
replace picmdo_text="RUSSIA" if picmdo_text=="RUSSIAN FEDERATION"|picmdo_text=="USSR"
replace picmdo_text="PAPUA NEW GUINEA" if picmdo_text=="PNG"

replace picmd=-2 if picmd==.
replace picmda=-2 if picmda==.
replace picmdo=-2 if picmdo==.

replace picmdo_text="-3" if picmdo_text==""&picmda==1

list id response pims picmdo picmdo_text school_1 qual_1 if picmdo==1 & picmdo_text=="" & school_1 !=""

replace picmdo_text="SOUTH AFRICA" if strmatch(school_1, "*Johannesburg*") & picmdo_text==""
replace picmdo_text="SOUTH AFRICA" if strmatch(school_1, "*Pretoria*") & picmdo_text==""
replace picmdo_text="SOUTH AFRICA" if strmatch(school_1, "*Bloemfontein*") & picmdo_text==""
replace picmdo_text="SOUTH AFRICA" if strmatch(school_1, "*Natal*") & picmdo_text==""
replace picmdo_text="NEW ZEALAND" if strmatch(school_1, "*Dunedin*") & picmdo_text==""
replace picmdo_text="NEW ZEALAND" if strmatch(school_1, "*Auckland*") & picmdo_text==""
replace picmdo_text="NEW ZEALAND" if strmatch(school_1, "*Wellington*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*London*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Manchester*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Liverpool*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Newcastle-upon-Tyne*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Sheffield*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Leeds*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Glasgow*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Aberdeen*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Southampton*") & picmdo_text==""
replace picmdo_text="UNITED KINGDOM" if strmatch(school_1, "*Leicester*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Ranchi*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Hyderabad*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Pradesh*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Madras*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Punjab*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Pondicherry*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Poona*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Kerala*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Kerela*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Mumbai*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Bangalore*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Manipal*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Calcutta*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Nagpur*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Farad*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Saurashtra*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Mysore*") & picmdo_text==""
replace picmdo_text="INDIA" if strmatch(school_1, "*Gandhi*") & picmdo_text==""
replace picmdo_text="MYANMAR" if strmatch(school_1, "*Myanmar*") & picmdo_text==""
replace picmdo_text="MYANMAR" if strmatch(picmdo_text, "*BURMA*")
replace picmdo_text="MYANMAR" if strmatch(school_1, "*Mandalay*") & picmdo_text==""
replace picmdo_text="MYANMAR" if strmatch(school_1, "*Institute of Medicine II*") & picmdo_text==""
replace picmdo_text="IRELAND" if strmatch(school_1, "*Dublin*") & picmdo_text==""
replace picmdo_text="BANGLADESH" if strmatch(school_1, "*Dhaka*") & picmdo_text==""
replace picmdo_text="PAKISTAN" if strmatch(school_1, "*Baqai*") & picmdo_text==""
replace picmdo_text="PAKISTAN" if strmatch(school_1, "*Karachi*") & picmdo_text==""
replace picmdo_text="FIJI" if strmatch(school_1, "*Fiji*") & picmdo_text==""
replace picmdo_text="NETHERLANDS" if strmatch(school_1, "*Leiden*") & picmdo_text==""
replace picmdo_text="NETHERLANDS" if strmatch(school_1, "*Amsterdam*") & picmdo_text==""
replace picmdo_text="NETHERLANDS" if strmatch(school_1, "*Groningen*") & picmdo_text==""
replace picmdo_text="GERMANY" if strmatch(school_1, "*Gottingen*") & picmdo_text==""
replace picmdo_text="GERMANY" if strmatch(school_1, "*Duesseldorf*") & picmdo_text==""
replace picmdo_text="GERMANY" if strmatch(school_1, "*Dusseldorf*") & picmdo_text==""
replace picmdo_text="GERMANY" if strmatch(school_1, "*Witten-Herdecke*") & picmdo_text==""
replace picmdo_text="GERMANY" if strmatch(school_1, "*Munich*") & picmdo_text==""
replace picmdo_text="GERMANY" if strmatch(school_1, "*Hannover*") & picmdo_text==""
replace picmdo_text="CHINA" if strmatch(school_1, "*Shanghai*") & picmdo_text==""
replace picmdo_text="CHINA" if strmatch(school_1, "*Beijing*") & picmdo_text==""
replace picmdo_text="CHINA" if strmatch(school_1, "*Peking*") & picmdo_text==""
replace picmdo_text="PHILIPPINES" if strmatch(school_1, "*Philippines*") & picmdo_text==""
replace picmdo_text="PHILIPPINES" if strmatch(school_1, "*Iloilo*") & picmdo_text==""
replace picmdo_text="PHILIPPINES" if strmatch(school_1, "*Manila*") & picmdo_text==""
replace picmdo_text="SRI LANKA" if strmatch(school_1, "*Colombo*") & picmdo_text==""
replace picmdo_text="SRI LANKA" if strmatch(school_1, "*Peradeniya*") & picmdo_text==""
replace picmdo_text="SRI LANKA" if strmatch(school_1, "*Jaffna*") & picmdo_text==""
replace picmdo_text="NIGERIA" if strmatch(school_1, "*Port Harcourt*") & picmdo_text==""
replace picmdo_text="BOSNIA & HERZEGOVINA" if strmatch(school_1, "*Sarajevo*") & picmdo_text==""
replace picmdo_text="BENIN" if strmatch(school_1, "*Benin*") & picmdo_text==""
replace picmdo_text="SINGAPORE" if strmatch(school_1, "*Singapore*") & picmdo_text==""
replace picmdo_text="USA" if strmatch(school_1, "*New Jersey*") & picmdo_text==""
replace picmdo_text="USA" if strmatch(school_1, "*Chicago*") & picmdo_text==""
replace picmdo_text="SWEDEN" if strmatch(school_1, "*Lund*") & picmdo_text==""
replace picmdo_text="IRAQ" if strmatch(school_1, "*Baghdad*") & picmdo_text==""
replace picmdo_text="ZIMBABWE" if strmatch(picmdo_text, "*RHODESIA*")
replace picmdo_text="ZIMBABWE" if strmatch(school_1, "*Rhodesia*") & picmdo_text==""
replace picmdo_text="GUATEMALA" if strmatch(school_1, "*Guatemala*") & picmdo_text==""
replace picmdo_text="THAILAND" if strmatch(school_1, "*Bangkok*") & picmdo_text==""
replace picmdo_text="BULGARIA" if strmatch(school_1, "*Sofia*") & picmdo_text==""
replace picmdo_text="POLAND" if strmatch(school_1, "*Krakow*") & picmdo_text==""



drop qual_1 - group_7  N_master N_phd N_dipcert N_fellow  school_1 - school_8 year_grad_1 - year_grad_8 

replace picamc=w7_picamc if (picamc<0|picamc==.)&w7_picamc!=.&w7_picamc>=0
replace picamc=w6_picamc if (picamc<0|picamc==.)&w6_picamc!=.&w6_picamc>=0
replace picamc=w4_picamc if (picamc<0|picamc==.)&w4_picamc!=.&w4_picamc>=0
replace picamc=w3_picamc if (picamc<0|picamc==.)&w3_picamc!=.&w3_picamc>=0
replace picamc=w2_picamc if (picamc<0|picamc==.)&w2_picamc!=.&w2_picamc>=0
replace picamc=w1_picamc if (picamc<0|picamc==.)&w1_picamc!=.&w1_picamc>=0

replace picamc=2 if (picamc<0|picamc==.)&picmda==1

replace pims=w7_pims if (pims<0|pims==.)&w7_pims!=.&w7_pims>=0

**********************************************


*pims
replace pims=w7_pims if (pims<0)&w7_pims>=0&w7_pims!=.  //tt added 7/5/2015
replace pims=w6_pims if (pims<=0)&w6_pims>=0&w6_pims!=.


*pindyr/pindmt - amended for wave 7

*replace pindyr=w6_pindyr if pindyr==-2&w6_pindyr>=0&w6_pindyr!=.
*replace pindmt=w6_pindmt if pindmt==-2&w6_pindmt>=0&w6_pindmt!=.

*replace pindyr=. if continue==1  - i don't think this is necessary
*replace pindmt=. if continue==1

rename pindyr w8pindyr
rename pindmt w8pindmt

gen wlwhpy1=wlwhpy
gen wlmlpy1=wlmlpy
gen wlsdpy1=wlsdpy
gen wlotpy1=wlotpy
replace wlwhpy1=0 if wlwhpy <= 0
replace wlmlpy1=0 if wlmlpy <= 0
replace wlsdpy1=0 if wlsdpy <= 0
replace wlotpy1=0 if wlotpy <= 0
*drop w8alleave
gen w8alleave=.
replace w8alleave = (wlwhpy1+wlmlpy1+(wlsdpy1/5)+(wlotpy1/5))/4.5
replace w8alleave=round(w8alleave, 1)
list id w8alleave wlwhpy wlmlpy wlsdpy wlotpy wlwhpy1 wlmlpy1 wlsdpy1 wlotpy1 in 1/50

drop wlwhpy1 wlmlpy1 wlsdpy1 wlotpy1
ren wlwhpy w8wlwhpy
ren wlmlpy w8wlmlpy
ren wlsdpy w8wlsdpy
ren wlotpy w8wlotpy

*local w8leave wlwhpy1 wlmlpy1 wlsdpy1 wlotpy1
*replace `w8leave'=. if `w8leave' <= 0
*gen w8alleave = .
*replace w8alleave = (wlwhpy1+wlmlpy1+(wlsdpy1/5)+(wlotpy1/5))/4.5
*replace w8alleave=round(w8alleave, 1)
*list id w8alleave wlwhpy wlmlpy wlsdpy wlotpy wlwhpy1 wlmlpy1 wlsdpy1 wlotpy1
*local w8leave wlwhpy wlmlpy wlsdpy wlotpy

*calculate pindmt and pindyr for those who responded to waves 8 and 7 (and so can retrieve pind data from w7)
merge 1:1 listeeid using "L:\Data\Data Clean\Wave7\dtah\Internal release\w7_internal_Feb2016.dta", keepusing(pindyr pindmt wlwhpy wlmlpy wlsdpy wlotpy /*NL added*/ /*w7alleave*/) gen(merge7)

replace wlwhpy=0 if wlwhpy <= 0
replace wlmlpy=0 if wlmlpy <= 0
replace wlsdpy=0 if wlsdpy <= 0
replace wlotpy=0 if wlotpy <= 0
gen w7alleave=.
replace w7alleave = (wlwhpy+wlmlpy+(wlsdpy/5)+(wlotpy/5))/4.5
replace w7alleave=round(w7alleave, 1)

rename pindyr w7pindyr
rename pindmt w7pindmt
drop if merge7==2

replace w8pindyr=w7pindyr if continue=="Continue" & merge7 ==3
replace w8pindmt=w7pindmt if (w8alleave==. | w8alleave<0) & continue=="Continue" & merge7 ==3
replace w8pindmt=w8alleave if (w7pindmt==. | w7pindmt<0) & (w8alleave>=0 & w8alleave !=.) & continue=="Continue" & merge7 ==3
replace w8pindmt=w7pindmt+w8alleave if continue=="Continue"& w7pindmt>=0 & w7pindmt!=. & w8alleave>=0 & w8alleave!=. & merge7 ==3

drop wlwhpy wlmlpy wlsdpy wlotpy

*calculate pindmt and pindyr for those who responded to waves 8 and 6, but not wave 7 (and so must retrieve pind data from w6)
merge 1:1 listeeid using "L:\Data\Data Clean\Wave7\dtah\Internal release\w6_internal_Feb2016.dta", keepusing(pindyr pindmt /*wlwhpy wlmlpy wlsdpy wlotpy NL added*/ w6alleave) gen(merge6)

/*
replace wlwhpy=0 if wlwhpy <= 0
replace wlmlpy=0 if wlmlpy <= 0
replace wlsdpy=0 if wlsdpy <= 0
replace wlotpy=0 if wlotpy <= 0
gen w6alleave=.
replace w6alleave = (wlwhpy+wlmlpy+(wlsdpy/5)+(wlotpy/5))/4.5
replace w6alleave=round(w6alleave, 1)
*/
rename pindyr w6pindyr
rename pindmt w6pindmt
drop if merge6==2

replace w8pindyr=w6pindyr if continue=="Continue" & merge6==3 & merge7==1
replace w8pindmt=w6pindmt if (w8alleave==. | w8alleave<0) & continue=="Continue" & merge6 ==3 & merge7==1
replace w8pindmt=w8alleave if (w6pindmt==. | w6pindmt<0) & (w8alleave>=0 & w8alleave !=.) & continue=="Continue" & merge6 ==3 & merge7==1
replace w8pindmt=w6pindmt+w8alleave if continue=="Continue"& w6pindmt>=0 & w6pindmt!=. & w8alleave>=0 & w8alleave!=. & merge6==3 & merge7==1

*drop wlwhpy wlmlpy wlsdpy wlotpy

*calculate pindmt and pindyr for those who responded to waves 8 and 5 but not 6 or 7 (and so must retrieve pind data from w5)
merge 1:1 listeeid using "L:\Data\Data Clean\Wave7\dtah\Internal release\w5_internal_Feb2016.dta", keepusing(pindyr pindmt w5alleave) gen(merge5)

rename pindyr w5pindyr
rename pindmt w5pindmt
drop if merge5==2

replace w8pindyr=w5pindyr if continue=="Continue" & merge5 ==3 & merge6==1 & merge7==1
replace w8pindmt=w5pindmt if (w8alleave==. | w8alleave<0) & continue=="Continue" & merge5 ==3 & merge6==1 & merge7==1
replace w8pindmt=w8alleave if (w5pindmt==. | w5pindmt<0) & (w8alleave>=0 & w8alleave !=.) & continue=="Continue" & merge5 ==3 & merge6==1 & merge7==1 
replace w8pindmt=w5pindmt+w8alleave if continue=="Continue"& w5pindmt>=0 & w5pindmt!=. & w8alleave>=0 & w8alleave!=. & merge5 ==3 & merge6==1 & merge7==1

*calculate pindmt and pindyr for those who responded to waves 8 and 4, but not 5, 6 or 7 (so need to get pind date from wave4)
merge 1:1 listeeid using "L:\Data\Data Clean\Wave7\dtah\Internal release\w4_internal_Feb2016.dta", keepusing(pindyr pindmt w4alleave) gen(merge4)

rename pindyr w4pindyr
rename pindmt w4pindmt
drop if merge4==2

replace w8pindyr=w4pindyr if continue=="Continue" & merge4==3 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w4pindmt if (w8alleave==. | w8alleave<0) & continue=="Continue" & merge4 ==3 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w8alleave if (w4pindmt==. | w4pindmt<0) & (w8alleave>=0 & w8alleave !=.) & continue=="Continue" & merge4==3 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w4pindmt+w8alleave if continue=="Continue"& w4pindmt>=0 & w4pindmt!=. & w8alleave>=0 & w8alleave!=. & merge4==3 & merge5==1 & merge6==1 & merge7==1

*calculate pindmt and pindyr for continuing docs who responded to wave 8 and 3 but not waves 4, 5, 6 or 7 (so need to get data from wave 3) 
merge 1:1 listeeid using "L:\Data\Data Clean\Wave7\dtah\Internal release\w3_internal_Feb2016.dta", keepusing(pindyr pindmt w3alleave) gen(merge3)

rename pindyr w3pindyr
rename pindmt w3pindmt
drop if merge3==2

replace w8pindyr=w3pindyr if continue=="Continue" & merge3==3 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w3pindmt if (w8alleave==. | w8alleave<0) & continue=="Continue" & merge3==3 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w8alleave if (w3pindmt==. | w3pindmt<0) & (w8alleave>=0 & w8alleave !=.) & continue=="Continue" & merge3==3 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w3pindmt+w8alleave if continue=="Continue"& w3pindmt>=0 & w3pindmt!=. & w8alleave>=0 & w8alleave!=. & merge3==3 & merge4==1 & merge5==1 & merge6==1 & merge7==1

*calculate pindmt and pindyr for continuing docs who responded to wave 8 and 2 but not waves 3, 4, 5, 6 or 7 (so need to get data from wave 2) 
merge 1:1 listeeid using "L:\Data\Data Clean\Wave7\dtah\Internal release\w2_internal_Feb2016.dta", keepusing(pindyr pindmt w2alleave) gen(merge2)

rename pindyr w2pindyr
rename pindmt w2pindmt
drop if merge2==2

replace w8pindyr=w2pindyr if continue=="Continue" & merge2==3 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w2pindmt if (w8alleave==. | w8alleave<0) & continue=="Continue" & merge2==3 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w8alleave if (w2pindmt==. | w2pindmt<0) & (w8alleave>=0 & w8alleave !=.) & continue=="Continue" & merge2==3 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w2pindmt+w8alleave if continue=="Continue"& w2pindmt>=0 & w2pindmt!=. & w8alleave>=0 & w8alleave!=. & merge2==3 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1

*calculate pindmt and pindyr for those who responded to wave 8 but not 2, 3, 4, 5, 6 or 7 (so get data from wave 1)
merge 1:1 listeeid using "L:\Data\Data Clean\Wave7\dtah\Internal release\w1_internal_Feb2016.dta", keepusing(pindyr pindmt) gen(merge1)
rename pindyr w1pindyr
rename pindmt w1pindmt
drop if merge1==2

replace w8pindyr=w1pindyr if continue=="Continue" & merge1==3 & merge2==1 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w1pindmt if (w8alleave==. | w8alleave<0) & continue=="Continue" & merge1==3 & merge2==1 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w8alleave if (w1pindmt==. | w1pindmt<0) & (w8alleave>=0 & w8alleave !=.) & continue=="Continue" & merge1==3 & merge2==1 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1
replace w8pindmt=w1pindmt+w8alleave if continue=="Continue"& w1pindmt>=0 & w1pindmt!=. & w8alleave>=0 & w8alleave!=. & merge1==3 & merge2==1 & merge3==1 & merge4==1 & merge5==1 & merge6==1 & merge7==1

replace w8pindyr=w8pindyr+1 if w8pindmt>=12 & w8pindmt!=. & continue=="Continue"
replace w8pindmt=w8pindmt-12 if w8pindmt>=12 & w8pindmt!=. & continue=="Continue"

rename w8pindyr pindyr
rename w8pindmt pindmt

drop merge* w*alleave w*pindyr w*pindmt
**********************************************

*FRACGP/FACRRM/FWSHPOTH

gen fracgp=0
gen facrrm=0
gen fwshpoth=0

replace fracgp=1 if regexm(piqadf, "FRACGP")
replace facrrm=1 if regexm(piqadf, "FACRRM")
*replace fwshpoth=1 if piqadf!=""&piqadf!="FRACGP"&piqadf!="FACRRM"
gen temp1=2 if fracgp==1 & facrrm==1 
replace temp1=1 if (fracgp==1 | facrrm==1) & temp1==.
replace temp1=0 if temp1==.
replace piqanf=0 if piqanf<1|piqanf==.
replace fwshpoth=piqanf-temp1
replace fwshpoth = 1 if fwshpoth > 1 & fwshpoth != .

*replace fwshpoth=1 if piqadf!=""


foreach x of var fracgp facrrm fwshpoth {

replace `x'=w7_`x' if `x'==0&w7_`x'==1
replace `x'=w6_`x' if `x'==0&w6_`x'==1
replace `x'=w5_`x' if `x'==0&w5_`x'==1
replace `x'=w4_`x' if `x'==0&w4_`x'==1
replace `x'=w3_`x' if `x'==0&w3_`x'==1
replace `x'=w2_`x' if `x'==0&w2_`x'==1
replace `x'=w1_`x' if `x'==0&w1_`x'==1

}

********************************************

*SEARCH FOR OTHER VARIABLES WITH COMMENT "NO CHANGE"
/*
ren pisapgp_nc1 pisapgp_nc1w8 
ren pisapgp_temp pisapgp_tempw8
ren pisapgp_nc2 pisapgp_nc2w8 
ren pisapgp_temp pisapgpw8
drop pisapgp_nc1w8 pisapgp_tempw8  pisapgp_nc2w8 pisapgpw8
drop pisapgp_temp pisapgp_temp
drop pisapgp_nc1 pisapgp_nc1w8 pisapgp_temp 
drop pisapgp_nc2
drop pisapgp_temp
capture drop pisapgp_nc1 pisapgp_temp pisapgp_nc2 pisapgp_temp pisapgp_nc1
drop pisapgp*
*/

preserve
drop *_text *_comment *_multi* w7_* /*altid*/ dtbatch dtserial dtimage continue source response wlocoth pwmhn gltww gltwl glrtw glrst fcprt fcprs /// 
 piemail dummy furcom date listeeid /*gltwwML*/ piqadf pwmht pindyr pindmt pisapgp*
desc _all, varlist
restore

foreach x in `r(varlist)' {

	capture confirm var `x'_comment
	if !_rc {
		capture confirm var w7_`x'
		if !_rc {
		tostring `x'_comment, replace
		gen `x'_temp=upper(`x'_comment)
		gen `x'_nc1=strmatch(`x'_temp, "*NO CHANGE*")
		gen `x'_nc2=strmatch(`x'_temp, "*AS BEFORE*")
		gen `x'_nc3=strmatch(`x'_temp, "*LAST YEAR*")
		drop `x'_temp
	
		replace `x'=w7_`x' if (`x'_nc1==1|`x'_nc2==1|`x'_nc3==1)&`x'<0&`x'!=-1&w7_`x'>=0&w7_`x'!=.
		drop `x'_nc1 `x'_nc2 `x'_nc3
		}
		else {
		}
	}
	else {
	}

}


*******************************************

*Merge age/year of birth/gender from previous waves and AMPCo
*gen piyrb=piyrbi
replace piyrb=w7_piyrbi if (piyrb==-1|piyrb==-2|piyrb==.)&w7_piyrbi!=.&w7_piyrbi>0
replace piyrb=w6_piyrbi if (piyrb==-1|piyrb==-2|piyrb==.)&w6_piyrbi!=.&w6_piyrbi>0
replace piyrb=w4_piyrbi if (piyrb==-1|piyrb==-2|piyrb==.)&w4_piyrbi!=.&w4_piyrbi>0
replace piyrb=w3_piyrbi if (piyrb==-1|piyrb==-2|piyrb==.)&w3_piyrbi!=.&w3_piyrbi>0
replace piyrb=w2_piyrbi if (piyrb==-1|piyrb==-2|piyrb==.)&w2_piyrbi!=.&w2_piyrbi>0
replace piyrb=w1_piyrbi if (piyrb==-1|piyrb==-2|piyrb==.)&w1_piyrbi!=.&w1_piyrbi>0

replace piyrb=-2 if piyrb==.

replace pigen=w7_pigeni if (pigen==-1|pigen==-2|pigen==.)&w7_pigeni!=.&w7_pigeni>=0
replace pigen=w6_pigeni if (pigen==-1|pigen==-2|pigen==.)&w6_pigeni!=.&w6_pigeni>=0
replace pigen=w4_pigeni if (pigen==-1|pigen==-2|pigen==.)&w4_pigeni!=.&w4_pigeni>=0
replace pigen=w3_pigeni if (pigen==-1|pigen==-2|pigen==.)&w3_pigeni!=.&w3_pigeni>=0
replace pigen=w2_pigeni if (pigen==-1|pigen==-2|pigen==.)&w2_pigeni!=.&w2_pigeni>=0
replace pigen=w1_pigeni if (pigen==-1|pigen==-2|pigen==.)&w1_pigeni!=.&w1_pigeni>=0

replace pigen=-2 if pigen==.



*merge year of birth and gender information from AMPCo population database

tempfile ampco

preserve

use "L:\Data\Samples\Wave 8\Alldocs2015\Alldocs2015.dta", clear

drop dtsortplanno auspostcode dtlocality persontitle initials surname preambletonam /// 
	 addressline1 addressline2 addressline3 addressline4 honourlist salutation dtbarcode /// 
	type mlpcode year

*replace	postcode="4558" if listeeid==400496
*replace	personsex="M" if listeeid==400496
*replace	personage="53" if listeeid==400496
*replace	doctormedicaldiscipline="Surgery - Plastic & Reconst" if listeeid==400496

ren dtpostcode ampco_postcode1
ren postcode ampco_postcode2
ren personsex ampco_gender
ren personage piagei
ren doctormedicaldiscipline ampco_type

destring piagei, replace	
save "`ampco'"

restore

drop _merge
merge 1:1 listeeid using "`ampco'"
drop if _merge==2
drop _merge

replace pigen=0 if pigen==-2&ampco_gender=="M"
replace pigen=1 if pigen==-2&ampco_gender=="F"

*replace piyrb=real(regexs(1)) if piyrb==-2&ampco_yob!=""&regexm(ampco_yob, "^([0-9][0-9][0-9][0-9])")

replace piyrb = 2015-piagei if piyrb<0

*correct unreasonable numbers for year of birth
* none in w7

replace piagei=-2 if piagei==.
ren piyrb piyrbi
ren pigen pigeni

************************************************

preserve

*Merge the variables of year of graduate/medical school from Ampco qualification database

*Extract bachelor graduate year/school/overseas from AMPCo

use "L:\Data\Data Clean\Wave8\AMPCo doc qualification\ampco_qualification.dta", clear

ren qual_description qual
replace qual= trim(qual)

*replace year_grad=2001 if year_grad==20001
replace year_grad=. if year_grad==0
destring year_grad, replace


keep if regexm(qual, "(Bachelor)")
duplicates tag listeeid, gen(dup)
*drop if type=="Non-medical"

keep if regexm(qual, "Medicine")|regexm(qual, "Surgery")
drop if strmatch(qual,"*Bachelor of Arts Medicine*")
drop if strmatch(qual,"*Bachelor of Dental Surgery*")
drop if strmatch(qual,"*Bachelor of Science Medicine*")
drop if strmatch(qual,"*Bachelor of Science Surgery*")
drop if strmatch(qual,"*Bachelor of Medicine & Surgery Bachelor of the Art of Obstetrics*")


sort listeeid year_grad
tab qual

duplicates tag listeeid, gen(dup1)
drop if dup1==1&qual=="Bachelor of Medicine"
drop if dup1==1&year_grad==.
drop dup1

duplicates tag listeeid, gen(dup2)
duplicates drop listeeid year_grad location, force

sort listeeid year_grad
by listeeid: gen n=_n if dup2==1
by listeeid: drop if n==1&dup2==1
drop dup2

keep listeeid qual school location year_grad dup

tempfile ampco_qual

save "`ampco_qual'"

restore

merge 1:1 listeeid using "`ampco_qual'"
drop if _merge==2
drop _merge

replace location="AUSTRALIA" if location=="ACT"|location=="NSW"|location=="QLD"|location=="SA"|location=="TAS"|location=="VIC"|location=="WA"|location=="NT"
replace location="AUSTRALIA" if location=="SYDNEY"|location=="ADELAIDE"|location=="MELBOURNE"|location=="TASMANIA"
replace location="OVERSEAS" if location!=""&location!="AUSTRALIA"

replace picmda=1 if picmda==-2&location=="AUSTRALIA"
replace picmdo=1 if picmdo==-2&location=="OVERSEAS"
replace picmd=year_grad if picmd==-2&year_grad!=.

*rename medicalschool school

replace pims=2 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Adelaide"
replace pims=3 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Notre Dame (WA)"

replace pims=4 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Australian National University"
replace pims=5 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Notre Dame (Sydney NSW)"
replace pims=6 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Bond University"
replace pims=7 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of New South Wales Sydney"
replace pims=8 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Deakin University"
replace pims=9 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Queensland Brisbane"
replace pims=10 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Flinders University"
replace pims=11 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Sydney"
replace pims=12 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Griffith University"
replace pims=13 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Tasmania Hobart"
replace pims=14 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="James Cook University"
replace pims=15 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Western Australia Perth"&(dup==1|dup==2|dup==2)
replace pims=16 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Melbourne"&(dup==1|dup==2|dup==2)
replace pims=17 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Western Australia Perth"&dup==0
replace pims=18 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Melbourne"&dup==0
replace pims=19 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="University of Western Sydney Nepean"
replace pims=20 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Monash University"&(dup==1|dup==2|dup==2)
replace pims=21 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Wollongong University"
replace pims=22 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Monash University"&dup==0
replace pims=23 if (pims<0|pims==.)&location=="AUSTRALIA"&school=="Newcastle University"
replace pims=23 if (pims<0|pims==.)&location=="AUSTRALIA"&strmatch(school, "*University of New England*")

*2 stated universities which don't have medical schools ie Swinburne and Canberra Uni. I have left these as pims=-2.




replace pims=0 if (pims<0|pims==.)&picmdo==1
replace pims=-2 if pims==.

replace picamc=2 if (picamc<0|picamc==.)&picmda==1
replace picamc=-2 if picamc==.

drop qual school location year_grad dup ampco_gender  ampco_type

*******************************************************************

*asgc/rrma/state/type/cheque

preserve

*Merge location/doctor type/cheque send info from survey sample data

*Main survey sample

tempfile w8main w8pilot w8

use "L:\Data\Samples\Wave 8\W8final.dta", clear

renvars _all, lower
keep listeeid asgc_cat rrma chequew8 type dtstate
desc _all

ren asgc_cat asgc
ren chequew8 cheque
*ren typew8 type
ren dtstate state

gen version="Main"

save "`w8main'"

use "L:\Data\Samples\Wave 8 Pilot\W8Pfinal.dta", clear

drop chequew7 typeW7p  //remove if not necessary tt 10/6/2015
renvars _all, lower
keep listeeid asgc_cat rrma chequew7p type dtstate
desc _all
ren asgc_cat asgc
ren chequew7p cheque
ren dtstate state

gen version="Pilot"

save "`w8pilot'"

use "`w8main'", clear
append using "`w8pilot'"

sort listeeid version
duplicates tag listeeid, gen(dup)

by listeeid: drop if dup==1&version=="Main"
drop dup

renvars state asgc rrma cheque type version, pref(ampco_)
desc _all
save "`w8'"

restore

merge 1:1 listeeid using "`w8'"
drop if _merge==2
drop _merge ampco_version

renvars ampco_cheque ampco_type, pred(6)

replace type=sdtype if type==.
replace cheque=0 if cheque==.

foreach x of var ampco_state ampco_asgc ampco_rrma {

replace `x'=upper(`x')

renvars `x', pred(6)

}



replace asgc="1" if asgc=="MAJOR CITY"
replace asgc="2" if asgc=="INNER REGIONAL"
replace asgc="3" if asgc=="OUTER REGIONAL"
replace asgc="4" if asgc=="REMOTE"
replace asgc="5" if asgc=="VERY REMOTE"
replace asgc="-3" if asgc=="N/A"

replace rrma="1" if rrma=="CAPITAL"
replace rrma="2" if rrma=="OTHER METRO"
replace rrma="3" if rrma=="LARGE RURAL"
replace rrma="4" if rrma=="SMALL RURAL"
replace rrma="5" if rrma=="OTHER RURAL"
replace rrma="6" if rrma=="REMOTE CENTRE"
replace rrma="7" if rrma=="OTHER REMOTE"
replace rrma="-3" if rrma=="N/A"

destring asgc rrma, replace

replace asgc=gltwwasgc if asgc==.&gltwwasgc!=.&gltwwasgc!=-3
replace asgc=gltwlasgc if asgc==.&gltwlasgc!=.&gltwlasgc!=-3
*replace asgc=w5_gltwwasgc if asgc==.&gltwwasgc!=.&gltwwasgc!=-3 & w5_glpcw==glpcw

replace rrma=gltwwrrma if rrma==.&gltwwrrma!=.&gltwwrrma!=-3
replace rrma=gltwlrrma if rrma==.&gltwlrrma!=.&gltwlrrma!=-3

replace state=dtstate if state==""&dtstate!=""

list state ampco_postcode1 if state=="" & ampco_postcode1!=.
*replace state="ACT" if state==""&ampco_postcode1==2605

*replace missing asgc and rrma
list listeeid response asgc gltwwasgc gltwlasgc ampco_postcode1 if asgc==. & ampco_postcode1!=. & response!=""
*none for w7 (but use code below if there are in future)

/*replace asgc=1 if asgc==.& listeeid==209650
replace rrma=1 if rrma==.& listeeid==209650

replace asgc=2 if asgc==.& ampco_postcode1==2576
replace rrma=5 if rrma==.& ampco_postcode1==2576

replace asgc=1 if asgc==.& ampco_postcode1==3073
replace rrma=1 if rrma==.& ampco_postcode1==3073

replace asgc=1 if asgc==.& ampco_postcode1==4560
replace rrma=3 if rrma==.& ampco_postcode1==4560

replace asgc=1 if asgc==.& ampco_postcode1==3056
replace rrma=1 if rrma==.& ampco_postcode1==3056

replace asgc=1 if asgc==.& ampco_postcode1==3182
replace rrma=1 if rrma==.& ampco_postcode1==3182

replace asgc=1 if asgc==.& ampco_postcode1==4053
replace rrma=1 if rrma==.& ampco_postcode1==4053

replace asgc=1 if asgc==.& ampco_postcode1==5168
replace rrma=1 if rrma==.& ampco_postcode1==5168*/


foreach x of var glpcw glpcl {

replace state="ACT" if ((`x'>=2600&`x'<=2618)|(`x'>=2900&`x'<=2999))& state==""
replace state="NSW" if ((`x'>=2000&`x'<=2599)|(`x'>=2619&`x'<=2899)) & state==""
replace state="NT" if (`x'<1000&`x'>=800) & state==""
replace state="QLD" if (`x'>=4000&`x'<=4999) & state==""
replace state="SA" if (`x'>=5000&`x'<=5999) & state==""
replace state="TAS" if (`x'>=7000&`x'<=7999) & state==""
replace state="VIC" if (`x'>=3000&`x'<=3999) & state==""
replace state="WA" if (`x'>=6000&`x'<=6999) & state==""

}

drop dtstate ampco_postcode1 ampco_postcode2
drop w7_* w6_* w5_* w4_* w1_* w2_* w3_*

******************************************************

*change mabel ids for wave 7 where listeeid and mabel id mismatches - not necessary for wave 7

/*merge 1:1 listeeid using "${ddtah}\w1_6_listeeid_id_all.dta"

replace id = id_w1_6 if id!=id_w1_6 & id_w1_6!=. & id!=.

drop if _merge==2
drop _merge id_w1_5

*create cohort variable

gen cohort=.

merge 1:1 listeeid using "`w1'"
drop if _merge==2

replace cohort=2008 if _merge==3&cohort==.
drop w1_* _merge

merge 1:1 listeeid using "`w2'"
drop if _merge==2

replace cohort=2009 if _merge==3&cohort==.
drop w2_* _merge

merge 1:1 listeeid using "`w3'"
drop if _merge==2

replace cohort=2010 if _merge==3&cohort==.
drop w3_* _merge

merge 1:1 listeeid using "`w4'"
drop if _merge==2

replace cohort=2011 if _merge==3&cohort==.
drop w4_* _merge

merge 1:1 listeeid using "`w5'"
drop if _merge==2

replace cohort=2012 if _merge==3&cohort==.
drop w5_* _merge

merge 1:1 listeeid using "`w6'"
drop if _merge==2

replace cohort=2013 if _merge==3&cohort==.
drop w6_* _merge

replace cohort=2014 if cohort==.*/

**********************************

*mixed *_comment and *_text variables and combine them

*csnmd_text

ren csnmd_text csnmd_comment
replace csnmd_comment = upper(csnmd_comment)

*picmdo_comment

drop picmdo_comment
ren picmdo_text picmdo_country

*pwothh_text

*drop pwothh_text

*pwbr_text/pwpm_text

foreach x of var pwbr pwpm {

replace `x'_text = `x'_text + ", Comment: " + `x'_comment if `x'_comment!=""
replace `x'_text = upper(`x'_text)
drop `x'_comment
ren `x'_text `x'_comment
list `x' in 1/20
}

*rename all *_comment to *_text following the previous waves

ren *_comment *_text

*****************************************************

*drop additional geographic variables Matthew sent to ensure consistancy between waves

drop pwmht glrpc fcprp
renvars w8wlwhpy w8wlmlpy w8wlsdpy w8wlotpy, pred(2)

*****************************************************


*replace above cohort imputation with this - tt 17/6/2015
merge 1:1 listeeid using "L:\Data\Samples\masterid.dta", keepusing(W*)
keep if _merge==3
drop _merge
gen cohort=.
replace cohort=2008 if W1p==1|W1==1
replace cohort=2009 if W2Np==1|W2N==1
replace cohort=2010 if W3Np==1|W3N==1
replace cohort=2011 if W4Np==1|W4N==1
replace cohort=2012 if W5Np==1|W5N==1
replace cohort=2013 if W6Np==1|W6N==1
replace cohort=2014 if W7Np==1|W7N==1
replace cohort=2015 if W8Np==1|W8N==1
drop W8Np-W1
********************






















