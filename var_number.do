
**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: clean the variables related to other numeric responses in financial and working load sections
********************************************************

global ddtah="D:\Data\Data Clean\Wave9\dtah"
global ddo="D:\Data\Data Clean\Wave9"
global dlog="D:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\var_number.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

*list all related variables: 

/*pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo*/
/*wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau*/
/*wlcmin wlcnpmin wlcsmin wlrh wlpch pwhlh*/
/*wlcf wlcnpf wlcnpn wlcsf wlcsn fibv fidme fidp fiip*/
/*wlbbp*/
/*wlocrpn wlocrhn wlocrpe wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr*/
/*wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe wlcotpve wlcot*/
/*fcndc fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6*/
/*glnl*/

*convert all numeric response to numbers, keep the text responses in *_comment

*added in wave 9 - none

/*tab1 pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau 
				 wlcmin wlcnpmin wlcsmin wlrh wlpch wlcf wlcnpf wlcsf fibv fidme fidp ///
				 fispm fisnpm fisgi fishw fisoth ///
				 fiip fisadd wlbbp wlocrpn wlocrhn wlocrpe /// 
				 wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe /// 
				 wlcotpve wlcot fcndc fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6 pwhlh glnl*/


* we attempt to automatically recode comments into a number. We then check that all the automatic coding was valid. We then attempt to manually recode
*where automatic recodes were not possible.				 
				 
				 
drop wlva_comment				

foreach x of var pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau ///
				 wlcmin wlcnpmin wlcsmin wlrh wlpch wlcf wlcnpf wlcnpn wlcsf wlcsn fibv fidme fidp ///
				 fispm fisnpm fisgi fishw fisoth ///
				 fiip fisadd wlbbp wlocrpn wlocrhn wlocrpe /// 
				 wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe /// 
				 wlcotpve wlcot fcndc fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6 pwhlh glnl ///
				 pioth {


gen `x'_temp = trim(`x')
replace `x'_temp = upper(`x'_temp)
drop `x'

replace `x'_temp = subinstr(`x'_temp, "~", "", .)
replace `x'_temp = subinstr(`x'_temp, "?", "", .)
replace `x'_temp = subinstr(`x'_temp, "`", "", .)
replace `x'_temp = subinstr(`x'_temp, "+-", "", .)
replace `x'_temp = subinstr(`x'_temp, "ABOUT", "", .)
replace `x'_temp = subinstr(`x'_temp, "APPROX", "", .)


replace `x'_temp = trim(`x'_temp)

gen `x' = real(regexs(1)) if regexm(`x'_temp, "^([0-9]+)$")

gen `x'_1 = real(regexs(1)) if regexm(`x'_temp, "^([0-9]+)\-([0-9]+)")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_temp, "^([0-9]+)\-([0-9]+)")&`x'==.

replace `x' = (`x'_1 + `x'_2) / 2 if regexm(`x'_temp, "^([0-9]+)\-([0-9]+)")&`x'==.&`x'_2!=0
replace `x' = `x'_1 if regexm(`x'_temp, "^([0-9]+)\-([0-9]+)")&`x'==.&`x'_2==0

gen `x'_comment = upper(`x'_temp) if `x'==.&`x'_temp!=""
drop `x'_temp `x'_1 `x'_2
}
*

******************************************************

*Dollar values

foreach x of var wlcf wlcnpf wlcsf fibv fidme fidp fiip fisadd{

replace `x'=0 if `x'==.&(`x'_comment=="-0"|`x'_comment=="NIL"|`x'_comment=="ZERO"|`x'_comment=="NONE"|`x'_comment=="O")
replace `x'=-3 if (`x'==.|`x'==0)&(strmatch(`x'_comment, "*NA*")|strmatch(`x'_comment, "*NOT APPLICABLE*")|strmatch(`x'_comment, "*N/A*"))

replace `x'_comment = trim(`x'_comment)
replace `x'_comment = itrim(`x'_comment)

replace `x'_comment = subinstr(`x'_comment, "$", "", .)
replace `x'_comment = subinstr(`x'_comment, "/-", "", .)
replace `x'_comment = subinstr(`x'_comment, ".-", "", .)
*replace `x'_comment = subinstr(`x'_comment, "-", "", .)
replace `x'_comment = subinstr(`x'_comment, "/=", "", .)
*replace `x'_comment = subinstr(`x'_comment, "=", "", .)

replace `x'_comment = regexr(`x'_comment, "^\-", "")
replace `x'_comment = regexr(`x'_comment, "\-$", "")
replace `x'_comment = regexr(`x'_comment, "^\=", "")
replace `x'_comment = regexr(`x'_comment, "\=$", "")

replace `x' = (real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
replace `x' = (real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[ ][A-Z]+$")&`x'==.
replace `x' = (real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[A-Z]+$")&`x'==.

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)$")&`x'==.
replace `x' = real(regexs(1)) + real(regexs(2))/100 if regexm(`x'_comment, "^([0-9]+)[.|:|=]([0-9]+)$")&`x'==.
replace `x' = real(regexs(1))*1000 + real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[,|.]([0-9][0-9][0-9])$")&`x'==.
replace `x' = real(regexs(1)) + real(regexs(2))/100 if regexm(`x'_comment, "^([0-9]+)[.|-]([0-9][0-9])$")&`x'==.
replace `x' = real(regexs(1))*1000 + real(regexs(2)) + real(regexs(3))/100 if regexm(`x'_comment, "^([0-9]+)[,|.]([0-9][0-9][0-9])[.|-]([0-9][0-9])$")&`x'==.
replace `x' = real(regexs(1))*1000000 + real(regexs(2))*1000 + real(regexs(3)) if regexm(`x'_comment, "^([0-9])[,]([0-9][0-9][0-9])[,]([0-9][0-9][0-9])")&`x'==.

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.

replace `x' = real(regexs(1))*1000 + real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[,|.]([0-9][0-9][0-9])[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1))*1000 + real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[,|.| ]([0-9][0-9][0-9]).*")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^[:]([0-9]+)$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[:]$")&`x'==.

replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[M]$")
replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "([0-9]+)[M]$")
replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "([0-9]+.[0-9]+) MILLION$")

replace `x'=real(regexs(1))*1000 if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[K]$")
replace `x'=real(regexs(1))*1000 if regexm(`x'_comment, "([0-9]+)[K]$")

replace `x'_comment=trim(`x'_comment)

gen `x'_1=regexs(1) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
gen `x'_2=regexs(2) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
replace `x'=(real(`x'_1)+real(`x'_2))/2 if `x'_1==`x'_2&`x'_1!=""&`x'_2!=""
drop `x'_1 `x'_2
list id dtimage `x' `x'_comment if `x'==.&`x'_comment!="" // DON'T DO EDITS AFTER THIS STEP. IT'S ONLY FOR VIEWING CASES FOR strmatch COMMAND
}
*

*Dollar values

foreach x of var wlcf wlcnpf wlcsf fibv fidme fidp fiip fisadd{
list id dtimage `x' `x'_comment if `x'==.&`x'_comment!=""
}
*
gen wlcfbulk=1 if strmatch(wlcf_comment,"*bulk*")|strmatch(wlcf_comment,"*BULK*")|strmatch(wlcf_comment,"*MEDICARE*")|strmatch(wlcf_comment,"*MBS*")|strmatch(wlcf_comment,"*M/C*")
replace wlcfbulk=1 if wlbbp==100
replace wlcf=37.05 if wlcfbulk==1  //need to update this value each year according to current medicare rate
replace wlcf=-3 if strmatch(wlcf_comment,"*N/A*") | wlcf_comment=="NA"
replace wlcf=-4 if strmatch(wlcf_comment,"*NOT SURE*") | strmatch(wlcf_comment,"*DONT KNOW*")| strmatch(wlcf_comment,"*DON'T KNOW*")
list id dtimage wlcf_comment wlcf wlcfbulk wlbbp if (wlcf==.&wlcf_comment!="") 
*wlcf = what is your current (level b) fee for a standard consultation?
*the listed fee for 2015 is $37.05 on www.mbsonline.gov.au

gen num_flag1 = ""
*foreach x of var wlcf wlcnpf wlcsf fibv fidme fidp fiip fisadd{
replace num_flag1="num_flag1" if wlcf==.&wlcf_comment!="" /* `x'==.&`x'_comment!=""*/
*}
*
tab num_flag1
preserve
keep if num_flag1=="num_flag1"
keep id dir6 sdtype response wlcf wlcf_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num1_readonly.xlsx", firstrow(variables) nolabel replace
restore

*wlcf - 1, 2 ; wlcnpf - 2 ; wlcsf - 2 fibv - all ;  fidme - all ; fidp - 1, 2 ; fiip - all ; fisadd - all


replace wlcf = 	21	 if id == 	1002620	 & wlcf ==	.	//	ITEM NO ITEM NO'S 53                                                                                        
replace wlcf = 	37.05	 if id == 	1001189	 & wlcf ==	.	//	0
replace wlcf = 	37.5	 if id == 	56829	 & wlcf ==	.	//	FULLY BB                                                                                                    
replace wlcf = 	37.6	 if id == 	58177	 & wlcf ==	.	//	37.60 DOLLAR                                                                                                
replace wlcf = 	57	 if id == 	79631	 & wlcf ==	.	//	-57
replace wlcf = 	70	 if id == 	1002128	 & wlcf ==	.	//	70
replace wlcf = 	70	 if id == 	97336	 & wlcf ==	.	//	70 60 FOR PENSIONER                                                                                         
replace wlcf = 	72.5	 if id == 	1002261	 & wlcf ==	.	//	68.00-77                                                                                                    
replace wlcf = 	80	 if id == 	22096	 & wlcf ==	.	//	80 (5%) ON 63                                                                                               
                                       


list id dtimage wlcf_comment wlcf wlcfbulk if (wlcf==.&wlcf_comment!="")


*check for high values
list id dirall wlbbp wlcf wlcf_comment if wlcf>1000& wlcf!=.
replace wlcf=wlcf/100 if wlcf>900&wlcf!=.   //all these were just missing decimal - NOTE THE THRESHOLD THAT CAN CHANGE EACH WAVE

drop wlcfbulk 



* specialists

*first need to clean item numbers so that can use these to calculate billing
foreach x of var wlcnpn wlcsn {
list id dirall `x' `x'_comment if `x'==. &`x'_comment!=""
}
*
gen num_flagx = ""
foreach x of var wlcnpn wlcsn {
replace num_flagx = "num_flagx" if `x'==. &`x'_comment!=""
}
*
preserve
sort id
keep if num_flagx=="num_flagx"
keep id typecont response dir5 dir6 wlcnpn wlcsn wlcnpn_comment wlcsn_comment wlcnpf wlcsf wlcnpf_comment wlcsf_comment wlcfna wlcfna_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_numx.xlsx", firstrow(variables) nolabel replace
restore

replace wlcsn = 	302	 if id == 	1431	 & wlcsn ==	.	//	302/304                                                            
replace wlcnpf = 	0	 if id == 	4479	 & wlcnpf ==	.	//	FREE INITIAL CONSULTAION & THEN MOST TREATMENT COSMETIC    
replace wlcsn = 	23	 if id == 	4479	 & wlcsn ==	.	//	23 OR                                                              
replace wlcnpn = 	13870	 if id == 	24615	 & wlcnpn ==	.	//	13870/73                                                           
replace wlcnpf = 	-4	 if id == 	25561	 & wlcnpf ==	66	//	                                //IT DOESN'T LOOK LIKE 66                           
replace wlcsf = 	-4	 if id == 	25561	 & wlcsf ==	66	//	                                //IT DOESN'T LOOK LIKE 66                           
replace wlcnpn = 	296	 if id == 	26012	 & wlcnpn ==	.	//	296 BULK BILLED                                                    
replace wlcnpn = 	104	 if id == 	27096	 & wlcnpn ==	.	//	104 (OR 16401)                                                     
replace wlcsf = 	103	 if id == 	27096	 & wlcsf ==	.	//	110 95                                                           
replace wlcsn = 	105	 if id == 	27096	 & wlcsn ==	.	//	105 (16500)                                                        
replace wlcfna =	1	 if id == 	27142		//	NOT RELEVANT ANAESTHETIST
replace wlcnpn = 	104	 if id == 	27419	 & wlcnpn ==	.	//	162 ITEM # 104                                                     
replace wlcsn = 	105	 if id == 	27419	 & wlcsn ==	.	//	//ORIGINAL VALUE WAS 72, BUT DOCTOR NOTED ITEM 105                                                        
replace wlcnpn = 	17615	 if id == 	27831	 & wlcnpn ==	.	//	17615 17690                                                        
replace wlcsn = 	-3	 if id == 	27831	 & wlcsn ==	.	//	THERE IS NO ITEM NO FOR POST OP VISIT FOR ANAESTHESTISTS           
replace wlcnpn = 	-3	 if id == 	29581	 & wlcnpn ==	.	//	N/A (NOT MEDICARE RELATED)                                         
replace wlcsn = 	-3	 if id == 	29581	 & wlcsn ==	.	//	N/A (NOT MEDICARE RELATED)                                         
replace wlcnpf = 	89	 if id == 	30477	 & wlcnpf ==	.	//	//ITEM 57 OR 170, TAKE AVERAGE
replace wlcnpn = 	-4	 if id == 	30477	 & wlcnpn ==	.	//	57 OR 170                                                          
replace wlcnpn = 	-3	 if id == 	30617	 & wlcnpn ==	.	//	NA                                                                 
replace wlcsn = 	-3	 if id == 	30617	 & wlcsn ==	.	//	NA                                                                 
replace wlcsn = 	-3	 if id == 	30757	 & wlcsn ==	.	//	N/A                                                                
replace wlcsn = 	116	 if id == 	30858	 & wlcsn ==	.	//	1.16
replace wlcnpn = 	306	 if id == 	31308	 & wlcnpn ==	.	//	320 ITEM NO 306 THE WORDING IS CONFUSING  $ AMT AN ITEM DESCRIPTION
replace wlcsn = 	320	 if id == 	31308	 & wlcsn ==	.	//	320 ITEM NO 306 THE WORDING IS CONFUSING  $ AMT AN ITEM DESCRIPTION
replace wlcnpf = 	-2	 if id == 	33720	 & wlcnpf ==	.	//	FRANKLY THAT IS MY BUSINESS NOT APPROPRIATE                
replace wlcnpn = 	-2	 if id == 	33720	 & wlcnpn ==	.	//	FRANKLY THAT IS MY BUSINESS NOT APPROPRIATE                        
replace wlcsf = 	-2	 if id == 	33720	 & wlcsf ==	.	//	FRANKLY THAT IS MY BUSINESS NOT APPROPRIATE                      
replace wlcsn = 	-2	 if id == 	33720	 & wlcsn ==	.	//	FRANKLY THAT IS MY BUSINESS NOT APPROPRIATE                        
replace wlcsn = 	-4	 if id == 	33950	 & wlcsn ==	.	//	304 OR 306                                                         
replace wlcnpf = 	-2	 if id == 	34015	 & wlcnpf ==	.	//	NYOB                                                       
replace wlcnpn = 	-2	 if id == 	34015	 & wlcnpn ==	.	//	NYOB                                                               
replace wlcsn = 	-4	 if id == 	35721	 & wlcsn ==	.	//	143/132                                                            
replace wlcnpf = 	235	 if id == 	36156	 & wlcnpf ==	.	//	200/270                                                    
replace wlcnpn = 	-4	 if id == 	36156	 & wlcnpn ==	.	//	104/16401                                                          
replace wlcnpn = 	-4	 if id == 	37456	 & wlcnpn ==	.	//	17615 17690                                                        
replace wlcnpn = 	0	 if id == 	39789	 & wlcnpn ==	.	//	0
replace wlcnpn = 	132	 if id == 	40210	 & wlcnpn ==	.	//	132/110, 132 CIRCLED
replace wlcsn = 	133	 if id == 	40210	 & wlcsn ==	.	//	133/116, 133 CIRCLED
replace wlcnpf = 	280	 if id == 	41340	 & wlcnpf ==	280132	//	280 132, TAKE CELL VALUE     
replace wlcnpn = 	160	 if id == 	41340	 & wlcnpn ==	.	//	160 110, TAKE CELL VALUE
replace wlcsf = 	100	 if id == 	41340	 & wlcsf ==	100116	//	100 116, TAKE CELL VALUE
replace wlcsn = 	116	 if id == 	41340	 & wlcsn ==	.	//	116 116, TAKE CELL VALUE
replace wlcnpn = 	17610	 if id == 	42205	 & wlcnpn ==	.	//	176.1, SHOULD BE 17610
replace wlcnpn = 	-4	 if id == 	45365	 & wlcnpn ==	.	//	132 & 112 TELEHEALTH                                               
replace wlcsn = 	-4	 if id == 	45365	 & wlcsn ==	.	//	116 & 112                                                          
replace wlcnpn = 	17610	 if id == 	53749	 & wlcnpn ==	12610	//	VALUE WAS 17610
replace wlcsn = 	-4	 if id == 	54192	 & wlcsn ==	.	//	110 / 131                                                          
replace wlcsn = 	-4	 if id == 	72785	 & wlcsn ==	.	//	116/133                                                            
replace wlcnpn = 	296	 if id == 	73395	 & wlcnpn ==	.	//	AMA 296                                                            
replace wlcsn = 	-4	 if id == 	84520	 & wlcsn ==	.	//	304/306                                                            
replace wlcnpn = 	-4	 if id == 	1000172	 & wlcnpn ==	.	//	110/2                                                              
replace wlcsn = 	-4	 if id == 	1000172	 & wlcsn ==	.	//	116/2                                                              
                                                             


*only use item number if fee variable is blank
list id sdtype wlcnpf wlcnpn wlcnpn_comment wlcsf wlcsn wlcsn_comment wlcfna wlcfna_comment if (wlcnpn_comment!=""|wlcsn_comment!=""|wlcna_comment!="")&(wlcnpf==.&wlcnpn==.)

gen num_flag2=""
replace num_flag2="num_flag2" if (wlcnpn_comment!=""|wlcsn_comment!=""|wlcna_comment!="")&(wlcnpf==.&wlcnpn==.)
tab num_flag1 num_flag2, m
preserve
sort id
keep if num_flag2=="num_flag2"
keep id sdtype response dirall wlcnpf wlcnpf_comment wlcnpn wlcnpn_comment wlcsf wlcsf_comment wlcsn wlcsn_comment wlcfna wlcfna_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num2.xls", firstrow(variables) nolabel replace
restore

***
*mc_flag2 edits
***


