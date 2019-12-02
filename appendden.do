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

log using "${dlog}\appendden.log", replace

*tempfile online_all pilot_all 

********************************************************


***************
*   den online 
***************

*main wave data


tempfile den denpilot

use "${ddata}\online\dew9n.dta", clear
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
ren		Q6_13		jshe //order change
ren		Q7		jsch
ren		Q8		jsredt
				
ren		Q9_1_1_TEXT		pwpuhh
ren		Q9_2_1_TEXT		pwpihh
ren		Q9_3_1_TEXT		pwpish
ren		Q9_4_1_TEXT		pwhfh
ren		Q9_5_1_TEXT		pweih
ren		Q9_6_1_TEXT		pwothh
ren		Q9_7_1_TEXT		pwtoh
ren		Q10		pwhlh
ren		Q11_1_TEXT		pwmhn
ren		Q11_2_TEXT		pwmhp
ren		Q12_1_TEXT		pwwyr
ren		Q12_2_TEXT		pwwmth
				
ren		Q13_1_1_TEXT		wlwh
ren		Q13_2_1_TEXT		wldph
ren		Q13_3_1_TEXT		wlidph
ren		Q13_4_1_TEXT		wleh
ren		Q13_5_1_TEXT		wlmh
ren		Q13_6_1_TEXT		wlothh
ren		Q14_1		wltms
ren		Q14_2		wlttr
ren		Q14_3		wltnt
ren		Q15_1		wlacto
ren		Q15_2		wlactc
ren		Q15_3		wlactn
ren		Q16		wlnp
ren		Q17		wlah
ren		Q18_1_TEXT		wlrh
ren		Q18_2_TEXT		wlpch
ren		Q18_3_TEXT		wlcot
ren		Q19_1_TEXT		wlocr     //no wlocr_tick in this version
ren		Q19_2_TEXT		wlocna
ren		Q20_1_TEXT		wlwhpy
ren		Q20_2_TEXT		wlmlpy
ren		Q20_3_TEXT		wlsdpy
ren		Q20_4_TEXT		wlotpy
				
ren		Q21_1_1_TEXT		figey
ren		Q21_1_2_TEXT		figef
ren		Q21_2_1_TEXT		finey
ren		Q21_2_2_TEXT		finef
ren		Q22		fib
ren		Q23		fibv
ren		Q24		fidme_tick
ren		Q24_TEXT		fidme
ren		Q25		fiip
ren		Q26		fisadd
ren		Q27		fics
ren		Q28		ficsyr
ren		Q29		fiefr
ren		Q30_1_1_TEXT		fighiy
ren		Q30_1_2_TEXT		fighif
ren		Q30_2_1_TEXT		finhiy
ren		Q30_2_2_TEXT		finhif
				
ren		Q31_1_TEXT		gltww
ren		Q31_2_TEXT		glpcw
				
				
ren		Q32_1_TEXT		gltwl
ren		Q32_2_TEXT		glpcl
ren		Q33_1		glfiw
ren		Q33_2		glbl
ren		Q33_3		glpfiw
ren		Q33_4		glgeo
ren		Q33_5		glacsc
ren		Q34		glyrrs
ren		Q35_1		glrtw_tick
ren		Q35_1_TEXT		glrtw
ren		Q35_2		glrst_tick
ren		Q35_2_TEXT		glrst
ren		Q35_3		glrna
ren		Q36_1		glrl_1
ren		Q36_2		glrl_2
ren		Q36_3		glrl_3
ren		Q37_1		glrlpv
ren		Q37_2		glrltv
ren		Q37_3		glrlrs
ren		Q37_4		glrlrp
ren		Q37_5		glrlot
				
