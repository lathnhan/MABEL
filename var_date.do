**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: clean the variables related date/year/month


****************************pwnwmf****************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

*capture clear
capture log close
set more off

log using "${dlog}\var_date.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

*List of all variables cleaned in this section

*Date of year: pwsyr jsbsyr pirsyr pireyr piyrb picmd pifayr pifryr
*Date of year/month: pwsmth/pwsyr
*Pair of year/month: pwwmth/pwwyr, glmth/glyr, pindyr/pindmt
*Year: ficsyr glyrrs fcpr
*Pair of day/week: wlww/wlwd
*Day: wlwy wlwod wlsdpy wlotpy
*Week: wlwhpy wlmlpy

********************************************************
*date survey was received
*online date
destring date, replace
format date %td
*extraentry hardcopy date: not applicable in wave 9 since extra responses were sent to Datatime
*destring dateextra, replace 
*format dateextra %td

gen date3 = date(dtrcvd, "DMY")
format date3 %td

*combine dates	
*replace date=dateextra if date==.
replace date=date3 if date==.
format date %td
drop  /*dateextra*/ date3 dtrcvd

*pwsyr/pwsmth
ren pwsyr pwsyr_comment
ren pwsmth pwsmth_comment

replace pwsmth_comment=upper(pwsmth_comment)

foreach x of var pwsyr pwsmth {
replace `x'= subinstr(`x', "~", "", .)
replace `x' = subinstr(`x', "?", "", .)
replace `x'= subinstr(`x', "`", "", .)
replace `x'= subinstr(`x', "+-", "", .)
replace `x'= subinstr(`x', "ABOUT", "", .)
replace `x'= subinstr(`x', "APPROX", "", .)
replace `x'= subinstr(`x', "AROUND", "", .)
}

gen pwsyr=real(regexs(1)) if regexm(pwsyr_comment, "^([0-9][0-9][0-9][0-9])$")
gen year="20"+ pwsyr_comment  if real(pwsyr_comment)<16
gen year2 =real(regexs(1)) if regexm(year, "^([0-9][0-9][0-9][0-9])$")
replace pwsyr=year2 if pwsyr==. & year2!=.
drop year2 year
replace pwsyr_comment=trim(pwsyr_comment)
replace pwsyr=real(regexs(1)) if regexm(pwsmth_comment, "([0-9][0-9][0-9][0-9])")
replace pwsyr=real(regexs(1)) if regexm(pwsyr_comment, "([0-9][0-9][0-9][0-9])")
gen pwsmth=real(regexs(1)) if regexm(pwsmth_comment, "^([0-9][0-9]|[0-9])$")

replace pwsyr=2016-real(pwsyr_comment) if regexm(pwsyr_comment, "^([0-9]+)$")& pwsyr==.

replace pwsmth=1 if strmatch(pwsmth_comment,"*JAN*")|pwsmth_comment=="JANUARY"
replace pwsmth=2 if strmatch(pwsmth_comment,"*FEB*")|pwsmth_comment=="FEBRUARY"
replace pwsmth=3 if strmatch(pwsmth_comment,"*MAR*")|pwsmth_comment=="MARCH"
replace pwsmth=4 if strmatch(pwsmth_comment,"*APR*")|pwsmth_comment=="APRIL"
replace pwsmth=5 if strmatch(pwsmth_comment,"*MAY*")
replace pwsmth=6 if strmatch(pwsmth_comment,"*JUN*")|pwsmth_comment=="JUNE"
replace pwsmth=7 if strmatch(pwsmth_comment,"*JUL*")|pwsmth_comment=="JULY"
replace pwsmth=8 if strmatch(pwsmth_comment,"*AUG*")|pwsmth_comment=="AUGUST"
replace pwsmth=9 if strmatch(pwsmth_comment,"*SEP*")|pwsmth_comment=="SEPTEMBER"
replace pwsmth=10 if strmatch(pwsmth_comment,"*OCT*")|pwsmth_comment=="OCTOBER"
replace pwsmth=11 if strmatch(pwsmth_comment,"*NOV*")|pwsmth_comment=="NOVEMBER"
replace pwsmth=12 if strmatch(pwsmth_comment,"*DEC*")|pwsmth_comment=="DECEMBER"

