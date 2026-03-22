*Import lookup files
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Lookup Files\Date Week Lookup.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Date Week Lookup.dta", replace

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Lookup Files\App Download Lookup.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\App Download Lookup.dta", replace

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Lookup Files\Week Number Lookup.xlsx", clear firstrow
tostring Week_Number, replace
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Week Number Lookup.dta", replace


import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Lookup Files\Show Name Lookup.xlsx", clear firstrow
foreach var of varlist Show_Name Show_Name_Replacement {
	replace `var' = trim(itrim(upper(`var')))
}
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Show Name Lookup.dta", replace

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Lookup Files\Short Form Asset Lookup.xlsx", clear firstrow
foreach var of varlist Show_Name Episode Episode_Replacement {
	replace `var' = trim(itrim(upper(`var')))
}
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Short Form Asset Lookup.dta", replace
*import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Lookup Files\Life Goes On Tracker Lookup.xlsx", clear firstrow
*save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Life Goes On Tracker Lookup.dta", replace
*********************************************************************************************************************************************************************

*Import Daily Short Form Data Files

/*Only run historical years if data has changed 
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Short Form Daily Files\WE tv Short Form Daily Data 2016.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2016.dta", replace
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Short Form Daily Files\WE tv Short Form Daily Data 2017.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2017.dta", replace
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Short Form Daily Files\WE tv Short Form Daily Data 2018.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2018.dta", replace
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Short Form Daily Files\WE tv Short Form Daily Data 2019.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2019.dta", replace
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Short Form Daily Files\WE tv Short Form Daily Data 2020.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2020.dta", replace
*/

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Short Form Daily Files\WE tv Short Form Daily Data 2021.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2021.dta", replace

*Append Short Form Files Together
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2020.dta"
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2019.dta"
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2018.dta"
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2017.dta"
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data 2016.dta"

foreach var of varlist Show_Name Episode Video_Source {
	replace `var' = trim(itrim(upper(`var')))
}

gen Form_Type = "SHORT FORM"
gen Playback = "ON DEMAND"

*Merge Short Form Asset Lookup
merge m:1 Show_Name Episode using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Short Form Asset Lookup.dta"
replace Episode = Episode_Replacement if _m==3
drop _m Episode_Replacement

/*Merge Life Goes On Tracker Lookup
merge m:1 Episode using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Life Goes On Tracker Lookup.dta"
replace Episode = Episode_2 if _m==3
drop _m Episode_2 
*/

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data.dta", replace
***********************************************************************************************************************************************************************

*Import Daily Long Form Data

/*Only run historical years if data has changed
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Long Form Daily Files\WE tv Long Form Daily Data 2016, 2017, 2018.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Daily Data 2016, 2017, 2018.dta", replace
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Long Form Daily Files\WE tv Long Form Daily Data 2019.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Daily Data 2019.dta", replace
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Long Form Daily Files\WE tv Long Form Daily Data 2020.xlsx", clear firstrow
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Daily Data 2020.dta"
*/

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\Long Form Daily Files\WE tv Long Form Daily Data 2021.xlsx", clear firstrow
tostring Episode_Number, replace
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Daily Data 2016, 2017, 2018.dta"
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Daily Data 2019.dta"
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Daily Data 2020.dta"

foreach var of varlist Network  Show_Name Episode Video_Source {
	replace `var' = trim(itrim(upper(`var')))
}

gen Form_Type = "LONG FORM"
drop if Show_Name == "LIVE STREAM"

*Replace Life Goes On Show Name
replace Show_Name = "LIFE GOES ON" if strpos(Episode, "LIFE GOES ON")


save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Daily Data.dta", replace
*************************************************************************************************************************************************************************

*Append long and short form files and export file
append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Short Form Daily Data.dta"

replace Video_Source = "AppleTV" if Video_Source == "TVE APPLETV"
replace Video_Source = ".com Site" if Video_Source == "TVE NETWORK"
replace Video_Source = "Roku" if Video_Source == "TVE ROKU"
replace Video_Source = "YouTube TV" if Video_Source == "TVE YOUTUBE TV"
replace Video_Source = "Chromecast" if Video_Source == "TVE CHROMECAST"
replace Video_Source = "FireTV" if Video_Source == "TVE FIRETV"
replace Video_Source = "Mobile App" if Video_Source == "TVE NETWORK APP"
replace Video_Source = "Xbox" if Video_Source == "TVE XBOX"
replace Video_Source = "Android TV" if Video_Source == "TVE ANDROID TV"
replace Video_Source = "Xfinity Site" if Video_Source == "TVE XFINITY TV"
replace Video_Source = "Xfinity App" if Video_Source == "TVE XFINITY TV APP"

*Gen Video Source Rollup
gen Video_Source_Rollup = Video_Source
replace Video_Source_Rollup = "OTT" if inlist(Video_Source, "AppleTV", "Roku", "Chromecast", "FireTV", "Xbox", "Android TV")
replace Video_Source_Rollup = "Xfinity" if inlist(Video_Source, "Xfinity Site", "Xfinity App")

