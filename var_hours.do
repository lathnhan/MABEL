*Date last modified: 14/3/17
*Purpose: clean the variables related to working hours

********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

*capture clear
capture log close
set more off

log using "${dlog}\var_hours.log", replace

********************************************************

use "${ddtah}\temp_all.dta", clear

********************************************************

*WORKING HOURS BY SETTINGS

*GP: pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh pwtoh
*SP: pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh pwtoh
*HD: pwpuhh pwpihh pwpish pwhfh pweih pwothh pwtoh
*DE: pwpuhh pwpihh pwpish pwhfh pweih pwothh pwtoh

*WORKING HOURS BY ACTIVITIES

*All Doctors: wlwh wldph wlidph wleh wlmh wlothh

********************************************************

foreach x of var pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh /// 
				 wlwh wldph wlidph wleh wlmh wlothh {

replace `x'=upper(`x')

ren `x' `x'_comment
gen `x'=regexs(1) if regexm(`x'_comment, "^([0-9]+)$")
replace `x'_comment="" if regexm(`x'_comment, "^([0-9]+)$")

replace `x'=regexs(1) if regexm(`x'_comment, "^([0-9]+)[ ]([A-Z]+[ ]+)")
replace `x'=regexs(1) if regexm(`x'_comment, "^([0-9]+)[ ]([A-Z]+)")

gen a=strmatch(`x'_comment, "*1/2*")

replace `x'=regexs(1) if a==1&regexm(`x'_comment, "^([0-9]+[ ][1][/][2])")
replace `x'=regexs(1) if a==1&regexm(`x'_comment, "^([1][/][2])")
replace `x'=subinstr(`x', "1/2", ".5", .)
replace `x'=subinstr(`x', " ", "", .)
drop a

replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")
replace `x'=string((real(regexs(1))+real(regexs(2)))/2) if `x'==""&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
replace `x'=string((real(regexs(1))+real(regexs(2)))/2) if `x'==""&regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")
replace `x'=string((real(regexs(1))+real(regexs(2)))/2) if `x'==""&regexm(`x'_comment, "^[~]([0-9]+)\-([0-9]+)$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^\-([0-9]+)$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^\-([0-9]+[.][0-9]+)$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^[~]([0-9]+)$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^[~]([0-9]+[.][0-9]+)$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^([0-9]+)H$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^[+][-]([0-9]+)$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^([0-9]+)[.]$")
replace `x'=regexs(1) if `x'==""&regexm(`x'_comment, "^([0-9]+) \((.*)\)$")

replace `x'="0" if `x'==""&`x'_comment=="---"
replace `x'="0" if `x'==""&`x'_comment=="--"
replace `x'="0" if `x'==""&`x'_comment=="-"
replace `x'="0" if `x'==""&`x'_comment=="//"
replace `x'="0" if `x'==""&`x'_comment=="/"
replace `x'="0" if `x'==""&`x'_comment=="\"
replace `x'="0" if `x'==""&`x'_comment=="NIL"
replace `x'="0" if `x'==""&`x'_comment=="N/A"
replace `x'="0" if `x'==""&`x'_comment=="NA"
replace `x'="0" if `x'==""&`x'_comment=="O"
replace `x'="0.5" if `x'==""&`x'_comment==".5"
replace `x'="0" if `x'==""&`x'_comment=="X"
replace `x'="0" if `x'==""&`x'_comment=="NONE"
replace `x'="0" if `x'==""&`x'_comment=="NILL"
replace `x'="0" if `x'==""&`x'_comment=="0-"
replace `x'="1" if `x'==""&`x'_comment=="ONE"
replace `x'="2" if `x'==""&`x'_comment=="TWO"
replace `x'="3" if `x'==""&`x'_comment=="THREE"
replace `x'="4" if `x'==""&`x'_comment=="FOUR"
replace `x'="5" if `x'==""&`x'_comment=="FIVE"
replace `x'="6" if `x'==""&`x'_comment=="SIX"
replace `x'="7" if `x'==""&`x'_comment=="SEVEN"
replace `x'="8" if `x'==""&`x'_comment=="EIGHT"
replace `x'="9" if `x'==""&`x'_comment=="NINE"
replace `x'="10" if `x'==""&`x'_comment=="TEN"
}
*