foreach x of var pwsyr pwsmth {
replace `x'=-3 if `x'_comment=="NA"|`x'_comment=="N/A" & `x'==.
}
*
replace pwsmth=6 if pwsmth==. & pwsyr>3 &pwsyr<.


*list date dtimage pwsmth pwsmth_comment pwsyr pwsyr_comment id if (pwsmth==.&pwsmth_comment!="") |(pwsyr==.&pwsyr_comment!="") in 1/3000
list id sdtype date pwsmth pwsmth_comment pwsyr pwsyr_comment if (pwsmth==.&pwsmth_comment!="") | (pwsyr == . & pwsyr_comment !="")
*count if (pwsmth==.&pwsmth_comment!="") | (pwsyr == . & pwsyr_comment !="")
gen date_flag1 = ""
replace date_flag1 = "date_flag1" if (pwsmth==.&pwsmth_comment!="") | (pwsyr == . & pwsyr_comment !="")
tab date_flag1

*estimate month if dr says eg 4 years ago - need to have value for month

list id sdtype date dtimage pwsmth pwsmth_comment pwsyr pwsyr_comment if pwsyr !=. & pwsmth == .
gen date_flag2 = ""
replace date_flag2 = "date_flag2" if pwsyr !=. & pwsmth == .
tab date_flag2

*if no value given then assume it is june
replace pwsmth=6 if pwsmth==. & pwsmth_comment=="" & pwsyr!=.
	
*list all incorrect month/year

list id sdtype dtimage date piyrb pwsmth pwsmth_comment pwsyr pwsyr_comment if pwsyr < 1980 | (pwsyr > 2015 & pwsyr != .) | pwsmth==0 | (pwsmth >12 & pwsmth != .)
gen date_flag3 = ""
replace date_flag3 = "date_flag3" if pwsyr < 1980 | (pwsyr > 2015 & pwsyr != .) | pwsmth==0 | (pwsmth >12 & pwsmth != .)
tab date_flag3


list date piyrb pwsmth pwsmth_comment pwsyr pwsyr_comment id if pwsmth != . & pwsyr==. 
gen date_flag4 = ""
replace date_flag4 = "date_flag4" if pwsmth != . & pwsyr==. 
tab date_flag4

preserve
keep if date_flag1 == "date_flag1" | date_flag2 == "date_flag2" | date_flag3 == "date_flag3" | date_flag4 == "date_flag4"
keep id sdtype response typecont dir4 dir10 dir11 date piyrb pwsmth pwsmth_comment pwsyr pwsyr_comment
tab sdtype
tab typecont response, m
export excel using "L:\Data\Data Clean\Wave9\extracts\var_date\var_date1.xlsx", firstrow(variables) nolabel replace
restore

***
*date_flag1 - date_flag4 edits
***
replace pwsyr = 	1986	 if id == 	243	 & pwsyr ==	.	//	30 YEARS                
replace pwsyr = 	2013	 if id == 	320	 & pwsyr ==	.	//	3
replace pwsmth = 	12	 if id == 	996	 & pwsmth ==	16	//	16
replace pwsyr = 	2014	 if id == 	996	 & pwsyr ==	.	//	                        
replace pwsmth = 	-4	 if id == 	1988	 & pwsmth ==	.	//	VARIOUS PRACTICES/HOSP SERVICE 7/15
replace pwsyr = 	-4	 if id == 	1988	 & pwsyr ==	.	//	                        
replace pwsyr = 	2014	 if id == 	2073	 & pwsyr ==	.	//	2, checked original
replace pwsmth = 	-4	 if id == 	2686	 & pwsmth ==	6	//	2105
replace pwsyr = 	-4	 if id == 	2686	 & pwsyr ==	2105	//	9
replace pwsmth = 	12	 if id == 	3348	 & pwsmth ==	18	//	18
replace pwsyr = 	2014	 if id == 	3348	 & pwsyr ==	.	//	                        
replace pwsyr = 	2010	 if id == 	3541	 & pwsyr ==	.	//	6
replace pwsyr = 	2012	 if id == 	4000	 & pwsyr ==	.	//	4
replace pwsmth = 	-4	 if id == 	4360	 & pwsmth ==	.	//	YEARS AGO                          
replace pwsyr = 	-4	 if id == 	4360	 & pwsyr ==	.	//	                        
replace pwsyr = 	2012	 if id == 	4521	 & pwsyr ==	.	//	4
replace pwsyr = 	1994	 if id == 	4568	 & pwsyr ==	1921	//	94
replace pwsyr = 	2007	 if id == 	4948	 & pwsyr ==	.	//	9
replace pwsmth = 	-3	 if id == 	5591	 & pwsmth ==	6	//	                                   
replace pwsyr = 	2010	 if id == 	5668	 & pwsyr ==	.	//	6
replace pwsyr = 	2006	 if id == 	5769	 & pwsyr ==	.	//	10 (RELOCATED 2YR AGO)  
replace pwsyr = 	2007	 if id == 	7417	 & pwsyr ==	.	//	9
replace pwsyr = 	2014	 if id == 	7458	 & pwsyr ==	.	//	2
replace pwsyr = 	-4	 if id == 	8519	 & pwsyr ==	2019	//	2019
replace pwsyr = 	-4	 if id == 	8567	 & pwsyr ==	1916	//	1916
replace pwsyr = 	-4	 if id == 	8965	 & pwsyr ==	.	//	199
replace pwsyr = 	2010	 if id == 	9401	 & pwsyr ==	.	//	6
replace pwsyr = 	2008	 if id == 	9430	 & pwsyr ==	.	//	8
replace pwsyr = 	1986	 if id == 	9562	 & pwsyr ==	.	//	30 YEARS                
replace pwsyr = 	2009	 if id == 	9809	 & pwsyr ==	.	//	7
replace pwsmth = 	1	 if id == 	10458	 & pwsmth ==	6	//	JA                                 
replace pwsyr = 	1990	 if id == 	11443	 & pwsyr ==	1930	//	1930
replace pwsyr = 	1993	 if id == 	12261	 & pwsyr ==	.	//	-23
replace pwsyr = 	2013	 if id == 	13498	 & pwsyr ==	.	//	3
replace pwsmth = 	-4	 if id == 	13780	 & pwsmth ==	.	//	3 16                               
replace pwsmth = 	-4	 if id == 	14778	 & pwsmth ==	.	//	                                   
replace pwsyr = 	-4	 if id == 	14778	 & pwsyr ==	.	//	20 YRS PLUS             
replace pwsmth = 	-4	 if id == 	15236	 & pwsmth ==	.	//	LAST CENTURY                       
replace pwsyr = 	-4	 if id == 	15236	 & pwsyr ==	.	//	                        
replace pwsmth = 	-4	 if id == 	16055	 & pwsmth ==	.	//	                                   
replace pwsyr = 	-4	 if id == 	16055	 & pwsyr ==	.	//	> 10 YR AGO             
replace pwsyr = 	2011	 if id == 	17170	 & pwsyr ==	.	//	5
replace pwsyr = 	2014	 if id == 	17406	 & pwsyr ==	.	//	2
replace pwsyr = 	2012	 if id == 	18698	 & pwsyr ==	.	//	4
replace pwsmth = 	-5	 if id == 	19259	 & pwsmth ==	.	//	LOCUM HAVE NO *** ***              
replace pwsyr = 	-5	 if id == 	19259	 & pwsyr ==	.	//	                        
replace pwsyr = 	2011	 if id == 	20053	 & pwsyr ==	.	//	5
replace pwsyr = 	2010	 if id == 	20462	 & pwsyr ==	.	//	6
replace pwsyr = 	1998	 if id == 	21564	 & pwsyr ==	1917	//	98
replace pwsyr = 	2008	 if id == 	21633	 & pwsyr ==	.	//	8
replace pwsyr = 	2008	 if id == 	21812	 & pwsyr ==	.	//	8
replace pwsyr = 	2011	 if id == 	23409	 & pwsyr ==	.	//	5
replace pwsmth = 	-4	 if id == 	25561	 & pwsmth ==	.	//	> 10 YEARS AGO                     
replace pwsyr = 	-4	 if id == 	25561	 & pwsyr ==	.	//	                        
replace pwsyr = 	2013	 if id == 	26545	 & pwsyr ==	.	//	3
replace pwsmth = 	-4	 if id == 	27693	 & pwsmth ==	.	//	                                   
replace pwsyr = 	-4	 if id == 	27693	 & pwsyr ==	.	//	201
replace pwsyr = 	2014	 if id == 	31640	 & pwsyr ==	.	//	2
replace pwsyr = 	2015	 if id == 	33923	 & pwsyr ==	.	//	1
replace pwsmth = 	-4	 if id == 	33950	 & pwsmth ==	.	//	VARIES AS I WORK IN SEVERAL PLACES 
replace pwsyr = 	-4	 if id == 	33950	 & pwsyr ==	.	//	                        
replace pwsmth = 	-4	 if id == 	34656	 & pwsmth ==	.	//	                                   
replace pwsyr = 	-4	 if id == 	34656	 & pwsyr ==	.	//	> 10 YR                 
replace pwsmth = 	-4	 if id == 	36065	 & pwsmth ==	0	//	0
replace pwsyr = 	2012	 if id == 	37002	 & pwsyr ==	.	//	4
replace pwsyr = 	2008	 if id == 	37534	 & pwsyr ==	.	//	8
replace pwsyr = 	2012	 if id == 	37683	 & pwsyr ==	.	//	4
replace pwsyr = 	2014	 if id == 	39697	 & pwsyr ==	.	//	2
replace pwsyr = 	-3	 if id == 	41202	 & pwsyr ==	.	//	                        
replace pwsmth = 	-4	 if id == 	41829	 & pwsmth ==	.	//	                                   
replace pwsyr = 	-4	 if id == 	41829	 & pwsyr ==	.	//	ALWAYS                  
replace pwsyr = 	2015	 if id == 	42621	 & pwsyr ==	.	//	1
replace pwsyr = 	-3	 if id == 	43203	 & pwsyr ==	.	//	                        
replace pwsyr = 	10	 if id == 	44035	 & pwsyr ==	.	//	10 10/9/03              
replace pwsyr = 	2011	 if id == 	48745	 & pwsyr ==	.	//	5
replace pwsyr = 	-3	 if id == 	48989	 & pwsyr ==	.	//	                        
replace pwsyr = 	2007	 if id == 	49327	 & pwsyr ==	.	//	9
replace pwsyr = 	2016	 if id == 	50304	 & pwsyr ==	.	//	1
replace pwsyr = 	2011	 if id == 	50764	 & pwsyr ==	.	//	5
replace pwsyr = 	2013	 if id == 	51110	 & pwsyr ==	.	//	3
replace pwsyr = 	2013	 if id == 	51252	 & pwsyr ==	.	//	3
replace pwsyr = 	2011	 if id == 	52609	 & pwsyr ==	.	//	5 YR                    
replace pwsyr = 	2012	 if id == 	52786	 & pwsyr ==	.	//	4
replace pwsyr = 	2013	 if id == 	53145	 & pwsyr ==	.	//	3
replace pwsyr = 	2010	 if id == 	53177	 & pwsyr ==	.	//	6
replace pwsyr = 	2011	 if id == 	53256	 & pwsyr ==	.	//	5
replace pwsmth = 	7	 if id == 	53596	 & pwsmth ==	11	//	11, LIKELY STATED PERIOD
replace pwsyr = 	2015	 if id == 	53596	 & pwsyr ==	.	//	0, LIKELY STATED PERIOD
replace pwsyr = 	2011	 if id == 	53829	 & pwsyr ==	.	//	5
replace pwsmth = 	-4	 if id == 	55743	 & pwsmth ==	14	//	14
replace pwsmth = 	-4	 if id == 	55930	 & pwsmth ==	16	//	16
replace pwsmth = 	-4	 if id == 	56621	 & pwsmth ==	0	//	0
replace pwsyr = 	2015	 if id == 	56685	 & pwsyr ==	.	//	1
replace pwsyr = 	2013	 if id == 	56698	 & pwsyr ==	.	//	3
replace pwsmth = 	-4	 if id == 	56704	 & pwsmth ==	0	//	0
replace pwsyr = 	2013	 if id == 	57364	 & pwsyr ==	.	//	3
replace pwsmth = 	-4	 if id == 	57419	 & pwsmth ==	14	//	14
replace pwsmth = 	-4	 if id == 	57526	 & pwsmth ==	18	//	18
replace pwsyr = 	2013	 if id == 	57797	 & pwsyr ==	.	//	3
replace pwsyr = 	2011	 if id == 	58691	 & pwsyr ==	.	//	5
replace pwsyr = 	1997	 if id == 	59459	 & pwsyr ==	.	//	19 years                
replace pwsmth = 	1	 if id == 	59657	 & pwsmth ==	.	//	 2.5 YRS AGO                       
replace pwsyr = 	2014	 if id == 	59657	 & pwsyr ==	.	//	                        
replace pwsyr = 	2014	 if id == 	60470	 & pwsyr ==	.	//	2
replace pwsyr = 	2013	 if id == 	60979	 & pwsyr ==	.	//	3 YRS                   
replace pwsmth = 	-4	 if id == 	62293	 & pwsmth ==	0	//	0
replace pwsyr = 	2015	 if id == 	62618	 & pwsyr ==	.	//	1
replace pwsyr = 	2012	 if id == 	63985	 & pwsyr ==	.	//	4
replace pwsyr = 	2008	 if id == 	64162	 & pwsyr ==	.	//	8
replace pwsmth = 	9	 if id == 	64206	 & pwsmth ==	10	//	10
replace pwsyr = 	2013	 if id == 	64206	 & pwsyr ==	.	//	2
replace pwsmth = 	10	 if id == 	64616	 & pwsmth ==	10	//	10
replace pwsyr = 	2015	 if id == 	64616	 & pwsyr ==	.	//	0
replace pwsmth = 	7	 if id == 	65026	 & pwsmth ==	11	//	11
replace pwsyr = 	2008	 if id == 	65026	 & pwsyr ==	.	//	7
replace pwsyr = 	2015	 if id == 	65056	 & pwsyr ==	.	//	1
replace pwsyr = 	2015	 if id == 	65249	 & pwsyr ==	.	//	1
replace pwsyr = 	2015	 if id == 	65352	 & pwsyr ==	.	//	1
replace pwsmth = 	6	 if id == 	66170	 & pwsmth ==	2	//	2
replace pwsyr = 	2016	 if id == 	66170	 & pwsyr ==	.	//	0
replace pwsmth = 	-5	 if id == 	66660	 & pwsmth ==	.	//	                                   
replace pwsyr = 	-5	 if id == 	66660	 & pwsyr ==	.	//	inf                     
replace pwsyr = 	-3	 if id == 	66711	 & pwsyr ==	.	//	n/a                     
replace pwsmth = 	8	 if id == 	67067	 & pwsmth ==	0	//	0
replace pwsyr = 	2013	 if id == 	67067	 & pwsyr ==	.	//	3
replace pwsyr = 	2012	 if id == 	67451	 & pwsyr ==	.	//	4
replace pwsyr = 	2007	 if id == 	67808	 & pwsyr ==	.	//	9
replace pwsyr = 	2011	 if id == 	68693	 & pwsyr ==	.	//	5
replace pwsmth = 	12	 if id == 	68874	 & pwsmth ==	8	//	8
replace pwsyr = 	2013	 if id == 	68874	 & pwsyr ==	.	//	2
replace pwsmth = 	8	 if id == 	69064	 & pwsmth ==	10	//	10
replace pwsyr = 	2014	 if id == 	69064	 & pwsyr ==	.	//	1
replace pwsmth = 	-4	 if id == 	71427	 & pwsmth ==	0	//	0
replace pwsmth = 	4	 if id == 	71523	 & pwsmth ==	2	//	2
replace pwsyr = 	2013	 if id == 	71523	 & pwsyr ==	.	//	3
replace pwsyr = 	2008	 if id == 	71596	 & pwsyr ==	.	//	8
replace pwsmth = 	12	 if id == 	71599	 & pwsmth ==	6	//	6
replace pwsyr = 	2014	 if id == 	71599	 & pwsyr ==	.	//	1
replace pwsmth = 	3	 if id == 	71770	 & pwsmth ==	3	//	3
replace pwsyr = 	2014	 if id == 	71770	 & pwsyr ==	.	//	2
replace pwsmth = 	9	 if id == 	71894	 & pwsmth ==	9	//	9
replace pwsyr = 	2011	 if id == 	71894	 & pwsyr ==	.	//	4
replace pwsmth = 	12	 if id == 	72296	 & pwsmth ==	11	//	11
replace pwsyr = 	2010	 if id == 	72296	 & pwsyr ==	.	//	5
replace pwsyr = 	2012	 if id == 	72362	 & pwsyr ==	.	//	4
replace pwsyr = 	2011	 if id == 	72484	 & pwsyr ==	.	//	5
replace pwsmth = 	-4	 if id == 	72935	 & pwsmth ==	0	//	0
replace pwsmth = 	4	 if id == 	73508	 & pwsmth ==	6	//	6
replace pwsyr = 	2011	 if id == 	73508	 & pwsyr ==	.	//	5
replace pwsyr = 	2014	 if id == 	74287	 & pwsyr ==	.	//	2
replace pwsmth = 	3	 if id == 	76766	 & pwsmth ==	3	//	3
replace pwsyr = 	2015	 if id == 	76766	 & pwsyr ==	.	//	1
replace pwsmth = 	12	 if id == 	77328	 & pwsmth ==	9	//	9
replace pwsyr = 	2015	 if id == 	77328	 & pwsyr ==	.	//	0
replace pwsmth = 	3	 if id == 	79946	 & pwsmth ==	9	//	9
replace pwsyr = 	2016	 if id == 	79946	 & pwsyr ==	.	//	0
replace pwsmth = 	1	 if id == 	80565	 & pwsmth ==	6	//	6
replace pwsyr = 	2015	 if id == 	80565	 & pwsyr ==	.	//	1
replace pwsmth = 	8	 if id == 	80920	 & pwsmth ==	11	//	11
replace pwsyr = 	2015	 if id == 	80920	 & pwsyr ==	.	//	0
replace pwsyr = 	2013	 if id == 	81988	 & pwsyr ==	.	//	3
replace pwsmth = 	12	 if id == 	82377	 & pwsmth ==	6	//	6
replace pwsyr = 	2012	 if id == 	82377	 & pwsyr ==	.	//	3
replace pwsyr = 	2013	 if id == 	83305	 & pwsyr ==	.	//	3
replace pwsmth = 	12	 if id == 	83495	 & pwsmth ==	7	//	7
replace pwsyr = 	2011	 if id == 	83495	 & pwsyr ==	.	//	4
replace pwsyr = 	2010	 if id == 	83864	 & pwsyr ==	.	//	6
replace pwsmth = 	2	 if id == 	83960	 & pwsmth ==	5	//	5
replace pwsyr = 	2016	 if id == 	83960	 & pwsyr ==	.	//	0
replace pwsmth = 	9	 if id == 	84135	 & pwsmth ==	10	//	10
replace pwsyr = 	2014	 if id == 	84135	 & pwsyr ==	.	//	1
replace pwsyr = 	2014	 if id == 	84194	 & pwsyr ==	.	//	2
replace pwsyr = 	2014	 if id == 	84315	 & pwsyr ==	.	//	2
replace pwsyr = 	2011	 if id == 	84423	 & pwsyr ==	.	//	5 YEARS                 
replace pwsyr = 	2012	 if id == 	89667	 & pwsyr ==	.	//	4
replace pwsyr = 	2015	 if id == 	90897	 & pwsyr ==	.	//	//2-15
replace pwsmth = 	6	 if id == 	92770	 & pwsmth ==	0	//	0
replace pwsyr = 	2015	 if id == 	92770	 & pwsyr ==	.	//	1
replace pwsmth = 	6	 if id == 	97191	 & pwsmth ==	1	//	1
replace pwsyr = 	2013	 if id == 	97191	 & pwsyr ==	.	//	3
replace pwsyr = 	2014	 if id == 	97461	 & pwsyr ==	.	//	2
replace pwsmth = 	2	 if id == 	97845	 & pwsmth ==	6	//	6
replace pwsyr = 	2016	 if id == 	97845	 & pwsyr ==	.	//	0
replace pwsmth = 	3	 if id == 	98774	 & pwsmth ==	3	//	3
replace pwsyr = 	2015	 if id == 	98774	 & pwsyr ==	.	//	1
replace pwsmth = 	8	 if id == 	1000719	 & pwsmth ==	0	//	0
replace pwsyr = 	2016	 if id == 	1000719	 & pwsyr ==	.	//	0
replace pwsmth = 	12	 if id == 	1001175	 & pwsmth ==	2	//	2
replace pwsyr = 	2015	 if id == 	1001175	 & pwsyr ==	.	//	0
replace pwsyr = 	2013	 if id == 	1001194	 & pwsyr ==	.	//	3
replace pwsmth = 	5	 if id == 	1001273	 & pwsmth ==	9	//	9
replace pwsyr = 	2015	 if id == 	1001273	 & pwsyr ==	.	//	0
replace pwsmth = 	-4	 if id == 	1001496	 & pwsmth ==	5	//	5
replace pwsyr = 	-4	 if id == 	1001496	 & pwsyr ==	1913	//	1913
replace pwsmth = 	6	 if id == 	1001874	 & pwsmth ==	.	//	                                   
replace pwsyr = 	2015	 if id == 	1001874	 & pwsyr ==	.	//	12 MONTHS               
replace pwsyr = 	2015	 if id == 	1001914	 & pwsyr ==	.	//	1
replace pwsyr = 	-4	 if id == 	1001935	 & pwsyr ==	3007	//	3007
replace pwsmth = 	10	 if id == 	1002129	 & pwsmth ==	1	//	1
replace pwsyr = 	2013	 if id == 	1002129	 & pwsyr ==	.	//	3
replace pwsmth = 	6	 if id == 	1002189	 & pwsmth ==	2	//	2
replace pwsyr = 	2015	 if id == 	1002189	 & pwsyr ==	.	//	1
replace pwsmth = 	6	 if id == 	1002202	 & pwsmth ==	3	//	3
replace pwsyr = 	2014	 if id == 	1002202	 & pwsyr ==	.	//	2
replace pwsmth = 	3	 if id == 	1002277	 & pwsmth ==	6	//	6
replace pwsyr = 	2016	 if id == 	1002277	 & pwsyr ==	.	//	0
replace pwsmth = 	12	 if id == 	1002326	 & pwsmth ==	8	//	8
replace pwsyr = 	2015	 if id == 	1002326	 & pwsyr ==	.	//	1
replace pwsyr = 	2015	 if id == 	1002344	 & pwsyr ==	.	//	1
replace pwsyr = 	2014	 if id == 	1002346	 & pwsyr ==	.	//	2
replace pwsmth = 	10	 if id == 	1002379	 & pwsmth ==	1	//	1
replace pwsyr = 	2014	 if id == 	1002379	 & pwsyr ==	.	//	2
replace pwsmth = 	12	 if id == 	1002380	 & pwsmth ==	6	//	6
replace pwsyr = 	2013	 if id == 	1002380	 & pwsyr ==	.	//	2
replace pwsmth = 	-4	 if id == 	1002384	 & pwsmth ==	13	//	13
replace piyrb = 	 "1973"	 if id == 	1002384	 & piyrb ==	 "73"		
replace pwsmth = 	-4	 if id == 	1002397	 & pwsmth ==	.	//	4.5
replace pwsmth = 	-4	 if id == 	1002406	 & pwsmth ==	16	//	16
replace pwsyr = 	-4	 if id == 	1002406	 & pwsyr ==	.	//	1,3                     
replace pwsmth = 	4	 if id == 	1002424	 & pwsmth ==	4	//	4
replace pwsyr = 	2016	 if id == 	1002424	 & pwsyr ==	.	//	0
replace pwsmth = 	5	 if id == 	1002448	 & pwsmth ==	3	//	3
replace pwsyr = 	2010	 if id == 	1002448	 & pwsyr ==	.	//	6
replace pwsmth = 	5	 if id == 	1002481	 & pwsmth ==	5	//	5
replace pwsyr = 	2015	 if id == 	1002481	 & pwsyr ==	.	//	01 ONE YEAR AND 5 MONTHS
replace pwsmth = 	-4	 if id == 	1002509	 & pwsmth ==	17	//	17
replace pwsmth = 	2	 if id == 	1002622	 & pwsmth ==	9	//	9
replace pwsyr = 	2015	 if id == 	1002622	 & pwsyr ==	.	//	1
replace pwsmth = 	7	 if id == 	1002728	 & pwsmth ==	1	//	1
replace pwsyr = 	2014	 if id == 	1002728	 & pwsyr ==	.	//	2
replace pwsyr = 	2011	 if id == 	1002732	 & pwsyr ==	.	//	5
replace pwsmth = 	10	 if id == 	1002771	 & pwsmth ==	2	//	2
replace pwsyr = 	2015	 if id == 	1002771	 & pwsyr ==	.	//	1
replace pwsmth = 	4	 if id == 	1003019	 & pwsmth ==	6	//	6
replace pwsyr = 	2015	 if id == 	1003019	 & pwsyr ==	.	//	1
replace pwsmth = 	3	 if id == 	1003228	 & pwsmth ==	6	//	6
replace pwsyr = 	2016	 if id == 	1003228	 & pwsyr ==	.	//	0
replace pwsyr = 	2015	 if id == 	1003280	 & pwsyr ==	.	//	1
replace pwsmth = 	3	 if id == 	1003293	 & pwsmth ==	5	//	5
replace pwsyr = 	2014	 if id == 	1003293	 & pwsyr ==	.	//	2
replace pwsmth = 	12	 if id == 	1003326	 & pwsmth ==	9	//	9
replace pwsyr = 	2010	 if id == 	1003326	 & pwsyr ==	.	//	5
replace pwsyr = 	2011	 if id == 	1003383	 & pwsyr ==	.	//	5
replace pwsyr = 	2012	 if id == 	1003414	 & pwsyr ==	.	//	4
replace pwsyr = 	2014	 if id == 	1003533	 & pwsyr ==	.	//	2
replace pwsyr = 	2015	 if id == 	1004699	 & pwsyr ==	.	//	1

*if no value given then assume it is june, need to apply again
replace pwsmth=6 if pwsmth==. & pwsmth_comment=="" & pwsyr!=.

********************************************************

*jsbsyr pirsyr pireyr piyrb picmd pifayr pifryr

foreach x of var jsbsyr pirsyr pireyr piyrb picmd pifayr pifryr {

ren `x' `x'_comment
replace `x'_comment = upper(`x'_comment)

gen `x'=-3 if `x'_comment=="NA"|`x'_comment=="N/A"

replace `x' = real(regexs(1)) if regexm(`x'_comment, "([0-9][0-9][0-9][0-9])")
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9][0-9][0-9][0-9])[ ][A-Z].*$")

gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "([0-9][0-9][0-9][0-9])[ ]([0-9][0-9][0-9][0-9])")
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "([0-9][0-9][0-9][0-9])[ ]([0-9][0-9][0-9][0-9])")
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "([0-9][0-9][0-9][0-9])[ ]([0-9][0-9][0-9][0-9])")
drop `x'_1 `x'_2


list id date `x'_comment if `x'==.&`x'_comment!="" 

}
*


*check imputations
list date  jsbsyr jsbsyr_comment id if jsbsyr!=.& jsbsyr_comment!=""
* all good

*fill in missing values
list date  jsas jsbsyr jsbsyr_comment jsbsdk id response dirall if jsbsyr==.& jsbsyr_comment!=""
	replace jsbsyr=-4 if id==1004410

*check imputations
list pirsyr pirsyr_comment  id if pirsyr!=.& pirsyr_comment!="" 
* all good

list date sdtype continue pirsyr_comment pireyr pirps pirna id if pirsyr==.& pirsyr_comment!=""
*all good

* check imputations
list pireyr pireyr_comment id if pireyr!=.& pireyr_comment!="" & pirna!=1
*all good

list date pireyr_comment id response dirall if pireyr==.& pireyr_comment!="" & pirna!=1 
	
	replace pireyr=-1 if id==18038|id==18354|id==19842|id==23579|id==44626
	replace pireyr=-4 if id==63742|id==65964|id==69483|id==79275|id==83410|id==88659|id==94164|id==1004664|id==1005237

*check imputations
list date piyrb piyrb_comment id if piyrb!=.& piyrb_comment!="" , clean
	replace piyrb=-4 if id==1003908

list date piyrb_comment id response dirall if piyrb==.& piyrb_comment!=""
	replace piyrb=1971 if id==1001564

list date picmd picmd_comment id if picmd!=.& picmd_comment!="", clean
	replace picmd=-4 if id==1004420

