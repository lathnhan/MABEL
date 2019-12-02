
*Purpose: clean the check box variables in wave 9


********************************************************
global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

capture log close
set more off

log using "${dlog}\var_checkbox.log", replace

********************************************************

*use "${ddtah}\temp_all.dta_Tammy", clear

********************************************************

*Check box variables have three categories (First section excluded):
*Don't Know: jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk 
*Not Applicable: jsbsna jsmena wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocrnapb wlocrnapv wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana ///
*  				 fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna
*Other: wltms wlttr wltrg wltnt wlana wlobs wlsur wleme wlnon wlnt glrlpv glrltv glrlrs glrlrp glrlot fcccrf fcccn fccccw fcccdc picmda picmdo ///
*				 pipqno pisappc pisappm pisaprm pisapde pisapma pisapop pisapps pisapsu pisapim pisapom pisapph pisapan pisapem pisapic pisapog /// 
* 				 pisappa pisapra  

foreach x of var jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk  jsmena wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv /// 
				 wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna ///
				 wltms wlttr wltrg wltnt wlva wlana wlobs wlsur wleme wlnon wlnt glrlpv glrltv glrlrs glrlrp glrlot fcccrf fcccn fccccw /// 
				 fcccdc picmda picmdo pisaddi pisapon pisashm pisaspo pisappc pisappm pisaprm pisapde pisapma pisapop pisapps pisapsu pisapom pisapph ///
				 pisapan pisapem pisapgp pisapic pisapog pisappa pisapra pifyrna pisapai pisapim   ///
				 pimrgen pimrspe pimrpro pimrlim pimrnon ///
				 wlacto wlactc wlactn {   //new for wave 7
* removed jsbsna  pisapim in wave 6
gen `x'_comment = regexs(2) if regexm(`x', "^(.*)comment[:](.*)$")
replace `x' = regexs(1) if regexm(`x', "(.*)comment[:](.*)$")
replace `x' = trim(`x')
replace `x'_comment = trim(`x'_comment)
replace `x'_comment = proper(`x'_comment)
replace `x'="" if `x'=="."
replace `x'=itrim(`x')
replace `x'=trim(`x')
replace `x'=proper(`x')
tab `x'
}
*

*add in the online dk and na
replace wlnt="1" if wlwd_tick=="3"
replace wlna="1" if wlwd_tick=="4"
* wlva_tick - nothing to convert
* wlvau_tick - nothing to convert
* wlvadk - same for online and hc (but online never has the value 0)
* wlvana - same for online and hc (but online never has the value 0)
replace fimedk="1" if fidme_tick=="2"
replace fidpdk="1" if fidp_tick=="2"
replace fidpna="1" if fidp_tick=="3"
*pifayr_tick - nothing to convert
*pifryr_tick - nothing to convert
*pifyrna - same for online and hc (but online never has the value 0)
*glrtw_tick - nothing to convert
*glrst_tick - nothing to convert
*glrna - same for online and hc (but online never has the value 0)
replace fcpr_dk="1" if fcpr_tick=="2"
replace fcpr_na="1" if fcpr_tick=="3"
*fcprt_tick - nothing to convert
*fcprs_tick - nothing to convert
replace picmda="1" if picmda_tick=="1"
replace picmdo="1" if picmda_tick=="2"
*wlcnpmin - nothing to convert
*wlcsmin - nothing to convert
*wlcna - same for online and hc (but online never has the value 0)
replace wlbpna = "1" if  wlbbp_tick=="2"
replace jsbsdk="1" if jsbsyr_tick=="2"
replace wlocna="1" if wlocr_tick=="2"

*Convert the check box with DK

foreach x of var jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk {
list id /*dirall*/ `x' `x'_comment if `x'_comment!=""
}
*
gen cb_flag1=""
foreach x of var jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk {
replace cb_flag1="cb_flag1" if `x'_comment!=""
}
*
preserve
keep if cb_flag1=="cb_flag1"
keep id sdtype dirall jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk jsbsdk_comment wlvadk_comment fimedk_comment fidpdk_comment fcpr_dk_comment fcprt_dk_comment cb_flag1 
sort id
export excel using "D:\Data\Data clean\Wave9\extracts\var_cb\var_cb1.xlsx", firstrow(variables) nolabel replace
restore

