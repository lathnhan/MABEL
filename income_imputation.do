*Purpose: Impute missing income data 
*

********************************************************

global ddtah="D:\Data\Data Clean\Wave9\dtah"
global ddo="D:\Data\Data Clean\Wave9"
global dlog="D:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\income_imputation.log", replace

********************************************************

use "${ddtah}\temp_all.dta", clear

********************************************************

preserve

drop if sdtype==-1

*************************************

*generate spouse variable

tab fclp, m
gen spouse=1 if fclp==1

tab fcpes, m
replace spouse=1 if fclp!=1 & (fcpes>=0&fcpes!=4&fcpes!=.)

tab fclp spouse, m


*generate spouse's employment variables

gen emplst=fcpes

replace emplst=4 if (emplst<0|emplst==.)&fclp==0


*create variable to indicate other personal income source
gen fioti=1 if fisadd>0 & fisadd<.
gen oth_src=(fioti==1)

**************************************

*replace the negative values by missing

foreach x of var figey finey figef finef fighiy finhiy fighif finhif wlmlpy wlotpy {

replace `x'=. if `x'<0

}

*replace missing weekoff by zero (assumption)

replace wlmlpy=0 if wlmlpy==.
replace wlotpy=0 if wlotpy==.

gen weekoff = wlmlpy + wlotpy/7 /*maternity leave and other leaves*/

gen ginc=figey

replace ginc = figef * (26 - weekoff/2) if ginc==.
label var ginc "Gross annual personal earnings"

*other household income and partner's income

gen gothinc=fighiy-figey
replace gothinc=(fighif-figef)*26 if fighiy==.|figey==.
replace gothinc=(fighiy-figef*(26-weekoff/2)) if fighif==. & gothinc==.
replace gothinc=(fighif-figey/(26-weekoff/2))*26 if fighiy==. & gothinc==.
label var gothinc "Gross annual other and partner's earnings"

*check other and partner's income, negative values
replace gothinc=. if gothinc<0


*****************************************

*net income

gen ninc=finey

replace ninc=finef*(26-weekoff/2) if ninc==. & finef>0 & finef!=.
label var ninc "Net annual earnings"

*other household income and partner's income 

gen nothinc=finhiy-finey
replace nothinc=(finhif-finef)*26 if finhiy==.|finey==.
replace nothinc=(finhiy-finef*(26-weekoff/2)) if finhif==.&nothinc==.
replace nothinc=(finhif-finey/(26-weekoff/2))*26 if finhiy==.&nothinc==.
label var nothinc "Net annual other and partner's earnings"


*****************************************

*fill a few more gross and net income information using household income for single doctors with no other income source, 
*doctors whose partners not working

replace ginc=fighiy if ((emplst!=2&emplst!=3) | spouse!=1) & ginc==. & oth_src==0 & fighiy!=.
replace ginc=fighif*(26-weekoff/2) if ((emplst!=2&emplst!=3) | spouse!=1) & ginc==. & oth_src==0 & fighif!=.

replace ninc=finhiy if ((emplst!=2&emplst!=3) | spouse!=1) & ninc==. & oth_src==0 & finhiy!=.
replace ninc=finhif*(26-weekoff/2) if ((emplst!=2&emplst!=3) | spouse!=1) & ninc==. & oth_src==0 & finhif!=.

*****************************************

*children under age 18

*drop *_c  

foreach x of num 1/6 {
list id fcndc fcayna fcc_age_* if fcc_age_`x'==-4
}

foreach x of num 1/6 {
gen w7age_`x'=fcc_age_`x'
replace w7age_`x'=. if w7age_`x'<0
}

gen children=(fcndc>0&(fcc_age_1 < 18 | fcc_age_2 < 18 | fcc_age_3 < 18 | fcc_age_4 < 18 | fcc_age_5 < 18 | fcc_age_6 < 18))


*****************************************

egen numkids=rownonmiss(w7age_1 - w7age_6)

gen numdkids017=(w7age_1!=.&w7age_1<18)+(w7age_2!=.&w7age_2<18)+(w7age_3!=.&w7age_3<18)+(w7age_4!=.&w7age_4<18)+ ///
	(w7age_5!=.&w7age_5<18)+(w7age_6!=.&w7age_6<18)

