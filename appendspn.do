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

log using "${dlog}\appendspn.log", replace

tempfile spn

********************************************************


***************
*   spn online 
***************

*main wave data

use "${ddata}\online\spw9n.dta", clear
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
ren		Q6_6		jsps
ren		Q6_7		jspu
ren		Q6_8		jsuh
ren		Q6_9		jslq
ren		Q6_10		jswl
ren		Q6_11		jslj
ren		Q6_12		jshe
ren		Q7		jsch
ren		Q8		jsred
ren		Q9_1_1_TEXT		pwpuhh
ren		Q9_2_1_TEXT		pwpihh
ren		Q9_3_1_TEXT		pwpish
ren		Q9_4_1_TEXT		pwhfh
ren		Q9_5_1_TEXT		pwlab
ren		Q9_6_1_TEXT		pwchh
ren		Q9_7_1_TEXT		pwgov
ren		Q9_8_1_TEXT		pweih
ren		Q9_9_1_TEXT		pwothh
ren		Q9_10_1_TEXT		pwtoh
ren		Q10		pwpip

ren		Q11_1_1_TEXT		pwnwmf
ren		Q11_1_2_TEXT		pwnwmp
ren		Q11_2_1_TEXT		pwnwff
ren		Q11_2_2_TEXT		pwnwfp
ren		Q12_1_TEXT		pwnwn
ren		Q12_2_TEXT		pwnwap
ren		Q12_3_TEXT		pwnwad
ren		Q12_4_TEXT		pwnwo
ren		Q13		pwcl
ren		Q14		pwbr
ren		Q14_TEXT		pwbr_text
ren		Q15_1_TEXT		pwsmth
ren		Q15_2_TEXT		pwsyr
ren		Q16		pwhlh
ren		Q17_1_TEXT		pwmhn
ren		Q17_2_TEXT		pwmhp
ren		Q18_1_TEXT		pwwyr
ren		Q18_2_TEXT		pwwmth
ren		Q19_1		pwpm_0
ren		Q19_2		pwpm_1
ren		Q19_3		pwpm_2
ren		Q19_4		pwpm_3
ren		Q19_5		pwpm_4
ren		Q19_5_TEXT		pwpm_text
				
ren		Q20_1_1_TEXT		wlwh
ren		Q20_2_1_TEXT		wldph
ren		Q20_3_1_TEXT		wlidph
ren		Q20_4_1_TEXT		wleh
ren		Q20_5_1_TEXT		wlmh
ren		Q20_6_1_TEXT		wlothh
ren		Q21_1		wltms
ren		Q21_2		wlttr
ren		Q21_3		wltrg
ren		Q21_4		wltnt
ren		Q22_1		wlacto
ren		Q22_2		wlactc
ren		Q22_3		wlactn
ren		Q23_1_TEXT		wlnppc
ren		Q23_2_TEXT		wlnpph
ren		Q23_3_TEXT		wlnprh
ren		Q23_4_TEXT		wlnprr
ren		Q24		wlwd_tick
ren		Q24_TEXT		wlwd
ren		Q25_1		wlcnpmin_tick
ren		Q25_1_TEXT		wlcnpmin
ren		Q25_2		wlcsmin_tick
ren		Q25_2_TEXT		wlcsmin
ren		Q25_3		wlcna
ren		Q26		wlbbp_tick
ren		Q26_TEXT		wlbbp
ren		Q27_1_TEXT		wlcnpf
ren		Q27_2_TEXT		wlcsf
ren		Q27_3_TEXT		wlcfna
ren		Q27_4_TEXT		wlcnpn
ren		Q27_5_TEXT		wlcsn
ren		Q28		wlah
ren		Q29_1_1_TEXT		wlocrpbn
ren		Q29_1_2_TEXT		wlocrpvn
ren		Q29_2_1_TEXT		wlocrpbe
ren		Q29_2_2_TEXT		wlocrpve
ren		Q29_3_1_TEXT		wlocnapb
ren		Q29_3_2_TEXT		wlocnapv

