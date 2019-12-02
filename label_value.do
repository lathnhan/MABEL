*Date last modified: 1/12/2017
*Purpose: Edit the value labels 



** Updated for Wave 9 - 1/12/2017


********************************************************

global ddtah="L:\Data\Data Clean\Wave9\dtah"
global ddo="L:\Data\Data Clean\Wave9"
global dlog="L:\Data\Data Clean\Wave9\log"


*capture clear
capture log close
set more off

log using "${dlog}\label_value.log", replace

********************************************************

*use "${ddtah}\temp_all.dta", clear

********************************************************

*rename variables to match those in previous waves


*ren wlocrnapv wlocnapv
ren csrtn csclir


*create new variable name where variable has changed
*rename pimr pimr5
********************************************************

*convert string variables to numerical

replace continue="1" if continue=="Continue"
replace continue="0" if continue=="New"

replace source="1" if source=="Main"
replace source="2" if source=="Pilot"

replace response="1" if response=="Hardcopy"
replace response="2" if response=="Online"
replace response="3" if response=="Response Sheet"

replace state="1" if state=="ACT"
replace state="2" if state=="NSW"
replace state="3" if state=="NT"
replace state="4" if state=="QLD"
replace state="5" if state=="SA"
replace state="6" if state=="TAS"
replace state="7" if state=="VIC"
replace state="8" if state=="WA"

destring continue source response state, replace

gen picmdoi=.

