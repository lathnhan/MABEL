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

log using "${dlog}\appendgpn.log", replace

tempfile gpn gpnpilot

********************************************************


***************
*   gpn online 
***************

*main wave data

use "${ddata}\online\gpw9n.dta", clear
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
ren		Q19_1		pwpm_0
ren		Q19_2		pwpm_1
ren		Q19_3		pwpm_3
ren		Q19_4		pwpm_4
ren		Q19_4_TEXT		pwpm_text
ren		Q20_1_TEXT		pwmhn
ren		Q20_2_TEXT		pwmhp
ren		Q21_1_TEXT		pwwyr
ren		Q21_2_TEXT		pwwmth
				
ren		Q22_1_1_TEXT		wlwh
ren		Q22_2_1_TEXT		wldph
ren		Q22_3_1_TEXT		wlidph
ren		Q22_4_1_TEXT		wleh
ren		Q22_5_1_TEXT		wlmh
ren		Q22_6_1_TEXT		wlothh
ren		Q23_1		wltms
ren		Q23_2		wlttr
ren		Q23_3		wltrg
ren		Q23_4		wltnt
ren		Q24_1		wlacto
ren		Q24_2		wlactc
ren		Q24_3		wlactn
ren		Q25_1		wlana
ren		Q25_2		wlobs
ren		Q25_3		wlsur
ren		Q25_4		wleme
ren		Q25_5		wlnon
ren		Q26		wlspint
ren		Q27		wlspmain
ren		Q27_TEXT		wlot_text
ren		Q28		wlprop
ren		Q29_1_TEXT		wlnppc
ren		Q29_2_TEXT		wlnph
ren		Q30_1_TEXT		wlwy
ren		Q30_2_TEXT		wlwod
ren		Q31		wlwd_tick
ren		Q31_TEXT		wlwd
ren		Q32		wlcmin
ren		Q33		wlbbp
ren		Q34		wlcf
ren		Q35		wlah
ren		Q36_1_1_TEXT		wlocrpn
ren		Q36_1_2_TEXT		wlocrhn
ren		Q36_2_1_TEXT		wlocrpe
ren		Q36_2_2_TEXT		wlocrhe
ren		Q36_3_1_TEXT		wlocrnap
ren		Q36_3_2_TEXT		wlocrnah
ren		Q37_1_1_TEXT		wlcotpn
ren		Q37_1_2_TEXT		wlcothn
ren		Q37_2_1_TEXT		wlcotpe
ren		Q37_2_2_TEXT		wlcothe
ren		Q37_3_1_TEXT		wlcotnap
ren		Q37_3_2_TEXT		wlcotnah
ren		Q38		wlocoth
ren		Q39		wlal
ren		Q40_1_TEXT		wlwhpy
ren		Q40_2_TEXT		wlmlpy
ren		Q40_3_TEXT		wlsdpy
ren		Q40_4_TEXT		wlotpy
ren		Q41_1		wlva_tick
ren		Q41_1_TEXT		wlva
ren		Q41_2		wlvau_tick
ren		Q41_2_TEXT		wlvau
ren		Q41_3		wlvadk
ren		Q41_4		wlvana
				
ren		Q42_1_1_TEXT		figey
ren		Q42_1_2_TEXT		figef
ren		Q42_2_1_TEXT		finey
ren		Q42_2_2_TEXT		finef
ren		Q43		fib
ren		Q44		fibv
ren		Q45		fidme_tick
ren		Q45_TEXT		fidme
ren		Q46		fidp_tick
ren		Q46_TEXT		fidp
ren		Q47		fips

ren		Q48_1_1_TEXT		fispm
ren		Q48_2_1_TEXT		fisnpm
ren		Q48_3_1_TEXT		fisgi
ren		Q48_4_1_TEXT		fishw
ren		Q48_5_1_TEXT		fisoth
ren		Q48_6_1_TEXT		fistot
ren		Q49		fisadd
ren		Q50		fics
ren		Q51		ficsyr
ren		Q52		fiefr
ren		Q53		fiip
ren		Q54_1_1_TEXT		fighiy
ren		Q54_1_2_TEXT		fighif
ren		Q54_2_1_TEXT		finhiy
ren		Q54_2_2_TEXT		finhif
				
ren		Q55_1_TEXT		gltww
ren		Q55_2_TEXT		glpcw
				
				
ren		Q56_1_TEXT		gltwl
ren		Q56_2_TEXT		glpcl
ren		Q57_1		glfiw
ren		Q57_2		glbl
ren		Q57_3		glpfiw
ren		Q57_4		glgeo
ren		Q57_5		glacsc
ren		Q58		glyrrs
ren		Q59_1		glrtw_tick
ren		Q59_1_TEXT		glrtw
ren		Q59_2		glrst_tick
ren		Q59_2_TEXT		glrst
ren		Q59_3		glrna
ren		Q60_1		glrl_1
ren		Q60_2		glrl_2
ren		Q60_3		glrl_3
ren		Q61_1		glrlpv
ren		Q61_2		glrltv
ren		Q61_3		glrlrs
ren		Q61_4		glrlrp
ren		Q61_5		glrlot
ren		Q61_6		glrlna
ren		Q62		gltps
ren		Q63_1_1_TEXT		gltown1
ren		Q63_1_2_TEXT		glpc1
ren		Q63_2_1_TEXT		gltown2
ren		Q63_2_2_TEXT		glpc2
ren		Q63_3_1_TEXT		gltown3
ren		Q63_3_2_TEXT		glpc3
				