*change where the '*' to run all lines below
foreach x of var pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
*tab `x'_comment if `x'==""
*list id dtimage `x'_comment pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh pwtoh wlwh if `x'==""&`x'_comment!=""&sdtype==1
*list id dtimage `x'_comment pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh pwtoh if `x'==""&`x'_comment!=""&sdtype==2
*list id `x' `x'_comment if `x'=="" & `x'=="1" & `x'=="0"
list id sdtype dtimage `x'_comment pwpuhh pwpihh pwpish pwhfh pweih pwothh pwtoh wlwh if `x'== . &`x'_comment!=""&(sdtype==3|sdtype==4)
}
*

*Check that following translation all looks ok. otherwise recode

*Place of work variables
foreach x of var pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
list id sdtype dtimage `x' `x'_comment  if `x'_comment!="" & `x'!= `x'_comment & sdtype==1
}
*
foreach x of var pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
list id sdtype dtimage `x' `x'_comment  if `x'_comment!="" & `x'!= `x'_comment & sdtype==2
}
*
foreach x of var pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
list id sdtype source response continue dtimage `x' `x'_comment  if `x'_comment!="" & `x'!= `x'_comment & sdtype==3
}
*
foreach x of var pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
list id sdtype dtimage `x' `x'_comment  if `x'_comment!="" & `x'!= `x'_comment & sdtype==4
}
*

gen hr_flag1 = ""
foreach x of var pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
replace hr_flag1="hr_flag1" if `x'_comment!="" & `x'!= `x'_comment
}
* 
tab hr_flag1
preserve
keep if hr_flag1=="hr_flag1"
keep id sdtype pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh ///
				pwpish_comment  pwchh_comment pwpuhh_comment pwpihh_comment pwhfh_comment pwahs_comment pwgov_comment pweih_comment pwlab_comment pwothh_comment pwtoh_comment ///
				dir4 dir3 
export excel using "L:\Data\Data clean\Wave9\extracts\var_hr\var_hr1.xlsx", firstrow(variables) nolabel replace
restore

*hr_flag1 edits
replace pwothh = 	"1"	 if id == 	518	 & pwothh ==	""	//1.0 (HOME VISITS)                                                
replace pwothh = 	"5"	 if id == 	1027	 & pwothh ==	""	//-5
replace pwothh = 	"0"	 if id == 	2045	 & pwothh ==	""	//PRESENTATION TO GPS, STUDENT, REGISTRATION                       
replace pwpish = 	"-4"	 if id == 	4972	 & pwpish ==	""	//VARIES                                                                                            
replace pwtoh = 	"-4"	 if id == 	4972	 & pwtoh ==	""	//VARIES                                                                              
replace pwothh = 	"10"	 if id == 	6070	 & pwothh ==	""	//GP TRAINING 10                                                   
replace pwchh = 	"0"	 if id == 	20245	 & pwchh ==	"42"	//42 NIL                                      
replace pwtoh = 	"16"	 if id == 	26012	 & pwtoh ==	""	//16 (16 HRS) NOT SURE IF HEADSPACE COUNTS AS PRIVATE ROOMS? I DO WORK PRIVATELY THERE
replace pwpuhh = 	"31"	 if id == 	27104	 & pwpuhh ==	""	//31H 15M                                                   
replace pwpihh = 	"30"	 if id == 	29222	 & pwpihh ==	"60"	//total 60, take average                                                          
replace pwpish = 	"30"	 if id == 	29222	 & pwpish ==	"60"	//total 60, take average                                                          
replace pwothh = 	"3.5"	 if id == 	32437	 & pwothh ==	""	//3.5 COMMUNITY PALLIATIVE CARE                                    
replace pwothh = 	"10"	 if id == 	33066	 & pwothh ==	""	//10 ***                                                           
replace pwpish = 	"46"	 if id == 	35565	 & pwpish ==	"45.5"	//46 45                                                                                             
replace pwchh = 	"5"	 if id == 	35993	 & pwchh ==	""	//5 - SPECIALIST OUTREACH FROM PUBLIC HOSPITAL
replace pweih = 	"5"	 if id == 	35993	 & pweih ==	""	//5 - ACTUALLY TAKES PLACE AT FMC IN MED ED UNIT                        
replace pwpihh = 	"16"	 if id == 	38124	 & pwpihh ==	""	//16 <-                                                     
replace pwpihh = 	"5"	 if id == 	41963	 & pwpihh ==	""	//5 & ON CALL -: 21/24 PER WEEK                             
replace pwpuhh = 	"12"	 if id == 	41963	 & pwpuhh ==	""	//12 & ON CALL -: 42/24 PER  WK                             
replace pwpihh = 	"32"	 if id == 	43518	 & pwpihh ==	""	//65 total, take average
replace pwpuhh = 	"33"	 if id == 	43518	 & pwpuhh ==	""	//65 total, take average
replace pwpuhh = 	"0"	 if id == 	43796	 & pwpuhh ==	"60"	//box scribbled                                                          
replace pwtoh = 	"32"	 if id == 	45122	 & pwtoh ==	""	//32 * THIS IS MY FTE RATHER THAN ACTUAL HOURS WORKED                                 
replace pwothh = 	"0"	 if id == 	58613	 & pwothh ==	"8"	//8 RACGP EXAMINER (TWICE A YEAR), considered not usual                                  
replace pwpuhh = 	"24"	 if id == 	60005	 & pwpuhh ==	""	//(24) (ON CALL)                                            
replace pwpuhh = 	"50"	 if id == 	66271	 & pwpuhh ==	""	//50+                                                       
replace pwhfh = 	"0.5"	 if id == 	68135	 & pwhfh ==	""	//30-45 MIN      
replace pwhfh = 	"4"	 if id == 	68224	 & pwhfh ==	""	//1.30 X 4       
replace pwchh = 	"5"	 if id == 	68224	 & pwchh ==	"1"	//1 X 5                                       
replace pwpish = 	"48"	 if id == 	68224	 & pwpish ==	"08"	//08 X 6                                                                                            
replace pwpihh = 	"6"	 if id == 	68723	 & pwpihh ==	""	//4-8HR                                                     
replace pwahs = 	"8"	 if id == 	71954	 & pwahs ==	""	//7.6 HRS  
replace pwpish = 	"11"	 if id == 	72773	 & pwpish ==	""	//it was 11
replace pwtoh = 	"40"	 if id == 	74464	 & pwtoh ==	""	//40
replace pwpish = 	"48"	 if id == 	74464	 & pwpish ==	""	//48
replace pwtoh = 	"5"	 if id == 	75338	 & pwtoh ==	""	//5-                                                                                  
replace pwpish = 	"20"	 if id == 	80697	 & pwpish ==	"25"	//it was likely 20
replace pwtoh = 	"24"	 if id == 	1000694	 & pwtoh ==	""	//~ 24                                                                                
replace pwothh = 	"12"	 if id == 	1000828	 & pwothh ==	""	//HOME DOCTORS SERVICE 12                                          
replace pwhfh = 	"0.5"	 if id == 	1002799	 & pwhfh ==	""	//1-2 HRS        
replace pwtoh = 	"40"	 if id == 	1003843	 & pwtoh ==	""	//40 & UNPAID OVERTIME                                                                
replace id=1003667999 if id==1003667					//id swapped
replace id=1003667 if id==1004769					//id swapped
replace id=1004769 if id==1003667999					//id swapped