gen numdkids017_2 = numdkids017 - 2

gen numdkids=(w7age_1!=.&w7age_1<19)+(w7age_2!=.&w7age_2<19)+(w7age_3!=.&w7age_3<19)+(w7age_4!=.&w7age_4<19)+ ///
	(w7age_5!=.&w7age_5<19)+(w7age_6!=.&w7age_6<19)

gen numk04=(w7age_1!=.&w7age_1<5)+(w7age_2!=.&w7age_2<5)+(w7age_3!=.&w7age_3<5)+(w7age_4!=.&w7age_4<5)+ ///
	(w7age_5!=.&w7age_5<5)+(w7age_6!=.&w7age_6<5)

gen numk515=(w7age_1>=5&w7age_1<16)+(w7age_2>=5&w7age_2<16)+(w7age_3>=5&w7age_3<16)+(w7age_4>=5&w7age_4<16)+ ///
	(w7age_5>=5&w7age_5<16)+(w7age_6>=5&w7age_6<16)

gen numk012=(w7age_1!=.&w7age_1<13)+(w7age_2!=.&w7age_2<13)+(w7age_3!=.&w7age_3<13)+(w7age_4!=.&w7age_4<13)+ ///
	(w7age_5!=.&w7age_5<13)+(w7age_6!=.&w7age_6<13)

*gen numk1315=(w7age_1>=13&w7age_1<16)+(w7age_2>=13&w7age_2<16)+(w7age_3>=13&w7age_3<16)+(w7age_4>=13&w7age_4<16)+ ///
	*(w7age_5>=13&w7age_5<16)+(w7age_6>=13&w7age_6<16)

*gen numk1617=(w7age_1>=16&w7age_1<18)+(w7age_2>=16&w7age_2<18)+(w7age_3>=16&w7age_3<18)+(w7age_4>=16&w7age_4<18)+ ///
	*(w7age_5>=16&w7age_5<18)+(w7age_6>=16&w7age_6<18)
	
gen numk1317=(w7age_1>=13&w7age_1<18)+(w7age_2>=13&w7age_2<18)+(w7age_3>=13&w7age_3<18)+(w7age_4>=13&w7age_4<18)+ ///
	(w7age_5>=13&w7age_5<18)+(w7age_6>=13&w7age_6<18)


*****************************************

*generate observed income variable



*adding income from practising and other income assuming that if there is no employed partner and household income equals to zero if it is missing
*for tax purpose, it is reasonable to assume that couples wukk split other household income to maximise tax benefits; so 
	*we assume that couples will split it equally if the partner is not working.

	
* Here we can use the additional information on gross  annual non-practice doctor’s income “fisadd” from wave 6 onwards if it is not missing.


replace fclp=. if fclp<0
replace fcpes=. if fcpes<0
replace fisadd=. if fisadd<0

gen fisadd2=fisadd
replace fisadd=gothinc if fisadd>gothinc & fisadd!=.
gen obs_annualy=ginc
replace obs_annualy=ginc+ fisadd if fisadd!=.


*When dr has partner who is not in labour force
replace obs_annualy=obs_annualy + gothinc/2 if (fisadd==0|fisadd==.)&(fcpes==0|fcpes==1|(fcpes==4&fclp==1)) & gothinc!=.
*When dr has no partner
replace obs_annualy=obs_annualy + gothinc if (fisadd==0|fisadd==.)&(fcpes==.|(fcpes==4&fclp!=1)) & gothinc!=.  


*assume all other household income is from partner, treat missing as missing
gen obs_annualy2=gothinc
replace obs_annualy2=gothinc-fisadd if fisadd!=.

*when partner is working
replace obs_annualy2=gothinc if (fisadd==0|fisadd==.)&(fcpes==2|fcpes==3) & gothinc!=.

*when partner is not working
replace obs_annualy2=gothinc/2 if (fisadd==0|fisadd==.)&(fcpes==0|fcpes==1|(fcpes==4&fclp==1)) & gothinc!=.
gen obs_allhhy=obs_annualy + obs_annualy2
replace obs_allhhy=obs_annualy if obs_allhhy==.&obs_annualy!=.



