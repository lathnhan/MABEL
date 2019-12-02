*Date last modified: 19/8/2017
*Purpose: update SEIFA 2011 release and other additional variables to wave 6 data

********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

capture log close
set more off

log using "${dlog}\wave8_SEIFA.log", replace

*Comments add by Wenda: this part is new to Wave 5 release, all source files can be found in 
*"L:\Data\Data Clean\Wave5\dtah\SEIFA 2011"
*the external linked variables are: house price (postcode level), SEIFA (most recent version 2011),
*Distance to ther nearest ED, percentages of ages under 5 and over 70, GP ratio, DWS status)

********************************************************

*use "${ddtah}\Internal release\w7_internal_Sep2014.dta", clear



********************************************************

*clean the postcodes for linkage

gen postcode = glpcw 		/*postcodes of work address*/

replace postcode=800 if postcode==801
replace postcode=820 if postcode==804
replace postcode=810 if postcode==811
replace postcode=870 if postcode==871
replace postcode=880 if postcode==881
replace postcode=2000 if postcode==2001
replace postcode=2036 if postcode==2006
replace postcode=2060 if postcode==2059
replace postcode=2137 if postcode==2139
replace postcode=2033 if postcode==2052
replace postcode=2060 if postcode==2055
replace postcode=2307 if postcode==2308
replace postcode=2617 if postcode==2616
replace postcode=2650 if postcode==2661
replace postcode=2750 if postcode==2751
replace postcode=3000 if postcode==3001
replace postcode=3052 if postcode==3010
replace postcode=3052 if postcode==3050
replace postcode=3028 if postcode==3027
replace postcode=3500 if postcode==3502
replace postcode=3550 if postcode==3552
replace postcode=3630 if postcode==3632
replace postcode=3677 if postcode==3676
replace postcode=3168 if postcode==3800
replace postcode=4000 if postcode==4001
replace postcode=4030 if postcode==4029
replace postcode=4073 if postcode==4072
replace postcode=4810 if postcode==4813
replace postcode=5006 if postcode==5005
replace postcode=5067 if postcode==5071
replace postcode=5107 if postcode==5106
replace postcode=6000 if postcode==6001
replace postcode=6230 if postcode==6231
replace postcode=6008 if postcode==6904
replace postcode=7000 if postcode==7001

********************************************************

*Metro/Non-Metro

gen metro=1 if gltwwasgc==1
replace metro=0 if gltwwasgc>=2&gltwwasgc<=5
replace metro=gltwwasgc if metro==.&gltwwasgc<0

********************************************************

*SEIFA 		/*SEIFA 2011 was prepared before to link Wave 4 and 5 data*/
drop _merge
merge m:1 postcode using "L:\Data\Data Clean\Wave5\dtah\SEIFA 2011\seifa2011.dta", keep(master match) 

ren index_ad_disad 	seifa_irsad
ren index_dis 		seifa_irsd
ren index_econ 		seifa_ier
ren index_educ 		seifa_ieo

********************************************************

*percentage of population under 5 and above 65

merge m:1 postcode using "L:\Data\Data Clean\Wave5\dtah\SEIFA 2011\postcodeunder5&elderly.dta", keep(master match) nogen

ren percentageunder5 					percent_under5
ren percentageelderly__65_and_above_ 	percent_above65

********************************************************

/*distance to emergency department

merge m:1 postcode using "L:\Data\Data Clean\Wave5\dtah\SEIFA 2011\postcode_minimum_distance.dta", keep(master match) nogen

ren dist 	mindist_band

********************************************************

*population GP density only provided at SLA level, link to POA2006

preserve

tempfile gpratio

use "L:\Data\Data Clean\Wave5\dtah\SEIFA 2011\CP2006SLA_2006POA.DTA", clear

merge m:1 SLA_2006_Code using "L:\Data\Data Clean\Wave5\dtah\SEIFA 2011\SLA_GPpopu_Ratio.dta", keep(match) nogen

gen NumGPs_per = NumGPs * Pcent / 100
gen UR06total_per = UR06total * Pcent / 100

sort POA_2006_Code
by POA_2006_Code: egen NumGPs_total = total(NumGPs_per)
by POA_2006_Code: egen UR06total_total = total(UR06total_per)

keep POA_2006_Code NumGPs_total UR06total_total
duplicates drop POA_2006_Code, force

gen RatioGPpopu = NumGPs_total / UR06total_total
ren POA_2006_Code postcode



keep postcode RatioGPpopu
save "`gpratio'"

restore */

preserve

do "L:\Data\Data Clean\Wave8\GP ratio\GPratio.do"
restore

drop _merge

merge m:1 postcode using "L:\Data\Data Clean\Wave7\GP ratio\GPratio.dta", gen(merge2)
drop if merge2==2
drop merge2 

********************************************************
*DWS

rename gltww locality_name
*rename glpcw postcode

tostring postcode, replace
merge m:m postcode locality_name using "L:\Data\Data Clean\Wave8\DWS data\sa2_data.dta", keepusing(dws2015)
drop if _merge==2

*MANUALLY RECODE WHERE NECESSARY
destring postcode, replace

replace dws="N" if locality_name=="UNSW" & (postcode==2033) & _merge==1
replace dws="N" if locality_name=="UNIVERSITY OF SYDNEY" & (postcode==2036) & _merge==1
replace dws="N" if locality_name=="CANBERRA" & (postcode==2600|postcode==2601) & _merge==1