*Work load variables
foreach x of var wlwh wldph wlidph  { 
list id sdtype dtimage `x'_comment wlwh* wldph* wlidph* if `x'==""&`x'_comment!="" 
*list id `x'_comment `x' if `x'_comment~=`x'&`x'!="" & `x'_comment!=""
}

*
foreach x of var wleh wlmh wlothh { 
list id sdtype dtimage `x'_comment wleh* wlmh* wlothh* pwtoh if `x'==""&`x'_comment!="" 
*list id `x'_comment `x' if `x'_comment~=`x'&`x'!="" & `x'_comment!=""
}
*

gen hr_flag2 = ""
foreach x of var wlwh wldph wlidph wleh wlmh wlothh{
replace hr_flag2="hr_flag2" if `x'==""&`x'_comment!=""
}
* 
tab hr_flag2
preserve
keep if hr_flag2=="hr_flag2"
keep id sdtype  wlwh wldph wlidph wleh wlmh wlothh ///
				wlwh_comment wldph_comment wlidph_comment wleh_comment wlmh_comment wlothh_comment ///
				dir4 dir5 
export excel using "L:\Data\Data clean\Wave9\extracts\var_hr\var_hr2.xlsx", firstrow(variables) nolabel replace
restore

*hr_flag2 edits
replace wlwh = 	"60"	 if id == 	4360	 & wlwh ==	""	//MOST RECENT USUAL WEEK 60                                             
replace wlwh = 	"45"	 if id == 	4407	 & wlwh ==	""	//45 10-1 2-5                                                           
replace wlidph = 	"2.5"	 if id == 	6720	 & wlidph ==	""	//2:5
replace wleh = 	"1.5"	 if id == 	14337	 & wleh ==	""	//1.5 CONTINUING MEDICAL EDUCATION                                                    
replace wlwh = 	"69"	 if id == 	20110	 & wlwh ==	"50"	//TOTAL 69                                                 
replace wlmh = 	"0.5"	 if id == 	20700	 & wlmh ==	""	//O.5                                     
replace wlidph = 	"0"	 if id == 	22802	 & wlidph ==	""	//1/4
replace wlmh = 	"0"	 if id == 	22802	 & wlmh ==	""	//1/4
replace wlothh = 	"17"	 if id == 	26132	 & wlothh ==	""	//LAB-17HR                                                 
replace wldph = 	"27"	 if id == 	27104	 & wldph ==	""	//27H.15M                                      
replace wlothh = 	"31"	 if id == 	27104	 & wlothh ==	""	//31H 15M                                                  
replace wldph = 	"28"	 if id == 	29447	 & wldph ==	""	//28 19 HRS OF THIS INCLUDES TEACHING AND ROUND
replace wldph = 	"5.5"	 if id == 	30686	 & wldph ==	""	//-5.5
replace wleh = 	"2.5"	 if id == 	31910	 & wleh ==	""	//wleh+wlmh= 5, take average                                                                                 
replace wlmh = 	"2.5"	 if id == 	31910	 & wlmh ==	""	//wleh+wlmh= 5, take average                                                                                 
replace wlothh = 	"40"	 if id == 	34537	 & wlothh ==	""	//40 ***                                                   
replace wlwh = 	"48"	 if id == 	36429	 & wlwh ==	""	//48 4 1/2 4 3 5 2 1/2 4 1/2 4 6 4 1/2 4 1/2                            
replace wlothh = 	"32"	 if id == 	40913	 & wlothh ==	""	//MEDICOLEGAL 32                                           
replace wlothh = 	"10"	 if id == 	41791	 & wlothh ==	""	//10 @ MORE REPORT WRITING/PREP                            
replace wleh = 	"2"	 if id == 	44035	 & wleh ==	""	//.2
replace wlmh = 	"5"	 if id == 	44035	 & wlmh ==	"0.5"	//.5
replace wleh = 	"3"	 if id == 	45878	 & wleh ==	""	//wlidph+wleh+wlmh=10, take average                 
replace wlmh = 	"3"	 if id == 	45878	 & wlmh ==	""	//wlidph+wleh+wlmh=10, take average                 
replace wlidph = 	"4"	 if id == 	45878	 & wlidph ==	""	//wlidph+wleh+wlmh=10, take average                 
replace wlothh = 	"1"	 if id == 	51770	 & wlothh ==	""	//MEETINGS 1                                               
replace wlwh = 	"60"	 if id == 	52606	 & wlwh ==	""	//60 ?                                                                  
replace wleh = 	"3"	 if id == 	57517	 & wleh ==	""	//AV 3                                                                                
replace wlothh = 	"20"	 if id == 	58964	 & wlothh ==	""	//20 -DIAGNOSTIC                                           
replace wleh = 	"4"	 if id == 	59586	 & wleh ==	""	//4 *I ALSO STUDY 8 HRS A DAY ON WEEKENDS*                                            
replace wleh = 	"0"	 if id == 	60165	 & wleh ==	""	//0 - CONCURRENT OR SPORADIC                                                          
replace wleh = 	"0.25"	 if id == 	62293	 & wleh ==	""	//0.25
replace wlmh = 	"0.25"	 if id == 	62293	 & wlmh ==	""	//0.25
replace wlmh = 	"0.25"	 if id == 	73508	 & wlmh ==	""	//1/4
replace wleh = 	"3"	 if id == 	74256	 & wleh ==	""	//PLUS 2-3-6 ON TOP OF TOTAL HRS                                                      
replace wlmh = 	"17.5"	 if id == 	97661	 & wlmh ==	""	//35 COMMITTEES, POLICY/PROCEDURE MAKING, take average
replace wlothh = 	"17.5"	 if id == 	97661	 & wlothh ==	""	// COMMITTEES POLICY/PROCEDURE MAKING                     
replace wldph = 	"30"	 if id == 	1000519	 & wldph ==	""	//REST                                         
replace wlidph = 	"4"	 if id == 	1001187	 & wlidph ==	""	//4 *** STUDENT ALWAYS
replace wldph = 	"36"	 if id == 	1001187	 & wldph ==	""	//36 *** STUDENT ALWAYS                        
replace wleh = 	"36"	 if id == 	1001187	 & wleh ==	""	//36 *** STUDENT ALWAYS                                                               
replace wleh = 	"1"	 if id == 	1001546	 & wleh ==	""	//01 - EXTRA                                                                          
replace wleh = 	"0.25"	 if id == 	1002144	 & wleh ==	""	//0.25
replace wlidph = 	"0.75"	 if id == 	1002144	 & wlidph ==	""	//0.75
replace wlothh = 	"10"	 if id == 	1002261	 & wlothh ==	""	//10 40 HRS PATIENT CONTACT PRIVATE HOSPITAL               
replace wldph = 	"31"	 if id == 	1002261	 & wldph ==	""	//31 - 40 HRS PATIENT CONTACT                  
replace wleh = 	"1"	 if id == 	1004369	 & wleh ==	""	//< 1                                                                                 
replace wlmh = 	"1"	 if id == 	1004369	 & wlmh ==	""	//< 1   



