cd "~/Desktop/econ-program-usage-data"
import excel articles_programs_used, sheet("articles_programs_used") firstrow case(lower) clear

rename p cpp

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

replace vol = subinstr(vol, char(13), "", .)
replace vol = subinstr(vol, char(10), "", .)
replace vol = subinstr(vol, "  ", " ", .)
replace vol = substr(vol, 1, length(vol) - 1) if substr(vol, -1, 1) == "."
replace vol = itrim(vol)

save articles_programs_used, replace