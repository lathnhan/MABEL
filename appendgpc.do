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

log using "${dlog}\appendgpc.log", replace

tempfile gpc gpcpilot

********************************************************


***************
*   gpc online 
***************

*main wave data

use "${ddata}\online\gpw9c.dta", clear
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
ren		Q6_1		jshp
ren		Q6_2		jsbc
ren		Q6_3		jssn
ren		Q6_4		jsto
ren		Q6_5		jspe
ren		Q6_6		jscp
ren		Q6_7		jsps
ren		Q6_8		jsuh
ren		Q6_9		jssm
ren		Q6_10		jslq
ren		Q6_11		jsco
ren		Q6_12		jsfs
ren		Q6_13		jswl
ren		Q6_14		jslj
ren		Q6_15		jshe
ren		Q7		jsch
ren		Q8		jsred

ren		Q9_1_1_TEXT		pwpish
ren		Q9_2_1_TEXT		pwchh
ren		Q9_3_1_TEXT		pwpuhh
ren		Q9_4_1_TEXT		pwpihh
ren		Q9_5_1_TEXT		pwhfh
ren		Q9_6_1_TEXT		pwahs
ren		Q9_7_1_TEXT		pwgov
ren		Q9_8_1_TEXT		pweih
ren		Q9_9_1_TEXT		pwothh
ren		Q9_10_1_TEXT		pwtoh
ren		Q10_1_1_TEXT		pwnwmf
ren		Q10_1_2_TEXT		pwnwmp
ren		Q10_2_1_TEXT		pwnwff
ren		Q10_2_2_TEXT		pwnwfp
ren		Q11_1_TEXT		pwnwn
ren		Q11_2_TEXT		pwnwap
ren		Q11_3_TEXT		pwnwad
ren		Q11_4_TEXT		pwnwo
ren		Q12		pwcl
ren		Q13		pwbr
ren		Q13_TEXT		pwbr_text
ren		Q14_1_TEXT		pwsmth
ren		Q14_2_TEXT		pwsyr
ren		Q15		pwoce
ren		Q16		pwacc
ren		Q17		pwni
ren		Q18		pwwh
ren		Q19		pwahnc
ren		Q20_1		pwpm_0
ren		Q20_2		pwpm_1
ren		Q20_3		pwpm_2
ren		Q20_4		pwpm_3
ren		Q20_4_TEXT		pwpm_text
ren		Q21_1_TEXT		pwmhn
ren		Q21_2_TEXT		pwmhp
ren		Q22_1_TEXT		pwwyr
ren		Q22_2_TEXT		pwwmth
				
ren		Q23_1_1_TEXT		wlwh
ren		Q23_2_1_TEXT		wldph
ren		Q23_3_1_TEXT		wlidph
ren		Q23_4_1_TEXT		wleh
ren		Q23_5_1_TEXT		wlmh
ren		Q23_6_1_TEXT		wlothh
ren		Q24_1		wltms
ren		Q24_2		wlttr
ren		Q24_3		wltrg
ren		Q24_4		wltnt
ren		Q25_1		wlacto
ren		Q25_2		wlactc
ren		Q25_3		wlactn
ren		Q26_1		wlana
ren		Q26_2		wlobs
ren		Q26_3		wlsur
ren		Q26_4		wleme
ren		Q26_5		wlnon
ren		Q27		wlspint
ren		Q28		wlspmain //create dichotomous variables
ren		Q28_TEXT		wlot_text
ren		Q29		wlprop
ren		Q30_1_TEXT		wlnppc
ren		Q30_2_TEXT		wlnph
ren		Q31_1_TEXT		wlwy
ren		Q31_2_TEXT		wlwod
ren		Q32		wlwd_tick
ren		Q32_TEXT		wlwd
ren		Q33		wlcmin
ren		Q34		wlbbp
ren		Q35		wlcf
ren		Q36		wlah
ren		Q37_1_1_TEXT		wlocrpn
ren		Q37_1_2_TEXT		wlocrhn
ren		Q37_2_1_TEXT		wlocrpe
ren		Q37_2_2_TEXT		wlocrhe
ren		Q37_3_1_TEXT		wlocrnap
ren		Q37_3_2_TEXT		wlocrnah
ren		Q38_1_1_TEXT		wlcotpn
ren		Q38_1_2_TEXT		wlcothn
ren		Q38_2_1_TEXT		wlcotpe
ren		Q38_2_2_TEXT		wlcothe
ren		Q38_3_1_TEXT		wlcotnap
ren		Q38_3_2_TEXT		wlcotnah
ren		Q39		wlocoth
ren		Q40		wlal
ren		Q41_1_TEXT		wlwhpy
ren		Q41_2_TEXT		wlmlpy
ren		Q41_3_TEXT		wlsdpy
ren		Q41_4_TEXT		wlotpy
ren		Q42_5		wlva_tick
ren		Q42_5_TEXT		wlva
ren		Q42_6		wlvau_tick
ren		Q42_6_TEXT		wlvau
ren		Q42_7		wlvadk
ren		Q42_8		wlvana
				
