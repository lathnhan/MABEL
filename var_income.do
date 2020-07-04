**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: clean the variables related to income
********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


capture log close
set more off

log using "${dlog}\var_income.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

foreach x of var figey finey figef finef fighiy finhiy fighif finhif {

replace `x'=upper(`x')

ren `x' `x'_comment
gen `x'=regexs(1) if regexm(`x'_comment, "^([0-9]+)$")
replace `x'_comment="" if regexm(`x'_comment, "^([0-9]+)$")
replace `x'=`x'_comment if regexm(`x'_comment, "([0-9]+)")

replace `x'=subinstr(`x', "$", "", .)
replace `x'=subinstr(`x', ",", "", .) if regexm(`x', "(,)([0-9][0-9][0-9])")
replace `x'=subinstr(`x', "~", "", .)
replace `x'=subinstr(`x', "-000", "000", .)
replace `x'=subinstr(`x', "-00", "", .)
replace `x'=subinstr(`x', ".000", "000", .)
replace `x'=subinstr(`x', ".00", "", .)
replace `x'=subinstr(`x', ";000", "000", .)
replace `x'=subinstr(`x', ";00", "", .)
replace `x'=subinstr(`x', ":000", "000", .)
replace `x'=subinstr(`x', ":00", "", .)
replace `x'=subinstr(`x', "/000", "000", .)
replace `x'=subinstr(`x', "/00", "", .)
replace `x'=subinstr(`x', "K", "000", .)
replace `x'=subinstr(`x', " 000", "000", .)
replace `x'=subinstr(`x', " 00", "", .)
replace `x'=subinstr(`x', ",000", "000", .)
gen `x'00 = 1 if strmatch(`x'_comment, "*,00")


*replace `x'=subinstr(`x', ",00", "", .)
replace `x'=subinstr(`x', "=000", "000", .)
replace `x'=subinstr(`x', "=00", "", .)
replace `x'=subinstr(`x', "000-", "000", .)
replace `x'=subinstr(`x', "APPROX", "", .)
replace `x'=subinstr(`x', "VARIES", "", .)
replace `x'=subinstr(`x', "+/", "", .)
replace `x'=subinstr(`x', "//", "", .) if regexm(`x', "^[//]")
replace `x'=subinstr(`x', "XX", "", .)
replace `x'=subinstr(`x', "000/", "000 ", .)
replace `x'=subinstr(`x', "000.", "000 ", .)
replace `x'=subinstr(`x', " M", "M", 1) if regexm(`x', "[M]$")
replace `x'=subinstr(`x', "09/10", "", .)
replace `x'=subinstr(`x', "2010/2011", "", .)
replace `x'=subinstr(`x', "//", "", .) if regexm(`x', "[//]$")
replace `x'=subinstr(`x', " THOUSAND", "000", .)
replace `x'=subinstr(`x', " MILLION", "000000", .)
replace `x'=subinstr(`x', " MIL", "000000", .)
replace `x'=subinstr(`x', "ABOUT", "", .)
replace `x'=subinstr(`x', "ROUGHLY", "", .)

replace `x'=string(real(regexs(1))*1000000) if regexm(`x', "^([0-9][.][0-9])[M]$")
replace `x'=string(real(regexs(1))*1000000) if regexm(`x', "([0-9])[MIL]$")
replace `x'=string(real(regexs(1))*1000000) if regexm(`x', "([0-9])[M]$")
replace `x'=string(real(regexs(1))*1000000) if regexm(`x', "([0-9].[0-9]+) MIL*$")
replace `x'=string(real(regexs(1))*1000000) if regexm(`x', "([0-9])[ ][MILLION]$")


gen `x'_1=regexs(1) if regexm(`x', "^([0-9]+)[ ]([0-9]+)$")
gen `x'_2=regexs(2) if regexm(`x', "^([0-9]+)[ ]([0-9]+)$")
replace `x'=string((real(`x'_1)+real(`x'_2))/2) if `x'_1==`x'_2&`x'_1!=""&`x'_2!=""
drop `x'_1 `x'_2

*tammy amended slightly - 17/6/2014
gen `x'_temp1=1 if regexm(`x', "^([0-9]+)\-([0-9]+)$")
replace `x'=string((real(regexs(1))+real(regexs(2)))/2) if regexm(`x', "^([0-9]+)\-([0-9]+)$")
*replace `x'=subinstr(`x', "-", "", .)

gen `x'_temp2=1 if regexm(`x', "[A-Za-z]")
replace `x'=regexs(1) if regexm(`x', "([0-9]+)")

destring `x', replace  
}
*
gen inc_flag1 = ""
foreach x of var figey finey figef finef fighiy finhiy fighif finhif {
replace inc_flag1="inc_flag1" if `x'_temp1==1 | `x'_temp2==1
list id `x' `x'_comment if `x'_temp1==1
list id `x' `x'_comment if `x'_temp2==1
}
*
*check if above code accounts for all text response. If not, amend above code (tt added 17/6/2014)
/*foreach x of var figey finey figef finef fighiy finhiy fighif finhif {
tab1 `x' 
tab1 `x'_comment if `x'==""
}*/