list date picmd_comment id if picmd==.& picmd_comment!=""
	replace picmd=1996 if id==1001564
	replace picmd=1986 if id==1001976

list pifayr pifayr_comment id if pifayr!=.& pifayr_comment!="", clean
	replace pifayr = -1 if id==7538
	

*for some reason the doctor's name often appears at pifayr. I have investigated the cause of this but didn't resolve it.
list date picmdo picmda pims piis picamc pifayr pifayr_comment pifyrna pifryr_comment id dirall if pifayr==.& pifayr_comment!=""
	
	replace pifayr=1992 if id==36582
	replace pifayr=-1 if id==54068
	replace pifyrna=1 if id==54068
	
list pifryr pifryr_comment id if pifryr!=.& pifryr_comment!="" in 1/4000, clean
	replace pifryr=-4 if id==8464
	
list date sdtype continue picmdo picmda pims piis picamc pifayr pifryr_comment pifyrna id dirall if pifryr==.& pifryr_comment!=""
	replace pifryr=-4 if id==34053

	
tab1 jsbsyr pirsyr pireyr piyrb picmd pifayr pifryr
	replace jsbsyr=2017 if id==74130
	replace jsbsyr=2016 if id==76411
	replace jsbsyr = -4 if jsbsyr < 2016
	replace pirsyr = -4 if pirsyr > 2016 & pirsyr != .
	replace pireyr = 2017 if id==50978 | id==1001132
	replace pireyr = -4 if pireyr < 2016 & pireyr > 0
	replace picmd=-4 if picmd < 1956 //NOTE THIS THRESHOLD, WHICH WILL NEED UPDATE FOR NEXT WAVE
	replace pifayr=1988 if id==64652
	replace pifryr=2013 if id==1003937
	replace pifryr=-4 if pifryr > 2016 & pifryr != .
	replace pireyr=-4 if id==55691
	
****************************************************

*pwwmth/pwwyr,  pindyr/pindmt

foreach x of var pwwmth pwwyr pindmt pindyr {

ren `x' `x'_comment
replace `x'_comment=upper(`x'_comment)
replace `x'_comment=subinstr(`x'_comment, " 1/2", ".5", .)

gen `x'=.

replace `x'=real(`x'_comment) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")&`x'==.
replace `x'=real(`x'_comment) if regexm(`x'_comment, "^([.][0-9]+)$")&`x'==.
replace `x'=real(regexs(0)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")&`x'==.
replace `x'=real(regexs(0)) if regexm(`x'_comment, "^([.][0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-([0-9]+)$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "([0-9]+)")&`x'==.

gen temp_`x'_1=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen temp_`x'_2=real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=temp_`x'_1 if `x'==.&temp_`x'_1!=.&temp_`x'_1==temp_`x'_2&`x'==.
drop temp_`x'_1 temp_`x'_2

replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="--")
replace `x'=0 if `x'==.&`x'_comment=="NIL"
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|`x'_comment=="N/A")

}

foreach x of var pwwmth pindmt {

replace `x'=real(regexs(1))/4 if regexm(`x'_comment, "^([0-9]+)[ ](([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))$")
replace `x'=real(regexs(1))/4 if regexm(`x'_comment, "^([0-9]+)(([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ](([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)(([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))$")
replace `x'=real(regexs(1))*12 if regexm(`x'_comment, "^([0-9]+)[ ](([Y][E][A][R])|([Y][E][A][R][S])|([Y][R][S])|([Y][R]))$")
replace `x'=real(regexs(1))*12 if regexm(`x'_comment, "^([0-9]+)(([Y][E][A][R])|([Y][E][A][R][S])|([Y][R][S])|([Y][R]))$")

tab `x'_comment if `x'==.

}

foreach x of var pwwyr pindyr {

replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)[ ](([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))$")
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)(([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))$")
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ](([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))$")
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)(([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ](([Y][E][A][R])|([Y][E][A][R][S])|([Y][R][S])|([Y][R]))$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)(([Y][E][A][R])|([Y][E][A][R][S])|([Y][R][S])|([Y][R]))$")

tab `x'_comment if `x'==.

}

replace pwwyr = real(regexs(1)) if regexm(pwwyr_comment, "([0-9]+)")
replace pwwyr = real(regexs(0)) if regexm(pwwyr_comment, "([0-9]+)[.]([0-9]+)")
list date pwwmth pwwmth_comment pwwyr pwwyr_comment id if (pwwmth==.&pwwmth_comment!="")|(pwwyr==.&pwwyr_comment!="")

*edit on pwwyr pwwmth, considered date_flag5	
replace pwwmth=-4 if id==16596
replace pwwyr=-4 if id==16596
replace pwwmth=-3 if id==19259
replace pwwyr=-3 if id==19259
replace pwwmth=-3 if id==25444
replace pwwyr=-3 if id==25444
replace pwwyr=19 if id==26147 //19Y
replace pwwmth=-3 if id==54545
replace pwwyr=-3 if id==54545
replace pwwmth=5 if id==1000744
replace pwwyr=1 if id==1000744
replace pwwyr=0 if id==1000982 //- -
replace pwwyr=1 if id==1002128
replace pwwmth=-4 if id==1002542
replace pwwyr=-4 if id==1002542

	
list date pwwyr pwwyr_comment id if  pwwyr_comment!="" 
list date typecont pwwyr pwwyr_comment id dirall if pwwyr_comment != "" & pwwyr >= 100 & pwwyr != .
		replace pwwyr=2016-1998 if id==595
		replace pwwyr=2016-1990 if id==36925
		replace pwwyr=2016-2013 if id==51239
		replace pwwyr=2016-2016 if id==3626
		replace pwwyr=2016-2004 if id==41203
		replace pwwyr=2016-1994 if id==54963

*make sure data isn't repeated in month and year fields
list pwwmth pwwyr id dirall if pwwmth>=12&pwwmth!=.&pwwyr!=.
replace pwwyr=. if pwwmth>=12&pwwmth!=.&pwwyr!=.


list id pwwmth pwwyr if pwwmth!=.&pwwyr==. 
*all good

list id pwwmth pwwyr if pwwmth==.&pwwyr!=. in 4001/8995

gen a=1 if pwwmth!=.&pwwyr==.&pwwmth>=0
gen b=1 if pwwmth==.&pwwyr!=.&pwwyr>=0

replace pwwyr=int(pwwmth/12) if a==1&pwwyr==.
replace pwwmth=pwwmth-(pwwyr*12) if a==1

replace pwwmth=(pwwyr-int(pwwyr))*12 if b==1
replace pwwyr=int(pwwyr) if b==1

drop a b

replace pwwmth=round(pwwmth, .1)
replace pwwyr=round(pwwyr, .1)



*glyr glmth removed in 2015
*list dtimage glmth glmth_comment glyr glyr_comment id if (glmth==.&glmth_comment!="")|(glyr==.&glyr_comment!="")


*check if been in hospital more time than in geographic location - tt added 7/7/14
*list id sdtype continue picmd picmda pirsyr pireyr dtimage glyr glmth pwwyr pwwmth if glyr < pwwyr &pwwyr!=.
*there were several who had been longer in geog location than hospital but these were their actual answers so i have left - tt 18/3/2015

list pindmt pindmt_comment pindyr pindyr_comment id if (pindmt==.&pindmt_comment!="")|(pindyr==.&pindyr_comment!="")
	replace pindyr=0 if id==959 //NIL
	replace pindyr=0 if id==1322
	replace pindyr=0 if id==10911 //NONE
	replace pindyr=0 if id==12063 //NIL
	replace pindyr=0 if id==16606
	replace pindyr=0 if id==26723 //NONE
	replace pindyr=1 if id==30940 //ONE
	replace pindyr=-4 if id==34015 //DONT UNDERSTAND
	replace pindyr=0 if id==34158 //O
	replace pindmt=0 if id==34158 //O
	replace pindyr=0 if id==58306 //NONE

list id pindmt pindyr if pindmt>=12&pindmt!=.&pindyr!=.
*none
replace pindyr=. if pindmt>=12&pindmt!=.&pindyr!=.

list id pindmt pindyr if pindmt!=.&pindyr==. 
list id pindmt pindyr if pindmt==.&pindyr!=. 

gen a=1 if pindmt!=.&pindyr==.&pindmt>=0
gen b=1 if pindmt==.&pindyr!=.&pindmt>=0

replace pindyr=int(pindmt/12) if a==1&pindyr==.
replace pindmt=pindmt-(pindyr*12) if a==1

replace pindmt=(pindyr-int(pindyr))*12 if b==1
replace pindyr=int(pindyr) if b==1

drop a b

replace pindmt=round(pindmt, 1)
replace pindyr=round(pindyr, .1)

*****************************************************

*Year: ficsyr glyrrs fcpr - ficsyr not in w7

foreach x of var ficsyr glyrrs fcpr {

ren `x' `x'_comment
replace `x'_comment=upper(`x'_comment)
replace `x'_comment=subinstr(`x'_comment, " 1/2", ".5", .)

gen `x'=.

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-([0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([.][0-9]+)$")&`x'==.

gen temp_`x'_1=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
gen temp_`x'_2=real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
replace `x'=temp_`x'_1 if `x'==.&temp_`x'_1!=.&temp_`x'_1==temp_`x'_2
drop temp_`x'_1 temp_`x'_2

replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="--")
replace `x'=0 if `x'==.&`x'_comment=="NIL"
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|`x'_comment=="N/A")

replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ](([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))$")
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)(([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ](([Y][E][A][R])|([Y][E][A][R][S])|([Y][R][S])|([Y][R]))$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)(([Y][E][A][R])|([Y][E][A][R][S])|([Y][R][S])|([Y][R]))$")

replace `x'=real(regexs(1)) if regexm(`x'_comment, "([0-9]+)[ ][A-Z].*")&`x'==.

list id dtimage `x'_comment if `x'==.&`x'_comment!="" 

}
*
	replace ficsyr=2016-2004 if id==1002517
	replace ficsyr=0.5 if id==1004029
	replace glyrrs = 0 if id==1001452
	replace glyrrs = -3 if id== 1001532
	replace glyrrs = 15 if id== 1002620
	replace glyrrs = 0 if id==1002637

replace ficsyr=real(regexs(1)) if regexm(ficsyr_comment, "([0-9]+)")& ficsyr==.


foreach x of var ficsyr {
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|strmatch(`x'_comment,"*N/A*"))
replace `x'=-4 if `x'==.&(strmatch(`x'_comment,"*NOT SURE*")|strmatch(`x'_comment,"*T KNOW*"))
}
*
foreach x of var ficsyr glyrrs fcpr {
list id date dtimage `x' `x'_comment if `x'!=. & `x'_comment!="" & `x'!=real(`x'_comment)
}
*
*I NOTICE THAT THERE ARE QUITE A FEW AUTOMATED CLEANING THAT DON'T FOLLOW THE RULE OF TABLE 13 IN THE USER MANUAL, e.g., ID==1001366, 1002329, 1002934, 1003513, 1003542, 1004894 
	replace ficsyr=0.3 if id==1002115 //FROM FEB 2016
	replace ficsyr=9.75 if id==1002568 //2YEAR 9 MONTHS
	replace ficsyr=8.67 if id==1003795 // 1 YEAR 8 MONTHS
	replace ficsyr=1.83 if id==1004735 //1 YEAR, 10 MONTHS 

foreach x of var ficsyr glyrrs fcpr {
list id `x'_comment if `x'==.&`x'_comment!="" 
}
*

tab1 glyrrs fcpr

*********************************************

*Pair of day/week: wlww/wlwd

gen date_flag7 = ""

foreach x of var wlwd wlww {

ren `x' `x'_comment
replace `x'_comment=upper(`x'_comment)

replace `x'_comment=regexs(2)+"-"+regexs(1) if regexm(`x'_comment, "^([0-9][0-9])[/]([0-9][0-9])[/][2][0][1][2-4]$")

gen `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)$")

replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")
replace `x'=real(`x'_comment) if regexm(`x'_comment, "^([0-9]+)[.]([0-9]+)$")

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\~([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-\-([0-9]+)$")

gen temp_`x'_1=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
gen temp_`x'_2=real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")

replace `x'=temp_`x'_1 if `x'==.&temp_`x'_1!=.&temp_`x'_1==temp_`x'_2
drop temp_`x'_1 temp_`x'_2

replace `x'=0 if (`x'_comment=="-"|`x'_comment=="--"|`x'_comment=="---")&`x'==.
replace `x'=0 if (`x'_comment=="NIL"|`x'_comment=="NIL.")&`x'==.
replace `x'=0 if (`x'_comment=="/"|`x'_comment=="ZERO")&`x'==.
replace `x'=0 if `x'_comment=="SAME DAY"&`x'==.
replace `x'=1 if `x'_comment=="ONE"
replace `x'=0 if `x'_comment=="NONE"

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.

replace wlwd=0 if wlwd==.&wlwd_comment=="<1"

replace date_flag7 = "date_flag7" if `x'==.&`x'_comment!="" 
list dtimage `x'_comment id if `x'==.&`x'_comment!="" 
}
tab date_flag7

