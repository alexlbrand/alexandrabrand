*A) Download the Chrono Report
	*Obtain excel from https://amc1.ca.analytics.ibm.com/bi/?perspective=home
	
*B) Import the data
	import excel "K:\Rainbow Research\2- we research\Alex Brand\Overnights\Input\Overnights Chrono.xlsx", clear
	
*C) Clean the data
	*1. Drop unnecessary variables
	drop E F
	*2. Rename variables
	rename A STIME
	rename B ETIME
	rename C PROGRAM
	rename D EPISODE
	rename G P2
	rename H MEDAGE
	rename I P18_49
	rename J P25_54
	rename K F18_49
	rename L F25_54
	*3. Drop unnecessary observations
	gen temp_time = STIME
	dstring temp_time, replace
	drop if _n < 15
	drop if _n > 17
	*4. Drop missing observations
	*5. Re-Order columns
	order STIME ETIME PROGRAM EPISODE F18_49 F25_54 P18_49 P25_54 P2 MEDAGE
	
*D) Paste to Chrono Template
	putexcel B8 = STIME using "K:\Rainbow Research\2- we research\Alex Brand\Overnights\Output\Overnights_Temp.xlsx" sheet("Chrono"), modify keepcellfmt
	*sheetmodify 
	*keepcellfmt
	
*E) Save
	save "K:\Rainbow Research\2- we research\Alex Brand\Overnights\Output\Overnights_Temp.xlsx" sheet(Chrono), replace
	
	