
*Purpose: standardise all missing values

********************************************************

global ddtah="D:\Data\Data Clean\Wave9\dtah"
global ddo="D:\Data\Data Clean\Wave9"
global dlog="D:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\missing_value.log", replace

*Comments add by Wenda: this do file standardises all missing values across all variables, 
*make sure assign the right missing value codes for not applicable/don't know/and other cases
*also check up number of missing values for all variables comparing to the previous years'

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************
renvars _all, lower

*admin variables

drop dtbatch dtserial dummy


replace sdtype=-1 if response==.
replace source=-1 if source==.
replace continue=1 if continue==.

replace continue=1 if continue==0&cohort!=2016
*replace continue=0 if continue==1&cohort==2013



replace t2response=-4 if t2response==.
replace response=4 if response==.

*label de mode 4 "AMPCo database", add encode

label var dtimage "Hardcopy image"

*************************************************

*cs

preserve

drop *_text *_country *_multi* *_flag*  piqadf  gltww gltwl glrtw glrst /// 
	 fcprt fcprs pwmhn piemail furcom wlocoth 

desc cs*, varlist

restore

foreach x in `r(varlist)' {

codebook `x'

}

/* NO MISSING VALUES FOUND*/

*************************************************

*js

foreach x of var jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl jsbc jssn jsto jshe jspe jscp jsuh jslq jswl jslj jsch {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var jshp jssm jsco jsfs {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var jsqs jsst jspt {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==2|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace jspu=-1 if (jspu==.|jspu==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace jspu=-2 if jspu==.

foreach x of var jsas jsbsyr jsbsdk jssc jsmapna jssc6 jsscg{
replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==2|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.
}

replace jsred=-1 if (jsred==.|jsred==-2)&(sdtype==4|sdtype==-1|response==3)
replace jsred=-2 if jsred==.

replace jsredt=-1 if (jsredt==.|jsredt==-2)&(sdtype==1|sdtype==2|sdtype==3|sdtype==-1|response==3)
replace jsredt=-2 if jsredt==.


foreach x of var  jsmaddi jsmapan jsmapde jsmapem jsmapgp jsmapic jsmapma jsmapog jsmapom jsmapop ///
			jsmappc jsmapai jsmappm jsmappa jsmaphy jsmapps jsmapph jsmapon jsmapra jsmaprm ///
			jsmashm jsmaspo jsmapsu jsmaoth jsmapna {
				 
replace `x' = -1 if sdtype!=3
replace `x'= -3 if jsmapna==1 & sdtype==3
replace `x'= -2 if jsmsome!=1 & `x'==. &sdtype==3
replace `x'=0 if jsmsome==1 & `x'==. &sdtype==3
}

*drop jsmsome

replace jsps=-1 if (jsps==.|jsps==-2|jsps==-3)&(sdtype==-1|sdtype==3|sdtype==4|response==3)
replace jsps=-2 if jsps==.

replace jsbsyr=-4 if jsbsyr==-2&jsbsdk==1
*replace jsbsyr=-3 if jsbsyr==-2&jsbsna==1

replace jsbsdk=0 if jsbsdk==-2&jsbsyr>=0
*replace jsbsna=0 if jsbsna==-2&jsbsyr>=0

*replace jsbsna=-1 if (jsbsna==.|jsbsna==-2)&(sdtype==-1|sdtype==2|sdtype==2|sdtype==4)
*replace jsbsna=-2 if jsbsna==.

*replace jsmena=0 if jsmena==-2&jsmle!=""



*************************************************

*pw

preserve

drop *_text *_multi* *_1 *_2 *_3 *_4 *_5 *_flag*
keep pw*

desc _all, varlist

restore

foreach x of var pwpuhh pwpihh pwpish pwhfh pweih pwothh pwtoh {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var pwchh pwgov {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace pwahs=-1 if (pwahs==.|pwahs==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace pwahs=-2 if pwahs==.

replace pwlab=-1 if (pwlab==.|pwlab==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace pwlab=-2 if pwlab==.

replace pwpip=-1 if (pwpip==.|pwpip==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace pwpip=-2 if pwpip==.

foreach x of var pwnwmf pwnwff pwnwmp pwnwfp pwnwn pwnwap pwnwad pwnwo pwcl {

replace `x'=-1 if (`x'==.|`x'==-2)&((sdtype==3|sdtype==4|sdtype==-1|response==3)|(sdtype==2&(pwpip==2|pwpip==0)))
replace `x'=-2 if `x'==.

}

replace pwbr=-1 if (pwbr==.|pwbr==-2)&((sdtype==3|sdtype==4|sdtype==-1|response==3)|(sdtype==2&pwpip==0))
replace pwbr=-2 if pwbr==.

foreach x of var pwsmth pwsyr {

replace `x'=-1 if (`x'==.|`x'==-2)&((sdtype==3|sdtype==4|sdtype==-1|response==3|continue==1)|(sdtype==2&pwpip==0))
replace `x'=-2 if `x'==.

}

replace pwoce=-1 if (pwoce==.|pwoce==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)
replace pwoce=-2 if pwoce==.

foreach x of var pwwh pwni pwacc {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace pwhlh=-1 if (pwhlh==.|pwhlh==-2)&(sdtype==1|sdtype==3|sdtype==-1|response==3)
replace pwhlh=-2 if pwhlh==.

foreach x of var pwwmth pwwyr {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3|continue==1|sdtype==2|sdtype==3|sdtype==4)
replace `x'=-2 if `x'==.

}

replace pwahnc=-1 if (pwahnc==.|pwahnc==-2)&(sdtype==-1|response==3|continue==0|sdtype==2|sdtype==3|sdtype==4|pwwh==0)
replace pwahnc=-2 if pwahnc==.


foreach x of var pwmhp pwmhpasgc pwmhprrma pwmhmmm {

replace `x'=-1 if (`x'==.|`x'==-2)&((sdtype==-1|response==3)|(sdtype==1&pwahnc==1)|(sdtype==1&pwwh==0))
replace `x'=-2 if `x'==.

}

replace pwsp=-1 if (pwsp==.|pwsp==-2)&(sdtype==1|sdtype==2|sdtype==4|sdtype==-1|response==3)
replace pwsp=-2 if pwsp==.

replace pwpm=-1 if (pwpm==.|pwpm==-2)&(sdtype==-1|sdtype==3|sdtype==4|(sdtype==1&pwahnc==1)|pwwh==0)
replace pwpm=-2 if pwpm==.

********************************************************

*wl

foreach x of var wlwh wldph wlidph wleh wlmh wlothh wlwhpy wlmlpy wlsdpy wlotpy wlah  {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var wltms wlttr wltnt {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==3|sdtype==-1|response==3)
replace `x'=-2 if (wltms==.|wltms==-2)&(wlttr==.|wlttr==-2)&(wltnt==.|wltnt==-2)

}

replace wltrg=-1 if (wltrg==.|wltrg==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)
replace wltrg=-2 if wltrg==.

foreach x of var wltms wlttr wltrg {

replace `x'=0 if `x'<0&wltnt==1

}

replace wlactn=0 if wlactc==1 | wlacto==1

foreach x of var wlactc wlacto wlactn {
replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if wlactc!=1 & wlacto!=1 & wlactn!=1
}

foreach x of var wlana wlobs wlsur wleme wlnon wlspint{

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var wlante wlwom wlpsych wlskin wlchild wlsport wlotspe wlprop{

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=0 if `x'==.
replace `x'=-3 if wlspint==0

}

foreach x of var wlana wlobs wlsur wleme {

replace `x'=0 if `x'<0&wlnon==1

}

replace wlnppc=-1 if (wlnppc==.|wlnppc==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)
replace wlnppc=-2 if wlnppc==.

foreach x of var wlnpph wlnprh wlnprr {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace wlnph=-1 if (wlnph==.|wlnph==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace wlnph=-2 if wlnph==.

replace wlnp=-1 if (wlnp==.|wlnp==-2)&(sdtype==1|sdtype==2|sdtype==-1|response==3)
replace wlnp=-2 if wlnp==.

foreach x of var wlwy wlwod {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var wlwd wlww wlnt {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace wlna=-1 if (wlna==.|wlna==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace wlna=-2 if wlna==.

foreach x of var wlwd wlww {

replace `x'=-3 if `x'<0&(wlnt==1|wlna==1)

}

foreach x of var wlcmin wlcf {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace wlbbp=-1 if (wlbbp==.|wlbbp==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)
replace wlbbp=-2 if wlbbp==.

foreach x of var wlcnpmin wlcsmin wlcna wlcnpf wlcsf wlcfna wlbpna {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var wlcnpmin wlcsmin {

replace `x'=-3 if `x'<0&wlcna==1

}

foreach x of var wlcnpf wlcsf {

replace `x'=-3 if `x'<0&wlcfna==1

}

replace wlbbp=-3 if wlbbp<0&wlbpna==1

foreach x of var wlocrpn wlocrpe wlocrnap wlocrhn wlocrhe wlocrnah wlcotpn wlcotpe wlcotnap wlcothn wlcothe wlcotnah {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3|wlah==0)
replace `x'=-2 if `x'==.

}

foreach x of var wlocot{

replace wlocot=-1 if (wlocot==.|wlocot==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3|wlah==0)
replace wlocot=-2 if wlocot==.

}

replace wlocrpn=-3 if wlocrpn<0&wlocrnap==1
replace wlocrpe=-3 if wlocrpe<0&wlocrnap==1
replace wlocrhn=-3 if wlocrhn<0&wlocrnah==1
replace wlocrhe=-3 if wlocrhe<0&wlocrnah==1

replace wlcotpn=-3 if wlcotpn<0&wlcotnap==1
replace wlcotpe=-3 if wlcotpe<0&wlcotnap==1
replace wlcothn=-3 if wlcothn<0&wlcotnah==1
replace wlcothe=-3 if wlcothe<0&wlcotnah==1

foreach x of var wlocrpbn wlocrpbe wlocnapb wlocrpvn wlocrpve wlocnapv wlcotpbn wlcotpbe wlcotnapb wlcotpvn wlcotpve wlcotnapv {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3|wlah==0)
replace `x'=-2 if `x'==.

}

replace wlocrpbn=-3 if wlocrpbn<0&wlocnapb==1
replace wlocrpbe=-3 if wlocrpbe<0&wlocnapb==1
replace wlocrpvn=-3 if wlocrpvn<0&wlocnapv==1
replace wlocrpve=-3 if wlocrpve<0&wlocnapv==1

replace wlcotpbn=-3 if wlcotpbn<0&wlcotnapb==1
replace wlcotpbe=-3 if wlcotpbe<0&wlcotnapb==1
replace wlcotpvn=-3 if wlcotpvn<0&wlcotnapv==1
replace wlcotpve=-3 if wlcotpve<0&wlcotnapv==1

foreach x of var wlocr wlocna wlrh wlpch wlcot {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==2|sdtype==-1|response==3|wlah==0)
replace `x'=-2 if `x'==.

}



replace wlocr=-3 if wlocr<0&wlocna==1

replace wlal=-1 if (wlal==.|wlal==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace wlal=-2 if wlal==.

foreach x of var wlva wlvadk wlvana wlvau {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace wlva=-3 if wlva<0&wlvana==1
replace wlvau=-3 if wlvau<0&wlvana==1
replace wlva=-4 if wlva!=-3&wlva<0&wlvana==1
replace wlvau=-4 if wlvau!=-3&wlvau<0&wlvana==1
replace wlvau=-1 if wlvau<0&wlva==0

********************************************************************

*fi

foreach x of var figey figef finey finef fib fibv fidme fisadd fimedk  fiip fighiy fighif finhiy finhif {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace ficsyr=-1 if (ficsyr==.|ficsyr==-2)&(sdtype==-1|response==3|continue==1)
replace ficsyr=-3 if fics==0

*fioti not in w6

foreach x of var fidp fidpdk fidpna fips {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace figey=-1 if figey==-2&figef>=0&finef>=0
replace finey=-1 if finey==-2&figef>=0&finef>=0
replace figef=-1 if figef==-2&figey>=0&finey>=0
replace finef=-1 if finef==-2&figey>=0&finey>=0

replace fighiy=-1 if fighiy==-2&fighif>=0&finhif>=0
replace finhiy=-1 if finhiy==-2&fighif>=0&finhif>=0
replace fighif=-1 if fighif==-2&fighiy>=0&finhiy>=0
replace finhif=-1 if finhif==-2&fighiy>=0&finhiy>=0

replace fibv=-1 if fibv==-2&fib==0
replace fidme=-4 if fidme==-2&fimedk==1
replace fidp=-4 if fidp==-2&fidpdk==1
replace fidp=-3 if fidp==-2&fidpna==1

*replace ficsyr=-1 if fics==0


foreach x of var fispm fisnpm fisgi fishw fisoth {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|sdtype==3|sdtype==4|response==3)
replace `x'=-2 if `x'==.

}

replace fisadd=-1 if fisadd==-2 & (fisoth==-1|fisadd==0) 
*********************************************************************

*gl

replace glnl=-1 if (glnl==.|glnl==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace glnl=-2 if glnl==.

foreach x of var glpcw gltwwasgc gltwwrrma gltwwmmm glpcl gltwlasgc gltwlrrma gltwlmmm glfiw glbl glpfiw glgeo glacsc glyrrs /// 
				 glrtwasgc glrtwrrma glrtwmmm glrna glrl glrlpv glrltv glrlrs glrlot glrlna {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace glrlrp=-1 if (glrlrp==.|glrlrp==-2)&(sdtype==2|sdtype==-1|response==3)
replace glrlrp=-2 if glrlrp==.

replace glrtwasgc=-3 if glrtwasgc==-2&glrna==1
replace glrtwrrma=-3 if glrtwrrma==-2&glrna==1
replace glrtwmmm=-3 if glrtwmmm==-2&glrna==1

foreach x of var glrlpv glrltv glrlrs glrlrp glrlot glrlna {

replace `x'=-1 if `x'==-2&glrl==0
replace `x'=-3 if `x'==-2&glrlna==1

}

replace gltps=-1 if (gltps==.|gltps==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace gltps=-2 if gltps==.

foreach x of var glpc1 glpc2 glpc3 ///
				 glout1asgc glout1rrma glout1mmm glout2asgc glout2rrma glout2mmm glout3asgc glout3rrma glout3mmm {
				 
replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==3|sdtype==4|sdtype==-1|response==3)	
replace `x'=-3 if gltps==0 & `x'==.
replace `x'=-2 if `x'==.
}

foreach x of var glnfive glnpast glnfund {
replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
*replace `x'=-3 if glnonm==1 & `x'==.
replace `x'=-2 if `x'==.
}	

replace glnfund= -3 if (glnfund<0|glnfund==.)	& glnpast==0			 
*******************************************************************

*fc

preserve

drop *_text *_multi* fcprt fcprs *_1 *_2 *_3 *_4 *_5 *_flag*
keep fc*

desc _all, varlist

restore

foreach x in `r(varlist)' {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace fcpr=-3 if fcpr==-2&fcpr_na==1
replace fcpr=-4 if fcpr==-2&fcpr_dk==1

replace fcprtasgc=-3 if fcprtasgc==-2&fcprt_na==1
replace fcprtrrma=-3 if fcprtrrma==-2&fcprt_na==1
replace fcprtasgc=-4 if fcprtasgc==-2&fcprt_dk==1
replace fcprtrrma=-4 if fcprtrrma==-2&fcprt_dk==1

replace fcayna=1 if fcndc==0&fcayna==-2

foreach x of num 1/6 {

replace fcc_age_`x' = -3 if (fcayna==1|fcndc==0)&fcc_age_`x'==-2

local j = `x' + 1

capture confirm var fcc_age_`j'

if !_rc {

replace fcc_age_`j' = -3 if fcc_age_`j'==-2&(fcc_age_`x'>=0|fcc_age_`x'==-3)

}

else {

}

}

foreach x of var fcccrf fcccn fccccw fcccdc {
replace `x'=-1 if `x'==-2 & fcndc<1
}





******************************************************

*pi

ren wlhth pihth

foreach x of var piyrbi pigeni piagei picmd picmda picmdo picmdoi pims picamc piqonr pindyr pindmt pirs pihth pilfsa /// 
				piqanm piqanph piqandc piqanf piis pifayr pifryr pifyrna pioth pires {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace pifyrna=-3 if pifryr==3
replace pifyrna=0 if pifryr>-2 & pifryr<.

foreach x of var piste piste6 pisteg pisapna pisaddi pisappc pisappm pisaprm pisapde pisapma pisapop pisapps pisapsu pisapim pisapom pisapph /// 
				 pisapps pisapan pisapem pisapic pisapog pisappa pisapra pisashm pisapim pisapai pisapon pisaspo {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==2|sdtype==3|sdtype==-1|response==3)
replace `x'=0 if `x'==.

}

foreach x of var pisapna pisaddi pisappc pisappm pisaprm pisapde pisapma pisapop pisapps pisapsu pisapim pisapom pisapph /// 
				 pisapps pisapan pisapem pisapic pisapog pisappa pisapra pisashm pisapim pisapai pisapon pisaspo {

replace `x'=0 if `x'==-2

}


foreach x of var pimsp6 pisesp6 pimspx pisespx pimspgx pisespgx {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

foreach x of var pirsyr pireyr {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==2|sdtype==3|sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace pirna=-1 if (pirna==.|pirna==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace pirna=-2 if pirna==.

replace pirsyr=-3 if pirsyr==-2&pirna==1
replace pireyr=-3 if pireyr==-2&pirna==1

/* pisp - just in pilot of wave5
replace pisp=-1 if (pisp==.|pisp==-2)&(sdtype==1|sdtype==2|sdtype==3|sdtype==-1|response==3)
replace pisp=-2 if pisp==.
replace pisp=-3 if pisp==-2&pirna==1*/

replace pirps=-1 if (pirps==.|pirps==-2)&(sdtype==2|sdtype==3|sdtype==4|sdtype==-1|response==3)
replace pirps=-2 if pirps==.
replace pirps=-3 if pirps==-2&pirna==1

foreach x of var pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 pertj perct perrd peror perwo /// 
				 perfr perlz persoc perart pernev pereff perrsv perknd perimg perstr {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3|continue==1)
replace `x'=-2 if `x'==.

}

foreach x of var piin piinf pides pider pidef piviv pivpc pidmn {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

replace `x'hl=-1 if (`x'hl==.|`x'hl==-2)&(sdtype==-1|response==3)
replace `x'hl=-2 if `x'hl==.

replace `x'hl=-1 if `x'hl==-2&`x'==0

}

foreach x of var pifirisk picarisk piclrisk {

replace `x'=-1 if (`x'==.|`x'==-2)&(sdtype==-1|response==3)
replace `x'=-2 if `x'==.

}

replace picmda=0 if picmda<0&picmdo==1
replace picmdo=0 if picmdo<0&picmda==1

foreach x of var pimrgen pimrspe pimrpro pimrlim pimrnon {

replace `x'=-1 if `x'==.&(sdtype==-1|response==3)
replace `x'=0 if `x'==.

}

***********************************************************

*impute specialty variable pimsp from AMPCo for those with missing code -2

preserve

tempfile speampco

use "D:\Data\Samples\Wave 9\Alldocs2016\Alldocs2016.dta", clear

keep listeeid doctormedicaldiscipline

ren doctormedicaldiscipline specialty

save "`speampco'"

restore

gen pimspi = pimsp6

merge 1:1 listeeid using "`speampco'", keep(master match) nogen


replace pimspi=0 if pimsp6==-2&specialty=="Cardiology"
replace pimspi=1 if pimsp6==-2&specialty=="Genetics"
replace pimspi=2 if pimsp6==-2&specialty=="Clinical Pharmacology"
replace pimspi=3 if pimsp6==-2&specialty=="Endocrinology"
replace pimspi=4 if pimsp6==-2&specialty=="Gastroenterology"
replace pimspi=5 if pimsp6==-2&specialty=="Physician"
replace pimspi=6 if pimsp6==-2&specialty=="Geriatric Medicine"
replace pimspi=7 if pimsp6==-2& specialty=="Clinical Haematology"
replace pimspi=8 if pimsp6==-2&specialty=="Immunology & Allergy"
replace pimspi=9 if pimsp6==-2&specialty=="Infectious Diseases"
replace pimspi=10 if pimsp6==-2&specialty=="Medical Oncology"
replace pimspi=11 if pimsp6==-2&specialty=="Neurology"
replace pimspi=12 if pimsp6==-2&specialty=="Nuclear Medicine"
replace pimspi=13 if pimsp6==-2&specialty=="Renal Medicine"
replace pimspi=14 if pimsp6==-2&specialty=="Rheumatology"
replace pimspi=15 if pimsp6==-2&specialty=="Respiratory Medicine"
replace pimspi=16 if pimsp6==-2&specialty=="Surgery - General"
replace pimspi=17 if pimsp6==-2&specialty=="Surgery - Cardio-Thoracic"
replace pimspi=18 if pimsp6==-2&specialty=="Surgery - Oral Maxillofacial"
replace pimspi=19 if pimsp6==-2&specialty=="Surgery - Orthopaedic"
replace pimspi=20 if pimsp6==-2&specialty=="Surgery - Ent Head & Neck"
replace pimspi=21 if pimsp6==-2&specialty=="Surgery - Paediatric"
replace pimspi=22 if pimsp6==-2&specialty=="Surgery - Plastic & Reconst"
replace pimspi=23 if pimsp6==-2&specialty=="Urology"
replace pimspi=24 if pimsp6==-2&specialty=="Surgery - Neurosurgery"
replace pimspi=25 if pimsp6==-2&specialty=="Surgery - Vascular"
replace pimspi=26 if pimsp6==-2&specialty=="Alcohol & Drug Depd'cy/Rehab"
replace pimspi=27 if pimsp6==-2&specialty=="Anaesthesia"
replace pimspi=28 if pimsp6==-2&specialty=="Dermatology"
replace pimspi=29 if pimsp6==-2&specialty=="Emergency Medicine"
replace pimspi=30 if pimsp6==-2&specialty=="Intensive Care"
replace pimspi=32 if pimsp6==-2&specialty=="Gynaecology"|specialty=="Obstetrics & Gynaecology"
replace pimspi=33 if pimsp6==-2&specialty=="Occupational Medicine"
replace pimspi=34 if pimsp6==-2&specialty=="Ophthalmology"
replace pimspi=35 if pimsp6==-2&specialty=="Paediatric Medicine"|specialty=="Adolescent Medicine"

replace pimspi=37 if pimsp6==-2&specialty=="Palliative Medicine"
replace pimspi=38 if pimsp6==-2&specialty=="Anatomical Pathology"|specialty=="Chemical Pathology"|specialty=="Cytopathology" ///
   |specialty=="Forensic Pathology"|specialty=="Pathology"|specialty=="Haematology"|specialty=="Microbiology"
replace pimspi=39 if pimsp6==-2&specialty=="Psychiatry"
replace pimspi=41 if pimsp6==-2&specialty=="Diagnostic Radiology"
replace pimspi=42 if pimsp6==-2&specialty=="Radiation Oncology"
replace pimspi=43 if pimsp6==-2&specialty=="Rehabilitation"
replace pimspi=44 if pimsp6==-2&specialty=="Sexual Health"
replace pimspi=45 if pimsp6==-2&specialty=="Sports Medicine"
replace pimspi=46 if pimsp6==-2&specialty=="Medical Officer"|specialty=="Epidemiology"


*Don't know how to code adolescent medicine, aviation medicine, child psychiatry, clinical chemistry,  cosmetic medicine, diabetes, 
*diagnostic ultrasound, epidemiology, gynaecological oncology, medical officer, microbiology, neonatal medicine, 
*physical medicine, physician, practising, 



replace pimspx = 0 if pimspi==0 & pimspx==.
replace pimspx = 1 if pimspi==1 & pimspx==.
replace pimspx = 4 if pimspi==2 & pimspx==.
replace pimspx = 5 if pimspi==3 & pimspx==.
replace pimspx = 6 if pimspi==4 & pimspx==.
replace pimspx = 7 if pimspi==5 & pimspx==.
replace pimspx = 8 if pimspi==6 & pimspx==.
replace pimspx = 2 if pimspi==7 & pimspx==.
replace pimspx = 3 if pimspi==8 & pimspx==.
replace pimspx = 9 if pimspi==9 & pimspx==.
replace pimspx = 11 if pimspi==10 & pimspx==.
replace pimspx = 12 if pimspi==11 & pimspx==. 
replace pimspx = 13 if pimspi==12 & pimspx==.
replace pimspx = 15 if pimspi==13 & pimspx==.
replace pimspx = 16 if pimspi==14 & pimspx==.
replace pimspx = 17 if pimspi==15 & pimspx==.
replace pimspx = 19 if pimspi==16 & pimspx==.
replace pimspx = 20 if pimspi==17 & pimspx==. 
replace pimspx = 42 if pimspi==18 & pimspx==.
replace pimspx = 21 if pimspi==19 & pimspx==.
replace pimspx = 22 if pimspi==20 & pimspx==.
replace pimspx = 23 if pimspi==21 & pimspx==.
replace pimspx = 24 if pimspi==22 & pimspx==.
replace pimspx = 25 if pimspi==23 & pimspx==.
replace pimspx = 26 if pimspi==24 & pimspx==.
replace pimspx = 27 if pimspi==25 & pimspx==.
replace pimspx = 42 if pimspi==26 & pimspx==.
replace pimspx = 28 if pimspi==27 & pimspx==. 
replace pimspx = 29 if pimspi==28 & pimspx==.
replace pimspx = 31 if pimspi==29 & pimspx==.
replace pimspx = 10 if pimspi==30 & pimspx==.
replace pimspx = 32 if pimspi==31 & pimspx==.
replace pimspx = 33 if pimspi==32 & pimspx==. 
replace pimspx = 34 if pimspi==33 & pimspx==.
replace pimspx = 35 if pimspi==34 & pimspx==.
replace pimspx = 14 if pimspi==35 & pimspx==. 
replace pimspx = 42 if pimspi==36 & pimspx==.
replace pimspx = 41 if pimspi==37 & pimspx==.
replace pimspx = 18 if pimspi==38 & pimspx==.
replace pimspx = 36 if pimspi==39 & pimspx==.
replace pimspx = 37 if pimspi==40 & pimspx==.
replace pimspx = 30 if pimspi==41 & pimspx==.
replace pimspx = 38 if pimspi==42 & pimspx==.
replace pimspx = 39 if pimspi==43 & pimspx==.
replace pimspx = 42 if pimspi==44 & pimspx==.
replace pimspx = 40 if pimspi==45 & pimspx==.
replace pimspx = 42 if pimspi==46 & pimspx==.


rename pimspi pimsp6i
label var pimspx "Cross-wave specialty variable"
label var pimsp6i "(wave 6) The main specialty in which you practise (imputed)"
label val pimsp6i specialty6

drop specialty



***********************************************************

*standardise missing codes for variables within the same sub-question

*jsbsyr/jsbsna/jsbsdk
*jsbsna not in wv6

*replace jsbsyr=-3 if jsbsyr==-2&jsbsna==1
replace jsbsyr=-4 if jsbsyr==-2&jsbsdk==1
*replace jsbsna=0 if jsbsna==-2&jsbsyr>0
replace jsbsdk=0 if jsbsdk==-2&jsbsyr>0

*pwnwmf/pwnwmp/pwnwff/pwnwfp

gen allmiss=(pwnwmf==-2&pwnwmp==-2&pwnwff==-2&pwnwfp==-2)

foreach x of var pwnwmf pwnwmp pwnwff pwnwfp {

replace `x'=-3 if `x'==-2&allmiss==0

}

drop allmiss

*pwnwn/pwnwap/pwnwad/pwnwo

gen allmiss=(pwnwn==-2&pwnwap==-2&pwnwad==-2&pwnwo==-2)

foreach x of var pwnwn pwnwap pwnwad pwnwo {

replace `x'=-3 if `x'==-2&allmiss==0

}

drop allmiss

*wlwh



*wlnppc/wlnpph/wlnprh/wlnprr/wlnph

gen allmiss=(wlnppc==-2&wlnpph==-2&wlnprh==-2&wlnprr==-2)

foreach x of var wlnppc wlnpph wlnprh wlnprr {

replace `x'=-3 if `x'==-2&allmiss==0&sdtype==2

}

drop allmiss

gen allmiss=(wlnppc==-2&wlnph==-2)

foreach x of var wlnppc wlnph {

replace `x'=-3 if `x'==-2&allmiss==0&sdtype==1

}

drop allmiss

*wlwy/wlwod

gen allmiss=(wlwy==-2&wlwod==-2)

foreach x of var wlwy wlwod {

replace `x'=-3 if `x'==-2&allmiss==0&sdtype==1

}

drop allmiss

*wlww/wlwd/wlnt/wlna

replace wlww=-3 if wlww==-2&(wlnt==1|wlna==1)
replace wlwd=-3 if wlwd==-2&(wlnt==1|wlna==1)

replace wlnt=0 if wlnt==-2&(wlww>=0|wlwd>=0)
replace wlna=0 if wlna==-2&(wlww>=0|wlwd>=0)

*wlcnpmin/wlcsmin/wlcna

replace wlcna=0 if wlcna==-2&(wlcnpmin>=0|wlcsmin>=0)
replace wlcna=1 if wlcna==-2&(wlcnpmin==-3|wlcsmin==-3)

*wlcnpf/wlcsf/wlcfna/wlcnpn/wlcsn

replace wlcfna=0 if wlcfna==-2&(wlcnpf>=0|wlcsf>=0)
replace wlcfna=1 if wlcfna==-2&(wlcnpf==-3|wlcsf==-3)

foreach x of var wlcnpn wlcsn {
replace `x'=-1 if sdtype==1|sdtype==3|sdtype==4|sdtype==-1|response==3
replace `x'=-3 if wlcfna==1 & `x'==.
}

replace wlcnpn=-2 if wlcnpf==-2&wlcnpn==.
replace wlcsn=-2 if wlcsf==-2&wlcsn==.

*wlbbp/wlbpna

replace wlbpna=0 if wlbpna==-2&wlbbp>=0

*on-call variables

foreach x of var wlocrpn wlocrpe wlocrnap wlocrhn wlocrhe wlocrnah {

replace `x'=-1 if `x'==-2&wlah==0&sdtype==1

}

replace wlocrnap=0 if wlocrnap==-2&(wlocrpn>=0|wlocrpe>=0)&sdtype==1
replace wlocrnah=0 if wlocrnah==-2&(wlocrhn>=0|wlocrhe>=0)&sdtype==1

foreach x of var wlocrpbn wlocrpbe wlocnapb wlocrpvn wlocrpve wlocnapv {

replace `x'=-1 if `x'==-2&wlah==0&sdtype==2

}

replace wlocnapb=0 if wlocnapb==-2&(wlocrpbn>=0|wlocrpbe>=0)&sdtype==2
replace wlocnapv=0 if wlocnapv==-2&(wlocrpvn>=0|wlocrpve>=0)&sdtype==2

foreach x of var wlcotpn wlcotpe wlcotnap wlcothn wlcothe wlcotnah {

replace `x'=-1 if `x'==-2&wlah==0&sdtype==1

}

replace wlcotnap=0 if wlcotnap==-2&(wlcotpn>=0|wlcotpe>=0)&sdtype==1
replace wlcotnah=0 if wlcotnah==-2&(wlcothn>=0|wlcothe>=0)&sdtype==1

foreach x of var wlcotpbn wlcotpbe wlcotnapb wlcotpvn wlcotpve wlcotnapv {

replace `x'=-1 if `x'==-2&wlah==0&sdtype==2

}

replace wlcotnapb=0 if wlcotnapb==-2&(wlcotpbn>=0|wlcotpbe>=0)&sdtype==2
replace wlcotnapv=0 if wlcotnapv==-2&(wlcotpvn>=0|wlcotpve>=0)&sdtype==2

*wlwhpy/wlmlpy/wlsdpy/wlotpy

gen allmiss=(wlwhpy==-2&wlmlpy==-2&wlsdpy==-2&wlotpy==-2)

foreach x of var wlwhpy wlmlpy wlsdpy wlotpy {

replace `x'=-3 if `x'==-2&allmiss==0

}

drop allmiss

*wlva/wlvadk/wlvana/wlvau

replace wlva=-4 if wlva==-2&wlvadk==1
replace wlva=-3 if wlva==-2&wlvana==1

replace wlvadk=0 if wlvadk==-2&wlva>=0
replace wlvana=0 if wlvana==-2&wlva>=0

replace wlvau=-3 if wlvau==-2&(wlva==0|wlvana==1)

*figey/finey/figef/finef

gen allmiss=(figey==-2&finey==-2&figef==-2&finef==-2)

foreach x of var figey finey figef finef {

replace `x'=-3 if `x'==-2&allmiss==0

}

drop allmiss

*fidme/fimedk

replace fimedk=0 if fimedk==-2&fidme>=0

*fidp/fidpdk/fidpna

replace fidpdk=0 if fidpdk==-2&fidp>=0
replace fidpna=0 if fidpna==-2&fidp>=0

*fighiy/finhiy/fighif/finhif

gen allmiss=(fighiy==-2&finhiy==-2&fighif==-2&finhif==-2)

foreach x of var fighiy finhiy fighif finhif {

replace `x'=-3 if `x'==-2&allmiss==0

}

drop allmiss

/*glmth/glyr

replace glyr=0 if glyr<0&glmth>=0

gen allmiss=(glyr==-2&glmth==-2)

replace glyr=-3 if glyr==-2&allmiss==0
replace glmth=-3 if glmth==-2&allmiss==0

replace glyr=-1 if glyr==-2&continue==1
replace glmth=-1 if glmth==-2&continue==1

drop allmiss*/

*glyrrs

replace glyrrs=-1 if glyrrs==-2&continue==1

*glrna/glrtwasgc/glrtwrrma

replace glrna=0 if glrna==-2&(glrtw!=""|glrst!="")
replace glrtwasgc=-3 if glrna==1&glrtwasgc==-2
replace glrtwrrma=-3 if glrna==1&glrtwrrma==-2

*glrl

replace glrna=1 if glrna==-2&glrl==0

*fcpmd

foreach x of var fcpmd fcpr fcpr_dk fcpr_na fcprt_dk fcprt_na fcprtasgc fcprtrrma {

replace `x'=-1 if `x'==-2 & continue==1

}

*fcayna/fcndc

replace fcayna=1 if fcndc==0&fcayna==-2
replace fcayna=0 if fcndc>0&fcayna==-2

*picmdoi

replace picmdoi=-1 if picmdoi==-2&picmda==1

*pifayr

replace pifayr=-3 if pifayr==-2&picmda==1
replace pifryr=-3 if pifryr==-2&picmda==1
replace pifyrna=1 if pifyrna==-2&picmda==1

*piqanu piqang piqanm piqanph piqandc piqanf piqanot

gen allmiss=(piqanm==-2&piqanph==-2&piqandc==-2&piqanf==-2)

foreach x of var  piqanm piqanph piqandc piqanf  {

replace `x'=0 if `x'==-2

}

drop allmiss




*pisesp

replace pisesp6=-3 if pisesp6==-2&pimsp6i>=0
replace pisespgx=-3 if pisespgx==-2&pimsp6i>=0

*pirsyr/pireyr

replace pirsyr=-1 if pirsyr==-2&continue==1
replace pireyr=-3 if pireyr==-2&pirna==1

*if gp who qualified before 2014 then change to -3 (not applicable) as shouldn't have asked this question.
*keep registrars who qualified before 2014 as they are answering wrong questionnaire.
replace pireyr=-3 if pireyr<2015 & pireyr>0 & sdtype==1



*pirps/pirna

replace pirps=-1 if pirps==-2&source==2 
replace pirna=0 if pirna==-2&(pireyr>=0|pirsyr>=0)

*pindyr/pindmt

gen allmiss=(pindyr==-2&pindmt==-2)

replace pindyr=-3 if pindyr==-2&allmiss==0
replace pindmt=-3 if pindmt==-2&allmiss==0

replace pindyr=-1 if pindyr==-2&continue==1
replace pindmt=-1 if pindmt==-2&continue==1

drop allmiss

***************************************************









