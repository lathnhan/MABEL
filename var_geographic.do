**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 15 April 2017
*Purpose: merge the geographic variables from Matthew to w6 data
********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\var_geographic.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

*NOTE: Remember to clean glnloc after getting these data from matthew.



preserve

*in wave 8 the geovar file from Matthew was in 2 parts - this won't normally happen
tempfile geovar1 geovar2


import delimited using "L:\Data\Data Clean\Wave8\dtah\W8_FinalGeocode.csv", clear
*tostring cpwmhp, replace
save "`geovar1'"

import delimited using "L:\Data\Data Clean\Wave8\dtah\W8_FinalGeocode_pt2.csv", clear
append using "`geovar1'"

*rename pwmhn cpwmhn

*rename DocID id
tostring cfcprpc, replace
foreach x of var cpwmht pwmhasgc pwmhrrma cgltww gltwwasgc gltwwrrma /*gltwwML - Medicare local, not found*/ cgltwl ///
				  gltwlasgc gltwlrrma cglrtw  glrtwasgc glrtwrrma cfcprtw cfcprpc fcprtasgc ///
				 fcprtrrma cgltown1  glout1asgc glout1rrma cgltown2  glout2asgc glout2rrma ///
				 cgltown3  glout3asgc glout3rrma {

replace `x'=trim(`x')
replace `x'=itrim(`x')
replace `x'=upper(`x')

}


*
destring cfcprpc, replace
	
	*the next 4 lines are for wa
	duplicates report id
	duplicates tag id, gen(dup)
	drop if dup>0 &sdtype!=1
	drop if id==20936 & cgltww=="BEROWRA HEIGHTS"


save "${ddtah}\geovar.dta", replace





restore

********************************************************


merge 1:1 id using "${ddtah}\geovar.dta"
*merge 1:1 id using "`geovar'" // use this instead of line above


*This bit changes all the Cleaned variables (prefix of 'C') to the original var names and capitalises

drop if _merge==2 		/*all these 2 responses are declined to participate in the survey*/
gen pwmht=""

foreach x of var gltww gltwl glrtw fcprt glpcw glpcl pwmht pwmhp gltown1 gltown2 gltown3  glpc1 glpc2 glpc3 {

tostring `x' c`x', replace
replace c`x'="" if c`x'=="."
replace c`x'="" if c`x'=="-"

replace `x' = c`x' if _merge==3
replace `x' = trim(`x')
replace `x' = itrim(`x')
replace `x' = upper(`x')

dis "Variable `x'"
tab `x' if _merge==1

}

rename cfcprpc fcprpc
rename cgltpc gltpc


/*there are no cases in wave 6 where _merge==1

list id gltww glpcw if _merge==1  /

replace gltww="NEDLANDS" if id==80465

list id gltwl glpcl if _merge==1

replace gltwl="BROWN HILL" if id==51474
replace glpcl="3350" if id==51474

list id glrtw fcprs if _merge==1
list id fcprt fcprs if _merge==1
list id pwmhn pwmhp if _merge==1*/

drop cgltww cgltwl cglrtw cfcprt  cglpcw cglpcl cpwmht cpwmhp cgltown1 cgltown2 cgltown3 cglpc1 cglpc2 cglpc3 _merge

************************************************************



order gltww glpcw gltwl glpcl glrtw glrst gltpc fcprt fcprs fcprpc gltown1 pwmhn pwmhp gltown1 glpc1 gltown2 glpc2 gltown3 glpc3
*, a(piqadg)   - what does this mean - tt 23/4/2015


ren fcprpc fcprp
ren pwmhasgc pwmhtasgc
ren pwmhrrma pwmhtrrma

destring  glpcw glpcl gltpc fcprp pwmhp  glpc1 glpc2 glpc3, replace

foreach x of var pwmhn pwmht gltww gltwl glrtw glrst fcprt fcprs {

replace `x'=upper(`x')
replace `x'=trim(`x')
replace `x'=itrim(`x')
replace `x'="" if `x'=="-"

}
*aa
*glrpc/glrtw/glrst

list gltpc glrtw if gltpc==. & glrtw!=""
*No missing values

list gltpc glrtw glrst if glrst=="" & glrtw!=""

rename gltpc glrpc
gen glrst1=glrst
list  id glrtw glrst glrst1 glrpc  if glrst1!="ACT"&glrst1!="NSW"&glrst1!="NT"&glrst1!="QLD"&glrst1!="TAS"&glrst1!="SA"&glrst1!="VIC"&glrst1!="WA" & glrst1!=""

replace glrst="" if glrpc!=.
replace glrst="ACT" if (glrpc>=2600&glrpc<=2618)|(glrpc>=2900&glrpc<=2999)
replace glrst="NSW" if (glrpc>=2000&glrpc<=2599)|(glrpc>=2619&glrpc<=2899)
replace glrst="NT" if glrpc<1000&glrpc>=800
replace glrst="QLD" if glrpc>=4000&glrpc<=4999
replace glrst="SA" if glrpc>=5000&glrpc<=5999
replace glrst="TAS" if glrpc>=7000&glrpc<=7999
replace glrst="VIC" if glrpc>=3000&glrpc<=3999
replace glrst="WA" if glrpc>=6000&glrpc<=6999