replace dws="N" if locality_name=="COLLAROY PLATEAU" & (postcode==2097) & _merge==1
replace dws="N" if locality_name=="CONCORD REPATRIATION HOSPITAL" & (postcode==2137) & _merge==1
replace dws="N" if locality_name=="ETTALONG" & (postcode==2257) & _merge==1
replace dws="Y" if locality_name=="CALLAGHAN" & (postcode==2307) & _merge==1
replace dws="N" if locality_name=="BRUCE" & (postcode==2601) & _merge==1
replace dws="N" if locality_name=="KAWANA" & (postcode==4575) & _merge==1
replace dws="Y" if locality_name=="MAJURA PARK" & (postcode==2609) & _merge==1
replace dws="N" if locality_name=="KAPOOKA" & (postcode==2650) & _merge==1
replace dws="N" if locality_name=="PRAHRAN" & (postcode==3004) & _merge==1
replace dws="N" if locality_name=="ROYAL MELBOURNE HOSPITAL" & (postcode==3052) & _merge==1
replace dws="N" if locality_name=="UNIVERSITY OF MELBOURNE" & (postcode==3052) & _merge==1
replace dws="N" if locality_name=="MALVERN" & (postcode==3148) & _merge==1
replace dws="N" if locality_name=="BRISBANE AIRPORT" & (postcode==4008) & _merge==1
replace dws="N" if locality_name=="HERSTON" & (postcode==4030) & _merge==1
replace dws="Y" if locality_name=="RAINWORTH" & (postcode==4065) & _merge==1
replace dws="N" if locality_name=="ST LUCIA" & (postcode==4073) & _merge==1
replace dws="N" if locality_name=="SUMNER PARK" & (postcode==4074) & _merge==1
replace dws="N" if locality_name=="LOGAN" & (postcode==4114|postcode==4131) & _merge==1
replace dws="N" if locality_name=="UPPER MT GRAVATT" & (postcode==4122) & _merge==1
replace dws="N" if locality_name=="WEST BURLEIGH" & (postcode==4219) & _merge==1
replace dws="N" if locality_name=="NOOSA" & (postcode==4567) & _merge==1
replace dws="N" if locality_name=="LAVARACK" & (postcode==4810) & _merge==1
replace dws="N" if locality_name=="TOWNSVILLE MILPO" & (postcode==4810) & _merge==1
replace dws="Y" if locality_name=="CAPE YORK" & (postcode==4871) & _merge==1
replace dws="Y" if locality_name=="LOCKHART RIVER" & (postcode==4892) & _merge==1
replace dws="N" if locality_name=="ADELAIDE" & (postcode==5001) & _merge==1
replace dws="N" if locality_name=="ADELAIDE UNIVERSITY" & (postcode==5006) & _merge==1
replace dws="Y" if locality_name=="SALISBURY SOUTH" & (postcode==5107) & _merge==1
replace dws="N" if locality_name=="VICTOR HARBOUR" & (postcode==5211) & _merge==1
replace dws="Y" if locality_name=="COCOS (KEELING) ISLANDS" & (postcode==6799) & _merge==1

replace dws="N" if (postcode==9913|postcode==9914| postcode==9916| postcode==9916) & _merge==1

replace dws="Y" if postcode<900


replace dws2015="Y" if rrma==6|rrma==7
rename dws2015 dws
replace dws= "0" if dws=="N"
replace dws= "1" if dws=="Y"

destring dws, replace

label var dws		"District of Workforce Shortage"

label val dws yesno
rename locality_name gltww

replace dws=-4 if dws==. & gltww!=""
replace dws=-2 if gltww==""


duplicates drop listeeid, force



********************************************************
* add data on distance to nearest emergency hospital

drop _merge
merge m:1 postcode using "L:\Data\Data Clean\Wave8\Distance to ED\distance_cd_to_hospital.dta


drop if _merge==2


drop  emer_targe sqkm priv_targe public_targe poa_name postcode
rename public_dista distpubl
rename priv_dista distpriv
rename emer_dista distemer

label var distpubl "Distance to the nearest public hospital (km)"
label var distpriv "Distance to the nearest private hospital (km)"
label var distemer "Distance to the nearest emergency department(km)"

********************************************************


*label new variables

label var metro 			"Indicator of Metro / Non-Metro"
label var seifa_irsad 		"Index of relative Socio-Economic Advantage and Disadvantage"
label var seifa_irsd 		"Index of relative Socio-Economic Disadvantage"
label var seifa_ier 		"Index of Economic Resource"
label var seifa_ieo 		"Index of Education and Occupation"
label var percent_under5 	"Percentage of population under age 5"
label var percent_above65 	"Percentage of population above age 65"
*label var mindist 			"Minimum distance to emergency department (Km)"
*label var mindist_band 		"Minimum distance to emergency department in bands (Km)"
label var RatioGPpopu 		"Ratio of GP to population"
*label var medianprice 		"Median house price"

******************************************************

*save "${ddtah}\Internal release\w6_internal_Sep2014_SEIFA2011.dta", replace
*save "${ddtah}\w6_internal_Sep2014_SEIFA2011.dta", replace

