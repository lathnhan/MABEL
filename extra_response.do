**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 08 June 2017
*Purpose: append additonal responses from Anne's response sheet and AMPCo database to MABEL w5 data

********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\extra_response.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

*Comments added by Wenda: there are always some doctors didn't return any survey but just called up Anne or send emails
*say that they are not in clinical practice, those doctors are not captured by the survey data yet, they are all recorded 
*in Anne's response sheet (the one you use to calculate response rates for MABEL meetings), so this do file simply going through 
*the same process as you working on the response rates, map the response sheet to the main survey data and see if there are any 
*doctors reported not in clinical practice but not picked up by the survey.

*APPEND EXTRA RESPONSES FROM ANNE'S RESPONSE SHEET

preserve

tempfile w9main w9pilot w9responsesheet

import excel "L:\Data\Responses\Wave 9\W9Response.xlsx", sheet("w9Response") firstrow clear

renvars _all, lower

keep username type version responsecode dateresponsereceived comment listeeid
ren username id
rename dateresponsereceived response_date
format response_date %td


/*merge 1:1 id using "${ddtah}\id_mismatch.dta"
drop if _merge==2

replace id = old_id if _merge==3

drop _merge listeeid old_id*/ 

save "`w9main'"

import excel "L:\Data\Responses\Wave 8 Pilot\w9PResponse.xlsx", sheet("w9PResponse") firstrow clear

renvars _all, lower

keep username type version responsecode dateresponsereceived comment listeeid
ren username id
rename dateresponsereceived response_date
format response_date %td

/*merge 1:1 id using "${ddtah}\id_mismatch.dta"
drop if _merge==2

replace id = old_id if _merge==3

drop _merge listeeid old_id*/

save "`w9pilot'"

append using "`w9main'", gen(main)
drop if id==.
save "`w9responsesheet'"

restore

*merge from Main response

merge 1:1 id using "`w9responsesheet'", gen(merge1)



replace responsecode="" if merge1==3

drop if merge1==2&(responsecode==""|responsecode=="2"|responsecode=="3"|responsecode=="6")
*save "L:\Data\Data Clean\Wave7\dtah\tt.dta", replace

*check if comments are relevant
list id responsecode comments if strmatch(responsecode, "*comment*")

replace responsecode=lower(responsecode)

drop if responsecode=="1"    //but why would anyone have this responsecode?
replace responsecode=subinstr(responsecode, ",", " ", .)
replace responsecode=subinstr(responsecode, "/", " ", .)
replace responsecode=subinstr(responsecode, "(", " ", .)
replace responsecode=subinstr(responsecode, ")", " ", .)
replace responsecode=subinstr(responsecode, "-", " ", .)
replace responsecode=subinstr(responsecode, "_", " ", .)
replace responsecode=subinstr(responsecode, ".", " ", .)
replace responsecode=subinstr(responsecode, "see comment", "", .)
replace responsecode=regexr(responsecode, "or", "")
replace responsecode=regexr(responsecode, "or", "")
replace responsecode=itrim(responsecode)
replace responsecode=trim(responsecode)
replace responsecode=lower(responsecode)

drop if strmatch(responsecode, "1 *")

drop if responsecode=="16"  //but this states answers same as previous year - check tt 8/6/2016
drop if responsecode=="17"
drop if responsecode=="18"
drop if responsecode=="21"
drop if responsecode=="22"


replace responsecode=itrim(responsecode)
replace responsecode=trim(responsecode)

replace cspret=1 if strmatch(responsecode,"4 *")
replace cspret=1 if responsecode=="4"
replace cspret=1 if strmatch(responsecode,"* 4*")

replace csncli=1 if strmatch(responsecode,"* 5*")
replace csncli=1 if strmatch(responsecode,"5 *")
replace csncli=1 if responsecode=="5"

tab responsecode csml, m
replace csml=1 if responsecode=="7"

tab responsecode csexl, m
replace csexl=1 if responsecode=="10"
replace csexl=1 if strmatch(responsecode, "* 10")

tab responsecode csocli, m
replace csocli=1 if strmatch(responsecode,"*11*")

tab responsecode csonmd, m
replace csonmd=1 if strmatch(responsecode,"*13*")

tab responsecode csnmd, m
replace csnmd=1 if strmatch(responsecode,"*14*")

gen csdeath=1 if strmatch(responsecode,"*15*")

gen csovs=1 if strmatch(responsecode,"*11*")|strmatch(responsecode,"*12*")|strmatch(responsecode,"*13*")

replace source="Main" if main==1
replace source="Pilot" if main==0
replace continue="New" if continue==""&version=="w9N"
replace continue="Continue" if continue==""&version=="w9C"
replace response="Response Sheet" if response==""