*cb_flag1 edits
replace fidme = 	"0"	if id ==	11085	& fidme ==	 ""	//Nil
replace wlvana =	"1"	 if id == 	5591	& wlvana ==	"0"	//not applicable
replace fidme =	"0"	 if id == 	32990	& fidme==	"NIL"	
replace fimedk = 	"0"	 if id == 	33681	 & fimedk ==	"1"	//amount given
replace fidme =	"0"	 if id == 	72825	& fidme ==	"NIL"	


list fidme fimedk fimedk_comment dirall id sdtype if fimedk_comment!="" 
gen cb_flag2=""
replace cb_flag2="cb_flag2" if fimedk_comment!="" 

***
*cb_flag2 data extract should have been here, but only 1 case so direct edit
replace fimedk="0" if id==4022 & fimedk==""
***
	
list fidp fidpdk fidpdk_comment fidpna fidpna_comment id /*dirall*/ if fidpna_comment!=""|fidpdk_comment!=""
gen cb_flag3=""
replace cb_flag3="cb_flag3" if fidpna_comment!=""|fidpdk_comment!=""

***
*cb_flag3 data extract should have been here, but only 1 case so direct edit
*cb_flag3 edits
replace fidpdk="0" if id==4022 & fidpdk==""
replace fidpna="0" if id==4022 & fidpna==""
***
	
tab1 jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk

*********************************************************************************

*Convert the check box with NA

foreach x of var   jsmena wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana ///
  				 fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna pifyrna wlnt {
replace `x'="1" if `x'=="N/A"|`x'=="Na"|`x'=="NA"|`x'=="na"|`x'=="N A"|`x'=="nA"|strmatch(`x',"N/A*")|`x'=="Not Applicable"
replace `x'="1" if strmatch(`x',"No Appicable")|strmatch(`x',"N-A")
replace `x'="1" if `x'=="N?A"|`x'=="Nil"|`x'=="N??A"
replace `x'="1" if `x'_comment=="N/A"|`x'=="Na"|`x'=="NA"|`x'=="na"|`x'=="N A"|`x'=="nA"|strmatch(`x',"N/A*")|`x'=="Not Applicable"
replace `x'="1" if `x'_comment=="N?A"|`x'=="Nil"|`x'=="N??A"
replace `x'_comment=regexs(1) if regexm(`x', "^Na - (.*)$")
replace `x'="1" if regexm(`x', "^Na - (.*)$")|strmatch(`x',"Na*")|`x'=="N\A"|`x'=="An"
tab `x'
}
*
foreach x of var   jsmena wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana ///
  				 fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna pifyrna wlnt {
tab `x'				 
}
*

list id dirall wlwd wlww wlnt wlna if wlna!="" & wlna!="1"& wlna!="0"
	*none identified
	
list id sdtype dirall  wlwd wlww wlnt wlna wlna_comment if wlna_comment!="" 
***
*cb_flag4 should have been here, but only 1 case identified so do direct editing
*cb_flag4 edits
replace wlwd="7" if id==4022 & wlwd==""
***
	
list id dirall wlcna wlcna_comment if wlcna_comment!=""
***
*cb_flag5 should have been here, but only 1 case identified so do direct editing
replace wlcna="1" if id==34795 & wlcna=="0"
***

list id dirall wlcnpmin wlcsmin wlcna if wlcna!=""&wlcna!="1"&wlcna!="0"
	*none identified
	
replace wlcna = "1" if wlcna=="An"|wlcna=="Ba"|wlcna=="Nz"

list id response /*wlcnpf wlcsf wlcfna wlcfna_comment*/ if (wlcfna!="0"&wlcfna!="1"&wlcfna!="")|wlcfna_comment!=""
gen cb_flag6=""
replace cb_flag5="cb_flag5" if (wlcfna!="0"&wlcfna!="1"&wlcfna!="")|wlcfna_comment!=""
tab cb_flag6 response

preserve
keep if cb_flag6=="cb_flag6"
keep id sdtype dirall wlcnpf wlcsf wlcfna wlcfna_comment cb_flag6 cb_flag5 cb_flag1
sort id
export excel using "D:\Data\Data clean\Wave9\extracts\var_cb\var_cb5.xlsx", firstrow(variables) nolabel replace
restore

