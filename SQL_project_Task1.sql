--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SQL projekt - Úkol 1
-- Anežka Sekavová
-- 12.3.2026
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- ODPOVED: Ve většině odvětví mzdy rostou i klesají.
--		Je pět odvětví, kde na datovém vzorku pouze rostou mzdy: Administrativní a podpůrné činnosti, Doprava a skladování, Ostatní činnosti, Zdravotní a sociální péče, Zpracovatelský průmysl  
--		V pripade konkretnejsich dotazu (napr. v kterych letech v kterych odvetvich) je treba zmenit posledni SELECT (SELECT DISTINCT -> SELECT a odkomentovat *, pripadne ORDER BY)

WITH cte_branch_year_wages_balance AS (
	SELECT 
		industry_branch_code,
		industry_branch_name,
		year,
		wage,
		lag(wage,1) OVER (PARTITION BY industry_branch_code ORDER BY industry_branch_code ASC, YEAR ASC) AS wage_previous_year
	FROM t_anezka_sekavova_project_SQL_primary_final
	GROUP BY industry_branch_code, industry_branch_name, YEAR, wage
)
SELECT DISTINCT 
--	*,
	industry_branch_name,
	CASE 
		WHEN wage_previous_year - wage < 0 THEN 'increase'
		WHEN wage_previous_year - wage > 0 THEN 'decrease'
		ELSE NULL
	END AS balance
FROM cte_branch_year_wages_balance
WHERE 1=1
	AND wage_previous_year NOTNULL 
--	AND wage_previous_year - wage < 0  --increase
	AND wage_previous_year - wage > 0  --decrease
--ORDER BY industry_branch_name ASC, YEAR ASC 
;