foreach x of var pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh /// 
				 wlwh wldph wlidph wleh wlmh wlothh {
tab `x'_comment if `x'==""
}
*
foreach x of var pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh /// 
				 wlwh wldph wlidph wleh wlmh wlothh {
tab `x'
destring `x', replace
}
*
***********
* remove outliers

foreach x of var pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh pwtoh {
sort `x'
list id sdtype dtimage pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh pwtoh wlwh `x' if `x'>=100 & `x'!=.
}
*
gen hr_flag3=""
foreach x of var pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
replace hr_flag3 = "hr_flag3" if `x'>=100 & `x'!=. 				 
}
*
tab hr_flag3 response
preserve
keep if hr_flag3=="hr_flag3"
keep id sdtype  response pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh ///
				pwpish_comment  pwchh_comment pwpuhh_comment pwpihh_comment pwhfh_comment pwahs_comment pwgov_comment pweih_comment pwlab_comment pwothh_comment pwtoh_comment ///
				dir4 dir3 
export excel using "L:\Data\Data clean\Wave9\extracts\var_hr\var_hr3.xlsx", firstrow(variables) nolabel replace
restore

*hr_flag3 edits
replace pwtoh = 	45	 if id == 	15002	 & pwtoh ==	452	//cross check, seemed likely a typo
replace pwpuhh = 	-4	 if id == 	34537	 & pwpuhh ==	168	//respondent seemed not to understand the question or not to give a sensible answer
replace pwpihh = 	-4	 if id == 	34537	 & pwpihh ==	120	//respondent seemed not to understand the question or not to give a sensible answer
replace pwpish = 	-4	 if id == 	34537	 & pwpish ==	120	//respondent seemed not to understand the question or not to give a sensible answer
replace pwhfh = 	-4	 if id == 	34537	 & pwhfh ==	0	//respondent seemed not to understand the question or not to give a sensible answer
replace pwlab = 	-4	 if id == 	34537	 & pwlab ==	120	//respondent seemed not to understand the question or not to give a sensible answer
replace pwchh = 	-4	 if id == 	34537	 & pwchh ==	0	//respondent seemed not to understand the question or not to give a sensible answer
replace pwgov = 	-4	 if id == 	34537	 & pwgov ==	0	//respondent seemed not to understand the question or not to give a sensible answer
replace pweih = 	-4	 if id == 	34537	 & pweih ==	0	//respondent seemed not to understand the question or not to give a sensible answer
replace pwothh = 	-4	 if id == 	34537	 & pwothh ==.		//respondent seemed not to understand the question or not to give a sensible answer
replace pwtoh =		-4	 if id ==	34537	 & pwtoh == 70 //respondent seemed not to understand the question or not to give a sensible answer
replace pwtoh = 	-4	 if id == 	37745	 & pwtoh ==	22229	     
replace pwtoh = 	24.5	 if id == 	41388	 & pwtoh ==	243.5	//243.5, cross check, seemed likely a typo
replace pwlab = 	-4	 if id == 	53450	 & pwlab ==	4545	            
replace pwtoh = 	-4	 if id == 	61294	 & pwtoh ==	8012	     
replace pwothh = 	10	 if id == 	71719	 & pwothh ==	110	//looked like a mark


