**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: clean the multiple choice variables in wave 9
********************************************************

global ddtah="D:\Data\Data Clean\Wave9\dtah"
global ddo="D:\Data\Data Clean\Wave9"
global dlog="D:\Data\Data Clean\Wave9\log"

capture log close
set more off

log using "${dlog}\var_mc.log", replace

***
*use "${ddtah}\temp_all.dta", clear
***


***hardcopy surveys***

*separate all mc variables for the value and text comments 

foreach x of var jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl jshp jsbc jssn jsto jspe jscp jsps jsuh jsas jssc jsred jsredt /// 
				 jssm jslq jsco jsfs jspu jsqs jsst jspt jsch jshe jswl jslj ///
				 pwpip pwcl pwacc pwni pwwh pwahnc pwpm pwbr pwoce pwsp ///
				 wlah wloo wlal wlhth wlspint wlante wlwom wlpsych wlskin wlchild wlsport wlotspe wlprop ///
				 fib fics fiefr fips /// 
				 gltps glfiw glbl glpfiw glgeo glacsc glrl ///
				 fclp fcpmd fcrwncc fcpwncc fcoq fcpes ///
				 piis picamc piqonr pigen pims pirs pilfsa pertj perct perrd peror perwo perfr perlz persoc perart pernev pereff perrsv /// 
				 perknd perimg perstr pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 ///
				 pifirisk picarisk piclrisk piin piinf pides pider pidef piviv pivpc pidmn /// 
				 piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl pimsp pisesp piste pires {
				 			 
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
*convert multiple choices for categorical variables, convert answers to *_multi variables
*added new wave 8 variables - tt 30/11/2015

foreach x of var jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl jshp jsbc jssn jsto jspe jscp jsps jsuh jsas jssc jsred jsredt /// 
				 jssm jslq jsco jsfs jspu jsqs jsst jspt jsch jshe jswl jslj ///
				 pwpip pwcl pwacc pwni pwwh pwahnc pwpm pwbr pwoce pwsp ///
				 wlah wloo wlal wlhth wlspint wlante wlwom wlpsych wlskin wlchild wlsport wlotspe wlprop ///
				 fib fics fiefr fips /// 
				 gltps glfiw glbl glpfiw glgeo glacsc glrl ///
				 fclp fcpmd fcrwncc fcpwncc fcoq fcpes ///
				 piis picamc piqonr pigen pims pirs pilfsa pertj perct perrd peror perwo perfr perlz persoc perart pernev pereff perrsv /// 
				 perknd perimg perstr pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 ///
				 pifirisk picarisk piclrisk piin piinf pides pider pidef piviv pivpc pidmn /// 
				 piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl pimsp pisesp piste pires  {
				 *jsfm - couldn't be included in w7 as there were no examples of multicode - replace in w8
				 
*Convert the multiple formar [#,#,#] to [_#_#_#]

replace `x'_comment =  regexs(1) + "_" + regexs(2) + "_" + regexs(3) + "_" + regexs(4) + "_"  if regexm(`x'_comment, "^([0-9]+)[,]([0-9]+)[,]([0-9]+)(.*)$")
replace `x'_comment =  regexs(1) + "_" + regexs(2) + "_" + regexs(3) +  "_" if regexm(`x'_comment, "^([0-9]+)[,]([0-9]+)(.*)$")

*Create *_multi variables for multiple answers for related variables, convert with multiple answers upto 4

replace `x' = regexs(1) if (regexm(`x'_comment, "^([0-9]+)_([0-9]+)_"))
gen `x'_multi1 = regexs(2) if (regexm(`x'_comment, "^([0-9]+)_([0-9]+)_"))
gen `x'_multi2 = regexs(3) if (regexm(`x'_comment, "^([0-9]+)_([0-9]+)_([0-9]+)_"))
gen `x'_multi3 = regexs(4) if (regexm(`x'_comment, "^([0-9]+)_([0-9]+)_([0-9]+)_([0-9]+)_"))
gen `x'_multi4 = regexs(5) if (regexm(`x'_comment, "^([0-9]+)_([0-9]+)_([0-9]+)_([0-9]+)_([0-9]+)_"))

replace `x'_comment=regexr(`x'_comment, "^([0-9]+)_([0-9]+)_([0-9]+)_([0-9]+)_([0-9]+)_$", "")
replace `x'_comment=regexr(`x'_comment, "^([0-9]+)_([0-9]+)_([0-9]+)_([0-9]+)_$", "")
replace `x'_comment=regexr(`x'_comment, "^([0-9]+)_([0-9]+)_([0-9]+)_$", "")
replace `x'_comment=regexr(`x'_comment, "^([0-9]+)_([0-9]+)_$", "")

*Convert "N/A" to missing value "-3"

replace `x'="-3" if (`x'_comment=="N/A"|`x'_comment=="NA"|`x'_comment=="Na"|`x'_comment=="na"| `x'_comment=="Not Applicable")&`x'==""

*Convert "Don't Know" to missing value "-4"

replace `x'="-4" if (`x'_comment=="Don'T Know"|`x'_comment=="Do Not Know"|`x'_comment=="Not Sure"|`x'_comment=="Unsure")&`x'==""

dis "Variable `x'"
}
*

