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

log using "${dlog}\appendspc.log", replace

tempfile spc

********************************************************


***************
*   spc online 
***************

*main wave data

use "${ddata}\online\spw9c.dta", clear
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
ren		Q30_3_2_TEXT		wlcotnapv
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

ren		Q40 	fisadd
ren		Q41		fiip
ren	Q42_1_1_TEXT	fighiy
ren	Q42_1_2_TEXT	fighif
ren	Q42_2_1_TEXT	finhiy
ren	Q42_2_2_TEXT	finhif

ren	Q43	glnl
ren	Q44_1_TEXT	gltww
ren	Q44_2_TEXT	glpcw
ren	Q45_1_TEXT	gltwl
ren	Q45_2_TEXT	glpcl
ren	Q46_1	glfiw
ren	Q46_2	glbl
ren	Q46_3	glpfiw
ren	Q46_4	glgeo
ren	Q46_5	glacsc
ren	Q47_1	glrl_1
ren	Q47_2	glrl_2
ren	Q47_3	glrl_3
ren	Q48_1	glrlpv
ren	Q48_2	glrltv
ren	Q48_3	glrlrs
ren	Q48_4	glrlot
ren	Q48_5	glrlna
ren	Q49	gltps
ren	Q50_1_1_TEXT	gltown1
ren	Q50_1_2_TEXT	glpc1
ren	Q50_2_1_TEXT	gltown2
ren	Q50_2_2_TEXT	glpc2
ren	Q50_3_1_TEXT	gltown3
ren	Q50_3_2_TEXT	glpc3
ren	Q51	glnfive
ren	Q52	glnpast
ren	Q53	glnfund

ren	Q54	fclp
ren	Q55	fcpes
ren	Q56	fcndc
ren	Q57_1_TEXT	fcayna
ren	Q57_2_TEXT	fcc_age_1
ren	Q57_3_TEXT	fcc_age_2
ren	Q57_4_TEXT	fcc_age_3
ren	Q57_5_TEXT	fcc_age_4
ren	Q57_6_TEXT	fcc_age_5
ren	Q57_7_TEXT	fcc_age_6
ren	Q58_1		fcccrf
ren	Q58_2		fcccn
ren	Q58_3		fccccw
ren	Q58_4		fcccdc
ren	Q58_5		fcccna
ren	Q59_1		fcrwncc
ren	Q59_2		fcpwncc
ren	Q59_3		fcoq

