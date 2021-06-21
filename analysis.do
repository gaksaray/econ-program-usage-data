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