gen mc_flag1=""
foreach x of var jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl jshp jsbc jssn jsto jspe jscp jsps jsuh jsas jssc jsred jsredt /// 
				 jssm jslq jsco jsfs jspu jsqs jsst jspt jsch jshe jswl jslj ///
				 pwpip pwcl pwacc pwni pwwh pwahnc pwpm pwbr pwoce pwsp ///
				 wlah wloo wlal wlhth wlspint wlante wlwom wlpsych wlskin wlchild wlsport wlotspe wlprop ///
				 fib fics fiefr fips /// 
				 gltps glfiw glbl glpfiw glgeo glacsc glrl ///
				 fclp fcpmd fcrwncc fcpwncc fcoq fcpes ///
				 piis picamc piqonr pigen pims pirs pilfsa pertj perct perrd peror perwo perfr perlz persoc perart pernev pereff perrsv /// 
				 perknd perimg perstr pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 ///
				 pifirisk picarisk piclrisk piin piinf pides pider pidef piviv pivpc pidmn /// 
				 piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl pimsp pisesp piste pires{
replace mc_flag1 = "mc_flag1" if `x'==""&`x'_comment!=""
list id `x'_comment if `x'==""&`x'_comment!="", clean
}				 
*
tab mc_flag1				 
preserve
tostring id, replace
keep if mc_flag1=="mc_flag1"
keep id sdtype dirall mc_flag1
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc1.xlsx", firstrow(variables) nolabel replace
restore

*mc_flag1 edits
replace	pwni	=	"-4"	if id ==	612	 //text probably, unable to determine
replace	fib	=	"-1"	if id ==	1842	 //cannot recall, considered not asked
replace	pwni	=	"-1"	if id ==	3153	 //do not know, considered not asked
replace	pires	=	"-1"	if id ==	3184	 //prior to medicine, considered not asked
replace	fclp	=	"1"	if id ==	4022	 //box was marked
replace	fcoq	=	"3"	if id ==	4022	 //box was marked
replace	fcpes	=	"3"	if id ==	4022	 //box was marked
replace	fcpwncc	=	"2"	if id ==	4022	 //box was marked
replace	fcrwncc	=	"0"	if id ==	4022	 //box was marked
replace	fib	=	"1"	if id ==	4022	 //box was marked
replace	fips	=	"0"	if id ==	4022	 //box was marked
replace	glacsc	=	"3"	if id ==	4022	 //box was marked
replace	glbl	=	"3"	if id ==	4022	 //box was marked
replace	glfiw	=	"1"	if id ==	4022	 //box was marked
replace	glgeo	=	"1"	if id ==	4022	 //box was marked
replace	glpfiw	=	"1"	if id ==	4022	 //box was marked
replace	glrl	=	"0"	if id ==	4022	 //box was marked
replace	gltps	=	"1"	if id ==	4022	 //box was marked
replace	picarisk	=	"3"	if id ==	4022	 //box was marked
replace	pidef	=	"0"	if id ==	4022	 //box was marked
replace	pider	=	"1"	if id ==	4022	 //there was a time
replace	pideshl	=	"-1"	if id ==	4022	 //stem was no
replace	pidmn	=	"0"	if id ==	4022	 //box was marked
replace	pidmnhl	=	"-1"	if id ==	4022	 //stem was no
replace	pifirisk	=	"3"	if id ==	4022	 //box was marked
replace	piin	=	"1"	if id ==	4022	 //there was a time
replace	piinf	=	"0"	if id ==	4022	 //box was marked
replace	piis	=	"1"	if id ==	4022	 //box was marked
replace	pilfsa	=	"8"	if id ==	4022	 //box was marked
replace	pimsp	=	"32"	if id ==	4022	 //box was marked
replace	piqonr	=	"1"	if id ==	4022	 //box was marked
replace	pires	=	"0"	if id ==	4022	 //box was marked
replace	pirs	=	"0"	if id ==	4022	 //box was marked
replace	pisesp	=	"34"	if id ==	4022	 //box was marked
replace	piviv	=	"0"	if id ==	4022	 //box was marked
replace	pivpc	=	"0"	if id ==	4022	 //box was marked
replace	pwcl	=	"1"	if id ==	4022	 //box was marked
replace	pwpm	=	"2"	if id ==	4022	 //box was marked
replace	wlhth	=	"2"	if id ==	4022	 //box was marked


*Convert the inconsistent multicode variables between online and hardcopy entries
*Variables: jsredt, pwpm, glrl, pwpip, pimsp, pisesp, piste and variables in personal life events section

*jsredt
replace jsredt="3" if jsredt=="4" & response=="Online"
replace jsredt="4" if jsredt=="5" & response=="Online"
replace jsredt="5" if jsredt=="6" & response=="Online"

*pwpm

replace pwpm="0" if pwpm_0=="1"&pwpm==""
replace pwpm="1" if pwpm_1=="1"&pwpm==""
replace pwpm="2" if pwpm_2=="1"&sdtype==2&pwpm==""
replace pwpm="3" if pwpm_3=="1"&pwpm==""
replace pwpm="4" if pwpm_4=="1"&pwpm==""
replace pwpm_text=pwpm_4 if pwpm_4!=""