ren		Q43_1_1_TEXT		figey
ren		Q43_1_2_TEXT		figef
ren		Q43_2_1_TEXT		finey
ren		Q43_2_2_TEXT		finef
ren		Q44		fib
ren		Q45		fibv
ren		Q46		fidme_tick
ren		Q46_TEXT		fidme
ren		Q47		fidp_tick
ren		Q47_TEXT		fidp
ren		Q48		fips
*ren		Q49_1_1_TEXT		fispm
*ren		Q49_2_1_TEXT		fisnpm
*ren		Q49_3_1_TEXT		fisgi
*ren		Q49_4_1_TEXT		fishw
*ren		Q49_5_1_TEXT		fisoth
*ren		Q49_6_1_TEXT		fistot
ren		Q49		fisadd
ren		Q50		fiip

ren	Q51_1_1_TEXT	fighiy
ren	Q51_1_2_TEXT	fighif
ren	Q51_2_1_TEXT	finhiy
ren	Q51_2_2_TEXT	finhif

ren	Q52_1_TEXT	gltww
ren	Q52_2_TEXT	glpcw
ren	Q53_1_TEXT	gltwl
ren	Q53_2_TEXT	glpcl
ren	Q54_1	glfiw
ren	Q54_2	glbl
ren	Q54_3	glpfiw
ren	Q54_4	glgeo
ren	Q54_5	glacsc
ren	Q55_1	glrl_1
ren	Q55_2	glrl_2
ren	Q55_3	glrl_3
ren	Q56_1	glrlpv
ren	Q56_2	glrltv
ren	Q56_3	glrlrs
ren	Q56_4	glrlrp
ren	Q56_5	glrlot
ren	Q56_6	glrna
ren	Q57	gltps
ren	Q58_1_1_TEXT	gltown1
ren	Q58_1_2_TEXT	glpc1
ren	Q58_2_1_TEXT	gltown2
ren	Q58_2_2_TEXT	glpc2
ren	Q58_3_1_TEXT	gltown3
ren	Q58_3_2_TEXT	glpc3

ren	Q59	fclp
ren	Q60	fcpes
ren	Q61	fcndc
ren	Q62_1_TEXT	fcayna
ren	Q62_2_TEXT	fcc_age_1
ren	Q62_3_TEXT	fcc_age_2
ren	Q62_4_TEXT	fcc_age_3
ren	Q62_5_TEXT	fcc_age_4
ren	Q62_6_TEXT	fcc_age_5
ren	Q62_7_TEXT	fcc_age_6
ren	Q63_1	fcccrf
ren	Q63_2	fcccn
ren	Q63_3	fccccw
ren	Q63_4	fcccdc
ren	Q63_5	fcccna
ren	Q64_1	fcrwncc
ren	Q64_2	fcpwncc
ren	Q64_3	fcoq
	
