*Date last modified: 16/6/2017
*Purpose: attach distance moved since last responded to MABEL
*Matthew produces the data for this each wave based on latitude and longitude of the mid point of suburbs
*

********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\mobility.log", replace

********************************************************

preserve

import excel "${ddo}\mobility data\w1tow9_dist_AllDrTypes.xlsx", sheet("w1tow9_dist_AllDrTypes") firstrow cellrange(A1:I20209) clear

*import delimited "${ddo}\mobility data\w1tow9_dist_AllDrTypes.csv" clear

keep id dist_w9chg
rename dist_w9chg gldist


gen gldistgr=.
replace gldistgr=0 if gldist==0
replace gldistgr=1 if gldist>0 & gldist<=9
replace gldistgr=2 if gldist>9 & gldist<=49
replace gldistgr=3 if gldist>49 & gldist<.

save "${ddtah}\mobility.dta", replace

restore

*drop _merge
merge m:1 id using "${ddtah}\mobility.dta"
keep if _merge!=2

label var gldist		"Distance moved (workplace) since last completed MABEL"
label var gldistgr		"Distance moved (workplace) since last completed MABEL (grouped)"


#delimit;
label val gldistgr distance;
label de distance	0 	"did not move"
					1	"moved less than 10km"
					2	"moved 10-49km"
					3	"moved 50km or more";

replace gldistgr=-3 if continue==0 & gldistgr==.
replace gldistgr=-4 if continue==1 & gldistgr==.

#delimit cr