*Gen O&O Video Source Indicator
gen OO_Video_Source_Indicator = "No"
replace OO_Video_Source_Indicator = "Yes" if inlist(Video_Source_Rollup, ".com Site", "Mobile App", "OTT")

*Fix Life After Lockup Naming Convention
replace Show_Name = "LIFE AFTER LOCKUP" if Show_Name == "LOVE AFTER LOCKUP" & inlist(Season, "2B", "2D", "3B", "3BB")

*Fix Show Names
merge m:1 Show_Name using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Show Name Lookup.dta"
replace Show_Name = Show_Name_Replacement if Show_Name_Replacement !=""
drop _m Show_Name_Replacement

gen Ep_String = substr(Episode, -5,.) if Form_Type == "LONG FORM"
replace Ep_String = subinstr(Ep_String, "-","",.)
replace Ep_String = substr(Ep_String, indexnot(Ep_String, "0"), .)
replace Ep_String = Episode if Form_Type != "LONG FORM"
gen Show_Name_Episode = Show_Name + " " + Ep_String if Form_Type == "LONG FORM"
replace Show_Name_Episode = Show_Name + ": "+ Episode if Form_Type == "SHORT FORM"

merge m:1 Date using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Date Week Lookup.dta"
drop if _m==1
drop if _m==2
drop _m

merge m:1 Week using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Week Number Lookup.dta"
drop if _m==1
drop if _m==2
drop _m

drop if Year == 2015

replace Completed_Views = 0 if Completed_Views ==.

drop if Video_Source == "YouTube TV" & Playback == "LIVE"

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long and Short Form Daily Data.dta", replace

*Temporarily drop livestream for 9/28/2020 onward
drop if Playback == "LIVE" & Date > td(27sep2020)

export delimited using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Output\WE tv Long and Short Form Daily Data.csv", replace
**************************************************************************************************************************************************************************

*Import App Downloads data and export file
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\WE tv App Installs.xlsx", clear firstrow

*gen WEtv_Mobile = _WEtv_IOS + _WEtv_Android_App
*drop _WEtv_IOS _WEtv_Android_App

replace _WEtvAndroidTV = "0" if _WEtvAndroidTV == "-"
destring _WEtvAndroidTV, replace

gen id= _n
reshape long _, i(id) j(Network_Video_Source)str
drop id
rename _ App_Downloads

merge m:1 Date using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Date Week Lookup.dta"
*drop if _m==1
drop if _m==2
drop _m

merge m:1 Week using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Week Number Lookup.dta"
*drop if _m==1
drop if _m==2
drop _m

merge m:1 Network_Video_Source using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\App Download Lookup.dta"
drop if _m==1
drop if _m==2
drop _m
drop Network_Video_Source

gen Network = "WETV"

*Gen Video Source Rollup
gen Video_Source_Rollup = Video_Source
replace Video_Source_Rollup = "OTT" if inlist(Video_Source, "Roku", "Android TV", "FireTV", "Xbox", "AppleTV")

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Daily App Downloads.dta", replace
export delimited using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Output\WE tv Daily App Downloads.csv", replace
*************************************************************************************************************************************************************************

*Import Long Form Time Shift data and export file
import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\WE tv Long Form Time Shift Data.xlsx", clear firstrow

foreach var of varlist Network Show_Name Episode Video_Source {
	replace `var' = trim(itrim(upper(`var')))
}

gen Form_Type = "LONG FORM"

replace Video_Source = "AppleTV" if Video_Source == "TVE APPLETV"
replace Video_Source = ".com Site" if Video_Source == "TVE NETWORK"
replace Video_Source = "Roku" if Video_Source == "TVE ROKU"
replace Video_Source = "YouTube TV" if Video_Source == "TVE YOUTUBE TV"
replace Video_Source = "Chromecast" if Video_Source == "TVE CHROMECAST"
replace Video_Source = "FireTV" if Video_Source == "TVE FIRETV"
replace Video_Source = "Mobile App" if Video_Source == "TVE NETWORK APP"
replace Video_Source = "Xbox" if Video_Source == "TVE XBOX"
replace Video_Source = "Android TV" if Video_Source == "TVE ANDROID TV"
replace Video_Source = "Xfinity Site" if Video_Source == "TVE XFINITY TV"
replace Video_Source = "Xfinity App" if Video_Source == "TVE XFINITY TV APP"

*Gen Video Source Rollup
gen Video_Source_Rollup = Video_Source
replace Video_Source_Rollup = "OTT" if inlist(Video_Source, "AppleTV", "Roku", "Chromecast", "FireTV", "Xbox", "Android TV")
replace Video_Source_Rollup = "Xfinity" if inlist(Video_Source, "Xfinity Site", "Xfinity App")

