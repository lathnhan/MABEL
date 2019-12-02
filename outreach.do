
*Purpose: clean the variables related outreach questions for specialist

********************************************************

global ddtah="D:\Data\Data Clean\Wave9\dtah"
global ddo="D:\Data\Data Clean\Wave9"
global dlog="D:\Data\Data Clean\Wave9\log"

*capture clear
capture log close
set more off

log using "${dlog}\outreach.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

*gltown1 glpc1 gltown2 glpc2 gltown3 glpc3 glnfive  glnpast glnfund


*In Wave 8 remove: glnonm glnloc glnvis glntrav glnpay glnco glnsub glnlead glnreq glngrow glndis glnpers glncomp glnsupp glnlong 
***********************************************************



foreach x of var glnfive glnpast glnfund {
				 			 
gen `x'_comment = regexs(2) if regexm(`x', "^(.*)comment[:](.*)$")
replace `x' = regexs(1) if regexm(`x', "(.*)comment[:](.*)$")
replace `x' = trim(`x')
replace `x'_comment = trim(`x'_comment)
replace `x'_comment = proper(`x'_comment)

replace `x'="" if `x'=="."
replace `x'=itrim(`x')
replace `x'=trim(`x')
replace `x'=proper(`x')
}
*
*There are a few cases with multiple checks
replace glnfive = "-5" if glnfive=="*"
replace glnpast = "-5" if glnpast=="*"

* yes/no questions
foreach x of var glnfive glnpast glnfund {
replace `x' = "0" if `x'=="2" & response=="Online"
list id dtimage `x' `x'_comment if  `x'_comment!=""
}
*

gen out_flag1=""
foreach x of var glnfive glnpast glnfund {
replace out_flag1 = "out_flag1" if  `x'_comment!=""
}
*
preserve
sort id
keep if out_flag1 == "out_flag1"
keep id sdtype response typecont dir8 dir9 glnfive glnpast glnfund glnfive_comment glnpast_comment glnfund_comment 
export excel using "D:\Data\Data Clean\Wave9\extracts\var_out\var_out1.xlsx", firstrow(variables) nolabel replace
restore

***
*out_flag1 edit
***
replace glnfive = 	-2	 if id == 	24803	 & glnfive ==	 ""	//	Living Rural! Annoying Metro Centric Question                        
replace glnpast = 	-2	 if id == 	24803	 & glnpast ==	 ""	//	Same                                   
replace glnpast = 	-2	 if id == 	24847	 & glnpast ==	 ""	//	                                       
replace glnfund = 	-2	 if id == 	26098	 & glnfund ==	 ""	//	                                                        
replace glnfive = 	-3	 if id == 	26456	 & glnfive ==	 ""	//	N/A                                                                  
replace glnpast = 	-3	 if id == 	26456	 & glnpast ==	 ""	//	N/A                                    
replace glnfund = 	-2	 if id == 	28486	 & glnfund ==	 ""	//	Msoap - Not Sure What This Means                        
replace glnfive = 	-2	 if id == 	28705	 & glnfive ==	 ""	//	Rural - Already Do                                                   
replace glnpast = 	-2	 if id == 	28705	 & glnpast ==	 ""	//	Non-Metropolitan - Already Do          
replace glnfund = 	-4	 if id == 	28741	 & glnfund ==	 ""	//	Possibly                                                
replace glnfund = 	-2	 if id == 	31222	 & glnfund ==	 ""	//	                                                        
replace glnfund = 	-2	 if id == 	32382	 & glnfund ==	 ""	//	                                                        
replace glnpast = 	-3	 if id == 	32821	 & glnpast ==	 ""	//	N/A                                    
replace glnfive = 	-2	 if id == 	32821	 & glnfive ==	 ""	//	That'S Where I Work!                                                 
replace glnfive = 	-3	 if id == 	33197	 & glnfive ==	 ""	//	N/A                                                                  
replace glnfund = 	-2	 if id == 	34656	 & glnfund ==	 ""	//	                                                        
replace glnfive = 	-2	 if id == 	35721	 & glnfive ==	 ""	//	I Am Regional!                                                       
replace glnfund = 	-2	 if id == 	35721	 & glnfund ==	 ""	//	                                                        
replace glnfive = 	-2	 if id == 	38741	 & glnfive ==	 ""	//	My Area Is Rural                                                     
replace glnpast = 	-2	 if id == 	38741	 & glnpast ==	 ""	//	My Area Is Rural                       
replace glnfund = 	-2	 if id == 	39934	 & glnfund ==	 ""	//	                                                        
replace glnfund = 	-2	 if id == 	41341	 & glnfund ==	 ""	//	?                                                       
replace glnfive = 	-2	 if id == 	42451	 & glnfive ==	 ""	//	Traralgon Already                                                    
replace glnpast = 	-2	 if id == 	42451	 & glnpast ==	 ""	//	Traralgon Already                      
replace glnpast = 	-3	 if id == 	43151	 & glnpast ==	 ""	//	N/A                                    
replace glnfund = 	0	 if id == 	43151	 & glnfund ==	 ""	//	                                                        
replace glnfund = 	-2	 if id == 	53462	 & glnfund ==	 ""	//	Not Sure                                                
replace glnfive = 	1	 if id == 	57023	 & glnfive ==	 ""	//	As Above                                                             
replace glnpast = 	1	 if id == 	57023	 & glnpast ==	 ""	//	As Above                               
replace glnpast = 	0	 if id == 	59210	 & glnpast ==	 ""	//	No - I Lived There                     
replace glnfive = 	1	 if id == 	59210	 & glnfive ==	 ""	//	Devonport & Launceston Are Both Regional                             
replace glnfund = 	-2	 if id == 	64945	 & glnfund ==	 ""	//	                                                        
replace glnfive = 	-2	 if id == 	72947	 & glnfive ==	 ""	//	I Am Already In A Rural Area.                                        


*Will we replace values in cases where the box wasn't marked but the text implied an answer? - yes
*glyrrs
destring glyrrs, replace force

foreach x of var  glfiw glbl glpfiw glgeo glacsc {
destring `x', replace force
gen `x'2=`x' 
replace `x'2=`x'2-1 if response=="Online"
replace `x'=`x'2
drop `x'2
}
*


*glnyr: not asked in wave 8
*gen glnyr2=glnyr
*destring glnyr, replace force
*list dtimage glnyr glnyr2 id if glnyr==. & glnyr2!=""

*drop glnyr2
foreach x of var gltown1 glpc1 gltown2 glpc2 gltown3 glpc3 glnfive glnpast glnfund  {
destring `x', replace
label var `x' 		"Cleaned"
}
*
save "${ddtah}\temp_all.dta", replace

