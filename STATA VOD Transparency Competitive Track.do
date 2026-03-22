*IMPORT ARCHIVED DATA. ONLY RUN THIS CODE IF SOMETHING IN ARCHIVED DATA NEEDS TO BE CHANGED*
/*
import excel using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Input\VOD Transparency\moyear_lookup.xlsx", clear firstrow
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\moyear_lookup.dta", replace
insheet using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Input\VOD Transparency\Archived Monthly Files\vod_transparency_trend2.csv", clear
keep month year series season title network txns playtime hhs estvodhhmm ofdays
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_transparency_trend2.dta", replace

insheet using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Input\VOD Transparency\Archived Monthly Files\vod_transparency_trend.csv", clear
keep month year series season title network txns playtime hhs estvodhhmm ofdays

append using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_transparency_trend2.dta"
merge m:1 month year using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\moyear_lookup.dta"
order moyear, before(series)
drop if _m==2
drop _m
drop month year
replace hhs = "0" if hhs == "-"
replace playtime = "0" if playtime == "-"
destring txns hhs playtime, replace ignore(",")
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Data\vod_transparency_archive.dta", replace
*/

*IMPORT CALL LETTERS LOOKUP*
import excel using "K:\Rainbow Research\1-amc research\STATA\Lookups\network_names_type_call.xlsx", clear firstrow
contract net_type net network_clean network_fvod
drop if network_fvod == ""
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\call_letter_lookup.dta", replace
drop _f
contract net_type net network_clean
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\call_letter_lookup_linear_only.dta", replace

*IMPORT NEW NIELSEN PROGRAMS AND GENRES*
insheet using "K:\Rainbow Research\1-amc research\AMC-SUN Tableau\STATA\Input\Rankers\Lookups\Net Program Genre Lookup.csv", clear
drop prog_clean
drop if genre == "N/A"
rename program nielsen_program
foreach var of varlist net nielsen_program genre {
	replace `var' = trim(itrim(upper(`var')))
	}

drop tc
drop if nielsen == "TALES" & genre == "SPECIAL"
drop if genre == "UNCLASSIFIED"
drop if nielsen == "BEING" & subgenre == "DOCUMENTARY"
drop if nielsen == "DEADLIEST CATCH SPC" & subgenre == "DOCUMENTARY"
drop if nielsen == "SCIENCE OF STUPID" & subgenre == "DOCU-SOAP/SERIES"
drop if nielsen == "WICKED TUNA: OUTER BANKS" & subgenre == "DOCUMENTARY"
drop if nielsen == "SECRETS OF THE LOST" & subgenre == "DOCU-SOAP/SERIES"
contract net nielsen_program genre subgenre
drop _freq
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\new_nielsen_prog.dta", replace

*IMPORT FVOD LOOKUP (PROG LEVEL)*
import excel using "K:\Rainbow Research\1-amc research\STATA\Lookups\vod_transparency_lookup_full.xlsx", clear firstrow sheet("append1")
foreach var of varlist net_type net network fvod_ nielsen_ genre _m content {
	replace `var' = trim(itrim(upper(`var')))
	}
	
*rename nets that changed over
replace net = "PAR" if net == "SPIKE"
replace net = "PAR" if net == "SPKE"
replace net = "MT" if net == "VEL"
replace network = "PARAMOUNT" if net == "PAR"
replace network = "MOTORTREND" if net == "MT"

*fix duplicates
duplicates tag net_type net network fvod_program, gen(tag)
replace genre = "UNSCRIPTED" if tag == 1 & net == "MT" & genre != "UNCLASSIFIED"
replace nielsen_program = "COPS" if nielsen_program == "COPS (O)"
replace nielsen_program = "GONE: THE FORGOTTEN WOMEN" if nielsen_program == "GONE" & net == "PAR"
replace nielsen_program = "CARS THAT ROCK WITH BRIAN JOHNSON" if nielsen_program == "CARS THAT ROCK WITH BRIAN"
replace nielsen_program = "FANTOMWORKS" if nielsen_program == "FANTOM WORKS"
replace nielsen_program = "SALVAGE HUNTERS: CLASSIC CARS" if nielsen_program == "SALVAGE HUNTERS: CLASSIC"
replace nielsen_program = "WEST COAST CUSTOMS" if nielsen_program == "INSIDE WEST COAST CUSTOMS"
replace genre = "UNSCRIPTED" if nielsen_program == "GONE: THE FORGOTTEN WOMEN"
drop if tag >0 & genre == "UNCLASSIFIED"

