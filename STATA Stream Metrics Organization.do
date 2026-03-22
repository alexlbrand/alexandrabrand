import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\StreamMetrics_Lookup_Genre.xlsx", clear firstrow
rename ChannelName channel_name
replace channel_name = trim(itrim(upper(channel_name)))
replace MappedGenreinclMixedMapping = trim(itrim(upper(MappedGenreinclMixedMapping)))
replace Network = trim(itrim(upper(Network)))
rename Network competitive_network
drop D
duplicates tag channel_name MappedGenreinclMixedMapping competitive_network, gen(tag)
drop if tag >0
drop tag
save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\genre_lookup.dta", replace

import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\StreamMetrics_Lookup_Channel.xlsx", clear firstrow
rename ChannelName channel_name
replace channel_name = trim(itrim(upper(channel_name)))
replace MappedChannelName = trim(itrim(upper(MappedChannelName)))
drop C
drop D
drop E
drop F
drop G
duplicates tag channel_name MappedChannelName, gen(tag)
drop if tag >0
drop tag
save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\channel_lookup.dta", replace

import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\January_2025_ads_stats.xlsx", clear firstrow
gen Month = "Jan-25"
save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Jan_2025.dta", replace

import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\February_2025_ads_stats.xlsx", clear firstrow
gen Month = "Feb-25"
save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Feb_2025.dta", replace

import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\March_2025_ads_stats.xlsx", clear firstrow
gen Month = "Mar-25"
save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Mar_2025.dta", replace

import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\April_2025_ads_stats.xlsx", clear firstrow
gen Month = "Apr-25"
save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Apr_2025.dta", replace

import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\May_2025_ads_stats.xlsx", clear firstrow
gen Month = "May-25"
save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\May_2025.dta", replace

import excel using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\June_2025_ads_stats.xlsx", clear firstrow
gen Month = "Jun-25"

append using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Jan_2025.dta"
append using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Feb_2025.dta"
append using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Mar_2025.dta"
append using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\Apr_2025.dta"
append using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\May_2025.dta"

replace channel_name = trim(itrim(upper(channel_name)))

merge m:1 channel_name using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\channel_lookup.dta"
drop if _m==2
preserve
export delimited using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\Stream_Metrics_Additional_ChannelLookup.csv", replace
restore
drop _merge

merge m:1 channel_name using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\DTA Files\genre_lookup.dta"
drop if _m==2
preserve
export delimited using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Input\Stream_Metrics_Additional_GenreLookup.csv", replace
restore
drop _merge
rename channel_genre SM_genre
rename MappedGenreinclMixedMapping research_genre
rename channel_name SM_channel_name
rename MappedChannelName research_channel_name
rename Month month

save "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Output\Stream_Metrics.dta", replace
export delimited using "C:\Users\ABrand\OneDrive - AMC Networks\Desktop\Stream Metrics\Output\Stream_Metrics.csv", replace