*repeat the same procedure for personal and household net income

gen obs_annualnety=ninc

replace obs_annualnety=obs_annualnety + nothinc/2 if (fcpes==0|fcpes==1|(fcpes==4&fclp==1)) & nothinc!=.
replace obs_annualnety=obs_annualnety + nothinc if (fcpes==.|(fcpes==4&fclp!=1)) & nothinc!=.

gen obs_annualnety2=.

replace obs_annualnety2=nothinc if (fcpes==2|fcpes==3) & nothinc!=.
replace obs_annualnety2=nothinc/2 if (fcpes==0|fcpes==1|(fcpes==4&fclp==1)) & nothinc!=.

gen obs_allnethhy=obs_annualnety + obs_annualnety2
replace obs_allnethhy=obs_annualnety if obs_allnethhy==.&obs_annualnety!=.


*****************************************

*keep the variables required only

#delimit;

keep  id spouse emplst oth_src weekoff ginc gothinc ninc nothinc children numkids numdkids017 
		numdkids017_2 numdkids numk04 numk515 numk012  numk1317 obs_annualy obs_annualy2 
		obs_allhhy obs_annualnety obs_annualnety2 obs_allnethhy;

#delimit cr

*****************************************

*calculating the payable tax given taxable income, Stefi's program to calculate the tax income
*need to define commands for 1617
*update individual income tax rates from ABS 
*https://www.ato.gov.au/Rates/Individual-income-tax-rates/
*tt checked 8/6/16. Figures were same in 1617 as in 1415 and 1314


capture program drop tax1617
program define tax1617
version 13

