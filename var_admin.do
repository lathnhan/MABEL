
**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: clean the administrative variables in wave 9
********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


capture log close
set more off

log using "${dlog}\var_admin.log", replace

********************************************************


tostring _all, replace force
foreach x of var _all {
replace `x'=regexs(1) if regexm(`x', "^([0-9]+) comment[:]$")
replace `x'=regexs(1) if regexm(`x', "^([0-9]+) comment[:][.]$")
replace `x'=trim(`x')
replace `x'="" if `x'=="comment:"
replace `x'="" if `x'==".comment:"
replace `x'="" if `x'==".comment:."
replace `x'="" if `x'==". comment:"
replace `x'="" if `x'==". comment:."
replace `x'="" if `x'=="."
replace `x'=regexs(1) if regexm(`x', "^(.*) comment[:]$")
replace `x'=trim(`x')
}
*

*drop the observations with admin ids

destring id, replace force
drop if id==.



***************************************

*clean variable of doctor types

tab sdtype, m

replace sdtype="1" if sdtype=="GP"
replace sdtype="2" if sdtype=="Specialist"|sdtype=="SP"
replace sdtype="3" if sdtype=="HD"|sdtype=="Hospital Doctor"
replace sdtype="4" if sdtype=="DE"|sdtype=="Doctor Enrolled"

destring sdtype, replace

***************************************

*clean other admin variables

tab continue, m
tab source, m
*correct source if it is a late extra
*replace source ="Pilot" if id==1869
*replace source ="Main" if id==81086|id==41290|id==39596|id==31804|id==39055|id==65511

tab response, m

*tab furcom if source=="Main"

*correct the hardcopy pilot response entered online manually
*not sure about this now have new 'sample' variable - tt 17/2/2015
*replace source="Pilot" if source=="Main"&regexm(furcom, "^HCopy (.*)$")

***************************************

order dtbatch dtserial dtimage id sdtype continue source response

***************************************

preserve

*prepare the dataset for Matthew to clean geographic variables

keep dtbatch dtserial dtimage id sdtype continue source response pwmhn pwmhp gltww glpcw gltwl glpcl glrtw glrst glrna fcprt fcprs ///
gltown1 glpc1 gltown2 glpc2 gltown3 glpc3


duplicates tag id, gen(dup)

sort id
foreach x of var pwmhn pwmhp gltww glpcw gltwl glpcl glrtw glrst glrna fcprt fcprs {
replace `x'=proper(`x')
}

list id sdtype pwmhn pwmhp gltww glpcw gltwl glpcl glrtw glrst glrna fcprt fcprs if dup>=1

egen a=rownonmiss(pwmhn pwmhp gltww glpcw gltwl glpcl glrtw glrst fcprt fcprs) if dup>=1, s

sort id a
by id: gen n=_n

list id a n if dup>=1
replace n=. if id==.

drop if dup==1&n==1
drop if dup==2&(n==1|n==2)
drop a n dup
recast str gltown2 pwmhn gltww

save "${ddtah}\w9_geoclean.dta", replace
*this step was repeated on 16/8/2016 to include HDC cases which had originally been omitted - filename changed from w8_geoclean to w8_geoclean2
*and then following was done to prepare data for matthew
/*use "L:\Data\Data Clean\Wave8\dtah\w8_geoclean2.dta", clear
merge m:m id using "L:\Data\Data Clean\Wave8\dtah\w8_geoclean.dta"
drop if _merge==3
save "L:\Data\Data Clean\Wave8\dtah\w8_geoclean2.dta", replace*/


restore

*************************************

*The following program creates the directory for individual pages after splitting the scanned images.
gen typecont=""
replace typecont="gpc" if continue=="Continue" & sdtype==1
replace typecont="spc" if continue=="Continue" & sdtype==2
replace typecont="hdc" if continue=="Continue" & sdtype==3
replace typecont="dec" if continue=="Continue" & sdtype==4
replace typecont="gpn" if continue=="New" & sdtype==1
replace typecont="spn" if continue=="New" & sdtype==2
replace typecont="hdn" if continue=="New" & sdtype==3
replace typecont="den" if continue=="New" & sdtype==4

gen dtimage_name=dtimage
replace dtimage_name=subinstr(dtimage_name, "G:\Projects\50581-MABEL 2016\IMAGES\", "", .)
replace dtimage_name = subinstr(dtimage_name, "\BAT", "x\BAT", .) if dtimage_name != ""
replace dtimage_name = subinstr(dtimage_name, ".TIF", "", .) if dtimage_name != ""

gen dirall="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + ".tif" if dtimage_name !=""
replace dirall=subinstr(dirall, "x\BAT", "\BAT", .) if dtimage_name !=""

*Change names of directory variables to fit with the new directory
forvalues x = 1(1)9{
gen dir`x'="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_000`x'.tif" if dtimage_name != ""
}
*
gen dir10="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0010.tif" if dtimage_name != ""
gen dir11="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0011.tif" if dtimage_name != "" & typecont != "dec" & typecont != "hdc"
gen dir12="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0012.tif" if dtimage_name != "" & typecont != "dec" & typecont != "hdc" & typecont != "den" & typecont != "hdn"
gen dir13="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0013.tif" if dtimage_name != "" & (typecont == "gpn" | typecont == "spn")
gen dir14="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0014.tif" if dtimage_name != "" & (typecont == "gpn" | typecont == "spn")
gen dir15="L:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0015.tif" if dtimage_name != "" & typecont == "spn"

 compress
 
save "${ddtah}\temp_all.dta", replace