foreach x in np s{
replace wlc`x'f=	37.05	if wlc`x'n==	23	& wlc`x'f==.
replace wlc`x'f=	71.7	if wlc`x'n==	36	& wlc`x'f==.
replace wlc`x'f=	105.55	if wlc`x'n==	44	& wlc`x'f==.
replace wlc`x'f=	21	if wlc`x'n==	53	& wlc`x'f==.
replace wlc`x'f=	38	if wlc`x'n==	54	& wlc`x'f==.
replace wlc`x'f=	61	if wlc`x'n==	57	& wlc`x'f==.
replace wlc`x'f=	85.55	if wlc`x'n==	104	& wlc`x'f==.
replace wlc`x'f=	43	if wlc`x'n==	105	& wlc`x'f==.
replace wlc`x'f=	71	if wlc`x'n==	106	& wlc`x'f==.
replace wlc`x'f=	125.5	if wlc`x'n==	107	& wlc`x'f==.
replace wlc`x'f=	79.45	if wlc`x'n==	108	& wlc`x'f==.
replace wlc`x'f=	192.8	if wlc`x'n==	109	& wlc`x'f==.
replace wlc`x'f=	150.9	if wlc`x'n==	110	& wlc`x'f==.
replace wlc`x'f=	64.2	if wlc`x'n==	113	& wlc`x'f==.
replace wlc`x'f=	113.2	if wlc`x'n==	114	& wlc`x'f==.
replace wlc`x'f=	75.5	if wlc`x'n==	116	& wlc`x'f==.
replace wlc`x'f=	43	if wlc`x'n==	119	& wlc`x'f==.
replace wlc`x'f=	183.1	if wlc`x'n==	122	& wlc`x'f==.
replace wlc`x'f=	110.75	if wlc`x'n==	128	& wlc`x'f==.
replace wlc`x'f=	79.75	if wlc`x'n==	131	& wlc`x'f==.
replace wlc`x'f=	263.9	if wlc`x'n==	132	& wlc`x'f==.
replace wlc`x'f=	132.1	if wlc`x'n==	133	& wlc`x'f==.
replace wlc`x'f=	263.9	if wlc`x'n==	135	& wlc`x'f==.
replace wlc`x'f=	263.9	if wlc`x'n==	137	& wlc`x'f==.
replace wlc`x'f=	132.5	if wlc`x'n==	139	& wlc`x'f==.
replace wlc`x'f=	452.65	if wlc`x'n==	141	& wlc`x'f==.
replace wlc`x'f=	282.95	if wlc`x'n==	143	& wlc`x'f==.
replace wlc`x'f=	548.85	if wlc`x'n==	145	& wlc`x'f==.
replace wlc`x'f=	343.1	if wlc`x'n==	147	& wlc`x'f==.
replace wlc`x'f=	452.65	if wlc`x'n==	291	& wlc`x'f==.
replace wlc`x'f=	260.3	if wlc`x'n==	296	& wlc`x'f==.
replace wlc`x'f=	260.3	if wlc`x'n==	297	& wlc`x'f==.
replace wlc`x'f=	311.3	if wlc`x'n==	299	& wlc`x'f==.
replace wlc`x'f=	86.45	if wlc`x'n==	302	& wlc`x'f==.
replace wlc`x'f=	133.1	if wlc`x'n==	304	& wlc`x'f==.
replace wlc`x'f=	183.65	if wlc`x'n==	306	& wlc`x'f==.
replace wlc`x'f=	213.15	if wlc`x'n==	308	& wlc`x'f==.
replace wlc`x'f=	106.6	if wlc`x'n==	318	& wlc`x'f==.
replace wlc`x'f=	86.45	if wlc`x'n==	322	& wlc`x'f==.
replace wlc`x'f=	124.65	if wlc`x'n==	332	& wlc`x'f==.
replace wlc`x'f=	85.55	if wlc`x'n==	385	& wlc`x'f==.
replace wlc`x'f=	43	if wlc`x'n==	386	& wlc`x'f==.
replace wlc`x'f=	42.75	if wlc`x'n==	411	& wlc`x'f==.
replace wlc`x'f=	82.65	if wlc`x'n==	412	& wlc`x'f==.
replace wlc`x'f=	121.7	if wlc`x'n==	413	& wlc`x'f==.
replace wlc`x'f=	97.05	if wlc`x'n==	507	& wlc`x'f==.
replace wlc`x'f=	137.3	if wlc`x'n==	511	& wlc`x'f==.
replace wlc`x'f=	212.6	if wlc`x'n==	515	& wlc`x'f==.
replace wlc`x'f=	71.7	if wlc`x'n==	2713	& wlc`x'f==.
replace wlc`x'f=	134.1	if wlc`x'n==	2717	& wlc`x'f==.
replace wlc`x'f=	150.9	if wlc`x'n==	2801	& wlc`x'f==.
replace wlc`x'f=	75.5	if wlc`x'n==	2806	& wlc`x'f==.
replace wlc`x'f=	150.9	if wlc`x'n==	3005	& wlc`x'f==.
replace wlc`x'f=	75.5	if wlc`x'n==	3010	& wlc`x'f==.
replace wlc`x'f=	183.1	if wlc`x'n==	3018	& wlc`x'f==.
replace wlc`x'f=	129.6	if wlc`x'n==	6007	& wlc`x'f==.
replace wlc`x'f=	85.55	if wlc`x'n==	6011	& wlc`x'f==.
replace wlc`x'f=	362.1	if wlc`x'n==	13870	& wlc`x'f==.
replace wlc`x'f=	268.6	if wlc`x'n==	13873	& wlc`x'f==.
replace wlc`x'f=	85.55	if wlc`x'n==	16401	& wlc`x'f==.
replace wlc`x'f=	43	if wlc`x'n==	16404	& wlc`x'f==.
replace wlc`x'f=	47.15	if wlc`x'n==	16500	& wlc`x'f==.
replace wlc`x'f=	140.55	if wlc`x'n==	16501	& wlc`x'f==.
replace wlc`x'f=	43	if wlc`x'n==	17610	& wlc`x'f==.
replace wlc`x'f=	85.55	if wlc`x'n==	17615	& wlc`x'f==.
replace wlc`x'f=	118.5	if wlc`x'n==	17620	& wlc`x'f==.
replace wlc`x'f=	43	if wlc`x'n==	17640	& wlc`x'f==.
replace wlc`x'f=	72.75	if wlc`x'n==	17645	& wlc`x'f==.
replace wlc`x'f=	118.5	if wlc`x'n==	17650	& wlc`x'f==.
replace wlc`x'f=	39.55	if wlc`x'n==	17690	& wlc`x'f==.
replace wlc`x'f=	396	if wlc`x'n==	20560	& wlc`x'f==.
replace wlc`x'f=	85.55	if wlc`x'n==	51700	& wlc`x'f==.
replace wlc`x'f=	43	if wlc`x'n==	51703	& wlc`x'f==.
replace wlc`x'f=	70	if wlc`x'n==	55704	& wlc`x'f==.
}
*