syntax varname [if], Generate(name)
confirm new var `generate'

*change to current tax thresholds and rates
*taxable income
local bound1=18200
local bound2=37000
local bound3=80000
local bound4=180000

*tax on this income
local percl1=0.19
local percl2=0.325
local percl3=0.37
local percl4=0.45

*eg $3,572 plus 32.5c for each $1 over $37,000
local base1=3572
local base2=19822
local base3=54232

gen `generate'=0 `if'
replace `generate'=`percl1'*(`varlist'-`bound1') if (`varlist'<=`bound2' & `varlist'>`bound1')
replace `generate'=`base1'+`percl2'*(`varlist'-`bound2') if (`varlist'<=`bound3' & `varlist'>`bound2')
replace `generate'=`base2'+`percl3'*(`varlist'-`bound3') if (`varlist'<=`bound4' & `varlist'>`bound3')
replace `generate'=`base3'+`percl4'*(`varlist'-`bound4') if (`varlist'>`bound4' & `varlist'!=.)

end

*change to "tax1617"
tax1617 obs_annualy, gen(inctax1)
tax1617 obs_annualy2, gen(inctax2)

*****************************************

*low income tax offset
*use "https://atotaxrates.info/tax-offset/low-income-tax-offset/"
*TT checked 8/6/16 - 1617 same as 1415 and 1617

capture program drop offsetli1617
program define offsetli1617
version 13

syntax varname [if], Generate(name)
confirm new var `generate'

local reblowinc=445
local bndlowinc=37000
local perclowinc=0.015  //use step 6 on page http://calculators.ato.gov.au/scripts/axos/AXOS.asp - LINK DOESN'T WORK

gen `generate' = `reblowinc'-(`varlist'-`bndlowinc')*`perclowinc'*(`varlist'>`bndlowinc') `if'
replace `generate'=max(0, `generate') `if'

end

offsetli1617 obs_annualy, gen(lioffset1)
offsetli1617 obs_annualy2, gen(lioffset2)

*****************************************

*offset for dependnt spouses  //	Dependent spouse tax offset phased-out so set to zero for wave 6 onwards
capture program drop offsetds1617
program define offsetds1617
version 13

syntax varname(min=4 max=4) [if], Generate(name)
confirm new var `generate'1
confirm new var `generate'2

local rebdepsp=2286 //- HOW TO GET THIS?
local bnddepsp1=282 //- HOW TO GET THIS?
local bnddepsp2=150000 //- HOW TO GET THIS?
local percdepsp=0.25 //- HOW TO GET THIS?

*define the order of the 4 variables

local obs_annualy: word 1 of `varlist'
local obs_annualy2: word 2 of `varlist'
local lioffset1: word 3 of `varlist'
local lioffset2: word 4 of `varlist'

tempvar x1 x2

/*gen `x1'=(`rebdepsp'-(`obs_annualy2'-`bnddepsp1')*`percdepsp'*(`obs_annualy2'>`bnddepsp1'))*(`obs_annualy'<=`bnddepsp2')
replace `x1'=max(0, `x1')

gen `x2'=(`rebdepsp'-(`obs_annualy'-`bnddepsp1')*`percdepsp'*(`obs_annualy'>`bnddepsp1'))*(`obs_annualy2'<=`bnddepsp2')
replace `x2'=max(0, `x2')*/

*set to zero as spouse tax offset phased out
gen `x1'=(`rebdepsp'-(`obs_annualy2'-`bnddepsp1')*`percdepsp'*(`obs_annualy2'>`bnddepsp1'))*(`obs_annualy'<=`bnddepsp2')
replace `x1'=0

*set to zero as spouse tax offset phased out
gen `x2'=(`rebdepsp'-(`obs_annualy'-`bnddepsp1')*`percdepsp'*(`obs_annualy'>`bnddepsp1'))*(`obs_annualy2'<=`bnddepsp2')
replace `x2'=0

gen `generate'1 = 0 `if'
gen `generate'2 = 0 `if'

end

local varoffset obs_annualy obs_annualy2 lioffset1 lioffset2

offsetds1617 `varoffset', gen(offset) 

****************************************

*calculating the amount of medicare levy one is eligible
*ato website   https://www.ato.gov.au/Individuals/Tax-return/2014/Tax-return/Medicare-levy-questions-M1-M2/M1---Medicare-levy-reduction-or-exemption/
*https://www.ato.gov.au/Individuals/Tax-Return/2015/Tax-return/Medicare-levy-questions-M1-M2/M1-Medicare-levy-reduction-or-exemption/
*https://atotaxrates.info/individual-tax-rates-resident/medicare-levy/


capture program drop medlev1617
program define medlev1617

syntax varlist(min=6 max=6) [if], Generate(name)
confirm new var `generate'1
confirm new var `generate'2

local ind_bndyl=20896  //individual band lower
local ind_bndyu=26120 //individual band upper
local basefaminc=44076  //base family income
local basedepch=4047   //base dependent children
local bndfaminc=45676 //low income threshold for families
local bnddepch=4195  // additional threshold for each dependent child 
local mc_perc=0.02  //  medicare levy - HOW TO GET THIS?
local mc_phin=0.10   //  - HOW TO GET THIS?

local obs_annualy: word 1 of `varlist'
local partner: word 2 of `varlist'
local emplst_partner: word 3 of `varlist'
local obs_allhhy: word 4 of `varlist'
local numdkids: word 5 of `varlist'
local obs_annualy2: word 6 of `varlist'

*don't need to change following at all

#delimit;

local no_mc1=(`obs_annualy'<=`ind_bndyl') | ((`partner'==1 | (`emplst_partner'>=1&`emplst_partner'<=3) | `numdkids'>0) & 
				`obs_allhhy'<=(`bndfaminc' + `bnddepch'*`numdkids') );
				
local no_mc2=(`obs_annualy2'<=`ind_bndyl') | ((`partner'==1 | (`emplst_partner'>=1&`emplst_partner'<=3) | `numdkids'>0) & 
				`obs_allhhy'<=(`bndfaminc' + `bnddepch'*`numdkids') );

tempvar fam_red fam_red1 fam_red2 part_mc;

gen `part_mc'=((`partner'==1 | (`emplst_partner'>=1&`emplst_partner'<=3) | `numdkids'>0) & `obs_allhhy'<=(`basefaminc'+
			`numdkids'*`basedepch') & `obs_allhhy'>(`bndfaminc'+`numdkids'*`bnddepch'));

gen `fam_red'=`mc_perc'*(`bndfaminc'+`numdkids'*`bnddepch')-(`mc_phin'-`mc_perc')*(`obs_allhhy'-`bndfaminc'-`numdkids'*`bnddepch') 
				if `part_mc'==1;

gen `fam_red1'=`fam_red'*`obs_annualy'/`obs_allhhy';
gen `fam_red2'=`fam_red'*`obs_annualy2'/`obs_allhhy';

gen `generate'1=0 if `no_mc1';
replace `generate'1=min(`mc_perc'*`obs_annualy', `mc_phin'*(`obs_annualy'-`ind_bndyl')) if `no_mc1'==0;
gen `generate'2=0 if `no_mc2';
replace `generate'2=min(`mc_perc'*`obs_annualy2', `mc_phin'*(`obs_annualy2'-`ind_bndyl')) if `no_mc2'==0;

#delimit cr

replace `generate'1=`mc_perc'*`obs_annualy'-`fam_red1' if `part_mc'==1
replace `generate'2=`mc_perc'*`obs_annualy2'-`fam_red2' if `part_mc'==1