ren		Q30_1_1_TEXT		wlcotpbn
ren		Q30_1_2_TEXT		wlcotpvn
ren		Q30_2_1_TEXT		wlcotpbe
ren		Q30_2_2_TEXT		wlcotpve
ren		Q30_3_1_TEXT		wlcotnapb
ren		Q30_3_2_TEXT		wlcotnapv //NL changed from wlcotnabv
ren		Q31		wlocoth
ren		Q32		wloo
ren		Q33_1_TEXT		wlwhpy
ren		Q33_2_TEXT		wlmlpy
ren		Q33_3_TEXT		wlsdpy
ren		Q33_4_TEXT		wlotpy
ren		Q34_1_1_TEXT		figey
ren		Q34_1_2_TEXT		figef
ren		Q34_2_1_TEXT		finey
ren		Q34_2_2_TEXT		finef
ren		Q35		fib
ren		Q36		fibv
ren		Q37		fidme_tick
ren		Q37_TEXT		fidme
ren		Q38		fidp_tick
ren		Q38_TEXT		fidp
ren		Q39		fips

ren		Q40_1_1_TEXT		fispm
ren		Q40_2_1_TEXT		fisnpm
ren		Q40_3_1_TEXT		fisgi
ren		Q40_4_1_TEXT		fishw
ren		Q40_5_1_TEXT		fisoth
ren		Q40_6_1_TEXT		fisoth_text
ren		Q41		fisadd
ren		Q42		fics
ren		Q43		ficsyr
ren		Q44		fiefr
ren		Q45		fiip
ren		Q46_1_1_TEXT		fighiy
ren		Q46_1_2_TEXT		fighif
ren		Q46_2_1_TEXT		finhiy
ren		Q46_2_2_TEXT		finhif
ren		Q47		glnl
ren		Q48_1_TEXT		gltww
ren		Q48_2_TEXT		glpcw
ren		Q49_1_TEXT		gltwl
ren		Q49_2_TEXT		glpcl

ren		Q50_1		glfiw
ren		Q50_2		glbl
ren		Q50_3		glpfiw
ren		Q50_4		glgeo
ren		Q50_5		glacsc
ren		Q51			glyrrs
ren		Q52_1		glrtw_tick
ren		Q52_1_TEXT	glrtw
ren		Q52_2		glrst_tick
ren		Q52_2_TEXT	glrst
ren		Q52_3		glrna
ren		Q53_1		glrl_1
ren		Q53_2		glrl_2
ren		Q53_3		glrl_3
ren		Q54_1		glrlpv
ren		Q54_2		glrltv
ren		Q54_3		glrlrs
ren		Q54_4		glrlot
ren		Q54_5		glrlna
ren		Q55			gltps
ren		Q56_1_1_TEXT		gltown1
ren		Q56_1_2_TEXT		glpc1
ren		Q56_2_1_TEXT		gltown2
ren		Q56_2_2_TEXT		glpc2
ren		Q56_3_1_TEXT		gltown3
ren		Q56_3_2_TEXT		glpc3
ren		Q57		glnfive
ren		Q58		glnpast
ren		Q59		glnfund
				
ren		Q60			fclp
ren		Q61			fcpes
ren		Q62			fcpmd
ren		Q63			fcpr_tick
ren		Q63_TEXT	fcpr
ren		Q64_1		fcprt_tick
ren		Q64_1_TEXT	fcprt
ren		Q64_2		fcprs_tick
ren		Q64_2_TEXT	fcprs
ren		Q64_3		fcpr_dk
ren		Q64_4		fcpr_na
ren		Q65			fcndc
ren		Q66_1_TEXT		fcayna
ren		Q66_2_TEXT		fcc_age_1
ren		Q66_3_TEXT		fcc_age_2
ren		Q66_4_TEXT		fcc_age_3
ren		Q66_5_TEXT		fcc_age_4
ren		Q66_6_TEXT		fcc_age_5
ren		Q66_7_TEXT		fcc_age_6
ren		Q67_1		fcccrf
ren		Q67_2		fcccn
ren		Q67_3		fccccw
ren		Q67_4		fcccdc
ren		Q67_5		fcccna
ren		Q68_1		fcrwncc
ren		Q68_2		fcpwncc
ren		Q68_3		fcoq
ren		Q69			piyrb