list id dtimage pwpm* if pwpm=="*"|pwpm=="-4"
list id dtimage pwpm* if pwpm=="" & pwpm_comment!=""
list id dirall response pwpm if sdtype==1 & pwpm == "4" 

drop pwpm_0 pwpm_1 pwpm_2 pwpm_3 pwpm_4

*wlprop - new for wave 6
gen wlprop2= wlprop
*replace wlprop="0" if wlprop2=="1" & (response=="Online"|source=="Pilot")
replace wlprop="0" if wlprop2=="1" & response=="Online"
replace wlprop="1" if wlprop2=="2" & response=="Online"
replace wlprop="2" if wlprop2=="3" & response=="Online"
replace wlprop="3" if wlprop2=="4" & response=="Online"

list id dtimage wlprop wlprop_comment if wlprop_comment!=""

*mc_flag2
gen mc_flag2=""
replace mc_flag2="mc_flag2" if wlprop_comment!=""
tab mc_flag2				 
preserve
tostring id, replace
keep if mc_flag2=="mc_flag2"
keep id sdtype dirall wlprop wlprop_comment mc_flag2
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc2.xlsx", firstrow(variables) nolabel replace
restore

drop wlprop2

*glrl
replace glrl="1" if glrl==""&glrl_1=="1"
replace glrl="2" if glrl==""&glrl_2=="1"
replace glrl="0" if glrl==""&glrl_3=="1"

list id dtimage glrl glrl_comment if glrl_comment!=""
	*replace glrl_comment="" if id==15452
	
*mc_flag3

gen mc_flag3=""
replace mc_flag3="mc_flag3" if glrl_comment!=""
tab mc_flag3 sdtype
preserve
tostring id, replace
keep if mc_flag3=="mc_flag3"
keep id dirall sdtype glrl glrl_comment mc_flag3 mc_flag2 mc_flag1
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc3.xlsx", firstrow(variables) nolabel replace
restore

***
*Apply mc_flag3 edits
***
replace glrl = 	"1"	 if id == 	67232	 & glrl ==	""	//rural bond
replace glrl =	"0"  if id ==	26514 	 & glrl ==  ""
replace glrl = "1" if id==61746 & glrl=="" //Yes-Mrbs=Rrma rating
replace glrl = "0" if id==1001366 & glrl==""


list id dtimage glrl glrl_comment if glrl_comment!="" & glrl==""

replace glrl="1" if glrl_comment=="1_2_" | glrl_comment=="12"
replace glrl_1="1" if glrl_comment=="1_2_" | glrl_comment=="12"
replace glrl_2="1" if glrl_comment=="1_2_" | glrl_comment=="12"

drop glrl_1 glrl_2 glrl_3


*pwpip
list id dtimage pwpip pwpip_comment if pwpip_comment!=""

*mc_flag4
gen mc_flag4=""
replace mc_flag4="mc_flag4" if pwpip_comment!=""
tab mc_flag4
preserve
tostring id, replace
keep if mc_flag4=="mc_flag4"
keep id dirall sdtype pwpip pwpip_comment mc_flag4 mc_flag3 mc_flag2 mc_flag1
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc4.xlsx", firstrow(variables) nolabel replace
restore

***
*Apply mc_flag4 edits
***
replace pwpip="1" if id==32399 & pwpip==""
replace pwpip="1" if id==34823 & pwpip==""
replace pwpip="1" if id==1001061 & pwpip==""


list id dtimage pwpip pwpip_comment if pwpip_comment!="" & pwpip==""

gen mc_flag5 = ""
replace mc_flag5 = "mc_flag5" if pwpip_comment!="" & pwpip==""
tab mc_flag5
***
*Should have been mc_flag5 data extract, but no case
***

*check the relevance of any multi responses 
tab1 pwpip_multi1 pwpip_multi2 pwpip_multi3 

gen mc_flag6 = ""
replace mc_flag6 = "mc_flag6" if pwpip_multi1 != ""

preserve
tostring id, replace
keep if mc_flag6=="mc_flag6"
keep id dirall sdtype pwpip pwpip_comment pwpip_multi1 mc_flag6 mc_flag4 mc_flag3 mc_flag2 mc_flag1
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc6.xlsx", firstrow(variables) nolabel replace
restore

drop pwpip_multi1 pwpip_multi2 pwpip_multi3 

*jsas
replace jsas="0" if jsas=="5" & response=="Online"

********************************************************

*pimsp/pisesp

foreach x of var pimsp pisesp {
	foreach i of num 1/47 {
	*local j = `i' - 1
	replace `x'="`i'" if `x'==""&`x'_`i'=="1"
	drop `x'_`i'
	}	
}
*
list id sdtype pimsp pimsp_comment pisesp pisesp_comment if pimsp_comment!="" & pimsp==""
***
*Should have been mc_flag7 here, but only a few cases so do direct editing
***

replace pimsp="39" if id==41987 & pimsp==""
replace pimsp="47" if id==30686 & pimsp==""


destring pimsp, replace force
destring pisesp, replace force