foreach x of var wlwh wldph wlidph wleh wlmh wlothh pwtoh {
list id sdtype dtimage `x' wlwh wldph wlidph wleh wlmh wlothh pwtoh if `x'>=100 & `x'!=.
}
*
gen hr_flag4=""
foreach x of var wlwh wldph wlidph wleh wlmh wlothh pwtoh {
replace hr_flag4 = "hr_flag4" if `x'>=100 & `x'!=. 				 
}
*
tab hr_flag4 
preserve
keep if hr_flag4=="hr_flag4"
keep id sdtype  wlwh wldph wlidph wleh wlmh wlothh pwtoh ///
				wlwh_comment wldph_comment wlidph_comment wleh_comment wlmh_comment wlothh_comment pwtoh_comment ///
				dir4 dir5 
export excel using "L:\Data\Data clean\Wave9\extracts\var_hr\var_hr4.xlsx", firstrow(variables) nolabel replace
restore

*hr_flag4 edits
replace wlwh = 	19	 if id == 	9971	 & wlwh ==	419	//likely 19            
replace wlwh = 	-4	 if id == 	37173	 & wlwh ==	60	//sum more than 168            
replace wldph = 	-4	 if id == 	37173	 & wldph ==	40	//sum more than 168            
replace wlidph = 	-4	 if id == 	37173	 & wlidph ==	150	//sum more than 168            
replace wleh = 	-4	 if id == 	37173	 & wleh ==	10	//sum more than 168            
replace wlmh = 	-4	 if id == 	37173	 & wlmh ==	0	//sum more than 168            
replace wlothh = 	-4	 if id == 	37173	 & wlothh ==	0	//sum more than 168            
replace wldph = 	35	 if id == 	87125	 & wldph ==	3535	//cross check, likely a typo