ren		Q70		pigen
ren		Q71		picmd
ren		Q72		picmda_tick
ren		Q72_TEXT		picmdo_text
ren		Q73		pims
ren		Q74		piis
ren		Q75_1		pifayr_tick
ren		Q75_1_TEXT		pifayr
ren		Q75_2		pifryr_tick
ren		Q75_2_TEXT		pifryr
ren		Q75_3		pifyrna
ren		Q76		picamc
ren		Q77		piqonr
ren		Q78_1_1_TEXT		piqanm
ren		Q78_1_2_TEXT		piqadm
ren		Q78_2_1_TEXT		piqanph
ren		Q78_2_2_TEXT		piqadph
ren		Q78_3_1_TEXT		piqandc
ren		Q78_3_2_TEXT		piqaddc
ren		Q78_4_1_TEXT		piqanf
ren		Q78_4_2_TEXT		piqadf
ren		Q79		pires
ren		Q80_1_TEXT		pioth
ren		Q81_1_1		pimsp_1
ren		Q81_1_2		pisesp_1
ren		Q81_2_1		pimsp_2
ren		Q81_2_2		pisesp_2
ren		Q81_3_1		pimsp_3
ren		Q81_3_2		pisesp_3
ren		Q81_4_1		pimsp_4
ren		Q81_4_2		pisesp_4
ren		Q81_5_1		pimsp_5
ren		Q81_5_2		pisesp_5
ren		Q81_6_1		pimsp_6
ren		Q81_6_2		pisesp_6
ren		Q81_7_1		pimsp_7
ren		Q81_7_2		pisesp_7
ren		Q81_8_1		pimsp_8
ren		Q81_8_2		pisesp_8
ren		Q81_9_1		pimsp_9
ren		Q81_9_2		pisesp_9
ren		Q81_10_1		pimsp_10
ren		Q81_10_2		pisesp_10
ren		Q81_11_1		pimsp_11
ren		Q81_11_2		pisesp_11
ren		Q81_12_1		pimsp_12
ren		Q81_12_2		pisesp_12
ren		Q81_13_1		pimsp_13
ren		Q81_13_2		pisesp_13
ren		Q81_14_1		pimsp_14
ren		Q81_14_2		pisesp_14
ren		Q81_15_1		pimsp_15
ren		Q81_15_2		pisesp_15
ren		Q81_16_1		pimsp_16
ren		Q81_16_2		pisesp_16
ren		Q81_17_1		pimsp_17
ren		Q81_17_2		pisesp_17
ren		Q81_18_1		pimsp_18
ren		Q81_18_2		pisesp_18
ren		Q81_19_1		pimsp_19
ren		Q81_19_2		pisesp_19
ren		Q81_20_1		pimsp_20
ren		Q81_20_2		pisesp_20
ren		Q81_21_1		pimsp_21
ren		Q81_21_2		pisesp_21
ren		Q81_22_1		pimsp_22
ren		Q81_22_2		pisesp_22
ren		Q81_23_1		pimsp_23
ren		Q81_23_2		pisesp_23
ren		Q81_24_1		pimsp_24
ren		Q81_24_2		pisesp_24
ren		Q81_25_1		pimsp_25
ren		Q81_25_2		pisesp_25
ren		Q81_26_1		pimsp_26
ren		Q81_26_2		pisesp_26
ren		Q81_27_1		pimsp_27
ren		Q81_27_2		pisesp_27
ren		Q81_28_1		pimsp_28
ren		Q81_28_2		pisesp_28
ren		Q81_29_1		pimsp_29
ren		Q81_29_2		pisesp_29
ren		Q81_30_1		pimsp_30
ren		Q81_30_2		pisesp_30
ren		Q81_31_1		pimsp_31
ren		Q81_31_2		pisesp_31
ren		Q81_32_1		pimsp_32
ren		Q81_32_2		pisesp_32
ren		Q81_33_1		pimsp_33
ren		Q81_33_2		pisesp_33
ren		Q81_34_1		pimsp_34
ren		Q81_34_2		pisesp_34
ren		Q81_35_1		pimsp_35
ren		Q81_35_2		pisesp_35
ren		Q81_36_1		pimsp_36
ren		Q81_36_2		pisesp_36
ren		Q81_37_1		pimsp_37
ren		Q81_37_2		pisesp_37
ren		Q81_38_1		pimsp_38
ren		Q81_38_2		pisesp_38
ren		Q81_39_1		pimsp_39
ren		Q81_39_2		pisesp_39
ren		Q81_40_1		pimsp_40
ren		Q81_40_2		pisesp_40
ren		Q81_41_1		pimsp_41
ren		Q81_41_2		pisesp_41
ren		Q81_42_1		pimsp_42
ren		Q81_42_2		pisesp_42
ren		Q81_43_1		pimsp_43
ren		Q81_43_2		pisesp_43
ren		Q81_44_1		pimsp_44
ren		Q81_44_2		pisesp_44
ren		Q81_45_1		pimsp_45
ren		Q81_45_2		pisesp_45
ren		Q81_46_1		pimsp_46
ren		Q81_46_2		pisesp_46
ren		Q81_47_1		pimsp_47
ren		Q81_47_2		pisesp_47
ren		Q82_1_TEXT		pindyr
ren		Q82_2_TEXT		pindmt
ren		Q83		pirs
ren		Q84_1		pimrgen
ren		Q84_2		pimrspe
ren		Q84_3		pimrpro
ren		Q84_4		pimrlim
ren		Q84_5		pimrnon
ren		Q85		wlhth
ren		Q86_1		pilfsa
ren		Q87_1		pertj
ren		Q87_2		perct
ren		Q87_3		perrd
ren		Q87_4		peror
ren		Q87_5		perwo
ren		Q87_6		perfr
ren		Q87_7		perlz
ren		Q87_8		persoc
ren		Q87_9		perart
ren		Q87_10		pernev
ren		Q87_11		pereff
ren		Q87_12		perrsv
ren		Q87_13		perknd
ren		Q87_14		perimg
ren		Q87_15		perstr
ren		Q88_1		pilc_1
ren		Q88_2		pilc_2
ren		Q88_3		pilc_3
ren		Q88_4		pilc_4
ren		Q88_5		pilc_5
ren		Q88_6		pilc_6
ren		Q88_7		pilc_7
ren		Q89_1		pifirisk
ren		Q89_2		picarisk
ren		Q89_3		piclrisk
ren		Q90_1_1		piin
ren		Q90_1_2		piinf
ren		Q90_1_3		pides
ren		Q90_1_4		pider
ren		Q90_1_5		pidef
ren		Q90_1_6		piviv
ren		Q90_1_7		pivpc
ren		Q90_1_8		pidmn
ren		Q90_2_1_1		piinhl_1
ren		Q90_2_1_2		piinhl_2
ren		Q90_2_1_3		piinhl_3
ren		Q90_2_1_4		piinhl_4
ren		Q90_2_2_1		piinfhl_1
ren		Q90_2_2_2		piinfhl_2
ren		Q90_2_2_3		piinfhl_3
ren		Q90_2_2_4		piinfhl_4
ren		Q90_2_3_1		pideshl_1
ren		Q90_2_3_2		pideshl_2
ren		Q90_2_3_3		pideshl_3
ren		Q90_2_3_4		pideshl_4
ren		Q90_2_4_1		piderhl_1
ren		Q90_2_4_2		piderhl_2
ren		Q90_2_4_3		piderhl_3
ren		Q90_2_4_4		piderhl_4
ren		Q90_2_5_1		pidefhl_1
ren		Q90_2_5_2		pidefhl_2
ren		Q90_2_5_3		pidefhl_3
ren		Q90_2_5_4		pidefhl_4
ren		Q90_2_6_1		pivivhl_1
ren		Q90_2_6_2		pivivhl_2
ren		Q90_2_6_3		pivivhl_3
ren		Q90_2_6_4		pivivhl_4
ren		Q90_2_7_1		pivpchl_1
ren		Q90_2_7_2		pivpchl_2
ren		Q90_2_7_3		pivpchl_3
ren		Q90_2_7_4		pivpchl_4
ren		Q90_2_8_1		pidmnhl_1
ren		Q90_2_8_2		pidmnhl_2
ren		Q90_2_8_3		pidmnhl_3
ren		Q90_2_8_4		pidmnhl_4
ren		Q91		piemail
ren		Q92		furcom


save "`spn'"

*save "${ddata}\online\spnw8pilot.dta", replace

*append using "`spn'"
gen sdtype="SP"
gen continue="New"
gen response="Online"

renvars _all, lower

drop v* 
drop a_*
drop a
*drop _1_text - _7_text
drop location*
drop a*

save "${ddtah}\\spn.dta", replace

exit