ren	Q60			piis
ren	Q61_1		pifayr_tick
ren	Q61_1_TEXT	pifayr
ren	Q61_2		pifryr_tick
ren	Q61_2_TEXT	pifryr
ren	Q61_3		pifyrna
ren	Q62_1_1_TEXT	piqanm
ren	Q62_1_2_TEXT	piqadm
ren	Q62_2_1_TEXT	piqanph
ren	Q62_2_2_TEXT	piqadph
ren	Q62_3_1_TEXT	piqandc
ren	Q62_3_2_TEXT	piqaddc
ren	Q62_4_1_TEXT	piqanf
ren	Q62_4_2_TEXT	piqadf
ren	Q63			pires
ren	Q64_1_TEXT	pioth
ren	Q65			piqonr
ren	Q66_1_1		pimsp_1
ren	Q66_1_2		pisesp_1
ren	Q66_2_1		pimsp_2
ren	Q66_2_2		pisesp_2
ren	Q66_3_1		pimsp_3
ren	Q66_3_2		pisesp_3
ren	Q66_4_1		pimsp_4
ren	Q66_4_2		pisesp_4
ren	Q66_5_1		pimsp_5
ren	Q66_5_2		pisesp_5
ren	Q66_6_1		pimsp_6
ren	Q66_6_2		pisesp_6
ren	Q66_7_1		pimsp_7
ren	Q66_7_2		pisesp_7
ren	Q66_8_1		pimsp_8
ren	Q66_8_2		pisesp_8
ren	Q66_9_1		pimsp_9
ren	Q66_9_2		pisesp_9
ren	Q66_10_1	pimsp_10
ren	Q66_10_2	pisesp_10
ren	Q66_11_1	pimsp_11
ren	Q66_11_2	pisesp_11
ren	Q66_12_1	pimsp_12
ren	Q66_12_2	pisesp_12
ren	Q66_13_1	pimsp_13
ren	Q66_13_2	pisesp_13
ren	Q66_14_1	pimsp_14
ren	Q66_14_2	pisesp_14
ren	Q66_15_1	pimsp_15
ren	Q66_15_2	pisesp_15
ren	Q66_16_1	pimsp_16
ren	Q66_16_2	pisesp_16
ren	Q66_17_1	pimsp_17
ren	Q66_17_2	pisesp_17
ren	Q66_18_1	pimsp_18
ren	Q66_18_2	pisesp_18
ren	Q66_19_1	pimsp_19
ren	Q66_19_2	pisesp_19
ren	Q66_20_1	pimsp_20
ren	Q66_20_2	pisesp_20
ren	Q66_21_1	pimsp_21
ren	Q66_21_2	pisesp_21
ren	Q66_22_1	pimsp_22
ren	Q66_22_2	pisesp_22
ren	Q66_23_1	pimsp_23
ren	Q66_23_2	pisesp_23
ren	Q66_24_1	pimsp_24
ren	Q66_24_2	pisesp_24
ren	Q66_25_1	pimsp_25
ren	Q66_25_2	pisesp_25
ren	Q66_26_1	pimsp_26
ren	Q66_26_2	pisesp_26
ren	Q66_27_1	pimsp_27
ren	Q66_27_2	pisesp_27
ren	Q66_28_1	pimsp_28
ren	Q66_28_2	pisesp_28
ren	Q66_29_1	pimsp_29
ren	Q66_29_2	pisesp_29
ren	Q66_30_1	pimsp_30
ren	Q66_30_2	pisesp_30
ren	Q66_31_1	pimsp_31
ren	Q66_31_2	pisesp_31
ren	Q66_32_1	pimsp_32
ren	Q66_32_2	pisesp_32
ren	Q66_33_1	pimsp_33
ren	Q66_33_2	pisesp_33
ren	Q66_34_1	pimsp_34
ren	Q66_34_2	pisesp_34
ren	Q66_35_1	pimsp_35
ren	Q66_35_2	pisesp_35
ren	Q66_36_1	pimsp_36
ren	Q66_36_2	pisesp_36
ren	Q66_37_1	pimsp_37
ren	Q66_37_2	pisesp_37
ren	Q66_38_1	pimsp_38
ren	Q66_38_2	pisesp_38
ren	Q66_39_1	pimsp_39
ren	Q66_39_2	pisesp_39
ren	Q66_40_1	pimsp_40
ren	Q66_40_2	pisesp_40
ren	Q66_41_1	pimsp_41
ren	Q66_41_2	pisesp_41
ren	Q66_42_1	pimsp_42
ren	Q66_42_2	pisesp_42
ren	Q66_43_1	pimsp_43
ren	Q66_43_2	pisesp_43
ren	Q66_44_1	pimsp_44
ren	Q66_44_2	pisesp_44
ren	Q66_45_1	pimsp_45
ren	Q66_45_2	pisesp_45
ren	Q66_46_1	pimsp_46
ren	Q66_46_2	pisesp_46
ren	Q66_47_1	pimsp_47
ren	Q66_47_2	pisesp_47
ren	Q67_1_TEXT	pindyr
ren	Q67_2_TEXT	pindmt
ren	Q68			pirs
ren	Q69_1		pimrgen
ren	Q69_2		pimrspe
ren	Q69_3		pimrpro
ren	Q69_4		pimrlim
ren	Q69_5		pimrnon
ren	Q70			wlhth
ren	Q71_1		pilfsa
ren	Q72_1		pifirisk
ren	Q72_2		picarisk
ren	Q72_3		piclrisk
ren	Q73_1_1		piin
ren	Q73_1_2		piinf
ren	Q73_1_3		pides
ren	Q73_1_4		pider
ren	Q73_1_5		pidef
ren	Q73_1_6		piviv
ren	Q73_1_7		pivpc
ren	Q73_1_8		pidmn
ren	Q73_2_1_1	piinhl_1
ren	Q73_2_1_2	piinhl_2
ren	Q73_2_1_3	piinhl_3
ren	Q73_2_1_4	piinhl_4
ren	Q73_2_2_1	piinfhl_1
ren	Q73_2_2_2	piinfhl_2
ren	Q73_2_2_3	piinfhl_3
ren	Q73_2_2_4	piinfhl_4
ren	Q73_2_3_1	pideshl_1
ren	Q73_2_3_2	pideshl_2
ren	Q73_2_3_3	pideshl_3
ren	Q73_2_3_4	pideshl_4
ren	Q73_2_4_1	piderhl_1
ren	Q73_2_4_2	piderhl_2
ren	Q73_2_4_3	piderhl_3
ren	Q73_2_4_4	piderhl_4
ren	Q73_2_5_1	pidefhl_1
ren	Q73_2_5_2	pidefhl_2
ren	Q73_2_5_3	pidefhl_3
ren	Q73_2_5_4	pidefhl_4
ren	Q73_2_6_1	pivivhl_1
ren	Q73_2_6_2	pivivhl_2
ren	Q73_2_6_3	pivivhl_3
ren	Q73_2_6_4	pivivhl_4
ren	Q73_2_7_1	pivpchl_1
ren	Q73_2_7_2	pivpchl_2
ren	Q73_2_7_3	pivpchl_3
ren	Q73_2_7_4	pivpchl_4
ren	Q73_2_8_1	pidmnhl_1
ren	Q73_2_8_2	pidmnhl_2
ren	Q73_2_8_3	pidmnhl_3
ren	Q73_2_8_4	pidmnhl_4
ren	Q74			piemail
ren	Q75			furcom


save "`spc'"


*pilot data


*append using "`spc'"
gen sdtype="SP"
gen continue="Continue"
gen response="Online"

renvars _all, lower

drop v* 
drop a_*
drop a
*drop _1_text - _7_text
drop location*
drop a*
save "${ddtah}\\spc.dta", replace

exit