*check translations
gen inc_flag2 = ""
foreach x of var figey finey figef finef {
replace inc_flag2="inc_flag2" if `x'!=. & `x'_comment!="" & `x' != real(`x'_comment)
list id `x' `x'_comment if `x'!=. & `x'_comment!="" & `x' != real(`x'_comment) 
}
*
*recode when value ends in ",00"
gen inc_flag3 = ""
foreach x of var figey finey figef finef fighiy finhiy fighif finhif {
replace inc_flag3 = "inc_flag3" if `x'00==1
list id sdtype `x'00 `x'_comment figey finey figef finef fighiy finhiy fighif finhif wlwh pwtoh if `x'00==1 
}
*
tab1 inc_flag1 inc_flag2 inc_flag3

preserve
sort id
keep if inc_flag1 == "inc_flag1" | inc_flag2 == "inc_flag2" | inc_flag3 == "inc_flag3"
keep id sdtype typecont response inc_flag1 inc_flag2 inc_flag3 dir5 dir6 dir7 dir8 figey finey figef finef fighiy finhiy fighif finhif figey_comment finey_comment figef_comment finef_comment fighiy_comment finhiy_comment fighif_comment finhif_comment
export excel using "L:\Data\Data Clean\Wave9\extracts\var_inc\var_inc1-3.xlsx", firstrow(variables) nolabel replace
restore

*gpc dir7 dir8; gpn dir7 dir8; spc dir6 dir7; spn dir6 dir8; dec dir5; den dir5; hdc dir5 dir6; hdn dir5 dir6
***
*inc_flag1 - inc_flag3 edits
***
replace fighiy = 	325665	 if id == 	518	 & fighiy ==	.	//	                                              
replace finhiy = 	222665	 if id == 	518	 & finhiy ==	.	//	                                                                                                         
replace fighif = 	.	 if id == 	518	 & fighif ==	325665	//	325,665 ANNUAL                                                                                   
replace finhif = 	.	 if id == 	518	 & finhif ==	222665	//	222,665 ANNUAL           
replace fighiy = 	226941	 if id == 	1771	 & fighiy ==	226	//	226.941.00                                    
replace finey = 	200000	 if id == 	1908	 & finey ==	200	//	200,00.00                                                                                            
replace fighiy = 	216898	 if id == 	4034	 & fighiy ==	.	//	similar to q43
replace finhiy = 	72832	 if id == 	4034	 & finhiy ==	.	//	similar to q43
replace finhiy = 	33000	 if id == 	5342	 & finhiy ==	33	//	33,00                                                                                                    
*replace finey = 	84000	 if id == 	5702	 & finey ==	84000	//	                                                                                                     
replace figey = 	-4	 if id == 	5999	 & figey ==	60	//	                                                              
replace fighiy = 	240000	 if id == 	9348	 & fighiy ==	240	//	240
replace fighiy = 	450000	 if id == 	10120	 & fighiy ==	450	//	                                              
replace finhiy = 	300000	 if id == 	10120	 & finhiy ==	300	//	                                                                                                         
replace figey = 	200000	 if id == 	11323	 & figey ==	200	//	200,00                                                        
replace finey = 	150000	 if id == 	11323	 & finey ==	150	//	150,00                                                                                               
replace finey = 	110000	 if id == 	11420	 & finey ==	110	//	$110
replace fighiy = 	400000	 if id == 	11702	 & fighiy ==	.	//	SAME AS 43                                                                                               
replace finhiy = 	100000	 if id == 	11702	 & finhiy ==	43	//	SAME AS 43                                                                                               
replace figey = 	300000	 if id == 	12930	 & figey ==	300	//	300,00, CROSS CHECK HH                                                        
replace fighiy = 	250000	 if id == 	13016	 & fighiy ==	2500	//	2,500
replace finhiy = 	170000	 if id == 	13016	 & finhiy ==	1700	//	1,700
replace fighiy = 	450000	 if id == 	13450	 & fighiy ==	4500000	//	                                              
replace fighiy = 	200000	 if id == 	15873	 & fighiy ==	200	//	$200,00                                       
replace finey = 	180000	 if id == 	16783	 & finey ==	180	//	180,00                                                                                               
replace fighif = 	13500	 if id == 	19000	 & fighif ==	1300014000	//	$13,000-$14,000                                                                                  
*replace fighif = 	.	 if id == 	19515	 & fighif ==	0	//	                                                                                                 
*replace finhif = 	.	 if id == 	19515	 & finhif ==	0	//	                         
*replace fighiy = 	100000	 if id == 	21213	 & fighiy ==	1000000	//	1,000,000
replace finey = 	35000	 if id == 	21370	 & finey ==	35	//	35,00                                                                                                
replace fighiy = 	200000	 if id == 	21459	 & fighiy ==	200	//	200,00                                        
replace figey = 	.	 if id == 	21651	 & figey ==	0	//	DON'T KNOW YET - ONLY WORKED LAST 3/12                        
replace fighiy = 	800000	 if id == 	25215	 & fighiy ==	80000	//	                                              
replace fighiy = 	1500000	 if id == 	26147	 & fighiy ==	15000000	//	15,000,000
*replace figey = 	1000000	 if id == 	26510	 & figey ==	1000000	//	1.000,000                                                     
replace fighiy = 	150000	 if id == 	27104	 & fighiy ==	4	//	AS ABOVE - (WIDOWE4D, NO SPOUSE)              
replace fighiy = 	1000000	 if id == 	27472	 & fighiy ==	1000	//	1000,00                                       
replace finhiy = 	119000	 if id == 	27781	 & finhiy ==	119	//	119,00                                                                                                   
replace fighiy = 	1100000	 if id == 	27907	 & fighiy ==	1	//	1.100,000                                     
replace fighiy = 	1000000	 if id == 	28011	 & fighiy ==	.	//	AS ABOVE                                      
replace finhiy = 	600000	 if id == 	28011	 & finhiy ==	.	//	AS ABOVE                                                                                                 
replace finey = 	630000	 if id == 	28245	 & finey ==	3	//	3O% LESS                                                                                             
replace figey = 	-4	 if id == 	28442	 & figey ==	300000	//	>300,000                                                      
replace finey = 	-4	 if id == 	28442	 & finey ==	300000	//	>300000                                                                                              
replace fighiy = 	-4	 if id == 	28442	 & fighiy ==	500000	//	>500,000                                      
replace finhiy = 	-4	 if id == 	28442	 & finhiy ==	500000	//	>500,000                                                                                                 
replace figey = 	.	 if id == 	28486	 & figey ==	0	//	WORK PART TIME - 2 DAYS PER *** Q - HEALTH - ONE LEVEL FOR TOP
replace finey = 	200000	 if id == 	28627	 & finey ==	200	//	200,00                                                                                               
replace figey = 	-4	 if id == 	28935	 & figey ==	200000	//	>200000                                                       
replace finey = 	-4	 if id == 	28935	 & finey ==	200000	//	>200000                                                                                              
replace fighiy = 	-4	 if id == 	28935	 & fighiy ==	200000	//	>200000                                       
replace finhiy = 	-4	 if id == 	28935	 & finhiy ==	200000	//	>200000                                                                                                  
replace fighiy = 	280000	 if id == 	29424	 & fighiy ==	34	//	SEE 34                                        
replace finhiy = 	160000	 if id == 	29424	 & finhiy ==	34	//	SEE 34                                                                                                   
replace figey = 	-4	 if id == 	29679	 & figey ==	200000	//	200000+                                                       
replace finef = 	-4	 if id == 	29679	 & finef ==	1500	//	                                                   
replace fighiy = 	3000000	 if id == 	30291	 & fighiy ==	0	//	3 MILL                                        
replace finhiy = 	2000000	 if id == 	30291	 & finhiy ==	0	//	2 MILL                                                                                                   
replace finey = 	1060000	 if id == 	30400	 & finey ==	47	//	-47%
replace finhiy = 	1060000	 if id == 	30400	 & finhiy ==	47	//	-47%
replace fighiy = 	-4	 if id == 	30501	 & fighiy ==	1000000	//	>$1,000,000.00                                
replace figey = 	235000	 if id == 	30849	 & figey ==	235	//	$235
replace finey = 	240000	 if id == 	31012	 & finey ==	240	//	$240,00                                                                                              
replace fighiy = 	240000	 if id == 	31012	 & fighiy ==	240	//	$240.00
replace figey = 	1200000	 if id == 	31310	 & figey ==	1	//	1.200.000                                                     
replace finey = 	-4	 if id == 	31347	 & finey ==	1900	//	-1900
replace fighiy = 	1300000	 if id == 	32385	 & fighiy ==	1	//	1.3
replace figey = 	-4	 if id == 	32475	 & figey ==	200000	//	>$200,000                                                     
replace figey = 	.	 if id == 	32821	 & figey ==	23	//	LEVEL 23, WA MEDICAL AWARD                                    
replace figey = 	-4	 if id == 	32990	 & figey ==	300000	//	> 300,000                                                     
replace fighif = 	.	 if id == 	33441	 & fighif ==	5140	//	5140.68
replace finhif = 	5140	 if id == 	33441	 & finhif ==	.	//	                         
replace figey = 	1200000	 if id == 	33495	 & figey ==	1200	//	1200,00                                                       
replace fighiy = 	990000	 if id == 	33582	 & fighiy ==	34	//	AS IN 34                                      
replace finhiy = 	300000	 if id == 	33582	 & finhiy ==	.	//	AS IN 34                                      
replace figey = 	16500	 if id == 	33872	 & figey ==	16	//	//16.500
replace finey = 	10800	 if id == 	33872	 & finey ==	10	//	//10.800
replace figey = 	300000	 if id == 	33914	 & figey ==	300	//	300,00                                                        
replace finhiy = 	200000	 if id == 	33914	 & finhiy ==	200	//	200,00                                                                                                   
replace fighiy = 	1400000	 if id == 	34612	 & fighiy ==	140000	//	1,400,00                                      
replace finhiy = 	330000	 if id == 	35256	 & finhiy ==	330	//	330 00                                                                                                   
replace fighiy = 	329000	 if id == 	35260	 & fighiy ==	329	//	$329,00                                       
replace finhiy = 	168000	 if id == 	35260	 & finhiy ==	168	//	$168,00                                                                                                  
replace figey =		290000	 if id ==	35260	 & figey  ==	29000 //29000
replace finey =		144000	 if id ==	35260	 & finey  ==	144000 //14400
replace finhiy = 	1250000	 if id == 	35497	 & finhiy ==	125000	//	                                                                                                         
replace fighiy = 	.	 if id == 	38077	 & fighiy ==	450000	//	450,000, likely swap
replace finhiy = 	450000	 if id == 	38077	 & finhiy ==	.	//	450,000, likely swap                                                                                                         
replace fighiy = 	1050000	 if id == 	38251	 & fighiy ==	105000	//	105000- HOUSEHOLD INCOME                      
replace finey = 	.	 if id == 	39416	 & finey ==	0	//	                                                                                                     
replace figey = 	200000	 if id == 	40126	 & figey ==	200	//	200,00.00                                                     
replace finey = 	.	 if id == 	41566	 & finey ==	0	//	                                                                                                     
replace fighiy = 	-4	 if id == 	42329	 & fighiy ==	80000	//	<80,000                                       
replace finey = 	257000	 if id == 	42456	 & finey ==	257	//	257,00                                                                                               
replace figey = 	160307	 if id == 	44930	 & figey ==	160	//	160, 307                                                      
replace figey = 	180000	 if id == 	45876	 & figey ==	180	//	$180
replace finey = 	150000	 if id == 	45876	 & finey ==	150	//	$150
replace finey = 	200000	 if id == 	46189	 & finey ==	200	//	200,00.00                                                                                            
replace figey = 	-2	 if id == 	46885	 & figey ==	.	//	I DON'T WANT TO ANSWER THAT                                   
replace finey = 	-2	 if id == 	46885	 & finey ==	.	//	                                                                                                     
replace figef = 	-2	 if id == 	46885	 & figef ==	.	//	                         
replace finef = 	-2	 if id == 	46885	 & finef ==	.	//	                                                   
replace fighiy = 	-2	 if id == 	46885	 & fighiy ==	34	//	SEE ANSWER 34                                 
replace finhiy = 	-2	 if id == 	46885	 & finhiy ==	.	//	                                                                                                         
replace fighif = 	-2	 if id == 	46885	 & fighif ==	.	//	                                                                                                 
replace finhif = 	-2	 if id == 	46885	 & finhif ==	.	//	                         
replace fighif = 	7591	 if id == 	50243	 & fighif ==	7501	//	                                                                                                 
replace figey = 	750000	 if id == 	51239	 & figey ==	400350	//	700-800K                                                      
replace fighiy = 	750000	 if id == 	51239	 & fighiy ==	.	//	SAME AS ABOVE                                 
replace fighiy = 	6500	 if id == 	51311	 & fighiy ==	34	//	AS PER QN 34                                  
replace finhiy = 	3200	 if id == 	51311	 & finhiy ==	.	//	AS PER QN 34                                  
replace fighiy = 	300000	 if id == 	52002	 & fighiy ==	300	//	                                              
replace fighiy = 	230000	 if id == 	52274	 & fighiy ==	230	//	                                              
replace finhiy = 	155000	 if id == 	52274	 & finhiy ==	155	//	~150-160                                                                                                 
replace figey = 	-4	 if id == 	56604	 & figey ==	1	//	$1.6 MILLION PRACTICE EARNINGS                                
replace finey = 	250000	 if id == 	56604	 & finey ==	0	//	MY PERSONAL EARNINGS AFTER TAX & BUSINESS EXP TAKEN OFF $250,000                                     
replace figey = 	223000	 if id == 	56670	 & figey ==	222000000	//	222,000,000
replace fighiy = 	292000	 if id == 	56956	 & fighiy ==	.	//LIKELY SWAP BETWEEN ANNUAL AND FORTNIGHTLY INCOME	                                              
replace finhiy = 	192000	 if id == 	56956	 & finhiy ==	.	//LIKELY SWAP BETWEEN ANNUAL AND FORTNIGHTLY INCOME	                                                                                                         
replace fighif = 	.	 if id == 	56956	 & fighif ==	292000	//	292,000
replace finhif = 	.	 if id == 	56956	 & finhif ==	192000	//	192,000 ROUGHLY SUPERFUND
replace fighiy = 	440000	 if id == 	56974	 & fighiy ==	4	//	4.400000-00                                   
replace fighiy = 	350000	 if id == 	58082	 & fighiy ==	300000	//	$300,000 - $400,000                           
replace fighiy = 	380000	 if id == 	59311	 & fighiy ==	380	//	                                              
replace finhiy = 	220000	 if id == 	59311	 & finhiy ==	220	//	                                                                                                         
replace finhiy = 	450000	 if id == 	59403	 & finhiy ==	450	//	450,00                                                                                                   
replace figey = 	58000	 if id == 	61265	 & figey ==	580	//	580P0, LIKELY A TYPO                                                        
replace fighiy = 	500000	 if id == 	61984	 & fighiy ==	500	//	500,00                                        
replace fighiy = 	.	 if id == 	63142	 & fighiy ==	1	//	1.67
replace fighiy = 	320000	 if id == 	64591	 & fighiy ==	320	//	320,00                                        
replace finey = 	150000	 if id == 	67808	 & finey ==	150	//	150.00
replace fighiy = 	250000	 if id == 	67808	 & fighiy ==	250	//	250.00
replace finhiy = 	150000	 if id == 	67808	 & finhiy ==	150	//	150.00
replace finey = 	-4	 if id == 	69592	 & finey ==	3	//	3 OF SURGEONS I WORKED WITH HAVE RETIRED THIS YEAR!                                                  
replace fighiy = 	490000	 if id == 	71591	 & fighiy ==	43	//	SAME AS Q.43                                  
replace finhiy = 	200000	 if id == 	71591	 & finhiy ==	.	//	SAME AS Q.43                                  
replace finhiy = 	264000	 if id == 	72819	 & finhiy ==	264	//	264,00                                                                                                   
replace figey = 	-3	 if id == 	73145	 & figey ==	6	//	N/A/CONFIDENTIAL SS LEVEL -> 6 YEARS                          
replace finey = 	-3	 if id == 	73145	 & finey ==	.	//	                                                                                                     
replace figef = 	-3	 if id == 	73145	 & figef ==	.	//	                         
replace finef = 	-3	 if id == 	73145	 & finef ==	.	//	                                                   
replace fighiy = 	-3	 if id == 	73145	 & fighiy ==	.	//	N/A                                           
replace finhiy = 	-3	 if id == 	73145	 & finhiy ==	.	//	                                                                                                         
replace fighif = 	-3	 if id == 	73145	 & fighif ==	.	//	                                                                                                 
replace finhif = 	-3	 if id == 	73145	 & finhif ==	.	//	                         
replace figey = 	445000	 if id == 	73180	 & figey ==	445	//	445=00, LIKELY A TYPO                                                        
replace finey = 	240000	 if id == 	73180	 & finey ==	240	//	240=00, LIKELY A TYPO                                                                                               
replace fighiy = 	460000	 if id == 	73180	 & fighiy ==	460	//	460=00, LIKELY A TYPO                                        
replace finhiy = 	255000	 if id == 	73180	 & finhiy ==	255	//	255=00, LIKELY A TYPO                                                                                                   
replace figef = 	15800	 if id == 	73824	 & figef ==	15	//	15 800                   
replace fighif = 	15800	 if id == 	73824	 & fighif ==	15	//	15 800                                                                                           
replace finef = 	4500	 if id == 	75180	 & finef ==	4	//	4.5
replace finhif = 	4326	 if id == 	75180	 & finhif ==	4	//	4.326
replace figey = 	200000	 if id == 	78298	 & figey ==	200	//	200-                                                          
replace fighiy = 	200000	 if id == 	78298	 & fighiy ==	200	//	200-                                          
replace finey = 	111600	 if id == 	78736	 & finey ==	111	//	//111.600
replace figef = 	4166	 if id == 	78736	 & figef ==	4	//	4.166
replace finef = 	2325	 if id == 	78736	 & finef ==	2	//	2.325
replace finhiy = 	111600	 if id == 	78736	 & finhiy ==	111	//	111.6
replace fighif = 	4166	 if id == 	78736	 & fighif ==	4	//	4.166
*replace finhif = 	2325	 if id == 	78736	 & finhif ==	2325	//	                         
*replace figey = 	100000	 if id == 	79321	 & figey ==	100	//	100,00                                                        
*replace fighiy = 	100000	 if id == 	79321	 & fighiy ==	100	//	100,00                                        
replace finef = 	3600	 if id == 	84659	 & finef ==	4600	//	4600 3600                                          
replace fighiy = 	400000	 if id == 	92549	 & fighiy ==	400	//	                                              
replace finhiy = 	250000	 if id == 	92549	 & finhiy ==	250	//	                                                                                                         
replace figef = 	14000	 if id == 	94018	 & figef ==	140	//	14  000                  
replace finef = 	7000	 if id == 	94018	 & finef ==	7	//	7 0 00                                             
replace fighiy = 	300000	 if id == 	96806	 & fighiy ==	300	//	                                              
replace finey = 	185000	 if id == 	97006	 & finey ==	180000190000	//	? 180000-190000                                                                                      
replace finhiy = 	330000	 if id == 	97006	 & finhiy ==	320	//	? 320-340000?                                                                                            
*replace figey = 	.	 if id == 	97602	 & figey ==	80	//	PLEASE SEE Q80                                                
*replace finey = 	.	 if id == 	97602	 & finey ==	.	//	                                                                                                     
*replace figef = 	.	 if id == 	97602	 & figef ==	.	//	                         
*replace finef = 	.	 if id == 	97602	 & finef ==	.	//	                                                   
*replace fighiy = 	.	 if id == 	97602	 & fighiy ==	.	//	                                              
*replace finhiy = 	.	 if id == 	97602	 & finhiy ==	.	//	                                                                                                         
*replace fighif = 	.	 if id == 	97602	 & fighif ==	.	//	                                                                                                 
*replace finhif = 	.	 if id == 	97602	 & finhif ==	.	//	                         
replace fighiy = 	.	 if id == 	99029	 & fighiy ==	0	//	                                              
replace finhiy = 	.	 if id == 	99029	 & finhiy ==	0	//	                                                                                                         
replace fighif = 	.	 if id == 	99029	 & fighif ==	0	//	                                                                                                 
replace finhif = 	.	 if id == 	99029	 & finhif ==	0	//	                         
*replace fighif = 	-4	 if id == 	99168	 & fighif ==	300	//	                                                                                                 
replace fighiy = 	-4	 if id == 	1000597	 & fighiy ==	0	//	D/K > 500000 GROSS                            
replace fighiy = 	155000	 if id == 	1000911	 & fighiy ==	150000160000	//	150000-160000                                 
replace finhiy = 	125000	 if id == 	1000911	 & finhiy ==	120000130000	//	120000-130000                                                                                            
*replace fighiy = 	.	 if id == 	1001061	 & fighiy ==	0	//	                                              
replace figef = 	9000	 if id == 	1001138	 & figef ==	5004	//	8-10K                    
replace fighif = 	14000	 if id == 	1001138	 & fighif ==	1400	//	1,400
replace finef = 	4700	 if id == 	1001532	 & finef ==	4	//	4.7 K (60% OF TOTAL)                               
replace figey = 	-4	 if id == 	1001538	 & figey ==	180000	//	>180000-                                                      
*replace fighiy = 	.	 if id == 	1001538	 & fighiy ==	0	//	0
replace figey = 	165100	 if id == 	1001581	 & figey ==	165	//	165 100                                                       
replace finey = 	101100	 if id == 	1001581	 & finey ==	101	//	101 100                                                                                              
*replace fighiy = 	-4	 if id == 	1001747	 & fighiy ==	12000000	//	$12,000,000
replace finey = 	140000	 if id == 	1001811	 & finey ==	140	//	140
replace finey = 	120000	 if id == 	1001861	 & finey ==	120	//	120,00                                                                                               
replace figef = 	5500	 if id == 	1001874	 & figef ==	5000	//	5K TO 6K                 
replace fighif = 	5500	 if id == 	1001874	 & fighif ==	5	//	5 TO 6K                                                                                          
replace finhif = 	4250	 if id == 	1001874	 & finhif ==	3000	//	3K TO 5.5                
replace finey = 	70000	 if id == 	1002115	 & finey ==	70	//	                                                                                                     
replace finhiy = 	125000	 if id == 	1002128	 & finhiy ==	125	//	                                                                                                         
replace figey = 	-3	 if id == 	1002144	 & figey ==	.	//	N/A PART RETIRED                                              
replace finey = 	-3	 if id == 	1002144	 & finey ==	.	//	N/A PART RETIRED                                                                                     
*replace fighiy = 	.	 if id == 	1002326	 & fighiy ==	0	//	                                              
*replace finhiy = 	.	 if id == 	1002326	 & finhiy ==	0	//	                                                                                                         
replace finey = 	112200	 if id == 	1002392	 & finey ==	49	//	49%TAX,NOT PAID YET                                                                                  
replace finhiy = 	163200	 if id == 	1002392	 & finhiy ==	49	//	49%
replace fighiy = 	120000	 if id == 	1002768	 & fighiy ==	120	//	                                              
replace finhiy = 	90000	 if id == 	1002768	 & finhiy ==	90	//	                                                                                                         
replace figef = 	11500	 if id == 	1002799	 & figef ==	6505	//	10-13,000.00             
replace finef = 	8500	 if id == 	1002799	 & finef ==	5003	//	7-10,000.00                                        
replace fighif = 	12000	 if id == 	1002799	 & fighif ==	7005	//	10-14,000.00                                                                                     
replace finhif = 	8500	 if id == 	1002799	 & finhif ==	50003	//	7-10,0000                
replace fighif = 	3200	 if id == 	1003222	 & fighif ==	.	//	SAME AS NO 42            
replace finhif = 	2300	 if id == 	1003222	 & finhif ==	42	//	SAME AS NO 42            
replace fighiy = 	.	 if id == 	1003577	 & fighiy ==	0	//	                                              
replace finhiy = 	.	 if id == 	1003577	 & finhiy ==	0	//	                                                                                                         
replace fighif = 	.	 if id == 	1003577	 & fighif ==	0	//	                                                                                                 
replace finef = 	.	 if id == 	1003581	 & finef ==	14	//	FIGURES ARE FOR 14-15                              
replace finef = 	1700	 if id == 	1003668	 & finef ==	17000	//	17,000
replace figef = 	2696	 if id == 	1004238	 & figef ==	2	//	2 696                    
replace finef = 	1691	 if id == 	1004238	 & finef ==	1	//	1 691                                              
replace fighiy = 	84773	 if id == 	1004500	 & fighiy ==	24	//	AS PER Q24                                    
replace finhiy = 	64007	 if id == 	1004500	 & finhiy ==	.	//	                                                                                                         
replace figey = 	81000	 if id == 	1005036	 & figey ==	81	//	81,00                                                         
replace finey = 	71000	 if id == 	1005036	 & finey ==	71	//	71,00                                                                                                
replace figef = 	-4	 if id == 	1005238	 & figef ==	3	//	3.5


*replace if above code does not result in correct amount (tt added 17/6/2014)

foreach x of var figey finey figef finef fighiy finhiy fighif finhif {
replace `x'=0 if `x'==.&(`x'_comment=="-0"|`x'_comment=="NIL"|`x'_comment=="ZERO"|`x'_comment=="NONE"|`x'_comment=="O")
replace `x'=-3 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "NA")|strmatch(`x'_comment, "*NOT APPLICABLE*")|strmatch(`x'_comment, "*N/A*"))
replace `x'=-4 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*DO NOT KNOW*")|strmatch(`x'_comment, "*DONT KNOW*")|strmatch(`x'_comment, "DK"))
replace `x'=-4 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*NO IDEA*")|strmatch(`x'_comment, "*DON'T KNOW*")|strmatch(`x'_comment, "NOT SURE"))
replace `x'=-4 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*UNSURE*")|`x'_comment== "?"|strmatch(`x'_comment, "*UNKNOWN*")|`x'_comment== "-")
replace `x'=-2 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*CONFIDENTIAL*")|`x'_comment=="PASS"|strmatch(`x'_comment, "*DECLINE*")|strmatch(`x'_comment, "*DISCLOS*"))
replace `x'=-2 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*PRIVATE*")|strmatch(`x'_comment,"*REFUSE*")|strmatch(`x'_comment, "*WISH*")|strmatch(`x'_comment, "*CHOOSE*"))
replace `x'=-2 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*PREFER NOT*")|strmatch(`x'_comment,"*WILLING*")|strmatch(`x'_comment, "*NOT*")|strmatch(`x'_comment, "*MYOB*"))
replace `x'=-2 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*WANT*")|strmatch(`x'_comment,"*BUSINESS*")|strmatch(`x'_comment, "*NOT*")|strmatch(`x'_comment, "*MYOB*"))
}
*
foreach x of var figey finey figef finef fighiy finhiy fighif finhif {
list dtimage `x' `x'_comment id if `x'==. & `x'_comment!="" 
}
* 
*replace fighiy=450000 if id==38077 // 450,000
*replace fighif=325665 if id==518 // 325,665 ANNUAL
replace fighif=192000 if id==56956 // 292,000
*replace finhif=222665 if id==518 //222,665 ANNUAL
replace finhif=192000 if id==56956 // 192,000 ROUGHLY SUPERFUND

*list id dirall sdtype wlwh wlwhpy figey finey figef finef fighiy finhiy fighif finhif if id==38077 | id==518 | id==56956


replace fighiy=figey if strmatch(fighiy_comment,"* ABOVE") & fighiy==. & figey!=.
replace fighiy=figey if strmatch(fighiy_comment,"A/A") & fighiy==. & figey!=.
replace finhiy=finey if strmatch(finhiy_comment,"* ABOVE") & finhiy==. & finey!=.
replace finhiy=finey if strmatch(finhiy_comment,"A/A") & finhiy==. & finey!=.
replace fighif=figef if strmatch(fighif_comment,"* ABOVE") & fighif==. & figef!=.
replace finhif=finef if strmatch(finhif_comment,"* ABOVE") & finhif==. & finef!=.

*all others are -2
foreach x of var figey finey figef finef {
replace `x'=-2 if `x'==. & `x'_comment!=""  
}
*

********************************************************

*check the validity of the values, make imputation if necessary.

*1. personal gross income less than net income (annual)

list  id figey finey figef finef fighiy finhiy fighif finhif wlwh pwtoh if figey !=. & finey !=. & figey <= finey & figey >= 0 & finey >= 0 

gen inc_flag4 = ""
replace inc_flag4 = "pgr.a<pnt.a" if figey !=. & finey !=. & figey <= finey & figey >= 0 & finey >= 0

*****************************************************

*2. household gross income less than net income (annual)

list figey finey figef finef fighiy finhiy fighif finhif id if fighiy!=.&finhiy!=.&fighiy<=finhiy &fighiy>=0 & finhiy>=0 

gen inc_flag5 = ""
replace inc_flag5 = "hgr.a<hnt.a" if fighiy !=. & finhiy != . & fighiy <= finhiy & fighiy >= 0 & finhiy>=0

*****************************************************

*3. personal gross income less than net income (fortnightly)

list id /*figey finey*/ figef finef /*fighiy finhiy*/ fighif finhif if figef!=.&finef!=.&figef<=finef &finef>0 & figef>0

gen inc_flag6 = ""
replace inc_flag6 = "pgr.f<pnt.f" if figef!=.&finef!=.&figef<=finef &finef>0 & figef>0

*****************************************************

*4. household gross income less than net income (fortnightly)

list id /*figey finey*/ figef finef /*fighiy finhiy*/ fighif finhif if fighif!=.&finhif!=.&fighif<=finhif &finhif>0 &fighif>0 

gen inc_flag7 = ""
replace inc_flag7 = "hgr.f<hnt.f" if fighif!=.&finhif!=.&fighif<=finhif &finhif>0 &fighif>0 

*gen notrightf = 1 if fighif!=.&finhif!=.&fighif<=finhif   //to make sure above aren't listed again
*****************************************************

*5. personal gross income greater than household gross income (annual)

list id figey finey figef finef fighiy finhiy fighif finhif fclp fcpes if figey!=.&fighiy!=.&figey>fighiy 

gen inc_flag8 = ""
replace inc_flag8 = "pgr.a>hgr.a" if figey != . & fighiy != . & figey > fighiy
	
***************************************************************

*6. personal net income greater than household net income (annual)

*gen notright=1 if  figey!=.&fighiy!=.&figey>fighiy   //this means that those listed in part 5 are not listed again here.
list  id figey finey figef finef fighiy finhiy fighif finhif fclp fcpes if finey!=.&finhiy!=.&finey>finhiy 

gen inc_flag9 = ""
replace inc_flag9 = "pnt.a>hnt.a" if finey != . & finhiy != . & finey > finhiy

*replace notright=2 if finey!=.&finhiy!=.&finey>finhiy  //to make sure dont list any of above again

*************************************************************

*7. personal gross income greater than household gross income (fortnightly)

list id figey finey figef finef fighiy finhiy fighif finhif fclp fcpes if figef!=.&fighif!=.&figef>fighif

gen inc_flag10 = ""
replace inc_flag10 = "pgr.f>hgr.f" if figef != . & fighif != . & figef > fighif

************************************************************

*8. personal net income greater than household net income (fortnightly)
*replace notrightf=2 if figef!=.&fighif!=.&figef>fighif & notrightf==. // to make sure above cases are not listed again

list id figey finey figef finef fighiy finhiy fighif finhif fclp fcpes if finef!=.&finhif!=.&finef>finhif  

gen inc_flag11 = ""
replace inc_flag11 = "pnt.f>hnt.f" if finef != . & finhif != . & finef > finhif

************************************************************

*9. check annual numbers are not less than 10,000

foreach x of var figey finey fighiy finhiy {
gen `x'_c=(`x'<10000)
replace `x' = `x' * 1000 if `x'_c==1&`x'<1000&`x'>=50
drop `x'_c
}
*

*foreach x of var figey  finey fighiy finhiy {
*list id figey finey figef finef fighiy finhiy fighif finhif pwtoh fcpes wlwhpy wlmlpy if `x'>0 &`x'<10000 
*}
*
gen inc_flag12 = ""
foreach x of var figey  finey fighiy finhiy {
replace inc_flag12 = "ann<10K" if `x'>0 &`x'<10000 
}
*
****************************************************

*10. check the fortnightly numbers less than 1,000

gen inc_flag13 = ""
foreach x of var figef finef fighif finhif {
list id figey finey figef finef fighiy finhiy fighif finhif fclp fcpes pwtoh sdtype if `x'>0 & `x'<1000 
replace inc_flag13 = "fnt<1K" if `x'>0 & `x'<1000
gen `x'_c=(`x'<1000)
drop `x'_c
}
*

tab1 inc_flag4-inc_flag13

preserve
sort id
keep if inc_flag4 != "" | inc_flag5 != "" | inc_flag6 != "" | inc_flag7 != "" | inc_flag8 != "" | inc_flag9 != "" | ///
		inc_flag10 != "" | inc_flag11 != "" | inc_flag12 != "" | inc_flag13 != ""
tab1 	inc_flag4-inc_flag13 
keep 	id sdtype typecont response wlwh wlwhpy inc_flag4-inc_flag13 dir5 dir6 dir7 dir8 figey finey figef finef fighiy finhiy fighif finhif ///
		figey_comment finey_comment figef_comment finef_comment fighiy_comment finhiy_comment fighif_comment finhif_comment
export excel using "L:\Data\Data Clean\Wave9\extracts\var_inc\var_inc4-13x.xlsx", firstrow(variables) nolabel replace
restore

*list id response sdtype wlwh wlwhpy figey finey figef finef fighiy finhiy fighif finhif if id== 643| id == 	821| id == 	2154| id == 	2502| id == 	6292| id == 	6606| id == 	8893| id == 	9023| id == 	9149| id == 	9248| id == 	10911| id == 	11002| id == 	11108| id == 	12307| id == 	12596| id == 	13171| id == 	13648| id == 	14836| id == 	15370| id == 	19259| id == 	19770| id == 	20492| id == 	20519| id == 	20883| id == 	21483| id == 	22175| id == 	22802| id == 	23709| id == 	23766| id == 	24952| id == 	25045| id == 	25066| id == 	25104| id == 	25640| id == 	26222| id == 	26223| id == 	26243| id == 	26402| id == 	26510| id == 	26559| id == 	26723| id == 	27201| id == 	27844| id == 	28296| id == 	28471| id == 	28785| id == 	28889| id == 	29488| id == 	29755| id == 	29879| id == 	31624| id == 	32467| id == 	34041| id == 	34425| id == 	34583| id == 	34656| id == 	35532| id == 	35982| id == 	36073| id == 	36103| id == 	36527| id == 	36805| id == 	37174| id == 	37963| id == 	38362| id == 	38666| id == 	39934| id == 	40177| id == 	40775| id == 	41304| id == 	41419| id == 	41872| id == 	42000| id == 	42056| id == 	42329| id == 	42965| id == 	43037| id == 	46591| id == 	46789| id == 	49004| id == 	50500| id == 	50907| id == 	51311| id == 	51942| id == 	52181| id == 	52914| id == 	52957| id == 	53042| id == 	53444| id == 	54702| id == 	55202| id == 	55810| id == 	56610| id == 	57418| id == 	58463| id == 	58509| id == 	58639| id == 	58781| id == 	58835| id == 	58914| id == 	59040| id == 	59131| id == 	59903| id == 	59937| id == 	61279| id == 	61790| id == 	63142| id == 	63888| id == 	64737| id == 	65056| id == 	68643| id == 	68660| id == 	69062| id == 	69574| id == 	69843| id == 	70143| id == 	70346| id == 	70618| id == 	70723| id == 	73649| id == 	73984| id == 	75149| id == 	75702| id == 	76489| id == 	76567| id == 	77728| id == 	78914| id == 	82412| id == 	82422| id == 	83375| id == 	87563| id == 	88534| id == 	91204| id == 	92248| id == 	92793| id == 	92834| id == 	93124| id == 	94582| id == 	96172| id == 	96242| id == 	96997| id == 	97191| id == 	97399| id == 	97821| id == 	98627| id == 	99362| id == 	99390| id == 	1000264| id == 	1000574| id == 	1000585| id == 	1000725| id == 	1001116| id == 	1001297| id == 	1001313| id == 	1001332| id == 	1001365| id == 	1001543| id == 	1001747| id == 	1001801| id == 	1001874| id == 	1002023| id == 	1002145| id == 	1002202| id == 	1002289| id == 	1002509| id == 	1002622| id == 	1002637| id == 	1002665| id == 	1003097| id == 	1003258| id == 	1003335| id == 	1003645| id == 	1003672| id == 	1003773| id == 	1003943| id == 	1003989| id == 	1004074| id == 	1004221| id == 	1004581| id == 	1004618| id == 	1004923| id == 	1004946, separator(0)

***
*inc_flag4-inc_flag13 edits
***
replace finhiy = 	35000	 if id == 	643	 & finhiy ==	3500	//	                               
replace finhiy = 	420000	 if id == 	821	 & finhiy ==	4200000	//	                               
replace figef = 	6000	 if id == 	2154	 & figef ==	600	//	                 
replace finef = 	5500	 if id == 	2154	 & finef ==	550	//	                                    
replace fighif = 	-4	 if id == 	2502	 & fighif ==	1100	//	               
replace finhif = 	-4	 if id == 	2502	 & finhif ==	1700	//	                         
replace finey = 	-2	 if id == 	6292	 & finey ==	-4	//	DON'T KNOW                                 
replace fighiy = 	-2	 if id == 	6292	 & fighiy ==	-4	//	DON'T KNOW & WOULDN'T SAY IF I DID              
replace figey = 	250000	 if id == 	6606	 & figey ==	260000	//	260,000, look likely 250000
replace fighiy = 	150000	 if id == 	8893	 & fighiy ==	15000	//	                                                
replace finhiy = 	140000	 if id == 	9023	 & finhiy ==	14000	//	                               
*replace figey = 	-4	 if id == 	9149	 & figey ==	10000	//	                                                
*replace finey = 	-4	 if id == 	9149	 & finey ==	10000	//	                                           
replace fighiy = 	300000	 if id == 	9149	 & fighiy ==	250000	//	250,000, likely swap
replace finhiy = 	250000	 if id == 	9149	 & finhiy ==	300000	//	300,000, likely swap
replace finhiy = 	150000	 if id == 	9248	 & finhiy ==	15000	//	                               
replace finey = 	90000	 if id == 	10911	 & finey ==	900000	//	$900,000
replace finhiy = 	120000	 if id == 	11002	 & finhiy ==	12000	//	                               
replace finey = 	91330	 if id == 	11108	 & finey ==	9133	//	                                           
replace figey = 	60000	 if id == 	12307	 & figey ==	6000	//	6,000.00
replace finey = 	40000	 if id == 	12307	 & finey ==	4000	//	4,000.00
replace figey = 	160000	 if id == 	12596	 & figey ==	16000	//	                                                
*replace figey = 	.	 if id == 	13171	 & figey ==	0	//	                                                
*replace finey = 	.	 if id == 	13171	 & finey ==	0	//	                                           
*replace figef = 	2500	 if id == 	13648	 & figef ==	250	//	                 
*replace finef = 	2500	 if id == 	13648	 & finef ==	250	//	                                    
replace figey = 	230000	 if id == 	14836	 & figey ==	23000	//	                                                
replace finhiy = 	400000	 if id == 	15370	 & finhiy ==	40000	//	                               
replace finhiy = 	170000	 if id == 	19259	 & finhiy ==	70000	//	                               
replace fighiy = 	.	 if id == 	19770	 & fighiy ==	0	//	                                                
replace finhiy = 	217000	 if id == 	20492	 & finhiy ==	21700	//	                               
replace fighiy = 	75435	 if id == 	20519	 & fighiy ==	45435	//	                                                
replace figey = 	250000	 if id == 	20883	 & figey ==	25000	//	                                                
replace finey = 	-4	 if id == 	21483	 & finey ==	200000	//	PLUS 200K TO FAMILY TRUST - IE WIFES INCOME
*replace finhiy = 	-3	 if id == 	22175	 & finhiy ==	.	//	                               
*replace fighiy = 	500000	 if id == 	22802	 & fighiy ==	50000	//
replace figey = 500 if id == 22082 & figey == 500000
replace finey = 400 if id == 22082 & finey == 400000
*replace fighiy = 	-4	 if id == 	23709	 & fighiy ==	125000	//	                                                
replace finhiy = 	-4	 if id == 	23709	 & finhiy ==	425000	//	entry heavily scribbled                               
replace figey = 	98000	 if id == 	23766	 & figey ==	9800	//	                                                
replace finey = 	63000	 if id == 	23766	 & finey ==	6300	//	                                           
replace fighiy = 	380000	 if id == 	24952	 & fighiy ==	300000	//	                                                
*replace fighiy = 	320000	 if id == 	25045	 & fighiy ==	320000	//	                                                
replace fighiy = 	650000	 if id == 	25066	 & fighiy ==	6500	//	                                                
replace finhiy = 	270000	 if id == 	25104	 & finhiy ==	220000	//	                               
replace finey = 	800000	 if id == 	25640	 & finey ==	8000000	//	                                           
replace figey = 	103000	 if id == 	26222	 & figey ==	10300	//	10,300
replace finey = 	90000	 if id == 	26222	 & finey ==	9000	//	                                           
replace fighiy = 	200000	 if id == 	26223	 & fighiy ==	20000	//	                                                
*replace figey = 	-4	 if id == 	26243	 & figey ==	0	//	                                                
*replace finey = 	-4	 if id == 	26243	 & finey ==	0	//	                                           
replace fighiy = 	260000	 if id == 	26402	 & fighiy ==	26000	//	                                                
*replace figey = 	100000	 if id == 	26510	 & figey ==	1000000	//	1.000,000                                       
replace fighiy = 	400000	 if id == 	26559	 & fighiy ==	40000	//	                                                
replace finhiy = 	200000	 if id == 	26559	 & finhiy ==	20000	//	                               
replace fighiy = 	100000	 if id == 	26723	 & fighiy ==	10000	//	                                                
*replace finhiy = 	-4	 if id == 	26723	 & finhiy ==	60000	//	                               
replace figey = 	1500000	 if id == 	27201	 & figey ==	15000000	//	                                                
replace finhiy = 	120000	 if id == 	27844	 & finhiy ==	12000	//	                               
replace finey = 	.	 if id == 	28296	 & finey ==	3	//implausible value
replace finhiy = 	.	 if id == 	28296	 & finhiy ==	4	//implausible value                    
replace finey = 	70000	 if id == 	28471	 & finey ==	700000	//	                                           
replace figef = 	8000	 if id == 	28785	 & figef ==	48000	//	48000 FORTNIGHTLY, it's 8000
replace finhif = 	9400	 if id == 	28889	 & finhif ==	94000	//	                         
replace finey = 	300000	 if id == 	29488	 & finey ==	400000	//	likely 300000                                           
replace fighiy = 	358000	 if id == 	29755	 & fighiy ==	355000	//	                                                
replace figey = 	250000	 if id == 	29879	 & figey ==	450000	//	450,000
replace fighiy = 	-4	 if id == 	31624	 & fighiy ==	-2	//	NOT PREPARED TO DISCLOSE                        
replace finhiy = 	-4	 if id == 	31624	 & finhiy ==	-2	//	NOT PREPARED TO DISCLOSE       
replace figey = 	-4	 if id == 	32467	 & figey ==	1	//	                                                
replace finey = 	-4	 if id == 	32467	 & finey ==	1	//	                                           
replace figef = 	-4	 if id == 	32467	 & figef ==	1	//	                 
replace finef = 	-4	 if id == 	32467	 & finef ==	1	//	                                    
replace fighiy = 	-4	 if id == 	32467	 & fighiy ==	1	//	                                                
replace finhiy = 	-4	 if id == 	32467	 & finhiy ==	1	//	                               
replace fighif = 	-4	 if id == 	32467	 & fighif ==	1	//	               
replace finhif = 	-4	 if id == 	32467	 & finhif ==	1	//	                         
replace fighiy = 	320000	 if id == 	34041	 & fighiy ==	32000	//	                                                
replace figef = 	8597	 if id == 	34425	 & figef ==	.	//likely swap
replace finey = 	.		 if id==	34425	 & finey == 8597 //likely swap	                 
replace fighiy = 	420000	 if id == 	34583	 & fighiy ==	350000	//likely swap                                       
replace finhiy = 	350000	 if id == 	34583	 & finhiy ==	420000	//likely swap
replace figey = 	80000	 if id == 	34656	 & figey ==	20000	//	                                                
replace finey = 	140000	 if id == 	35532	 & finey ==	190000	//	190,000, look likely 140000
replace fighiy = 	495000	 if id == 	35982	 & fighiy ==	49500	//	                                                
replace finhiy = 	148335	 if id == 	36073	 & finhiy ==	48335	//	$48,335, it was 148,335
replace fighiy = 	465000	 if id == 	36103	 & fighiy ==	46500	//	                                                
*replace finey = 	-4	 if id == 	36527	 & finey ==	4000	//	                                           
replace finhiy = 	195000	 if id == 	36805	 & finhiy ==	19500	//	                               
replace fighiy = 	290000	 if id == 	37174	 & fighiy ==	240000	//likely swap
replace finhiy = 	240000	 if id == 	37174	 & finhiy ==	290000	//likely swap                      
replace fighiy = 	333142	 if id == 	37963	 & fighiy ==	33142	//likely typo
replace figey = 	202656	 if id == 	38362	 & figey ==	262656	//	                                                
replace figey = 	600000	 if id == 	38666	 & figey ==	6000000	//redundant 0
replace fighiy = 	1700000	 if id == 	39934	 & fighiy ==	1200000	//	                                                
replace fighiy = 	500000	 if id == 	40177	 & fighiy ==	50000	//	                                                
*replace figey = 	500000	 if id == 	40775	 & figey ==	1500000	//	                                                
replace finey = 	.	 if id == 	41304	 & finey ==	2	//	                                           
replace figey = 	323794	 if id == 	41419	 & figey ==	3323794	//likely typo                                                
replace finhiy = 	-3	 if id == 	41872	 & finhiy ==	.	//	                               
replace fighif = 	-3	 if id == 	41872	 & fighif ==	.	//	               
replace finhif = 	-3	 if id == 	41872	 & finhif ==	.	//	                         
replace finey = 	220000	 if id == 	42000	 & finey ==	2000000	//	                                           
replace figey = 	310000	 if id == 	42056	 & figey ==	10000	//	                                                
replace fighiy = 	580000	 if id == 	42329	 & fighiy ==	-4	//	<80,000, it's 5, not <
replace figey = 	.	 if id == 	42965	 & figey ==	0	//	                                                
replace fighiy = 	160000	 if id == 	43037	 & fighiy ==	16000	//	                                                
replace finhiy = 	100000	 if id == 	43037	 & finhiy ==	10000	//	                               
*replace figef = 	8000	 if id == 	46591	 & figef ==	800	//	800
replace figey = 	30000	 if id == 	46789	 & figey ==	300000	//	                                                
*replace figef = 	8000	 if id == 	49004	 & figef ==	800	//	                 
replace fighiy = 	250000	 if id == 	50500	 & fighiy ==	25000	//	                                                
replace finhiy = 	125000	 if id == 	50500	 & finhiy ==	25000	//	                               
replace finef = 	15000	 if id == 	50907	 & finef ==	1500	//	                 
replace fighiy =	.		 if id ==	51311	 & fighiy == 6500 //likely swap
replace finhiy=		.		 if id ==	51311	 & finhiy == 3200 //likely swap
replace fighif = 	6500	 if id == 	51311	 & fighif ==	.	//likely swap	               
replace finhif = 	3200	 if id == 	51311	 & finhif ==	.	//likely swap	                         
replace figey = 	150000	 if id == 	51942	 & figey ==	15000	//likely swap	                                                
replace figef = 	13000	 if id == 	52181	 & figef ==	130000	//	                 
replace fighiy = 	180000	 if id == 	52914	 & fighiy ==	18000	//	                                                
replace fighif = 	13500	 if id == 	52957	 & fighif ==	13	//	13 500         
replace finhif = 	7500	 if id == 	52957	 & finhif ==	7	//	7 500                    
replace finey = 	.	 if id == 	53042	 & finey ==	1	//	                                           
replace finhiy = 	320000	 if id == 	53444	 & finhiy ==	32000	//	                               
replace figey = 	1300000	 if id == 	54702	 & figey ==	1800000	//	                                                
replace figey = 	200000	 if id == 	55202	 & figey ==	20000	//	                                                
replace finey = 	900000	 if id == 	55810	 & finey ==	9000000	//	                                           
replace fighif = 	18000	 if id == 	56610	 & fighif ==	10000	//likely swap
replace finhif = 	10000	 if id == 	56610	 & finhif ==	18000	//likely swap	                         
replace fighiy = 	400000	 if id == 	57418	 & fighiy ==	40000	//	                                                
replace finef = 	4500	 if id == 	58463	 & finef ==	45000	//	45,000
replace fighiy = 	-3	 if id == 	58509	 & fighiy ==	.	//	                                                
replace fighif = 	-3	 if id == 	58509	 & fighif ==	.	//	               
replace finhif = 	-3	 if id == 	58509	 & finhif ==	.	//	                         
replace finey = 	40000	 if id == 	58639	 & finey ==	40	//	                                           
replace fighif = 	6450	 if id == 	58781	 & fighif ==	645	//	645
replace finhif = 	-4	 if id == 	58781	 & finhif ==	645	//	645
*replace finhiy = 	-3	 if id == 	58835	 & finhiy ==	.	//	                               

****************************************************

replace figey = 	1500000	 if id == 	58914	 & figey ==	1	//	1.5 MILLION                                     
replace fighiy = 	1500000	 if id == 	58914	 & fighiy ==	1	//	$1.5 MILLION.                                   
replace fighif = 	16500	 if id == 	59040	 & fighif ==	6500	//	               
replace figef = 	13000	 if id == 	59131	 & figef ==	6500	//likely swap	                 
replace finef = 	6500	 if id == 	59131	 & finef ==	13000	//likely swap	                                    
replace fighif = 	15000	 if id == 	59131	 & fighif ==	9000	//likely swap	               
replace finhif = 	9000	 if id == 	59131	 & finhif ==	15000	//likely swap	                         
*replace fighiy = 	200000	 if id == 	59903	 & fighiy ==	20000	//	                                                
replace fighif = 	16900	 if id == 	59937	 & fighif ==	6900	//	               
*replace fighiy = 	290000	 if id == 	61279	 & fighiy ==	29000	//	                                                
replace fighiy = 	1300000	 if id == 	61790	 & fighiy ==	130000	//	                                                
replace finhiy = 	913000	 if id == 	61790	 & finhiy ==	97300	//	                               
replace fighiy = 	1670000	 if id == 	63142	 & fighiy ==	-4	//	1.67
replace fighif = 	14000	 if id == 	63888	 & fighif ==	14	//	               
replace fighiy = 	440000	 if id == 	64737	 & fighiy ==	44000	//	                                                
replace figey = 	325000	 if id == 	65056	 & figey ==	355000	//	                                                
replace fighiy = 	400000	 if id == 	68643	 & fighiy ==	40000	//	                                                
replace finey = 	.	 if id == 	68660	 & finey ==	2	//	                                           
replace finhiy = 	.	 if id == 	68660	 & finhiy ==	2	//	                               
replace figef = 	9500	 if id == 	69062	 & figef ==	19500	//	                 
replace fighif = 	10100	 if id == 	69574	 & fighif ==	1010	//	               
replace fighiy = 	.	 if id == 	69843	 & fighiy ==	0	//	                                                
replace finhiy = 	.	 if id == 	69843	 & finhiy ==	0	//	                               
replace finhiy = 	120000	 if id == 	70143	 & finhiy ==	12000	//	                               
replace finef = 	5500	 if id == 	70346	 & finef ==	55000	//	                                    
replace figef = 	4490	 if id == 	70618	 & figef ==	.	//likely swap
replace finef = 	3200	 if id == 	70618	 & finef ==	.	//likely swap	                                    
replace figey = 	.	 if id == 	70618	 & figey ==	4490	//likely swap        
replace finey = 	.	 if id == 	70618	 & finey ==	3200	//likely swap	                                    
replace figey = 	120000	 if id == 	70723	 & figey ==	12000	//	                                                
replace finey = 	235000	 if id == 	73649	 & finey ==	2350000	//	                                           
replace fighiy = 	750000	 if id == 	73984	 & fighiy ==	75000	//	                                                
replace finhiy = 	450000	 if id == 	73984	 & finhiy ==	45000	//	                               
replace finey = 	65000	 if id == 	75149	 & finey ==	6500	//	                                           
replace finhiy = 	65000	 if id == 	75149	 & finhiy ==	6500	//	                               
replace fighiy = 	250000	 if id == 	75702	 & fighiy ==	200000	//	200000,00                                       
replace fighiy = 	165000	 if id == 	76489	 & fighiy ==	150000	//likely swap	                                                
replace finhiy = 	150000	 if id == 	76489	 & finhiy ==	165000	//likely swap	                               
replace figey = 	95000	 if id == 	76489	 & figey ==	85000	//likely swap                                   
replace finey = 	85000	 if id == 	76489	 & finey ==	95000	//likely swap                      
replace figey = 	120000	 if id == 	76567	 & figey ==	12000	//	                                                
replace finey = 	80000	 if id == 	77728	 & finey ==	800000	//	                                           
replace finhiy = 	90000	 if id == 	78914	 & finhiy ==	900000	//	                               
replace figey = 	110000	 if id == 	82412	 & figey ==	11000	//	                                                
replace figey = 	.	 if id == 	82422	 & figey ==	14	//	                                                
replace fighiy = 	-4	 if id == 	83375	 & fighiy ==	0	//	                                                
replace finhiy = 	-4	 if id == 	83375	 & finhiy ==	0	//	                               
replace fighif = 	-4	 if id == 	83375	 & fighif ==	0	//	               
replace finhif = 	-4	 if id == 	83375	 & finhif ==	0	//	                         
replace figey = 	100000	 if id == 	87563	 & figey ==	1000	//	                                                
replace finhiy = 	-2	 if id == 	88534	 & finhiy ==	.	//	                               
replace fighif = 	-2	 if id == 	88534	 & fighif ==	.	//	               
replace finhif = 	-2	 if id == 	88534	 & finhif ==	.	//	                         
replace fighiy = 	120000	 if id == 	91204	 & fighiy ==	12000	//	                                                
replace figey = 	110000	 if id == 	92248	 & figey ==	11000	//	                                                
replace finhiy = 	110000	 if id == 	92248	 & finhiy ==	11000	//	                               
*replace fighiy = 	125000	 if id == 	92793	 & fighiy ==	12500	//	                                                
*replace finhiy = 	100000	 if id == 	92793	 & finhiy ==	10000	//	                               
replace figey = 	-4	 if id == 	92834	 & figey ==	59680	//	                                                
replace finey = 	-4	 if id == 	92834	 & finey ==	66000	//	                                           
replace fighiy = 	100000	 if id == 	93124	 & fighiy ==	10000	//	                                                
*replace figey = 	123000	 if id == 	94582	 & figey ==	12300	//	                                                
replace fighif = 	-4	 if id == 	96172	 & fighif ==	0	//	               
replace finhif = 	-4	 if id == 	96172	 & finhif ==	0	//	                         
replace finhiy = 	160000	 if id == 	96242	 & finhiy ==	16000	//	                               
replace finhiy = 	350000	 if id == 	96997	 & finhiy ==	35000	//	                               
replace fighiy = 	150000	 if id == 	97191	 & fighiy ==	15000	//	                                                
replace fighiy = 	-4	 if id == 	97399	 & fighiy ==	0	//	                                                
replace finhiy = 	-4	 if id == 	97399	 & finhiy ==	0	//	                               
*replace fighif = 	-4	 if id == 	97821	 & fighif ==	0	//	               
*replace finhif = 	-4	 if id == 	97821	 & finhif ==	0	//	                         
replace finhiy = 	80000	 if id == 	98627	 & finhiy ==	800000	//	800000
*replace figey = 	150000	 if id == 	99362	 & figey ==	1500000	//	                                                
*replace figef = 	4000	 if id == 	99390	 & figef ==	4	//	                 
replace fighif = 	10500	 if id == 	1000264	 & fighif ==	7500	//likely swap	               
replace finhif = 	7500	 if id == 	1000264	 & finhif ==	10500	//likely swap                 
replace fighiy = 	220000	 if id == 	1000574	 & fighiy ==	22000	//	                                                
replace figey = 	113000	 if id == 	1000585	 & figey ==	1130000	//	                                                
replace figey = 	99000	 if id == 	1000725	 & figey ==	80000	//likely swap	                                                
replace finey = 	80000	 if id == 	1000725	 & finey ==	99000	//likely swap	                                           
replace fighiy = 	150000	 if id == 	1000725	 & fighiy ==	120000	//likely swap	                                                
replace finhiy = 	120000	 if id == 	1000725	 & finhiy ==	150000	//likely swap                      
replace figey = 	.	 if id == 	1001116	 & figey ==	0	//	                                                
replace finey = 	.	 if id == 	1001116	 & finey ==	0	//	                                           
*replace fighiy = 	-4	 if id == 	1001297	 & fighiy ==	0	//	                                                
replace fighiy = 	130000	 if id == 	1001313	 & fighiy ==	13000	//	                                                
replace fighiy = 	120000	 if id == 	1001332	 & fighiy ==	12000	//	                                                
replace figey = 	1210	 if id ==	1001365	 & figey ==		2240 //look likely 1210
replace finhif = 	1000	 if id == 	1001365	 & finhif ==	1500	//	                         
replace fighiy = 	-4	 if id == 	1001543	 & fighiy ==	29739	//	                                                
replace finhiy = 	-4	 if id == 	1001543	 & finhiy ==	34380	//	                               
replace fighiy = 	1200000	 if id == 	1001747	 & fighiy ==	-4	//	$12,000,000
replace finhif = 	3500	 if id == 	1001801	 & finhif ==	3	//	3.5
replace finef = 	4500	 if id == 	1001874	 & finef ==	4500000	//	4500K                               
replace fighif = 	.	 if id == 	1002023	 & fighif ==	0	//	               
replace finhif = 	8500	 if id == 	1002145	 & finhif ==	85000	//	                         
replace fighiy = 	-4	 if id == 	1002202	 & fighiy ==	0	//	                                                
replace finhiy = 	-4	 if id == 	1002202	 & finhiy ==	0	//	                               
replace figey = 	200000	 if id == 	1002289	 & figey ==	20000	//	                                                
replace figey = 	144000	 if id == 	1002509	 & figey ==	12000	//	$12000/MONTHLY                                  
replace finey = 	108000	 if id == 	1002509	 & finey ==	9000	//	$9000/MONTHLY                              
replace fighif = 	-4	 if id == 	1002622	 & fighif ==	10	//implausible	               
replace finhif = 	-4	 if id == 	1002622	 & finhif ==	10	//implausible	                         
replace finhiy = 	150000	 if id == 	1002637	 & finhiy ==	15000	//	                               
replace finey =		.		 if id ==	1002665	 & finey == 6644 //likely swap
replace figef = 	6644	 if id == 	1002665	 & figef ==	.	//likely swap       
replace fighiy = 	180000	 if id == 	1003097	 & fighiy ==	18000	//	                                                
replace fighiy = 	.	 if id == 	1003258	 & fighiy ==	0	//	                                                
replace finhiy = 	.	 if id == 	1003258	 & finhiy ==	0	//	                               
replace figef = 	-4	 if id == 	1003335	 & figey ==	4000	//respondent seemed not to understand the question and/or not to respond properly
replace finef = 	-4	 if id == 	1003335	 & finef ==	120	//respondent seemed not to understand the question and/or not to respond properly
replace fighiy = 	-4	 if id == 	1003335	 & fighiy ==	80000	//respondent seemed not to understand the question and/or not to respond properly
replace finhiy = 	-4	 if id == 	1003335	 & finhiy ==	9000	//respondent seemed not to understand the question and/or not to respond properly
replace finhiy = 	120000	 if id == 	1003645	 & finhiy ==	12000	//	                               
replace fighif = 	9000	 if id == 	1003672	 & fighif ==	7500	//likely swap	               
replace finhif = 	7500	 if id == 	1003672	 & finhif ==	9000	//likely swap                
replace fighif = 	.	 if id == 	1003773	 & fighif ==	0	//	               
replace finhif = 	.	 if id == 	1003773	 & finhif ==	0	//	                         
replace finhiy = 	110000	 if id == 	1003943	 & finhiy ==	11000	//	                               
replace fighiy = 	150000	 if id == 	1003989	 & fighiy ==	15000	//	                                                
replace finhif = 	2194	 if id == 	1004074	 & finhif ==	2914	//corrected after checking with individual income	                         
replace figey = . 			 if id ==   1004221	 & figey ==		2900 //likely swap
replace finey = . 			 if id ==   1004221	 & finey ==		1800 //likely swap
replace figef = 	2900	 if id == 	1004221	 & figef ==	.	//likely swap        
replace finef = 	1800	 if id == 	1004221	 & finef ==	.	//likely swap                           
replace fighiy = . 			 if id ==   1004221	 & fighiy ==		2900 //likely swap
replace finhiy = . 			 if id ==   1004221	 & finhiy ==		1800 //likely swap
replace fighif = 	2900	 if id == 	1004221	 & fighif ==	.	//likely swap          
replace finhif = 	1800	 if id == 	1004221	 & finhif ==	.	//likely swap                
replace figey = 	.	 if id == 	1004581	 & figey ==	2588	//likely swap	                 
replace figef = 	.	 if id == 	1004581	 & figef ==	1620	//likely swap	                                    
replace figef = 	2588	 if id == 	1004581	 & figef ==	.	//likely swap
replace finef = 	1620	 if id == 	1004581	 & finef ==	.	//likely swap	                                    
replace figey = 	100000	 if id == 	1004618	 & figey ==	10000 //	                                                
replace figey = 	.	 	if id == 	1004923	 & figey ==	3437 //likely swap	                 
replace figef = 	.	 if id == 	1004923	 & figef ==	2107 //likely swap	                                    
replace figef = 	3437	 if id == 	1004923	 & figef ==	.	//likely swap
replace finef = 	2107	 if id == 	1004923	 & finef ==	.	//likely swap                           
replace figey = 	70000	 if id == 	1004946	 & figey ==	50000	//likely swap
replace finey = 	50000	 if id == 	1004946	 & finey ==	70000	//likely swap                                  


**************************************************

*11. impute household income if only reported partner's and other income

*used fioti in the past - now this has been replaced by fisadd
destring fclp, replace
destring fcpes, replace

replace fighiy = figey if (fighiy==0|fighiy==.)&figey!=.&(fisadd==0|fisadd==.)&(fclp==0|(fclp==1&fcpes!=2&fcpes!=3))
replace finhiy = finey if (finhiy==0|finhiy==.)&finey!=.&(fisadd==0|fisadd==.)&(fclp==0|(fclp==1&fcpes!=2&fcpes!=3))
replace fighif = figef if (fighif==0|fighif==.)&figef!=.&(fisadd==0|fisadd==.)&(fclp==0|(fclp==1&fcpes!=2&fcpes!=3))
replace finhif = finef if (finhif==0|finhif==.)&finef!=.&(fisadd==0|fisadd==.)&(fclp==0|(fclp==1&fcpes!=2&fcpes!=3))

**************************************************

*12. before tax income is too much higher than after tax income

gen ratio1=figey/finey if figey!=.&finey!=.
gen ratio2=figef/finef if figef!=.&finef!=.
gen ratio3=fighiy/finhiy if fighiy!=.&finhiy!=.
gen ratio4=fighif/finhif if fighif!=.&finhif!=.

foreach x of num 1/4 {
list id figey finey figef finef fighiy finhiy fighif finhif wlwhpy fcpes pwtoh if ratio`x'>=5&ratio`x'!=. 
drop ratio`x'
}
*

********************************************************

*13. household income is too much higher than personal income (annual/fortnightly)

gen ratio1=fighiy/figey if fighiy!=.&figey!=.
gen ratio2=finhiy/finey if finhiy!=.&finey!=.
gen ratio3=fighif/figef if fighif!=.&figef!=.
gen ratio4=finhif/finef if finhif!=.&finef!=.

gen inc_flag14 = ""
foreach x of num 1/4 {
list id figey finey figef finef fighiy finhiy fighif finhif fisadd wlwhpy fcpes pwtoh sdtype if ratio`x'>=10&ratio`x'!=. 
replace inc_flag14 = "inc_flag14" if ratio`x' >= 10 & ratio`x' != .
}
*


*14. check hourly rate, correct if it is too small or too big

gen hour=pwtoh
replace hour=wlwh if (hour==.|hour<0)&wlwh>=0&wlwh!=.
replace hour=. if hour<0


gen wkswrkd=int(52-(wlwhpy+wlmlpy+(wlsdpy/7)+(wlotpy/7))) if (wlwhpy>=0 & wlmlpy>=0 & wlsdpy>=0 & wlotpy>=0)
gen rate1=figey/(hour*wkswrkd) if figey!=.&hour!=. &figey>0
gen rate2=finey/(hour*wkswrkd) if finey!=.&hour!=. & finey>0
gen rate3=figef/(hour*2) if figef!=.&hour!=. &figef>0
gen rate4=finef/(hour*2) if finef!=.&hour!=. &finef>0

gen inc_flag15 = ""
foreach x of num 1/4 {
list sdtype dtimage hour rate`x' id figey finey figef finef fighiy finhiy fighif finhif  fcpes if rate`x'<=20
replace inc_flag15 = "inc_flag15" if rate`x'<=20 
}
*
tab1 inc_flag14 inc_flag15

preserve
sort id
keep if inc_flag14 != "" | inc_flag15 != "" 
tab1 	inc_flag14 inc_flag15 
keep 	id sdtype typecont response inc_flag14 inc_flag15 dir5 dir6 dir7 dir8 figey finey figef finef fighiy finhiy fighif finhif ///
		figey_comment finey_comment figef_comment finef_comment fighiy_comment finhiy_comment fighif_comment finhif_comment ///
		fisadd wlwhpy fcpes pwtoh hour rate1 rate2 rate3 rate4 
export excel using "L:\Data\Data Clean\Wave9\extracts\var_inc\var_inc14-15.xlsx", firstrow(variables) nolabel replace
restore

***
*inc_flag14 - inc_flag15 edits
***
replace fighiy = 	1060000	 if id == 	1341	 & fighiy ==	11060000	//value was	1,060,000
*replace figey = 	300000	 if id == 	3610	 & figey ==	30000	//	           
*replace figey = 	380000	 if id == 	3921	 & figey ==	38000	//	38,000 - **********REVIEW AND AMEND******
replace finhiy = 	40000	 if id == 	4633	 & finhiy ==	400000	//	                           
*replace figey = 	140000	 if id == 	5808	 & figey ==	14000	//	           
*replace figey = 	250000	 if id == 	7137	 & figey ==	25000	//	           
*replace finey = 	230000	 if id == 	7137	 & finey ==	23000	//	                           
*replace figey = 	500000	 if id == 	8084	 & figey ==	50000	//	           
*replace finey = 	400000	 if id == 	8084	 & finey ==	40000	//	                           
replace finey = 	220000	 if id == 	8354	 & finey ==	22000	//	                           
replace finey = 	100000	 if id == 	8545	 & finey ==	1000	//	                           
*replace finhiy = 	127000	 if id == 	8545	 & finhiy ==	27000	//	          
replace fighiy = 	700000	 if id == 	9200	 & fighiy ==	7000000	//	                
replace figey = 	360000	 if id == 	10825	 & figey ==	36000	//	           
replace fighiy = 	80000	 if id == 	11886	 & fighiy ==	800000	//	           
replace finhiy = 	45000	 if id == 	11886	 & finhiy ==	450000	//	                           
*replace figey = 	182000	 if id == 	12229	 & figey ==	18200	//	           
*replace finey = 	182000	 if id == 	12229	 & finey ==	8200	//	                           
*replace fighiy = 	200000	 if id == 	12229	 & fighiy ==	20000	//	                
*replace finhiy = 	200000	 if id == 	12229	 & finhiy ==	20000	//	          
*replace figey = 	350000	 if id == 	13910	 & figey ==	35000	//	           
*replace finey = 	200000	 if id == 	13910	 & finey ==	20000	//	                           
*replace figey = 	600000	 if id == 	18121	 & figey ==	60000	//	60,000
*replace finey = 	350000	 if id == 	18121	 & finey ==	35000	//	35,000
*replace figey = 	300000	 if id == 	20734	 & figey ==	30000	//	30,000
*replace fighif = 	5500	 if id == 	21915	 & fighif ==	55000	//	       
replace figey = 	140000	 if id == 	22016	 & figey ==	14000	//	           
replace finey = 	100000	 if id == 	22016	 & finey ==	10000	//	                           
replace figey = 	180000	 if id == 	22385	 & figey ==	18000	//	           
replace finey = 	145000	 if id == 	22385	 & finey ==	14500	//	                           
*replace figey = 	500000	 if id == 	22825	 & figey ==	50000	//	           
*replace finey = 	250000	 if id == 	22825	 & finey ==	25000	//	                           
*replace figey = 	650000	 if id == 	24003	 & figey ==	65000	//	           
replace figey = 	200000	 if id == 	24089	 & figey ==	20000	//	           
replace finey = 	150000	 if id == 	24089	 & finey ==	15000	//	                           
replace finey = 	220000	 if id == 	24128	 & finey ==	22000	//	                           
*replace figey = 	250000	 if id == 	24150	 & figey ==	25000	//	           
*replace fighiy = 	360000	 if id == 	24811	 & fighiy ==	3600000	//	$3,600,000
replace fighiy = 	1400000	 if id == 	25410	 & fighiy ==	14000000	//	                
replace fighiy = 	100000	 if id == 	27472	 & fighiy ==	1000000	//	1000,00         
replace finey = 	250000	 if id == 	27520	 & finey ==	25000	//	                           
replace figey = 	129000	 if id == 	28854	 & figey ==	12900	//	           
replace fighiy = 	129000	 if id == 	28854	 & fighiy ==	12900	//	                
*replace figey = 	300000	 if id == 	29564	 & figey ==	30000	//	           
replace figey = 	270000	 if id == 	30851	 & figey ==	27000	//	           
replace finey = 	270000	 if id == 	30851	 & finey ==	27000	//	                           
*replace finey = 	.	 if id == 	34425	 & finey ==	8597	//	                           
replace figey = 	290000	 if id == 	35260	 & figey ==	29000	//	           
replace finey = 	144000	 if id == 	35260	 & finey ==	14400	//	                           
replace fighiy = 	700000	 if id == 	38002	 & fighiy ==	7000000	//	                
replace finhiy = 	400000	 if id == 	38002	 & finhiy ==	4000000	//	          
replace finey = 	200000	 if id == 	39341	 & finey ==	20000	//	                           
replace fighiy = 	260000	 if id == 	41015	 & fighiy ==	2600000	//	2,600,000
replace figey = 	280000	 if id == 	42624	 & figey ==	28000	//	28,000
replace finey = 	180000	 if id == 	42624	 & finey ==	18000	//	18,000
replace figey = 	250000	 if id == 	43461	 & figey ==	25000	//	           
replace finey = 	130000	 if id == 	43461	 & finey ==	13000	//	                           
replace finey = 	250000	 if id == 	44005	 & finey ==	25000	//	25000?                     
replace finey = 	108000	 if id == 	45541	 & finey ==	10800	//	                           
replace fighif = 	12000	 if id == 	50905	 & fighif ==	120000	//	       
replace finey = 	400000	 if id == 	53256	 & finey ==	40000	//	                           
*replace figey = 	500000	 if id == 	53432	 & figey ==	50000	//	           
replace figey = 	400000	 if id == 	53572	 & figey ==	40000	//	           
replace fighiy = 	500000	 if id == 	55651	 & fighiy ==	5000000	//	                
*replace figey = 	500000	 if id == 	56529	 & figey ==	50000	//	50 000     
replace finey = 	240000	 if id == 	58740	 & finey ==	24000	//	                           
replace figey = 	500000	 if id == 	58777	 & figey ==	50000	//	           
replace fighiy = 	110000	 if id == 	60082	 & fighiy ==	.	//likely swap
replace finhiy = 	90000	 if id == 	60082	 & finhiy ==	.	//likely swap	       
replace fighif = 	.	 if id == 	60082	 & fighif ==	110000	//likely swap
replace finhif = 	.	 if id == 	60082	 & finhif ==	90000	//likely swap
replace finef = 	15000	 if id == 	60321	 & finef ==	1500	//	       
replace figey = 	130000	 if id == 	60475	 & figey ==	13000	//	           
replace finey = 	100000	 if id == 	63788	 & finey ==	10000	//	                           
replace finey = 	330000	 if id == 	64893	 & finey ==	33000	//	                           
replace figef = 	14000	 if id == 	65323	 & figef ==	1400	//	1400
replace fighif = 	14000	 if id == 	65323	 & fighif ==	1400	//	       
replace figey = 	.	 if id == 	65742	 & figey ==	5445	//likely swap
replace finey = 	.	 if id == 	65742	 & finey ==	3576	//likely swap	                           
replace figef = 	5445	 if id == 	65742	 & figef ==	.	//likely swap
replace finef = 	3576	 if id == 	65742	 & finef ==	.	//likely swap
replace fighiy = 	128000	 if id == 	66426	 & fighiy ==	.	//likely swap   
replace finhiy = 	80000	 if id == 	66426	 & finhif ==	.	//likely swap
replace fighif = 	.	 if id == 	66426	 & fighif ==	128000	//likely swap  
replace finhif = 	.	 if id == 	66426	 & finhif ==	80000	//likely swap
replace finey = 	120000	 if id == 	69688	 & finey ==	12000	//	                           
replace figey = 	.	 if id == 	70618	 & figey ==	4490	//	           
replace finey = 	.	 if id == 	70618	 & finey ==	3200	//	                           
replace fighiy = 	450000	 if id == 	71522	 & fighiy ==	4500000	//	                
replace figey = 	340000	 if id == 	73336	 & figey ==	34000	//	           
replace finey = 	220000	 if id == 	73336	 & finey ==	22000	//	                           
********************************************
replace figey = 	190000	 if id == 	74782	 & figey ==	19000	//	           
replace finey = 	130000	 if id == 	74782	 & finey ==	13000	//	                           
replace fighif = 	18000	 if id == 	75332	 & fighif ==	180000	//	       
replace fighiy = 	170000	 if id == 	82297	 & fighiy ==	1700000	//	                
replace figey = 	600000	 if id == 	84907	 & figey ==	60000	//	           
replace finey = 	480000	 if id == 	84907	 & finey ==	48000	//	                           
replace fighiy = 	350000	 if id == 	84957	 & fighiy ==	3500000	//	                
replace fighif = 	10400	 if id == 	88292	 & fighif ==	104000	//	       
replace finhif = 	6800	 if id == 	88292	 & finhif ==	68000	//	       
replace fighif = 	13000	 if id == 	89967	 & fighif ==	130000	//	       
replace finhif = 	10000	 if id == 	89967	 & finhif ==	100000	//	       
replace fighiy = 	365000	 if id == 	90961	 & fighiy ==	3650000	//	                
replace figef = 	15000	 if id == 	91375	 & figef ==	1500	//	1500
replace finef = 	10000	 if id == 	91375	 & finef ==	1000	//	1000
replace fighif = 	20000	 if id == 	91375	 & fighif ==	2000	//	2000
replace finhif = 	13000	 if id == 	91375	 & finhif ==	1300	//	1300
replace figef = 	25000	 if id == 	92981	 & figef ==	2500	//	       
replace finef = 	20000	 if id == 	92981	 & finef ==	2000	//	       
replace fighif = 	25000	 if id == 	92981	 & fighif ==	2500	//	       
replace finhif = 	20000	 if id == 	92981	 & finhif ==	2000	//	       
replace figef = 	20000	 if id == 	94164	 & figef ==	2000	//	       
replace finef = 	15000	 if id == 	94164	 & finef ==	1500	//	       
replace fighif = 	30000	 if id == 	94164	 & fighif ==	3000	//	       
replace finhif = 	22000	 if id == 	94164	 & finhif ==	2200	//	       
replace finey = 	180000	 if id == 	97003	 & finey ==	18000	//	                           
replace finef = 	18000	 if id == 	97131	 & finef ==	1800	//	       
replace finhif = 	18000	 if id == 	97131	 & finhif ==	1800	//	       
replace fighif = 	13000	 if id == 	98369	 & fighif ==	130000	//	       
replace finhif = 	8500	 if id == 	98369	 & finhif ==	85000	//	       
replace figef = 	30000	 if id == 	98693	 & figef ==	3000	//	       
replace finef = 	20000	 if id == 	98693	 & finef ==	2000	//	       
replace fighif = 	40000	 if id == 	98693	 & fighif ==	4000	//	       
replace finhif = 	30000	 if id == 	98693	 & finhif ==	3000	//	       
replace fighiy = 	200000	 if id == 	1000549	 & fighiy ==	2000000	//	                
replace figef = 	25000	 if id == 	1000813	 & figef ==	2500	//	       
replace finef = 	18000	 if id == 	1000813	 & finef ==	1800	//	       
replace figey = 	110000	 if id == 	1001434	 & figey ==	11000	//	           
replace fighiy = 	110000	 if id == 	1001434	 & fighiy ==	11000	//	                
replace finef = 	8000	 if id == 	1002045	 & finef ==	800	//	       
replace finey = 	-4	 if id == 	1002261	 & finey ==	35033	//	35033 39392 ROOM RENTAL 37%
replace finhiy = 	273000	 if id == 	1002345	 & finhiy ==	2763000	//	          
replace figey = 	290000	 if id == 	1002385	 & figey ==	29000	//	           
replace fighiy = 	540000	 if id == 	1002385	 & fighiy ==	54000	//	                
replace finey = 	.	 if id == 	1002665	 & finey ==	6644	//	                           
replace fighiy = 	300000	 if id == 	1003700	 & fighiy ==	.	//	                
replace finhiy = 	280000	 if id == 	1003700	 & finhiy ==	.	//	          
replace fighif = 	.	 if id == 	1003700	 & fighif ==	300000	//	       
replace finhif = 	.	 if id == 	1003700	 & finhif ==	280000	//	       
replace fighif = 	.	 if id == 	1003749	 & fighif ==	2000	//	       
replace finhif = 	.	 if id == 	1003749	 & finhif ==	1200	//	       
replace figey = 	-4	 if id == 	1004221	 & figey ==	2900	//	           
replace finey = 	-4	 if id == 	1004221	 & finey ==	1800	//	                           
replace fighiy = 	-4	 if id == 	1004221	 & fighiy ==	2900	//	                
replace finhiy = 	-4	 if id == 	1004221	 & finhiy ==	1800	//	          
replace fighif = 	2200	 if id == 	1004478	 & fighif ==	.	//	SINGLE HOUSEHOLD
replace finhif = 	1300	 if id == 	1004478	 & finhif ==	.	//	SINGLE HOUSEHOLD
replace figey = 	.	 if id == 	1004581	 & figey ==	2588	//	2588.74
replace finey = 	.	 if id == 	1004581	 & finey ==	1620	//	                           
replace figey = 	.	 if id == 	1004923	 & figey ==	3437	//	3437.41
replace finey = 	.	 if id == 	1004923	 & finey ==	2107	//	2107.66
replace finey = 	110000	 if id == 	1005243	 & finey ==	11000	//	                           
replace finhiy = 	150000	 if id == 	1005243	 & finhiy ==	15000	//	          



drop ratio1 ratio2 ratio3 ratio4 hour rate1 rate2 rate3 rate4 figey_temp1 figey_temp2 finey_temp* figef_temp* finef_temp* fighiy_temp* finhiy_temp* fighif_temp* finhif_temp*

********************************************************

*Correct fortnightly income if too big
list dirall response id sdtype figey finey figef finef fighiy finhiy fighif finhif if figef>80000 & figef!=. 

list dirall response id sdtype figey finey figef finef fighiy finhiy fighif finhif if (finef==0| finef>45000) &finef!=. 

list response id sdtype pwtoh wkswrkd figey finey figef finef fighiy finhiy fighif finhif fisadd fcpes if fighif==5| fighif==700|(fighif>90000&fighif!=.) 


gen inc_flag16 = ""
replace inc_flag16 = "inc_flag16" if (figef>80000 & figef != .) | ((finef==0 | finef>45000) & finef != .) | (fighif>90000&fighif!=.)
tab inc_flag16

*only a few cases so do direct editings
replace figef = 8835 if id == 7849
replace figef = -4 if id == 39307
replace figef = . if id == 57359
replace figey = 115713 if id == 57359
replace figey = 327194 if id == 1004200
replace finey = 232194 if id == 1004200  
replace figef = .   if id == 1004200 
replace finef = .   if id == 1004200
replace fighiy = 327194   if id == 1004200
replace finhiy = 232194   if id == 1004200
replace fighif = .  if id == 1004200
replace finhif = .  if id == 1004200


replace fighiy=fighif if (fighiy==.|fighiy<0)&fighif>50000&fighif!=.
replace finhiy=finhif if (finhiy==.|finhiy<0)&finhif>50000&finhif!=.
replace fighif=. if fighif>50000&fighif!=.
replace finhif=. if finhif>50000&finhif!=.

list id sdtype pwtoh wkswrkd figey finey figef finef fighiy finhiy fighif finhif fisadd fcpes if figef>40000 & figef!=. 

replace figef = 5800 if id == 15802


*clean fisadd

list response sdtype dirall fisadd figey finey figef finef fighiy finhiy fighif finhif fcpes id if fisadd>fighiy & fighiy!=. & fighiy>0 & fisadd!=.

replace fisadd = 56000 if id == 8464
replace fighiy = 150000 if id == 8799
replace fisadd = 15000 if id == 26570
replace fisadd = 22000 if id == 39774
replace fisadd = 20000 if id == 41015
replace fisadd = 52000 if id == 71591
replace fisadd = 32000 if id == 1000009


drop wkswrkd
compress
************************************************************

foreach x of var figey finey figef finef fighiy finhiy fighif finhif {
label var `x' 		"Cleaned"
}
*

save "${ddtah}\\temp_all.dta", replace
