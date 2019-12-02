import excel "L:\Data\Samples\Wave 8\AMPCoFiles\all-quals 2015.xlsx", sheet("all-quals") firstrow clear
renvars _all, lower

sort listeeid
by listeeid: gen recno=_n

rename qualification qual_description
rename medicalschool school
rename yeargrad year_grad

