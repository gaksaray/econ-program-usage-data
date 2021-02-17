import delimited C:\Users\gaksaray\Desktop\econ-program-usage-data\articles_programs_used.csv, bindquote(strict) stripquote(yes) clear

rename v16 cpp

foreach var of varlist stata-sas {
	replace `var' = "0" if `var' == "FALSE"
	replace `var' = "1" if `var' == "TRUE"
	replace `var' = "." if `var' == "NA"
	destring `var', replace
}

replace issue_name = itrim(issue_name)

replace author = subinstr(author, "Ã¶", "ö", .)
replace author = subinstr(author, "Ã¼", "ü", .)
replace author = subinstr(author, "Ã", "Ò", .)
replace author = subinstr(author, "Ã", "à", .)
replace author = subinstr(author, "à©", "é", .)
replace author = subinstr(author, "à³", "ó", .)
replace author = subinstr(author, "àª", "ê", .)
replace author = subinstr(author, "à§", "ç", .)
// ...

replace title = substr(title, 1, length(title) - 1) if substr(title, -1, 1) == "."

replace vol = substr(vol, 1, length(vol) - 1) if substr(vol, -1, 1) == "."
replace vol = itrim(vol)

save articles_programs_used, replace

// Stata vs. R over years
use articles_programs_used, clear
keep if stata == 1 | r == 1
contract stata r year
bysort year: egen tot = total(_freq)
foreach prog in stata r {
	replace `prog' = `prog' * _freq
}
drop _freq
collapse (sum) stata r, by(year tot)
foreach prog in stata r {
	generate p_`prog' = `prog' / tot
	replace p_`prog' = 0 if missing(p_`prog')
}
twoway (line p_stata year, sort) (line p_r year, sort), scheme(sj)
graph export stata_vs_r.png, replace

// we could repeat this for papers which uses either stata or r (but not both):
/* egen rowtot = rowtotal(stata-sas)
keep if rowtot == 1 */


// Stata vs. python over years
use articles_programs_used, clear
keep if stata == 1 | python == 1
contract stata python year
bysort year: egen tot = total(_freq)
foreach prog in stata python {
	replace `prog' = `prog' * _freq
}
drop _freq
collapse (sum) stata python, by(year tot)
foreach prog in stata python {
	generate p_`prog' = `prog' / tot
	replace p_`prog' = 0 if missing(p_`prog')
}
twoway (line p_stata year, sort) (line p_python year, sort), scheme(sj)
graph export stata_vs_python.png, replace
