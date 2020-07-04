********************************************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
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

log using "${dlog}\appenddec.log", replace

*tempfile online_all pilot_all 

********************************************************


***************
*   dec online 
***************

*main wave data

tempfile dec decpilot
use "${ddata}\online\dew9c.dta", clear

gen source="Main"
renvars _all, upper

ren	V3	id
ren	V8	date
ren	V9	datefinish
ren	Q1	csclid
ren	Q2_1	cspret_1
ren	Q2_2	cspret_2
ren	Q3_1	csncli
ren	Q3_2	csml
ren	Q3_3	cshd
ren	Q3_4	csstu
ren	Q3_5	csexl
ren	Q3_6	csocli
ren	Q3_7	csoncli
ren	Q3_8	csonmd
ren	Q3_9	csnmd
ren	Q3_9_TEXT	csnmd_text
ren	Q4			csrtn
		
ren	Q5_1	jsfm
ren	Q5_2	jsva
ren	Q5_3	jspw
ren	Q5_4	jsau
ren	Q5_5	jscw
ren	Q5_6	jsrc
ren	Q5_7	jshw
ren	Q5_8	jswr
ren	Q5_9	jsrp
ren	Q5_10	jsfl
ren	Q6_1	jsbc
ren	Q6_2	jssn
ren	Q6_3	jsto
ren	Q6_4	jspe
ren	Q6_5	jscp
ren	Q6_6	jsqs
ren	Q6_7	jsst
ren	Q6_8	jspt
ren	Q6_9	jsuh
ren	Q6_10	jslq
ren	Q6_11	jswl
ren	Q6_12	jslj
ren	Q6_13	jshe
ren	Q7	jsch
ren	Q8	jsredt
		
ren	Q9_1_1_TEXT	pwpuhh
ren	Q9_2_1_TEXT	pwpihh
ren	Q9_3_1_TEXT	pwpish
ren	Q9_4_1_TEXT	pwhfh
ren	Q9_5_1_TEXT	pweih
ren	Q9_6_1_TEXT	pwothh
ren	Q9_7_1_TEXT	pwtoh
ren	Q10			pwhlh
ren	Q11_1_TEXT	pwmhn
ren	Q11_2_TEXT	pwmhp
ren	Q12_1_TEXT	pwwyr
ren	Q12_2_TEXT	pwwmth
		
ren	Q13_1_1_TEXT	wlwh
ren	Q13_2_1_TEXT	wldph
ren	Q13_3_1_TEXT	wlidph
ren	Q13_4_1_TEXT	wleh
ren	Q13_5_1_TEXT	wlmh
ren	Q13_6_1_TEXT	wlothh
ren	Q14_1	wltms
ren	Q14_2	wlttr
ren	Q14_3	wltnt
ren	Q15_1	wlacto
ren	Q15_2	wlactc
ren	Q15_3	wlactn
ren	Q16	wlnp
ren	Q17	wlah
ren	Q18_1_TEXT	wlrh
ren	Q18_2_TEXT	wlpch
ren	Q18_3_TEXT	wlcot
ren	Q19			wlocr_tick
ren	Q19_TEXT	wlocr
ren	Q20_1_TEXT	wlwhpy
ren	Q20_2_TEXT	wlmlpy
ren	Q20_3_TEXT	wlsdpy
ren	Q20_4_TEXT	wlotpy
		
ren	Q21_1_1_TEXT	figey
ren	Q21_1_2_TEXT	figef
ren	Q21_2_1_TEXT	finey
ren	Q21_2_2_TEXT	finef
ren	Q22	fib
ren	Q23	fibv
ren	Q24	fidme_tick
ren	Q24_TEXT	fidme
ren	Q25	fiip
ren	Q26	fisadd
ren	Q27_1_1_TEXT	fighiy
ren	Q27_1_2_TEXT	fighif
ren	Q27_2_1_TEXT	finhiy
ren	Q27_2_2_TEXT	finhif
		