foreach x of var wlcnpn wlcsn{
replace `x'=-3 if strmatch(`x'_comment,"*N/A*") | `x'_comment=="NA"|strmatch(`x'_comment,"*NOT APPLICABLE*")
replace `x'=-4 if strmatch(`x'_comment,"*NOT SURE*") | strmatch(`x'_comment,"*DONT KNOW*")| strmatch(`x'_comment,"*DON'T KNOW*")
}
*

* If there are 2 items numbers, i have used the mean fee, but do not quote the 2 numbers as numeric variables only permit one number.
list id wlcnpf wlcnpn wlcnpn_comment wlcsf wlcsn wlcsn_comment wlcfna if (wlcnpn_comment!=""&wlcnpn==.)|(wlcsn_comment!=""&wlcsn==.)

gen num_flag3=""
replace num_flag3="num_flag3" if (wlcnpn_comment!=""&wlcnpn==.)|(wlcsn_comment!=""&wlcsn==.)
tab num_flag3 num_flag1, m
preserve
sort id
keep if num_flag3=="num_flag3"
keep id sdtype response dirall wlcnpf wlcnpf_comment wlcnpn wlcnpn_comment wlcsf wlcsf_comment wlcsn wlcsn_comment wlcfna wlcfna_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num3.xlsx", firstrow(variables) nolabel replace
restore

***
*num_flag3 edits
***
replace wlcsn = 	302	 if id == 	1431	 & wlcsn ==	.	//	302/304                                                            
*replace wlcsn = 	23	 if id == 	4479	 & wlcsn ==	.	//	23 OR                                                              
*replace wlcfna = 	0	 if id == 	23701	 & wlcfna ==	.		                                                                      
replace wlcnpn = 	13870	 if id == 	24615	 & wlcnpn ==	.	//	13870/73                                                           
replace wlcnpn = 	296	 if id == 	26012	 & wlcnpn ==	.	//	296 BULK BILLED                                                    
*replace wlcnpn = 	104	 if id == 	27096	 & wlcnpn ==	.	//	104 (OR 16401)                                                     
*replace wlcsn = 	105	 if id == 	27096	 & wlcsn ==	.	//	105 (16500)                                                        
*replace wlcfna = 	0	 if id == 	27379	 & wlcfna ==	.		                                                                      
replace wlcnpn = 	104	 if id == 	27419	 & wlcnpn ==	.	//	162 ITEM # 104                                                     
replace wlcsn = 	105	 if id == 	27419	 & wlcsn ==	.	//	72 ITEM 105                                                        
*replace wlcfna = 	0	 if id == 	29315	 & wlcfna ==	.		                                                                      
replace wlcsn = 	116	 if id == 	30858	 & wlcsn ==	.	//	1.16
replace wlcnpn = 	306	 if id == 	31308	 & wlcnpn ==	.	//	320 ITEM NO 306 THE WORDING IS CONFUSING  $ AMT AN ITEM DESCRIPTION
replace wlcsn = 	306	 if id == 	31308	 & wlcsn ==	.	//	320 ITEM NO 306 THE WORDING IS CONFUSING  $ AMT AN ITEM DESCRIPTION
*replace wlcfna = 	0	 if id == 	33950	 & wlcfna ==	.		                                                                      
*replace wlcsn = 	304	 if id == 	33950	 & wlcsn ==	.	//	304 OR 306                                                         
*replace wlcfna = 	0	 if id == 	34015	 & wlcfna ==	.		                                                                      
replace wlcsn = 	143	 if id == 	35721	 & wlcsn ==	.	//	143/132                                                            
*replace wlcfna = 	0	 if id == 	37456	 & wlcfna ==	.		                                                                      
replace wlcnpn = 	132	 if id == 	40210	 & wlcnpn ==	.	//	132/110                                                            
replace wlcsn = 	133	 if id == 	40210	 & wlcsn ==	.	//	133/116                                                            
replace wlcnpn = 	110	 if id == 	41340	 & wlcnpn ==	.	//	160 110                                                            
replace wlcsn = 	116	 if id == 	41340	 & wlcsn ==	.	//	116 116                                                            
replace wlcnpn = 	17610	 if id == 	42205	 & wlcnpn ==	.	//	176.1
*replace wlcfna = 	0	 if id == 	42587	 & wlcfna ==	.		                                                                      
replace wlcsn = 	116	 if id == 	45365	 & wlcsn ==	.	//	116 & 112                                                          
replace wlcnpn = 	132	 if id == 	45365	 & wlcnpn ==	.	//	132 & 112 TELEHEALTH                                               
replace wlcsn = 	304	 if id == 	84520	 & wlcsn ==	.	//	304/306                                                            


***updated edits to account for the multiple item responses
replace wlcnpf = (61 + 117.55)/2 if id == 	30477 // 57 OR 170
replace wlcsf = (86.45 + 133.1)/2 if id == 	1431 //	302/304
replace wlcnpf = (362.1 + 268.6)/2 if id == 	24615	//	13870/73  
replace wlcnpf = 85.55 if id == 	27096	 //	104 (OR 16401), both 85.55
replace wlcsf = (43 + 47)/2 if id == 	27096	 //	105 (16500)
replace wlcnpf = (162 + 85.55)/2 if id == 	27419	 //	162 ITEM # 104
replace wlcsf = 34.2 if id == 	29315	 //	AC501
replace wlcnpf = (43.5 + 183.65)/2 if id == 	31308 //	320 ITEM NO 306 THE WORDING IS CONFUSING  $ AMT AN ITEM DESCRIPTION
replace wlcsf = (43.5 + 183.65)/2 if id == 	31308 //	320 ITEM NO 306 THE WORDING IS CONFUSING  $ AMT AN ITEM DESCRIPTION
replace wlcsf = (133.1 + 183.65)/2 if id == 	33950	 //	304 OR 306
replace wlcsf = (282.95 + 263.9)/2 if id == 	35721	 //	143/132 
replace wlcnpf = (85.55 + 39.55)/2 if id == 	37456	 //	17615 17690 
replace wlcnpf = (263.9 + 150.9)/2 if id == 	40210	 //	132/110 
replace wlcsf = (132.1 + 75.5)/2 if id==40210	 //	133/116
replace wlcsf = 75.5 if id == 41340	 //	100 116, no item number 100
replace wlcnpf = 263.9 if id == 	41340	// 280 132, likely item 132, no item 280 but fee of 132 is close
replace wlcnpf = (160+150.9)/2 if id == 	41340	//	160 110
replace wlcsf = 75.5 if id == 	41340	//	116 116    
replace wlcnpf = 43 if id == 	42205	 //	176.1, item likely 17610
replace wlcsf = 75.5 if id == 	45365	 //	116 & 112, no fee specified for item 112
replace wlcnpf = 263.9 if id == 	45365	 //	132 & 112 TELEHEALTH, no fee specified for item 112
replace wlcsf = (133.1 + 183.65)/2 if id == 	84520	 //	304/306
replace wlcnpf = 150.9 if id == 	1000172	//	110/2
replace wlcsf =  75.5 if id == 	1000172	//	116/2

                                                  
*check for outliers
list id dirall response wlcnpf wlcnpf_comment wlcnpn wlcnpn_comment if wlcnpf>700&wlcnpf!=. // few cases identified but not sure how to edit

list id sdtype dtimage wlcnpf wlcnpn wlcnpn_comment if wlcnpf<10&wlcnpf>0
*all good


list id sdtype dtimage wlcsf wlcsn wlcsn_comment if wlcsf>700&wlcsf!=.
replace wlcsf=. if id==41575 //item number instead of fee
replace wlcsf=. if id==41591 //item number instead of fee

list id sdtype response wlcnpf wlcnpn wlcnpn_comment wlcsf wlcsn wlcsn_comment wlcfna wlcfna_comment if wlcfna==0 & wlcfna_comment!="" 

foreach x of var wlcnpf wlcnpn wlcsf wlcsn{
replace `x'=-2 if wlcfna_comment=="-2" & response=="Online"
}
* 

*check the invalid medicare numbers 
list id sdtype dtimage wlcnpf wlcnpn wlcnpn_comment wlcsf wlcsn wlcsn_comment wlcfna wlcfna_comment if wlcnpn!=. & wlcnpf==.

	replace wlcnpn = -4 if id == 35375

list id sdtype dtimage wlcnpf wlcnpn wlcnpn_comment wlcsf wlcsn wlcsn_comment wlcfna wlcfna_comment if wlcsn!=. & wlcsf==.
*all good

list id sdtype dtimage wlcnpf wlcnpf_comment wlcnpn wlcnpn_comment wlcsf wlcsf_comment wlbbp if wlcnpf_comment!="" & wlcnpf==.
*all good

list id sdtype dtimage wlcnpf wlcnpf_comment wlcnpn wlcnpn_comment wlcsf wlcsf_comment wlbbp if wlcsf_comment!="" & wlcsf==.
*none to deal with

list id sdtype dtimage wlcnpf wlcnpf_comment  wlcsf wlcsf_comment wlbbp if wlcsf_comment!="" & wlcsf==.
*none to deal with

*fibv - What is the approximate annual total value in dollars of these benefits?
list id sdtype dtimage fibv_comment fibv fib if (fibv==.|fibv==-4)& fibv_comment!=""
replace fibv=-4 if strmatch(fibv_comment,"*KNOW*")|strmatch(fibv_comment,"*SURE*")|strmatch(fibv_comment,"*DK*")|strmatch(fibv_comment,"*CERTAIN*")
replace fibv=-4 if strmatch(fibv_comment,"*NO IDEA*")|strmatch(fibv_comment,"*UNCLEAR*")
replace fibv=-2 if fibv_comment=="PASS"

list id dtimage fibv_comment fibv fib if (fibv==.)& fibv_comment!=""
replace fib="-2" if id==4972 //privacy
replace fibv=-2 if id==4972 //privacy
*replace fibv=-1 if id==1001689
replace fibv=13000 if id==48848
replace fibv=17000 if id==35893
replace fibv=11700 if id==10167
replace fibv=17000 if id==1003517
replace fibv=16000 if id==72785
replace fibv=18000 if id==55505
replace fibv=18500 if id==58082
replace fibv=17000 if id==32768
replace fibv=9000 if id==65849
replace fibv=20000 if id==1664
replace fibv=9100 if id==47964
replace fibv=17000 if id==66946
replace fibv=6000 if id==1004872
replace fibv=19000 if id==72455
replace fibv=10000 if id==57517
replace fibv=10000 if id==55182
replace fibv=9000 if id==36065
replace fibv=10400 if id==58895


*fidme/fimedk

list id sdtype dtimage fidme_comment fidme fimedk if fidme==.& fidme_comment!=""
replace fidme=-2 if id==4972 //privacy

list id sdtype dtimage fidme_comment fidme fimedk if  fidme_comment!="" &fidme==.
*all good


replace fidme=-4 if fidme_comment!=""& fidme==.

*large values for fidme
list id sdtype dtimage fidme fidme_comment fimedk fimedk_comment if fidme>900000 & fidme!=.

replace fidme=-4 if id == 84028



*fidp
list id sdtype dtimage fidp_comment fidp fidpdk fidpna if (fidp==.& fidp_comment!="")|strmatch(fidp_comment, "*NA*")|strmatch(fidp_comment, "*NOT APPLICABLE*")|strmatch(fidp_comment, "*N/A*")
replace fidp=-2 if id==4972 //privacy
replace fidp=65000 if id==58781
replace fidp=250000 if id==34995
replace fidp=150000 if id==1027
replace fidp=500000 if id==58914
replace fidp=185000 if id==4830


list id sdtype dtimage fidp_comment fidp fidpdk fidpna if fidp_comment!="" & fidp==.
*all good

replace fidpna=1 if strmatch(fidp_comment, "*NA*")|strmatch(fidp_comment, "*NOT APPLICABLE*")|strmatch(fidp_comment, "*N/A*")
replace fidpdk=1 if strmatch(fidp_comment, "*DK*")

/*WY: home loan doesn't count*/

*fiip
list id sdtype dtimage fiip_comment fiip id sdtype if fiip_comment!=""& fiip==.
replace fiip=-2 if id==4972 //privacy
replace fiip=4032 if id==21356
replace fiip=8215 if id==41942
replace fiip=5000 if id==4714
replace fiip=7300 if id==32768
replace fiip=6000 if id==12101
replace fiip=2000 if id==54415
replace fiip=4800 if id==56909
replace fiip=7000 if id==58781
replace fiip=5000 if id==17069
replace fiip=1500 if id==1001546
replace fiip=2000 if id==66665
replace fiip=5400 if id==11420
replace fiip=1000 if id==1001454
replace fiip=650 if id==57050
replace fiip=3600 if id==1002753
replace fiip=1536.9 if id==1001189
replace fiip=9000 if id==34348
replace fiip=9000 if id==36065
replace fiip=3984.5 if id==12388
replace fiip=4200 if id==15002
replace fiip=5000 if id==24135
replace fiip=3000 if id==71954
replace fiip=3600 if id==68224
replace fiip=300 if id==96799

replace fiip=-4 if strmatch(fiip_comment, "*UNSURE*")|strmatch(fiip_comment, "*KNOW*")|strmatch(fiip_comment, "*DK*")|strmatch(fiip_comment, "*NOT SURE*")|strmatch(fiip_comment, "*N/K*")
replace fiip  = real(regexs(1)) if regexm(fiip_comment, "^([0-9]+)")&fiip==.
replace fiip_comment = subinstr(fiip_comment, "/", "", .)
replace fiip=-4 if strmatch(fiip_comment,"*>*")|strmatch(fiip_comment,"*<*")

list id dtimage fiip fiip_comment figey finey if fiip >1000000& fiip!=.

replace fiip=-4 if id==67937 //it was 4200250 which was considered implausible.

*fisadd - personal income from non-medical sources

list fisadd_comment fisadd id if fisadd_comment!=""& fisadd!=. in 5001/8995
replace fisadd=10000 if id==681925 //10K
replace fisadd= 53000 if id==84520 //53K RENTAL
replace fisadd=-4 if id==65038 //< 5 000 
replace fisadd=10000 if id==68192 //10K (NEGATIVELY GEARED PROPERTY)
replace fisadd=200000 if id==1651 // 200.000
replace fisadd=30000 if id==72689 //30.000
replace fisadd=10000 if id==23766 //10000 100,000 , 10000 was in the box

list fisadd_comment fisadd id if fisadd_comment!=""& fisadd==. 

replace fisadd_comment = subinstr(fisadd_comment, "/", "", .)
replace fisadd  = real(regexs(1)) if regexm(fisadd_comment, "^([0-9]+)")&fisadd==.
*none to deal with

list dtimage fisadd_comment fisadd id sdtype if fisadd_comment!=""& fisadd==.
replace fisadd=-4 if (strmatch(fisadd_comment,"*KNOW*")|strmatch(fisadd_comment,"*SURE*")|strmatch(fisadd_comment,"*IDEA*")|strmatch(fisadd_comment,"*DK*"))& fisadd==.

*replace fisadd=-2 if id==4972 //privacy
replace fisadd=70000 if id==69592
replace fisadd=40000 if id==55505
replace fisadd=100000 if id==27104
replace fisadd=5000 if id==75226
replace fisadd=300000 if id==56640
replace fisadd=100000 if id==32497

replace fisadd=-4 if fisadd_comment!="" & fisadd==.

*recode negative income
gen fisadd_neg=fisadd if fisadd<-6 & fisadd!=.
replace fisadd=-5 if fisadd<-6 & fisadd!=.
*non generated

*check outliers
sort dtimage
list dtimage id fisadd fisadd_comment if (fisadd>800000 &fisadd!=.)|(fisadd<10&fisadd>0)

replace fisadd=52534 if id==4034
replace fisadd=3500 if id==36368 //3-4000
replace fisadd=10000 if id==23766


foreach x of var wlcf wlcnpf wlcsf fiip fisadd{
tab `x'
tab `x'_comment if `x'==.
}
*

********************************************************

*Staff structure of the practice

gen num_flag4=""

foreach x of var pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo{
*replace `x'=-1 if sdtype==2 & (pwpip!=1 & pwpip!=.)  ///tammy added this 1/7/2014
replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="--")
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|strmatch(`x'_comment,"*N/A*")|`x'_comment=="NONE")
replace `x'=-4 if `x'==.&(strmatch(`x'_comment,"*DON'T KNOW*")|(strmatch(`x'_comment,"*N/K*")))

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")&`x'==.
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.

gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
drop `x'_1 `x'_2

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.


replace `x'=1 if `x'==.&`x'_comment=="ONE"
replace `x'=2 if `x'==.&`x'_comment=="TWO"
replace `x'=3 if `x'==.&`x'_comment=="THREE"
replace `x'=4 if `x'==.&`x'_comment=="FOUR"
replace `x'=0.5 if `x'==.&`x'_comment=="1/2"
replace `x'=1.5 if `x'==.&`x'_comment=="1 1/2"

replace `x'=-4 if `x'==.&`x'_comment=="NOT SURE"
replace `x'=0 if `x'==.&`x'_comment=="NIL"

*list id dtimage `x'_comment if `x'==.&`x'_comment!=""
list id `x'_comment `x' if `x'_comment!="" & `x'!=.
replace num_flag4 = "num_flag4" if `x'_comment!=""
}
*
tab num_flag4

preserve
sort id
keep if num_flag4 == "num_flag4"
keep id sdtype response dir4 pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo pwnwmf_comment pwnwff_comment pwnwmp_comment pwnwfp_comment pwnwn_comment pwnwap_comment pwnwad_comment pwnwo_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num4.xls", firstrow(variables) nolabel replace
restore

***
*num_flag4 edits
***
replace pwnwn = 	0	 if pwnwn ==	-4	 & id == 	1782	//	0 DON'T KNOW                                                                                     
replace pwnwap = 	0	 if pwnwap ==	-4	 & id == 	1782	//	0 DON'T KNOW                                                                                 
replace pwnwmp = 	1	 if pwnwmp ==	.	 & id == 	2045	//	0.1
replace pwnwfp = 	1	 if pwnwfp ==	.	 & id == 	4886	//	1 (4 DAYS X 11 HRS)                          
replace pwnwad = 	0.25	 if pwnwad ==	.	 & id == 	6386	//	//1/4
replace pwnwn = 	6	 if pwnwn ==	.	 & id == 	6386	//	6 4-5 PLIGHT NURSES, ONE COMMUNITY NURSE                                                         
replace pwnwad = 	5	 if pwnwad ==	.	 & id == 	10586	//	5 -> 1 OF WHOM IS A NURSE BUT NOT WORKING AS SUCH                
replace pwnwn = 	0	 if pwnwn ==	.	 & id == 	11905	//	O                                                                                                
replace pwnwo = 	0	 if pwnwo ==	.	 & id == 	13155	//	O                                                          
replace pwnwmf = 	3	 if pwnwmf ==	.	 & id == 	13711	//	WHAT'S FULL TIME 3                                                    
replace pwnwap = 	0	 if pwnwap ==	-3	 & id == 	13780	//	NONE                                                                                         
replace pwnwmp = 	0	 if pwnwmp ==	.	 & id == 	15841	//	NO                                           
replace pwnwn = 	3	 if pwnwn ==	.	 & id == 	17323	//	3 1 X FTE                                                                                        
replace pwnwad = 	4	 if pwnwad ==	.	 & id == 	17323	//	4 (2 X FTE)                                                      
replace pwnwap = 	6	 if pwnwap ==	.	 & id == 	17723	//	6 - RENT ROOMS/SELF EMPLOYED                                                                 
replace pwnwap = 	0	 if pwnwap ==	.	 & id == 	19259	//	                                                                                             
replace pwnwad = 	0	 if pwnwad ==	.	 & id == 	19259	//	                                                                 
replace pwnwo = 	0	 if pwnwo ==	.	 & id == 	19259	//	                                                           
replace pwnwfp = 	1	 if pwnwfp ==	.	 & id == 	19842	//	1 2                                          
replace pwnwmf = 	2	 if pwnwmf ==	.	 & id == 	19842	//	2 1                                                                   
replace pwnwap = 	15	 if pwnwap ==	.	 & id == 	21198	//	A LOT  15                                                                                    
replace pwnwad = 	20	 if pwnwad ==	.	 & id == 	24135	//	>20                                                              
replace pwnwo = 	180	 if pwnwo ==	.	 & id == 	24135	//	PLUS/- 180                                                 
replace pwnwad = 	105	 if pwnwad ==	3	 & id == 	26307	//	                                                                 
replace pwnwad = 	0.1	 if pwnwad ==	.	 & id == 	26735	//	0.1FTE                                                           
replace pwnwmf = 	0	 if pwnwmf ==	.	 & id == 	28705	//	NO OTHERS FORMALLY ASSOCIATED WITH                                    
replace pwnwff = 	0	 if pwnwff ==	.	 & id == 	28705	//	                                                 
replace pwnwmp = 	0	 if pwnwmp ==	.	 & id == 	28705	//	                                             
replace pwnwfp = 	0	 if pwnwfp ==	.	 & id == 	28705	//	                                             
replace pwnwmf = 	1	 if pwnwmf ==	.	 & id == 	31557	//	-1
replace pwnwad = 	1	 if pwnwad ==	.	 & id == 	31557	//	-1
replace pwnwad = 	120	 if pwnwad ==	.	 & id == 	32399	//	>120                                                             
replace pwnwo = 	1000	 if pwnwo ==	.	 & id == 	32399	//	>1000                                                      
replace pwnwfp = 	6	 if pwnwfp ==	.	 & id == 	34067	//	6 (6)                                        
replace pwnwmp = 	7	 if pwnwmp ==	1	 & id == 	34823	//	                                             
replace pwnwmf = 	1	 if pwnwmf ==	0	 & id == 	34980	//	-                                                                     
replace pwnwff = 	0	 if pwnwff ==	.	 & id == 	35445	//	O                                                
replace pwnwmp = 	0	 if pwnwmp ==	.	 & id == 	35565	//	                                             
replace pwnwfp = 	0	 if pwnwfp ==	.	 & id == 	35565	//	                                             
replace pwnwad = 	0.5	 if pwnwad ==	.	 & id == 	37478	//	0.5
replace pwnwo = 	3	 if pwnwo ==	.	 & id == 	41652	//	-3
replace pwnwo = 	0	 if pwnwo ==	.	 & id == 	43000	//	0
replace pwnwad = 	1	 if pwnwad ==	.	 & id == 	43000	//	0.5
replace pwnwo = 	7	 if pwnwo ==	.	 & id == 	49359	//	//4/9
replace pwnwff = 	1	 if pwnwff ==	.	 & id == 	53782	//	ONLY ME                                          
replace pwnwo = 	50	 if pwnwo ==	.	 & id == 	53911	//	50+             , CANNOT DETERMINE                                           
replace pwnwmf = 	1	 if pwnwmf ==	.	 & id == 	55464	//	1 20 PLUS. I WORK AT ONE OF THE SITES BUT, THERE ARE MANY PRACTICES.  
replace pwnwmf = 	4	 if pwnwmf ==	.	 & id == 	57257	//	                                                                      
replace pwnwap = 	0	 if pwnwap ==	.	 & id == 	57969	//	. 30                                                                                         
replace pwnwmp = 	4	 if pwnwmp ==	.	 & id == 	61794	//	-4
replace pwnwap = 	10	 if pwnwap ==	.	 & id == 	64609	//	UNCERTAIN -  10                                                                              
replace pwnwn = 	1	 if pwnwn ==	.	 & id == 	71726	//	1 1 PART TIME NURSE                                                                              
replace pwnwo = 	6	 if pwnwo ==	.	 & id == 	72989	//	6 - GPS                                                    
replace pwnwff = 	5	 if pwnwff ==	.	 & id == 	78287	//	4 5                                              
replace pwnwn = 	1	 if pwnwn ==	.	 & id == 	91751	//	EFT 1                                                                                            
replace pwnwo = 	1	 if pwnwo ==	.	 & id == 	91751	//	EFT 0.5                                                    
replace pwnwap = 	2	 if pwnwap ==	.	 & id == 	91751	//	EFT 2                                                                                        
replace pwnwad = 	2	 if pwnwad ==	.	 & id == 	91751	//	EFT 2                                                            
replace pwnwo = 	2	 if pwnwo ==	.	 & id == 	1001133	//	2 ***                                                      
replace pwnwmp = 	3	 if pwnwmp ==	30	 & id == 	1001594	//	                                             
replace pwnwn = 	2	 if pwnwn ==	.	 & id == 	1001621	//	-2
replace pwnwap = 	3	 if pwnwap ==	.	 & id == 	1001621	//	-3
replace pwnwff = 	1	 if pwnwff ==	.	 & id == 	1001874	//	ONLY MYSELF                                      
replace pwnwn = 	3	 if pwnwn ==	1	 & id == 	1002419	//	1 FULL TIME 2 PART TIME                                                                          
replace pwnwmf = 	1	 if pwnwmf ==	2	 & id == 	1002620	//	                                                                      
replace pwnwff = 	2	 if pwnwff ==	3	 & id == 	1002620	//	                                                 
replace pwnwmp = 	1	 if pwnwmp ==	.	 & id == 	1002620	//	X                                            
replace pwnwfp = 	1	 if pwnwfp ==	.	 & id == 	1002620	//	                                             
replace pwnwff = 	3	 if pwnwff ==	.	 & id == 	1002643	//	03 4                                             
replace pwnwmf = 	4	 if pwnwmf ==	.	 & id == 	1002643	//	4 5                                                                   

foreach x of var pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo{
replace `x' = -1 if num_flag4 == "num_flag4" & `x'==.
}
*

*pwnwmf
list id pwnwmf_comment pwnwmf if pwnwmf_comment!="" & pwnwmf!=.
list id pwnwmf_comment pwnwmf if pwnwmf_comment!="" & pwnwmf==.
*pwnwff
list id pwnwff_comment pwnwff if pwnwff_comment!="" & pwnwff!=.
list id pwnwff_comment pwnwff if pwnwff_comment!="" & pwnwff==.
*pwnwmp
*all good
list id pwnwmp_comment pwnwmp if pwnwmp_comment!="" & pwnwmp==.

replace pwnwmp=round(pwnwmp,1)
*pwnwf
list id pwnwfp_comment pwnwfp if pwnwfp_comment!="" & pwnwfp!=.
*all good
list id pwnwfp_comment pwnwfp if pwnwfp_comment!="" & pwnwfp==.

replace pwnwfp=round(pwnwfp,1)

*pwnwn
list id pwnwn_comment pwnwn if pwnwn_comment!="" & pwnwn!=.
*doctors respond in different ways - some in terms of head count and some in terms of fte.
*data is of poor quality.

list pwnwn_comment pwnwn pwpip id if pwnwn_comment!="" & pwnwn==.

*pwnwap
list id pwnwap_comment pwnwap if pwnwap_comment!="" & pwnwap!=.
*all good
list pwnwap_comment pwnwap id if pwnwap_comment!="" & pwnwap==.

*pwnwad
list id pwnwad_comment pwnwad if pwnwad_comment!="" & pwnwad!=.
list pwnwad_comment pwnwad id if pwnwad_comment!="" & pwnwad==.

*pwnwo
list pwnwo_comment pwnwo  id if pwnwo_comment!="" & pwnwo!=.
*all good
list pwnwo_comment pwnwo id if pwnwo_comment!="" & pwnwo==.

foreach x of var pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo {
tab `x'
tab `x'_comment if `x'==.
}
*


*****************************************

*Number of patients
gen num_flag5=""

foreach x of var wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau {

replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="---"|`x'_comment=="-0"|strmatch(`x'_comment,"*NIL*"))
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|strmatch(`x'_comment,"*N/A*")|strmatch(`x'_comment,"*RADIOLOG*")|strmatch(`x'_comment,"*PATHOLOG*")|strmatch(`x'_comment,"*APPLICABLE*"))

replace `x'=-4 if `x'==.&(`x'_comment=="DK"|strmatch(`x'_comment,"*DON'T KNOW*")|strmatch(`x'_comment,"*I DO NOT KNOW*")|strmatch(`x'_comment,"*>*"))


replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
drop `x'_1 `x'_2

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.

replace `x'=1 if `x'==.& strmatch(`x'_comment,"*ZERO*")
replace `x'=1 if `x'==.&`x'_comment=="ONE"
replace `x'=2 if `x'==.&`x'_comment=="TWO"
replace `x'=3 if `x'==.&`x'_comment=="THREE"
replace `x'=4 if `x'==.&`x'_comment=="FOUR"

replace num_flag5="num_flag5" if `x'_comment!=""
*list dtimage `x'_comment `x' id if `x'==.&`x'_comment!=""
}
*
tab num_flag5
preserve
sort id
keep if num_flag5 == "num_flag5"
keep id sdtype response dir4 dir5 dir6 dir7 wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau wlnppc_comment wlnpph_comment wlnprh_comment wlnprr_comment wlnph_comment wlnp_comment wlva_comment wlvau_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num5.xls", firstrow(variables) nolabel replace
restore

***
*num_flag5 edits
***
replace wlnppc = 	7.5	 if id == 	3224	 & wlnppc ==	.	//	7.5
replace wlnph = 	3.5	 if id == 	3224	 & wlnph ==	.	//	3.5
replace wlnppc = 	100	 if id == 	4714	 & wlnppc ==	.	//	PLUS MINUS 100            , CONSIDERED APPROX.                                      
replace wlnppc = 	120	 if id == 	5432	 & wlnppc ==	.	//	PLUS MINUS 120            , CONSIDERED APPROX.                                      
replace wlnppc = 	380	 if id == 	12198	 & wlnppc ==	.	//	38
replace wlnph = 	40	 if id == 	12490	 & wlnph ==	-4	//	40 -> OTHER CONSULTING ROOM   
replace wlnppc = 	20	 if id == 	14778	 & wlnppc ==	.	//	20/WEEK VARIES AT WORK                                          
replace wlnph = 	0	 if id == 	14778	 & wlnph ==	.	//	                              
replace wlnppc = 	0	 if id == 	15807	 & wlnppc ==	-3	//	0 N/A                                                           
replace wlnph = 	2	 if id == 	21585	 & wlnph ==	.	//	-2
replace wlnppc = 	30	 if id == 	24135	 & wlnppc ==	.	//	PLUS/- 30                , CONSIDERED APPROX.                                       
replace wlnppc = 	80	 if id == 	25449	 & wlnppc ==	-3	//	80 OR 0 PATHOLOGY REPORTING PATH LAB                            
replace wlnppc = 	80	 if id == 	25561	 & wlnppc ==	.	//	80
replace wlnpph = 	20	 if id == 	25561	 & wlnpph ==	.	//	20
replace wlnppc = 	85	 if id == 	26456	 & wlnppc ==	.	//	85 - INCLUDES PHONE CALLS = 20                                  
replace wlnppc = 	0	 if id == 	26653	 & wlnppc ==	.	//	0  5-8 PATIENT IN NURSING HOMES                                 
replace wlnppc = 	-4	 if id == 	29260	 & wlnppc ==	.	//	NO IDEA TOO MANY                                                
replace wlnppc = 	-3	 if id == 	29400	 & wlnppc ==	.	//	NA -IMAGING                                                     
replace wlnpph = 	-4	 if id == 	29701	 & wlnpph ==	25	//	25 NO IDEA, total, cannot determine individual values                                                                                        
replace wlnprh = 	-4	 if id == 	29701	 & wlnprh ==	25	//	25 NO IDEA, total, cannot determine individual values                                                                                        
replace wlnpph = 	10	 if id == 	41454	 & wlnpph ==	.	//	10 (***)                                                                                                                              
replace wlnpph = 	100	 if id == 	41987	 & wlnpph ==	.	//	100 } = 150                                                                                                                           
replace wlnprh = 	50	 if id == 	41987	 & wlnprh ==	.	//	50 } = 150                                                                    
replace wlnpph = 	100	 if id == 	42329	 & wlnpph ==	-4	//	>100                                                                                                                                  
replace wlnp = 	25	 if id == 	47516	 & wlnp ==	.	//	20 - 30                                  
replace wlnp = 	-4	 if id == 	48541	 & wlnp ==	.	//	DONT KN0W                                
replace wlnpph = 	1	 if id == 	54102	 & wlnpph ==	.	//	1
replace wlnprr = 	20	 if id == 	54102	 & wlnprr ==	.	//	20
replace wlnp = 	35	 if id == 	54188	 & wlnp ==	30	//	30 TO 40                                 
replace wlnppc = 	75	 if id == 	57228	 & wlnppc ==	.	//	75
replace wlnppc = 	120	 if id == 	57360	 & wlnppc ==	.	//	120, CASES.                                                     
replace wlnpph = 	7	 if id == 	66747	 & wlnpph ==	.	//	07 (7)                                                                                                                                
replace wlnprh = 	0	 if id == 	68763	 & wlnprh ==	.	//	                                                                              
replace wlnprr = 	0	 if id == 	68763	 & wlnprr ==	.	//	                                                                                     
replace wlnppc = 	40	 if id == 	71954	 & wlnppc ==	.	//	40/WK                                                           
replace wlnpph = 	80	 if id == 	73292	 & wlnpph ==	.	//	80  DIFFICULT TO SAY I WORK IN AN EMERGENCY DEPARTMENT THAT SEES 250PT PER DAY.  I SEE MY OWN AND ALSO REVIEW THE JUNIOR MEDICAL STAFF
replace wlnppc = 	80	 if id == 	74464	 & wlnppc ==	.	//	80                                                             
replace wlnp = 	50	 if id == 	75226	 & wlnp ==	.	//	AROUND 50                                
replace wlnp = 	23.5	 if id == 	78178	 & wlnp ==	.	//	23.5
replace wlnppc = 	125	 if id == 	83699	 & wlnppc ==	.	//	25/DAY                                                          
replace wlnppc = 	250	 if id == 	84252	 & wlnppc ==	.	//	250 1 WEEK                                                      
replace wlnppc = 	130	 if id == 	84423	 & wlnppc ==	.	//	26/DAY                                                          
replace wlnppc = 	100	 if id == 	1001175	 & wlnppc ==	.	//	25-X4                                                           
replace wlnppc = 	100	 if id == 	1001454	 & wlnppc ==	.	//	AROUND 20 PATIENTS DAILY                                        
replace wlnppc = 	150	 if id == 	1001496	 & wlnppc ==	.	//	30/DAY AVERAGE                                                  
replace wlnph = 	5	 if id == 	1001496	 & wlnph ==	.	//	1/DAY AVERAGE                 
replace wlnppc = 	-4	 if id == 	1001718	 & wlnppc ==	.	//	180+               , CANNOT DETERMINE                                             
replace wlnph = 	0	 if id == 	1002008	 & wlnph ==	.	//	O                             
replace wlnppc = 	-4	 if id == 	1002127	 & wlnppc ==	.	//	60+                , CANNOT DETERMINE                                             
replace wlnph = 	18	 if id == 	1002502	 & wlnph ==	.	//	15  - 20 PATIENTS/ OPERATIONS 
replace wlnprh = 	16	 if id == 	1003581	 & wlnprh ==	.	//	16 'PRIVATE' IN THE SENSE OF MEDICARE FEE FOR SERVICE                         
replace wlnp = 	30	 if id == 	1004769	 & wlnp ==	.	//	30  >30                                  
*num_flag 5.1
replace wlva = 	1.5	 if id == 	674	 & wlva ==	.	//	1.5
replace wlva = 	0	 if id == 	3555	 & wlva ==	1	//	ZERO                                                                           
replace wlvau = 	0	 if id == 	3555	 & wlvau ==	1	//	ZERO
replace wlva = 	-1	 if id == 	4972	 & wlva ==	-3	//	N/A                                                                            
replace wlvana =	1	 if id == 	4972			//	N/A                                                                            
replace wlva = 	0	 if id == 	4979	 & wlva ==	.	//	NONE                                                                           
replace wlva = 	0	 if id == 	5432	 & wlva ==	0	//	                                                                               
replace wlva = 	-1	 if id == 	5828	 & wlva ==	0	//	-                                                                              
replace wlvau = 	-1	 if id == 	5828	 & wlvau ==	0	//	-   
replace wlvana =	1	 if id == 	8043			//	N/A 
replace wlvana =	1	 if id == 	9752			//	N/A 
replace wlva = 	0.5	 if id == 	11004	 & wlva ==	.	//	0.5
replace wlvau = 	0.5	 if id == 	11004	 & wlvau ==	.	//	0.5
replace wlva = 	-1	 if id == 	15873	 & wlva ==	-3	//	N/A                                                                            
replace wlvau = 	-1	 if id == 	15873	 & wlvau ==	.	//	    
replace wlvana =	1	 if id == 	15873			//	N/A                                                                            
replace wlvana =	0	 if id == 	19518			//	
replace wlvadk =	0	 if id == 	19518			//	
replace wlva = 	-1	 if id == 	20958	 & wlva ==	-3	//	N/A                                                                            
replace wlvau = 	-1	 if id == 	20958	 & wlvau ==	.	//	    
replace wlvana =	1	 if id == 	20958			//	
replace wlvana =	1	 if id == 	21812			//	N/A 
replace wlva = 	-1	 if id == 	23979	 & wlva ==	0	//	                                                                               
replace wlvau = 	0.5	 if id == 	56951	 & wlvau ==	.	//	//1/2
replace wlva = 	-1	 if id == 	57956	 & wlva ==	.	//	NOT KNOWN                                                                      
replace wlvau = 	-1	 if id == 	57956	 & wlvau ==	.	//	    
replace wlvadk =	1	 if id == 	57956			//	NOT KNOWN                                                                      
replace wlvana =	1	 if id == 	64372			//	N/A 
replace wlvana =	1	 if id == 	83126				
replace wlva = 	0.5	 if id == 	85442	 & wlva ==	.	//	0.5
replace wlvana =	1	 if id == 	1001175				
replace wlva = 	0	 if id == 	1002449	 & wlva ==	0	//	                                                                               
replace wlvau = 	0	 if id == 	1002449	 & wlvau ==	0	//	    
replace wlvana =	1	 if id == 	1002449				
replace wlvana =	1	 if id == 	1002542				
replace wlvau = 	0.5	 if id == 	1003325	 & wlvau ==	.	//	0.5
replace wlva =	0	if id ==	1001914	& wlva ==	.	//	O
replace wlva =	0.5	if id ==	84249	& wlva ==	.	//	0.5
replace wlva =	6.5	if id ==	4568	& wlva ==	.	//	6.5
replace wlvau =	0.5	if id ==	4568	& wlvau ==	.	//	0.5
			
foreach x of var wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau {
list dtimage `x'_comment `x' id if `x'!=.&`x'_comment!=""
}
*
foreach x of var wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau {
list dtimage `x'_comment `x' id if `x'==.&`x'_comment!=""
}
*

foreach x of var wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau {
tab `x'
tab `x'_comment if `x'==.
}
*

*list id dirall response wlva wlva_comment if wlva==. & wlva_comment !=""
*list id dirall response wlvau wlvau_comment if wlvau==. & wlvau_comment !=""



****************************************

*Minutes/Hours

foreach x of var wlcmin wlcnpmin wlcsmin wlrh wlpch pwhlh {

replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="---"|`x'_comment=="-0"|`x'_comment=="NIL"| ///
strmatch(`x'_comment,"*ZERO*")|`x'_comment=="ZERO"|strmatch(`x'_comment,"*NONE*")|`x'_comment=="NL"|`x'_comment=="O")
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|`x'_comment=="N/A")
replace `x'=-4 if `x'==.& strmatch(`x'_comment,"*VARIABLE*")


replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[ ][A-Z]+$")&`x'==.
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[A-Z]+$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")&`x'==.


gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
drop `x'_1 `x'_2

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.
*replace `x'=subinstr(`x'_comment, "K", "000", .)
*replace `x'=subinstr(`x'_comment, "MILLION", "000000", .)


replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[M]$")
replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "([0-9]+)[M]$")
replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "([0-9]+.[0-9]+) MILLION$")

replace `x'=real(regexs(1))*1000 if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[K]$")
replace `x'=real(regexs(1))*1000 if regexm(`x'_comment, "([0-9]+)[K]$")
}
*
gen num_flag6 = ""
foreach x of var wlcmin wlcnpmin wlcsmin wlrh wlpch pwhlh{
replace num_flag6 = "num_flag6" if `x'_comment!=""
}
*
tab num_flag6
preserve
sort id
keep if num_flag6=="num_flag6"
keep id sdtype response dir3 dir4 dir5 dir6 wlcmin wlcnpmin wlcsmin wlrh wlpch pwhlh wlcmin_comment wlcnpmin_comment wlcsmin_comment wlrh_comment wlpch_comment pwhlh_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num6.xls", firstrow(variables) nolabel replace
restore

foreach x of var wlcmin wlcnpmin wlcsmin wlrh wlpch pwhlh {
list dtimage `x' `x'_comment id if `x'!=.&`x'_comment!=""
}
*

