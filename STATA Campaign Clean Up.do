
*Import iSpot data
insheet using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Test Stata\Input\intuit-credit-karma_reach_details_03-01-2025_to_03-31-2025_household (1).csv", clear

*Drop all irrelevant dimensions
keep Date ottincrementalreachcount otttotalreachcount

*Separate Date into 3 different strings
split Date, parse("/") gen(d_) destring
replace d_3=real(string(2)+string(d_3, "%03.0f")) if d_3<1000
rename d_1 day
rename d_2 month
rename d_3 year

*Keep only the last date
egen t = max(month)
keep if(month == t)

gen dd = day(Date, "MDY")
gen mm = month(Date)
gen yyyy = year(Date)
gen newdate = mdy(month(Date)+1,1,year(Date))-1
replace newdate=mdy(12,31,year(date)) if month(date)==12

*Append UE All Nets and Additional UE files
append using "K:\Rainbow Research\4 - Digital research\101 - Affiliate\UE by MSO\STATA\DTA Files\UE by MSO Mid.dta"

replace Coverage_Area = upper(Coverage_Area)

save "K:\Rainbow Research\4 - Digital research\101 - Affiliate\UE by MSO\STATA\DTA Files\UE by MSO.dta", replace
export delimited using "K:\Rainbow Research\4 - Digital research\101 - Affiliate\UE by MSO\STATA\Output\UE by MSO.csv", replace