foreach x of var pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh pwtoh wlwh{
list id sdtype pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh pwtoh pwtoh_comment ///
wlwh wldph wlidph wleh wlmh wlothh wlwh_comment if `x'>=100 & `x'!=. & (response=="Online"|source=="Pilot")
}

*all look ok



**************************************************

*Impute variable equal to zero if the sum equals to pwtoh/wlwh

destring pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh /// 
wlwh wldph wlidph wleh wlmh wlothh, replace

egen pw_gp=rowtotal(pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh) if sdtype==1
egen pw_sp=rowtotal(pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh) if sdtype==2
egen pw_hd=rowtotal(pwpuhh pwpihh pwpish pwhfh pweih pwothh) if sdtype==3
egen pw_de=rowtotal(pwpuhh pwpihh pwpish pwhfh pweih pwothh) if sdtype==4
egen wl_sum=rowtotal(wldph wlidph wleh wlmh wlothh)

foreach x of var pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh {
replace `x'=0 if `x'==.&sdtype==1&pw_gp==pwtoh&pw_gp!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh {
replace `x'=0 if `x'==.&sdtype==2&pw_sp==pwtoh&pw_sp!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var pwpuhh pwpihh pwpish pwhfh pweih pwothh {
replace `x'=0 if `x'==.&sdtype==3&pw_hd==pwtoh&pw_hd!=0&pwtoh!=.&pwtoh!=0
replace `x'=0 if `x'==.&sdtype==4&pw_de==pwtoh&pw_de!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var wldph wlidph wleh wlmh wlothh {
replace `x'=0 if `x'==.&wl_sum==wlwh&wlwh!=.&wl_sum!=0&wl_sum!=.
}

**********************************************************************

*Cross check wlwh and pwtoh

drop pw_gp pw_sp pw_hd pw_de wl_sum

egen pw_gp=rowtotal(pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh) if sdtype==1
egen pw_sp=rowtotal(pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh) if sdtype==2
egen pw_hd=rowtotal(pwpuhh pwpihh pwpish pwhfh pweih pwothh) if sdtype==3
egen pw_de=rowtotal(pwpuhh pwpihh pwpish pwhfh pweih pwothh) if sdtype==4

egen wl_sum=rowtotal(wldph wlidph wleh wlmh wlothh)

tab pwtoh if wlwh==.
tab wlwh if pwtoh==.

replace pwtoh=pw_gp if sdtype==1&pwtoh==.&pw_gp==wlwh&wlwh!=.
replace pwtoh=pw_sp if sdtype==2&pwtoh==.&pw_sp==wlwh&wlwh!=.
replace pwtoh=pw_hd if sdtype==3&pwtoh==.&pw_hd==wlwh&wlwh!=.
replace pwtoh=pw_de if sdtype==4&pwtoh==.&pw_de==wlwh&wlwh!=.

replace wlwh=wl_sum if wlwh==.&pwtoh==wl_sum&pwtoh!=.

replace pwtoh=pw_gp if sdtype==1&pwtoh!=.&pw_gp==wlwh&wlwh!=.
replace pwtoh=pw_sp if sdtype==2&pwtoh!=.&pw_sp==wlwh&wlwh!=.
replace pwtoh=pw_hd if sdtype==3&pwtoh!=.&pw_hd==wlwh&wlwh!=.
replace pwtoh=pw_de if sdtype==4&pwtoh!=.&pw_de==wlwh&wlwh!=.