ren		Q38		fclp
ren		Q39		fcpes
				
				
				
				
ren		Q40		fcpmd
ren		Q41		fcpr_tick
ren		Q41_TEXT		fcpr
ren		Q42_1		fcprt_tick
ren		Q42_1_TEXT		fcprt
ren		Q42_2		fcprs_tick
ren		Q42_2_TEXT		fcprs
ren		Q42_3		fcpr_dk
ren		Q42_4		fcpr_na
ren		Q43		fcndc
ren		Q44_1_TEXT		fcayna
ren		Q44_2_TEXT		fcc_age_1
ren		Q44_3_TEXT		fcc_age_2
ren		Q44_4_TEXT		fcc_age_3
ren		Q44_5_TEXT		fcc_age_4
ren		Q44_6_TEXT		fcc_age_5
ren		Q44_7_TEXT		fcc_age_6
ren		Q45_1		fcccrf
ren		Q45_2		fcccn
ren		Q45_3		fccccw
ren		Q45_4		fcccdc
ren		Q45_5		fcccna
ren		Q46_1		fcrwncc
ren		Q46_2		fcpwncc
ren		Q46_3		fcoq
				
				
ren		Q47		piyrb
ren		Q48		pigen
ren		Q49		picmd
ren		Q50		picmda_tick
ren		Q50_TEXT		picmdo_text
ren		Q51		pims
ren		Q52		piis
ren		Q53		picamc
ren		Q54_1		pifayr_tick
ren		Q54_1_TEXT		pifayr
ren		Q54_2		pifryr_tick
ren		Q54_2_TEXT		pifryr
ren		Q54_3		pifyrna
ren		Q55		piqonr
ren		Q56_1_1_TEXT		piqanm
ren		Q56_1_2_TEXT		piqadm
ren		Q56_2_1_TEXT		piqanph
ren		Q56_2_2_TEXT		piqadph
ren		Q56_3_1_TEXT		piqandc
ren		Q56_3_2_TEXT		piqaddc
ren		Q56_4_1_TEXT		piqanf
ren		Q56_4_2_TEXT		piqadf
ren		Q57		pires
ren		Q58_1_TEXT		pioth
ren		Q59_1		piste_1
ren		Q59_2		piste_2
ren		Q59_3		piste_3
ren		Q59_4		piste_4
ren		Q59_5		piste_5
ren		Q59_6		piste_6
ren		Q59_7		piste_7
ren		Q59_8		piste_8
ren		Q59_9		piste_9
ren		Q59_10		piste_10
ren		Q59_11		piste_11
ren		Q59_12		piste_12
ren		Q59_13		piste_13
ren		Q59_14		piste_14
ren		Q59_15		piste_15
ren		Q59_16		piste_16
ren		Q59_17		piste_17
ren		Q59_18		piste_18
ren		Q59_19		piste_19
ren		Q59_20		piste_20
ren		Q59_21		piste_21
ren		Q59_22		piste_22
ren		Q60		pirsyr
ren		Q61		pireyr
ren		Q62_1		pisapna
ren		Q62_2		pisaddi
ren		Q62_3		pisapan
ren		Q62_4		pisapde
ren		Q62_5		pisapem
ren		Q62_6		pisapic
ren		Q62_7		pisapma
ren		Q62_8		pisapog
ren		Q62_9		pisapom
ren		Q62_10		pisapop
ren		Q62_11		pisappc
ren		Q62_12		pisapai
ren		Q62_13		pisappm
ren		Q62_14		pisappa
ren		Q62_15		pisapim
ren		Q62_16		pisapps
ren		Q62_17		pisapph
ren		Q62_18		pisapon
ren		Q62_19		pisapra
ren		Q62_20		pisaprm
ren		Q62_21		pisashm
ren		Q62_22		pisaspo
ren		Q62_23		pisapsu
ren		Q62_24		pisapgp //order change
ren		Q63_1_TEXT		pindyr
ren		Q63_2_TEXT		pindmt
ren		Q64		pirs
ren		Q65_1		pimrgen
ren		Q65_2		pimrspe
ren		Q65_3		pimrpro
ren		Q65_4		pimrlim
ren		Q65_5		pimrnon
ren		Q66		wlhth
ren		Q67_1		pilfsa
ren		Q68_1		pertj
ren		Q68_2		perct
ren		Q68_3		perrd
ren		Q68_4		peror
ren		Q68_5		perwo
ren		Q68_6		perfr
ren		Q68_7		perlz
ren		Q68_8		persoc
ren		Q68_9		perart
ren		Q68_10		pernev
ren		Q68_11		pereff
ren		Q68_12		perrsv
ren		Q68_13		perknd
ren		Q68_14		perimg
ren		Q68_15		perstr
ren		Q69_1		pilc_1
ren		Q69_2		pilc_2
ren		Q69_3		pilc_3
ren		Q69_4		pilc_4
ren		Q69_5		pilc_5
ren		Q69_6		pilc_6
ren		Q69_7		pilc_7
ren		Q70_1		pifirisk
ren		Q70_2		picarisk
ren		Q70_3		piclrisk
ren		Q71_1_1		piin
ren		Q71_1_2		piinf
ren		Q71_1_3		pides
ren		Q71_1_4		pider
ren		Q71_1_5		pidef
ren		Q71_1_6		piviv
ren		Q71_1_7		pivpc
ren		Q71_1_8		pidmn
ren		Q71_2_1_1		piinhl_1
ren		Q71_2_1_2		piinhl_2
ren		Q71_2_1_3		piinhl_3
ren		Q71_2_1_4		piinhl_4
ren		Q71_2_2_1		piinfhl_1
ren		Q71_2_2_2		piinfhl_2
ren		Q71_2_2_3		piinfhl_3
ren		Q71_2_2_4		piinfhl_4
ren		Q71_2_3_1		pideshl_1
ren		Q71_2_3_2		pideshl_2
ren		Q71_2_3_3		pideshl_3
ren		Q71_2_3_4		pideshl_4
ren		Q71_2_4_1		piderhl_1
ren		Q71_2_4_2		piderhl_2
ren		Q71_2_4_3		piderhl_3
ren		Q71_2_4_4		piderhl_4
ren		Q71_2_5_1		pidefhl_1
ren		Q71_2_5_2		pidefhl_2
ren		Q71_2_5_3		pidefhl_3
ren		Q71_2_5_4		pidefhl_4
ren		Q71_2_6_1		pivivhl_1
ren		Q71_2_6_2		pivivhl_2
ren		Q71_2_6_3		pivivhl_3
ren		Q71_2_6_4		pivivhl_4
ren		Q71_2_7_1		pivpchl_1
ren		Q71_2_7_2		pivpchl_2
ren		Q71_2_7_3		pivpchl_3
ren		Q71_2_7_4		pivpchl_4
ren		Q71_2_8_1		pidmnhl_1
ren		Q71_2_8_2		pidmnhl_2
ren		Q71_2_8_3		pidmnhl_3
ren		Q71_2_8_4		pidmnhl_4
ren		Q72		piemail
ren		Q73		furcom


save "`den'"

*append using "`den'"
gen sdtype="DE"
gen continue="New"
gen response="Online"

renvars _all, lower

drop v* 
drop a_*
drop a
*drop _1_text - _7_text
drop location*

save "${ddtah}\den.dta", replace

exit