foreach x of var wlcmin wlcnpmin wlcsmin wlrh wlpch pwhlh {
list dtimage `x'_comment id if `x'==.&`x'_comment!=""
}
*

***
*num_flag6 edits
***
*replace wlcnpmin = 	60	 if wlcnpmin ==	.	 & id == 	4022	//	                                                         
replace wlcmin = 	15	 if wlcmin ==	.	 & id == 	18169	//	10 (20 ME)          
replace wlcmin = 	-3	 if wlcmin ==	.	 & id == 	19259	//	N/A LOCUM           
replace wlcmin = 	18	 if wlcmin ==	.	 & id == 	20687	//	15 - 20 MIN         
replace wlcmin = 	17	 if wlcmin ==	.	 & id == 	22211	//	16 1/2
replace wlcnpmin = 	75	 if wlcnpmin ==	.	 & id == 	26735	//	60 -90                                                   
replace wlcnpmin = 	-1	 if wlcnpmin ==	90	 & id == 	28104	//	PUBLIC                                                
replace wlcsmin = 	-1	 if wlcsmin ==	30	 & id == 	28104	//	PUBLIC                                                
replace wlcsmin = 	38	 if wlcsmin ==	.	 & id == 	31012	//	30 - 45                    
replace wlcnpmin = 	68	 if wlcnpmin ==	60	 & id == 	31042	//	60 TO 75                                                 
replace wlcsmin = 	38	 if wlcsmin ==	30	 & id == 	31042	//	30 TO 45                   
replace wlcnpmin = 	90	 if wlcnpmin ==	96	 & id == 	35565	//	                                                         
replace wlcnpmin = 	120	 if wlcnpmin ==	2	 & id == 	36515	//	2HOURS                                                   
replace wlcsmin = 	45	 if wlcsmin ==	30	 & id == 	36590	//	30 OR 60                   
replace wlcnpmin = 	75	 if wlcnpmin ==	.	 & id == 	36706	//	60 - 90 MINS PLUS REPORT                                 
replace wlcnpmin = 	75	 if wlcnpmin ==	60	 & id == 	36805	//	60 TO 90                                                 
replace wlcnpmin = 	75	 if wlcnpmin ==	.	 & id == 	37772	//	1.5 HRS                                                  
replace wlcnpmin = 	60	 if wlcnpmin ==	1	 & id == 	38112	//	1 HOUR                                                   
replace wlcnpmin = 	60	 if wlcnpmin ==	1	 & id == 	41203	//	1 HOUR                                                   
replace wlrh = 	60	 if wlrh ==	.	 & id == 	46287	//	60  3 DAYS IN WEEK                                 
replace wlcmin = 	45	 if wlcmin ==	.	 & id == 	49250	//	30- 60              
replace wlcsmin = 	23	 if wlcsmin ==	15	 & id == 	53285	//	15 TO 30                   
replace wlcmin = 	15	 if wlcmin ==	.	 & id == 	57858	//	FIFTEEN             
replace wlcmin = 	14	 if wlcmin ==	.	 & id == 	58758	//	12 - 15MIN          
replace wlcnpmin = 	60	 if wlcnpmin ==	1	 & id == 	59201	//	1HOUR                                                    
replace wlcsmin = 	23	 if wlcsmin ==	15	 & id == 	59249	//	15 TO 30                   
replace wlrh = 	-4	 if wlrh ==	7	 & id == 	60186	//	7 DAYS PER 3 WEEKS                                 
replace wlcsmin = 	45	 if wlcsmin ==	.	 & id == 	61594	//	60 - 30                    
replace wlcsmin = 	23	 if wlcsmin ==	15	 & id == 	63136	//	15 OR 30                   
replace wlrh = 	20	 if wlrh ==	.	 & id == 	65945	//	20 -> ON CALL FOR 7 DAYS EVERY 6 WEEKS MON-MON 24/7
replace wlcnpmin = 	60	 if wlcnpmin ==	1	 & id == 	68661	//	1 HOUR                                                   
replace wlcnpmin = 	30	 if wlcnpmin ==	.	 & id == 	84684	//	30 (45 OBSTETIN)                                         
replace wlrh = 	-4	 if wlrh ==	1	 & id == 	97111	//	1 WEEK                                             
replace wlcmin = 	18	 if wlcmin ==	15	 & id == 	1000513	//	15 TO 20 MINUTES    
replace wlcmin = 	17	 if wlcmin ==	.	 & id == 	1001138	//	9 - 25 MINUTES      
replace wlcmin = 	15	 if wlcmin ==	15000000	 & id == 	1002317	//	15M                 
replace wlcmin = 	-4	 if wlcmin ==	1	 & id == 	1002352	//	1Q5                 
replace wlcmin = 	14	 if wlcmin ==	.	 & id == 	1002753	//	12- 15 MINUTES      
replace wlpch = 	-4	 if wlpch ==	2	 & id == 	1004197	//	         
replace wlrh = 	-4	 if wlrh ==	.	 & id == 	1005110	//	//24/7
replace pwhlh = 	0	 if pwhlh ==	.         	 & id == 	41652	//	-0-                                                                                           
replace pwhlh = 	0	 if pwhlh ==	.        	 & id == 	42451	//	-0-                                                                                           
replace pwhlh = 	0	 if pwhlh ==	.       	 & id == 	46287	//	                                                                                              

*Round up numbers
replace wlrh=round(wlrh,.1)


foreach x of var wlrh wlpch pwhlh {
replace `x' =168 if `x'>168 & `x'!=.
}
*
foreach x of var wlcmin wlcnpmin wlcsmin wlrh wlpch pwhlh {
tab `x'
tab `x'_comment if `x'==.
}
*

replace wlcmin=19 if id==1002620 //18-20

**************************************************

*Percentage
*fispm fisnpm fisgi fishw fisoth are not in wave 9
foreach x of var wlbbp fispm fisnpm fisgi fishw fisoth {

replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="---"|`x'_comment=="-0"|`x'_comment=="NIL"| ///
strmatch(`x'_comment,"*ZERO*")|`x'_comment=="ZERO")
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|`x'_comment=="N/A")
replace `x'=-4 if `x'==.&(`x'_comment=="DK"|strmatch(`x'_comment,"*DON'T KNOW*")|strmatch(`x'_comment,"*I DO NOT KNOW*")|strmatch(`x'_comment,"*>*"))

replace `x'_comment=subinstr(`x'_comment, "%", "", .)
replace `x'_comment=subinstr(`x'_comment, "?", "", .)
replace `x'_comment=subinstr(`x'_comment, "$", "", .)
replace `x'_comment=subinstr(`x'_comment, "~", "", .)
replace `x'_comment=subinstr(`x'_comment, "-", " ", .)
replace `x'_comment=subinstr(`x'_comment, ",000", "000", .)
replace `x'_comment=subinstr(`x'_comment, ",", "", .)
replace `x'_comment=subinstr(`x'_comment, "]", "", .)
replace `x'_comment=subinstr(`x'_comment, "  ", " ", .)


replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[ ][A-Z]+$")&`x'==.
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)[A-Z]+$")&`x'==.
*replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")&`x'==.
replace `x'=real(`x'_comment) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)$")&`x'==.
replace `x'=real(`x'_comment) if regexm(`x'_comment, "^([.][0-9]+)$")&`x'==.

gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
drop `x'_1 `x'_2

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.
*replace `x'=subinstr(`x'_comment, "K", "000", .)
*replace `x'=subinstr(`x'_comment, "MILLION", "000000", .)


replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[M]$")&`x'==.
replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "([0-9]+)[M]$")&`x'==.
replace `x'=real(regexs(1))*1000000 if regexm(`x'_comment, "([0-9]+.[0-9]+) MILLION$")&`x'==.

replace `x'=real(regexs(1))*1000 if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[K]$")&`x'==.
replace `x'=real(regexs(1))*1000 if regexm(`x'_comment, "([0-9]+)[K]$")&`x'==.

replace `x'=real(regexs(1)) if regexm(`x'_comment, "([0-9]+)")&`x'==.

replace `x'=-4 if `x'==.&(`x'_comment=="UNSURE"|`x'_comment=="NOT SURE"|`x'_comment=="NO IDEA")

}
*
list wlbbp wlbbp_comment id response dirall if wlbbp!=.&wlbbp_comment!=""
list wlbbp wlbbp_comment id response dirall if wlbbp==.&wlbbp_comment!=""

gen num_flag7=""
replace num_flag7="num_flag7" if wlbbp==.&wlbbp_comment!=""
tab num_flag7
preserve
sort id
keep if num_flag7=="num_flag7"
keep id sdtype response dir5 dir6 wlbbp wlbpna wlbbp_comment wlbpna_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num7.xls", firstrow(variables) nolabel replace
restore

***
*num_flag7 edits
***

*replace wlbbp = 95 if wlbbp == -4 & id ==54983    //>95
*replace wlbbp = 95 if wlbbp == -4 & id ==69061    //>95
*replace wlbbp = 50 if wlbbp == -4 & id ==51262    //>50
replace wlbbp = 35 if wlbbp == 30 & id ==9776    //30-40
replace wlbbp = 20 if wlbbp == 0 & id ==7445    //0 PREFERRED 20 REALITY
*replace wlbbp = 50 if wlbbp == -4 & id ==1002412    //>50
*replace wlbbp = 95 if wlbbp == -4 & id ==1002722    //>95
replace wlbbp = 50 if wlbbp == 0 & id ==37683    //0 PRIVATE 100 PUBLIC
replace wlbbp = 70 if wlbbp == -4 & id ==55772    //0 PRIVATE 100 PUBLIC

replace wlbbp = 	-3	 if id == 	6386	 & wlbbp ==	.	//	N/A  SEE NARRATIVE                                       
replace wlbbp = 	100	 if id == 	12866	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	-4	 if id == 	13588	 & wlbbp ==	.	//	MOST                                                     
replace wlbbp = 	-4	 if id == 	19249	 & wlbbp ==	.	//	FREECARE                                                 
replace wlbbp = 	-3	 if id == 	19259	 & wlbbp ==	.	//	N/A LOCUM                                                
replace wlbbp = 	-4	 if id == 	31813	 & wlbbp ==	.	//	MOST                                                     
replace wlbbp = 	-1	 if id == 	32185	 & wlbbp ==	.	//	NOT APPLICABLE                                           
replace wlbbp = 	-4	 if id == 	32475	 & wlbbp ==	.	//	UNKNOWN                                                  
replace wlbbp = 	100	 if id == 	53678	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	-1	 if id == 	53899	 & wlbbp ==	.	//	N/A PROVIDE PSYCH ASSESSMENT & EXPERT EVIDENCE FOR COURTS
replace wlbpna = 	1	 if id == 	53899	 & wlbpna ==	0	//	        
replace wlbbp = 	100	 if id == 	57984	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	-4	 if id == 	59433	 & wlbbp ==	.	//	UNKNOWN  HOSPITAL ADMIN ORGANISES THIS                   
replace wlbbp = 	0	 if id == 	69095	 & wlbbp ==	.	//	LESS THAN ONE PERCENT                                    
replace wlbbp = 	100	 if id == 	78332	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	100	 if id == 	83695	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	100	 if id == 	90271	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	-4	 if id == 	91751	 & wlbbp ==	.	//	MOST                                                     
replace wlbbp = 	50	 if id == 	94441	 & wlbbp ==	.	//	HALF                                                     
replace wlbbp = 	100	 if id == 	97075	 & wlbbp ==	.	//	ALL PATIENTS                                             
replace wlbbp = 	100	 if id == 	99213	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	-4	 if id == 	1000513	 & wlbbp ==	.	//	MOST OF THE PATIENTS                                     
replace wlbbp = 	100	 if id == 	1000519	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	100	 if id == 	1001454	 & wlbbp ==	.	//	ALL BULKBILL                                             
replace wlbbp = 	100	 if id == 	1001496	 & wlbbp ==	.	//	ALL                                                      
replace wlbbp = 	100	 if id == 	1002085	 & wlbbp ==	.	//	ALL BULK BILL                                            
replace wlbbp = 	50	 if id == 	1002141	 & wlbbp ==	.	//	HALF                                                     
replace wlbbp = 	100	 if id == 	1003280	 & wlbbp ==	.	//	ALL PATIENTS                                             

replace wlbbp=100 if strmatch(wlbbp_comment, "ALL*")
replace wlbbp=-3 if wlbbp_comment=="N/A"|strmatch(wlbbp_comment,"NA*")|wlbbp_comment=="N A"|strmatch(wlbbp_comment,"N/A*")|strmatch(wlbbp_comment,"*NOT APPLICABLE*")
replace wlbpna=1 if sdtype==2 & (wlbbp_comment=="N/A"|wlbbp_comment=="Na"|wlbbp_comment=="NA"|wlbbp_comment=="na"|wlbbp_comment=="N A"|wlbbp_comment=="nA"|strmatch(wlbbp_comment,"N/A*")|wlbbp_comment=="Not Applicable")


tab wlbbp
list id response dtimage wlbbp if wlbbp>100 & wlbbp != .
replace wlbbp=-4 if wlbbp == 560 & id==79235 //typo, cannot determine
replace wlbbp=100 if wlbbp==1000 & id==84638 //typo, likely 100


*number of other qualifications obtained in Australia