replace sdtype=1 if response=="Response Sheet"& (type=="[1]GP"|type=="GP")
replace sdtype=2 if response=="Response Sheet"&	(type=="[2]specialist"|type=="Specialist") 
replace sdtype=3 if response=="Response Sheet"& (type=="[3]hospital non-specialist"|type=="Hospital doctor") 
replace sdtype=4 if response=="Response Sheet"& (type=="[4]specialist-in-training"|type=="Specialist Registrar") 

drop type version responsecode merge1

*********************************************************
*In Wave 8, surveys were not sent to datatime if csrtn==0 because the survey was left blank.  Need to record if csrtn==0 here thoughn
replace csrtn=0 if username==	43615		& csrtn==. & jshp==. 
replace csrtn=0 if username==	9376		& csrtn==. & jshp==. 
replace csrtn=0 if username==	25771		& csrtn==. & jshp==. 
replace csrtn=0 if username==	20378		& csrtn==. & jshp==. 
replace csrtn=0 if username==	33547		& csrtn==. & jshp==. 
replace csrtn=0 if username==	41219		& csrtn==. & jshp==. 
replace csrtn=0 if username==	38251		& csrtn==. & jshp==. 
replace csrtn=0 if username==	39503		& csrtn==. & jshp==. 
replace csrtn=0 if username==	56287		& csrtn==. & jshp==. 
replace csrtn=0 if username==	27809		& csrtn==. & jshp==. 
replace csrtn=0 if username==	33413		& csrtn==. & jshp==. 
replace csrtn=0 if username==	36158		& csrtn==. & jshp==. 
replace csrtn=0 if username==	31056		& csrtn==. & jshp==. 
replace csrtn=0 if username==	24924		& csrtn==. & jshp==. 
replace csrtn=0 if username==	39294		& csrtn==. & jshp==. 
replace csrtn=0 if username==	27575		& csrtn==. & jshp==. 
replace csrtn=0 if username==	43347		& csrtn==. & jshp==. 
replace csrtn=0 if username==	41420		& csrtn==. & jshp==. 
replace csrtn=0 if username==	42409		& csrtn==. & jshp==. 
replace csrtn=0 if username==	34652		& csrtn==. & jshp==. 
replace csrtn=0 if username==	38863		& csrtn==. & jshp==. 
replace csrtn=0 if username==	26209		& csrtn==. & jshp==. 
replace csrtn=0 if username==	34743		& csrtn==. & jshp==. 
replace csrtn=0 if username==	35895		& csrtn==. & jshp==. 
replace csrtn=0 if username==	55676		& csrtn==. & jshp==. 
replace csrtn=0 if username==	39362		& csrtn==. & jshp==. 
replace csrtn=0 if username==	29877		& csrtn==. & jshp==. 
replace csrtn=0 if username==	26878		& csrtn==. & jshp==. 
replace csrtn=0 if username==	41256		& csrtn==. & jshp==. 
replace csrtn=0 if username==	73436		& csrtn==. & jshp==. 
replace csrtn=0 if username==	25838		& csrtn==. & jshp==. 
replace csrtn=0 if username==	25278		& csrtn==. & jshp==. 
replace csrtn=0 if username==	73399		& csrtn==. & jshp==. 
replace csrtn=0 if username==	45271		& csrtn==. & jshp==. 
replace csrtn=0 if username==	73915		& csrtn==. & jshp==. 
replace csrtn=0 if username==	41524		& csrtn==. & jshp==. 
replace csrtn=0 if username==	43595		& csrtn==. & jshp==. 
replace csrtn=0 if username==	28966		& csrtn==. & jshp==. 
replace csrtn=0 if username==	41455		& csrtn==. & jshp==. 
replace csrtn=0 if username==	36119		& csrtn==. & jshp==. 
replace csrtn=0 if username==	64926		& csrtn==. & jshp==. 
replace csrtn=0 if username==	40176		& csrtn==. & jshp==. 
replace csrtn=0 if username==	36903		& csrtn==. & jshp==. 
replace csrtn=0 if username==	6352		& csrtn==. & jshp==. 
replace csrtn=0 if username==	86298		& csrtn==. & jshp==. 



*********************************************************

*generate date of response for those extra response from response sheet

*replace response_date="" if response_date=="MO1"|response_date=="`"|response_date=="q"|response_date=="v"|response_date=="y"

replace response_date=date if date!=. & response_date==.
drop date
rename response_date date


*generate the time to response variable based on date of response and mailout dates
*drop mailout
gen mailout=""

replace mailout="09/02/2015" if source=="Pilot"
replace mailout="05/06/2015" if source=="Main"
*tab mailout