replace `generate'1=`generate'1+`generate'2 if `generate'1>0 & `generate'2<0 & `part_mc'==1
replace `generate'2=`generate'1+`generate'2 if `generate'1<0 & `generate'2>0 & `part_mc'==1

replace `generate'1=max(0, `generate'1) if `generate'1!=.
replace `generate'2=max(0, `generate'2) if `generate'2!=.

end

local varsmedlev obs_annualy spouse emplst obs_allhhy numdkids obs_annualy2

medlev1617 `varsmedlev', gen(mc)

****************************************

*calculating the amount of family tax benefit part A and B for one is eligible
*http://www.humanservices.gov.au/customer/services/centrelink/family-tax-benefit-part-a-part-b
*in 2015 changed age bands to under 13 and 13-17. The official top age band was 14-19 in secondary education but as we 
*dont have a measure of secondary education we chose 13-17 as a sensible age band.
capture program drop ftb1617
program define ftb1617

syntax varlist(min=9 max=9) [if], Generate(name)
confirm new var `generate'_A
confirm new var `generate'_B

local maxrateA012=5504.2 	//Max rate for each child aged under 13 Family Tax Benefit Part A//
local maxrateA1317=6938.65   //Max rate for each child aged 13-17 Family Tax Benefit Part A. *see note above//
local minrateA012=1525.16   //Base rate for each child aged under 13 Family Tax Benefit Part A//
local minrateA1317=1525.16   //Base rate for each child aged 13-17 Family Tax Benefit Part A *see note above//
local bndAinc1=52706 		//First income test threshold Family Tax Benefit Part A//
local bndAinc2=94316		//Second income test threshold Family Tax Benefit Part A 
local bndAincch=3796 		//for each Family Tax Benefit child after the first - check this figure - i couldn't find it anywhere so am using from previous year - tt 8/6/16// -SAME IN WAVE 9
local FA1_perc=0.2 			//First income test rate Family Tax Benefit Part A//
local FA2_perc=0.3 		//Second income test rate Family Tax Benefit Part A//
local FS_A=323.96		//Basic rates for large family supplement// - HOW TO GET THIS?
local rateB04=4412.65	//Max rate for youngest child aged under 5 Family Tax Benefit Part B//
local rateB515=3190.10	//Max rate for youngest child aged 5-15 Family Tax Benefit Part A//
local bndBinc1=100000		//Income test threshold Family Tax Benefit Part B//
local bndBinc2=5548		//Lower earner threshold Family Tax Benefit Part B//
local FB1_perc=0.2 			//Rate for lower earner Family Tax Benefit Part B//

local numdkids017_2: word 1 of `varlist'
local numk012: word 2 of `varlist'
local numk1317: word 3 of `varlist' //changed by tt 28/4/15
local numk04: word 4 of `varlist'
local numk515: word 5 of `varlist'
local obs_allhhy: word 6 of `varlist'
local obs_annualy: word 7 of `varlist'
local obs_annualy2: word 8 of `varlist'
local partner: word 9 of `varlist'

tempvar minftb_A nokidm2