ren	Q28_1_TEXT	gltww
ren	Q28_2_TEXT	glpcw
ren	Q29_1_TEXT	gltwl
ren	Q29_2_TEXT	glpcl
ren	Q30_1	glfiw
ren	Q30_2	glbl
ren	Q30_3	glpfiw
ren	Q30_4	glgeo
ren	Q30_5	glacsc
ren	Q31_1	glrl_1
ren	Q31_2	glrl_2
ren	Q31_3	glrl_3
ren	Q32_1	glrlpv
ren	Q32_2	glrltv
ren	Q32_3	glrlrs
ren	Q32_4	glrlrp
ren	Q32_5	glrlot
		
ren	Q33	fclp
ren	Q34	fcpes
ren	Q35	fcndc
ren	Q36_1_TEXT	fcayna
ren	Q36_2_TEXT	fcc_age_1
ren	Q36_3_TEXT	fcc_age_2
ren	Q36_4_TEXT	fcc_age_3
ren	Q36_5_TEXT	fcc_age_4
ren	Q36_6_TEXT	fcc_age_5
ren	Q36_7_TEXT	fcc_age_6
ren	Q37_1	fcccrf
ren	Q37_2	fcccn
ren	Q37_3	fccccw
ren	Q37_4	fcccdc
ren	Q37_5	fcccna
ren	Q38_1	fcrwncc
ren	Q38_2	fcpwncc
ren	Q38_3	fcoq
		
ren	Q39			piis
ren	Q40			picamc
ren	Q41_1		pifayr_tick
ren	Q41_1_TEXT	pifayr
ren	Q41_2		pifryr_tick
ren	Q41_2_TEXT	pifryr
ren	Q41_3		pifyrna
ren	Q42			piqonr
ren	Q43_1_1_TEXT	piqanm
ren	Q43_1_2_TEXT	piqadm
ren	Q43_2_1_TEXT	piqanph
ren	Q43_2_2_TEXT	piqadph
ren	Q43_3_1_TEXT	piqandc
ren	Q43_3_2_TEXT	piqaddc
ren	Q43_4_1_TEXT	piqanf
ren	Q43_4_2_TEXT	piqadf
ren	Q44			pires
ren	Q45_1_TEXT	pioth
ren	Q46_1	piste_1
ren	Q46_2	piste_2
ren	Q46_3	piste_3
ren	Q46_4	piste_4
ren	Q46_5	piste_5
ren	Q46_6	piste_6
ren	Q46_7	piste_7
ren	Q46_8	piste_8
ren	Q46_9	piste_9
ren	Q46_10	piste_10
ren	Q46_11	piste_11
ren	Q46_12	piste_12
ren	Q46_13	piste_13
ren	Q46_14	piste_14
ren	Q46_15	piste_15
ren	Q46_16	piste_16
ren	Q46_17	piste_17
ren	Q46_18	piste_18
ren	Q46_19	piste_19
ren	Q46_20	piste_20
ren	Q46_21	piste_21
ren	Q46_22	piste_22
ren	Q47		pireyr
ren	Q48_1	pisapna
ren	Q48_2	pisaddi
ren	Q48_3	pisapan
ren	Q48_4	pisapde
ren	Q48_5	pisapem
ren	Q48_6	pisapic
ren	Q48_7	pisapma
ren	Q48_8	pisapog
ren	Q48_9	pisapoe
ren	Q48_10	pisapop
ren	Q48_11	pisappc
ren	Q48_12	pisapai
ren	Q48_13	pisappm
ren	Q48_14	pisappa
ren	Q48_15	pisapim
ren	Q48_16	pisapps
ren	Q48_17	pisapph
ren	Q48_18	pisapon
ren	Q48_19	pisapra
ren	Q48_20	pisaprm
ren	Q48_21	pisashm
ren	Q48_22	pisaspo
ren	Q48_23	pisapsu
ren	Q48_24	pisapgp
ren	Q49_1_TEXT	pindyr
ren	Q49_2_TEXT	pindmt
ren	Q50		pirs
ren	Q51_1	pimrgen
ren	Q51_2	pimrspe
ren	Q51_3	pimrpro
ren	Q51_4	pimrlim
ren	Q51_5	pimrnon
ren	Q52		wlhth
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

save "`dec'"

save "${ddtah}\\dec.dta", replace

exit


