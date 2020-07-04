**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 13 April 2017
*Purpose: identify and drop the duplicated responses based on set up rules

********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\duplicates.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear


/* ignore this - now done in var_date.do 
gen date3=regexs(0) if regexm(furcom, "([0-9]+)\/([0-9]+)\/([0-9]+)") & a==1
replace date=date3 if date3!=""

gen date2=date(date, "DMY")
replace date1=date2 if a==1
drop date2 date3   */




********************************************************

* It's important to check up duplicates using both MABEL id and listeeid
* because occasionally continuing doctors got reassigned new MABEL ids when preparing the sample
* Clean up those mis-matches before start dropping duplicated responses

*merge on listeeids
gen username=id
merge m:m username using "L:\Data\Samples\Wave 8\W8_All.dta", keepusing(listeeid) 
drop if _merge==2
drop _merge
merge m:m username using "L:\Data\Samples\Wave 8 Pilot\W8p_All.dta", keepusing(listeeid) update 
drop if _merge==2
drop _merge
merge m:m username using "L:\Data\Samples\masterid.dta", keepusing(listeeid) update 
drop if _merge==2
drop _merge



*replace listeeid=504580 if id==95078

*code pilots as hardcopy if entered into online main
*replace response = "Hardcopy" if sample=="1" & source=="Main"
drop sample

********************************************************

*identify the mis-match of MABEL ids and Listeeids

duplicates tag id, gen(dup1)
duplicates tag listeeid, gen(dup2)

tab1 dup1 dup2

duplicates report id
duplicates report listeeid
*In Wave 7 sample, all MABEL ids had a unique Listeeids.

*some would have had previous MABEL ids, particularly if they were in the boost sample.

/*SOLUTION: keep recording their old MABEL ID (smaller number)

sort listeeid id
by listeeid: gen n=_n if dup1==0&dup2!=0
list id listeeid n sdtype continue source response if dup1==0&dup2!=0

by listeeid: gen old_id = id[_n-1] if dup1==0&dup2!=0

preserve

keep id listeeid old_id
keep if old_id!=.
save "${ddtah}\id_mismatch.dta", replace

restore

replace id = old_id if dup1==0&dup2!=0&old_id!=.


drop dup1 dup2 n old_id
*/
*drop dup
duplicates tag id listeeid, gen(dup3)
tab dup3
*drop n
**************************************************

*Found variable wlcotnapv is still a string variable
list id dtimage sdtype wlcotpvn wlcotpve wlcotnapv if wlcotnapv=="A/A" | wlcotnapv=="O"
replace wlcotnapv="1" if id==34128
replace wlcotnapv="0" if id==65144
destring wlcotnapv,replace

preserve

*the criteria for dropping duplicates is to keep the one with higher item response rate, but this only counts the numeric variables
	 
*remove this version when all data cleaning is complete*	 
drop 	dtbatch dtserial dtimage /*altid*/ *_text *_comment *_multi* pwmhn pwmhp wlocoth gltww glpcw gltwl glpcl glrtw glrst fcprt fcprs /// 
		dummy furcom dup3 continue source response piemail id listeeid date   piqa* wlspin*   ///
		pires pioth gltown* glpc* datefinish /*dup dup1 dup2 dupid*/ ///
		jshe	jswl	jslj	wlocrnapb	jsredt	ka	kb	kc	kd	ip	iq	ir	is ///
		fcpes_1	fcpes_2	fcpes_3	fcpes_4	fcpes_5	q66_4	/*pifayr_tick*/	glnfund	jsred ///
		fics	fiefr		glnpast		glnfive		fistot	

desc _all, varlist
restore

foreach x in `r(varlist)' {
replace `x'=-2 if `x'==.
}

