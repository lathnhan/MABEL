
**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: clean the variables from first section in wave 9
********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


capture log close
set more off

log using "${dlog}\var_cssection.log", replace

********************************************************

*use "L:\Data\Data Clean\Wave9\dtah\temp_all_Tammy.dta", clear

*CSCLID
tab csclid
list id source response dir1 csclid if csclid != "0" & csclid != "1" & csclid != "2"

gen cs_flag1 = ""
replace cs_flag1 = "cs_flag1"  if csclid != "0" & csclid != "1" & csclid != "2"

preserve
tostring id, replace
keep if cs_flag1=="cs_flag1"
keep id source response dir2 csclid cs_flag1
export excel using "L:\Data\Data clean\Wave9\extracts\var_cs\var_cs1.xlsx", firstrow(variables) nolabel replace
restore

*cs_flag1 edits
*drop		 if id == 	217	 //blank form, no response
*drop		 if id == 	7856	 //blank form, no response
*drop		 if id == 	28575	 //blank form, no response
*drop		 if id == 	32419	 //permanently retired
*drop		 if id == 	68746	 //blank form, no response
replace csclid = 	"1"	 if id == 	934	//box blank but had other responses
replace csclid = 	"1"	 if id == 	1842	//box was marked
replace csclid = 	"1"	 if id == 	3894	//box blank but had other responses
replace csclid = 	"1"	 if id == 	4000	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	4830	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	6337	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	6720	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	7617	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	8476	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	8858	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	9389	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	10491	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	10688	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	11094	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	12063	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	12173	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	12307	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	13261	 //box was marked
replace csclid = 	"1"	 if id == 	13648	 //box was marked
replace csclid = 	"1"	 if id == 	14266	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	15807	 //box was marked
replace csclid = 	"1"	 if id == 	17040	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	18421	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	18609	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	19149	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	19259	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	21304	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	21548	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	21588	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	22226	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	22819	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	23186	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	23790	 //box was marked
replace csclid = 	"1"	 if id == 	23797	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	27096	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	27907	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	28609	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	29049	//box was marked
replace csclid = 	"1"	 if id == 	31647	//box was marked
replace csclid = 	"1"	 if id == 	34467	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	35238	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	42621	 //box was marked
replace csclid = 	"1"	 if id == 	44494	 //box was marked
replace csclid = 	"1"	 if id == 	45497	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	51262	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	57717	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	58039	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	58082	 //box was marked
replace csclid = 	"1"	 if id == 	58127	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	58521	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	60067	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	63922	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	63985	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	64639	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	69064	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	71518	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	71578	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	71582	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	71646	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	77683	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	83630	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	84823	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	97295	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	1001197	 //box blank but had other responses
replace csclid = 	"1"	 if id == 	1004292	 //box blank but had other responses


replace csclid="0" if csclid=="2" & response=="Online"
*replace csclid="0" if csclid=="2" & (response=="Online"|source=="Pilot")
*replace csclid="0" if csclid=="2" & response=="Hardcopy" & source=="Pilot"

gen csclid_comment=regexs(2) if regexm(csclid, "^(.*)comment[:](.*)$")
replace csclid="1" if strmatch(csclid, "1*") /*run tab csclid first to check the validity of doing this*/

tab csclid_comment csclid


*******************************************************************************
*WY: if the doctor leave all questions with blank, just drop this observation
*******************************************************************************
*check missing cases*/
br if csclid==""
*a few cases, but all except for id=32429 will be addressed later
	
*remove duplicates if one hasn't got a response at csclid
duplicates tag id, gen(dup)
tab dup

tab dup csclid, m
drop if dup>0 & csclid==""


*******************************************************

*cspret - csnmd

*replace cspret="0" if cspret=="2" & (response=="Online"|source=="Pilot")
replace cspret="0" if cspret=="2" & response=="Online"