*cb_flag6 edits
replace wlcfna = 	"1"	 if id == 	4022	 & wlcfna ==	"0"	
replace wlcsf = 	"153"	 if id == 	26012	 & wlcsf ==	"$153 IF BULK BILLED OR $203 IF NOT"	
replace wlcnpf = 	"200"	 if id == 	26012	 & wlcnpf ==	"200 BULK BILLED"                                 	
replace wlcsf = 	"0"	 if id == 	27965	 & wlcsf ==	"BILLED TO MEDICARE 0"              	
replace wlcfna = 	"0"	 if id == 	32915	 & wlcfna ==	"1"	//Only On Other Practice                                          
replace wlcfna = 	"1"	 if id == 	34795	 & wlcfna ==	"0"	//Na                                                                                 
replace wlcnpf = 	"0"	 if id == 	38419	 & wlcnpf ==	"0 WRITE 0 IF YOU BULK BILL 100% OF YOUR PATIENTS"	
replace wlcfna = 	"1"	 if id == 	41202	 & wlcfna ==	"0"	//Na
replace wlcnpf = 	"0"	 if id == 	54221	 & wlcnpf ==	"BULK BILLED"	
replace wlcsf = 	"0"	 if id == 	54221	 & wlcsf ==	 ""	
replace wlcnpf = 	"128"	 if id == 	68609	 & wlcnpf ==	"128 ROPP BULK BILL"
*

replace wlcfna_comment=wlcfna if wlcfna!=""&wlcfna!="1"&wlcfna!="0"
replace wlcfna="1" if wlcfna_comment=="- Na"
replace wlcfna_comment = wlcfna if wlcfna!="" & wlcfna!="1" & wlcfna!="0" & wlcfna_comment==""
replace wlcfna="0" if wlcfna!=""&wlcfna!="1"&wlcfna!="0"

list id dirall wlbbp wlbpna wlbpna_comment if (wlbpna!="0"&wlbpna!="1"&wlbpna!="")|wlbpna_comment!=""
gen cb_flag7=""
replace cb_flag7="cb_flag7" if (wlbpna!="0"&wlbpna!="1"&wlbpna!="")|wlbpna_comment!=""
preserve
keep if cb_flag7=="cb_flag7"
keep id sdtype dirall wlbbp wlbpna wlbpna_comment cb_flag7 cb_flag6 cb_flag1
sort id
export excel using "D:\Data\Data clean\Wave9\extracts\var_cb\var_cb7.xlsx", firstrow(variables) nolabel replace
restore
tab cb_flag7 

*cb_flag7 edits
replace wlbbp = 	"100"	 if id == 	26512	 & wlbbp ==	"100 BULK BILLED"     	
replace wlbpna = 	"0"	 if id == 	32915	 & wlbpna ==	"1"	
replace wlbpna = 	"-1"	 if id == 	34072	 & wlbpna ==	"0"	//don't know, considered not asked
replace wlbbp = 	"-1"	 if id == 	34072	 & wlbbp ==	 ""	//don't know, considered not asked
replace wlbpna = 	"1"	 if id == 	34795	 & wlbpna ==	"0"	
replace wlbbp = 	"-1"	 if id == 	34795	 & wlbbp ==	 ""	
replace wlbbp = 	"100"	 if id == 	43105	 & wlbbp ==	"100 PRIVATE HOSPITAL"	
replace wlbpna = 	"0"	 if id == 	66878	 & wlbpna ==	"1"	//box not ticked
replace wlbbp = 	"-1"	 if id == 	68763	 & wlbbp ==	"PRACTICE CHARGES"	

*on call - not applicable
*online has comment in `x', hardcopy has comment in `x'_comment

