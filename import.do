**********************************************************
*WAVE 9 MABEL DATA CLEANING AND MANAGEMENT
*Authors: Nhan La, Tammy Taylor
*Date last modified: 14 October 2017
*Purpose: change format to stata
**********************************************************

global session="L:\Data\Data Original\Wave9\Online"
*local session onlineresponse_2041209
**********************************************************

*pilot in progress

import delimited "${session}\DEW9C.csv", varnames(1) clear
save "${session}\DEW9C.DTA", replace

import delimited "${session}\DEW9N.csv", varnames(1) clear
save "${session}\DEW9N.DTA", replace

import delimited "${session}\GPW9C.csv", varnames(1) clear
save "${session}\GPW9C.DTA", replace

import delimited "${session}\GPW9N.csv", varnames(1) clear
save "${session}\GPW9N.DTA", replace

import delimited "${session}\HDW9C.csv", varnames(1) clear
save "${session}\HDW9C.DTA", replace

import delimited "${session}\HDW9N.csv", varnames(1) clear
save "${session}\HDW9N.DTA", replace

import delimited "${session}\SPW9C.csv", varnames(1) clear
save "${session}\SPW9C.DTA", replace

import delimited "${session}\SPW9N.csv", varnames(1) clear
save "${session}\SPW9N.DTA", replace