replace wlwh=wl_sum if wlwh!=.&pwtoh==wl_sum&pwtoh!=.

replace pwtoh=pw_gp if sdtype==1&pw_gp==wl_sum&wl_sum!=.
replace pwtoh=pw_sp if sdtype==2&pw_sp==wl_sum&wl_sum!=.
replace pwtoh=pw_hd if sdtype==3&pw_hd==wl_sum&wl_sum!=.
replace pwtoh=pw_de if sdtype==4&pw_de==wl_sum&wl_sum!=.

replace wlwh=wl_sum if sdtype==1&pw_gp==wl_sum&wl_sum!=.
replace wlwh=wl_sum if sdtype==2&pw_sp==wl_sum&wl_sum!=.
replace wlwh=wl_sum if sdtype==3&pw_hd==wl_sum&wl_sum!=.
replace wlwh=wl_sum if sdtype==4&pw_de==wl_sum&wl_sum!=.

*some drs copy the total from pwpish instead of pwtoh when entering wlwh. The following code deals with this
egen mis_sum = rowtotal(wlwh wlidph wleh wlmh wlothh) if wldph==.&wlwh!=.
gen mismatch=1 if pwtoh==mis_sum&wldph==.&wlwh!=.
replace wldph=wlwh if mismatch==1
replace wlwh=mis_sum if mismatch==1

foreach x of var pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh {
replace `x'=0 if `x'==.&sdtype==1&pw_gp==pwtoh&pw_gp!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh {
replace `x'=0 if `x'==.&sdtype==2&pw_sp==pwtoh&pw_sp!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var pwpuhh pwpihh pwpish pwhfh pweih pwothh {
replace `x'=0 if `x'==.&sdtype==3&pw_hd==pwtoh&pw_hd!=0&pwtoh!=.&pwtoh!=0
replace `x'=0 if `x'==.&sdtype==4&pw_de==pwtoh&pw_de!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var wldph wlidph wleh wlmh wlothh {
replace `x'=0 if `x'==.&wl_sum==wlwh&wlwh!=.&wl_sum!=0&wl_sum!=.
}


*****************************************************************


*check case by case for those wlwh!=pwtoh
***
*Not sure how to amend these cases. They all look sensible though
***

list id dtimage pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh pwtoh wlwh wldph wlidph wleh wlmh wlothh if sdtype==1 & pwtoh != wlwh & pwtoh != . & wlwh != .
/*excerpt from w8
replace pwtoh=40 if id==80408
replace pwothh=1 if id==4358
*/

list id dtimage pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh pwtoh wlwh wldph wlidph wleh wlmh wlothh if sdtype==2&pwtoh!=wlwh&pwtoh!=.&wlwh!=. & dtimage==""
/*excerpt from w8
replace pwtoh=67 if id==56028
replace pwtoh=57 if id==46798
*/

list id dtimage pwpuhh pwpihh pwpish pwhfh pweih pwothh pwtoh wlwh wldph wlidph wleh wlmh wlothh if (sdtype==3|sdtype==4)&pwtoh!=wlwh&pwtoh!=.&wlwh!=.
/*excerpt from w8
replace pwtoh=45 if id==43873
replace wlwh=45 if id==43873
*/


gen hr_flag5=""
replace hr_flag5 = "hr_flag5" if  pwtoh != wlwh & pwtoh != . & wlwh != . 				 
tab hr_flag5 
preserve
keep if hr_flag5=="hr_flag5"
keep id sdtype response dirall   pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh ///
						wlwh wldph wlidph wleh wlmh wlothh
export excel using "L:\Data\Data clean\Wave9\extracts\var_hr\var_hr5.xlsx", firstrow(variables) nolabel replace
restore


*************************************************************
* find cases where pwtoh and wlwh but values are given in constituent variables 
***
*Not sure how to amend these cases. They all look sensible though
***
list id sdtype dtimage pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh pwtoh wlwh wldph wlidph wleh wlmh wlothh if wlwh==0 | pwtoh==0 /*in 7000/8000*/
/*excerpt from w8
replace pwtoh=55 if id==89007
replace pwtoh=38 if id==1000557
*/


gen hr_flag6=""
replace hr_flag6="hr_flag6" if wlwh==0 | pwtoh==0
tab hr_flag6
preserve
keep if hr_flag6=="hr_flag6"
keep id sdtype response dirall   pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh ///
						wlwh wldph wlidph wleh wlmh wlothh
export excel using "L:\Data\Data clean\Wave9\extracts\var_hr\var_hr6.xlsx", firstrow(variables) nolabel replace
restore