ren	Q65	piis
ren	Q66_1	pifayr_tick
ren	Q66_1_TEXT	pifayr
ren	Q66_2	pifryr_tick
ren	Q66_2_TEXT	pifryr
ren	Q66_3	pifyrna
ren	Q67	piqonr
ren	Q68_1_1_TEXT	piqanm
ren	Q68_1_2_TEXT	piqadm
ren	Q68_2_1_TEXT	piqanph
ren	Q68_2_2_TEXT	piqadph
ren	Q68_3_1_TEXT	piqandc
ren	Q68_3_2_TEXT	piqaddc
ren	Q68_4_1_TEXT	piqanf
ren	Q68_4_2_TEXT	piqadf
ren	Q69	pires
ren	Q70_1_TEXT	pioth
ren	Q71_1_1_TEXT	pireyr
ren	Q71_2_1_TEXT	pirps
ren	Q71_3_1_TEXT	pirna
ren	Q72_1_TEXT	pindyr
ren	Q72_2_TEXT	pindmt
ren	Q73	pirs
ren	Q74_1	pimrgen
ren	Q74_2	pimrspe
ren	Q74_3	pimrpro
ren	Q74_4	pimrlim
ren	Q74_5	pimrnon
ren	Q75	wlhth
ren	Q76_1	pilfsa
ren	Q77_1	pifirisk
ren	Q77_2	picarisk
ren	Q77_3	piclrisk
ren	Q78_1_1	piin
ren	Q78_1_2	piinf
ren	Q78_1_3	pides
ren	Q78_1_4	pider
ren	Q78_1_5	pidef
ren	Q78_1_6	piviv
ren	Q78_1_7	pivpc
ren	Q78_1_8	pidmn
ren	Q78_2_1_1	piinhl_1
ren	Q78_2_1_2	piinhl_2
ren	Q78_2_1_3	piinhl_3
ren	Q78_2_1_4	piinhl_4
ren	Q78_2_2_1	piinfhl_1
ren	Q78_2_2_2	piinfhl_2
ren	Q78_2_2_3	piinfhl_3
ren	Q78_2_2_4	piinfhl_4
ren	Q78_2_3_1	pideshl_1
ren	Q78_2_3_2	pideshl_2
ren	Q78_2_3_3	pideshl_3
ren	Q78_2_3_4	pideshl_4
ren	Q78_2_4_1	piderhl_1
ren	Q78_2_4_2	piderhl_2
ren	Q78_2_4_3	piderhl_3
ren	Q78_2_4_4	piderhl_4
ren	Q78_2_5_1	pidefhl_1
ren	Q78_2_5_2	pidefhl_2
ren	Q78_2_5_3	pidefhl_3
ren	Q78_2_5_4	pidefhl_4
ren	Q78_2_6_1	pivivhl_1
ren	Q78_2_6_2	pivivhl_2
ren	Q78_2_6_3	pivivhl_3
ren	Q78_2_6_4	pivivhl_4
ren	Q78_2_7_1	pivpchl_1
ren	Q78_2_7_2	pivpchl_2
ren	Q78_2_7_3	pivpchl_3
ren	Q78_2_7_4	pivpchl_4
ren	Q78_2_8_1	pidmnhl_1
ren	Q78_2_8_2	pidmnhl_2
ren	Q78_2_8_3	pidmnhl_3
ren	Q78_2_8_4	pidmnhl_4
ren	Q79	piemail
ren	Q80	furcom

save "`gpc'"

*append using "`gpc'"
gen sdtype="GP"
gen continue="Continue"
gen response="Online"

renvars _all, lower

drop v* 
drop a_*
drop a
drop a*
*drop _1_text - _7_text
drop location*

save "${ddtah}\\gpc.dta", replace

exit


