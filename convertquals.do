**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: Convert qualifications
**********************************************************

import excel "L:\Data\Samples\Wave 8\AMPCoFiles\all-quals 2015.xlsx", sheet("all-quals") firstrow clear
renvars _all, lower

sort listeeid
by listeeid: gen recno=_n

rename qualification qual_description
rename medicalschool school
rename yeargrad year_grad

