
**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: Order variables for internal release
********************************************************

global ddtah="D:\Data\Data Clean\Wave9\dtah"
global ddo="D:\Data\Data Clean\Wave9"
global dlog="D:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\order.log", replace

********************************************************

use "${ddtah}\temp_all.dta", clear

********************************************************

ren piyrb_text piyrbi_text
*ren csrtn_text csclir_text
ren pigen_text pigeni_text
ren wlhth_text pihth_text
*ren wlocrnapb_text wlocnapb_text
*ren wlocrnapv_text wlocnapv_text
ren wlhth_multi1 pihth_multi1

drop pigen_multi1 piqadm_text piqadph_text piqaddc_text 
*drop v28
drop datefinish
drop miss* main email1 email2
********************************************************

#delimit;

order 

id 
listeeid 
sdtype 
continue 
source 
response 
cohort 
date 
t2response 
dtimage 

csclid 
cspret 
csncli 
csml 
cshd 
csstu 
csexl 
csocli 
csoncli 
csonmd 
csnmd 
csnmd_text 
csdeath 
csovs 
csclir 

jsfm 
jsva 
jspw 
jsau 
jscw 
jsrc 
jshw 
jswr 
jsrp 
jsfl 
jshp 
jsbc 
jssn 
jsto 
jspe 
jscp 
jsqs 
jsps 
jsst 
jspu 
jspt 
jsuh 
jssm 
jslq 
jsco 
jsfs 
jsch 
jsas 
jsbsyr 
jsbsdk 
/* jsbsna */
jssc 
jssc6
jsscg
jsmapna
jsmaddi 
jsmapan 
jsmapde 
jsmapem 
jsmapgp 
jsmapic 
jsmapma 
jsmapog 
jsmapom 
jsmapop 
jsmappc
jsmappm 
jsmappa 
jsmaphy 
jsmapps 
jsmapph 
jsmapon 
jsmapra 
jsmaprm 
jsmashm 
jsmaspo 
jsmapsu 
jsmaoth
jsmaoth_text

pwpuhh 
pwpihh 
pwpish 
pwchh 
pwhfh 
pwahs 
pwlab 
pwgov 
pweih 
pwothh 
pwtoh 
pwpip 
pwnwmf 
pwnwmp 
pwnwff 
pwnwfp 
pwnwn 
pwnwap 
pwnwad 
pwnwo 
pwcl 
pwbr 
pwbr_text 
pwsmth 
pwsyr 
pwoce 
pwacc 
pwni 
pwwh 
pwhlh 
pwahnc 
pwpm 
pwpm_text 
pwmhn 
pwmhp 
pwmhpasgc 
pwmhprrma 
pwwmth 
pwwyr 
pwsp 

wlwh 
wldph 
wlidph 
wleh 
wlmh 
wlothh 
wltms 
wlttr 
wltrg 
wltnt 
wlacto
wlactc
wlactn
wlana 
wlobs 
wlsur 
wleme 
wlnon 
wlspint
wlante
wlwom
wlpsych
wlskin
wlchild
wlsport
wlotspe
wlprop
wlnppc 
wlnpph 
wlnprh 
wlnprr 
wlnph 
wlnp 
wlwy 
wlwod 
wlwd 
wlww 
wlnt 
wlna 
wlcmin 
wlcnpmin 
wlcsmin 
wlcna 
wlcf 
wlcnpf 
wlcsf 
wlcfna 
wlbbp 
wlbpna 
wlah 
wlocrpn 
wlocrpe 
wlocrnap 
wlocrhn 
wlocrhe 
wlocrnah 
wlocrpbn 
wlocrpbe 
wlocnapb 
wlocrpvn 
wlocrpve 
wlocnapv 
wlocr 
wlocna 
wlcotpn 
wlcotpe 
wlcotnap 
wlcothn 
wlcothe 
wlcotnah 
wlcotpbn 
wlcotpbe 
wlcotnapb 
wlcotpvn 
wlcotpve 
wlcotnapv 
wlrh 
wlpch 
wlcot 
wlocoth 
wlal 
wlwhpy 
wlmlpy 
wlsdpy 
wlotpy 
wlva 
wlvadk 
wlvana 
wlvau 

figey 
figef 
finey 
/*finey_neg*/
finef 
fib 
fibv 
fidme 
fimedk 
fidp 
fidpdk 
fidpna 
fips 
fisadd
/*fisadd_neg*/
fiip 
fighiy 
fighif 
finhiy 
/*finhiy_neg*/
finhif 

glnl 
gltww 
glpcw 
gldist
gldistgr
gltwwasgc 
gltwwrrma 
/*gltwwml 
glmth 
glyr */
gltwl 
glpcl 
gltwlasgc 
gltwlrrma 
glfiw 
glbl 
glpfiw 
glgeo 
glacsc 
glyrrs 
glrtw 
glrst 
glrna 
glrtwasgc 
glrtwrrma 
glrl 
glrlpv 
glrltv 
glrlrs 
glrlrp 
glrlot 
glrlna 
gltps 
gltown1
glpc1
glout1asgc
glout1rrma
gltown2
glpc2
glout2asgc
glout2rrma
gltown3
glpc3
glout3asgc
glout3rrma
/*glnonm
glnloc
glnvis
glnyr
glntrav
glnpay
glnco
glnsub
glnlead
glnreq
glngrow
glndis
glnpers
glncomp
glnsupp
glnlong*/
glnfive
glnpast
glnfund

