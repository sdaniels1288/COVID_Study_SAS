/*
Title: COVID Case Study (Mar 2020)
Author: Stephan Daniels
Email: sdaniels1288@gmail.com
*/

OPTIONS VALIDVARNAME=V7;

* Declaring libname and filenames. Datafiles renamed for ease of use. "County Name" field was renamed in source to "county_name".;
libname BAS150GP "/home/u63025276/myfolders/group_project";

filename cases "/home/u63025276/myfolders/group_project/covid_cases.xlsx";
filename deaths "/home/u63025276/myfolders/group_project/covid_deaths.xlsx";

* Step 1 - Import Excel files into created library;
proc import datafile=cases
	dbms=xlsx
	out=BAS150GP.cases
	replace;
	getnames=yes;
run;

proc import datafile=deaths
	dbms=xlsx
	out=BAS150GP.deaths
	replace;
	getnames=yes;
run;

* Step 2 - Data cleaning;
proc sql;
	CREATE TABLE BAS150GP.cleaned_cases AS
	SELECT *
	FROM BAS150GP.cases
	WHERE county_name <> "Statewide Unallocated";

	CREATE TABLE BAS150GP.cleaned_deaths AS
	SELECT *
	FROM BAS150GP.deaths
	WHERE county_name <> "Statewide Unallocated";
quit;


title "Frequency of Cases by County (3/1/2020)";
proc freq data=BAS150GP.cleaned_cases;
	tables as_of_3_1_2020;
	label as_of_3_1_2020 = "Cases as of 3/1/2020";
run;

title "Frequency of Deaths by County (3/1/2020)";
proc freq data=BAS150GP.cleaned_deaths;
	tables as_of_3_1_2020;
	label as_of_3_1_2020 = "Deaths as of 3/1/2020";
run;

proc sort data=BAS150GP.cleaned_cases;
	by descending as_of_3_1_2020;
run;

title "Top Cases by County";
proc print data=BAS150GP.cleaned_cases(obs=3) label noobs;
	label county_name="County";
	label as_of_3_1_2020="Cases as of 03/01/2020";
	var county_name as_of_3_1_2020;
run;

/* Additional SQL code to pull CA case and death counts
proc sql;
	CREATE TABLE BAS150GP.cases_by_state AS
	SELECT state, SUM(as_of_3_1_2020) AS mar_cases
	FROM BAS150GP.cleaned_cases
	GROUP BY state
	ORDER BY mar_cases DESC;
	
	CREATE TABLE BAS150GP.deaths_by_state AS
	SELECT state, SUM(as_of_3_1_2020) AS mar_deaths
	FROM BAS150GP.cleaned_deaths
	GROUP BY state
	ORDER BY mar_deaths DESC;

	SELECT SUM(as_of_3_1_2020) AS total_cases
	FROM BAS150GP.cleaned_cases;
	
	SELECT SUM(as_of_3_1_2020) as CA_cases
	FROM BAS150GP.cleaned_cases
	WHERE state="CA";
	
	SELECT SUM(as_of_3_1_2020) as total_deaths
	FROM BAS150GP.cleaned_deaths;
	
	SELECT SUM(as_of_3_1_2020) as CA_deaths
	FROM BAS150GP.cleaned_deaths
	WHERE state="CA";
quit;

title "Top 5 Counties in CA";
proc sql outobs=5;
	SELECT county_name, (as_of_3_1_2020)/SUM(as_of_3_1_2020) AS case_pct
	FROM BAS150GP.cleaned_cases
	WHERE state="CA"
	ORDER BY case_pct DESC;
quit;
*/