list id pioth pioth_comment if pioth==. & pioth_comment!=""
foreach x of var pioth {
replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="---"|`x'_comment=="-0"|strmatch(`x'_comment,"*NIL*")|`x'_comment=="NONE" |`x'_comment=="NON"|`x'_comment=="X"  )
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|strmatch(`x'_comment,"*N/A*")|strmatch(`x'_comment,"*RADIOLOG*")|strmatch(`x'_comment,"*PATHOLOG*")|strmatch(`x'_comment,"*APPLICABLE*"))

replace `x'=-4 if `x'==.&(`x'_comment=="DK"|strmatch(`x'_comment,"*DON'T KNOW*")|strmatch(`x'_comment,"*I DO NOT KNOW*")|strmatch(`x'_comment,"*>*"))

replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
drop `x'_1 `x'_2

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.

replace `x'=0 if `x'==.& strmatch(`x'_comment,"*ZERO*")|strmatch(`x'_comment,"*NIL*")|`x'_comment=="O"|`x'_comment=="NO"
replace `x'=1 if `x'==.&`x'_comment=="ONE"
replace `x'=2 if `x'==.&`x'_comment=="TWO"
replace `x'=3 if `x'==.&`x'_comment=="THREE"
replace `x'=4 if `x'==.&`x'_comment=="FOUR"

list `x'_comment `x' id if `x'==.&`x'_comment!=""
}
*
list id response dirall pioth pioth_comment if pioth==. & pioth_comment!=""

gen num_flag8 = ""
replace num_flag8="num_flag8" if pioth==. & pioth_comment!=""
tab num_flag8
preserve
sort id
keep if num_flag8=="num_flag8"
keep id sdtype response dirall pioth pioth_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num8.xls", firstrow(variables) nolabel replace
restore

***
*num_flag8 edits
***
replace pioth = 	0	 if pioth ==	.	 & id == 	4360	//	IN LAST 12 MONTHS 0                                              
replace pioth = 	-5	 if pioth ==	.	 & id == 	12713	//	DONE A COUPLE OF SKIN CANCER COURSES                             
replace pioth = 	-5	 if pioth ==	.	 & id == 	18609	//	DRANZCOG ADV                                                     
replace pioth = 	0	 if pioth ==	.	 & id == 	21356	//	AM STUDYING HISTORY OF ART AT UWA PART TIME - NOT YET GOT DEGREE.
replace pioth = 	0	 if pioth ==	.	 & id == 	39789	//	NONE NEW                                                         
replace pioth = 	0	 if pioth ==	.	 & id == 	44035	//	0 12 MONTHS                                                      
replace pioth = 	0	 if pioth ==	.	 & id == 	56073	//	T0                                                               
replace pioth = 	0	 if pioth ==	.	 & id == 	59440	//	--                                                               
replace pioth = 	1	 if pioth ==	.	 & id == 	77754	//	ALS LEVEL 2                                                      
replace pioth = 	0	 if pioth ==	.	 & id == 	97404	//	PALLIATIVE CARE GP K 4YRS                                        
replace pioth = 	-4	 if pioth ==	.	 & id == 	1001061	//	_1) _2)                                                          
replace pioth = 	-4	 if pioth ==	.	 & id == 	1001369	//	DEPENDS WHAT YOU CALL A QUALIFICATION                            
replace pioth = 	1	 if pioth ==	.	 & id == 	1001532	//	ONE (GP FELLOWSHIP IN 2016)                                      
replace pioth = 	0	 if pioth ==	.	 & id == 	1002481	//	MASTER OF HEALTH ADMINISTRATION, already provided                                  
replace pioth = 	1	 if pioth ==	.	 & id == 	1002620	//	CERT - 3 IN AGED CARE                                            
replace pioth = 	1	 if pioth ==	.	 & id == 	1004160	//	1- PHYSIOTHERAPY                                                 


*These questions only appear in alternate years - won't be in wave 9
***************************************
*They are still in wave 9 for new docs.
***************************************

sort id
list dtimage fispm_comment fispm id if fispm!=.&fispm_comment!=""

list dtimage fispm_comment fispm id if fispm==.&fispm_comment!=""

list dtimage fisnpm fisnpm_comment id if fisnpm!=.&fisnpm_comment!=""

list dtimage fisnpm_comment id if fisnpm==.&fisnpm_comment!=""

list dtimage fisgi fisgi_comment id if fisgi!=.&fisgi_comment!=""

list dtimage fisgi_comment id if fisgi==.&fisgi_comment!=""

list dtimage fishw fishw_comment id if fishw!=.&fishw_comment!=""

list dtimage fishw_comment id if fishw==.&fishw_comment!=""

list dtimage fisoth fisoth_comment id if fisoth!=.&fisoth_comment!=""

list dtimage fisoth_comment id if fisoth==.&fisoth_comment!=""

gen num_flag9 = ""
foreach x of var fispm fisnpm fisgi fishw fisoth{
replace num_flag9 = "num_flag9" if `x'_comment!=""
}
*
tab num_flag9
preserve
sort id
keep if num_flag9=="num_flag9"
keep id sdtype dir7 dir8 response fispm fisnpm fisgi fishw fisoth fispm_comment fisnpm_comment fisgi_comment fishw_comment fisoth_comment fistot
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num9.xls", firstrow(variables) nolabel replace
restore

***
*num_flag9 edits
***
replace fispm = 	99.5	 if id == 	1001084	 & fispm ==	.	//	99.5
replace fisnpm = 	0	 if id == 	1001084	 & fisnpm ==	0	//	           
replace fisgi = 	0.5	 if id == 	1001084	 & fisgi ==	.	//	0.5
replace fishw = 	0	 if id == 	1001084	 & fishw ==	.	//	       
replace fisoth = 	0	 if id == 	1001084	 & fisoth ==	.	//	                                                                                      
replace fispm = 	98	 if id == 	1001189	 & fispm ==	.	//	98%
replace fisnpm = 	2	 if id == 	1001189	 & fisnpm ==	.	//	2%
replace fisgi = 	0	 if id == 	1001189	 & fisgi ==	.	//	0%
replace fishw = 	0	 if id == 	1001189	 & fishw ==	.	//	0%
replace fisoth = 	0	 if id == 	1001189	 & fisoth ==	.	//	0%
replace fispm = 	95	 if id == 	1001332	 & fispm ==	95	//	                  
replace fisnpm = 	4.5	 if id == 	1001332	 & fisnpm ==	.	//	4.5
replace fisgi = 	0.5	 if id == 	1001332	 & fisgi ==	.	//	0.5
replace fisnpm = 	0	 if id == 	1001496	 & fisnpm ==	.	//	           
replace fisgi = 	5	 if id == 	1001496	 & fisgi ==	.	//	5%
replace fisoth = 	0	 if id == 	1001496	 & fisoth ==	.	//	                                                                                      
replace fisnpm = 	7.5	 if id == 	1001508	 & fisnpm ==	.	//	7.5
replace fisgi = 	2.5	 if id == 	1001508	 & fisgi ==	.	//	2.5
replace fispm = 	90	 if id == 	1001532	 & fispm ==	.	//	90%
replace fisnpm = 	4	 if id == 	1001532	 & fisnpm ==	.	//	4%
replace fisgi = 	6	 if id == 	1001532	 & fisgi ==	.	//	6%
replace fishw = 	0	 if id == 	1001532	 & fishw ==	.	//	N/A    
replace fisoth = 	0	 if id == 	1001532	 & fisoth ==	.	//	                                                                                      
replace fispm = 	99	 if id == 	1001536	 & fispm ==	.	//	99%
replace fisnpm = 	1	 if id == 	1001536	 & fisnpm ==	.	//	1%
replace fisgi = 	0	 if id == 	1001536	 & fisgi ==	.	//	           
replace fishw = 	0	 if id == 	1001536	 & fishw ==	.	//	       
replace fisoth = 	0	 if id == 	1001536	 & fisoth ==	.	//	                                                                                      
replace fisgi = 	0	 if id == 	1001538	 & fisgi ==	.	//	YES        
replace fisnpm = 	0	 if id == 	1001576	 & fisnpm ==	.	//	-          
replace fisgi = 	0	 if id == 	1001576	 & fisgi ==	.	//	-          
replace fisoth = 	0	 if id == 	1001576	 & fisoth ==	.	//	-                                                                                     
replace fisgi = 	10	 if id == 	1001631	 & fisgi ==	.	//	10 SALARIED
replace fispm = 	95	 if id == 	1001697	 & fispm ==	.	//	95%
replace fisoth = 	0	 if id == 	1001832	 & fisoth ==	.	//	3 SALE OF NATURAL MEDICINES                                                           
replace fispm = 	95	 if id == 	1001897	 & fispm ==	.	//	95 CO-PAYMENT!    
replace fisnpm = 	1	 if id == 	1001939	 & fisnpm ==	.	//	1%
replace fisgi = 	1	 if id == 	1001939	 & fisgi ==	.	//	1%
replace fispm = 	80	 if id == 	1001958	 & fispm ==	.	//	80 ESTIMATION ONLY
replace fisnpm = 	1.5	 if id == 	1001958	 & fisnpm ==	.	//	1 1/2
replace fisgi = 	7.5	 if id == 	1001958	 & fisgi ==	.	//	7 1/2
replace fisoth = 	0	 if id == 	1001958	 & fisoth ==	.	//	                                                                                      
replace fisnpm = 	2.5	 if id == 	1002059	 & fisnpm ==	.	//	2.5
replace fisgi = 	2.5	 if id == 	1002059	 & fisgi ==	.	//	2.5
replace fisoth = 	0	 if id == 	1002059	 & fisoth ==	.	//	                                                                                      
replace fispm = 	-4	 if id == 	1002102	 & fispm ==	60	//	                  
replace fisnpm = 	-4	 if id == 	1002102	 & fisnpm ==	60	//	           
replace fisgi = 	-4	 if id == 	1002102	 & fisgi ==	.	//	N/A        
replace fishw = 	-4	 if id == 	1002102	 & fishw ==	0	//	       
replace fisoth = 	-4	 if id == 	1002102	 & fisoth ==	0	//	                                                                                      
replace fisgi = 	0	 if id == 	1002132	 & fisgi ==	.	//	           
replace fishw = 	0	 if id == 	1002132	 & fishw ==	.	//	       
replace fisoth = 	10	 if id == 	1002132	 & fisoth ==	.	//	10 (GP TRAINING PROVIDER)                                                             
replace fispm = 	79	 if id == 	1002186	 & fispm ==	.	//	79.25
replace fisgi = 	1	 if id == 	1002186	 & fisgi ==	.	//	0.75
replace fisoth = 	7	 if id == 	1002302	 & fisoth ==	.	//	7            TEACHING                                                                 
replace fispm = 	-4	 if id == 	1002308	 & fispm ==	.	//	65 OF GROSS       
replace fisnpm = 	-4	 if id == 	1002308	 & fisnpm ==	.	//	65 OF GROSS
replace fispm = 	85	 if id == 	1002509	 & fispm ==	.	//	85%
replace fisnpm = 	10	 if id == 	1002509	 & fisnpm ==	.	//	10%
replace fisgi = 	5	 if id == 	1002509	 & fisgi ==	.	//	5%
replace fishw = 	0	 if id == 	1002509	 & fishw ==	.	//	       
replace fisoth = 	0	 if id == 	1002509	 & fisoth ==	.	//	                                                                                      
replace fispm = 	70	 if id == 	1002542	 & fispm ==	.	//	70%
replace fisnpm = 	0	 if id == 	1002542	 & fisnpm ==	.	//	           
replace fishw = 	0	 if id == 	1002542	 & fishw ==	.	//	       
replace fisoth = 	0	 if id == 	1002542	 & fisoth ==	.	//	                                                                                      
replace fisgi = 	0.5	 if id == 	1002566	 & fisgi ==	.	//	0.5
replace fishw = 	0	 if id == 	1002566	 & fishw ==	.	//	       
replace fisoth = 	0.5	 if id == 	1002566	 & fisoth ==	.	//	0.5
replace fisgi = 	4.5	 if id == 	1002568	 & fisgi ==	.	//	4.5
replace fisnpm = 	0.5	 if id == 	1002719	 & fisnpm ==	.	//	0.5
replace fisgi = 	0	 if id == 	1002719	 & fisgi ==	.	//	           
replace fishw = 	1.5	 if id == 	1002719	 & fishw ==	.	//	1.5
replace fisoth = 	0	 if id == 	1002719	 & fisoth ==	.	//	                                                                                      
replace fispm = 	75	 if id == 	1002753	 & fispm ==	.	//	75 BULK BILLINGS  
replace fisnpm = 	0	 if id == 	1002753	 & fisnpm ==	.	//	           
replace fisoth = 	0	 if id == 	1002753	 & fisoth ==	.	//	                                                                                      
replace fisgi = 	0	 if id == 	1002869	 & fisgi ==	.	//	           
replace fishw = 	0	 if id == 	1002869	 & fishw ==	.	//	       
replace fisoth = 	68	 if id == 	1002869	 & fisoth ==	.	//	68 LOCUM                                                                              
replace fispm = 	85	 if id == 	1002910	 & fispm ==	.	//	85%
replace fisnpm = 	5	 if id == 	1002910	 & fisnpm ==	.	//	5%
replace fisoth = 	10	 if id == 	1002910	 & fisoth ==	.	//	10%
replace fisoth = 	20	 if id == 	1002985	 & fisoth ==	.	//	20 GOVT DEPT                                                                          
replace fispm = 	95	 if id == 	1003061	 & fispm ==	.	//	95%
replace fisnpm = 	2	 if id == 	1003061	 & fisnpm ==	.	//	2%
replace fisgi = 	3	 if id == 	1003061	 & fisgi ==	.	//	3%
replace fisoth = 	0	 if id == 	1003061	 & fisoth ==	.	//	                                                                                      
replace fisnpm = 	0.5	 if id == 	1003180	 & fisnpm ==	.	//	0.5
replace fisgi = 	0.5	 if id == 	1003180	 & fisgi ==	.	//	0.5
replace fishw = 	0	 if id == 	1003180	 & fishw ==	.	//	       
replace fisoth = 	0	 if id == 	1003180	 & fisoth ==	.	//	                                                                                      
replace fisnpm = 	5	 if id == 	1003233	 & fisnpm ==	.	//	5%
replace fisgi = 	5	 if id == 	1003233	 & fisgi ==	.	//	5%
replace fisoth = 	0	 if id == 	1003233	 & fisoth ==	.	//	                                                                                      
replace fispm = 	98	 if id == 	1003329	 & fispm ==	.	//	98%
replace fisnpm = 	2	 if id == 	1003329	 & fisnpm ==	.	//	2%
replace fisgi = 	0	 if id == 	1003329	 & fisgi ==	.	//	           
replace fishw = 	0	 if id == 	1003329	 & fishw ==	.	//	       
replace fisoth = 	0	 if id == 	1003329	 & fisoth ==	.	//	                                                                                      
replace fispm = 	20	 if id == 	1003517	 & fispm ==	.	//	20%
replace fisnpm = 	0	 if id == 	1003517	 & fisnpm ==	.	//	           
replace fisgi = 	0	 if id == 	1003517	 & fisgi ==	.	//	           
replace fishw = 	80	 if id == 	1003517	 & fishw ==	.	//	80%
replace fisoth = 	0	 if id == 	1003517	 & fisoth ==	.	//	                                                                                      
replace fisnpm = 	0	 if id == 	1003581	 & fisnpm ==	.	//	           
replace fisgi = 	0	 if id == 	1003581	 & fisgi ==	.	//	0.2
replace fisoth = 	0	 if id == 	1003581	 & fisoth ==	.	//	                                                                                      
replace fispm = 	0	 if id == 	1003596	 & fispm ==	.	//	                  
replace fisnpm = 	0	 if id == 	1003596	 & fisnpm ==	.	//	           
replace fisgi = 	0	 if id == 	1003596	 & fisgi ==	.	//	           
replace fishw = 	100	 if id == 	1003596	 & fishw ==	.	//	100%
replace fisoth = 	0	 if id == 	1003596	 & fisoth ==	.	//	                                                                                      
replace fispm = 	0	 if id == 	1003614	 & fispm ==	.	//	                  
replace fisgi = 	0.5	 if id == 	1003614	 & fisgi ==	.	//	0.5
replace fishw = 	97.5	 if id == 	1003614	 & fishw ==	.	//	97.5
replace fisoth = 	0	 if id == 	1003614	 & fisoth ==	.	//	                                                                                      
replace fispm = 	0	 if id == 	1003619	 & fispm ==	.	//	NIL               
replace fisnpm = 	0	 if id == 	1003619	 & fisnpm ==	.	//	NIL        
replace fisgi = 	0	 if id == 	1003619	 & fisgi ==	.	//	NIL        
replace fisoth = 	0	 if id == 	1003619	 & fisoth ==	.	//	NIL                                                                                   
replace fisnpm = 	0	 if id == 	1005124	 & fisnpm ==	.	//	           
replace fishw = 	0	 if id == 	1005124	 & fishw ==	.	//	       
replace fisoth = 	60	 if id == 	1005124	 & fisoth ==	.	//	HOSPITAL AND COMMUNITY HEALTH CENTRE SALARY (NB: COMMUNITY SALARY 50% RWAV FUNDING) 60

*convert into percentages if doctors reported dollar values instead

egen sum1=rowtotal(fispm fisnpm fisgi fishw fisoth)
egen sum2=rowtotal(fispm fisnpm fisgi fishw)

/*list fispm fisnpm fisgi fishw fisoth if sum2==fisoth&sum1!=100

foreach x of var fispm fisnpm fisgi fishw {
replace `x'=(`x'/sum2)*100 if `x'!=.&sum2==fisoth&sum2>1000
}
*/


foreach x of var fispm fisnpm fisgi fishw fisoth{
replace `x'=(`x'/sum1)*100 if `x'!=.&sum1>1000
}

foreach x of var fispm fisnpm fisgi fishw fisoth{
list sum1 dtimage fispm fisnpm fisgi fishw fisoth fis*comment id if `x'>100 & `x'!=.
}
*
*none to deal with

*replace fisoth=. if sum2==fisoth&sum2>100
drop sum1 sum2

egen sum1=rowtotal(fispm fisnpm fisgi fishw fisoth)
egen sum2=rowtotal(fispm fisnpm fisgi fishw)

list id dtimage fispm fisnpm fisgi fishw fisoth sum1 figey finey if sum1>1000
*none to deal with

*impute missing values equal to zero if the sum is 100

foreach x of var fispm fisnpm fisgi fishw fisoth {
replace `x'=round(`x', 0.1)
}
*
egen sum=rowtotal(fispm fisnpm fisgi fishw fisoth)
egen miss=rownonmiss(fispm fisnpm fisgi fishw fisoth)

foreach x of var fispm fisnpm fisgi fishw fisoth {

replace `x'=0 if `x'==.&sum==100
tab `x'_comment if `x'==.

gen a`x'1=strmatch(`x'_comment, "N/A*") if `x'==.
gen a`x'2=strmatch(`x'_comment, "NA*") if `x'==.
gen a`x'3=strmatch(`x'_comment, "NIL*") if `x'==.

gen a`x'=a`x'1+a`x'2+a`x'3

list id dtimage fispm fisnpm fisgi fishw fisoth `x'_comment if a`x'>=1&a`x'!=.

*replace `x'=0 if `x'==.&a`x'3==1
*replace `x'=0 if `x'==.&a`x'1==1&id==32808
*replace `x'=0 if `x'==.&a`x'1==1&id==1517
*replace `x'=0 if `x'==.&a`x'1==1&id==34726

replace `x'=-1 if `x'==.&(sdtype==3|sdtype==4)
replace `x'=-4 if `x'==.&(sdtype==1|sdtype==2)&miss>=1&miss<5
replace `x'=-2 if `x'==.&(sdtype==1|sdtype==2)&miss==0&csclid==1
replace `x'=-1 if `x'==.&(sdtype==1|sdtype==2)&miss==0&csclid==0

drop a`x'1 a`x'2 a`x'3 a`x'
label var `x' 	"cleaned"

}
*

replace fisoth_comment=fisoth_text
drop sum miss fisoth_text


****************************************************

*On-call ratio

foreach x of var wlocrpn wlocrhn wlocrpe wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr {

replace `x'_comment=upper(`x'_comment)
replace `x'_comment=trim(`x'_comment)
replace `x'_comment=itrim(`x'_comment)

replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="-0"|`x'_comment=="NIL"|`x'_comment=="ZERO"|`x'_comment=="NONE"|`x'_comment=="O")
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|`x'_comment=="N/A")

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^[1][/]([0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^[1][:]([0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^[1][ ]IN[ ]([0-9]+)$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^[1]IN([0-9]+)$")&`x'==.
replace `x'=real(regexs(1))+real(regexs(2))/10 if regexm(`x'_comment, "^([0-9]+)[.]([0-9])$")&`x'==.


foreach y of var wlocrpn wlocrhn wlocrpbn wlocrpvn {

replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]DAY$")
replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]DAYS$")
replace `y'=real(regexs(1))*5 if regexm(`y'_comment, "^([0-9]+)[ ]WEEK$")
replace `y'=real(regexs(1))*5 if regexm(`y'_comment, "^([0-9]+)[ ]WEEKS$")
replace `y'=real(regexs(1))*20 if regexm(`y'_comment, "^([0-9]+)[ ]MONTH$")
replace `y'=real(regexs(1))*20 if regexm(`y'_comment, "^([0-9]+)[ ]MONTHS$")

}

foreach y of var wlocr {

replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]DAY$")
replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]DAYS$")
replace `y'=real(regexs(1))*7 if regexm(`y'_comment, "^([0-9]+)[ ]WEEK$")
replace `y'=real(regexs(1))*7 if regexm(`y'_comment, "^([0-9]+)[ ]WEEKS$")
replace `y'=real(regexs(1))*30 if regexm(`y'_comment, "^([0-9]+)[ ]MONTH$")
replace `y'=real(regexs(1))*30 if regexm(`y'_comment, "^([0-9]+)[ ]MONTHS$")

}

foreach y of var wlocrpe wlocrhe wlocrpbe wlocrpve {

replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]DAY$")
replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]DAYS$")
replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]WEEK$")
replace `y'=real(regexs(1)) if regexm(`y'_comment, "^([0-9]+)[ ]WEEKS$")
replace `y'=real(regexs(1))*4 if regexm(`y'_comment, "^([0-9]+)[ ]MONTH$")
replace `y'=real(regexs(1))*4 if regexm(`y'_comment, "^([0-9]+)[ ]MONTHS$")

}

replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
drop `x'_1 `x'_2

replace `x'=1 if `x'_comment=="100%"&`x'==.

}
*

foreach x of var wlocrpn wlocrhn wlocrpe wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr {
list `x' `x'_comment id response dirall if `x'!=.&`x'_comment!=""
}
* all good

foreach x of var wlocrpn wlocrhn wlocrpe wlocrhe  wlocrpbn wlocrpvn  wlocrpbe wlocrpve wlocr{ 
list dtimage `x'_comment id if `x'==.&`x'_comment!=""
}
*

gen num_flag10=""
foreach x of var wlocrpn wlocrhn wlocrpe  wlocrhe  wlocrpbn wlocrpvn  wlocrpbe wlocrpve wlocr{ 
replace num_flag10="num_flag10" if `x'==.&`x'_comment!=""
}
*
tab num_flag10
preserve
sort id
keep if num_flag10=="num_flag10"
keep id sdtype typecont dir4 dir5 dir6 dir7 response wlocrpn wlocrpe wlocrnap wlocrhn wlocrhe wlocrnah wlocrpn_comment wlocrpe_comment wlocrnap_comment wlocrhn_comment wlocrhe_comment wlocrnah_comment ///
wlocrpbn wlocrpbe wlocnapb wlocrpvn wlocrpve wlocnapv wlocrpbn_comment wlocrpbe_comment wlocnapb_comment wlocrpvn_comment wlocrpve_comment wlocnapv_comment ///
wlocr wlocna wlocr_comment wlocna_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num10.xls", firstrow(variables) nolabel replace
restore