fclp 
fcpes 
fcpmd 
fcpr 
fcpr_dk 
fcpr_na 
fcprt 
fcprs 
fcprt_dk 
fcprt_na 
fcprtasgc 
fcprtrrma 
fcndc 
fcayna 
fcc_age_1 
fcc_age_2 
fcc_age_3 
fcc_age_4 
fcc_age_5 
fcc_age_6 
fcccrf 
fcccn 
fccccw 
fcccdc 
fcccna 
fcrwncc 
fcpwncc 
fcoq 

piyrbi 
piagei 
pigeni 
picmd 
picmda 
picmdo 
picmdoi 
picmdo_country 
pims 
piis 
picamc 
pifayr 
pifryr 
pifyrna 
piqonr 
piqanm
piqanph
piqandc
piqanf
piqadf
pires
pioth
piste 
piste6
pisteg  
facrrm 
fwshpoth
pimsp6
pimspx
pimsp6i
pimspgx 
pisespx
pisesp6
pisespgx  
pirsyr 
pireyr 
pirps 
pirna 
pisapna 
pisaddi
pisapan
pisapde
pisapem
pisapgp
pisapic
pisapma
pisapog
pisapom
pisapop
pisappc 
pisapai
pisappm
pisappa
pisapim
pisapps
pisapph
pisapon 
pisapra
pisaprm 
pisashm 
pisaspo 
pisapsu  
pindyr 
pindmt 
pirs 
pimrgen
pimrspe
pimrpro
pimrlim
pimrnon 
pihth
pilfsa 
pertj 
perct 
perrd 
peror 
perwo 
perfr 
perlz 
persoc 
perart 
pernev 
pereff 
perrsv 
perknd 
perimg 
perstr 
pilc_1 
pilc_2 
pilc_3 
pilc_4 
pilc_5 
pilc_6  
pilc_7 
pifirisk
picarisk
piclrisk
piin 
piinhl 
piinf 
piinfhl 
pides 
pideshl 
pider 
piderhl 
pidef 
pidefhl 
piviv 
pivivhl 
pivpc 
pivpchl 
pidmn 
pidmnhl 

furcom 
piemail 
type 
state 
asgc 
rrma 
cheque 
weight_cs 
weight_l 
weight_panel;

#delimit cr

*************************************
*following bit groups *multi and *text with correct variable



dropmiss *_multi*, force

desc csclid - pidmnhl, varlist

foreach x in `r(varlist)' {
	capture confirm var `x'_text
	
	if !_rc {
	
	gen `x'_c = (`x'_text!="")
	
	order `x'_c, a(`x')
	order `x'_text, a(`x'_c)
	
		capture confirm var `x'_multi1
		if !_rc {
		order `x'_multi1, a(`x'_text)
		}
		else {
		}
	
		capture confirm var `x'_multi2
		if !_rc {
		order `x'_multi2, a(`x'_multi1)
		}
		else {
		}
	
		capture confirm var `x'_multi3
		if !_rc {
		order `x'_multi3, a(`x'_multi2)
		}
		else {
		}

		capture confirm var `x'_multi4
		if !_rc {
		order `x'_multi4, a(`x'_multi3)
		}
		else {
		}
		
	}
	
	else {
	
		capture confirm var `x'_multi1
		if !_rc {
		order `x'_multi1, a(`x')
		}
		else {
		}
	
		capture confirm var `x'_multi2
		if !_rc {
		order `x'_multi2, a(`x'_multi1)
		}
		else {
		}
	
		capture confirm var `x'_multi3
		if !_rc {
		order `x'_multi3, a(`x'_multi2)
		}
		else {
		}
		
		capture confirm var `x'_multi4
		if !_rc {
		order `x'_multi4, a(`x'_multi3)
		}
		else {
		}
	
	}
	
}


**********************************************

ren pwtoh pwtohi
ren wlwh wlwhi

*need to do this to make long strings compatible with Stata12
recast str99	csnmd_text	, force
recast str100	pwbr_text	, force
recast str101	pwpm_text	, force
recast str102	pwmhn	, force
recast str103	wlwd_text	, force
recast str104	wlww_text	, force
recast str105	wlocoth	, force
*recast str106	wlwhpy_text	, force
*recast str107	wlotpy_text	, force
recast str108	finey_text	, force
recast str109	gltown2	, force
recast str110	pireyr_text	, force
recast str111	pindmt_text	, force
recast str112	furcom	, force
recast str113	piemail	, force
recast str114	wlot_text	, force
*recast str115	q21_1_text	, force
*recast str116	q21_2_text	, force





numlabel _all, add mask([#]) force

drop _merge firstwave v29 *_flag* dir* dup_id typecont sum1 sum2 username noresponse* w10np