contract net_type net network fvod_program nielsen_prog genre subgenre
drop _freq
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_lookup.dta", replace

*Patch on Genre merging out of order - fix order of merge with series that also had program names added to them to remove this
drop if inlist(genre,"UNCLASSIFIED","N/A")
contract net_type net network nielsen_prog genre subgenre
rename genre genre1
rename subgenre subgenre1
drop _f
save  "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_lookup_nielsen.dta", replace

*IMPORT AND APPEND MONTHLY TITLE TRANSPARENCY FILES*
set more off
local files : dir "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Input\VOD Transparency\Monthly Files\" files "*.xlsx"
foreach f in `files' {
     import excel using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Input\VOD Transparency\Monthly Files\\`f'", clear firstrow
	 drop if inlist(Network,"Participating Networks Total","All Other Networks","All Networks Total")
	 drop if Txns == .
	 drop Rnk TxnRate
	 destring AvgPlaytimeperTxn, replace ignore(",")
	 destring HHs, replace ignore(",")
	 destring Playtime, replace ignore(",")
	 save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\VOD Transparency Monthly Files\\`f'.dta", replace  
	 }

clear
 
local data : dir "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\VOD Transparency Monthly Files\" files "*.dta"
foreach d in `data' {
	 append using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\VOD Transparency Monthly Files\\`d'"
}
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_monthly_append.dta", replace

***CONTRACT PROGRAMS FOR LOOKUP - FIND EXISTING MATCHES, NEW MATCHES, ALL REMAINING TITLES***
replace Series = trim(itrim(upper(Series)))
rename Network network
rename Series fvod_program
replace network = subinstr(network,"*","",.)
replace network = subinstr(network,"+","",.)
replace network = trim(itrim(upper(network)))
contract network fvod_program
drop _freq

*MERGE CALL LETTERS, NET TYPE*
rename network network_fvod
merge m:1 network_fvod using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\call_letter_lookup.dta"
drop if _m==2
replace network_fvod = network_clean if network_clean != ""
drop network_clean
drop _m _freq
drop if fvod_program == ""

*rename nets that changed over
replace net = "PAR" if net == "SPIKE"
replace net = "PAR" if net == "SPKE"
replace net = "MT" if net == "VEL"
replace network = "PARAMOUNT" if net == "PAR"
replace network = "MOTORTREND" if net == "MT"

*FIND EXISTING MATCHES*
rename network_fvod network
merge m:1 net_type net network fvod_program using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_lookup.dta"
keep if _m==1
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\new_fvod_prog.dta", replace
*DROP SPANISH/KIDS/NON-NIELSEN MEASURED NETS*
drop if inlist(network,"DISCOVERY EN ESPANOL","DISCOVERY FAMILIA","DISNEY CHANNEL","DISNEY JUNIOR","GALAVISION","KABILLION")
drop if inlist(network,"MILITARY CHANNEL","MTV TR3S","NICKELODEON ESP","TEL","UMA","UNIVERSAL KIDS","UNIVERSO","UNIVISION")
drop nielsen_program genre _m subgenre
gen nielsen_program = fvod_program
replace nielsen_program = subinstr(nielsen_program,"(BBC)","",.)
replace nielsen_program = subinstr(nielsen_program,"(SPIKE)","",.)
replace nielsen_program = subinstr(nielsen_program,"'","",.)
replace nielsen_program = subinstr(nielsen_program,"!","",.)
replace nielsen_program = subinstr(nielsen_program,"(ORIGINAL)","",.)
replace nielsen_program = trim(itrim(upper(nielsen_program)))
replace nielsen_program = subinstr(nielsen_program,nielsen_program,nielsen_program+", THE",.) if strpos(nielsen_program,"THE ")==1
replace nielsen_program = subinstr(nielsen_program,"THE ","",.) if strpos(nielsen_program,"THE ")==1
replace nielsen_program = trim(itrim(upper(nielsen_program)))

merge m:1 net nielsen_program using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\new_nielsen_prog.dta"
drop if _m==2
order net_type net network fvod_program nielsen_program genre subgenre
gsort -_m
replace nielsen_program = "" if _m==1
export excel using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Output\VOD Transparency\new_prog_matches.xlsx", replace firstrow(variables)
***END PROCESS FOR PROGRAM LEVEL MERGE. USE THIS OUTPUT TO ADD TO FVOD PROGRAM GENRE FULL LOOKUP*
*RE-RUN VOD FULL LOOKUP NOW THAT NEW MATCHES HAVE BEEN FOUND (ROWS 33 - 47)*



****IMPORT FVOD LOOKUP (TITLE LEVEL)****
import excel using "K:\Rainbow Research\1-amc research\STATA\Lookups\fvod_title_lookup.xlsx", clear firstrow sheet("MAIN LOOKUP TAB")
contract network_clean original_title series_title season_title title_clean ep_title ep_title2 genre_title code_type form_type
drop _freq

*DROP DUPLICATES FOR NOW AS LONG AS MINIMAL*
duplicates tag network_clean original_title, gen(tag)
drop if tag >0
drop tag
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_level_lookup.dta", replace



******USE ALL DATA AND NEWLY UPDATED LOOKUPS TO GENERATE NEW OUTPUT FILE*****
/*MAKE SURE THAT YOU HAVE: 
	RE-RUN VOD FULL LOOKUP NOW THAT NEW MATCHES HAVE BEEN FOUND (ROWS 44 - 47)
	UPDATED TITLE LOOKUP AND THEN RE-RUN FULL TITLE LOOKUP FOR NEWEST MATCHES (ROWS 125 - 133) */

**BEGIN PROCESS FOR FULL DATA MERGE AND OUTPUT**
use "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_monthly_append.dta", clear
*RENAME VARIABLES AND APPEND HISTORICAL DATA*
rename Series series
rename Season season
rename Title title
rename Network network
rename Txns txns
rename HHs hhs
rename Playtime playtime
rename HHUEMM estvodhhmm
rename ofdays ofdaysonvodinreportperiod
rename month moyear
keep moyear series season title network txns playtime hhs estvodhhmm ofdays
append using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Data\vod_transparency_archive.dta"

replace series = trim(itrim(upper(series)))
rename network network_fvod
rename series fvod_program

*CLEAN NETWORK NAMES FOR LOOKUP MERGE*
replace network = subinstr(network,"*","",.)
replace network = subinstr(network,"+","",.)
replace network = trim(itrim(upper(network)))
replace network = "FREEFORM" if network == "ABC FAMILY"
replace net = "FRFM" if net == "ABCF"
merge m:1 network_fvod using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\call_letter_lookup.dta"
drop if _m==2
replace network_fvod = network_clean if network_clean != ""
drop network_clean
drop _m _freq

*MERGE IN TITLE LOOKUP FOR TITLES WITH BLANK SERIES NAME*
replace title = trim(itrim(upper(title)))
rename title original_title
rename network_fvod network_clean
merge m:1 network_clean original_title using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_level_lookup.dta"
replace fvod_program = series_title if _m==3 & fvod_program == ""
replace season = season_title if _m==3 & season == . & season_title != .
drop season_title
rename ep_title ep_no
rename ep_title2 ep_no2
drop _merge

rename network_clean network
merge m:1 net_type net network fvod_program using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_lookup.dta"
replace fvod_program = nielsen_program if _m==3 & nielsen_program != ""
drop if _m==2
drop _m

*Second merge on nielsen program for series that had the program name added aftewards; patch for running out of order
replace nielsen_program = series_title if nielsen_program == ""
replace nielsen_program = fvod_program if nielsen_program == ""

preserve

use "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_lookup_nielsen.dta", clear

duplicates tag net_type net network nielsen_prog, gen(tag)

drop if tag == 1

save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_lookup_nielsen.dta", replace

restore

merge m:1 net_type net network nielsen_prog using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_title_lookup_nielsen.dta"
replace genre = genre1 if _m == 3 & genre == ""
replace subgenre = subgenre1 if _m == 3 & subgenre == ""
drop if _m == 2
drop _m genre1 subgenre1
replace network = "UNIVERSAL KIDS" if network == "SPROUT"
replace net_type = "AD SUPPORTED CABLE" if network == "UNIVERSAL KIDS"
replace net = "UKID" if network == "UNIVERSAL KIDS"
replace network = "PARAMOUNT" if network == "SPIKE TV"
replace net = "PAR" if network == "PARAMOUNT"
replace genre = "SPANISH LANGUAGE" if genre == "" & inlist(network,"DISCOVERY EN ESPANOL","DISCOVERY FAMILIA","GALAVISION","NBC UNIVERSO","NICKELODEON ESP","TEL","UMA","UNIVERSO","UNIVISION")
replace subgenre = "SPANISH LANGUAGE" if genre == "" & inlist(network,"DISCOVERY EN ESPANOL","DISCOVERY FAMILIA","GALAVISION","NBC UNIVERSO","NICKELODEON ESP","TEL","UMA","UNIVERSO","UNIVISION")
replace genre = "CHILDRENS" if genre == "" & inlist(network,"DISNEY CHANNEL","DISNEY JUNIOR","DISNEY XD","KABILLION","NICKELODEON","NICK JR","SPROUT","THE CARTOON NETWORK","UNIVERSAL KIDS") & genre_title != "MOVIE"
replace subgenre = "CHILDRENS" if genre == "" & inlist(network,"DISNEY CHANNEL","DISNEY JUNIOR","DISNEY XD","KABILLION","NICKELODEON","NICK JR","SPROUT","THE CARTOON NETWORK","UNIVERSAL KIDS") & genre_title != "MOVIE"
replace genre = "MUSIC" if network == "MUSIC CHOICE"
replace subgenre = "MUSIC" if network == "MUSIC CHOICE"
replace genre = "MUSIC" if network == "FUSE" & genre == "" & fvod_program == ""
replace subgenre = "MUSIC" if network == "FUSE" & genre == "" & fvod_program == ""
drop if txns == .

replace net_type = "OTHER" if net_type == ""
replace net = "FEAR" if network == "FEARNET"
replace net = "KAB" if network == "KABILLION"
replace net = "MTVL" if network == "MTV LIVE"
replace net = "MTV3" if network == "MTV TR3S"
replace net = "MUSC" if network == "MUSIC CHOICE"
replace net = "NICKSP" if network == "NICKELODEON ESP"
replace net = "PAL" if network == "PALLADIA"
replace net = "UVSO" if network == "UNIVERSO"
replace net = "UVSN" if network == "UNIVISION"

replace genre = genre_title if genre == "" & genre_title != ""
drop genre_title
drop series_title

replace subgenre = "DRAMA" if genre == "DRAMA" & subgenre == ""
replace subgenre = "SPECIAL" if genre == "SPECIAL" & subgenre == ""
replace subgenre = "CHILDRENS" if genre == "CHILDRENS" & subgenre == ""
replace subgenre = "MOVIE" if genre == "MOVIE" & subgenre == ""
replace subgenre = "MUSIC" if genre == "MUSIC" & subgenre == ""
replace subgenre = "SPANISH LANGUAGE" if genre == "SPANISH LANGUAGE" & subgenre == ""
replace genre = "UNCLASSIFIED" if genre == ""
replace subgenre = "UNCLASSIFIED" if genre == "UNCLASSIFIED" & subgenre == ""


order moyear net_type net network fvod_program nielsen_program season ep_no ep_no2 title_clean original_title genre subgenre txns playtime hhs estvod ofdays code_type
gsort net_type net moyear -txns

*replace nulls with 0*
replace season = 0 if season == .
replace ep_no = 0 if ep_no == .
replace ep_no2 = 0 if ep_no2 == .

*Replace genre subgenre with most recent avail
rename genre genre_mapped
rename subgenre sub_mapped
merge m:1 net nielsen_program using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\new_nielsen_prog.dta"
replace genre_mapped = genre if _m==3 & genre != genre_mapped & genre != ""
replace sub_mapped = subgenre if _m==3 & subgenre != sub_mapped & subgenre != ""
drop if _m==2
drop _m genre subgenre
rename genre_mapped genre
rename sub_mapped subgenre

*tag form type for remaining titles*
replace form_type = "LF/UNIDENTIFIED" if form_type == ""
save "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Temp\vod_transparency_full_title_data.dta", replace
export delimited using "K:\Rainbow Research\1-amc research\Digital Multi-Platform\STATA\Output\VOD Transparency\vod_transparency_full_title_data.csv", replace
/*
preserve
*Keep 2019 only to try to clean
gen year = substr(moyear,1,4)
keep if year == "2019"

collapse(sum) txns playtime ofdays, by(net_type net network fvod_prog nielsen_prog season ep_no ep_no2 orig genre code_type form_type)
gsort net fvod ep_no2

*Fix metadata net by net with common nomenclature
split orig, parse("S: ")
gen ssn = substr(original_title2,1,1) if net == "ABC" & strpos(original_title2," ")==2
replace ssn = substr(original_title2,1,2) if net == "ABC" & strpos(original_title2," ")==3
drop original_title1 original_title3 original_title4
split original_title2, parse("EP: ")
gen ep_num = substr(original_title22,1,1) if strpos(original_title22," ")==2
replace ep_num = substr(original_title22,1,2) if strpos(original_title22," ")==3
drop original_title2*
*/