gen maildate=date(mailout, "DMY")
format maildate %td
*tab maildate
*drop maildate
*gen datebackup=date
*format datebackup %td
*sort date


replace date=. if date<maildate

gen t2response = date - maildate if date!=.

drop mailout maildate /*datebackup*/

*********************************************************

foreach x of var csdeath csovs cspret csncli csml cshd csstu csexl csocli csoncli csonmd csnmd csclid {

replace `x'=0 if `x'==.

}

replace csrtn=-2 if csrtn==.

order csdeath csovs, a(csnmd_text)

*********************************************************

/*THIS PROBABLY NECESSARY FOR WAVE 8 AS LISTEEID IS INCLUDED IN RESPONSE SHEET, AND COMMAND AT LINE 39 IMPORTS IT. BUT CHECK WHEN RUN ON DATA
*link the additional response sheet records with listeeid 
*drop _merge
replace username=id if username==.
merge 1:1 username using "L:\Data\Samples\Wave 8 Pilot\w9pfinal.dta", keepusing(listeeid) update

drop if _merge==2
drop _merge

*check for duplicates  */

*********************************************************

*APPEND EXTRA RESPONSES FROM AMPCO DATABASE FOR CONTINUING DOCTORS NOT IN CLINCAL PRACTICE

preserve

tempfile ampco_noclin

use "L:\Data\Samples\Wave 8\p3048 balance w9 continuing.dta", clear

keep listeeid employmentdetailpractisingsta
ren employmentdetailpractisingsta status
tab status

drop if strmatch(status, "*Employment to be verified*")|strmatch(status, "*Other*")|strmatch(status, "*Practising*")

gen cspret = 0
gen csdeath = 0
gen csovs = 0
gen csncli = 0
gen csml = 0
gen cshd = 0
gen csstu = 0
gen csexl = 0
gen csocli = 0
gen csoncli = 0
gen csonmd = 0
gen csnmd = 0

gen csclid = 0
gen csrtn = -2

gen sdtype=-1

replace cspret=1 if strmatch(status,"*Retired*")
replace csdeath=1 if strmatch(status,"*Deceased*")
replace csml=1 if strmatch(status,"*Maternity Leave*")
replace csexl=1 if strmatch(status,"*Sabbatical*")


destring listeeid, replace
*merge 1:1 listeeid using "L:\Data\Data Clean\Wave6\dtah\listeeid_xwaveid_all.dta", keepusing(id listeeid) update 

save "`ampco_noclin'"

restore

/*
preserve

tempfile w5survey ampco_retired

keep id listeeid
save "`w5survey'"

use "${ddtah}\W5final.dta", clear

keep listeeid username status
replace status=trim(status)

keep if status=="Retired"

ren username id

gen cspret=1
drop status

merge 1:1 listeeid id using "`w5survey'"
keep if _merge==1
drop _merge

gen csdeath = 0
gen csovs = 0
gen csncli = 0
gen csml = 0
gen cshd = 0
gen csstu = 0
gen csexl = 0
gen csocli = 0
gen csoncli = 0
gen csonmd = 0
gen csnmd = 0
gen csclid = 0
gen csrtn = -2

gen sdtype=-1

save "`ampco_retired'"

restore
*/

append using "`ampco_noclin'"

sort listeeid id

duplicates tag listeeid, gen(dup4)

list listeeid id sdtype if dup4==1
drop if dup4==1&id==.

*list listeeid id sdtype if dup4==1
*duplicates report listeeid

preserve

foreach x of num 1/8 {

tempfile w`x'

use "L:\Data\Data Clean\Wave8\dtah\Internal release\w`x'_internal_Feb2017.dta", clear

keep id listeeid
save "`w`x''"

}


use "`w1'", clear
append using "`w2'"
append using "`w3'"
append using "`w4'"
append using "`w5'"
append using "`w6'"
append using "`w7'"
append using "`w8'"

codebook listeeid id

duplicates drop listeeid id, force
duplicates drop listeeid, force
ren id id_w1_8

save "${ddtah}\w1_8_listeeid_id_all.dta", replace

restore

duplicates drop listeeid id, force

merge 1:1 listeeid using "${ddtah}\w1_8_listeeid_id_all.dta", keep(master match) nogen

replace id = id_w1_8 if id==.&id_w1_8!=.
drop id_w1_8 dup4

****************************************************

*Manually enter response date for those late responses where date of response hasn't been recorded...

gen response_date = ""

list id dtimage if date==. & dtimage != ""

gen date1 = date(response_date, "DMY")
gen mail = date("11/06/2014", "DMY")

gen t2response1 = date1 - mail

replace date = date1 if date==. & date1!=.
replace t2response = t2response1 if t2response==. & t2response1!=.

drop date1 mail t2response1 response_date

***************************************************