gen `nokidm2'=max(0, `numdkids017_2')

#delimit;

gen `generate'_A=`numk012'*`maxrateA012'+`numk1317'*`maxrateA1317'+`FS_A'*`nokidm2';
gen `minftb_A'=`numk012'*`minrateA012'+`numk1317'*`minrateA1317';

replace `generate'_A=max(`generate'_A-`FA1_perc'*(`obs_allhhy'-`bndAinc1'), `minftb_A') 
		if `obs_allhhy'<=`bndAinc2'+`bndAincch'*(`numk012'+`numk1317'-1) & `obs_allhhy'>`bndAinc1';
replace `generate'_A=max(`minftb_A'-`FA2_perc'*(`obs_allhhy'-`bndAinc2'-`bndAincch'*(`numk012'+`numk1317'
	-1)), 0) if `obs_allhhy'>`bndAinc2'+`bndAincch'*(`numk012'+`numk1317'-1);

gen `generate'_B=`rateB04'*(`numk04'>0)+`rateB515'*(`numk04'==0)*(`numk515'>0);

replace `generate'_B=0 if max(`obs_annualy', `obs_annualy2')>`bndBinc1';
replace `generate'_B=max(0, `generate'_B-`FB1_perc'*(min(`obs_annualy', `obs_annualy2')-`bndBinc2')) 
		if max(`obs_annualy', `obs_annualy2')<=`bndBinc1' & `partner'==1 & min(`obs_annualy', `obs_annualy2')>`bndBinc2';

end;

#delimit cr

local xvarsftb numdkids017_2 numk012 numk1317 numk04 numk515 obs_allhhy obs_annualy obs_annualy2 spouse
		

ftb1617 `xvarsftb', gen(ftb)



count if ftb_A!=0
count if ftb_B!=0
gen ftb=(ftb_A!=0)+(ftb_B!=0)
gen A=(ftb_A>0&ftb_A!=.)
gen B=(ftb_B>0&ftb_B!=.)
tab A B


*compute net income

gen annualnety = obs_annualy - inctax1 - mc1 + ftb_A + ftb_B + min(inctax1, offset1) //changed to remove spouse offset tt 28/4/2015
gen annualnety2 = obs_annualy2 - inctax2 - mc2 + min(inctax2, offset2)
gen annualnety_noftb = obs_annualy - inctax1 - mc1 + min(inctax1, offset1)

gen allnethhy=annualnety
replace allnethhy=annualnety + annualnety2 if spouse==1

gen dif_nety = annualnety - obs_annualnety
gen dif_nety_noftb = dif_nety - ftb_A - ftb_B

sum dif_nety dif_nety_noftb annualnety obs_annualnety, detail
gen ratio=annualnety/obs_annualnety
label var ratio "ratio imputed net / observed net"


*taken from line 254
*start computing gross income from net income
*same for 1416 as for 1415 and 1314 - tt 28/4/2015 

local bound1=18200
local bound2=37000
local bound3=80000
local bound4=180000
local percl1=0.19
local percl2=0.325
local percl3=0.37
local percl4=0.45
local base1=3572
local base2=19822
local base3=54232

local y "obs_annualnety obs_annualnety2"

foreach x in `y' {
local s=1
local k=1

forvalues i = 1/5 {
gen grossy`i'=.

if "`i'"=="1" {
gen db`i'=0
replace db`i'=1 if `x'<=`bound`k''
replace grossy`i'=`x'
}

else if "`i'"=="2" {
local t=2
gen db`i'=0
replace db`i'=1 if `x'<=`bound`t''
replace grossy`i'=(`x'-`perc`k''*`bound`k'')/(1-`perc`k'')
local k=`k'+1
local t=`t'+1
}

