********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: Master do file cleaning  data
*Input: Wave 9 data including online, hardcopy and extra entered

********************************************************

global ddata="L:\Data\Data Original\Wave9"
global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

capture log close
capture clear
set more off

log using "${dlog}\master.log", replace

********************************************************

*Append all data from different sources

do "${ddo}\append.do"				

*Cleaning process

*use "${ddtah}\w8_append.dta", clear   

*Clean variables by section/types

do "${ddo}\var_admin.do"   //done
do "${ddo}\var_cs.do" //done 
do "${ddo}\var_mc.do" //done
do "${ddo}\var_checkbox.do" //done 
do "${ddo}\var_hours.do"  //done 

do "${ddo}\var_number.do" //done  
do "${ddo}\var_date.do"   //done
do "${ddo}\var_income.do" //done
do "${ddo}\var_text.do"  //done

*Remove duplicated responses

do "${ddo}\duplicates.do"  //done

*Merge geographic variables from Matthew (cleaned)

do "${ddo}\var_geographic.do"  //done

*Clean outreach variable
do "${ddo}\outreach.do" //done

do "${ddo}\var_qualification.do" //done

*Append additional responses Anne recorded in response sheet

do "${ddo}\extra_response.do"    //done

*Extract information from previous waves and AMPCo database for those answered "No Change" and status quo variables

do "${ddo}\crosswave_ampco.do" 

*Add Variable and Value labels to the data

do "${ddo}\label_variable.do"   //done
do "${ddo}\label_value.do" //done

*Calculate sample weights

do "${ddo}\weights.do"  //done

*Standardise all missing values

do "${ddo}\missing_value.do"  //done

*add mobility data

do "${ddo}\mobility.do"  //done


*Order variables for internal release

do "${ddo}\order.do"   //done

*Add imputed income for Wave 8 internal release

do "${ddo}\income_imputation.do"  //done


do "${ddo}\SEIFA.do"   //done

do "${ddo}\checked variables_cleaning.do" //done

********************************************************


*updating first 8 waves internal release to be consistent

/*
do "${ddo}\w1updates.do"
do "${ddo}\w2updates.do"
do "${ddo}\w3updates.do"
do "${ddo}\w4updates.do"
do "${ddo}\w5updates.do"
do "${ddo}\w6updates.do"
do "${ddo}\w7updates.do"
*/
********************************************************

*save a copy of w1-8 data with response date and time to response variables for response graph comparison

*exit
do "${ddo}\wave 1 to 8 updates.do"

foreach i of num 1/8 {

use "${ddtah}\Internal release\w`i'_internal_Nov2017.dta", clear

drop if sdtype==-1
drop *_text *_c *_multi*
drop furcom  
save "L:\Data\Responses\Wave 8\w1_8_response\w`i'_survey_response.dta", replace

}


********************************************************************


*use "${ddtah}\Internal release\w8_internal_Sep2016.dta", clear


********************************************************************

*De-identification of W8 internal data


do "${ddo}\deidentification.do"
do "${ddo}\finalreleaseorder.do"

compress
save "${ddtah}\Public release\w8_publicrelease_v8.0.dta", replace
save "L:\Data\MABEL Data\Wave8\MABEL User DVD v8.0\MABEL v8.0 Stata14\\w8_publicrelease_v8.0.dta", replace
saveold "L:\Data\MABEL Data\Wave8\MABEL User DVD v8.0\MABEL v8.0 Stata13\\w8_publicrelease_v8.0.dta", replace


do "${ddo}\wave1_7_public_updates.do"




********************************************************************




***add

*list id listeeid dtimage piemail if piemail!="" & dtimage!=""
*replace piemail=="" if id==38741|id==39168|id==1000582
*replace piemail=="jane_c_elliott@yahoo.com.au" if id==65277
