foreach x of var cspret - csnmd {
gen `x'_comment= regexs(2) if regexm(`x', "^(.*)comment[:](.*)$")
tab `x', m
replace `x'=regexs(1) if regexm(`x', "^([0-9]) comment[:](.*)$")
tab `x', m
}
*

*replace cspret="1" if cspret_1=="1"&(response=="Online"|source=="Pilot")
*replace cspret="0" if cspret_2=="1"&(response=="Online"|source=="Pilot")

replace cspret="1" if cspret_1=="1" & response=="Online"
replace cspret="0" if cspret_2=="1" & response=="Online"

*check if doctor is working if they haven't filled in anything on 1st page - sometimes they have missed this page accidentally
list id dtimage source csclid csclid_comment csrtn glnl gltps pwtoh pwpish wldph furcom if csclid!="1" & cspret!="1"  & csncli!="1" & csml!="1" & cshd!="1" ///
& csstu!="1" & csexl!="1" & csocli!="1"& csoncli!="1" & csonmd!="1" & csnmd!="1" & csrtn!="1"

gen cs_flag2 = ""
replace cs_flag2 = "cs_flag2" if csclid!="1" & cspret!="1"  & csncli!="1" & csml!="1" & cshd!="1" & csstu!="1" & csexl!="1" & csocli!="1"& csoncli!="1" & csonmd!="1" & csnmd!="1" & csrtn!="1"

preserve
tostring id, replace
keep if cs_flag2=="cs_flag2"
keep id dirall source csclid csclid_comment csrtn glnl gltps pwtoh pwpish wldph furcom cs_flag2
export excel using "L:\Data\Data clean\Wave9\extracts\var_cs\var_cs2.xlsx", firstrow(variables) nolabel replace
restore

*cs_flag2 edits
*drop			 	 if id == 	68085	 & csclid ==	"0"	//form blank, no responses		
*drop 	 			 if id == 	33010	 & csclid ==	"0"	//form blank, no responses 		
replace csclid = "0"	 if id == 	29087	 & csclid ==	"0"	//verified					
replace csclid = "0"	 if id == 	51261	 & csclid ==	"0"	//verified					
replace csclid = "0"	 if id == 	71065	 & csclid ==	"0"	//verified					
replace csclid = "0"	 if id == 	72112	 & csclid ==	"0"	//verified					
replace csclid = "0"	 if id == 	1003147	 & csclid ==	"0"	//verified					
replace csclid = "1"	 if id == 	11706	 & csclid ==	"0"	//box was blank but had other responses					
replace csclid = "1"	 if id == 	59672	 & csclid ==	"0"	//box was blank but had other responses

*******************************************************

*recoding csclid if csclid is missing (tt 24/4/2014)

*******************************************************

destring csclid, replace


*recode to not permanently retired if cspret is blank and csncli-csnmd is not blank.
replace cspret="0" if csclid==0 & cspret=="" & (csncli=="1"|csml=="1"|cshd=="1"|csstu=="1"|csexl=="1"|csocli=="1"|csonmd=="1"|csnmd=="1")



list dtimage id csclid cspret - csrtn if cspret!=""&cspret!="0"&cspret!="1"


*recode csclid if csclid==0 and cspret is blank
*list id dtimage cs* wlwh wldph pwtoh glnl if csclid==. & cspret==""
*first check if following is appropriate for all cases
*replace csclid=1 if csclid==0 & cspret=="" & (pwnwn!=""|pwcl!=""|pwsmth!=""|pwpm!=""|pwmhn!=""|wlwh!=""|gltww!="")

*Check extended leave and amend if needed
list id dtimage cs* pwnwn pwcl pwsmth pwpm pwpuhh pwpip wldph wlwh pwtoh gltww wlnppc wlnpph furcom if csclid==0 & cspret==""

gen cs_flag3 = ""
replace cs_flag3 = "cs_flag3" if csclid==0 & cspret==""

preserve
tostring id, replace
keep if cs_flag3=="cs_flag3"
keep id dirall cs* pwnwn pwcl pwsmth pwpm pwpuhh pwpip wldph wlwh pwtoh gltww wlnppc wlnpph furcom cs_flag3
export excel using "L:\Data\Data clean\Wave9\extracts\var_cs\var_cs3.xlsx", firstrow(variables) nolabel replace
restore

*cs_flag3 edits
*drop if id == 3006 & csclid==0 //form blank, no responses

*******************************************************

*why have some said yes to csclid and also yes to cspret?
tab csclid cspret, m
list id cs* wldph pwtoh wlwh dirall if cspret=="1" & csclid==1

gen cs_flag4 = ""
replace cs_flag4 = "cs_flag4" if cspret=="1" & csclid==1
preserve
tostring id, replace
keep if cs_flag4=="cs_flag4"
keep id dirall cs* wldph pwtoh wlwh cs_flag4
export excel using "L:\Data\Data clean\Wave9\extracts\var_cs\var_cs4.xlsx", firstrow(variables) nolabel replace
restore

*cs_flag4 edits
replace csclid = 	0	 if id == 	25500	 & csclid ==	1	//work as counselor, no income from medical practice
replace cspret = 	"0"	 if id == 	36710	 & cspret ==	"1"	//box was crossed out


*****************************************************************************
*check if they report any income from clinical work, if so change their status accordingly
*****************************************************************************

foreach x of var csncli csml cshd csstu csexl csocli csoncli csonmd csnmd {
list id dirall csclid `x' `x'_comment figey figef if `x'_comment!="" & `x'_comment!="."
}
*nil of note