foreach x of var wlocnapb wlocnapv wlcotnapb wlcotnapv wlocrnap wlocrnah wlcotnap wlcotnah wlocna {
list id sdtype response /*dtimage*/ `x' `x'_comment wlocoth if (`x'!=""& `x'!="0" & `x'!="1") | `x'_comment!=""
*list id /*dtimage*/ `x' `x'_comment wlocoth if `x'_comment!=""
}
*
gen cb_flag8=""
foreach x of var wlocnapb wlocnapv wlcotnapb wlcotnapv wlocrnap wlocrnah wlcotnap wlcotnah wlocna {
replace cb_flag8="cb_flag8" if (`x'!=""& `x'!="0" & `x'!="1") | `x'_comment!=""
}
*
preserve
keep if cb_flag8=="cb_flag8" & response=="Hardcopy"
keep id sdtype dirall wlocnapb wlocnapv wlcotnapb wlcotnapv wlocrnap wlocrnah wlcotnap wlcotnah wlocna cb_flag8 cb_flag1
export excel using "D:\Data\Data clean\Wave9\extracts\var_cb\var_cb8.xlsx", firstrow(variables) nolabel replace
restore
tab cb_flag8 response

*cb_flag8 edits
replace wlocnapv = 	"0"	 if id == 	1664	 & wlocnapv ==	"All The Time For My Patients Only"
replace wlocnapb = 	"0"	 if id == 	4022	 & wlocnapb ==	""
replace wlocnapv = 	"0"	 if id == 	4022	 & wlocnapv ==	""
replace wlcotnapb = 	"0"	 if id == 	4022	 & wlcotnapb ==	""
replace wlcotnapv = 	"0"	 if id == 	4022	 & wlcotnapv ==	""
replace wlcotnap = 	"0"	 if id == 	21483	 & wlcotnap ==	""
replace wlcotnapv = 	"0"	 if id == 	27482	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	27831	 & wlcotnapv ==	""
replace wlcotnapb = 	"0"	 if id == 	31308	 & wlcotnapb ==	"1"
replace wlcotnapv = 	"0"	 if id == 	31308	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	32927	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	34067	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	34857	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	36368	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	37870	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	38607	 & wlcotnapv ==	""
replace wlocnapv = 	"0"	 if id == 	39026	 & wlocnapv ==	"0%"
replace wlcotnapv = 	"0"	 if id == 	39026	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	41085	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	41791	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	49908	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	54866	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	55014	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	55256	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	56263	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	58891	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	64810	 & wlcotnapv ==	""
replace wlcotnapv = 	"0"	 if id == 	66878	 & wlcotnapv ==	""
replace wlocnapb = 	"0"	 if id == 	71203	 & wlocnapb ==	"Weekly Oncall Every 3Months"
replace wlcotnapv = 	"0"	 if id == 	1000635	 & wlcotnapv ==	""
replace wlcotnapv = 	"1"	 if id == 	33005	 & wlcotnapv ==	""
replace wlocnapb = 	"1"	 if id == 	35565	 & wlocnapb ==	"0"
replace wlocnapv = 	"1"	 if id == 	35565	 & wlocnapv ==	"0"
replace wlcotnapb = 	"1"	 if id == 	35565	 & wlcotnapb ==	"0"
replace wlcotnapv = 	"1"	 if id == 	35565	 & wlcotnapv ==	""
replace wlocrnah = 	"1"	 if id == 	41948	 & wlocrnah ==	"0"
replace wlcotnah = 	"1"	 if id == 	41948	 & wlcotnah ==	"0"


*practice vacancies
list id wlva wlvau wlvadk wlvana  wlvana_comment dirall if wlvana_comment!=""
	*cb_flag9 should have been here, but only 1 case so do direct editings
	replace wlva="0" if id==4034
	*

list id wlva wlvau wlvadk wlvana  wlvana_comment dtimage if wlvana!=""&wlvana!="1"&wlvana!="0"
*na

foreach x of var jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk   {
tab `x'_comment if `x'==""
replace `x'=`x'_comment if `x'==""&`x'_comment!=""
}
*
*none to deal with

foreach i of num 1/6 {
replace fcc_age_`i' = fcayna if fcayna!=""&fcayna!="0"&fcayna!="1"&fcc_age_`i'==""
replace fcayna="" if fcayna!=""&fcayna!="0"&fcayna!="1"&fcc_age_`i'==fcayna
}
*
foreach x of var  wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana ///
  				 fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna pifyrna jsmena {
tab `x'_comment if `x'==""
tab `x'
}
*
foreach x of var  wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana ///
  				 fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna pifyrna jsmena {
list sdtype response dirall `x' if `x' != "0" & `x' != "1" & `x' != ""
}
*
	*should have been cb_flag10, but all online so implausible to check
	
foreach x of var  wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana ///
  				 fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna pifyrna jsmena {
replace `x' = "0" if `x' != "0" & `x' != "1" & `x' != ""
}
*

*none to deal with

****************************************************************

*Convert other check box variables

foreach x of var  wltms wlttr wltrg wltnt wlana wlobs wlsur wleme wlnon wlnt glrlpv ///
glrltv glrlrs glrlrp glrlot fcccrf fcccn fccccw  fcccdc picmda picmdo pisappc ///
pisappm pisaprm pisapde pisapma pisapop pisapps pisapsu pisapom pisapph  pisapan pisapem ///
pisapic pisapog pisappa pisapra pifyrna pisapai pisapim {
tab `x'
}
*
replace picmdo_text=picmdo if (response=="Online"|source=="Pilot")
replace picmdo="1" if picmda=="2"
replace picmda="0" if picmda=="2"
*replace picmda="1" if picmda=="A Medical School In Australia"