egen noresponse=anycount(`r(varlist)'), values (-2)

sort id noresponse

bysort id: gen n=_n if dup3!=0

*check the email information status for all duplicates.

by id: gen email1=1 if piemail[_n]!=piemail[_n-1]&id[_n]==id[_n-1]&n==2
by id: gen email2=1 if piemail[_n]!=piemail[_n+1]&id[_n]==id[_n+1]&n==1

list id listeeid n noresponse date dtimage piemail if dup3==1&(email1==1|email2==1)
list id piemail dtimage if dup3==1&(email1==1|email2==1)& piemail!=""

/*duplicates report id
duplicates report listeeid

gen flag1=0
gen flag2=0
replace flag1=1 if dup==1&(email1==1|email2==1)
replace flag2=1 if dup==1&(email1==1|email2==1)& piemail!=""

gen lbflag1=""
gen lbflag2=""

replace lbflag1 = "email 1" if flag1==1
replace lbflag2 = "email 2" if flag2==1

gen idtext = "*ID = " + string(id)
gen hardcopy="hcopy" if dtimage != ""
replace hardcopy="online" if dtimage==""
gen piemailtext="replace piemail = " + piemail + " if id== " + string(id) + " & piemail== " + piemail
gen case=0
replace case=1 if flag1==1 | flag2==1*/

/*fill piemail - not work
preserve
keep if case==1
gsort id -date
keep id piemail date
replace piemail = piemail if id[_n-1] == id[_n]
export excel using "L:\Data\Data Clean\Wave8\temp\email-fill.xlsx", replace
restore*/

/*check whether duplicates are artifact
preserve
keep if case==1
bysort id: gen missn = _n
tab sdtype
bysort missn: summarize noresponse
sort id date
gen datecheck=0
replace datecheck=1 if date[_n-1]==date[_n]
tab datecheck
keep id piemail date datecheck
export excel using "L:\Data\Data Clean\Wave8\temp\datecheck.xlsx", replace
restore*/
/*
*export cases
preserve
keep if case==1
sort id date
keep idtext piemailtext
stack idtext piemailtext, into(column) clear
bys _stack: gen row = _n
sort row _stack
gen idcase=_n
keep idcase column
/*list, clean noobs*/
export excel using "L:\Data\Data Clean\Wave8\temp\email-case.xlsx", replace
restore

*export label flags
preserve
keep if case==1
keep id lbflag1 lbflag2 hardcopy date
expand 2
sort id date lbflag1 lbflag2
gen idcase = _n
foreach x of var id date{
replace `x' = . if `x'[_n-1] == `x'[_n]
}
foreach x of var lbflag1 lbflag2 hardcopy{
replace `x' = "" if `x'[_n-1] == `x'[_n]
}
export excel using "L:\Data\Data Clean\Wave8\temp\email-flag.xlsx", replace
restore

*this program tends to behave inconsistently. It gives (and exports) differenct outcomes each time.
preserve
keep if case==1
bysort id (piemail): replace piemail = piemail[1] if missing(piemail)
bysort id (date): replace piemail = piemail[_N]
export excel id date piemail using "L:\Data\Data Clean\Wave8\temp\email-sol3.xlsx", replace
restore*/


/*
replace piemail="ross.hanrahan@yahoo.com" if id==2176
*/

	replace piemail="ian.davis@monash.edu" if id==1265 & piemail==""
	replace piemail="leonie_callaway@bigpond.com" if id==1916 & piemail==""
	replace piemail="monivros@yahoo.com" if id==2073 & piemail==""
	replace piemail="jimyen@gmail.com" if id==2159 & piemail==""
	replace piemail="amuljono@dhm.com.au" if id==2268 & piemail==""
	replace piemail="tinatong.xu@yahoo.com.au" if id==1265 & piemail==""
	replace piemail="aj_palumbo@hotmail.com" if id==2445 & piemail==""
	replace piemail="gaia_2005@bigpond.com" if id==3854 & piemail==""
	replace piemail="wright_ae@hotmail.com" if id==6873 & piemail==""
	replace piemail="felicity.rea@gmail.com" if id==11082 & piemail==""
	replace piemail="padminiact@hotmail.com" if id==14897 & piemail==""
	replace piemail="j.dessauer@scmg.com.au" if id==20700 /*the more recent submission has a different email but more missing values*/
	replace piemail="dimity.pond@newcastle.edu.au" if id==20936 & piemail==""
	replace piemail="pjc1942@bigpond.com" if id==21317 & piemail==""
	replace piemail="kbulwink@bigpond.net.au" if id==29315 & piemail==""
	replace piemail="padminiact@hotmail.com" if id==14897 & piemail==""
	replace piemail="jimjmcgill@gmail.com " if id==40964 & piemail==""
	replace piemail="neil_widdicombe@iinet.net.au" if id==42501 & piemail==""
	replace piemail="aber2606@uni.sydney.edu.au" if id==43920 & piemail==""
	replace piemail="raj.lgmc@westnet.com.au" if id==57012 & piemail==""
	replace piemail="drmhunter@uniting.com.au" if id==57262 & piemail==""
	replace piemail="ja.rotella@gmail.com" if id==57508 & piemail==""
	replace piemail="peter@neuron.com.au" if id==63136 & piemail==""
	replace piemail="robertgluer@gmail.com" if id==63419 & piemail==""
	replace piemail="bcarrigan@gmail.com" if id==65342 & piemail==""
	replace piemail="ken.kktan@gmail.com" if id==67442 & piemail==""
	replace piemail="peter@neuron.com.au" if id==63136 & piemail==""
	replace piemail="alistair.don@gmail.com" if id==67574 & piemail==""
	replace piemail="roseschuddinh@gmail.com" if id==70125 & piemail==""
	replace piemail="drdudule@yahoo.co.nz" if id==73144 & piemail==""
	replace piemail="tessa.weir@gmail.com" if id==77067 & piemail==""
	replace piemail="jacki@flinders.org" if id==77616 & piemail==""
	replace piemail="dr.louisestanbishop@gmail.com" if id==80153 & piemail==""
	replace piemail="de_frenza@bigpond.com" if id==80343 & piemail==""
	replace piemail="dr.louisestanbishop@gmail.com" if id==80153 & piemail==""
	replace piemail="liam.flynn@uqconnect.edu.au" if id==80153 & piemail==""
	replace piemail="dr.louisestanbishop@gmail.com" if id==80416 & piemail==""
	replace piemail="deniseglennon@mac.com" if id==82901 & piemail==""
	replace piemail="jamescorrey89@gmail.com" if id==90945 & piemail==""
	replace piemail="duke.tanya@gmail.com" if id==92066 & piemail==""
	replace piemail="vemansell@gmail.com" if id==93045 & piemail==""
	replace piemail="eawhitelaw@gmail.com" if id==98648 & piemail==""
	replace piemail="elinakt@gmail.com" if id==98718 & piemail==""
	replace piemail="owen.kang@gmail.com" if id==98743 & piemail==""
	replace piemail="timbaker@live.com.au" if id==1000134 & piemail==""
	replace piemail="peachesnmango@hotmail.com" if id==1000301 & piemail==""
	replace piemail="gurungparbati@hotmail.com" if id==1000453 & piemail==""
	replace piemail="Emily.Dunn@hnehealth.nsw.gov.au" if id==1000771 & piemail==""
	replace piemail="feffa_jj@hotmail.com" if id==1000853 & piemail==""


	
*drop among the rest duplicates with TWO responses

*keep the duplicated response with most updated doctor type
* wenda - what is the most update doctor type? is it the most recent?
* if there are 2 online surveys with same date, go back to the append.dta file and check the times. Keep most recent survey - providing it is in survey period.

bysort id: gen typech=1 if sdtype[_n]!=sdtype[_n-1]&n==2&dup3==1
list id sdtype n noresponse source date piemail if dup3==1&typech==1
list id sdtype n noresponse source date piemail if typech==1
list id sdtype n noresponse source date piemail typech response if dup3==1

	drop if id==57508 & sdtype==3
	drop if id==65342 & sdtype==1
	


*drop dup3 n

/*drop those number of nonresponse items is too big (difference is more than 10)

sort id
duplicates tag id listeeid, gen(dup)
by id: gen n=_n if dup==1

drop if (id==7454|id==14961|id==21698|id==38970|id==30796|id==32385|id==39596|id==53573|id==56668|id==64616|id==64639|id==72158|id==83776|id==89262|id==92433) & n==2


*by id: drop if id!=34863&id!=58316&id!=58994&id!=62825&id!=71082&id!=71142&id!=77001&dup==1&n==2&id[_n]==id[_n-1]&noresponse[_n]-noresponse[_n-1]>=10

drop dup n

duplicates tag id, gen(dup)
by id: gen n=_n if dup==1

sort id noresponse

replace dtimage = trim(dtimage)
replace piemail = trim(piemail)
replace piemail = itrim(piemail)
replace piemail = lower(piemail)



drop dup n email1 email2

duplicates tag id, gen(dup)
by id: gen n=_n if dup==1

sort id noresponse*/

**********************************************************

*drop duplicated reponses with more missing values

list id listeeid n noresponse date dtimage piemail if dup1==1

by id: drop if dup1==1&n==2&id[_n]==id[_n-1]&noresponse[_n]-noresponse[_n-1]>0

*drop dup1 dup2 dupid 


by id: gen n1=_n if dup3==1

sort id noresponse

**********************************************************

*keep most recent duplicated reponses if number of nonresponses are the same

list id listeeid n1 noresponse date if dup3>0

drop if dup3==1 & n1==2
	drop if id==98392 &(sdtype==3|sdtype==1)

drop n n1 dup3 noresponse typech

****************************************************



