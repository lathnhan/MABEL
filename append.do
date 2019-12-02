********************************************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 30 November 2017, 
*Purpose: append hardcopy, online, pilot, and extra entered datasets together
********************************************************************************

global ddata="L:\Data\Data Original\Wave9"
global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

capture clear
capture log close
set more off

log using "${dlog}\append.log", replace

*tempfile hardcopy_all online_all pilot_all extra_all

********************************************************


***************
*    online 
***************


foreach x in dec den gpc gpn hdc hdn spc spn{
do "${ddo}\\append`x'.do"
tostring _all, replace force
save "${ddtah}\\`x'.dta", replace
}


use "${ddtah}\\gpc.dta", clear
append using "${ddtah}\\gpn.dta"
append using "${ddtah}\\dec.dta"
append using "${ddtah}\\den.dta" 
append using "${ddtah}\\hdc.dta"
append using "${ddtah}\\hdn.dta"
append using "${ddtah}\\spc.dta"
append using "${ddtah}\\spn.dta"

tostring id csclid-pisapsu, replace force


*check for duplicates and if there are many online duplicates deal with now using code similar to that above
duplicates report id


renvars _all, lower

*gen date2= substr(date, 1, 10)
*gen date1=date(date, "DMYhms")
*
*format date1 %td
*drop date
*rename date1 date
*destring date, replace

**************************************************************
***NOT DONE THIS YET, VARIABLE DATE HAS SOME UNUSUAL VALUES***
gen date1 = dofc(date)
format date1 %td
drop date
rename date1 date
**************************************************************


*a couple of amendments due to errors on data entry - remove for wave 9
*replace id="97006" if id=="68" & sdtype=="SP"
*replace furcom="HCopy" if id=="82734"|id=="57274"| id=="71173"

tostring pisapgp, replace

save "${ddtah}\\allonline.dta" ,replace

*use "${ddtah}\\allonline.dta" ,clear


**************
*  Hardcopy
**************

foreach x in gpn gpc sn sc hdn hdc den dec {
import delimited "${ddata}\hardcopy\MABEL_2016_`x'170330.DAT", clear
save "L:\Data\Data Original\Wave9\hardcopy\MABEL_2016_`x'.dta", replace
}

*extra entry - late qs i entered manually
foreach x in gpc hdc spc {   
import delimited "${ddata}\extra entry\\`x'extra.dat",  clear
save "L:\Data\Data Original\Wave9\hardcopy\\`x'extra.dta", replace
}

tempfile gpn gpc spn spc hdn hdc den dec gpcextra hdcextra spcextra 

use "${ddata}\hardcopy\MABEL_2016_GPN.DTA", clear
tostring _all, replace force

gen source="Main"
gen continue="New"
gen response="Hardcopy"
renvars _all, lower
*rename wlottext wlot_text
save "`gpn'"

use "${ddata}\hardcopy\MABEL_2016_GPC.DTA", clear
tostring _all, replace force
renvars _all, lower
*rename wlottext wlot_text

gen source="Main"
gen continue="Continue"
gen response="Hardcopy"
*rename v286 gltown2
*rename v287 glpc2
*rename v288 gltown3
*rename v289 glpc3
renvars _all, lower
*rename pioth12 pioth
save "`gpc'"

use "${ddata}\hardcopy\MABEL_2016_SN.DTA", clear
tostring _all, replace force

gen source="Main"
gen continue="New"
gen response="Hardcopy"
*rename v254 gltown2
*rename v255 glpc2
*rename v256 gltown3
*rename v257 glpc3
*rename (pwwyr pwwmth) (pwwmth pwwyr) 
renvars _all, lower

save "`spn'"

use "${ddata}\hardcopy\MABEL_2016_SC.DTA", clear
tostring _all, replace force


gen source="Main"
gen continue="Continue"
gen response="Hardcopy"
*rename v249 gltown2
*rename v250 glpc2
*rename v251 gltown3
*rename v252 glpc3
*ren wlocnapb wlocrnapb
renvars _all, lower
save "`spc'"


use "${ddata}\hardcopy\MABEL_2016_HDN.DTA", clear
tostring _all, replace force

gen source="Main"
gen continue="New"
gen response="Hardcopy"
renvars _all, lower
save "`hdn'"

use "${ddata}\hardcopy\MABEL_2016_HDC.DTA", clear
tostring _all, replace force

gen source="Main"
gen continue="Continue"
gen response="Hardcopy"
renvars _all, lower
save "`hdc'"


use "${ddata}\hardcopy\MABEL_2016_DEN.DTA", clear
tostring _all, replace force

gen source="Main"
gen continue="New"
gen response="Hardcopy"
renvars _all, lower
*rename pisapoe  pisapom
save "`den'"

use "${ddata}\hardcopy\MABEL_2016_DEC.DTA", clear
tostring _all, replace force

gen source="Main"
gen continue="Continue"
gen response="Hardcopy"
renvars _all, lower
*rename pisapoe pisapom
save "`dec'"

use "${ddata}\hardcopy\gpcextra.DTA", clear
tostring _all, replace force
gen source="Main"
gen continue="Continue"
gen response="Hardcopy"
renvars _all, lower
save "`gpcextra'"

use "${ddata}\hardcopy\hdcextra.DTA", clear
tostring _all, replace force
gen source="Main"
gen continue="Continue"
gen response="Hardcopy"
renvars _all, lower
save "`hdcextra'"

use "${ddata}\hardcopy\spcextra.DTA", clear
tostring _all, replace force
gen source="Main"
gen continue="Continue"
gen response="Hardcopy"
renvars _all, lower
save "`spcextra'"


use "`gpn'", clear 
append using "`gpc'"
append using "`spn'"
append using "`spc'"
append using "`hdn'"
append using "`hdc'"
append using "`den'"
append using "`dec'"
append using "`gpcextra'"
append using "`spcextra'"
append using "`hdcextra'"


rename pivipchl pivpchl
rename pivipchl_comment pivpchl_comment

renvars _all, lower

preserve
drop *_comment
drop id
desc _all, varlist
restore

foreach x in `r(varlist)' {

capture confirm var `x'_comment

if !_rc {

replace `x' = `x' + " comment:" + `x'_comment

}

else {
}

}
drop*_comment


append using "${ddtah}\\allonline.dta"

destring id, replace force
rename id username
drop if username==.
merge m:1 username using "L:\Data\Samples\Wave 9\W9final.dta", gen(sample) keepusing(username)
keep if sample!=2
 label values sample mainpilot
 label define mainpilot 3 "main" 1 "pilot", replace
replace response = "Hardcopy" if sample==1 & source=="Main"
replace source = "Pilot" if sample==1
*replace response="Online" if source=="Pilot" 
 
rename username id


*drop locationlatitude locationlongitude locationaccuracy

compress
  
save "${ddtah}\w9_append.dta", replace
********************************************************