gen date_flag8 = ""
foreach x of var wlwd wlww {
replace date_flag8 = "date_flag8" if `x'!=.&`x'_comment!="" & `x'!=real(`x'_comment) 
*list dtimage `x'_comment `x' id if `x'!=.&`x'_comment!="" & `x'!=real(`x'_comment) 
}
tab date_flag8

foreach x of var wlwd wlww {
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|strmatch(`x'_comment,"*N/A*"))
replace `x'=-4 if `x'==.&(`x'_comment=="NOT SURE"|strmatch(`x'_comment,"*T KNOW"))
list dtimage `x'_comment wlwd wlww wlnt wlna id if `x'==.&`x'_comment!="" 
}
*

tab date_flag7 date_flag8

preserve
sort id
keep if date_flag7=="date_flag7" | date_flag8=="date_flag8"
keep id response sdtype typecont dir5 dir6 wlwd wlww wlnt wlna wlwd_comment wlww_comment wlnt_comment wlna_comment 
export excel using "L:\Data\Data Clean\Wave9\extracts\var_date\var_date7-8.xlsx", firstrow(variables) nolabel replace
restore

***
*date_flag7 and date_flag8 edits
***

replace wlww = 	0	 if wlww ==	-3	 & id == 	243	//	N/A                                              
replace wlnt = 	0	 if wlnt ==	1	 & id == 	243	//	N/A                                              
replace wlww = 	2.5	 if wlww ==	.	 & id == 	1376	//	2 (BETWEEN 2 & 3 WKS)                                             
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	1988	//	NOT SURE (LOCUM)                                                                      
replace wlww = 	-4	 if wlww ==	.	 & id == 	1988	//	                                                                  
replace wlwd = 	3	 if wlwd ==	.	 & id == 	3482	//	1-5 DAYS                                                                              
replace wlww = 	2	 if wlww ==	.	 & id == 	4479	//	~ 2                                                               
replace wlwd = 	0	 if wlwd ==	2	 & id == 	5342	//	2 HRS                                                                                 
replace wlwd = 	1.5	 if wlwd ==	.	 & id == 	5432	//	1-2 DAY                                                                               
replace wlwd = 	-1	 if wlwd ==	1	 & id == 	5904	//	01 NO NEW PATIENTS BEING SEEN                                                         
replace wlww = 	-1	 if wlww ==	.	 & id == 	5904	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	6386	//	                                                                  
replace wlwd = 	-3	 if wlwd ==	.	 & id == 	6471	//	                                                                                      
replace wlww = 	0	 if wlww ==	.	 & id == 	7445	//	0 = ***                                                           
replace wlwd = 	0	 if wlwd ==	.	 & id == 	7487	//	SAME                                                                                  
replace wlww = 	0	 if wlww ==	.	 & id == 	7487	//	                                                                  
replace wlww = 	0	 if wlww ==	.	 & id == 	8482	//	                                                                  
replace wlwd = 	-3	 if wlwd ==	.	 & id == 	9976	//	                                                                                      
replace wlww = 	-3	 if wlww ==	.	 & id == 	11564	//	                                                                  
replace wlwd = 	0	 if wlwd ==	.	 & id == 	12255	//	O                                                                                     
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	14778	//	DON'T KNOW PRINCIPALS & PRACTICE ADMIN STAFF WILL KNOW THIS                           
replace wlww = 	-4	 if wlww ==	.	 & id == 	14778	//	                                                                  
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	15811	//	                                                                                      
replace wlww = 	-4	 if wlww ==	.	 & id == 	15811	//	NOT KNOWN                                                         
replace wlww = 	0	 if wlww ==	.	 & id == 	16351	//	<1                                                                
replace wlww = 	-3	 if wlww ==	.	 & id == 	23186	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	24577	//	                                                                  
replace wlww = 	12	 if wlww ==	.	 & id == 	26456	//	12 - IF NON URGENT                                                
replace wlww = 	-4	 if wlww ==	.	 & id == 	28345	//	< 1                                                               
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	28494	//	VERY VARIABLE, ONE DAY IF SPACE 5                                                     
replace wlww = 	-4	 if wlww ==	.	 & id == 	28494	//	THREE MONTHS IF NOT URGENT EG PATIENT TRANFERRING FROM A COLLEAGUE
replace wlwd = 	3.5	 if wlwd ==	.	 & id == 	28741	//	1-7 DEPENDS ON URGENCY                                                                
replace wlwd = 	2.5	 if wlwd ==	.	 & id == 	28963	//	2-3 URGENT                                                                            
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	32475	//	UNKNOWN                                                                               
replace wlww = 	-4	 if wlww ==	.	 & id == 	32475	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	32920	//	                                                                  
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	34053	//	<7                                                                                    
replace wlww = 	-4	 if wlww ==	.	 & id == 	34053	//	                                                                  
replace wlwd = 	1.5	 if wlwd ==	.	 & id == 	34537	//	1-2 I AM A RADIOLOGIST                                                                
replace wlww = 	-3	 if wlww ==	.	 & id == 	34795	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	34795	//	            
replace wlww = 	-3	 if wlww ==	.	 & id == 	34823	//	                                                                  
replace wlwd = 	3.5	 if wlwd ==	1	 & id == 	36328	//	1 TO                                                                                  
replace wlww = 	0	 if wlww ==	1	 & id == 	36328	//	1
replace wlww = 	-3	 if wlww ==	.	 & id == 	36925	//	N/A       Winding Down Practice                                                                              
replace wlna = 	1	 if wlna ==	0	 & id == 	36925	//	            
replace wlww = 	3	 if wlww ==	.	 & id == 	37260	//	3 ***                                                             
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	41202	//	<7                                                                                    
replace wlww = 	-4	 if wlww ==	.	 & id == 	41202	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	41345	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	41345	//	            
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	41694	//	NO IDEA                                                                               
replace wlww = 	-4	 if wlww ==	.	 & id == 	41694	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	43461	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	43461	//	            
replace wlwd = 	-3	 if wlwd ==	.	 & id == 	50448	//	                                                                                      
replace wlww = 	-3	 if wlww ==	.	 & id == 	50736	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	50736	//	            
replace wlww = 	-3	 if wlww ==	.	 & id == 	52423	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	53899	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	53899	//	            
replace wlwd = 	2.5	 if wlwd ==	.	 & id == 	54866	//	1-4 VARIABLE DEPENDANT ON CONDITION EG -CANCER -BENIGN- WEEKS-MONTH                   
replace wlww = 	-3	 if wlww ==	.	 & id == 	55772	//	                                                                  
replace wlwd = 	-5	 if wlwd ==	.	 & id == 	56226	//	?                                                                                     
replace wlww = 	-5	 if wlww ==	.	 & id == 	56226	//	                                                                  
replace wlwd = 	3.5	 if wlwd ==	17.5	 & id == 	56685	//	//7-28
replace wlww = 	2	 if wlww ==	.	 & id == 	56685	//	                                                                  
replace wlnt = 	0	 if wlnt ==	1	 & id == 	56901	//	-
replace wlww = 	-3	 if wlww ==	.	 & id == 	56955	//	                                                                  
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	57956	//	I DON'T KNOW - APPT ARE MADE THROUGH CLERICAL STAFF                                   
replace wlww = 	-4	 if wlww ==	.	 & id == 	57956	//	                                                                  
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	59201	//	<5                                                                                    
replace wlwd = 	1.5	 if wlwd ==	1	 & id == 	59249	//	1 TO 2                                                                                
replace wlwd = 	-5	 if wlwd ==	.	 & id == 	59824	//	?                                                                                     
replace wlww = 	-5	 if wlww ==	.	 & id == 	59824	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	64246	//	                                                                  
replace wlwd = 	0	 if wlwd ==	7	 & id == 	64563	//	7
replace wlww = 	1	 if wlww ==	-3	 & id == 	64563	//	N/A                                                               
replace wlww = 	-3	 if wlww ==	.	 & id == 	64772	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	64772	//	            
replace wlww = 	-3	 if wlww ==	.	 & id == 	65022	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	65022	//	            
replace wlww = 	-3	 if wlww ==	.	 & id == 	66878	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	66878	//	            
replace wlwd = 	0	 if wlwd ==	2	 & id == 	68454	//	2 TO 3 WEEKS                                                                          
replace wlww = 	2.5	 if wlww ==	.	 & id == 	68454	//	2 TO 3 WEEKS                                                                          
replace wlnt = 	0	 if wlnt ==	1	 & id == 	69160	//	N/A                                              
replace wlww = 	-3	 if wlww ==	.	 & id == 	70770	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	71142	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	71142	//	            
replace wlwd = 	-3	 if wlwd ==	.	 & id == 	71518	//	                                                                                      
replace wlwd = 	-1	 if wlwd ==	.	 & id == 	71726	//	STOPPED. I HAVE STOPPED TAKING ON NEW PATIENTS. IF WE HAVE A LOCUM THEY WILL SEE LOCUM
replace wlww = 	-1	 if wlww ==	.	 & id == 	71726	//	                                                                  
replace wlnt = 	1	 if wlnt ==	0	 & id == 	71726	//	                                                 
replace wlww = 	-3	 if wlww ==	.	 & id == 	72455	//	                                                                  
replace wlww = 	-3	 if wlww ==	.	 & id == 	73145	//	                                                                  
replace wlna = 	1	 if wlna ==	0	 & id == 	73145	//	            
replace wlww = 	-3	 if wlww ==	.	 & id == 	96997	//	N/A DONT SEE PRIVATE PTS                                                              
replace wlna = 	1	 if wlna ==	0	 & id == 	96997	//	N/A DONT SEE PRIVATE PTS                                                              
replace wlwd = 	1.5	 if wlwd ==	.	 & id == 	98604	//	NOT SURE 1-2                                                                          
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	1000513	//	UNSURE (MOVED RECENTLY TO THE CURRENT PRACTICE)                                       
replace wlww = 	-4	 if wlww ==	.	 & id == 	1000513	//	                                                                  
replace wlwd = 	0	 if wlwd ==	4	 & id == 	1000818	//	4 WEEKS                                                                               
replace wlww = 	4	 if wlww ==	.	 & id == 	1000818	//	4 WEEKS                                                                               
replace wlwd = 	0	 if wlwd ==	.	 & id == 	1001454	//	NO WAITING- WILL SEE IN THE SAME DAY                                                  
replace wlnt = 	0	 if wlnt ==	1	 & id == 	1001645	//	Me Personally! Not Taking New Patients At Present
replace wlwd = 	2	 if wlwd ==	.	 & id == 	1001861	//	UP TO 4                                                                               
replace wlwd = 	0	 if wlwd ==	.	 & id == 	1002481	//	ANY TIME IN A DAY                                                                     
replace wlww = 	0	 if wlww ==	.	 & id == 	1002481	//	                                                                  
replace wlwd = 	0	 if wlwd ==	.	 & id == 	1002620	//	ON SAME DAY                                                                           
replace wlww = 	0	 if wlww ==	.	 & id == 	1002620	//	                                                                  
replace wlww = 	0	 if wlww ==	.	 & id == 	1003155	//	                                                                  
replace wlwd = 	0	 if wlwd ==	.	 & id == 	1003282	//	10MINS                                                                                
replace wlww = 	0	 if wlww ==	.	 & id == 	1003282	//	                                                                  
replace wlwd = 	-4	 if wlwd ==	.	 & id == 	1003582	//	DEPENDS ON ILLNESS SEVERITY                                                           
replace wlww = 	-4	 if wlww ==	.	 & id == 	1003582	//	                                                                  

                                                           
list id wlww wlwd if wlwd>=7&wlwd!=.&wlww!=. 

replace wlww=. if wlwd>=7&wlwd!=.&wlww!=.

gen a=1 if wlwd!=.&(wlww==.|wlww==-3)
gen b=1 if (wlwd==.|wlwd==-3)&wlww!=.

replace wlww=int(wlwd/7) if a==1
replace wlwd=wlwd-(wlww*7) if a==1

replace wlwd=(wlww-int(wlww))*7 if b==1
replace wlww=int(wlww) if b==1

drop a b



**************************************************

*Day: wlwy wlwod 

gen date_flag9 = ""

foreach x of var wlwy wlwod  {

ren `x' `x'_comment
replace `x'_comment=upper(`x'_comment)

replace `x'_comment=regexs(2)+"-"+regexs(1) if regexm(`x'_comment, "^([0-9][0-9])[/]([0-9][0-9])[/][2][0][1][2-4]$")

gen `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)$")


replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[ ][A-Z].*$")
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)[ ]\-[ ]([0-9]+)[ ][A-Z].*$")
replace `x'=real(`x'_comment) if regexm(`x'_comment, "^([0-9]+)[.]([0-9]+)$")

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\~([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-\-([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\?([0-9]+)$")

gen temp_`x'_1=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
gen temp_`x'_2=real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")

replace `x'=temp_`x'_1 if `x'==.&temp_`x'_1!=.&temp_`x'_1==temp_`x'_2
drop temp_`x'_1 temp_`x'_2

replace `x'=0 if (`x'_comment=="-"|`x'_comment=="--"|`x'_comment=="---")&`x'==.
replace `x'=0 if (`x'_comment=="NIL"|`x'_comment=="NIL.")&`x'==.
replace `x'=0 if (`x'_comment=="/"|`x'_comment=="ZERO")&`x'==.
replace `x'=1 if strmatch(`x'_comment,"ONE*")
replace `x'=0 if `x'_comment=="NONE"
replace `x'=2 if `x'_comment=="TWO"
replace `x'=3 if `x'_comment=="THREE"
replace `x'=4 if `x'_comment=="FOUR"
replace `x'=5 if `x'_comment=="FIVE"
replace `x'=6 if `x'_comment=="SIX"
replace `x'=7 if `x'_comment=="SEVEN"
replace `x'=-3 if (`x'_comment=="NA"|strmatch(`x'_comment,"*N/A*")|strmatch(`x'_comment,"*APPLICABLE*"))&`x'==.
replace `x'=0.5 if `x'==.&`x'_comment=="<1"
replace `x'=0.5 if `x'==.&`x'_comment=="1/2"
replace `x'=0 if strmatch(`x'_comment,"*SAME*")&`x'==.

replace `x'=-4 if (strmatch(`x'_comment,"*SURE*")|strmatch(`x'_comment,"*T KNOW*"))&`x'==.
replace `x'=-4 if `x'_comment=="?"
replace `x'=0 if `x'_comment=="O"


replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]\-[ ][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][?]*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[?]*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[+]*$")&`x'==.

