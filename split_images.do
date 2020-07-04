**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: Split scanned files into individual images
**********************************************************

*use "L:\Data\Data Clean\Wave9\dtah\temp_all.dta",clear

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
*replace dtimage_name = subinstr(dtimage_name, "GPC", "GPN", .) if dtimage_name != "" & typecont == "gpn"

*Create batch files from excel files consisting of image directory produced from folder
foreach x in gpc sc sn hdc den{
import excel "D:\Data\Data Original\Wave9\Scans\\`x'\17-03-06.xlsx", sheet("Sheet1") allstring clear
generate image_dir_`x'=""
recast str244 image_dir_`x'
format %244s image_dir_`x'
replace image_dir_`x' = "i_view64.exe D:\Data\Data Original\Wave9\Scans\" + A + "\" + B + " /extract=(D:\Data\Data Original\Wave9\Scans\" + A + "x,tif)" + " /tifc=4"
outfile image_dir_`x' using "D:\Data\Data Original\Wave9\Scans\image_dir_`x'_06.bat", noquo replace
}
*
foreach x in gpc gpn sc hdc hdn dec{
import excel "D:\Data\Data Original\Wave9\Scans\\`x'\17-03-30.xlsx", sheet("Sheet1") allstring clear
generate image_dir_`x'=""
recast str244 image_dir_`x'
format %244s image_dir_`x'
replace image_dir_`x' = "i_view64.exe D:\Data\Data Original\Wave9\Scans\" + A + "\" + B + " /extract=(D:\Data\Data Original\Wave9\Scans\" + A + "x,tif)" + " /tifc=4"
outfile image_dir_`x' using "D:\Data\Data Original\Wave9\Scans\image_dir_`x'_30.bat", noquo replace
}
*

*Change names of directory variables to fit with the new directory
*drop dirall
gen dirall = ""
replace dirall = "D:\Data\Data Original\Wave9\Scans\" + dtimage_name + ".tif" if dtimage_name != ""

forvalues x = 1(1)9{
gen dir`x' = ""
replace dir`x'="D:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_000`x'.tif" if dtimage_name != ""
}
*
gen dir10=""
replace dir10="D:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0010.tif" if dtimage_name != ""
gen dir11=""
replace dir11="D:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0011.tif" if dtimage_name != "" & typecont != "dec" & typecont != "hdc"
gen dir12=""
replace dir12="D:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0012.tif" if dtimage_name != "" & typecont != "dec" & typecont != "hdc" & typecont != "den" & typecont != "hdn"
gen dir13=""
replace dir13="D:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0013.tif" if dtimage_name != "" & (typecont == "gpn" | typecont == "spn")
gen dir14=""
replace dir14="D:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0014.tif" if dtimage_name != "" & (typecont == "gpn" | typecont == "spn")
gen dir15=""
replace dir15="D:\Data\Data Original\Wave9\Scans\" + dtimage_name + "_page_0015.tif" if dtimage_name != "" & typecont == "spn"

save "L:\Data\Data Clean\Wave9\dtah\temp_all.dta", replace

*use "L:\Data\Data Clean\Wave9\dtah\temp_all.dta", clear

*drop dtimage_name dtimage_name1 dtimage_name2 dtimage_dir dtimage_dir_gpc_v2 dtimage_dir_gpn_v2 dtimage_dir_spc_v2 dtimage_dir_spn_v2 dtimage_dir_hdc_v2 dtimage_dir_hdn_v2 dtimage_dir_dec_v2 dtimage_dir_den_v2
*drop dirall dir1-dir15

*Loop command
*@echo off
*for %%a in ("D:\originaldirectory\*.tif") do (
*  "C:\Program Files\IrfanView\i_view64.exe" "%%~fa" /extract=("D:\newdirectory",tif)
*)

/*
generate dtimage_name=dtimage
replace dtimage_name=subinstr(dtimage_name, "G:\Projects\50581-MABEL 2016\IMAGES\", "", .)
gen numorder = _n
keep numorder dtimage_name
export excel using "D:\Data\Data Original\Wave9\Scans\dtimage_name.xlsx", firstrow(varlabels) replace

***work on Excel file, create dtimage_name1 and dtimage_name2***
sort numorder
merge 1:1 numorder using "D:\Data\Data Original\Wave9\Scans\dtimage_name.dta"
*/

/*Generate batch file for all
generate dtimage_dir=""
recast str244 dtimage_dir
format %244s dtimage_dir
replace dtimage_dir=`""C:\Program Files\IrfanView\i_view64.exe""' + `" ""' + "D:\Data\Data Original\Wave9\Scans\" + dtimage_name1 + dtimage_name2 + `"""' + " /extract=("+`"""'+"D:\Data\Data Original\Wave9\Scans\" + dtimage_name1 + `"x""' + ",tif)" if response=="Hardcopy" & dtimage_name != "" 
foreach x in gpc gpn spc spn hdc hdn dec den{
outfile dtimage_dir using "D:\Data\Data Original\Wave9\Scans\dtimage_dir_`x'.bat" if typecont=="`x'" & dtimage_dir != "", noquo replace
}
*/

/*
*Another way to generate batch files. Didn't use this because there were mismatches between dtimage values and true directory of images
foreach x in gpc gpn spc spn hdc hdn dec den{
generate dtimage_dir_`x'_v2=""
recast str244 dtimage_dir_`x'_v2
format %244s dtimage_dir_`x'_v2
replace dtimage_dir_`x'_v2 = "i_view64.exe D:\Data\Data Original\Wave9\Scans\" + dtimage_name1 + dtimage_name2 + " /extract=(D:\Data\Data Original\Wave9\Scans\" + dtimage_name1 + "x,tif)" if response=="Hardcopy" & dtimage_name != "" & typecont=="`x'"
outfile dtimage_dir_`x'_v2 using "D:\Data\Data Original\Wave9\Scans\dtimage_dir_`x'_v2.bat" if dtimage_dir_`x'_v2 != "", noquo replace
}
*/

/*
replace dtimage_name1 = subinstr(dtimage_name1, "6\", "6x\", .)
replace dtimage_name2 = subinstr(dtimage_name2, ".TIF", "", .)
split dtimage_name, p("B")
replace dtimage_name2="B"+dtimage_name2 if dtimage_name2 != ""
*/