ren		Q64		fclp
ren		Q65		fcpes
				
				
				
				
ren		Q66		fcpmd
ren		Q67		fcpr_tick
ren		Q67_TEXT		fcpr
ren		Q68_7		fcprt_tick
ren		Q68_7_TEXT		fcprt
ren		Q68_8		fcprs_tick
ren		Q68_8_TEXT		fcprs
ren		Q68_9		fcpr_dk
ren		Q68_10		fcpr_na
ren		Q69		fcndc
ren		Q70_1_TEXT		fcayna
ren		Q70_2_TEXT		fcc_age_1
ren		Q70_3_TEXT		fcc_age_2
ren		Q70_4_TEXT		fcc_age_3
ren		Q70_5_TEXT		fcc_age_4
ren		Q70_6_TEXT		fcc_age_5
ren		Q70_7_TEXT		fcc_age_6
ren		Q71_1		fcccrf
ren		Q71_2		fcccn
ren		Q71_3		fccccw
ren		Q71_4		fcccdc
ren		Q71_5		fcccna
ren		Q72_1		fcrwncc
ren		Q72_2		fcpwncc
ren		Q72_3		fcoq
				
				
ren		Q73		piyrb
ren		Q74		pigen
ren		Q75		picmd
ren		Q76		picmda_tick
ren		Q76_TEXT		picmdo_text
ren		Q77		pims
ren		Q78		piis
ren		Q79		picamc
ren		Q80_1		pifayr_tick
ren		Q80_1_TEXT		pifayr
ren		Q80_2		pifryr_tick
ren		Q80_2_TEXT		pifryr
ren		Q80_3		pifyrna
ren		Q81		piqonr
ren		Q82_1_1_TEXT		piqanm
ren		Q82_1_2_TEXT		piqadm
ren		Q82_2_1_TEXT		piqanph
ren		Q82_2_2_TEXT		piqadph
ren		Q82_3_1_TEXT		piqandc
ren		Q82_3_2_TEXT		piqaddc
ren		Q82_4_1_TEXT		piqanf
ren		Q82_4_2_TEXT		piqadf
ren		Q83		pires
ren		Q84_1_TEXT		pioth
ren		Q85_1_1_TEXT		pirsyr
ren		Q85_2_1_TEXT		pireyr
ren		Q85_3_1_TEXT		pirps
ren		Q85_4_1_TEXT		pirna
ren		Q86_1_TEXT		pindyr
ren		Q86_2_TEXT		pindmt
ren		Q87		pirs
ren		Q88_1		pimrgen
ren		Q88_2		pimrspe
ren		Q88_3		pimrpro
ren		Q88_4		pimrlim
ren		Q88_5		pimrnon
ren		Q89		wlhth
ren		Q90_1		pilfsa
ren		Q91_1		pertj
ren		Q91_2		perct
ren		Q91_3		perrd
ren		Q91_4		peror
ren		Q91_5		perwo
ren		Q91_6		perfr
ren		Q91_7		perlz
ren		Q91_8		persoc
ren		Q91_9		perart
ren		Q91_10		pernev
ren		Q91_11		pereff
ren		Q91_12		perrsv
ren		Q91_13		perknd
ren		Q91_14		perimg
ren		Q91_15		perstr
ren		Q92_1		pilc_1
ren		Q92_2		pilc_2
ren		Q92_3		pilc_3
ren		Q92_4		pilc_4
ren		Q92_5		pilc_5
ren		Q92_6		pilc_6
ren		Q92_7		pilc_7
ren		Q93_1		pifirisk
ren		Q93_2		picarisk
ren		Q93_3		piclrisk
ren		Q94_1_1		piin
ren		Q94_1_2		piinf
ren		Q94_1_3		pides
ren		Q94_1_4		pider
ren		Q94_1_5		pidef
ren		Q94_1_6		piviv
ren		Q94_1_7		pivpc
ren		Q94_1_8		pidmn
ren		Q94_2_1_1		piinhl_1
ren		Q94_2_1_2		piinhl_2
ren		Q94_2_1_3		piinhl_3
ren		Q94_2_1_4		piinhl_4
ren		Q94_2_2_1		piinfhl_1
ren		Q94_2_2_2		piinfhl_2
ren		Q94_2_2_3		piinfhl_3
ren		Q94_2_2_4		piinfhl_4
ren		Q94_2_3_1		pideshl_1
ren		Q94_2_3_2		pideshl_2
ren		Q94_2_3_3		pideshl_3
ren		Q94_2_3_4		pideshl_4
ren		Q94_2_4_1		piderhl_1
ren		Q94_2_4_2		piderhl_2
ren		Q94_2_4_3		piderhl_3
ren		Q94_2_4_4		piderhl_4
ren		Q94_2_5_1		pidefhl_1
ren		Q94_2_5_2		pidefhl_2
ren		Q94_2_5_3		pidefhl_3
ren		Q94_2_5_4		pidefhl_4
ren		Q94_2_6_1		pivivhl_1
ren		Q94_2_6_2		pivivhl_2
ren		Q94_2_6_3		pivivhl_3
ren		Q94_2_6_4		pivivhl_4
ren		Q94_2_7_1		pivpchl_1
ren		Q94_2_7_2		pivpchl_2
ren		Q94_2_7_3		pivpchl_3
ren		Q94_2_7_4		pivpchl_4
ren		Q94_2_8_1		pidmnhl_1
ren		Q94_2_8_2		pidmnhl_2
ren		Q94_2_8_3		pidmnhl_3
ren		Q94_2_8_4		pidmnhl_4
ren		Q95		piemail
ren		Q96		furcom


save "`gpn'"


*pilot data


*append using "`gpn'"
gen sdtype="GP"
gen continue="New"
gen response="Online"

renvars _all, lower

drop v* 
drop a_*
drop a
*drop _1_text - _7_text
drop location*
drop a*
save "${ddtah}\\gpn.dta", replace

exit