replace date_flag9 = "date_flag9" if `x'==.&`x'_comment!="" 

list id `x'_comment if `x'==.&`x'_comment!="" 
}
*

replace wlwy=((real(regexs(1))+real(regexs(2)))/2)*7 if regexm(wlwy_comment, "^([0-9]+)\-([0-9]+)[ ](([W][E][E][K][S]))$")
replace wlwy=real(regexs(1))*7 if regexm(wlwy_comment, "^([0-9]+)[ ](([W][E][E][K][S]))$")
replace wlwy=real(regexs(1))*7 if regexm(wlwy_comment, "^([0-9]+)(([W][E][E][K][S]))$")
replace wlwy=real(regexs(1))/480 if regexm(wlwy_comment, "^([0-9]+)[ ](([M][I][N][S])|([M][I][N][U][T][E][S]))$")
replace wlwy=real(regexs(1))/480 if regexm(wlwy_comment, "^([0-9]+)(([M][I][N][S])|([M][I][N][U][T][E][S]))$")
replace wlwy=real(regexs(1))/8 if regexm(wlwy_comment, "^([0-9]+)[ ](([H][O][U][R][S])|([H][R][S]))$")
replace wlwy=real(regexs(1))/8 if regexm(wlwy_comment, "^([0-9]+)(([H][O][U][R][S])|([H][R][S]))$")