replace picmdoi=1 if picmdo_country=="AFGHANISTAN"
replace picmdoi=3 if picmdo_country=="ARGENTINA"
replace picmdoi=4 if picmdo_country=="ARMENIA"
replace picmdoi=5 if picmdo_country=="AUSTRIA"
replace picmdoi=6 if picmdo_country=="BANGLADESH"
replace picmdoi=7 if picmdo_country=="BELARUS"
replace picmdoi=8 if picmdo_country=="BELGIUM"
replace picmdoi=9 if picmdo_country=="BOSNIA & HERZEGOVINA"
replace picmdoi=10 if picmdo_country=="BRAZIL"
replace picmdoi=11 if picmdo_country=="BULGARIA"
replace picmdoi=12 if picmdo_country=="BURMA"
replace picmdoi=12 if picmdo_country=="BURMA/THAILAND"
replace picmdoi=12 if picmdo_country=="MYANMAR"
replace picmdoi=14 if picmdo_country=="CANADA"
replace picmdoi=15 if picmdo_country=="CHILE"
replace picmdoi=16 if picmdo_country=="CHINA"
replace picmdoi=17 if picmdo_country=="COLOMBIA"
replace picmdoi=18 if picmdo_country=="CONGO"
replace picmdoi=20 if picmdo_country=="CROATIA"
replace picmdoi=21 if picmdo_country=="CZECH REPUBLIC"
replace picmdoi=22 if picmdo_country=="DENMARK"
replace picmdoi=24 if picmdo_country=="EGYPT"
replace picmdoi=26 if picmdo_country=="FIJI"
replace picmdoi=27 if picmdo_country=="FRANCE"
replace picmdoi=28 if picmdo_country=="GEORGIA"
replace picmdoi=29 if picmdo_country=="GERMANY"
replace picmdoi=30 if picmdo_country=="GHANA"
replace picmdoi=31 if picmdo_country=="HONG KONG"
replace picmdoi=32 if picmdo_country=="HUNGARY"
replace picmdoi=33 if picmdo_country=="INDIA"
replace picmdoi=34 if picmdo_country=="INDONESIA"
replace picmdoi=35 if picmdo_country=="IRAN"
replace picmdoi=36 if picmdo_country=="IRAQ"
replace picmdoi=37 if picmdo_country=="IRELAND"|picmdo_country=="REPUBLIC OF IRELAND"
replace picmdoi=53 if picmdo_country=="IRELAND/MALAYSIA"
replace picmdoi=38 if picmdo_country=="ISRAEL"
replace picmdoi=39 if picmdo_country=="ITALY"
replace picmdoi=40 if picmdo_country=="JAMAICA"
replace picmdoi=41 if picmdo_country=="JAPAN"
replace picmdoi=42 if picmdo_country=="JORDAN"
replace picmdoi=44 if picmdo_country=="KENYA"
replace picmdoi=46 if picmdo_country=="KYRGYZSTAN"
replace picmdoi=47 if picmdo_country=="LATVIA"
replace picmdoi=48 if picmdo_country=="LEBANON"
replace picmdoi=51 if picmdo_country=="MACEDONIA"
replace picmdoi=52 if picmdo_country=="MALAWI"
replace picmdoi=53 if picmdo_country=="MALAYSIA"
replace picmdoi=54 if picmdo_country=="MALTA"
replace picmdoi=55 if picmdo_country=="MEXICO"
replace picmdoi=57 if picmdo_country=="NEPAL"
replace picmdoi=58 if picmdo_country=="NETHERLANDS"
replace picmdoi=59 if picmdo_country=="NEW ZEALAND"
replace picmdoi=60 if picmdo_country=="NIGERIA"
replace picmdoi=61 if picmdo_country=="PAKISTAN"
replace picmdoi=62 if picmdo_country=="PAPUA NEW GUINEA"
replace picmdoi=63 if picmdo_country=="PERSIA"
replace picmdoi=64 if picmdo_country=="PERU"
replace picmdoi=65 if picmdo_country=="PHILIPPINES"
replace picmdoi=66 if picmdo_country=="POLAND"
replace picmdoi=67 if picmdo_country=="RHODESIA"
replace picmdoi=68 if picmdo_country=="ROMANIA"
replace picmdoi=69 if picmdo_country=="RUSSIAN FEDERATION"|picmdo_country=="RUSSIA"
replace picmdoi=70 if picmdo_country=="SAUDI ARABIA"
replace picmdoi=71 if picmdo_country=="SERBIA"
replace picmdoi=72 if picmdo_country=="SINGAPORE"
replace picmdoi=73 if picmdo_country=="SLOVAKIA"
replace picmdoi=74 if picmdo_country=="SOUTH AFRICA"
replace picmdoi=75 if picmdo_country=="SPAIN"
replace picmdoi=76 if picmdo_country=="SRI LANKA"
replace picmdoi=77 if picmdo_country=="SUDAN"
replace picmdoi=78 if picmdo_country=="SWEDEN"
replace picmdoi=79 if picmdo_country=="SWITZERLAND"
replace picmdoi=80 if picmdo_country=="SYRIA"
replace picmdoi=81 if picmdo_country=="TAIWAN"
replace picmdoi=82 if picmdo_country=="TANZANIA"
replace picmdoi=83 if picmdo_country=="THAILAND"
replace picmdoi=85 if picmdo_country=="TURKEY"
replace picmdoi=86 if picmdo_country=="UGANDA"
replace picmdoi=87 if picmdo_country=="UKRAINE"
replace picmdoi=88 if picmdo_country=="UNITED ARAB EMIRATES"
replace picmdoi=89 if picmdo_country=="UNITED KINGDOM"
replace picmdoi=90 if picmdo_country=="UNITED STATES"|picmdo_country=="USA"
replace picmdoi=92 if picmdo_country=="UZBEKISTAN"
replace picmdoi=93 if picmdo_country=="VENEZUELA"
replace picmdoi=94 if picmdo_country=="VIETNAM"
replace picmdoi=95 if picmdo_country=="ZAMBIA"
replace picmdoi=96 if picmdo_country=="ZIMBABWE"
replace picmdoi=97 if picmdo_country=="ETHIOPIA"  |picmdo_country=="BENIN" |picmdo_country=="YEMEN"  //other africa
replace picmdoi=98 if picmdo_country=="OMAN"  //other asia
replace picmdoi=99 if picmdo_country=="GREECE"|picmdo_country=="PORTUGAL" //other Europe
replace picmdoi=100 if picmdo_country=="GUATEMALA"|picmdo_country=="ECUADOR"  //other south america


*******************************************************

*recode categorical variables to match those in previous waves