replace glrst="NSW" if glrtw=="RURAL NSW"
replace glrst="SA" if glrtw=="RURAL SA"
replace glrst="VIC" if glrtw=="RURAL VIC"

replace glrst="NT" if glrtw=="DARWIN" & glrst==""

list  id glrtw glrst glrst1 glrpc  if glrst1!="ACT"&glrst1!="NSW"&glrst1!="NT"&glrst1!="QLD"&glrst1!="TAS"&glrst1!="SA"&glrst1!="VIC"&glrst1!="WA" & glrst1!=""

tab glrst
replace glrst=trim(glrst)
replace glrst="" if glrst=="NA"|glrst=="N/A"
replace glrst="" if glrst!="ACT"&glrst!="NSW"&glrst!="NT"&glrst!="QLD"&glrst!="TAS"&glrst!="SA"&glrst!="VIC"&glrst!="WA"
replace glrst="QLD" if glrst=="QUEENSLAND"
replace glrst="SA" if glrst=="SOUTH AUSTRALIA"
replace glrst="TAS" if glrst=="TASMANIA"
replace glrst="" if glrst=="AUSTRALIA"

drop glrst1

*pwmhp/pwmht/pwmhn

list pwmht pwmhp if pwmhp!=. & pwmht==""
*no changes necessary

*fcprt/fcprs/fcprp
gen fcprs1=fcprs

replace fcprs="" if fcprp!=.
replace fcprs="ACT" if (fcprp>=2600&fcprp<=2618)|(fcprp>=2900&fcprp<=2999)
replace fcprs="NSW" if (fcprp>=2000&fcprp<=2599)|(fcprp>=2619&fcprp<=2899)
replace fcprs="NT" if fcprp<1000&fcprp>=800
replace fcprs="QLD" if fcprp>=4000&fcprp<=4999
replace fcprs="SA" if fcprp>=5000&fcprp<=5999
replace fcprs="TAS" if fcprp>=7000&fcprp<=7999
replace fcprs="VIC" if fcprp>=3000&fcprp<=3999
replace fcprs="WA" if fcprp>=6000&fcprp<=6999

list fcprt fcprs fcprs1 fcprp if fcprs1!="ACT"&fcprs1!="NSW"&fcprs1!="NT"&fcprs1!="QLD"&fcprs1!="TAS"&fcprs1!="SA"&fcprs1!="VIC"&fcprs1!="WA" & fcprs1!=""


tab fcprs, m
replace fcprs="" if fcprs!="ACT"&fcprs!="NSW"&fcprs!="NT"&fcprs!="QLD"&fcprs!="TAS"&fcprs!="SA"&fcprs!="VIC"&fcprs!="WA"
drop fcprs1

****************************************************

*impute the corresponding ASGC/RRMA

foreach x of var gltww gltwl glrtw fcprt pwmht {

tab `x' if `x'asgc==""
tab `x' if `x'rrma==""

}


/*the following is for a very late q which arrived after matthew had geocoded - no need to do in w8.
replace gltwlasgc="MAJOR CITY" if id==12394
replace gltwlrrma="CAPITAL" if id==12394
replace gltwwasgc="MAJOR CITY" if id==12394
replace gltwwrrma="CAPITAL" if id==12394*/



*****************************************************

foreach x of var glpcw glpcl pwmhp glrpc fcprp {

replace `x'=-2 if `x'==.

}

*renvars *ASGC *RRMA , lower
ren pwmhtasgc pwmhpasgc
ren pwmhtrrma pwmhprrma

*MedL


foreach x of var *asgc {

replace `x'="1" if `x'=="MAJOR CITY"
replace `x'="2" if `x'=="INNER REGIONAL"
replace `x'="3" if `x'=="OUTER REGIONAL"
replace `x'="4" if `x'=="REMOTE"
replace `x'="5" if `x'=="VERY REMOTE"

replace `x'="-3" if `x'=="N/A"

destring `x', replace

}

foreach x of var *rrma {

replace `x'="1" if `x'=="CAPITAL"
replace `x'="2" if `x'=="OTHER METRO"
replace `x'="3" if `x'=="LARGE RURAL"
replace `x'="4" if `x'=="SMALL RURAL"
replace `x'="5" if `x'=="OTHER RURAL"
replace `x'="6" if `x'=="REMOTE CENTRE"
replace `x'="7" if `x'=="OTHER REMOTE"

replace `x'="-3" if `x'=="N/A"

destring `x', replace

}

foreach i of num 1/3 {
list gltown`i' glpc`i' if glpc`i'==. & gltown`i' !=""
}


foreach x of var *mmm {
replace `x'=. if `x'==99
} 



foreach x of var *asgc *rrma  *mmm gltww gltwl glrtw fcprt pwmhn pwmht glpcw glpcl pwmhp glrpc fcprp pwmhn pwmht glrst fcprs gltown1 glpc1 gltown2 glpc2 gltown3 glpc3{
				 

label var `x' 		"Cleaned"

}