else if ("`i'"=="3"|"`i'"=="4"|"`i'"=="5") {

gen db`i'=0

if ("`i'"=="3"|"`i'"=="4") replace db`i'=1 if `x'<=`bound`t''

else replace db`i'=1 if `x'!=.

replace grossy`i'=(`x'+`base`s''-`perc`k''*`bound`k'')/(1-`perc`k'')
local s=`s'+1
local k=`k'+1
local t=`t'+1
}
}

local c0 "obs_annualy==."
local c1 "grossy1<=`bound1'"
local c2 "grossy2>`bound1'&grossy2<=`bound2'"
local c3 "grossy3>`bound2'&grossy3<=`bound3'"
local c4 "grossy4>`bound3'&grossy4<=`bound4'"
local c5 "grossy5>`bound4'"
local c6 "emplst>=0&emplst<4"
local cp0 "obs_annualy2=."

if "`x'"=="obs_annualnety" {

gen gry=.
label var gry "Gross annual earnings (only taxes)"

replace gry=grossy1 if db1==1 & `c1'
replace gry=grossy2 if db2==1 & `c2'
replace gry=grossy3 if db3==1 & `c3'
replace gry=grossy4 if db4==1 & `c4'
replace gry=grossy5 if db5==1 & `c5'

}

else if "`x'"=="obs_annualnety2" {
gen gryp=.
label var gryp "Gross annual earnings partner (only taxes)"

replace gryp=grossy1 if db1==1 & `c1' & `c6'
replace gryp=grossy2 if db2==1 & `c2' & `c6'
replace gryp=grossy3 if db3==1 & `c3' & `c6'
replace gryp=grossy4 if db4==1 & `c4' & `c6'
replace gryp=grossy5 if db5==1 & `c5' & `c6'

}

drop grossy1-db5
}


*assessment of how well imputation from net income works, compare the observed gross
*income to the imputed values for all observed net income 

*drop those observations where observed gross income is lower than net income
drop if obs_annualy!=.&obs_annualnety!=.&obs_annualy>0&obs_annualnety>0&obs_annualy<obs_annualnety

corr gry obs_annualy

gen ratio1=gry/obs_annualy
label var ratio1 "ratio imputed gross (gry)/observed gross"

gen ratiogn=obs_annualnety/obs_annualy
label var ratiogn "ratio observed net/observed gross"

gen dgry=(gry!=.)
gen dgryp=(gryp!=.)

capture drop annualy_imp

gen annualy_imp=obs_annualy
label var annualy_imp "Imputed variable - gross annual income"
gen annualy2_imp=obs_annualy2
label var annualy2_imp "Imputed variable - partner's gross annual income"

replace annualy_imp=gry if dgry==1
replace annualy2_imp=gryp if dgryp==1
replace annualy2_imp=0 if dgry==1&dgryp==0

gen allhhy_imp=obs_allhhy
replace allhhy_imp=annualy_imp+annualy2_imp if dgry==1

*local xvarsrebds annualy_imp annualy2_imp doffsetli1 doffsetli2
tax1617 annualy_imp, gen(dIT1)
tax1617 annualy2_imp, gen(dIT2)

offsetli1617 annualy_imp, gen(doffsetli1)
offsetli1617 annualy2_imp, gen(doffsetli2)

local xvarsrebds annualy_imp annualy2_imp doffsetli1 doffsetli2
offsetds1617 `xvarsrebds', gen(doffset)

local xvarsmedlev annualy_imp spouse emplst allhhy_imp numdkids annualy2_imp
medlev1617 `xvarsmedlev', gen(dMC)