*************************************************************

drop pw_gp pw_sp pw_hd pw_de wl_sum mis_sum mismatch

egen pw_gp=rowtotal(pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh) if sdtype==1
egen pw_sp=rowtotal(pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh) if sdtype==2
egen pw_hd=rowtotal(pwpuhh pwpihh pwpish pwhfh pweih pwothh) if sdtype==3
egen pw_de=rowtotal(pwpuhh pwpihh pwpish pwhfh pweih pwothh) if sdtype==4
egen wl_sum=rowtotal(wldph wlidph wleh wlmh wlothh)


*if either pwtoh or wlwh = 0, impute with the other value
replace pwtoh=wlwh if (pwtoh==0|pwtoh==.) & (wlwh>0&wlwh<.)& (pw_gp>0&pw_gp<.) &sdtype==1
replace pwtoh=wlwh if (pwtoh==0|pwtoh==.) & (wlwh>0&wlwh<.)& (pw_sp>0&pw_sp<.) &sdtype==2
replace pwtoh=wlwh if (pwtoh==0|pwtoh==.) & (wlwh>0&wlwh<.)& (pw_hd>0&pw_hd<.) &sdtype==3
replace pwtoh=wlwh if (pwtoh==0|pwtoh==.) & (wlwh>0&wlwh<.)& (pw_de>0&pw_de<.) &sdtype==4

replace wlwh=pwtoh if (wlwh==0|wlwh==.) & (pwtoh>0&pwtoh<.)& (pw_gp>0&pw_gp<.) &sdtype==1
replace wlwh=pwtoh if (wlwh==0|wlwh==.) & (pwtoh>0&pwtoh<.)& (pw_sp>0&pw_sp<.) &sdtype==2
replace wlwh=pwtoh if (wlwh==0|wlwh==.) & (pwtoh>0&pwtoh<.)& (pw_hd>0&pw_hd<.) &sdtype==3
replace wlwh=pwtoh if (wlwh==0|wlwh==.) & (pwtoh>0&pwtoh<.)& (pw_de>0&pw_de<.) &sdtype==4


foreach x of var pwpuhh pwpihh pwpish pwchh pwhfh pwahs pwgov pweih pwothh {
replace `x'=0 if `x'==.&sdtype==1&pw_gp==pwtoh&pw_gp!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var pwpuhh pwpihh pwpish pwchh pwlab pwhfh pwgov pweih pwothh {
replace `x'=0 if `x'==.&sdtype==2&pw_sp==pwtoh&pw_sp!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var pwpuhh pwpihh pwpish pwhfh pweih pwothh {
replace `x'=0 if `x'==.&sdtype==3&pw_hd==pwtoh&pw_hd!=0&pwtoh!=.&pwtoh!=0
replace `x'=0 if `x'==.&sdtype==4&pw_de==pwtoh&pw_de!=0&pwtoh!=.&pwtoh!=0
}

foreach x of var wldph wlidph wleh wlmh wlothh {
replace `x'=0 if `x'==.&wl_sum==wlwh&wlwh!=.&wl_sum!=0&wl_sum!=.
}

drop pw_gp pw_sp pw_hd pw_de wl_sum

***********************************************************

foreach x of var pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh /// 
				 wlwh wldph wlidph wleh wlmh wlothh {
label var `x' 		"Cleaned"
}
*
compress

*
/*test the editings
preserve
gen hr_flag1_t = ""
foreach x of var pwpish  pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
tostring `x', replace force
replace hr_flag1_t="hr_flag1_t" if `x'_comment!="" & `x'!= `x'_comment
}
tab hr_flag1_t
restore

preserve
gen hr_flag2_t = ""
foreach x of var wlwh wldph wlidph wleh wlmh wlothh{
tostring `x', replace force
replace hr_flag2="hr_flag2_t" if `x'==""&`x'_comment!=""
} 
tab hr_flag2_t
restore

preserve
gen hr_flag3_t=""
foreach x of var pwpish pwchh pwpuhh pwpihh pwhfh pwahs pwgov pweih pwlab pwothh pwtoh {
*tostring `x', replace force
replace hr_flag3_t = "hr_flag3_t" if `x'>=100 & `x'!=. 				 
}
tab hr_flag3_t
restore

preserve
gen hr_flag4_t=""
foreach x of var wlwh wldph wlidph wleh wlmh wlothh pwtoh {
replace hr_flag4_t = "hr_flag4_t" if `x'>=100 & `x'!=. 				 
}
tab hr_flag4_t
restore
*/