replace pimsp=pimsp-1
replace pisesp=pisesp-1


*create crosswave version of pimsp and pisesp
rename pimsp pimsp6
rename pisesp pisesp6



foreach x of new pimsp pisesp  {
gen `x'x=.

replace `x'x = 0 if `x'6==0
replace `x'x = 1 if `x'6==1
replace `x'x = 4 if `x'6==2
replace `x'x = 5 if `x'6==3
replace `x'x = 6 if `x'6==4
replace `x'x = 7 if `x'6==5
replace `x'x = 8 if `x'6==6
replace `x'x = 2 if `x'6==7
replace `x'x = 3 if `x'6==8
replace `x'x = 9 if `x'6==9
replace `x'x = 11 if `x'6==10
replace `x'x = 12 if `x'6==11
replace `x'x = 13 if `x'6==12
replace `x'x = 15 if `x'6==13
replace `x'x = 16 if `x'6==14
replace `x'x = 17 if `x'6==15
replace `x'x = 19 if `x'6==16
replace `x'x = 20 if `x'6==17
replace `x'x = 42 if `x'6==18
replace `x'x = 21 if `x'6==19
replace `x'x = 22 if `x'6==20
replace `x'x = 23 if `x'6==21
replace `x'x = 24 if `x'6==22
replace `x'x = 25 if `x'6==23
replace `x'x = 26 if `x'6==24
replace `x'x = 27 if `x'6==25
replace `x'x = 42 if `x'6==26
replace `x'x = 28 if `x'6==27
replace `x'x = 29 if `x'6==28
replace `x'x = 31 if `x'6==29
replace `x'x = 10 if `x'6==30
replace `x'x = 32 if `x'6==31
replace `x'x = 33 if `x'6==32
replace `x'x = 34 if `x'6==33
replace `x'x = 35 if `x'6==34
replace `x'x = 14 if `x'6==35
replace `x'x = 42 if `x'6==36
replace `x'x = 41 if `x'6==37
replace `x'x = 18 if `x'6==38
replace `x'x = 36 if `x'6==39
replace `x'x = 37 if `x'6==40
replace `x'x = 30 if `x'6==41
replace `x'x = 38 if `x'6==42
replace `x'x = 39 if `x'6==43
replace `x'x = 42 if `x'6==44
replace `x'x = 40 if `x'6==45
replace `x'x = 42 if `x'6==46

label var `x'x "Cleaned"
}
*tab1 pimsp pisesp

*piste

/*gen piste_5 = ""*/ //this is to take into account that piste 5 has been dropped.
***Don't get this point. Check with Tammy. Temporarily commented out.

foreach i of num 1/22 {

replace piste="`i'" if piste==""&piste_`i'=="1"
drop piste_`i'

}
destring piste, replace

replace piste=piste+1 if response=="Hardcopy" & piste>=5

rename piste piste6 //new variable for wave 6 onwards due to new categories

tostring  piste6, replace
*need to also create jssc for wave 6 onwards
gen piste=""

replace piste="0" if piste6=="11"
replace piste="1" if piste6=="20"
replace piste="2" if piste6=="7"
replace piste="3" if piste6=="16"
replace piste="4" if piste6=="15"
replace piste="5" if piste6=="17"
replace piste="6" if piste6=="4"
replace piste="7" if piste6=="8"
replace piste="8" if piste6=="19"
replace piste="9" if piste6=="13"
replace piste="10" if piste6=="3"
replace piste="11" if piste6=="10"
replace piste="12" if piste6=="23"
replace piste="13" if piste6=="9"
replace piste="14" if piste6=="2"
replace piste="15" if piste6=="6"
replace piste="16" if piste6=="14"
replace piste="17" if piste6=="1"
replace piste="18" if piste6=="12"
replace piste="19" if piste6=="18"
replace piste="20" if piste6=="21"
replace piste="21" if piste6=="22"


*personal life events

foreach x in piin piinf pides pider pidef piviv pivpc pidmn {

replace `x'="0" if `x'=="1" & response=="Online"
replace `x'="1" if `x'=="2" & response=="Online"
	foreach i of num 1/4 {
	local j = `i' - 1
	replace `x'hl="`j'" if `x'hl==""&`x'hl_`i'=="1"
	drop `x'hl_`i'
	}
}
*

