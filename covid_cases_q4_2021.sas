/*
Title: COVID Case Study (Q4 2021)
Author: Stephan Daniels
Email: sdaniels1288@gmail.com
*/

OPTIONS VALIDVARNAME=V7;

* Declaring libname and filenames. Datafiles renamed for ease of use. "County Name" field was renamed in source to "county_name".;
libname BAS150GP "/home/u63025276/myfolders/group_project";

filename cases "/home/u63025276/myfolders/group_project/covid_cases.xlsx";

* Step 1 - Import Excel files into created library;
proc import datafile=cases
	dbms=xlsx
	out=BAS150GP.cases
	replace;
	getnames=yes;
run;

* Steps 2 & 3 - Data cleaning and variable creation;
proc sql;
	CREATE TABLE BAS150GP.cleaned_cases_2021 AS
	SELECT county_name, 
		state,
		as_of_8_31_2021 - as_of_7_31_2021 AS aug_cases_2021,
		as_of_9_30_2021 - as_of_8_31_2021 AS sep_cases_2021,
		as_of_10_31_2021 - as_of_9_30_2021 AS oct_cases_2021,
		as_of_11_30_2021 - as_of_10_31_2021 AS nov_cases_2021,
		as_of_12_31_2021 - as_of_11_30_2021 AS dec_cases_2021
	FROM BAS150GP.cases
	WHERE county_name <> "Statewide Unallocated";
quit;

* Step 4 - Case means;
proc means data=BAS150GP.cleaned_cases_2021;
run;
/*
August		1277.14
September	1287.53
October		 801.52
November	 803.53
December	1977.70
*/

* Step 5 - Top cases per month;

* August 2021;
proc sort data=BAS150GP.cleaned_cases_2021;
	by descending aug_cases_2021;
run;
title "Counties with Most Cases (Aug 2021)";
proc print data=BAS150GP.cleaned_cases_2021(obs=3) noobs label;
	label county_name="County"
		state="State"
		aug_cases_2021="Case Count (Aug 2021)";
	var county_name state aug_cases_2021;
run;

* September 2021;
proc sort data=BAS150GP.cleaned_cases_2021;
	by descending sep_cases_2021;
run;
title "Counties with Most Cases (Sep 2021)";
proc print data=BAS150GP.cleaned_cases_2021(obs=3) noobs label;
	label county_name="County"
		state="State"
		sep_cases_2021="Case Count (Sep 2021)";
	var county_name state sep_cases_2021;
run;

* October 2021;
proc sort data=BAS150GP.cleaned_cases_2021;
	by descending oct_cases_2021;
run;
title "Counties with Most Cases (Oct 2021)";
proc print data=BAS150GP.cleaned_cases_2021(obs=3) noobs label;
	label county_name="County"
		state="State"
		oct_cases_2021="Case Count (Oct 2021)";
	var county_name state oct_cases_2021;
run;

* November 2021;
proc sort data=BAS150GP.cleaned_cases_2021;
	by descending nov_cases_2021;
run;
title "Counties with Most Cases (Nov 2021)";
proc print data=BAS150GP.cleaned_cases_2021(obs=3) noobs label;
	label county_name="County"
		state="State"
		nov_cases_2021="Case Count (Nov 2021)";
	var county_name state nov_cases_2021;
run;

* December 2021;
proc sort data=BAS150GP.cleaned_cases_2021;
	by descending dec_cases_2021;
run;
title "Counties with Most Cases (Dec 2021)";
proc print data=BAS150GP.cleaned_cases_2021(obs=3) noobs label;
	label county_name="County"
		state="State"
		dec_cases_2021="Case Count (Dec 2021)";
	var county_name state dec_cases_2021;
run;