*Gen O&O Video Source Indicator
gen OO_Video_Source_Indicator = "No"
replace OO_Video_Source_Indicator = "Yes" if inlist(Video_Source_Rollup, ".com Site", "Mobile App", "OTT")

*Fix Life After Lockup Naming Convention
replace Show_Name = "LIFE AFTER LOCKUP" if Show_Name == "LOVE AFTER LOCKUP" & inlist(Season, "2B", "2D", "3B", "3BB")

*Replace Life Goes On Show Name
replace Show_Name = "LIFE GOES ON" if strpos(Episode, "LIFE GOES ON")

gen Ep_String = substr(Episode, -5,.)
replace Ep_String = subinstr(Ep_String, "-","",.)
replace Ep_String = substr(Ep_String, indexnot(Ep_String, "0"), .)
gen Show_Name_Episode = Show_Name + " " + Ep_String

drop if Show_Name == "UNKNOWN"

replace Completed_Views = 0 if Completed_Views ==.

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Time Shift Data.dta", replace
export delimited using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Output\WE tv Long Form Time Shift Data.csv", replace
*********************************************************************************************************************************************************************************

*Import Long Form, Short Form and Livestream Network daily metrics

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\WE tv Network On Demand Daily Data.xlsx", clear firstrow
replace Form_Type = "SHORT FORM" if Form_Type == "WEBISODE"

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Network On Demand Daily Data.dta", replace

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\WE tv Network Livestream Daily Data.xlsx", clear firstrow
drop if Form_Type == "SHORT FORM"
save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Network Livestream Daily Data.dta", replace

append using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Network On Demand Daily Data.dta"

foreach var of varlist Network Video_Source {
	replace `var' = trim(itrim(upper(`var')))
}

replace Video_Source = "AppleTV" if Video_Source == "TVE APPLETV"
replace Video_Source = ".com Site" if Video_Source == "TVE NETWORK"
replace Video_Source = "Roku" if Video_Source == "TVE ROKU"
replace Video_Source = "YouTube TV" if Video_Source == "TVE YOUTUBE TV"
replace Video_Source = "Chromecast" if Video_Source == "TVE CHROMECAST"
replace Video_Source = "FireTV" if Video_Source == "TVE FIRETV"
replace Video_Source = "Mobile App" if Video_Source == "TVE NETWORK APP"
replace Video_Source = "Xbox" if Video_Source == "TVE XBOX"
replace Video_Source = "Android TV" if Video_Source == "TVE ANDROID TV"
replace Video_Source = "Xfinity Site" if Video_Source == "TVE XFINITY TV"
replace Video_Source = "Xfinity App" if Video_Source == "TVE XFINITY TV APP"

*Gen Video Source Rollup
gen Video_Source_Rollup = Video_Source
replace Video_Source_Rollup = "OTT" if inlist(Video_Source, "AppleTV", "Roku", "Chromecast", "FireTV", "Xbox", "Android TV")
replace Video_Source_Rollup = "Xfinity" if inlist(Video_Source, "Xfinity Site", "Xfinity App")

*Gen O&O Video Source Indicator
gen OO_Video_Source_Indicator = "No"
replace OO_Video_Source_Indicator = "Yes" if inlist(Video_Source_Rollup, ".com Site", "Mobile App", "OTT")

merge m:1 Date using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Date Week Lookup.dta"
drop if _m==1
drop if _m==2
drop _m

merge m:1 Week using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Week Number Lookup.dta"
drop if _m==1
drop if _m==2
drop _m

drop if Year == 2015

drop if Video_Source == "YouTube TV" & Playback == "LIVE"

*Temporarily drop livestream for 9/28/2020 onward
drop if Playback == "LIVE" & Date > td(27sep2020)

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Network On Demand and Livestream Daily Data.dta", replace
export delimited using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Output\WE tv Network On Demand and Livestream Daily Data.csv", replace
**************************************************************************************************************************************************************************************

*Import Users and Sessions

import excel using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Input\WE tv Monthly Users and Sessions.xlsx", clear firstrow

gen Network = "WETV"

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Monthly Users and Sessions.dta", replace
export delimited using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Output\WE tv Monthly Users and Sessions.csv", replace
****************************************************************************************************************************************************************************************
/*Life Goes On Tracker

use "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Long Form Time Shift Data.dta", clear
merge m:1 using Show_Name Season Episode using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\Life Goes On Tracker Lookup.dta"
drop if _m==1
drop if _m==2
drop _m

gen Digital_Episode_Day = Episode_Digital_Start_Date - Date
gen Digital_Season_Day = Season_Digital_Start_Date - Date

save "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\DTA Files\WE tv Life Goes On Digital Tracking.dta", replace
export delimited using "K:\Rainbow Research\2- we research\Digital\WE tv Digital Reports\STATA\Output\Life Goes On Digital Tracking.csv", replace
/*
