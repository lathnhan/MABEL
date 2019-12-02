*Date last modified: 23/8/17
*Purpose: clean the variables related to text responses

********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

*capture clear
capture log close
set more off

log using "${dlog}\var_text.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

*List all variables to be cleaned in this section
*Country of basic medical education: picmdo_text


********************************************************

*Countries

*Keep all original text in picmdo_comment, and the cleaned standardised text in picmdo_text

replace picmdo_text=upper(picmdo_text)
replace picmdo_text=trim(picmdo_text)
replace picmdo_text=itrim(picmdo_text)

replace picmdo_comment = picmdo_text

tab picmdo_text if picmdo_text!=""

replace picmdo_text="NEW ZEALAND" if picmdo_text=="NZ"
replace picmdo_text="AUSTRALIA" if picmdo_text=="PLUS BRISBANE 1989"
replace picmdo_text="SOUTH AFRICA" if strmatch(picmdo_text,"*SOUTH AFRICA*")
replace picmdo_text="UNITED KINGDOM" if picmdo_text=="UK"
replace picmdo_text="UNITED STATES" if picmdo_text=="USA"
replace picmdo_text="RUSSIA" if picmdo_text=="USSR"
replace picmdo_text="" if id==1000426 | id==1000453
replace picmdo_text="BURMA" if picmdo_text=="MYANMAR"
replace picmdo_text="" if picmdo_text=="AUSTRALIA"

*********************************************************************

*GPs areas of special interest
replace wlot_text=lower(wlot_text)




label var picmdo_text		"Cleaned"