replace picmdo_text=picmdo if picmdo_text==""&picmdo!=""&picmdo!="1"&picmdo!="0"
replace picmdo_text=upper(picmdo_text)
replace picmdo="" if picmdo!=""&picmdo!="1"&picmdo!="0"
replace picmda="1" if picmdo_text=="AUSTRALIA"
replace picmdo_text="" if picmdo_text=="AUSTRALIA"
replace picmdo="1" if picmdo==""&picmdo_text!=""

*wlacto wlactc wlactn
list id dtimage wlacto wlacto_comment response if wlacto_comment!=""
list id dtimage wlactc wlactc_comment  response if wlactc_comment!=""
list id dtimage wlactn wlactn_comment  response if wlactn_comment!=""

	*cb_flag11 data extraction should have been here, but only 3 cases so do direct editings
*
replace wlacto="0" if id==4022 & wlacto==""
replace wlactc="1" if id==4022 & wlactc==""
replace wlactn="1" if id==4022 & wlactn==""
*

list id response dtimage wlact* if wlactn=="1" & (wlactc=="1"|wlacto=="1")
replace wlactn="0" if  wlactn=="1" & (wlactc=="1"|wlacto=="1")

list wlact* if wlactn=="0" & wlactc=="0" &wlacto=="0" & csclid==1
replace wlactn="1" if wlactn=="0" & wlactc=="0" & wlacto=="0" & csclid==1

foreach x of var pimrgen pimrspe pimrpro pimrlim pimrnon {
list id /*dtimage*/ `x'_comment `x' if `x'_comment!=""
}
*
	*cb_flag12 data extraction should have been here, but only a few cases so do direct editings
*cb_flag12 edits
replace pimrpro="0" if id==4022 & pimrpro==""
replace pimrpro="0" if id==26514 & pimrpro==""
replace pimrlim="0" if id==4022 & pimrlim==""
replace pimrlim="0" if id==26514 & pimrlim==""
*
	
drop pimr*_comment

replace pimrgen="0" if pimrgen=="" & (pimrspe=="1"|pimrpro=="1"|pimrlim=="1"|pimrnon=="1")
replace pimrspe="0" if pimrspe=="" & (pimrgen=="1"|pimrpro=="1"|pimrlim=="1"|pimrnon=="1")
replace pimrpro="0" if pimrpro=="" & (pimrspe=="1"|pimrgen=="1"|pimrlim=="1"|pimrnon=="1")
replace pimrlim="0" if pimrlim=="" & (pimrspe=="1"|pimrpro=="1"|pimrgen=="1"|pimrnon=="1")
replace pimrnon="0" if pimrnon=="" & (pimrspe=="1"|pimrpro=="1"|pimrlim=="1"|pimrgen=="1")

****************************************************************

*code JSMLE - it is text for hardcopy q and checkbox for online.
*need to have separate variable for each specialty as they often select multipe
*created by TT 2/7/2015

destring jsmapna jsmaddi jsmapan jsmapde jsmapem jsmapgp jsmapic jsmapma jsmapog jsmapom jsmapop jsmappc jsmapai jsmappm jsmappa jsmaphy jsmapps jsmapph jsmapon jsmapra jsmaprm jsmashm jsmaspo jsmapsu jsmena, replace

replace jsmle=upper(jsmle)
tab jsmle
replace jsmapgp=1 if strmatch(jsmle, "*GP*")|strmatch(jsmle, "*GENERAL PRACTICE*")|strmatch(jsmle, "*G.P.*")
replace jsmaphy=1 if strmatch(jsmle, "*FRACP*")|strmatch(jsmle, "*PHYSICIAN*")
replace jsmapem=1 if strmatch(jsmle, "*ACEM*")|strmatch(jsmle, "*EMERG*")
replace jsmapan=1 if strmatch(jsmle, "*ANAESTHE*")
replace jsmapde=1 if strmatch(jsmle, "*DERMATOL*")
replace jsmapsu=1 if strmatch(jsmle, "*SURGERY*")|strmatch(jsmle, "*SURGICAL*")
replace jsmapic=1 if strmatch(jsmle, "*ICU*")|strmatch(jsmle, "*INTENSIVE*")
replace jsmapma=1 if strmatch(jsmle, "*ADMINISTRATION*")
replace jsmapog=1 if strmatch(jsmle, "*O & G*")|strmatch(jsmle, "*OBSTET*")|strmatch(jsmle, "*GYNAE*")
replace jsmapog=1 if strmatch(jsmle, "FRANZCOG")|strmatch(jsmle, "OBS & GYN")
replace jsmapop=1 if strmatch(jsmle, "*OPHTHAL*")
replace jsmappc=1 if strmatch(jsmle, "*PAED.*")|strmatch(jsmle, "*PAEDIATRIC*")|strmatch(jsmle, "*PAEDS*")
replace jsmapai=1 if strmatch(jsmle, "*PAIN*")
replace jsmappm=1 if strmatch(jsmle, "*PALLIATIVE*")|strmatch(jsmle, "*PALL MED*")
replace jsmapps=1 if strmatch(jsmle, "*PSYCHIATRY*")
replace jsmapph=1 if strmatch(jsmle, "*PUBLIC*")
replace jsmapra=1 if strmatch(jsmle, "*RADIOLOGY*")
replace jsmashm=1 if strmatch(jsmle,"*SEXUAL*") 
replace jsmaspo=1 if strmatch(jsmle,"*SPORT*")
replace jsmappa=1 if jsmle=="PATHOLOGY"
replace jsmaprm=1 if jsmle=="REHAB MED"