foreach x of var *_multi* {

destring `x', replace

}

*recode jssc  (0=0) (1=10) (2=1) (3=11) (4=2) (5=12) (6=3) (7=13) (8=4) (9=14) (10=5) (11=15) /// 
			*(12=6) (13=16) (14=7) (15=17) (16=8) (17=18) (18=9), gen()
			
*recode jssc jssc_multi*(0=0) (1=10) (2=1) (3=11) (4=2) (5=12) (6=3) (7=13) (8=4) (9=14) (10=5) (11=15) /// 
			*(12=6) (13=16) (14=7) (15=17) (16=8) (17=18) (18=9), gen()	

*recode piste piste_multi* (1=0) (2=13) (3=9) (4=5) (5=1) (6=14) (7=10) (8=6) (9=2) (10=15) (11=11) (12=7) /// 
*			 (13=3) (14=16) (15=12) (16=8) (17=4) , gen()

*******************************************************

**********************
*    Value Labels
**********************

label drop _all

#delimit;

label val 	csncli csml cshd csstu csexl csocli csoncli csonmd csnmd csovs csdeath 
			jsbsdk  wltms wlttr wltrg wltnt wlana wlobs 
			wlsur wleme wlnon 
			wlante wlwom wlpsych wlskin wlchild wlsport wlotspe
			wlnt wlna wlcna wlvadk wlvana 
			wlcfna wlbpna wlocrnap wlocrnah wlocnapb wlocnapv wlocna 
			wlcotnap wlcotnah wlcotnapb wlcotnapv fimedk fidpdk fidpna 
			glrna glrlpv glrltv glrlrs glrlrp glrlot glrlna 
			fcpr_dk fcpr_na fcprt_dk fcprt_na fcayna fcccrf fcccn fccccw 
			fcccdc fcccna picmda picmdo  pirna pifyrna pisapna pisappc pisappm 
			pisaprm pisapde pisapma pisapop pisapps pisapsu  pisapom pisapph 
			pisapan pisapai pisapem pisapgp pisapic pisapog pisappa pisapra pisapim 
			pisashm pisaspo wlacto wlactc wlactn wlocot
			jsmaddi jsmapan jsmapde jsmapem jsmapgp jsmapic jsmapma jsmapog jsmapom jsmapop
			jsmappc jsmapai jsmappm jsmappa jsmaphy jsmapps jsmapph jsmapon jsmapra jsmaprm 
			jsmashm jsmaspo jsmapsu jsmaoth jsmapna jsmsome
			marked;
		
label de marked 0 "response blank" 1 "response marked";

**********************;
#delimit;
label val 	csclid cspret pwcl pwwh pwahnc wlah fib  gltps fclp pwacc pwni pirps 
			 cheque piin piinf pides pider pidef piviv pivpc pidmn 
			wlspint fics pimrgen pimrspe pimrpro pimrlim pimrnon 
			glnfive glnpast glnfund pires fracgp facrrm fwshpoth yesno;
label de yesno 0 "no" 1 "yes";

**********************;
#delimit;
label val 	csclir piqonr unsure;
label de unsure 0 "no" 1 "yes" 2 "unsure";

**********************;

label val 	fcpmd picamc piis na;
label de na 0 "no" 1 "yes" 2 "not applicable";

**********************;

label val jsfm jsva jspw jsau jscw jsrc jshw jswr jsrp jsfl satis;
label de satis 	0 "very dissatisfied" 1 "moderately dissatisfied" 2 "not sure" 
				3 "moderately satisfied" 4 "very satisfied" 5 "not applicable";

**********************;
#delimit;
label val 	jshp jsbc jssn jsto jspe jscp jsqs jsps jsst 
			jspu jspt jsuh jssm jslq jsco jsfs glfiw glbl glpfiw glgeo 
			jshe jswl jslj
			glacsc fcrwncc fcpwncc fcoq fiefr agree;
label de agree 	0 "strongly disagree" 1 "disagree" 2 "neutral" 
				3 "agree" 4 "strongly agree" 5 "not applicable";

**********************;
#delimit;
label val jsch change;
label de change 	0 "no" 1 "yes, I'd like to increase my hours" 
					2 "yes, I'd like to decrease my hours";

******new for wave 8*********;
#delimit;
label val jsred reduce;
label de reduce	1 "this could be achieved easily within my current job"
					2 "this could be achieved with some difficulty in my current job"
					3 "I would have to change jobs, but there are suitable opportunities in my local area"
					4 "I would have to change jobs, and such jobs are scarce"
					5 "This would be impossible"
					6 "Don't know";
	
label val jsredt reducet;
label de reducet	1 "this could be achieved easily within my current training program"
					2 "this could be achieved with some difficulty in my current training program"
					3 "I would have to change training program"
					4 "This would be impossible"
					5 "Don't know";
					

**********************;

label val jsas jsas;
label de jsas 		0 "no" 1 "yes" 2 "unsure" 3 "no, I already have a place" 
					4 "no, I already have a specialist/GP qualification";

**********************;

label val pwpip pwpip;
label de pwpip 		0 "no" 1 "yes, in a public or private hospital and private consulting rooms" 
					2 "yes, in a public or private hospital only";

**********************;

label val pwbr pwbr;
label de pwbr 		0 "principal or partner" 1 "associate" 2 "salaried employee" 
					3 "contracted employee" 4 "locum" 5 "other";

**********************;

label val pwoce limit;
label de limit 		0 "very limited" 1 "average" 2 "very good";

**********************;

label val pwsp pwsp;
label de pwsp 	0 "intern" 2 "HMO Yr1" 3 "HMO Yr2" 4 "HMO Yr3" 1 "CMO" 
				5 "other hospital medical officer";

**********************;
#delimit;
label val pwpm pwpm;
label de pwpm 	0 "fee-for-service / bill patients directly" 1 "fixed payment per session or hour" 
				2 "salary - no rights to private practice" 3 "salary with rights to private practice" 
				4 "other";

**********************;

label val wlprop wlprop;
label de wlprop	0 "< 25%"
				1 "26-50%"
				2 "51-75%"
				3 ">75%";

**********************;

label val wlal wlal;
label de wlal 	0 "moderately easy" 1 "rather difficult" 2 "very difficult" 3 "not applicable";

**********************;

label val wlhth wlhth;
label de wlhth 	0 "excellent" 1 "very good" 2 "good" 3 "fair" 4 "poor";

**********************;

label val fips fips;
label de fips 	0 "sole trader" 1 "partnership" 2 "company" 3 "trust" 4 "don't know" 5 "not applicable";

**********************;

label val glrl glrl;
label de glrl 	0 "no" 1 "yes - I am required to work in an area of need" 
				2 "yes - I am required to work in a district of workforce shortage";

**********************;

label val fcpes fcpes;
label de fcpes 	0 "not in labour force" 1 "currently seeking work" 2 "full-time employment" 
				3 "part-time employment" 4 "not applicable";

**********************;

label val pirs pirs;
label de pirs 	0 "australian citizen" 1 "permanent resident" 2 "temporary resident" 9 "unchanged since I last completed the MABEL survey";

**********************;

label val pilfsa pilfsa;
label de pilfsa 1 "completely dissatisfied" 10 "completely satisfied";

**********************;
#delimit;
label val 	pertj perct perrd peror perwo perfr perlz persoc perart pernev pereff 
			perrsv perknd perimg perstr personal;
label de personal 1 "does not apply to me at all" 7 "applies to me perfectly";

**********************;

label val pilc_1 pilc_2 pilc_3 pilc_4 pilc_5 pilc_6 pilc_7 control;
label de control 1 "strongly disagree" 7 "strongly agree";

**********************;
label val pifirisk picarisk piclrisk risk;
label de risk 1 "very unlikely" 5 "very likely";


**********************;
#delimit;
label val type sdtype type;
label de type 1 "GP" 2 "specialist" 3 "hospital non-specialist" 4 "specialist-in-training";

**********************;

label val continue new;
label de new 0 "new" 1 "continuing";

**********************;

label val response mode;
label de mode 1 "hardcopy" 2 "online" 3 "response sheet" 4 "AMPCo database";

**********************;

label val pigeni gender;
label de gender 0 "male" 1 "female";

**********************;

label val source source;
label de source 1 "main survey" 2 "pilot survey";

**********************;
#delimit;
label val jssc training1;
label de training1 	0 "Not Applicable - I do not currently have a place" 
					1 "Paediatrics and Child Health" 
					2 "Palliative Medicine" 
					3 "Rehabilitation Medicine" 
					4 "Dermatology" 
					5 "General Practice" 
					6 "Medical Administration" 
					7 "Ophthalmology" 
					8 "Psychiatry" 
					9 "Surgery" 
					10 "Internal medicine (adult medicine)" 
					11 "Occupational Medicine" 
					12 "Public Health Medicine" 
					13 "Anaesthesia" 
					14 "Emergency Medicine" 
					15 "Intensive Care Medicine" 
					16 "Obstetrics and Gynaecology" 
					17 "Pathology" 
					18 "Radiology"
					19 "Addiction Medicine (wv6)"
					20 "Pain Medicine (wv6)"
					21 "Radiation Oncology (wv6)"
					22 "Sexual Health Medicine (wv6)"
					23 "Sport and Exercise Medicine (wv6)";
					
#delimit;					
label val jssc6 piste6 trainwv6;
label de trainwv6 	0 "Not Applicable - I do not currently have a place" 
					1 "Addiction medicine" 
					2 "Anaesthesia" 
					3 "Dermatology" 
					4 "Emergency medicine"
					5 "General Practice" 
					6 "Intensive care medicine" 
					7 "Medical Administration" 
					8 "Obstetrics and Gynaecology" 
					9 "Occupational and environmental medicine" 
					10 "Ophthalmology" 
					11 "Paediatrics and child health" 
					12 "Pain medicine" 
					13 "Palliative medicine" 
					14 "Pathology" 
					15 "Physician" 
					16 "Psychiatry" 
					17 "Public health medicine" 
					18 "Radiation oncology"
					19 "Radiology"
					20 "Rehabilitation medicine"
					21 "Sexual Health Medicine"
					22 "Sport and Exercise Medicine"
					23 "Surgery";				
					

**********************;
#delimit;
label val piste training2;
label de training2 	0 "Paediatrics and Child Health"
					1 "Rehabilitation Medicine" 
					2 "Medical Administration" 
					3 "Psychiatry" 
					4 "Internal medicine (adult medicine)" 
					5 "Public Health Medicine" 
					6 "Emergency Medicine" 
					7 "Obstetrics and Gynaecology" 
					8 "Radiology" 
					9 "Palliative Medicine" 
					10 "Dermatology" 
					11 "Ophthalmology" 
					12 "Surgery" 
					13 "Occupational Medicine" 
					14 "Anaesthesia" 
					15 "Intensive Care Medicine" 
					16 "Pathology"
					17 "Addiction Medicine (wv6)"
					18 "Pain Medicine (wv6)"
					19 "Radiation Oncology (wv6)"
					20 "Sexual Health Medicine (wv6)"
					21 "Sport and Exercise Medicine (wv6)";

**********************;

					
					
			

					
*create new variables for specialties in W6



#delimit;

label val pimsp6 pisesp6  specialty6;
label de specialty6 	0 "Cardiology"
					1 "Clinical genetics"
					2 "Clinical pharmacology"
					3 "Endocrinology"
					4 "Gastroenterology and hepatology"
					5 "General medicine"
					6 "Geriatric medicine"
					7 "Haematology"
					8 "Immunology & allergy"
					9 "Infectious diseases"
					10 "Medical oncology"
					11 "Neurology"
					12 "Nuclear medicine"
					13 "Nephrology"
					14 "Rheumatology"
					15 "Respiratory and sleep medicine"
					16 "General surgery"
					17 "Cardiothoracic surgery"
					18 "Oral and Maxillofacial Surgery"
					19 "Orthopaedic surgery"
					20 "Otolaryngology"
					21 "Paediatric surgery"
					22 "Plastic surgery"
					23 "Urology"
					24 "Neurosurgery"
					25 "Vascular surgery"
					26 "Addiction Medicine"
					27 "Anaesthesia "
					28 "Dermatology"
					29 "Emergency medicine"
					30 "Intensive care medicine"
					31 "Medical administration"
					32 "Obstetrics and gynaecology"
					33 "Occupational and environmental  medicine"
					34 "Ophthalmology"
					35 "Paediatrics and Child Health"
					36 "Pain Medicine"
					37 "Palliative Medicine"
					38 "Pathology"
					39 "Psychiatry"
					40 "Public health medicine"
					41 "Radiology"
					42 "Radiation oncology"
					43 "Rehabilitation medicine"
					44 "Sexual Health Medicine"
					45 "Sport and exercise medicine"
					46 "Other specialty - Not specified above";


					
*create new cross-wave specialty variable 

#delimit;

label val pimspx pisespx specialtyx;
label de specialtyx 0 "Cardiology"
					1 "Clinical genetics"
					2 "Clinical haematology"
					3 "Clinical immunology (incl. allergy)"
					4 "Clinical pharmacology"
					5 "Endocrinology"
					6 "Gastroenterology"
					7 "General medicine"
					8 "Geriatrics"
					9 "Infectious diseases"
					10 "Intensive care - internal medicine"
					11 "Medical oncology"
					12 "Neurology"
					13 "Nuclear medicine"
					14 "Paediatric medicine"
					15 "Renal medicine"
					16 "Rheumatology"
					17 "Thoracic medicine"
					18 "Pathology"
					19 "General surgery"
					20 "Cardiothoracic surgery"
					21 "Orthopaedic surgery"
					22 "Otolaryngology"
					23 "Paediatric surgery"
					24 "Plastic/reconstructive surgery"
					25 "Urology"
					26 "Neurosurgery"
					27 "Vascular surgery"
					28 "Anaesthesia"
					29 "Dermatology"
					30 "Diagnostic radiology (incl. ultrasound)"
					31 "Emergency medicine"
					32 "Medical administration"
					33 "Obstetrics and gynaecology (incl. gynaecological oncology)"
					34 "Occupational medicine"
					35 "Ophthalmology"
					36 "Psychiatry"
					37 "Public health medicine"
					38 "Radiation oncology"
					39 "Rehabilitation medicine"
					40 "Sport and exercise medicine"
					41 "Palliative Medicine"
					42 "OTHER SPECIALTY not specified above" 	;
				

**********************;

#delimit;


label var picmdoi 	"IMPUTED - Specified country/region";

label val picmdoi country;
label de country 	1 "Afghanistan"
					2 "Albania"
					3 "Argentina"
					4 "Armenia" 
					5 "Austria"
					6 "Bangladesh"
					7 "Belarus"
					8 "Belgium"
					9 "Bosnia & Herzegovina"
					10 "Brazil"
					11 "Bulgaria"
					12 "Burma/Myanmar"
					13 "Cambodia"
					14 "Canada"
					15 "Chile"
					16 "China"
					17 "Colombia"
					18 "Congo"
					19 "Costa Rica"
					20 "Croatia"
					21 "Czech Republic"
					22 "Denmark"
					23 "Ecuador"
					24 "Egypt"
					25 "Ethiopia"
					26 "Fiji"
					27 "France"
					28 "Georgia"
					29 "Germany"
					30 "Ghana"
					31 "Hong Kong"
					32 "Hungary"
					33 "India"
					34 "Indonesia"
					35 "Iran"
					36 "Iraq"
					37 "Ireland"
					38 "Israel"
					39 "Italy"
					40 "Jamaica"
					41 "Japan" 
					42 "Jordan" 
					43 "Kazakhstan"
					44 "Kenya"
					45 "Korea"
					46 "Kyrgyzstan"
					47 "Latvia"
					48 "Lebanon" 
					49 "Libya" 
					50 "Lithuania" 
					51 "Macedonia"
					52 "Malawi"
					53 "Malaysia"
					54 "Malta"
					55 "Mexico"
					56 "Moldova"
					57 "Nepal"
					58 "Netherlands"
					59 "New Zealand"
					60 "Nigeria"
					61 "Pakistan"
					62 "Papua New Guinea"
					63 "Persia"
					64 "Peru"
					65 "Philippines"
					66 "Poland"
					67 "Rhodesia"
					68 "Romania"
					69 "Russian Federation"
					70 "Saudi Arabia"
					71 "Serbia"
					72 "Singapore"
					73 "Slovakia"
					74 "South Africa"
					75 "Spain"
					76 "Sri Lanka"
					77 "Sudan"
					78 "Sweden"
					79 "Switzerland"
					80 "Syria"
					81 "Taiwan" 
					82 "Tanzania"
					83 "Thailand"
					84 "Trinidad & Tobago"
					85 "Turkey"
					86 "Uganda"
					87 "Ukraine" 
					88 "United Arab Emirates" 
					89 "United Kingdom"
					90 "United States"
					91 "Uruguay" 
					92 "Uzbekistan" 
					93 "Venezuela" 
					94 "Vietnam"
					95 "Zambia"
					96 "Zimbabwe"
					97 "Others Africa"
					98 "Other Asia"
					99 "Other Europe"
					100 "Other S America" ;

**********************;

#delimit;
preserve;
keep *asgc;
desc *asgc, varlist;
restore;

foreach x in `r(varlist)' {;
label val `x' asgc;
};

label de asgc 	1 "Major city" 
				2 "Inner regional" 
				3 "Outer regional" 
				4 "Remote" 
				5 "Very remote";

preserve;
keep *rrma;
desc *rrma, varlist;
restore;

foreach x in `r(varlist)' {;
label val `x' rrma;
};

label de rrma 	1 "Capital city" 
				2 "Other metropolitan" 
				3 "Large rural" 
				4 "Small rural" 
				5 "Other Rural" 
				6 "Remote centre" 
				7 "Other remote";

#delimit;
preserve;
keep *mmm;
desc *mmm, varlist;
restore;

foreach x in `r(varlist)' {;
label val `x' mmm;
};

label de mmm 	1 "MMM 1" 
				2 "MMM 2" 
				3 "MMM 3" 
				4 "MMM 4" 
				5 "MMM 5" 
				6 "MMM 6" 
				7 "MMM 7";				
				
				
				
				
				
**********************;

label val pims 	school;
label de school 	0 "Not Applicable"
					1 "University of Newcastle"
					2 "University of Adelaide"
					3 "University of Notre Dame WA"
					4 "Australian National University"
					5 "University of Notre Dame Sydney"
					6 "Bond University"
					7 "University of NSW"
					8 "Deakin University"
					9 "University of Queensland"
					10 "Flinders University"
					11 "University of Sydney"
					12 "Griffith University"
					13 "University of Tasmania" 
					14 "James Cook University"
					15 "University of WA (undergraduate)"
					16 "University of Melbourne (undergraduate)"
					17 "University of WA (postgraduate)" 
					18 "University of Melbourne (postgraduate)"
					19 "University of Western Sydney"
					20 "Monash University (undergraduate)"
					21 "University of Wollongong"
					22 "Monash University (postgraduate)"
					23 "Universty of New England & University of Newcastle Joint Medical Program";

**********************;

label val state state;
label de state 		1 "ACT"
					2 "NSW"
					3 "NT"
					4 "QLD"
					5 "SA"
					6 "TAS"
					7 "VIC"
					8 "WA";

**********************;

label val piinhl piinfhl pideshl piderhl pidefhl pivivhl pivpchl pidmnhl howlong;
label de howlong 	0 "0 to 3 months ago" 
					1 "4 to 6 months ago" 
					2 "7 to 9 months ago" 
					3 "10 to 12 months ago";

**********************;


*create group variables for pimsp/pisesp/piste;
#delimit;
recode pimspx (0/17 = 1) (18 = 2) (19/27 = 3) (28/42 = 4) , g(pimspgx);
recode pisespx (0/17 = 1) (18 = 2) (19/27 = 3) (28/42 = 4), g(pisespgx);
recode piste (0 4 15 = 1) (16 = 2) (12 = 3) (1/3 5/11 13 14 17 18 19 21 = 4), g(pisteg);
recode jssc (10=1) (9=3) ( 1 2 3 4 6 7 8 11 12 13 14 15 16 17 18 20 21 23=4) (5=5), g(jsscg); 

/*I don't think we want these included
recode pimsp6 (0/15 = 1) (16/25 = 2) (26/46 = 3), g(pimspg6);
recode pisesp6 (0/15 = 1) (16/25 = 2) (26/46 = 3), g(pisespg6);
recode piste6 (1/14 16/21  = 3) (15 = 1) (23 = 2) , g(pisteg6);*/

#delimit;

label val pimspgx pisespgx pisteg specialtygroup;
label de specialtygroup 	1 "Physician"
							2 "Pathology"
							3 "Surgery"
							4 "Other";
							
							
label val jsscg	jsscg;
label de jsscg 				0 "N/A"
							1 "Physician"
							3 "Surgery"
							4 "Other specialties"
							5 "General practice";							

/*label val pimspg6 pisespg6 pisteg6 specialtygr6;
label de specialtygr6		1 "Physician"
							2 "Surgery"
							3 "Other";*/
							

label var pisteg 	"GROUP - Which training program are you enrolled in?";
label var pimspgx 	"GROUP - What is the main specialty in which you practise?";
label var pisespgx 	"GROUP - What is the second specialty in which you practise?";

****************************;





#delimit cr

compress

numlabel _all, add mask([#]) force




