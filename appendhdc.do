*Date last modified: 14 October 2017
*Purpose: read in GP online data from main and pilot

********************************************************

global ddata="L:\Data\Data Original\Wave9"
global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"

capture clear
capture log close
set more off

log using "${dlog}\appendhdc.log", replace

tempfile hdc

********************************************************


***************
*   hdc online 
***************

*main wave data

use "${ddata}\online\hdw9c.dta", clear
gen source="Main"
renvars _all, upper

ren		V3		id
ren		V8		date
ren		V9		datefinish
				
ren		Q1		csclid
ren		Q2_1		cspret_1
ren		Q2_2		cspret_2
ren		Q3_1		csncli
ren		Q3_2		csml
ren		Q3_3		cshd
ren		Q3_4		csstu
ren		Q3_5		csexl
ren		Q3_6		csocli
ren		Q3_7		csoncli
ren		Q3_8		csonmd
ren		Q3_9		csnmd
ren		Q3_9_TEXT		csnmd_text
ren		Q4		csrtn
				
ren		Q5_1		jsfm
ren		Q5_2		jsva
ren		Q5_3		jspw
ren		Q5_4		jsau
ren		Q5_5		jscw
ren		Q5_6		jsrc
ren		Q5_7		jshw
ren		Q5_8		jswr
ren		Q5_9		jsrp
ren		Q5_10		jsfl
ren		Q6_1		jsbc
ren		Q6_2		jssn
ren		Q6_3		jsto
ren		Q6_4		jspe
ren		Q6_5		jscp
ren		Q6_6		jsqs
ren		Q6_7		jsst
ren		Q6_8		jspt
ren		Q6_9		jsuh
ren		Q6_10		jslq
ren		Q6_11		jswl
ren		Q6_12		jslj
ren		Q6_13		jshe
ren		Q7		jsch
ren		Q8		jsred
ren		Q9		jsas
ren		Q10		jsbsyr_tick
ren		Q10_TEXT		jsbsyr
ren		Q11_1		jssapna
ren		Q11_2		jssaddi
ren		Q11_3		jssapan
ren		Q11_4		jssapde
ren		Q11_5		jssapem
ren		Q11_6		jssapgp
ren		Q11_7		jssapic
ren		Q11_8		jssapma
ren		Q11_9		jssapog
ren		Q11_10		jssapom
ren		Q11_11		jssapop
ren		Q11_12		jssappc
ren		Q11_13		jssapai
ren		Q11_14		jssappm
ren		Q11_15		jssappa
ren		Q11_16		jssaphy
ren		Q11_17		jssapps
ren		Q11_18		jssapph
ren		Q11_19		jssapon
ren		Q11_20		jssapra
ren		Q11_21		jssaprm
ren		Q11_22		jssashm
ren		Q11_23		jssaspo
ren		Q11_24		jssapsu
ren		Q12_1		jsmapna
ren		Q12_2		jsmaddi
ren		Q12_3		jsmapan
ren		Q12_4		jsmapde
ren		Q12_5		jsmapem
ren		Q12_6		jsmapgp
ren		Q12_7		jsmapic
ren		Q12_8		jsmapma
ren		Q12_9		jsmapog
ren		Q12_10		jsmapom
ren		Q12_11		jsmapop
ren		Q12_12		jsmappc
ren		Q12_13		jsmapai
ren		Q12_14		jsmappm
ren		Q12_15		jsmappa
ren		Q12_16		jsmaphy
ren		Q12_17		jsmapps
ren		Q12_18		jsmapph
ren		Q12_19		jsmapon
ren		Q12_20		jsmapra
ren		Q12_21		jsmaprm
ren		Q12_22		jsmashm
ren		Q12_23		jsmaspo
ren		Q12_24		jsmapsu
				
ren		Q13_1_1_TEXT		pwpuhh
ren		Q13_2_1_TEXT		pwpihh
ren		Q13_3_1_TEXT		pwpish
ren		Q13_4_1_TEXT		pwhfh
ren		Q13_5_1_TEXT		pweih
ren		Q13_6_1_TEXT		pwothh
ren		Q13_7_1_TEXT		pwtoh
ren		Q14_1_TEXT		pwmhn
ren		Q14_2_TEXT		pwmhp
ren		Q15_1_TEXT		pwwyr
ren		Q15_2_TEXT		pwwmth
ren		Q16		pwsp
				
ren		Q17_1_1_TEXT		wlwh
ren		Q17_2_1_TEXT		wldph
ren		Q17_3_1_TEXT		wlidph
ren		Q17_4_1_TEXT		wleh
ren		Q17_5_1_TEXT		wlmh
ren		Q17_6_1_TEXT		wlothh
ren		Q18_1		wlacto
ren		Q18_2		wlactc
ren		Q18_3		wlactn
ren		Q19		wlnp
ren		Q20		wlah
ren		Q21_1_TEXT		wlrh
ren		Q21_2_TEXT		wlpch
ren		Q21_3_TEXT		wlcot
ren		Q22		wlocr_tick
ren		Q22_TEXT		wlocr
ren		Q23_1_TEXT		wlwhpy
ren		Q23_2_TEXT		wlmlpy
ren		Q23_3_TEXT		wlsdpy
ren		Q23_4_TEXT		wlotpy
				