***
*num_flag10 edits

replace wlocrpn = 	5	 if wlocrpn ==	.	 & id == 	612	//	5 PLUS                                        
replace wlocrpbn = 	40	 if wlocrpbn ==	.	 & id == 	1376	//	40 PUBLIC 6 PER YEAR                                          
replace wlocrpbe = 	26	 if wlocrpbe ==	.	 & id == 	1376	//	ALWAYS AVAILABLE ON MOBILE       
replace wlocrpbn = 	7	 if wlocrpbn ==	.	 & id == 	1771	//	7DAYS                                                         
replace wlocrpbe = 	6	 if wlocrpbe ==	.	 & id == 	1771	//	6WEEKS                           
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	1771	//	            
replace wlocrpbn = 	3.5	 if wlocrpbn ==	.	 & id == 	3626	//	3 OR 4                                                        
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	3626	//	            
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	3626	//	              
replace wlocrpe = 	8	 if wlocrpe ==	.	 & id == 	3641	//	8%
replace wlocrpn = 	5	 if wlocrpn ==	.	 & id == 	3860	//	5 EVENING/WE CLINICS (NOT ON CALL)            
replace wlocrpn = 	1.25	 if wlocrpn ==	.	 & id == 	3999	//	1.25
replace wlocrhn = 	1.25	 if wlocrhn ==	.	 & id == 	3999	//	1.25
replace wlocrpn = 	14	 if wlocrpn ==	.	 & id == 	4034	//	A FORTNIGHT                                   
replace wlocrnap = 	1	 if wlocrnap ==	0	 & id == 	4058	//	                                                                        
replace wlocrnah = 	1	 if wlocrnah ==	0	 & id == 	4058	//	        
replace wlocrpn = 	1	 if wlocrpn ==	.	 & id == 	4830	//	-1
replace wlocrpe = 	1	 if wlocrpe ==	.	 & id == 	4830	//	-1
replace wlocrpn = 	5	 if wlocrpn ==	5	 & id == 	5354	//	1 IN 5                                        
replace wlocrpe = 	20	 if wlocrpe ==	20	 & id == 	5354	//	1 IN 20                                          
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	5354	//	                                                                        
replace wlocrhe = 	3	 if wlocrhe ==	.	 & id == 	5354	//	1IN 3                                              
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	5354	//	        
replace wlocrpe = 	-4	 if wlocrpe ==	.	 & id == 	5818	//	7PM - 10PM SHARE AFTER HOURS WITH OTHER PRACTICES
replace wlocrhn = 	8	 if wlocrhn ==	.	 & id == 	6606	//	8 ONLY AS SUPERVISOR                               
replace wlocrpn = 	1	 if wlocrpn ==	.	 & id == 	8265	//	1 (JUST FOR MY RESIDENTIAL AGED CARE PATIENTS)
replace wlocrpn = 	-4	 if wlocrpn ==	.	 & id == 	9401	//	1WEEK NIGHT                                   
replace wlocrpe = 	6	 if wlocrpe ==	.	 & id == 	9401	//	6WEEKENDS                                        
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	9401	//	                                                                        
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	9401	//	        
replace wlocrpn = 	5	 if wlocrpn ==	.	 & id == 	9670	//	5 1 WEEK                                      
replace wlocrpn = 	60	 if wlocrpn ==	.	 & id == 	11861	//	12WEEKS                                       
replace wlocrpe = 	12	 if wlocrpe ==	.	 & id == 	11861	//	12WEEKS                                          
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	11861	//	                                                                        
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	11861	//	        
replace wlocrhn = 	7	 if wlocrhn ==	.	 & id == 	12506	//	1 7 DAYS A WEEK                                    
replace wlocrhe = 	1	 if wlocrhe ==	.	 & id == 	12506	//	1 ALL WEEKENDS UNLESS ON HOLIDAYS                  
replace wlocrpn = 	7	 if wlocrpn ==	.	 & id == 	12585	//	***                                           
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	12748	//	4 ONLY SATURDAY                                  
replace wlocrhn = 	1	 if wlocrhn ==	.	 & id == 	13809	//	01 ONCE/WEEK                                       
replace wlocrhe = 	1	 if wlocrhe ==	.	 & id == 	13809	//	01 ONCE/MONTH                                      
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	16822	//	4 SAT ONLY                                       
replace wlocrpn = 	7	 if wlocrpn ==	.	 & id == 	17260	//	7 DOMICILIARY HOSPICE CARE                    
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	17307	//	                                                                        
replace wlocrhe = 	4	 if wlocrhe ==	.	 & id == 	17307	//	1MONTH                                             
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	17307	//	        
replace wlocrnah = 	1	 if wlocrnah ==	0	 & id == 	18555	//	        
replace wlocrpn = 	-4	 if wlocrpn ==	.	 & id == 	19259	//	DEPENDS ON WHERE I AM DOING A LOCUM           
replace wlocrpn = 	1	 if wlocrpn ==	.	 & id == 	20351	//	1 ON CALL MONDAY TO THURSDAY INCLUSIVE        
replace wlocrhe = 	1	 if wlocrhe ==	.	 & id == 	20351	//	1 ALL HOSPITAL PATIENTS COVERED BY ME              
replace wlocrpn = 	-4	 if wlocrpn ==	.	 & id == 	20687	//	//24/7
replace wlocrpn = 	5	 if wlocrpn ==	.	 & id == 	20917	//	//5/5
replace wlocrpe = 	1	 if wlocrpe ==	1	 & id == 	20917	//	//1/1
replace wlocrpn = 	-4	 if wlocrpn ==	.	 & id == 	22802	//	ALL THE TIME                                  
replace wlocrpe = 	-4	 if wlocrpe ==	.	 & id == 	22802	//	ALL THE TIME                                     
replace wlocrhn = 	5	 if wlocrhn ==	.	 & id == 	24089	//	5 ROSTER IN A&E                                    
replace wlocrpbn = 	0	 if wlocrpbn ==	.	 & id == 	25045	//	0 ALWAYS ON CALL IE. GET CALLED                               
replace wlocrpbe = 	0	 if wlocrpbe ==	.	 & id == 	25045	//	                                 
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	25893	//	5 WEEKS & NIGHTS EVERY 4-6 WEEKS                              
replace wlocrpbe = 	8	 if wlocrpbe ==	.	 & id == 	28033	//	VARIABLE                         
replace wlocrpvn = 	-4	 if wlocrpvn ==	8	 & id == 	28033	//	                                      
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	28758	//	5 SEE BELOW                                                   
replace wlocrpbn = 	1	 if wlocrpbn ==	.	 & id == 	28785	//	1/1 ALWAYS ON CALL                                            
replace wlocrpbe = 	0	 if wlocrpbe ==	.	 & id == 	28963	//	24 HRS 7 DAY                     
replace wlocnapb = 	0	 if wlocnapb ==	1	 & id == 	28963	//	            
replace wlocrpvn = 	30	 if wlocrpvn ==	.	 & id == 	29222	//	6W                                    
replace wlocrpbe = 	0	 if wlocrpbe ==	.	 & id == 	30394	//	4 10                             
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	31310	//	1WEEK IN 5                                                    
replace wlocrpbe = 	5	 if wlocrpbe ==	.	 & id == 	31310	//	I WEEKEND IN 5                   
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	31310	//	            
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	31310	//	              
replace wlocrpbn = 	10	 if wlocrpbn ==	.	 & id == 	32390	//	10 FORTNIGHT                                                  
replace wlocrpbe = 	4	 if wlocrpbe ==	0	 & id == 	32390	//	                                 
replace wlocrpvn = 	7	 if wlocrpvn ==	.	 & id == 	33681	//	7 EVERY DAY                           
replace wlocrpve = 	8	 if wlocrpve ==	.	 & id == 	34897	//	                         
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	34915	//	            
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	35204	//	1 IN5                                                         
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	35204	//	            
replace wlocrpbn = 	2.5	 if wlocrpbn ==	.	 & id == 	36922	//	2 IN 5                                                        
replace wlocrpbe = 	2.5	 if wlocrpbe ==	.	 & id == 	36922	//	                                 
replace wlocrpvn = 	3	 if wlocrpvn ==	.	 & id == 	37114	//	3 TIMES PER WEEK                      
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	37114	//	              
replace wlocrpbn = 	40	 if wlocrpbn ==	.	 & id == 	37870	//	40 EVERY 8 WKS                                                
replace wlocrpbe = 	17	 if wlocrpbe ==	.	 & id == 	37870	//	3 PER YR                              
replace wlocrpbn = 	2.25	 if wlocrpbn ==	.	 & id == 	38768	//	2.25
replace wlocrpbe = 	2.25	 if wlocrpbe ==	.	 & id == 	38768	//	2.25
replace wlocrpbn = 	-4	 if wlocrpbn ==	.	 & id == 	39997	//	24 HRS/DAY FOR 2 WEEKS                                        
replace wlocrpbe = 	6.5	 if wlocrpbe ==	0	 & id == 	39997	//	I WEEKS/YR                            
replace wlocrpvn = 	0	 if wlocrpvn ==	.	 & id == 	39997	//	
replace wlocrpbn = 	1	 if wlocrpbn ==	.	 & id == 	40920	//	ONE                                                           
replace wlocrpbe = 	1	 if wlocrpbe ==	.	 & id == 	40920	//	ONE                              
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	40920	//	            
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	40920	//	              
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	41199	//	06 OTHER PUBLIC CAN OVERLAY      
replace wlocrpvn = 	6	 if wlocrpvn ==	4	 & id == 	41199	//	                                      
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	41235	//	            
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	41235	//	              
replace wlocrpve = 	6	 if wlocrpve ==	.	 & id == 	41345	//	6 MO                     
replace wlocrpbe = 	8	 if wlocrpbe ==	.	 & id == 	41965	//	7 5                              
replace wlocrpvn = 	75	 if wlocrpvn ==	8	 & id == 	41965	//	                                      
replace wlocrpbn = 	1	 if wlocrpbn ==	.	 & id == 	42224	//	01 PERMANENT ON CALL (ONLY SPECIALIST IN AREA)                
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	43105	//	                                 
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	43203	//	1 WEEKNIGHT/MONTH                                             
replace wlocrpbe = 	8	 if wlocrpbe ==	.	 & id == 	43203	//	1 WEEKEND/2 MONTHS                    
replace wlocrpvn = 	20	 if wlocrpvn ==	.	 & id == 	43203	//	1 WEEKNIGHT/MONTH                
replace wlocrpve = 	4	 if wlocrpve ==	.	 & id == 	43203	//	1 WEEKEND ONTH           
replace wlocrpbe = 	3	 if wlocrpbe ==	.	 & id == 	43259	//	2.58
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	43259	//	            
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	43308	//	1 IN 4 WEEKS                                                  
replace wlocrpbe = 	.	 if wlocrpbe ==	0	 & id == 	43308	//	                                 
replace wlocrpvn = 	0	 if wlocrpvn ==	.	 & id == 	43308	//	                                      
replace wlocrpbn = 	7	 if wlocrpbn ==	.	 & id == 	43518	//	7 WORKED TOGETHER                                             
replace wlocrpbe = 	7	 if wlocrpbe ==	.	 & id == 	43518	//	7 WORKS TOGETHER                 
replace wlocrpvn = 	7	 if wlocrpvn ==	.	 & id == 	43518	//	7 WORKS TOGETHER                      
replace wlocrpve = 	7	 if wlocrpve ==	.	 & id == 	43518	//	7 WORKS TOGETHER         
replace wlocrhn = 	1.25	 if wlocrhn ==	.	 & id == 	48989	//	4 NIGHTS/WK                                        
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	49548	//	1 PER MONTH                                                   
replace wlocrpbe = 	8	 if wlocrpbe ==	.	 & id == 	49548	//	1 EVERY 2 MONTHS                 
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	49548	//	            
replace wlocrpvn = 	20	 if wlocrpvn ==	.	 & id == 	49548	//	1 PER MONTH                           
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	49548	//	              
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	49705	//	IN4 WEEKS                                        
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	49705	//	                                                                        
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	51650	//	EVERY MONTH                                                   
replace wlocrpbn = 	26	 if wlocrpbn ==	.	 & id == 	52503	//	5 IN 130                                                      
replace wlocrpbe = 	26	 if wlocrpbe ==	.	 & id == 	52503	//	2 IN 52                          
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	52503	//	            
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	53356	//	5 A WEEK                                                      
replace wlocrpbe = 	7	 if wlocrpbe ==	.	 & id == 	53356	//	5 A WEEK                         
replace wlocrpvn = 	5	 if wlocrpvn ==	7	 & id == 	53356	//	                                      
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	53547	//	1 WEEK IN 4 - 6 WEEKS                                         
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	53782	//	5 PUBLIC SECTOR WORK ONLY                                     
replace wlocrpbe = 	5	 if wlocrpbe ==	.	 & id == 	53782	//	                                 
replace wlocrpvn = 	.	 if wlocrpvn ==	5	 & id == 	53782	//	                                      
replace wlocrpbn = 	8	 if wlocrpbn ==	.	 & id == 	54290	//	8 CONCURRENT                                                  
replace wlocrpbe = 	8	 if wlocrpbe ==	.	 & id == 	54290	//	8 CONCURRENT                     
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	54560	//	05 ONE LATE SHIFT WEEK                                        
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	54560	//	04 EVERY 4TH WEEKEND                  
replace wlocrpbe = 	0	 if wlocrpbe ==	.	 & id == 	55256	//	0 1 WEEKEND DAY IN EVERY 2 WEEKS 
replace wlocrpve = 	2	 if wlocrpve ==	.	 & id == 	55256	//	                         
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	56634	//	                                                                        
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	56634	//	        
replace wlocrpe = 	3	 if wlocrpe ==	.	 & id == 	56958	//	3-D                                              
replace wlocrhn = 	1	 if wlocrhn ==	.	 & id == 	56961	//	//7/7
replace wlocrpn = 	3	 if wlocrpn ==	.	 & id == 	57474	//	SAME                                          
replace wlocrpe = 	3	 if wlocrpe ==	.	 & id == 	57474	//	SAME                                             
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	57911	//	4 HOSPITAL IN THE HOME                           
replace wlocrnap = 	1	 if wlocrnap ==	.	 & id == 	58690	//	                                                                        
replace wlocrhn = 	10	 if wlocrhn ==	.	 & id == 	58690	//	2WEEKS                                             
replace wlocrhe = 	4	 if wlocrhe ==	.	 & id == 	58690	//	1 MNTH                                             
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	58690	//	        
replace wlocrpe = 	2	 if wlocrpe ==	.	 & id == 	58691	//	FORTNIGHT                                        
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	58691	//	                                                                        
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	58892	//	//1/4
replace wlocrpbn = 	12	 if wlocrpbn ==	.	 & id == 	58964	//	28/365                                                        
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	58964	//	//1/4
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	59197	//	ONE WEEK                                                      
replace wlocrpe = 	5	 if wlocrpe ==	.	 & id == 	60280	//	5 WEEKENDS                                       
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	60280	//	                                                                        
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	60542	//	EVERY 3/12 OR 80                                 
replace wlocrpbe = 	2	 if wlocrpbe ==	.	 & id == 	62128	//	//6/12
replace wlocrpbn = 	4	 if wlocrpbn ==	.	 & id == 	62716	//	2:08
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	62716	//	2:08
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	62716	//	            
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	62716	//	              
replace wlocrpn = 	20	 if wlocrpn ==	.	 & id == 	64216	//	20 FOR SICK/PALLIATIVE PATIENTS ONLY          
replace wlocrpe = 	20	 if wlocrpe ==	.	 & id == 	64216	//	20 FOR SICK/PALLIATIVE PATIENTS ONLY             
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	65108	//	2 IN 10                                                       
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	65108	//	            
replace wlocrpn = 	5	 if wlocrpn ==	.	 & id == 	65323	//	ONE WEEK                                      
replace wlocrpbn = 	0	 if wlocrpbn ==	.	 & id == 	67395	//	--                                                            
replace wlocrpn = 	10	 if wlocrpn ==	.	 & id == 	68135	//	02 WKS                                        
replace wlocrpbn = 	7	 if wlocrpbn ==	.	 & id == 	68965	//	1 IN SEVEN                                                    
replace wlocrpbe = 	10	 if wlocrpbe ==	.	 & id == 	68965	//	1 IN TEN                         
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	68965	//	            
replace wlocrpbn = 	30	 if wlocrpbn ==	.	 & id == 	70783	//	30% 10 WEEKNIGHTS A MONTH                                     
replace wlocrpbe = 	3	 if wlocrpbe ==	.	 & id == 	70783	//	3 1 IN 3 WEEKENDS                
replace wlocrpbn = 	6	 if wlocrpbn ==	.	 & id == 	72785	//	9 WEEKS PER YEAR: 24HOURS PER DAY FOR 7 DAYS                  
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	72785	//	            
replace wlocrpbe = 	24	 if wlocrpbe ==	45	 & id == 	72887	//	                                 
replace wlocrpvn = 	45	 if wlocrpvn ==	.	 & id == 	72887	//	6 MTHS                                
replace wlocrpve = 	24	 if wlocrpve ==	.	 & id == 	72887	//	6 MTHS                   
replace wlocrpbn = 	4	 if wlocrpbn ==	.	 & id == 	72947	//	1 WEEK IN 4                                                   
replace wlocrpbe = 	.	 if wlocrpbe ==	0	 & id == 	72947	//	                                 
replace wlocrpvn = 	0	 if wlocrpvn ==	.	 & id == 	72947	//	                                      
replace wlocnapb = 	1	 if wlocnapb ==	.	 & id == 	72966	//	            
replace wlocrpvn = 	2	 if wlocrpvn ==	.	 & id == 	72966	//	I IN 2                                
replace wlocrpve = 	5	 if wlocrpve ==	.	 & id == 	72966	//	I IN 5                   
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	72966	//	              
replace wlocrpbn = 	4	 if wlocrpbn ==	.	 & id == 	72988	//	4 (MON-THURS)                                                 
replace wlocrpbe = 	7	 if wlocrpbe ==	.	 & id == 	72988	//	7 (FRI-SUN)                      
replace wlocrpbn = 	30	 if wlocrpbn ==	.	 & id == 	73028	//	1 EVERY 6 WEEK                                                
replace wlocrpbe = 	12	 if wlocrpbe ==	.	 & id == 	73028	//	1 EVERY 3 MONTHS                 
replace wlocrpvn = 	60	 if wlocrpvn ==	.	 & id == 	73028	//	1 WEEK AT NIGHT: 3 MONTHS             
replace wlocrpve = 	12	 if wlocrpve ==	.	 & id == 	73028	//	1 WEEKEND: 3 MONTHS      
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	73274	//	5 A WEEK                                                      
replace wlocrpbe = 	2	 if wlocrpbe ==	.	 & id == 	73274	//	                                 
replace wlocrpvn = 	.	 if wlocrpvn ==	.	 & id == 	73274	//	2 IN FORTNIGHT                        
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	73369	//	A WEEK                                                        
replace wlocrpbe = 	20	 if wlocrpbe ==	.	 & id == 	73369	//	A MONTH                          
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	73369	//	            
replace wlocrnap = 	1	 if wlocrnap ==	.	 & id == 	80610	//	                                                                        
replace wlocrhn = 	5	 if wlocrhn ==	.	 & id == 	80610	//	A WEEK                                             
replace wlocrhe = 	2	 if wlocrhe ==	.	 & id == 	80610	//	A FORTNIGHT                                        
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	80610	//	        
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	84483	//	4WEEKS                                                        
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	84483	//	4WEEKS                           
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	84483	//	            
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	84483	//	              
replace wlocrpbe = 	12	 if wlocrpbe ==	.	 & id == 	85126	//	ALL THE TIME                     
replace wlocrpvn = 	-4	 if wlocrpvn ==	12	 & id == 	85126	//	                                      
replace wlocrpve = 	1	 if wlocrpve ==	.	 & id == 	85126	//	ALL THE TIME             
replace wlocrpbn = 	2.5	 if wlocrpbn ==	.	 & id == 	86968	//	2 WEEKNIGHTS PER WEEK                                         
replace wlocrpbe = 	2	 if wlocrpbe ==	0	 & id == 	88813	//	02 I WORK (NOT ON CALL) 1 WEEKEND IN 2
replace wlocrpvn = 	0	 if wlocrpvn ==	.	 & id == 	88813	//	
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	89667	//	A MONTH                                                       
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	89667	//	            
replace wlocrpvn = 	-1	 if wlocrpvn ==	.	 & id == 	89667	//	                                      
replace wlocrpve = 	-1	 if wlocrpve ==	.	 & id == 	89667	//	                         
replace wlocrpbe = 	12	 if wlocrpbe ==	.	 & id == 	91193	//	12 ON FOR ENTIRE WEEK 1 WEEK IN 12    
replace wlocrhn = 	7	 if wlocrhn ==	.	 & id == 	91501	//	7 DAYS X                                           
replace wlocrhe = 	3	 if wlocrhe ==	.	 & id == 	91501	//	3 X                                                
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	92096	//	4 4 WEEKS                                        
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	92549	//	WEEKLY EVERY 5TH WEEK                                         
replace wlocrpbe = 	1	 if wlocrpbe ==	.	 & id == 	94445	//	ALL                              
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	94445	//	            
replace wlocnapv = 	0	 if wlocnapv ==	.	 & id == 	94445	//	              
replace wlocrpbn = 	1	 if wlocrpbn ==	.	 & id == 	97028	//	24/7 AS DIRECTOR PUBLIC SECTOR WORK                           
replace wlocrpbe = 	1	 if wlocrpbe ==	.	 & id == 	97028	//	                                 
replace wlocrhn = 	5	 if wlocrhn ==	.	 & id == 	1000597	//	1 WK                                               
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	1000624	//	MONTH                                                         
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	1000624	//	MONTH                            
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	1000624	//	            
replace wlocrpbn = 	30	 if wlocrpbn ==	.	 & id == 	1000635	//	30 IE 1/MONTH 2 DAYS                                          
replace wlocrpbe = 	12	 if wlocrpbe ==	.	 & id == 	1000635	//	12 IE 1 X/3M 2 WEEKENDS          
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	1000683	//	            
replace wlocrpbn = 	10	 if wlocrpbn ==	.	 & id == 	1000697	//	FORTNIGHT                                                     
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	1000697	//	MONTH                            
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	1000697	//	            
replace wlocrpe = 	1	 if wlocrpe ==	.	 & id == 	1001138	//	A WEEK                                           
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	1001138	//	                                                                        
replace wlocrpe = 	5	 if wlocrpe ==	.	 & id == 	1001336	//	5 1 SATURDAY, 5 HOURS, EVERY 4 WEEKS             
replace wlocrhn = 	0	 if wlocrhn ==	.	 & id == 	1001336	//	                                                   
replace wlocrhe = 	0	 if wlocrhe ==	.	 & id == 	1001336	//	                                                   
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	1001368	//	ONE WEEK                                                      
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	1001453	//	A MONTH                                          
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	1001532	//	4 WEEKENDS                                       
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	1001532	//	                                                                        
replace wlocrpe = 	2.5	 if wlocrpe ==	.	 & id == 	1001564	//	2 WEEKS IN 5                                     
replace wlocrhn = 	10	 if wlocrhn ==	.	 & id == 	1001703	//	FORTNIGHT                                          
replace wlocrhe = 	4	 if wlocrhe ==	.	 & id == 	1001703	//	MONTH                                              
replace wlocrnah = 	0	 if wlocrnah ==	.	 & id == 	1001703	//	        
replace wlocrhn = 	5	 if wlocrhn ==	.	 & id == 	1001800	//	ONE WEEK                                           
replace wlocrhe = 	0	 if wlocrhe ==	4	 & id == 	1001800	//	4 WEEKS                                            
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	1001811	//	                                                                        
replace wlocrhe = 	-3	 if wlocrhe ==	.	 & id == 	1002077	//	N.A                                                
replace wlocrpn = 	5	 if wlocrpn ==	.	 & id == 	1002104	//	WEEK                                          
replace wlocrpe = 	20	 if wlocrpe ==	.	 & id == 	1002104	//	MONTH                                            
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	1002104	//	                                                                        
replace wlocrpn = 	0	 if wlocrpn ==	.	 & id == 	1002109	//	--                                            
replace wlocrpe = 	4	 if wlocrpe ==	.	 & id == 	1002115	//	MONTH                                            
replace wlocrpn = 	5	 if wlocrpn ==	.	 & id == 	1002920	//	1 NIGHT PER WEEK                              
replace wlocrpe = 	6	 if wlocrpe ==	.	 & id == 	1002920	//	1 WEEKEND EVERY 6 WEEKS                          
replace wlocrnap = 	0	 if wlocrnap ==	.	 & id == 	1002920	//	                                                                        
replace wlocrpe = 	1	 if wlocrpe ==	.	 & id == 	1003147	//	X ONE                                            
replace wlocrhe = 	6	 if wlocrhe ==	.	 & id == 	1003222	//	6 WEEKS/Y                                          
replace wlocrpe = 	-4	 if wlocrpe ==	22	 & id == 	1003233	//	                                                 
replace wlocrhe = 	-4	 if wlocrhe ==	22	 & id == 	1003233	//	                                                   
replace wlocrpbn = 	20	 if wlocrpbn ==	.	 & id == 	1003416	//	PER MONTH                                                     
replace wlocrpbe = 	4	 if wlocrpbe ==	.	 & id == 	1003416	//	PER MONTH                        
replace wlocrpbn = 	2.5	 if wlocrpbn ==	.	 & id == 	1003540	//	2 1/2
replace wlocrpbe = 	2.5	 if wlocrpbe ==	.	 & id == 	1003540	//	2 1/2
replace wlocrpbn = 	5	 if wlocrpbn ==	.	 & id == 	1003596	//	WEEK                                                          
replace wlocnapb = 	0	 if wlocnapb ==	.	 & id == 	1003596	//	            