destring cspret - csonmd, replace

*To recode comments in csnmd if they are not currently doing non-medical work in Australia.
replace csnmd_text=csnmd_comment if csnmd_text==""&csnmd_comment!=""
replace csnmd_text=proper(csnmd_text)
replace csnmd_text=trim(csnmd_text)

list id sdtype dirall csclid cspret - csonmd csnmd csnmd_text pwtoh wlwh furcom if csnmd_text!=""

replace csnmd=csnmd_text if csnmd==""

gen cs_flag5 = ""
replace cs_flag5 = "cs_flag5" if csnmd_text != "" & csnmd_text != "0"

*list id cs_flag5 csnmd csnmd_text if csnmd_text != "" & csnmd_text != "0"
preserve
tostring id, replace
keep if cs_flag5=="cs_flag5" & cs_flag4 != "cs_flag4" & cs_flag3 != "cs_flag3" & cs_flag2 != "cs_flag2" & cs_flag1 != "cs_flag1"
*recast str244 furcom, force
keep id sdtype dirall csclid cspret - csonmd csnmd csnmd_text pwtoh wlwh furcom cs_flag5
export excel using "L:\Data\Data clean\Wave9\extracts\var_cs\var_cs5.xlsx", firstrow(variables) nolabel replace
restore

*cs_flag5 edits
*drop		 if id == 	13043			//was a CEO, not doing clinical work
*drop		 if id == 	25082			//was an admin, not doing clinical work
*drop		 if id == 	31056			//not doing clinical work, retired
*drop		 if id == 	32414			//not doing clinical work, not return
*drop		 if id == 	32995			//not doing clinical work, not return
*drop		 if id == 	34893			//retired
*drop		 if id == 	41006			//medical advisor
*drop		 if id == 	42545			//not doing medical work, business management, no responses
*drop		 if id == 	44685			//not doing medical work, no responses
*drop		 if id == 	50604			//not doing medical work, no responses
*drop		 if id == 	63455			//not doing clinical work
*drop		 if id == 	84698			//unemployed
*drop		 if id == 	93391			//not doing clinical work
replace csncli = 	-1	 if id == 	1651	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	1651	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	1	 if id == 	8788	 & csncli ==	1	//verified, left as is
replace csnmd = 	"1"	 if id == 	8788	 & csnmd ==	"1"	//verified, left as is
replace csncli = 	-1	 if id == 	8795	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	8795	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	9888	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	9888	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	16492	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	16492	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	22016	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	22016	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	25045	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	25045	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	27104	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	27104	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	29222	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	29222	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	30965	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	30965	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	33274	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	33274	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	33582	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	33582	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	33649	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	33649	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	0	 if id == 	37175	 & csncli ==	0	//verified, unemployed, left as is
replace csnmd = 	"1"	 if id == 	37175	 & csnmd ==	"1"	//verified, unemployed, left as is
replace csncli = 	0	 if id == 	38754	 & csncli ==	0	//verified, teaching, left as is
replace csnmd = 	"1"	 if id == 	38754	 & csnmd ==	"1"	//teaching, left as is
replace csncli = 	-1	 if id == 	41454	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	41454	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	42105	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	42105	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	43689	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	43689	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	0	 if id == 	44853	 & csncli ==	0	//verified, manager
replace csnmd = 	"1"	 if id == 	44853	 & csnmd ==	"1"	//verified, manager
replace csncli = 	-1	 if id == 	56640	 & csncli ==	0	//doing clinical work part time
replace csnmd = 	"-1"	 if id == 	56640	 & csnmd ==	"1"	//doing clinical work part time
replace csclid =	1	 if id == 	56640	& csclid ==	0	//doing clinical work part time
replace csncli = 	-1	 if id == 	59040	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	59040	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	61270	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	61270	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	0	 if id == 	69954	 & csncli ==	0	//verified, need to consider doctor type
replace csnmd = 	"1"	 if id == 	69954	 & csnmd ==	"1"	//verified, need to consider doctor type
replace csncli = 	0	 if id == 	72743	 & csncli ==	.	//verified
replace csnmd = 	"1"	 if id == 	72743	 & csnmd ==	"1"	//verified
replace csncli = 	-1	 if id == 	73258	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	73258	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	80961	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	80961	 & csnmd ==	"0"	//doing clinical work, considered not asked
replace csncli = 	0	 if id == 	98438	 & csncli ==	0	//verified
replace csnmd = 	"1"	 if id == 	98438	 & csnmd ==	"1"	//verified
replace csncli = 	-1	 if id == 	1000595	 & csncli ==	1	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	1000595	 & csnmd ==	"1"	//doing clinical work, considered not asked
replace csncli = 	-1	 if id == 	1004197	 & csncli ==	0	//doing clinical work, considered not asked
replace csnmd = 	"-1"	 if id == 	1004197	 & csnmd ==	"0"	//doing clinical work, considered not asked