foreach x of var piin piinf pides pider pidef piviv pivpc pidmn  {
replace `x'="1" if `x'==""&(`x'hl=="0"|`x'hl=="1"|`x'hl=="2"|`x'hl=="3")&`x'==""
}
*
*sort dtimage
gen mc_flag7 = ""
foreach x of var piin piinf pides pider pidef piviv pivpc pidmn  {
replace mc_flag7 = "mc_flag7" if `x'!="1" & `x'hl!="" /*&dtimage!=""*/
list id `x' `x'_comment `x'hl `x'hl_comment if `x'!="1" & `x'hl!="" /*&dtimage!=""*/, clean
}
*
tab mc_flag7
tab mc_flag7 mc_flag1				 
preserve
tostring id, replace
keep if mc_flag7=="mc_flag7"
keep id sdtype dirall piin piinf pides pider pidef piviv pivpc pidmn piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl mc_flag7 mc_flag1
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc7.xlsx", firstrow(variables) nolabel replace
restore
*
***
*mc_flag7 edits
***
replace 	 pidef = 	"1"	 if id == 	57359	//box was marked
replace 	 pidmnhl = 	 ""	 if id == 	2355	//adjacency
replace 	 pivpchl = 	"2"	 if id == 	2355	//adjacency
*replace 	 piinhl = 	 ""	 if id == 	38010	//no response
*replace 	 piinhl = 	 ""	 if id == 	55014	//no response
replace 	 piinfhl = 	 ""	 if id == 	39601	//box was crossed out
replace 	 piderhl = 	"3"	 if id == 	4022	//box was marked
replace 	 piinhl = 	"3"	 if id == 	4022	//box was marked
*replace 	 pidmnhl = 	 ""	 if id == 	32990	//box was not marked
replace 	 pivpchl = 	 ""	 if id == 	32990	//time out of range
replace 	 pivpc = 	"0"	 if id == 	32990	//time out of range
replace 	 piinhl = 	 ""	 if id == 	32990	//time out of range
replace 	 piin = 	"0"	 if id == 	32990	//time out of range
replace 	 piderhl = 	 ""	 if id == 	33209	//box was crossed out
replace 	 piinf = 	"1"	 if id == 	1000685	//more likely yes
replace 	 piinfhl = 	 ""	 if id == 	1001365	 //box was crossed out
replace 	 piinf = 	"1"	 if id == 	1001132	//quarter present
replace 	 piinhl = 	 ""	 if id == 	1001132	//box was crossed out
replace 	 pidefhl = 	"1"	 if id == 	23123	//adjacency
replace 	 piderhl = 	 ""	 if id == 	23123	//adjacency
replace 	 pidefhl = 	"-1"	 if id == 	10949	//considered not asked
replace 	 pider = 	"1"	 if id == 	10949	//quarter present



foreach x of var piin piinf pides pider pidef piviv pivpc pidmn  {
tab1 `x'hl
}
*

*Variables with options "Yes" and "No"    

*changed below for wave 7 - 12/2/2015
foreach x of var pwcl pwacc pwni pwwh wlah fib fclp pwahnc gltps wlspint pires fics{
*replace `x'="0" if `x'=="2" & (response=="Online"|source=="Pilot")
replace `x'="0" if `x'=="2" & response=="Online"
list id dtimage `x' `x'_comment if `x'_comment!="" &`x'==""
tab `x',m
}
*

replace pwacc="1" if id==64634
replace pwacc="0" if id==15873
replace pwacc="-3" if id==72455
replace pwni="-4" if pwni_comment!="" & pwni==""
replace wlah="1" if id==15787
replace gltps="1" if id==26514
replace pires="0" if id==14387
replace pires="0" if id==18354
replace pires="0" if id==20936
replace pires="0" if id==26514
replace pires="1" if id==43461
replace pires="0" if id==1001985


	*replace pwcl_comment="" if id==51722|id==54415|id==28764


*wlspint
*pwacc
*pwni*
*wlah
*fib
*flcp
*pwahnc
*gltps
*pires


*replace wlante="1" if wlspmain=="1" & (response=="Online"|source=="Pilot")
replace wlante="1" if wlspmain=="1" & response=="Online"
replace wlwom="1" if wlspmain=="2" & response=="Online"
replace wlpsych="1" if wlspmain=="3" & response=="Online"
replace wlskin="1" if wlspmain=="4" & response=="Online"
replace wlchild="1" if wlspmain=="5" & response=="Online"
replace wlsport="1" if wlspmain=="6" & response=="Online"
replace wlotspe="1" if wlspmain=="7" & response=="Online"

destring wlante wlwom wlpsych wlskin wlchild wlsport wlotspe, replace
egen a = anycount(wlante wlwom wlpsych wlskin wlchild wlsport wlotspe), values(1)

foreach x in wlante wlwom wlpsych wlskin wlchild wlsport wlotspe {
replace `x'=0 if `x'==. & a!=0 & response=="Online"
*replace `x'=0 if `x'==. & a!=0 & (response=="Online"|source=="Pilot")
}
*
tostring wlante wlwom wlpsych wlskin wlchild wlsport wlotspe, replace
drop wlspmain a


*changed below for wave 7 - 12/2/2015
*variables with options "Yes", "No" and "not applicable" or "unsure"
foreach x of var fcpmd piis picamc piqonr{
gen `x'2=`x'
*replace `x'="0" if `x'2=="2" & (response=="Online"|source=="Pilot")
replace `x'="0" if `x'2=="2" & response=="Online"
replace `x'="2" if `x'2=="3" & response=="Online"
list id dirall `x' `x'_comment if `x'_comment!="" &`x'==""
drop `x'2
}
*
replace fcpmd="1" if id==1002867


*changed all the following for Wave 7 12/2/15
replace pwoce = wloo if sdtype==2
replace pwoce_comment = wloo_comment if sdtype==2
drop wloo wloo_comment

list id dtimage pwoce_comment pwoce if pwoce_comment!=""