local xvarsftb numdkids017_2 numk012 numk1317 numk04 numk515 allhhy_imp annualy_imp annualy2_imp spouse
ftb1617 `xvarsftb', gen(dftb)

gen dannualnety = annualy_imp - dIT1 - dMC1 + dftb_A + dftb_B + min(dIT1, doffset1) if dgry==1
gen dannualnety2 = annualy2_imp - dIT2 - dMC2 + min(dIT2, doffset2) if dgryp==1
gen dannualnety_noftb = annualy_imp - dIT1 - dMC1 + min(dIT1, doffset1) if dgry==1

gen dallnethhy = dannualnety if dgry==1
replace dallnethhy = dallnethhy + dannualnety2 if spouse==1 & dgry==1

gen ddif_nety = dannualnety - obs_annualnety if dgry==1
gen ddif_nety_noftb = ddif_nety - dftb_A - dftb_B if dgry==1
gen ddif_nety2 = dannualnety2 - obs_annualnety2 if dgryp==1

*****************************************************************

*****************************************************************

*********start the iteration*************
*********set the convergence value to an appropriately small value***********
*********Codes from Daniel************


*set convergence value*
local i=0.01

*count number of iterations
local j=1

*set max number of iterations
local k=300

***Create local for average diff of ind incomes***
sum ddif_nety
local mddif_nety = r(mean)
sum ddif_nety_noftb
local mddif_nety_noftb = r(mean)
sum ddif_nety2
local mddif_nety2 = r(mean)

***start loop that run as long as absolute value of average ind income diff
***i.e. observed-comparison net income is larger than the convergence value (=1)
***and bound maximum number of iterations to avoid eternal loops

while (abs(`mddif_nety') > = `i' | abs(`mddif_nety2') > = `i') & `j' < `k' {

sum ddif_nety ddif_nety2

*Here we update gross individual annual income

replace gry = (1+(obs_annualnety-dannualnety)/obs_annualnety)*gry

*Here we update partner's individual income

replace gryp= (1+(obs_annualnety-dannualnety2)/obs_annualnety2)*gryp
replace gryp = 0 if obs_annualnety2==0
drop dIT1-ddif_nety2

replace annualy_imp = gry if dgry==1
replace annualy2_imp = gryp if dgryp==1
replace annualy2_imp = 0 if dgry==1 & dgryp==0
replace allhhy_imp = (annualy2_imp + annualy_imp) if dgry==1

tax1617 annualy_imp, gen(dIT1)
tax1617 annualy2_imp, gen(dIT2)

offsetli1617 annualy_imp, gen(drebli1)
offsetli1617 annualy2_imp, gen(drebli2)

global xvarsrebds annualy_imp annualy2_imp drebli1 drebli2
offsetds1617 $xvarsrebds, gen(drebates)

global xvarsmedlev annualy_imp spouse emplst allhhy_imp numkids annualy2_imp
medlev1617 $xvarsmedlev, gen(dMC)

global xvarsftb numdkids017_2 numk012 numk1317 numk04 numk515 allhhy_imp annualy_imp annualy2_imp spouse 
ftb1617 $xvarsftb, gen(dftb) 

gen dannualnety = annualy_imp - dIT1  - dMC1 + dftb_A + dftb_B + min(dIT1,drebates1) if dgry==1
gen dannualnety2 = annualy2_imp - dIT2  - dMC2 + min(dIT2,drebates2) if  dgryp==1
gen dannualnety_noftb = annualy_imp - dIT1  - dMC1 + min(dIT1,drebates1) if  dgry==1

gen dallnethhy=dannualnety if dgry==1
replace dallnethhy=dallnethhy+dannualnety2 if spouse==1 & dgryp==1

gen ddif_nety= dannualnety-obs_annualnety if dgry==1
gen ddif_nety_noftb=ddif_nety-dftb_A-dftb_B if  dgry==1

gen ddif_nety2= dannualnety2-obs_annualnety2 if dgryp==1

sum ddif_nety2
local mddif_nety2 = r(mean)

sum ddif_nety
local mddif_nety = r(mean)

sum ddif_nety_noftb
local mddif_nety_noftb = r(mean)

local j = `j' + 1
}

*if convergence occurs within the set limits, replace y with gry for 
*all individuals, for whom we did not have gross but net income available

if `j' < `k' {
display "Number of iterations: `j'"
sum ddif_nety
sum ddif_nety2
sum ddif_nety_noft
}

else display "Maximum iterations (#=`k') reached"

*END OF IMPUTATION

*****************************************

keep id dannualnety dallnethhy annualy_imp allhhy_imp
replace annualy_imp=round(annualy_imp, .01)
replace annualy_imp=. if annualy_imp<0|(annualy_imp>0&annualy_imp<1000)|annualy_imp>5000000

save "${ddtah}\w9_imputed_income.dta", replace

restore

drop if id==.
*drop _merge
merge 1:1 id using "${ddtah}\w9_imputed_income.dta", gen(merge2)
drop dannualnety dallnethhy allhhy_imp merge2

label var annualy_imp 	"Imputed gross personal income"