replace wlocr = 	5.5	 if id == 	2129	 & wlocr ==	.	//	5 TO 6                            
replace wlocna = 	0	 if id == 	2129	 & wlocna ==	.	//	        
replace wlocr = 	1	 if id == 	50677	 & wlocr ==	.	//	1 (ON CALL ALL DAYS EXCEPT SUNDAY)
replace wlocna = 	0	 if id == 	50677	 & wlocna ==	.	//	        
replace wlocr = 	5	 if id == 	70104	 & wlocr ==	.	//	5 NIGHTS                          
replace wlocr = 	20	 if id == 	70424	 & wlocr ==	.	//	4 WEEKENDS                        
replace wlocna = 	0	 if id == 	70424	 & wlocna ==	.	//	        
replace wlocr = 	20	 if id == 	74514	 & wlocr ==	.	//	MONTH                             
replace wlocna = 	0	 if id == 	74514	 & wlocna ==	.	//	        
replace wlocr = 	3.5	 if id == 	85941	 & wlocr ==	.	//	//3/4
replace wlocr = 	20	 if id == 	88738	 & wlocr ==	.	//	ONE MONTH                         
replace wlocna = 	0	 if id == 	88738	 & wlocna ==	.	//	        
replace wlocr = 	20	 if id == 	98092	 & wlocr ==	.	//	8 (2 DAYS EVERY 8 WEEKS)          
replace wlocr = 	20	 if id == 	1000944	 & wlocr ==	.	//	ONE MONTH                         
replace wlocna = 	0	 if id == 	1000944	 & wlocna ==	.	//	        
replace wlocr = 	-4	 if id == 	1003843	 & wlocr ==	.	//	3 X ON CALL                       
replace wlocr = 	20	 if id == 	1004261	 & wlocr ==	.	//	MONTH                             
replace wlocna = 	0	 if id == 	1004261	 & wlocna ==	.	//	        
replace wlocr = 	5	 if id == 	1004450	 & wlocr ==	.	//	IN A TEN WEEK BLOCK DO 2 WEEKS    

foreach x of var wlocrpn wlocrhn wlocrpe wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve {
replace wlocoth= `x'_comment if wlocoth=="" & `x'==. & `x'_comment!=""
}
*
foreach x of var wlocrpn wlocrhn wlocrpe wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr {
tab `x'
tab `x'_comment if `x'==.
}
*
*Some extra cases identified
replace wlocrpvn = 5 if id==73274 & wlocrpvn_comment == "2 IN FORTNIGHT"
replace wlocrpvn = 12 if id==91193 & wlocrpvn_comment == "12 ON FOR ENTIRE WEEK 1 WEEK IN 12"
replace wlocrpvn = 2.5 if id==36922 & wlocrpvn_comment == "2 IN 5"
*list id wlocrpvn wlocrpvn_comment if wlocrpvn_comment == "2 IN FORTNIGHT"| wlocrpvn_comment == "12 ON FOR ENTIRE WEEK 1 WEEK IN 12" | wlocrpvn_comment == "2 IN 5"

****************************************************

*Call out times

foreach x of var wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe wlcotpve wlcot {

replace `x'_comment=upper(`x'_comment)
replace `x'_comment=trim(`x'_comment)
replace `x'_comment=itrim(`x'_comment)

replace `x'=0 if `x'==.&(`x'_comment=="-"|`x'_comment=="-0"|`x'_comment=="NIL"|`x'_comment=="ZERO"|`x'_comment=="NONE"|`x'_comment=="O")
replace `x'=-3 if `x'==.&(`x'_comment=="NA"|`x'_comment=="N/A")

replace `x'=1 if `x'==.&(`x'_comment=="ONCE")
replace `x'=2 if `x'==.&(`x'_comment=="TWICE")

replace `x'=real(regexs(1))+real(regexs(2))/10 if regexm(`x'_comment, "^([0-9]+)[.]([0-9])$")&`x'==.
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
gen `x'_1 = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
gen `x'_2 = real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
replace `x'=`x'_1 if `x'==.&`x'_1==`x'_2&regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")&`x'==.
drop `x'_1 `x'_2

*list id dtimage `x'_comment if `x'==.&`x'_comment!=""

}

*check imputations worked properly
foreach x of var wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe wlcotpve wlcot {
list dtimage `x' `x'_comment id if `x'!=.&`x'_comment!=""
}
*all good

foreach x of var wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe wlcotpve wlcot {
list dtimage `x'_comment id if `x'==.&`x'_comment!=""
}
*
gen num_flag11=""
foreach x of var wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe wlcotpve wlcot {
replace num_flag11="num_flag11" if `x'==.&`x'_comment!=""
}
*
tab num_flag11
preserve
sort id
keep if num_flag11=="num_flag11"
keep id sdtype response dir4 dir5 dir6 dir7 wlcotpn wlcotpe wlcotnap wlcothn wlcothe wlcotnah ///
wlcotpn_comment wlcotpe_comment wlcotnap_comment wlcothn_comment wlcothe_comment wlcotnah_comment ///
wlcotpbn wlcotpbe wlcotnapb wlcotpvn wlcotpve wlcotnapv ///
wlcotpbn_comment wlcotpbe_comment wlcotnapb_comment wlcotpvn_comment wlcotpve_comment wlcotnapv_comment ///
wlcot wlcot_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num11.xls", firstrow(variables) nolabel replace
restore

*sp dir6 ; gp dir7

***
*num_flag11 edits
***

replace wlcothn = 	5	 if id == 	612	 & wlcothn ==	.	//	PLUS 5                     
replace wlcotnap = 	1	 if id == 	4058	 & wlcotnap ==	0	//	        
replace wlcotnah = 	1	 if id == 	4058	 & wlcotnah ==	0	//	        
replace wlcotpn = 	1	 if id == 	7058	 & wlcotpn ==	.	//	1*                               
replace wlcotpe = 	1	 if id == 	7058	 & wlcotpe ==	.	//	1*            
replace wlcotnap = 	0	 if id == 	7058	 & wlcotnap ==	.	//	        
replace wlcotnah = 	0	 if id == 	7058	 & wlcotnah ==	.	//	        
replace wlcotnap = 	0	 if id == 	7984	 & wlcotnap ==	1	//	        
replace wlcothn = 	3	 if id == 	13809	 & wlcothn ==	.	//	03 1-2/NIGHT               
replace wlcothe = 	-4	 if id == 	13809	 & wlcothe ==	.	//	VARIABLE                               
replace wlcothe = 	5	 if id == 	16303	 & wlcothe ==	.	//	5 SEEING ***                           
replace wlcothn = 	-5	 if id == 	24089	 & wlcothn ==	.	//	IN HOSP DURING ROSTERED HRS
replace wlcotpbn = 	0	 if id == 	26350	 & wlcotpbn ==	.	//	0 CALLED OUT                                                   
replace wlcotnapv = 	0	 if id == 	27142	 & wlcotnapv ==	.	//	        
replace wlcotpvn = 	1	 if id == 	27831	 & wlcotpvn ==	.	//	1 (4 HOURS)                       
replace wlcotpbn = 	0	 if id == 	31308	 & wlcotpbn ==	.	//	0 BUT CONSULTATION X 3 BETWEEN OFFICE & HOME                   
replace wlcotpbe = 	0	 if id == 	31308	 & wlcotpbe ==	.	//	0 BUT CONSULTATION X 3 BETWEEN OFFICE & HOME            
replace wlcotpvn = 	8	 if id == 	32399	 & wlcotpvn ==	.	//	8 PROBLEMS DEALT WITH BY TELEPHONE
replace wlcotnapv = 	0	 if id == 	32399	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	0.25	 if id == 	32599	 & wlcotpbn ==	.	//	0.25
replace wlcotpbe = 	0.25	 if id == 	32599	 & wlcotpbe ==	.	//	0.25
replace wlcotpvn = 	-1	 if id == 	32599	 & wlcotpvn ==	.	//	                                  
replace wlcotpve = 	-1	 if id == 	32599	 & wlcotpve ==	.	//	                              
replace wlcotnapv = 	1	 if id == 	32599	 & wlcotnapv ==	.	//	        
replace wlcotnapv = 	0	 if id == 	33720	 & wlcotnapv ==	.	//	        
replace wlcotnapb = 	1	 if id == 	34656	 & wlcotnapb ==	0	//	                                    
replace wlcotnapv = 	0	 if id == 	34656	 & wlcotnapv ==	.	//	        
replace wlcotnapb = 	0	 if id == 	35953	 & wlcotnapb ==	.	//	                                    
replace wlcotnapv = 	0	 if id == 	35953	 & wlcotnapv ==	.	//	        
replace wlcotpbe = 	7	 if id == 	37008	 & wlcotpbe ==	.	//	47 CONSTANT ***                                         
replace wlcotnapv = 	0	 if id == 	37008	 & wlcotnapv ==	.	//	        
replace wlcotpbe = 	2	 if id == 	37260	 & wlcotpbe ==	.	//	2 - PHONE                                               
replace wlcotnapv = 	0	 if id == 	37260	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	0	 if id == 	41199	 & wlcotpbn ==	.	//	0 OUT CONSULTATIVE ON CALL ONLY                                
replace wlcotnapv = 	0	 if id == 	41199	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	5	 if id == 	41791	 & wlcotpbn ==	.	//	5 TIMES PER WEEK *** - SEVERAL CALLS EACH NIGHT                
replace wlcotpbn = 	0	 if id == 	41829	 & wlcotpbn ==	.	//	00 NOT ON CALL IN LAST WEEK                                    
replace wlcotpbe = 	0	 if id == 	41829	 & wlcotpbe ==	.	//	00 NOT ON CALL IN LAST WEEK                             
replace wlcotpvn = 	0	 if id == 	41829	 & wlcotpvn ==	.	//	00 NOT ON CALL IN LAST WEEK       
replace wlcotpve = 	0	 if id == 	41829	 & wlcotpve ==	.	//	00 NOT ON CALL IN LAST WEEK   
replace wlcotnapv = 	0	 if id == 	41829	 & wlcotnapv ==	.	//	        
replace wlcotnapv = 	0	 if id == 	53782	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	0	 if id == 	53899	 & wlcotpbn ==	.	//	0 NOT ON CALL                                                  
replace wlcotpbe = 	0	 if id == 	53899	 & wlcotpbe ==	.	//	0 NOT ON CALL                                           
replace wlcotpvn = 	0	 if id == 	53899	 & wlcotpvn ==	.	//	0 NOT ON CALL                     
replace wlcotpve = 	0	 if id == 	53899	 & wlcotpve ==	.	//	0 NOT ON CALL                 
replace wlcotnapv = 	0	 if id == 	53899	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	0	 if id == 	54336	 & wlcotpbn ==	.	//	0 NOT ON-CALL DURING LAST WEEK                                 
replace wlcotpbe = 	0	 if id == 	54336	 & wlcotpbe ==	.	//	0 NOT ON-CALL DURING LAST WEEK                          
replace wlcotpvn = 	0	 if id == 	54336	 & wlcotpvn ==	.	//	0 NOT ON-CALL DURING LAST WEEK    
replace wlcotpve = 	0	 if id == 	54336	 & wlcotpve ==	.	//	0 NOT ON-CALL DURING LAST WEEK
replace wlcotnapv = 	0	 if id == 	54336	 & wlcotnapv ==	.	//	        
replace wlcotnapv = 	0	 if id == 	54560	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	7	 if id == 	54866	 & wlcotpbn ==	.	//	07 TIMES PER WEEK EACH NIGHT                                   
replace wlcotpn = 	0	 if id == 	56901	 & wlcotpn ==	.	//	--                               
replace wlcotpbn = 	0	 if id == 	57023	 & wlcotpbn ==	.	//	0 NOT ON CALL                                                  
replace wlcotnapv = 	0	 if id == 	57023	 & wlcotnapv ==	.	//	        
replace wlcotpn = 	2	 if id == 	57474	 & wlcotpn ==	.	//	SAME                             
replace wlcotpe = 	4	 if id == 	57474	 & wlcotpe ==	.	//	SAME          
replace wlcotnah = 	0	 if id == 	58690	 & wlcotnah ==	.	//	        
replace wlcotpbn = 	-4	 if id == 	58991	 & wlcotpbn ==	.	//	NEVER GET HOME BEFORE 01AM!                                    
replace wlcotpbe = 	-4	 if id == 	58991	 & wlcotpbe ==	.	//	NEVER GET HOME BEFORE 01AM! 0800 - 0100AM               
replace wlcotnapv = 	0	 if id == 	58991	 & wlcotnapv ==	.	//	        
replace wlcotpbe = 	-4	 if id == 	59292	 & wlcotpbe ==	.	//	8 HOURS PER DAY                                         
replace wlcotnapb = 	0	 if id == 	59292	 & wlcotnapb ==	.	//	                                    
replace wlcotpvn = 	-1	 if id == 	59292	 & wlcotpvn ==	-3	//	N/A                               
replace wlcotpve = 	-1	 if id == 	59292	 & wlcotpve ==	-3	//	N/A                           
replace wlcotnapv = 	1	 if id == 	59292	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	5	 if id == 	59457	 & wlcotpbn ==	.	//	5 1 WEEK AT A TIME ON CALL                                     
replace wlcotnapv = 	0	 if id == 	59457	 & wlcotnapv ==	.	//	        
replace wlcotpe = 	0	 if id == 	66476	 & wlcotpe ==	.	//	0 N/A         
replace wlcotpbn = 	0	 if id == 	67395	 & wlcotpbn ==	.	//	--                                                             
replace wlcotnapv = 	0	 if id == 	67395	 & wlcotnapv ==	.	//	        
replace wlcotpbe = 	0	 if id == 	72988	 & wlcotpbe ==	.	//	0 WE DO ROUTINE SAT AM WARD ROUND IF ON CALL FOR WEEKEND
replace wlcotnapv = 	0	 if id == 	72988	 & wlcotnapv ==	.	//	        
replace wlcotnapv = 	0	 if id == 	81550	 & wlcotnapv ==	.	//	        
replace wlcotnapb = 	0	 if id == 	82683	 & wlcotnapb ==	.	//	                                    
replace wlcotnapv = 	0	 if id == 	82683	 & wlcotnapv ==	.	//	        
replace wlcotpbn = 	2	 if id == 	86394	 & wlcotpbn ==	.	//	2 WHEN ON CALL                                                 
replace wlcotpve = 	5	 if id == 	86394	 & wlcotpve ==	.	//	5 WHEN ON CALL                
replace wlcotnapv = 	0	 if id == 	86394	 & wlcotnapv ==	.	//	        
replace wlcotnapv = 	0	 if id == 	97997	 & wlcotnapv ==	.	//	        
replace wlcotpn = 	0	 if id == 	1000009	 & wlcotpn ==	.	//	0 0 ON CALL                      
replace wlcotpe = 	0	 if id == 	1000009	 & wlcotpe ==	.	//	0 0 ON CALL   
replace wlcothn = 	0	 if id == 	1000009	 & wlcothn ==	.	//	0 0 ON CALL                
replace wlcothe = 	0	 if id == 	1000009	 & wlcothe ==	.	//	0 0 ON CALL                            
replace wlcotpbn = 	10	 if id == 	1001368	 & wlcotpbn ==	.	//	ONE X FORTNIGHT                                                
replace wlcotpbe = 	20	 if id == 	1001368	 & wlcotpbe ==	.	//	ONE X MONTH                                             
replace wlcothe = 	20	 if id == 	1002523	 & wlcothe ==	.	//	20+                                    
replace wlcotnah = 	0	 if id == 	1002523	 & wlcotnah ==	.	//	        
replace wlcothe = 	1	 if id == 	1002568	 & wlcothe ==	.	//	EVERY WEEK END                         
replace wlcotnah = 	0	 if id == 	1002568	 & wlcotnah ==	.	//	        
replace wlcothe = 	-4	 if id == 	1002753	 & wlcothe ==	.	//	WE WORK AT HOSPITAL ALL DAY/WHEN ONCALL
replace wlcotnah = 	0	 if id == 	1002753	 & wlcotnah ==	.	//	        
replace wlcotnap = 	0	 if id == 	1003097	 & wlcotnap ==	.	//	        
replace wlcothe = 	20	 if id == 	1003097	 & wlcothe ==	.	//	20 OR MORE                             
replace wlcotnah = 	0	 if id == 	1003097	 & wlcotnah ==	.	//	        
replace wlcotpbn = 	0	 if id == 	1003619	 & wlcotpbn ==	.	//	0 ALL PHONE CALLS NOT REQUIRING ATTENDANCE AT THE HOSPITAL     

replace wlcot = 	1	 if id == 	46287	 & wlcot ==	.	//	CONTINUOUS NEEDED TO BE ON SITE/EACH ONCALL SHIFT        
replace wlcot = 	1	 if id == 	60786	 & wlcot ==	.	//	1 (THERE ALL THE TIME)                                   
replace wlcot = 	-3	 if id == 	61440	 & wlcot ==	.	//	N/A ON SITE ON CALL                                      
replace wlcot = 	20	 if id == 	69205	 & wlcot ==	.	//	>20 (PHONE, NO CALL INS)                                 
replace wlcot = 	-3	 if id == 	69657	 & wlcot ==	.	//	ON SITE                                                  
replace wlcot = 	1	 if id == 	70424	 & wlcot ==	.	//	1 FULL DAY                                               
replace wlcot = 	-3	 if id == 	75039	 & wlcot ==	.	//	BASED IN THE HOSPITAL                                    
replace wlcot = 	-3	 if id == 	77495	 & wlcot ==	.	//	N/A - BY PHONE ONLY                                      
replace wlcot = 	-3	 if id == 	87394	 & wlcot ==	.	//	NA - ON SITE                                             
replace wlcot = 	-3	 if id == 	89333	 & wlcot ==	.	//	N/A - ONSITE                                             
replace wlcot = 	1	 if id == 	97171	 & wlcot ==	.	//	1 STAY ON PREMISES                                       
replace wlcot = 	14	 if id == 	1005130	 & wlcot ==	.	//	14 ALL DAY                                               

foreach x of var wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe wlcotpve wlcot {
*tab `x'
tab `x'_comment if `x'==.
}
*


*wlocoth - if on-call arrangments don't fit above descriptions, please elaborate.
* this variable isn't included in public release as is text.
* the following variable indicates whether there is text in wlocoth so that this variable can be released publicly	
foreach x of var wlocrpn wlocrhn wlocrpe wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr ///
wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe wlcotpve wlcot {
replace wlocoth=`x'_comment if wlocoth=="" & (`x'<0|`x'==.)
}
*
destring wlah, replace
gen wlocot=1 if wlocoth!="" & wlocoth!="NA" & wlocoth!="N/A"
replace wlocot=0 if wlocot==. & (sdtype==1|sdtype==2) & wlah==1
tab wlocot

