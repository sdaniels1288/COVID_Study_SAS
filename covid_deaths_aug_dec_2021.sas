/*
Title: COVID-19 Case Study - Deaths (Aug 2021 - Dec 2021)
Author: Stephan Daniels
Email: sdaniels1288@gmail.com
*/

OPTIONS VALIDVARNAME=V7;

* Declaring libname and filenames. Datafiles renamed for ease of use. "County Name" field was renamed in source to "county_name".;
libname BAS150GP "/home/u63025276/myfolders/group_project";

filename deaths "/home/u63025276/myfolders/group_project/covid_deaths.xlsx";

* Step 1 - Import Excel file into created library;
proc import datafile=deaths
	dbms=xlsx
	out=BAS150GP.deaths
	replace;
	getnames=yes;
run;

data covid;
    set BAS150.covid;
    where county_name NE "Statewide Unallocated";
    aug_deaths_2021 = "As_of_8/31/2021"n - "As_of_7/31/2021"n;
    sep_deaths_2021 = "As_of_9/30/2021"n - "As_of_8/31/2021"n;
    oct_deaths_2021 = "As_of_10/31/2021"n - "As_of_9/30/2021"n;
    nov_deaths_2021 = "As_of_11/30/2021"n - "As_of_10/31/2021"n;
    dec_deaths_2021 = "As_of_12/31/2021"n - "As_of_11/30/2021"n;
    interval_deaths = aug_deaths_2021 + sep_deaths_2021 + oct_deaths_2021 + nov_deaths_2021 + dec_deaths_2021;
run;

proc means data=covid mean sum min max;
    var aug_deaths_2021;
run;

proc means data=covid mean sum min max;
    var sep_deaths_2021;
run;

proc means data=covid mean sum min max;
    var oct_deaths_2021;
run;

proc means data=covid mean sum min max;
    var nov_deaths_2021;
run;

proc means data=covid mean sum min max;
    var dec_deaths_2021;
run;

proc means data=covid mean sum min max;
    var interval_deaths;
run;

/* Output of sorts is included in output because they are limited to 3 counties */
/* August */

proc sort data=covid;
    by descending aug_deaths_2021;
run;

proc print data=covid(obs=3);
    var county_name aug_deaths_2021;
    title "Most Aug Deaths";
run;

/* September */
proc sort data=covid;
    by descending sep_deaths_2021;
run;

proc print data=covid(obs=3);
    var county_name sep_deaths_2021;
    title "Most Sep Deaths";
run;

/* October */
proc sort data=covid;
    by descending oct_deaths_2021;
run;

proc print data=covid(obs=3);
    var county_name oct_deaths_2021;
    title "Most Oct Deaths";
run;

/* November */
proc sort data=covid;
    by descending nov_deaths_2021;
run;

proc print data=covid(obs=3);
    var county_name nov_deaths_2021;
    title "Most Nov Deaths";
run;

/* December */
proc sort data=covid;
    by descending dec_deaths_2021;
run;

proc print data=covid(obs=3);
    var county_name dec_deaths_2021;
    title "Most Dec Deaths";
run;

/* Total interval */
proc sort data=covid;
    by descending interval_deaths;
run;

proc print data=covid(obs=5);
    var county_name interval_deaths;
    title "Aug-Dec Deaths";
run;

/* Extra Details: Anomalies */
proc sort data=covid;
    by aug_deaths_2021;
run;

proc print data=covid;
    where aug_deaths_2021 < 0;
    var county_name aug_deaths_2021 "As_of_7/31/2021"n "As_of_8/31/2021"n;
    title "Least Aug Deaths";
run;

/* Extra Details: States */
title "Most State Deaths";
proc sql outobs=5;
    SELECT
    State,
    SUM(interval_deaths) AS state_deaths
    FROM covid
    GROUP BY State
    ORDER BY state_deaths DESC;
quit;