***
*mc_flag8 should have been created, but too few observations so did direct editing
***
replace pwoce="2" if id==4022 & pwoce==""

foreach x of var pwbr pwoce wlal fips fcpes pigen  pirs wlhth jsfm - jsfl jshp jsbc jssn ///
					jsto jspe jscp jsps jsuh jssm jslq jsco jsfs jspu jsqs jsst jspt ///
					jshe jswl jslj ///
					 fcrwncc fcpwncc fcoq jsch pwpip pwsp glfiw glbl glpfiw glgeo glacsc{
gen `x'2=`x'
foreach i of num 1/23 {	
	local j = `i' - 1	
	*replace `x'="`j'" if `x'2=="`i'" & (response=="Online"|source=="Pilot") & `x'2!=""
	replace `x'="`j'" if `x'2=="`i'" & response=="Online" & `x'2!=""
	}
	*tab `x' `x'2 if (response=="Online"|source=="Pilot")
	tab `x' `x'2 if response=="Online"
	drop `x'2
	list id dirall `x' `x'_comment if `x'_comment!="" &`x'==""
}
*
gen mc_flag9=""
foreach x of var pwbr pwoce wlal fips fcpes pigen  pirs wlhth jsfm - jsfl jshp jsbc jssn ///
					jsto jspe jscp jsps jsuh jssm jslq jsco jsfs jspu jsqs jsst jspt ///
					jshe jswl jslj ///
					 fcrwncc fcpwncc fcoq jsch pwpip pwsp glfiw glbl glpfiw glgeo glacsc{
gen `x'2=`x'
foreach i of num 1/23 {	
	local j = `i' - 1	
	*replace `x'="`j'" if `x'2=="`i'" & (response=="Online"|source=="Pilot") & `x'2!=""
	replace `x'="`j'" if `x'2=="`i'" & response=="Online" & `x'2!=""
	}
	*tab `x' `x'2 if (response=="Online"|source=="Pilot")
	tab `x' `x'2 if response=="Online"
	drop `x'2
	list id dirall `x' `x'_comment if `x'_comment!="" &`x'==""
	replace mc_flag9="mc_flag9" if `x'_comment!="" &`x'==""
}
*
tab mc_flag9

preserve
tostring id, replace
keep if mc_flag9=="mc_flag9"
keep id sdtype response dirall pwbr pwoce wlal fips fcpes pigen  pirs wlhth jsfm - jsfl jshp jsbc jssn ///
					jsto jspe jscp jsps jsuh jssm jslq jsco jsfs jspu jsqs jsst jspt ///
					jshe jswl jslj ///
					 fcrwncc fcpwncc fcoq jsch pwpip pwsp glfiw glbl glpfiw glgeo glacsc
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc9.xlsx", firstrow(variables) nolabel replace
restore

***
*mc_flag9 edits
***
replace fips= "-4" if id==5798 //confidential
replace glacsc="5" if id==15873 //NA
replace fips="-4" if id==22427 //insist not wish to receive further surveys
replace	fcoq	= "5"	if id==26514
replace	fcpes	= "4"	if id==26514
replace	fcpwncc	= "5"	if id==26514
replace	fcrwncc	= "5"	if id==26514
replace	glacsc	= "5"	if id==26514
replace	glbl	= "3"	if id==26514
replace	glfiw	= "2"	if id==26514
replace	glgeo	= "5"	if id==26514
replace	glpfiw	= "5"	if id==26514
replace	wlhth	= "2"	if id==26514
replace pirs	= "0"	if id==26514
replace fips="-4" if id==32407 //private
replace fips="5" if id==35113 //I'm a locum for another specialist
replace wlhth="-4" if id==35113
replace fips="-4" if id==38745 //private
replace glacsc="5" if id==57956
replace pirs="-4" if id==58039 //New Zealand, made a recommendation
replace	jsfm	 ="-1" if id==58039
replace	jsva	 ="-1" if id==58039
replace	jspw	 ="-1" if id==58039
replace	jsau	 ="-1" if id==58039
replace	jscw	 ="-1" if id==58039
replace	jsrc	 ="-1" if id==58039
replace	jshw	 ="-1" if id==58039
replace	jswr	 ="-1" if id==58039
replace	jsrp	 ="-1" if id==58039
replace	jsfl	 ="-1" if id==58039
replace	jshp	 ="-1" if id==58039
replace	jsbc	 ="-1" if id==58039
replace	jssn	 ="-1" if id==58039
replace	jsto	 ="-1" if id==58039
replace	jshe	 ="-1" if id==58039
replace	jspe	 ="-1" if id==58039
replace	jscp	 ="-1" if id==58039
replace	jsps	 ="-1" if id==58039
replace	jsuh	 ="-1" if id==58039
replace	jssm	 ="-1" if id==58039
replace	jslq	 ="-1" if id==58039
replace	jsco	 ="-1" if id==58039
replace	jsfs	 ="-1" if id==58039
replace	jswl	 ="-1" if id==58039
replace	jslj	 ="-1" if id==58039
replace	jsch	 ="-1" if id==58039
replace pwsp="5" if id==62034
replace pirs="-4" if id==68455 //New Zealand
replace pwsp="-4" if id==69080
replace fips="5" if id==79717
replace pwbr="5" if id==84907
replace pirs="-1" if id==84907
replace wlhth="-1" if id==84907
replace pwsp="-4" if id==1000953
replace glpfiw="5" if id==1001522
replace glgeo="5" if id==1001522
replace jsch="-4" if id==1001874
replace pwbr="5" if id==1001874


foreach x of var pwbr pwoce wlal fips fcpes pigen  pirs wlhth jsfm - jsfl jshp jsbc jssn ///
					jsto jspe jscp jsps jsuh jssm jslq jsco jsfs jspu jsqs jsst jspt ///
					jshe jswl jslj ///
					glfiw glbl glpfiw glgeo glacsc fcrwncc fcpwncc fcoq jsch pwsp jssc {
list id dirall `x' `x'_comment if `x'_comment!="" &`x'==""
}
*
replace jssc="-4" if id==69118
	
*changed for 2015 (with qualtrics)
*PIMS (medical school in Australia) - changed below for W7
*replace pims="0" if (pims=="1"|pims=="2") &(response=="Online"|source=="Pilot")
replace pims="0" if (pims=="1"|pims=="2") & response=="Online"
replace pims="1" if (pims=="15") & response=="Online"
replace pims="2" if (pims=="3") & response=="Online"
replace pims="3" if (pims=="16") & response=="Online"
replace pims="4" if (pims=="4") & response=="Online"
replace pims="5" if (pims=="17") & response=="Online"
replace pims="6" if (pims=="5") & response=="Online"
replace pims="7" if (pims=="18") & response=="Online"
replace pims="8" if (pims=="6") & response=="Online"
replace pims="9" if (pims=="19") & response=="Online"
replace pims="10" if (pims=="7") & response=="Online"
replace pims="11" if (pims=="20") & response=="Online"
replace pims="12" if (pims=="8") & response=="Online"
replace pims="13" if (pims=="21") & response=="Online"
replace pims="14" if (pims=="9") & response=="Online"
replace pims="15" if (pims=="22") & response=="Online"
replace pims="16" if (pims=="10") & response=="Online"
replace pims="17" if (pims=="23") & response=="Online"
replace pims="18" if (pims=="11") & response=="Online"
replace pims="19" if (pims=="24") & response=="Online"
replace pims="20" if (pims=="12") & response=="Online"
replace pims="21" if (pims=="25") & response=="Online"
replace pims="22" if (pims=="13") & response=="Online"
replace pims="23" if (pims=="14") & response=="Online"

*The specialist training course you have been accepted into/are waiting to commence

*gen jssc=""
replace jssc="0" if jssapna == "1" & jssc==""
replace jssc="1" if jssaddi =="1" & jssc==""
replace jssc="2" if jssapan =="1" & jssc==""
replace jssc="3" if jssapde =="1" & jssc==""
replace jssc="4" if jssapem =="1" & jssc==""
replace jssc="5" if jssapgp =="1" & jssc==""
replace jssc="6" if jssapic =="1" & jssc==""
replace jssc="7" if jssapma =="1" & jssc==""
replace jssc="8" if jssapog =="1" & jssc==""
replace jssc="9" if jssapom =="1" & jssc==""
replace jssc="10" if jssapop =="1" & jssc==""
replace jssc="11" if jssappc =="1" & jssc==""
replace jssc="12" if jssapai =="1" & jssc==""
replace jssc="13" if jssappm =="1" & jssc==""
replace jssc="14" if jssappa =="1" & jssc==""
replace jssc="15" if jssaphy =="1" & jssc==""
replace jssc="16" if jssapps =="1" & jssc==""
replace jssc="17" if jssapph =="1" & jssc==""
replace jssc="18" if jssapon =="1" & jssc==""
replace jssc="19" if jssapra=="1" & jssc==""
replace jssc="20" if jssaprm=="1" & jssc==""
replace jssc="21" if jssashm=="1" & jssc==""
replace jssc="22" if jssaspo=="1" & jssc==""
replace jssc="23" if jssapsu=="1" & jssc==""


rename jssc jssc6  //new variable for wave 6 onwards due to new categories

*need to also create jssc for wave 6


gen jssc=jssc6
replace jssc="0" if jssc6=="0" 
replace jssc="1" if jssc6=="11"
replace jssc="2" if jssc6=="13" 
replace jssc="3" if jssc6=="20" 
replace jssc="4" if jssc6=="3" 
replace jssc="5" if jssc6=="5" 
replace jssc="6" if jssc6=="7" 
replace jssc="7" if jssc6=="10"
replace jssc="8" if jssc6=="16" 
replace jssc="9" if jssc6=="23" 
replace jssc="10" if jssc6=="15" 
replace jssc="11" if jssc6=="9" 
replace jssc="12" if jssc6=="17" 
replace jssc="13" if jssc6=="2" 
replace jssc="14" if jssc6=="4" 
replace jssc="15" if jssc6=="6" 
replace jssc="16" if jssc6=="8" 
replace jssc="17" if jssc6=="14" 
replace jssc="18" if jssc6=="19" 
replace jssc="19" if jssc6=="1" 
replace jssc="20" if jssc6=="12" 
replace jssc="21" if jssc6=="18" 
replace jssc="22" if jssc6=="21" 
replace jssc="23" if jssc6=="22" 

drop jssapna-jssapsu




foreach x of var jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl jshp jsbc jssn jsto jshe jspe jscp jsps jsuh /// 
				 jssm jslq jswl jslj jsco jsfs jspu jsqs jsst jspt jsch jsred jsredt pwcl pwacc pwni pwwh wlah fib fclp pwahnc gltps ///
				 fcpmd piis picamc piqonr pwbr pwoce wlal fips fiefr fics glfiw glbl glpfiw glgeo glacsc fcrwncc fcpwncc fcoq fcpes /// 
				 pigen pims pirs wlhth pilfsa pertj perct perrd peror perwo perfr perlz persoc perart pernev pereff perrsv /// 
				 perknd perimg perstr pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 ///
				 piin piinf pides pider pidef piviv pivpc pidmn /// 
				 piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl pwpip pwsp jsas jssc piste   pwpm glrl  ///
				 wlspint wlante	wlwom wlpsych wlskin wlchild wlsport wlotspe wlprop pifirisk picarisk piclrisk pires {

dis "Variable `x'"
list dirall id `x'_comment if `x'==""&`x'_comment!="" & (mc_flag1 == "" | mc_flag2 == "" | mc_flag3 == "" | mc_flag4 == "" | mc_flag5 == "" | mc_flag6 == "" | mc_flag7 == "" | mc_flag9 == "")
*destring `x', replace
*label var `x' 		"Cleaned"
}
*

gen mc_flag10 = ""
foreach x of var jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl jshp jsbc jssn jsto jshe jspe jscp jsps jsuh /// 
				 jssm jslq jswl jslj jsco jsfs jspu jsqs jsst jspt jsch jsred jsredt pwcl pwacc pwni pwwh wlah fib fclp pwahnc gltps ///
				 fcpmd piis picamc piqonr pwbr pwoce wlal fips fiefr fics glfiw glbl glpfiw glgeo glacsc fcrwncc fcpwncc fcoq fcpes /// 
				 pigen pims pirs wlhth pilfsa pertj perct perrd peror perwo perfr perlz persoc perart pernev pereff perrsv /// 
				 perknd perimg perstr pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 ///
				 piin piinf pides pider pidef piviv pivpc pidmn /// 
				 piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl pwpip pwsp jsas jssc piste   pwpm glrl  ///
				 wlspint wlante	wlwom wlpsych wlskin wlchild wlsport wlotspe wlprop pifirisk picarisk piclrisk pires {

replace mc_flag10 = "mc_flag10" if `x'==""&`x'_comment!="" & (mc_flag1 == "" | mc_flag2 == "" | mc_flag3 == "" | mc_flag4 == "" | mc_flag5 == "" | mc_flag6 == "" | mc_flag7 == "" | mc_flag9 == "")
}
*
tab mc_flag10

preserve
tostring id, replace
keep if mc_flag10=="mc_flag10"
keep id sdtype response dirall jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl jshp jsbc jssn jsto jshe jspe jscp jsps jsuh /// 
				 jssm jslq jswl jslj jsco jsfs jspu jsqs jsst jspt jsch jsred jsredt pwcl pwacc pwni pwwh wlah fib fclp pwahnc gltps ///
				 fcpmd piis picamc piqonr pwbr pwoce wlal fips fiefr fics glfiw glbl glpfiw glgeo glacsc fcrwncc fcpwncc fcoq fcpes /// 
				 pigen pims pirs wlhth pilfsa pertj perct perrd peror perwo perfr perlz persoc perart pernev pereff perrsv /// 
				 perknd perimg perstr pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 ///
				 piin piinf pides pider pidef piviv pivpc pidmn /// 
				 piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl pwpip pwsp jsas jssc piste   pwpm glrl  ///
				 wlspint wlante	wlwom wlpsych wlskin wlchild wlsport wlotspe wlprop pifirisk picarisk piclrisk pires
export excel using "D:\Data\Data clean\Wave9\extracts\var_mc\var_mc10.xlsx", firstrow(variables) nolabel replace
restore

***
*mc_flag10 edits
***
*Up to this point we can apply automatic/universal coding scheme. Will see how it goes, if not then return to edit manually.

destring jssc6 piste6, replace
label  var jssc6 "Cleaned"
label var piste6 "Cleaned"
label  var pimsp6 "Cleaned"
label var pisesp6 "Cleaned"

*****************************************************************

*Additional cleaning in this section for variables: pirps 
*this is for variables where doc has to type 'yes' or 'no'

foreach x of var pirps {
ren `x' `x'_comment
replace `x'_comment = upper(`x'_comment)
gen `x'=1 if `x'_comment=="YES"
replace `x'=0 if `x'_comment=="NO"
replace `x'=-3 if `x'_comment=="NA"|`x'_comment=="N/A"
label var `x' 		"Cleaned"
}
*

compress
****************************************************************

*All look good, except for among online GPs
*pwacc==3 (7 cases)
*pwni==3 (99 cases)