ren		Q24_1_1_TEXT		figey
ren		Q24_1_2_TEXT		figef
ren		Q24_2_1_TEXT		finey
ren		Q24_2_2_TEXT		finef
ren		Q25		fib
ren		Q26		fibv
ren		Q27		fidme_tick
ren		Q27_TEXT		fidme
ren		Q28		fiip
ren		Q29		fisadd
ren	Q30_1_1_TEXT	fighiy
ren	Q30_1_2_TEXT	fighif
ren	Q30_2_1_TEXT	finhiy
ren	Q30_2_2_TEXT	finhif

ren	Q31_1_TEXT	gltww
ren	Q31_2_TEXT	glpcw
ren	Q32_1_TEXT	gltwl
ren	Q32_2_TEXT	glpcl
ren	Q33_1	glfiw
ren	Q33_2	glbl
ren	Q33_3	glpfiw
ren	Q33_4	glgeo
ren	Q33_5	glacsc
ren	Q34_1	glrl_1
ren	Q34_2	glrl_2
ren	Q34_3	glrl_3
ren	Q35_1	glrlpv
ren	Q35_2	glrltv
ren	Q35_3	glrlrs
ren	Q35_4	glrlrp
ren	Q35_5	glrlot
	
ren	Q36	fclp
ren	Q37	fcpes
ren	Q38	fcndc
ren	Q39_1_TEXT	fcayna
ren	Q39_2_TEXT	fcc_age_1
ren	Q39_3_TEXT	fcc_age_2
ren	Q39_4_TEXT	fcc_age_3
ren	Q39_5_TEXT	fcc_age_4
ren	Q39_6_TEXT	fcc_age_5
ren	Q39_7_TEXT	fcc_age_6
ren	Q40_1	fcccrf
ren	Q40_2	fcccn
ren	Q40_3	fccccw
ren	Q40_4	fcccdc
ren	Q40_5	fcccna
ren	Q41_1	fcrwncc
ren	Q41_2	fcpwncc
ren	Q41_3	fcoq
	
ren	Q42	piis
ren	Q43	picamc
ren	Q44_1	pifayr_tick
ren	Q44_1_TEXT	pifayr
ren	Q44_2	pifryr_tick
ren	Q44_2_TEXT	pifryr
ren	Q44_3	pifyrna
ren	Q45	piqonr
ren	Q46_1_1_TEXT	piqanm
ren	Q46_1_2_TEXT	piqadm
ren	Q46_2_1_TEXT	piqanph
ren	Q46_2_2_TEXT	piqadph
ren	Q46_3_1_TEXT	piqandc
ren	Q46_3_2_TEXT	piqaddc
ren	Q46_4_1_TEXT	piqanf
ren	Q46_4_2_TEXT	piqadf
ren	Q47	pires
ren	Q48_1_TEXT	pioth
ren	Q49_1_TEXT	pindyr
ren	Q49_2_TEXT	pindmt
ren	Q50	pirs
ren	Q51_1	pimrgen
ren	Q51_2	pimrspe
ren	Q51_3	pimrpro
ren	Q51_4	pimrlim
ren	Q51_5	pimrnon
ren	Q52	wlhth
ren	Q53_1	pilfsa
ren	Q54_1	pifirisk
ren	Q54_2	picarisk
ren	Q54_3	piclrisk
ren	Q55_1_1	piin
ren	Q55_1_2	piinf
ren	Q55_1_3	pides
ren	Q55_1_4	pider
ren	Q55_1_5	pidef
ren	Q55_1_6	piviv
ren	Q55_1_7	pivpc
ren	Q55_1_8	pidmn
ren	Q55_2_1_1	piinhl_1
ren	Q55_2_1_2	piinhl_2
ren	Q55_2_1_3	piinhl_3
ren	Q55_2_1_4	piinhl_4
ren	Q55_2_2_1	piinfhl_1
ren	Q55_2_2_2	piinfhl_2
ren	Q55_2_2_3	piinfhl_3
ren	Q55_2_2_4	piinfhl_4
ren	Q55_2_3_1	pideshl_1
ren	Q55_2_3_2	pideshl_2
ren	Q55_2_3_3	pideshl_3
ren	Q55_2_3_4	pideshl_4
ren	Q55_2_4_1	piderhl_1
ren	Q55_2_4_2	piderhl_2
ren	Q55_2_4_3	piderhl_3
ren	Q55_2_4_4	piderhl_4
ren	Q55_2_5_1	pidefhl_1
ren	Q55_2_5_2	pidefhl_2
ren	Q55_2_5_3	pidefhl_3
ren	Q55_2_5_4	pidefhl_4
ren	Q55_2_6_1	pivivhl_1
ren	Q55_2_6_2	pivivhl_2
ren	Q55_2_6_3	pivivhl_3
ren	Q55_2_6_4	pivivhl_4
ren	Q55_2_7_1	pivpchl_1
ren	Q55_2_7_2	pivpchl_2
ren	Q55_2_7_3	pivpchl_3
ren	Q55_2_7_4	pivpchl_4
ren	Q55_2_8_1	pidmnhl_1
ren	Q55_2_8_2	pidmnhl_2
ren	Q55_2_8_3	pidmnhl_3
ren	Q55_2_8_4	pidmnhl_4
ren	Q56	piemail
ren	Q57	furcom

save "`hdc'"


*pilot data

*append using "`hdc'"
gen sdtype="HD"
gen continue="Continue"
gen response="Online"

renvars _all, lower

drop v* 
*drop a_*
drop a
*drop _1_text - _7_text
drop location*
drop a*

save "${ddtah}\\hdc.dta", replace


exit