gen date_flag10 = ""
foreach x of var wlwy wlwod {
replace date_flag10 = "date_flag10" if `x'!=.&`x'_comment!="" & `x'!=real(`x'_comment)
list `x' `x'_comment id if `x'!=.&`x'_comment!="" & `x'!=real(`x'_comment) 
}
*
foreach x of var wlwy wlwod {
list dtimage `x'_comment id if `x'==.&`x'_comment!="" 
}
*
tab1 date_flag9 date_flag10
tab date_flag9 date_flag10, m

preserve
keep if date_flag9 == "date_flag9" | date_flag10 == "date_flag10"
keep id response dir6 wlwy wlwod wlwy_comment wlwod_comment
export excel using "L:\Data\Data Clean\Wave9\extracts\var_date\var_date9-10.xlsx", firstrow(variables) nolabel replace
restore

***
*date_flag9 and date_flag10 edits
***
replace wlwy = 	-4	 if id == 	3860	 & wlwy ==	.	//	<3                                                                      
replace wlwod = 	0	 if id == 	4895	 & wlwod ==	.	//	APPTS USUALLY AVAILABLE                        
replace wlwod = 	-3	 if id == 	5591	 & wlwod ==	.	//	                                               
replace wlwy = 	-3	 if id == 	6170	 & wlwy ==	.	//	NOT RELEVANT                                                            
replace wlwod = 	-3	 if id == 	6386	 & wlwod ==	.	//	                                               
replace wlwy = 	0.5	 if id == 	6765	 & wlwy ==	0	//	0 TO 1 DAY                                                              
replace wlwod = 	0	 if id == 	8438	 & wlwod ==	-3	//	N/A 0?                                         
replace wlwy = 	120	 if id == 	9670	 & wlwy ==	.	//	99 (4 MTHS 120 DAYS)                                                    
replace wlwy = 	0.5	 if id == 	9776	 & wlwy ==	0	//	0 TO 1                                                                  
replace wlwod = 	-3	 if id == 	11564	 & wlwod ==	.	//	                                               
replace wlwy = 	3.5	 if id == 	13427	 & wlwy ==	.	//	DEPENDS ON URGENCY OF CASE 0-7                                          
replace wlwy = 	-4	 if id == 	14778	 & wlwy ==	.	//	DONT' KNOW PRINCIPALS & PRACTICE ADMIN STAFF WILL KNOW THIS             
replace wlwod = 	-4	 if id == 	14778	 & wlwod ==	.	//	                                               
replace wlwod = 	-3	 if id == 	15811	 & wlwod ==	.	//	                                               
replace wlwod = 	-3	 if id == 	15873	 & wlwod ==	.	//	N/A    HOSPITAL WAIT CAN BE 6 MONTHS                  
replace wlwod = 	0	 if id == 	17308	 & wlwod ==	10	//	10 MINUTES                                     
replace wlwy = 	14	 if id == 	17599	 & wlwy ==	.	//	1-3W                                                                    
replace wlwod = 	365	 if id == 	19249	 & wlwod ==	.	//	365 = 1 YEAR                                   
replace wlwy = 	1	 if id == 	19518	 & wlwy ==	.	//	01 (0-2 DEPENDING AS I ONLY WORK ON 3 DAYS (WEEK) & SATURDAY ROSTER:    
replace wlwod = 	14	 if id == 	19541	 & wlwod ==	2	//	2 WEEKS                                        
replace wlwod = 	-3	 if id == 	21812	 & wlwod ==	.	//	                                               
replace wlwy = 	14	 if id == 	22024	 & wlwy ==	2	//	2 WEEKS I ONLY SEE PATIENTS WITH APPOINTMENTS                           
replace wlwy = 	14	 if id == 	22757	 & wlwy ==	2	//	2 WKS                                                                   
replace wlwod = 	7	 if id == 	22757	 & wlwod ==	1	//	1 WK                                           
replace wlwod = 	-3	 if id == 	23186	 & wlwod ==	.	//	                                               
replace wlwy = 	-4	 if id == 	23489	 & wlwy ==	7	//	7 PLUS                                                                  
replace wlwy = 	7	 if id == 	24150	 & wlwy ==	1	//	1 WEEK                                                                  
replace wlwy = 	2.5	 if id == 	35770	 & wlwy ==	.	//	2-Mar
replace wlwy = 	7	 if id == 	47793	 & wlwy ==	1	//	1WEEK                                                                   
replace wlwod = 	-4	 if id == 	56226	 & wlwod ==	.	//	                                               
replace wlwod = 	-3	 if id == 	56955	 & wlwod ==	.	//	                                               
replace wlwod = 	0	 if id == 	57797	 & wlwod ==	.	//	DAILY                                          
replace wlwy = 	7	 if id == 	57843	 & wlwy ==	1	//	1 WK                                                                    
replace wlwod = 	-3	 if id == 	64246	 & wlwod ==	.	//	                                               
replace wlwy = 	14	 if id == 	69035	 & wlwy ==	.	//	14 (2 WEEKS)                                                            
replace wlwod = 	7	 if id == 	69688	 & wlwod ==	0	//	0 DAYS TO 2 WEEKS                              
replace wlwod = 	0	 if id == 	71518	 & wlwod ==	-3	//	0 N/A                                          
replace wlwod = 	-3	 if id == 	72455	 & wlwod ==	.	//	                                               
replace wlwy = 	0	 if id == 	72463	 & wlwy ==	.	//	0-                                                                      
replace wlwod = 	2.5	 if id == 	72469	 & wlwod ==	.	//	UP TO 5                                        
replace wlwy = 	7	 if id == 	72586	 & wlwy ==	1	//	1 WEEK                                                                  
replace wlwod = 	-3	 if id == 	75702	 & wlwod ==	.	//	                                               
replace wlwy = 	0	 if id == 	76233	 & wlwy ==	.	//	AVAILABLE IMMEDIATELY AS LOTS OF APPOINTMENTS 0                         
replace wlwod = 	0	 if id == 	79230	 & wlwod ==	30	//	30MINS                                         
replace wlwy = 	0	 if id == 	79717	 & wlwy ==	.	//	0 * OR 2-3 DAYS CONSIDERING & WORK PART TIME ONLY                       
replace wlwod = 	0	 if id == 	81030	 & wlwod ==	1	//	1 HOUR                                         
replace wlwy = 	7	 if id == 	82728	 & wlwy ==	1	//	1WEEK                                                                   
replace wlwy = 	0	 if id == 	83699	 & wlwy ==	17.5	//	15-20 MIN                                                               
replace wlwod = 	0	 if id == 	83699	 & wlwod ==	17.5	//	15-20 MIN                                      
replace wlwod = 	3.5	 if id == 	91751	 & wlwod ==	.	//	UP TO 7                                        
replace wlwy = 	0	 if id == 	97075	 & wlwy ==	.	//	WALK IN CLINIC                                                          
replace wlwod = 	0	 if id == 	97075	 & wlwod ==	.	//	WALK IN CLINIC VERY VARIABLE                   
replace wlwod = 	1	 if id == 	97661	 & wlwod ==	0	//	1 NORM IS SAME DAY                             
replace wlwod = 	1.5	 if id == 	98604	 & wlwod ==	.	//	I AM NOT CERTAIN 1-2                           
replace wlwy = 	0	 if id == 	1001454	 & wlwy ==	.	//	NO WAITING                                                              
replace wlwod = 	0	 if id == 	1001454	 & wlwod ==	.	//	NO WAITING                                     
replace wlwod = 	-4	 if id == 	1001564	 & wlwod ==	.	//	DEPENDS ON EACH DOCTOR                         
replace wlwod = 	-4	 if id == 	1001635	 & wlwod ==	.	//	VARIES                                         
replace wlwod = 	0	 if id == 	1002085	 & wlwod ==	.	//	NO WAITING TIME                                
replace wlwy = 	-4	 if id == 	1002141	 & wlwy ==	.	//	DAYS                                                                    
replace wlwod = 	0	 if id == 	1002141	 & wlwod ==	.	//	NO WAITING                                     
replace wlwy = 	0	 if id == 	1002326	 & wlwy ==	10	//	10 MIN.                                                                 
replace wlwy = 	2.5	 if id == 	1002392	 & wlwy ==	.	//	2-3DAYS                                                                 
replace wlwod = 	-4	 if id == 	1002424	 & wlwod ==	.	//	DEPENDS                                        
replace wlwy = 	-4	 if id == 	1002553	 & wlwy ==	.	//	VARIES PER ROSTER                                                       
replace wlwy = 	7	 if id == 	1002722	 & wlwy ==	.	//	FROM 00-14                                                              
replace wlwod = 	1.5	 if id == 	1002839	 & wlwod ==	-4	//	DON'T KNOW GUESS 1-2                           
replace wlwod = 	0	 if id == 	1005227	 & wlwod ==	3.5	//	3-4 HOURS                                      

replace wlwy=round(wlwy, .1)

***********************************************
*days off in past year

gen date_flag11 = ""

foreach x of var wlwhpy wlmlpy wlsdpy wlotpy  {

ren `x' `x'_comment
replace `x'_comment=upper(`x'_comment)

gen `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)$")


replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[ ][A-Z].*$")
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)[ ]\-[ ]([0-9]+)[ ][A-Z].*$")
replace `x'=real(`x'_comment) if regexm(`x'_comment, "^([0-9]+)[.]([0-9]+)$")

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\~([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\-\-([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^\?([0-9]+)$")
replace `x'=real(regexs(1)) if regexm(`x'_comment, "([0-9]+)$")&`x'==.

gen temp_`x'_1=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
gen temp_`x'_2=real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")

replace `x'=temp_`x'_1 if `x'==.&temp_`x'_1!=.&temp_`x'_1==temp_`x'_2
drop temp_`x'_1 temp_`x'_2

replace `x'=0 if (`x'_comment=="-"|`x'_comment=="--"|`x'_comment=="---")&`x'==.
replace `x'=0 if (`x'_comment=="NIL"|`x'_comment=="NIL.")&`x'==.
replace `x'=0 if (`x'_comment=="/"|`x'_comment=="ZERO")&`x'==.
replace `x'=1 if strmatch(`x'_comment,"ONE*")
replace `x'=0 if `x'_comment=="NONE" | `x'_comment=="NON" 
replace `x'=2 if `x'_comment=="TWO"
replace `x'=3 if `x'_comment=="THREE"
replace `x'=4 if `x'_comment=="FOUR"
replace `x'=5 if `x'_comment=="FIVE"
replace `x'=6 if `x'_comment=="SIX"
replace `x'=7 if `x'_comment=="SEVEN"
replace `x'=8 if `x'_comment=="EIGHT"
replace `x'=9 if `x'_comment=="NINE"
replace `x'=10 if `x'_comment=="TEN"
replace `x'=-3 if (`x'_comment=="NA"|strmatch(`x'_comment,"*N/A*")|strmatch(`x'_comment,"*APPLICABLE*"))&`x'==.
replace `x'=0.5 if `x'==.&`x'_comment=="<1"
replace `x'=0.5 if `x'==.&`x'_comment=="1/2"
replace `x'=0 if strmatch(`x'_comment,"*SAME*")&`x'==.

replace `x'=-4 if (strmatch(`x'_comment,"*SURE*")|strmatch(`x'_comment,"*T KNOW*"))&`x'==.
replace `x'=-4 if `x'_comment=="?"
replace `x'=0 if `x'_comment=="O"


replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]\-[ ][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][?]*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[?]*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[+]*$")&`x'==.

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[(][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)\-[ ][A-Z].*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[?]*$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[?]*$")&`x'==.

*replace date_flag11="date_flag11" if `x'==.&`x'_comment!="" 

list id `x'_comment if `x'==.&`x'_comment!="" 
destring `x', replace
}
*

foreach x of var wlsdpy wlotpy {

replace `x'=real(regexs(1))*5 if regexm(`x'_comment, "([0-9]+)[ ](([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))")
replace `x'=real(regexs(1))*5 if regexm(`x'_comment, "([0-9]+)(([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))")
replace `x'=real(regexs(1))*28 if regexm(`x'_comment, "([0-9]+)[ ](([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))")
replace `x'=real(regexs(1))*28 if regexm(`x'_comment, "([0-9]+)(([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))")

tab `x'_comment if `x'==. 
}
*

foreach x of var wlwhpy wlmlpy  {

replace `x'=`x'*4.3 if regexm(`x'_comment, "([0-9]+)[ ](([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))")
replace `x'=`x'*4.3 if regexm(`x'_comment, "([0-9]+)(([M][O][N][T][H])|([M][O][N][T][H][S])|([M][T][H][S])|([M][T][H]))")
replace `x'=`x' if regexm(`x'_comment, "([0-9]+)[ ](([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))")
replace `x'=`x' if regexm(`x'_comment, "([0-9]+)(([W][E][E][K])|([W][E][E][K][S])|([W][K][S])|([W][K]))")
replace `x'=`x'/5 if regexm(`x'_comment, "([0-9]+)[ ](([D][A][Y][S])|([D][A][Y])|([D][Y][S]))")
replace `x'=`x'/5 if regexm(`x'_comment, "([0-9]+)(([D][A][Y][S])|([D][A][Y])|([D][Y][S]))")

tab id `x'_comment if `x'==. 
}
*