****************************************************

*Number of children and ages

replace fcndc=0 if fcndc==.&(fcndc_comment=="-"|fcndc_comment=="NIL"|strmatch(fcndc_comment,"*NONE*")|fcndc_comment=="ZERO")
replace fcndc=-3 if fcndc==.&(fcndc_comment=="NA"|fcndc_comment=="N/A")
replace fcndc=1 if fcndc==.&fcndc_comment=="ONE"

replace fcndc=(real(regexs(1))+real(regexs(2)))/2 if regexm(fcndc_comment, "^([0-9]+)\-([0-9]+)$")&fcndc==.
gen fcndc_1 = real(regexs(1)) if regexm(fcndc_comment, "^([0-9]+)[ ]([0-9]+)$")&fcndc==.
gen fcndc_2 = real(regexs(2)) if regexm(fcndc_comment, "^([0-9]+)[ ]([0-9]+)$")&fcndc==.
replace fcndc=fcndc_1 if fcndc==.&fcndc_1==fcndc_2&regexm(fcndc_comment, "^([0-9]+)[ ]([0-9]+)$")&fcndc==.
drop fcndc_1 fcndc_2

replace fcndc = real(regexs(1)) if regexm(fcndc_comment, "^([0-9]+)[ ][A-Z].*$")&fcndc==.
replace fcndc = real(regexs(1)) if regexm(fcndc_comment, "^([0-9]+)[ ][(][A-Z].*$")&fcndc==.
replace fcndc = real(regexs(1)) if regexm(fcndc_comment, "^([0-9]+)[A-Z].*$")&fcndc==.

*Only a few cases so do direct editings
list id dirall fcndc_comment if fcndc==.&fcndc_comment!=""

replace fcndc=-2 if id==4972
replace fcndc=0 if id==14271
replace fcndc=0 if id==30980
replace fcndc=0 if id==45641
replace fcndc=2 if id==67483
replace fcndc=0 if id==79229
replace fcndc=0 if id==84030
replace fcndc=5 if id==99362
replace fcndc=2 if id==1000866
replace fcndc=0 if id==1003667
replace fcndc=0 if id==1004125

tab fcndc

list fcndc fcc_age_* id if fcndc>6 & fcndc<.

	replace fcndc=1 if fcndc==10 & id==5129 //entry was scribbled
	replace fcndc=0 if fcndc==10 & id==24263 //entry was scribbled
	replace fcndc=1 if fcndc==7 & id==73989 //it was 1


foreach x of var fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6 {

replace `x'=-3 if fcndc==0

replace `x'_comment=trim(`x'_comment)
replace `x'_comment=itrim(`x'_comment)
replace `x'_comment = subinstr(`x'_comment, " 1/2", ".5", .)

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]YEARS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)YEARS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]YEAR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)YEAR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]YRS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)YRS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]YR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)YR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ]Y$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)Y$")&`x'==.

replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[ ]YEARS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)YEARS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[ ]YEAR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)YEAR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[ ]YRS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)YRS$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[ ]YR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)YR$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)[ ]Y$")&`x'==.
replace `x'=real(regexs(1)) if regexm(`x'_comment, "^([0-9]+[.][0-9]+)Y$")&`x'==.

replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ]MONTHS$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)MONTHS$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ]MONTH$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)MONTH$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ]MTHS$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)MTHS$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ]MTH$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)MTH$")&`x'==.

replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)[ ]WEEKS$")&`x'==.
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)[ ]WEEK$")&`x'==.
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)[ ]WKS$")&`x'==.
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)[ ]WK$")&`x'==.
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)WEEKS$")&`x'==.
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)WEEK$")&`x'==.
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)WKS$")&`x'==.
replace `x'=real(regexs(1))/52 if regexm(`x'_comment, "^([0-9]+)WK$")&`x'==.

replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ]M$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)M$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)[ ]MO$")&`x'==.
replace `x'=real(regexs(1))/12 if regexm(`x'_comment, "^([0-9]+)MO$")&`x'==.

replace `x'=real(regexs(1))/real(regexs(2)) if regexm(`x'_comment, "^([0-9]+)[/]([0-9]+)$")&`x'==.
replace `x'=real(regexs(1))+real(regexs(2))/10 if regexm(`x'_comment, "^([0-9]+)[.]([0-9])$")&`x'==.
replace `x'=real(regexs(1))+real(regexs(2))/100 if regexm(`x'_comment, "^([0-9]+)[.]([0-9][0-9])$")&`x'==.

replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][(][A-Z].*$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[A-Z].*$")&`x'==.

replace `x'=0.5 if `x'==.&`x'_comment=="<1"
replace `x'=-3 if `x'==.&`x'_comment=="NA"|`x'_comment=="N/A"
replace `x'=0.5 if `x'==.&`x'_comment=="<1"
replace `x'=0.5 if `x'==.&`x'_comment=="<1"

*list id dtimage `x'_comment if `x'==.&`x'_comment!=""
}
*
gen num_flag12 = ""
foreach x of var fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6 {
replace num_flag12 = "num_flag12" if `x'==.&`x'_comment!=""
}
tab num_flag12 
*
preserve
sort id
keep if num_flag12=="num_flag12"
keep id sdtype response dirall fcndc fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6 ///
fcndc_comment fcc_age_1_comment fcc_age_2_comment fcc_age_3_comment fcc_age_4_comment fcc_age_5_comment fcc_age_6_comment
export excel using "D:\Data\Data clean\Wave9\extracts\var_num\var_num12.xls", firstrow(variables) nolabel replace
restore

***
*num_flag 12 edits
***
replace fcc_age_1 = 	7	 if id == 	365	 & fcc_age_1 ==	.	//	0.7
replace fcc_age_3 = 	0	 if id == 	2252	 & fcc_age_3 ==	.	//	ONE MONTH OLD      
replace fcc_age_2 = 	0	 if id == 	7327	 & fcc_age_2 ==	.	//	0 <1           
replace fcc_age_3 = 	0	 if id == 	7327	 & fcc_age_3 ==	.	//	0 <1               
replace fcc_age_1 = 	46	 if id == 	9562	 & fcc_age_1 ==	.	//	46!!                            
replace fcc_age_2 = 	41	 if id == 	9562	 & fcc_age_2 ==	41	//	41 YES         
replace fcc_age_3 = 	4	 if id == 	13809	 & fcc_age_3 ==	.	//	04 }TWINS          
replace fcc_age_4 = 	4	 if id == 	13809	 & fcc_age_4 ==	.	//	04 }TWINS 
replace fcc_age_1 = 	33	 if id == 	19518	 & fcc_age_1 ==	.	//	>33                             
replace fcc_age_3 = 	2	 if id == 	25054	 & fcc_age_3 ==	.	//	-2
replace fcndc = 	1	 if id == 	27907	 & fcndc ==	.	//	             
replace fcc_age_1 = 	2	 if id == 	27907	 & fcc_age_1 ==	.	//	-2
replace fcc_age_1 = 	2	 if id == 	27907	 & fcc_age_1 ==	.	//	-2
replace fcc_age_3 = 	2	 if id == 	28938	 & fcc_age_3 ==	.	//	-2
replace fcc_age_6 = 	2	 if id == 	35273	 & fcc_age_6 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	36013	 & fcc_age_2 ==	.	//	-2
replace fcc_age_3 = 	2	 if id == 	37750	 & fcc_age_3 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	37955	 & fcc_age_2 ==	.	//	-2
replace fcc_age_4 = 	2	 if id == 	43978	 & fcc_age_4 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	45521	 & fcc_age_2 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	45621	 & fcc_age_2 ==	.	//	-2
replace fcc_age_1 = 	0.4	 if id == 	47039	 & fcc_age_1 ==	.	//	4.5 MONTHS                      
replace fcc_age_3 = 	2	 if id == 	47183	 & fcc_age_3 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	47298	 & fcc_age_2 ==	.	//	-2
replace fcc_age_1 = 	0.3	 if id == 	47489	 & fcc_age_1 ==	.	//	0.25 (3 MONTHS)                 
replace fcc_age_2 = 	0.8	 if id == 	50394	 & fcc_age_2 ==	.	//	0 (9 MONTHS)   
replace fcc_age_2 = 	2	 if id == 	51005	 & fcc_age_2 ==	.	//	-2
replace fcc_age_4 = 	2	 if id == 	52942	 & fcc_age_4 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	53468	 & fcc_age_2 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	55510	 & fcc_age_2 ==	.	//	-2
replace fcc_age_4 = 	2	 if id == 	55691	 & fcc_age_4 ==	.	//	-2
replace fcc_age_1 = 	2	 if id == 	56235	 & fcc_age_1 ==	.	//	-2
replace fcc_age_1 = 	2	 if id == 	56812	 & fcc_age_1 ==	.	//	-2
replace fcc_age_4 = 	0.5	 if id == 	58082	 & fcc_age_4 ==	.	//	6/12 MONTH
replace fcc_age_2 = 	1	 if id == 	58235	 & fcc_age_2 ==	.	//	> 1            
replace fcc_age_2 = 	2	 if id == 	58970	 & fcc_age_2 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	59473	 & fcc_age_2 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	61797	 & fcc_age_2 ==	.	//	-2
replace fcc_age_1 = 	2	 if id == 	64220	 & fcc_age_1 ==	.	//	-2
replace fcc_age_2 = 	0.5	 if id == 	64609	 & fcc_age_2 ==	.	//	00 (6 MTHS OLD)
replace fcc_age_2 = 	2	 if id == 	65130	 & fcc_age_2 ==	.	//	-2
replace fcc_age_3 = 	0.2	 if id == 	66286	 & fcc_age_3 ==	.	//	0.2
replace fcc_age_1 = 	2	 if id == 	66354	 & fcc_age_1 ==	.	//	-2
replace fcc_age_3 = 	0.5	 if id == 	66477	 & fcc_age_3 ==	.	//	0.5
replace fcc_age_2 = 	2	 if id == 	68458	 & fcc_age_2 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	68643	 & fcc_age_2 ==	.	//	-2
replace fcc_age_1 = 	0.5	 if id == 	70190	 & fcc_age_1 ==	.	//	(6 MONTHS) 00                   
replace fcc_age_2 = 	0.5	 if id == 	70754	 & fcc_age_2 ==	.	//	0.5
replace fcc_age_3 = 	0.3	 if id == 	71975	 & fcc_age_3 ==	.	//	3 , 5 MONTHS       
replace fcc_age_1 = 	0.8	 if id == 	72133	 & fcc_age_1 ==	.	//	8.5 MONTHS                      
replace fcc_age_3 = 	2	 if id == 	73078	 & fcc_age_3 ==	.	//	-2
replace fcc_age_1 = 	0.5	 if id == 	79996	 & fcc_age_1 ==	.	//	0.4 (5 MONTHS)                  
replace fcc_age_2 = 	2	 if id == 	80271	 & fcc_age_2 ==	.	//	-2
replace fcc_age_1 = 	0.3	 if id == 	80694	 & fcc_age_1 ==	.	//	3.5 MONTHS                      
replace fcc_age_1 = 	1	 if id == 	80755	 & fcc_age_1 ==	.	//	< 1                             
replace fcc_age_1 = 	2	 if id == 	81870	 & fcc_age_1 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	84483	 & fcc_age_2 ==	.	//	-2
replace fcc_age_2 = 	2	 if id == 	88163	 & fcc_age_2 ==	.	//	-2
replace fcc_age_1 = 	0.3	 if id == 	95097	 & fcc_age_1 ==	.	//	0 4 MONTHS                      
replace fcc_age_2 = 	2	 if id == 	97862	 & fcc_age_2 ==	.	//	-2
replace fcc_age_1 = 	1	 if id == 	97997	 & fcc_age_1 ==	.	//	01 14 MONTHS                    
replace fcc_age_3 = 	2	 if id == 	99213	 & fcc_age_3 ==	.	//	-2
replace fcc_age_3 = 	13	 if id == 	1001372	 & fcc_age_3 ==	.	//	\13                
replace fcc_age_3 = 	0.8	 if id == 	1001593	 & fcc_age_3 ==	.	//	0 (9 MONTHS)       
replace fcc_age_3 = 	2	 if id == 	1002384	 & fcc_age_3 ==	.	//	-2
replace fcc_age_3 = 	0.5	 if id == 	1003171	 & fcc_age_3 ==	.	//	0 (5 MONTHS)       
replace fcc_age_1 = 	30	 if id == 	1003619	 & fcc_age_1 ==	.	//	30'S DISABLED CHILD NOW AN ADULT
replace fcc_age_1 = 	2	 if id == 	1003672	 & fcc_age_1 ==	.	//	-2


foreach x of var fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6 {
list fcndc `x'_comment id if `x'==.&`x'_comment!=""
}
*all good

foreach x of num 1/6 {
replace fcc_age_`x'=round(fcc_age_`x', .5)
list id fcndc fcc_age_`x' fcc_age_`x'_comment if fcc_age_`x'>=30&fcc_age_`x'!=.
}
*
replace fcc_age_2 = -4 if fcc_age_2==182 & id==60762
*all good

***************************************

*Number of locations


foreach x of var glnl {
replace `x'=(real(regexs(1))+real(regexs(2)))/2 if regexm(`x'_comment, "^([0-9]+)\-([0-9]+)$")&`x'==.
replace `x' = real(regexs(1)) if regexm(`x'_comment, "^([0-9]+)[ ][A-Z].*$")&`x'==.
replace `x'_comment=trim(`x'_comment)
replace `x'=1 if `x'==. & `x'_comment=="ONE"
replace `x'=1 if `x'_comment=="0NE"
replace `x'=2 if `x'==. & `x'_comment=="TWO"
replace `x'=3 if `x'==. & `x'_comment=="THREE"
replace `x'=4 if `x'==. & `x'_comment=="FOUR"
replace `x'=0 if `x'==. & `x'_comment=="NIL"

replace `x'=-3 if `x'==. & `x'_comment=="N/A"| `x'_comment=="NA"

gen `x'_1=regexs(1) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
gen `x'_2=regexs(2) if regexm(`x'_comment, "^([0-9]+)[ ]([0-9]+)$")
replace `x'=(real(`x'_1)+real(`x'_2))/2 if `x'_1==`x'_2& `x'_1!=""& `x'_2!=""
drop `x'_1 `x'_2
}
*

foreach x of var glnl  {
list id `x' `x'_comment if `x'!=.&`x'_comment!=""
}
*all good

foreach x of var glnl  {
list id `x' `x'_comment if `x'==.&`x'_comment!=""
}
*
*only a few cases so do direct editings, considered num_flag13
replace glnl =	-4	if id ==	1988	//	VERY VARIABLE - LOCUM 
replace glnl =	-4	if id ==	3626	//	MULTIPLE IN 2016 - LOCUM QLD/NZ 
*replace glnl =	-4	if id ==	4022	//	PORTLAND 
replace glnl =	-5	if id ==	24970	//	LOCUM 
replace glnl =	-3	if id ==	25444	//	NOT APPLICABLE 
replace glnl =	1	if id ==	31557	//	-1
replace glnl =	-5	if id ==	32990	//	PRACTISE - CLINICAL! 
replace glnl =	-4	if id ==	34537	//	MANY 
replace glnl =	7	if id ==	35766	//	>7 
replace glnl =	-3	if id ==	36672	//	ONLY DOING LOCUMS AT PRESENT <- NOT APPLICABLE 
replace glnl =	-4	if id ==	36706	//	MULTIPLE FOR MHT, ONE FOR MEDICO-LEGAL 
replace glnl =	-4	if id ==	38415	//	MANY 
replace glnl =	3	if id ==	41085	//	MANY 3 MAIN ONES 
replace glnl =	-4	if id ==	41937	//	AS MANY AS NEEDED FOR LOCUM WORK 
replace glnl =	-4	if id ==	42126	//	MULTIPLE 
replace glnl =	25	if id ==	51239	//	HEAPS - 20 - 30 
replace glnl =	-4	if id ==	55802	//	MANY 
replace glnl =	-5	if id ==	70049	//	LOCUM CMO IN TWO HOSPITALS 
replace glnl =	-5	if id ==	73991	//	1X 
replace glnl =	8	if id ==	81672	//	8+ 
replace glnl =	2	if id ==	86248	//	2+ 
replace glnl =	-4	if id ==	97850	//	MANY 
replace glnl =	-5	if id ==	1000172	//	VIC

****************************************

foreach x of var pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo wlnppc wlnpph wlnprh wlnprr wlnph wlnp wlva wlvau ///
				  fispm fisnpm fisgi fishw fisoth ///
				 wlcmin wlcnpmin wlcsmin wlrh wlpch wlcf wlcnpf wlcnpn wlcsf wlcsn fibv fidme fidp fiip fisadd wlbbp wlocrpn wlocrhn wlocrpe /// 
				 wlocrhe wlocrpbn wlocrpvn wlocrpbe wlocrpve wlocr wlcotpn wlcothn wlcotpe wlcothe wlcotpbn wlcotpvn wlcotpbe /// 
				 wlcotpve wlcot fcndc fcc_age_1 fcc_age_2 fcc_age_3 fcc_age_4 fcc_age_5 fcc_age_6 pwhlh glnl pioth{
label var `x' 	"Cleaned"
}
*
save "${ddtah}\temp_all.dta", replace
****************************************