replace jsmaphy=1 if jsmle=="16"
replace jsmapph=1 if jsmle=="18"
replace jsmapsu=1 if jsmle=="24"
replace jsmapog=1 if jsmle=="9"
replace jsmapem=1 if jsmle=="5"


replace jsmappc=1 if jsmle=="12 PLUS 18"
replace jsmapph=1 if jsmle=="12 PLUS 18"


gen jsmaoth=1 if jsmle=="CARDIOLOGY"|jsmle=="ENDOCRINOLOGY"|jsmle=="ENT"|jsmle=="GERIATRIC MEDICINE"|jsmle=="BPT"
replace jsmaoth=1 if strmatch(jsmle,"*HAEMOTOLOGY*") | strmatch(jsmle,"*HAEMATOLOGY*")|strmatch(jsmle,"*ONCOLOGY*") 
replace jsmaoth=1 if strmatch(jsmle,"*ORTHOPAEDICS*") | strmatch(jsmle,"*OTALARYNGOLOGY*")|strmatch(jsmle,"*OTORMINOLARYNGOLOGY*")
replace jsmaoth=1 if strmatch(jsmle,"*RHEUMATOLOGY*") | strmatch(jsmle,"*RURAL GENERALISM*")|strmatch(jsmle,"*UNDECIDED*")
replace jsmaoth=1 if strmatch(jsmle,"*UNSURE*") |strmatch(jsmle,"*SURE*")| strmatch(jsmle,"*NEPHROLOGY*") 
replace jsmaoth=1 if jsmle=="CARDIOTHORACICS"|jsmle=="INFECTIOUS DISEASES"|jsmle=="ORTHAPAEDICS"|jsmle=="GERIATRICS"
egen jsmsome = anymatch(jsmaddi jsmapan jsmapde jsmapem jsmapgp jsmapic jsmapma jsmapog jsmapom jsmapop jsmappc jsmapai jsmappm jsmappa jsmaphy jsmapps jsmapph jsmapon jsmapra jsmaprm jsmashm ///
jsmaspo jsmapsu jsmaoth), values(1)

replace jsmapog=1 if jsmena_comment=="O & G"

replace jsmena = 0 if jsmsome==1

gen jsmaoth_text = jsmle if jsmaoth==1
replace jsmapna = 1 if jsmena==1
drop jsmle jsmena_comment jsmena
*********************************************************************

foreach x of var jsbsdk wlvadk fimedk fidpdk fcpr_dk fcprt_dk  wlna wlcna wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv /// 
				 wlocna wlcotnap wlcotnah wlcotnapb wlcotnapv wlvana fidpna glrna glrlna fcpr_na fcprt_na fcayna fcccna pirna pisapna ///
				 wltms wlttr wltrg wltnt wlana wlobs wlsur wleme wlnon wlnt glrlpv glrltv glrlrs glrlrp glrlot fcccrf fcccn fccccw /// 
				 fcccdc picmda picmdo pisaddi pisapon pisashm pisaspo pisappc pisappm pisaprm pisapde pisapma pisapop pisapps ///
				 pisapsu pisapom pisapph pisapan pisapem pisapgp pisapic pisapog pisappa pisapra pifyrna pisapai pisapim ///
				 wlacto wlactc wlactn pimrgen pimrspe pimrpro pimrlim pimrnon {
destring `x', replace
label var `x' 		"Cleaned"
}
*


drop *_tick
compress