foreach x of var wlwhpy wlmlpy wlsdpy wlotpy  {
gen a= 1 if regexm(`x'_comment, "^([0-9]+)$")
list id `x' `x'_comment if a!=1 & `x'_comment!="" 
drop a
}
*	

foreach x of var wlwhpy wlmlpy wlsdpy wlotpy {
list id `x' `x'_comment if `x'!=.&`x'_comment!="" & `x'!=real(`x'_comment) 
destring `x', replace
}
*

foreach x of var wlwhpy wlmlpy  wlsdpy wlotpy {
list id `x'_comment if `x'==.&`x'_comment!="" 
}
*
*gen date_flag11 = ""
foreach x of var wlwhpy wlmlpy  wlsdpy wlotpy {
replace date_flag11 = "date_flag11" if (`x'!=.&`x'_comment!="" & `x'!=real(`x'_comment)) | (`x'==.&`x'_comment!="")
}
*
tab date_flag11

preserve
sort id
keep if date_flag11=="date_flag11"
keep id sdtype response dir4 dir5 dir6 dir7 wlwhpy wlmlpy wlsdpy wlotpy wlwhpy_comment wlmlpy_comment wlsdpy_comment wlotpy_comment 
export excel using "L:\Data\Data Clean\Wave9\extracts\var_date\var_date11.xlsx", firstrow(variables) nolabel replace
restore
*gpc dir7, gpn dir7, spc dir6, spn dir6, dec dir4, den dir4, hdc dir5, hdn dir5

***
*date_flag11 edits
***
replace wlsdpy = 	10	 if id == 	521	 & wlsdpy ==	70	//	70
replace wlotpy = 	0	 if id == 	3541	 & wlotpy ==	.	//	                                                                                                       
replace wlwhpy = 	1.5	 if id == 	3854	 & wlwhpy ==	5	//	1,5                                                                                                
replace wlmlpy = 	0	 if id == 	4185	 & wlmlpy ==	.	//	                                                                                                       
replace wlsdpy = 	0	 if id == 	4185	 & wlsdpy ==	.	//	                     
replace wlotpy = 	0	 if id == 	4185	 & wlotpy ==	.	//	LEAVE WITHOUT PAY WORKED OS                                                                            
replace wlwhpy = 	-2	 if id == 	4972	 & wlwhpy ==	.	//	PRIVACY                                                                                            
replace wlotpy = 	0	 if id == 	6720	 & wlotpy ==	.	//	#NAME?
replace wlwhpy = 	2	 if id == 	6765	 & wlwhpy ==	.	//	VACATION 2 WEEKS                                                                                   
replace wlwhpy = 	8	 if id == 	6933	 & wlwhpy ==	.	//	WORKED 8 WEEKS                                                                                     
replace wlwhpy = 	0.5	 if id == 	7185	 & wlwhpy ==	2	//	//1/2
replace wlsdpy = 	72	 if id == 	8265	 & wlsdpy ==	72	//	72
replace wlsdpy = 	4	 if id == 	8438	 & wlsdpy ==	5	//	3 TO 5               
replace wlsdpy = 	16	 if id == 	12866	 /*& wlsdpy ==	1.6*/	//	1.6
replace wlmlpy = 	0	 if id == 	15236	 & wlmlpy ==	.	//	                                                                                                       
replace wlotpy = 	0	 if id == 	19666	 & wlotpy ==	7	//	7 HRS ONLY FOR FUNERAL!                                                                                
replace wlsdpy = 	-4	 if id == 	25112	 & wlsdpy ==	2	//	4- POST OPS X2       
replace wlsdpy = 	2	 if id == 	28486	 & wlsdpy ==	52	//	2 = 1/52             
replace wlotpy = 	40	 if id == 	30157	 & wlotpy ==	200	//	40 WEEK DAYS (UNPAID GOVERNANCE AND OVERSEAS WORK & 8 WEEKEND DAYS).                                   
replace wlotpy = 	1	 if id == 	31991	 & wlotpy ==	.	//	1 (1)                                                                                                  
replace wlotpy = 	0.5	 if id == 	34053	 & wlotpy ==	2	//	//1/2
replace wlotpy = 	0	 if id == 	34656	 & wlotpy ==	.	//	0 *** TESTS OF FATHER                                                                                  
replace wlsdpy = 	0	 if id == 	36553	 & wlsdpy ==	.	//	                     
replace wlotpy = 	10	 if id == 	38242	 & wlotpy ==	.	//	10 -> CONFERENCE LEAVE                                                                                 
replace wlotpy = 	7	 if id == 	41085	 & wlotpy ==	.	//	7 ***                                                                                                  
replace wlotpy = 	90	 if id == 	41226	 & wlotpy ==	.	//	90 -> SABBATICAL                                                                                       
replace wlotpy = 	0	 if id == 	41791	 & wlotpy ==	.	//	#NAME?
replace wlotpy = 	36	 if id == 	45641	 & wlotpy ==	84	//	36 - ABOUT 3 MTHS OF 3 DAYS/WK                                                                         
replace wlotpy = 	12.5	 if id == 	46570	 & wlotpy ==	25	//	2.5 WEEKS                                                                                              
replace wlotpy = 	5	 if id == 	53899	 & wlotpy ==	.	//	5 -> FAMILY/CHILDREN SIDE @ ***                                                                        
replace wlotpy = 	180	 if id == 	54867	 & wlotpy ==	84	//	180 TOTAL @ 7 DAYS A FORTNIGHT OF WORK = 84                                                            
replace wlmlpy = 	0.5	 if id == 	55761	 & wlmlpy ==	.	//	0.5 WEEKS                                                                                              
replace wlotpy = 	7	 if id == 	55886	 & wlotpy ==	.	//	7 -> CONFERENCE                                                                                        
replace wlotpy = 	0	 if id == 	56263	 & wlotpy ==	715	//	0 75 00 80 715                                                                                         
replace wlwhpy = 	-4	 if id == 	56736	 & wlwhpy ==	.	//	WORKING PART-TIME (2/3)                                                                            
replace wlotpy = 	-4	 if id == 	56736	 & wlotpy ==	.	//	AS ABOVE                                                                                               
replace wlotpy = 	-4	 if id == 	56935	 & wlotpy ==	2016	//	HAD A WHOLE YEAR OFF, RESTARTED 5/01/2016                                                              
replace wlmlpy = 	6	 if id == 	58082	 & wlmlpy ==	.	//	6/12 M NOW AND ONGOING                                                                                 
replace wlwhpy = 	6	 if id == 	58241	 & wlwhpy ==	.	//	6 3 MTHS AWAY VOLUNTEER WORK                                                                       
replace wlotpy = 	20	 if id == 	59292	 & wlotpy ==	15	//	LONG SERVICE LEAVE 3 WEEKS AND PDL 1 WEEK                                                              
replace wlmlpy = 	20	 if id == 	61585	 & wlmlpy ==	.	//	20 5 MONTH MATERNITY                                                                                   
replace wlsdpy = 	0.5	 if id == 	62083	 & wlsdpy ==	2	//	//1/2
replace wlotpy = 	10	 if id == 	62083	 & wlotpy ==	0	//	0 PLUS PROF DEVELOP - 10 DAYS                                                                          
replace wlmlpy = 	0	 if id == 	68454	 & wlmlpy ==	.	//	0 -- ADULT KIDS                                                                                        
replace wlotpy = 	4	 if id == 	68576	 & wlotpy ==	.	//	4 -> CATARACT ***                                                                                      
replace wlmlpy = 	0	 if id == 	75539	 & wlmlpy ==	.	//	0 -> JUST STARTED 1ST JULY                                                                             
replace wlotpy = 	-4	 if id == 	77816	 & wlotpy ==	.	//	UNKNOWN                                                                                                
replace wlwhpy = 	4	 if id == 	1001635	 /*& wlwhpy ==	17.2*/	//	4 PAST YEAR ONLY OUT OF 7 MONTHS                                                                   
replace wlotpy = 	-4	 if id == 	1002141	 & wlotpy ==	.	//	CARER LEAVE                                                                                            
replace wlmlpy = 	0	 if id == 	1002620	 & wlmlpy ==	.	//	NO                                                                                                     
replace wlotpy = 	0	 if id == 	1002620	 & wlotpy ==	.	//	NO                                                                                                     
replace wlmlpy = 	0	 if id == 	1004052	 & wlmlpy ==	.	//	I DID NOT GET MATERNITY LEAVE SO UNPAID LEAVE FOR 5 WEEKS (AS WAS NOT ALLOWED TO USE SICK LEAVE EITHER)
replace wlotpy = 	-4	 if id == 	1005220	 & wlotpy ==	.	//	THE REST FOR STUDY FOR THE FELLOWSHIP EXAM                                                             

list id dirall wlwhpy wlmlpy wlsdpy wlotpy if wlwhpy>52 & wlwhpy!=. 
	replace wlwhpy = -4 if id == 32550 & wlwhpy == 60

list id dirall wlwhpy wlmlpy wlsdpy wlotpy if wlmlpy>52 & wlmlpy!=. 
	
list id dirall wlwhpy wlmlpy wlsdpy wlotpy if wlsdpy>365 & wlsdpy!=. 
	*all good
	
list id dirall wlwhpy wlmlpy wlsdpy wlotpy if wlotpy>365 & wlotpy!=. 
	*all good

foreach x of var wlwhpy wlmlpy  {
replace `x'=round(`x',1)
rename `x'_comment `x'_text
tab `x'
}

foreach x of var wlsdpy wlotpy  {
replace `x'=round(`x',1)
rename `x'_comment `x'_text
tab `x'
}

gen leavewh=.
replace leavewh=wlwhpy if wlwhpy>4 & wlwhpy<.  
gen a= 1 if regexm(wlwhpy_text, "^([0-9]+)$")
replace leavewh=. if strmatch(wlwhpy_text,"*CONF*")|strmatch(wlwhpy_text,"*STUDY*")|strmatch(wlwhpy_text,"*RDO*")
list id wlwhpy wlwhpy_text leavewh if a!=1 & wlwhpy_text!="" & leavewh==wlwhpy 
drop a


gen leaveml=.
replace leaveml=wlmlpy if wlmlpy<.  
gen a= 1 if regexm(wlmlpy_text, "^([0-9]+)$")
replace leaveml=. if strmatch(wlmlpy_text,"*CONF*")|strmatch(wlmlpy_text,"*STUDY*")
list id wlmlpy wlmlpy_text leaveml if a!=1 & wlmlpy_text!="" & wlmlpy>2 &wlmlpy<. & leaveml==wlmlpy 
drop a

gen leavesd=.
replace leavesd=wlsdpy if wlsdpy>20 & wlsdpy<.  
gen a= 1 if regexm(wlsdpy_text, "^([0-9]+)$")
list id wlsdpy wlsdpy_text leavesd if a!=1 & wlsdpy_text!="" & leavesd==wlsdpy 
drop a

gen leaveot=.
replace leaveot=wlotpy if wlotpy>10 & wlotpy<.  
gen a= 1 if regexm(wlotpy_text, "^([0-9]+)$")
replace leaveot=. if strmatch(wlotpy_text,"*CONF*")|strmatch(wlotpy_text,"*STUDY*")|strmatch(wlotpy_text,"*RDO*")| ///
strmatch(wlotpy_text,"*TEACH*")|strmatch(wlotpy_text,"*EXAM*")|strmatch(wlotpy_text,"*EDUCATION*")| ///
strmatch(wlotpy_text,"*PHD*")|strmatch(wlotpy_text,"*PROF*")|strmatch(wlotpy_text,"*PDL*")|strmatch(wlotpy_text,"*CME*") ///
|strmatch(wlotpy_text,"*CPD*")|strmatch(wlotpy_text,"*TESL*")|strmatch(wlotpy_text,"*ADO*") ///
|strmatch(wlotpy_text,"*MEETING*")|strmatch(wlotpy_text,"*LECTUR*")
list id wlotpy wlotpy_text leaveot if a!=1 & wlotpy_text!="" & leaveot==wlotpy 
drop a

*replace leaveot=. if id==26449


foreach x of var leavewh leaveml leavesd leaveot {
replace `x' = 0 if `x'<0|`x'==.
}

gen w9alleave = .       // total non-work-related leave taken in past year (in months)
replace w9alleave = (leavewh+leaveml+(leavesd/5)+(leaveot/5))/4.5
replace w9alleave=round(w9alleave, 1)
list id w9alleave leavewh leaveml leavesd leaveot in 6001/8995

drop leave*

compress
****************************************************

foreach x of var pwsyr ficsyr jsbsyr pirsyr pireyr piyrb picmd pwsmth pwsyr pwwmth pwwyr  /// 
				 pindyr pindmt glyrrs fcpr wlww wlwd wlwy wlwod wlsdpy wlotpy wlwhpy wlmlpy pifryr pifayr {
label var `x' 		"Cleaned"
}
*
save "${ddtah}\temp_all.dta", replace