*The following part is the extra cleaning steps, done to check the cases previously dropped. Many of which turn out to be kept in the data and a few are dropped. Refer to the Excel file for all cases.
drop		 if id == 	68746			//form blank, except for furcom which does not address any item
drop		 if id == 	217				//form totally blank
drop		 if id == 	7856			//form totally blank
drop		 if id == 	28575			//form totally blank
replace csstu = 	0	 if id == 	69722	 & csstu ==	1	//box was actually crossed out

*NOTE: id == 	34893 insisted not to wish to receive further surveys


destring csnmd, replace


**************************************************************
*list id csclid csnmd_text pwtoh wlwh if csnmd==1&csnmd_text!=""

foreach x of var csclid cspret csncli csml cshd csstu csexl csocli csoncli csonmd csnmd  {
replace `x'=0 if `x'==.
}
*

egen a=rowtotal(cspret csncli csml cshd csstu csexl csocli csoncli csonmd csnmd)

gen b=1 if csclid==1 & a>0&(pwtoh!=""|wlwh!="") //currently doing clinical work, listed non-clinical activities, & stated total hrs worked

foreach x of var cspret csncli csml cshd csstu csexl csocli csoncli csonmd csnmd {
replace `x'=0 if `x'==1&csclid==1&b==1
}

/*Now we have a group who said: a) they are in clinical practice & b)they are doing some non-clinical activity eg mat leave
and c) they haven't stated any working hours. Need to determine whether they are clinically working or not.  Therefore c is 
generated in order to determine whether the person really is in clinical practice or not. 
If c = 0 then no responses
If c > 0 then completed questionnaire.
*/

egen c=rownonmiss(jsfm - jsfl) if csclid==1&a>0&b!=1, strok
replace csclid=0 if csclid==1&a>0&b!=1&c==0

tab c
list if c!=0&c!=.   //people who say they are in clinical work but also not in clinical work, and have
					//not stated work hours but have responded to JS questions. Need to decided status.
gen cs_flag6=""
replace cs_flag6 = "cs_flag6" if c!=0 & c!=.
list if cs_flag6 == "cs_flag6"

*edit cs_flag6
*drop if id==41524 //form blank, no response
*replace csclid = 1 if id==69722 & csclid==1 //doing medical work, other cs items will be applied universal coding
					

drop a b c

egen a=rowtotal(cspret csncli csml cshd csstu csexl csocli csoncli csonmd csnmd)
tab a if csclid==0, m

replace csclid=1 if csclid==0&a==0&(pwtoh!=""|wlwh!="")
replace csclid=1 if csclid==0&a==0&(figey!=""|finey!=""|figef!=""|finef!="")
replace csclid=1 if csclid==0&a==0&wldph!=""

drop a


*********************************************************

*csrtn

*replace csrtn="0" if csrtn=="3" & response=="Online"

gen csrtn_comment=regexs(2) if regexm(csrtn, "^(.*)comment[:](.*)$")
replace csrtn=regexs(1) if regexm(csrtn, "^([0-9]) comment(.*)$")

replace csrtn="0" if csrtn=="3" & response=="Online"

destring csrtn, replace force

tab csrtn_comment if csrtn==.
list id dirall csclid csrtn csrtn_comment if csrtn==.&csrtn_comment!=""

replace csrtn=-3 if csclid==1&csrtn==.
replace csrtn=-3 if csclid==0&cspret==1&csrtn==.
replace csrtn=-2 if csrtn==.


*no comments of interest
*********************************************************

drop cs*_comment cspret_1 cspret_2 
drop cs_flag*

foreach x of var csclid cspret csncli csml cshd csstu csexl csocli csoncli csonmd csnmd csrtn {
*ab `x'
label var `x' 	"Cleaned"
}
*
