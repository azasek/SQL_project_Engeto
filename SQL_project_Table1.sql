--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SQL projekt - Tabulka 1
-- Anežka Sekavová
-- 12.3.2026
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Tabulka pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky
-- Tabulku pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final

CREATE TABLE t_anezka_sekavova_project_SQL_primary_final AS
WITH cte_czechia_payroll AS (
	SELECT 
		round(avg(value)::NUMERIC, 2) AS value,
		value_type_code,
		unit_code,
		calculation_code,
		industry_branch_code,
		payroll_year
	FROM czechia_payroll AS cp 
	WHERE value_type_code = 5958
		AND calculation_code = 100
	GROUP BY value_type_code, unit_code, calculation_code, industry_branch_code, payroll_year
	ORDER BY payroll_year, industry_branch_code 
), cte_czechia_price AS (
	SELECT
		round(avg(value)::NUMERIC, 2) AS price,
		category_code,
		date_part('year', date_from) AS price_year
	FROM czechia_price
	WHERE region_code IS NULL
	GROUP BY category_code, price_year
	ORDER BY price_year, category_code
)
SELECT 
	cpay.payroll_year AS YEAR,
	cpay.value AS wage,
	cpay.industry_branch_code,
	cpayib.name AS industry_branch_name,
	cpri.price,
	cpri.category_code,
	cpric."name" AS category_name,
	cpric.price_value,
	cpric.price_unit,
	e.gdp 
FROM cte_czechia_payroll AS cpay 
JOIN cte_czechia_price AS cpri
	ON cpay.payroll_year = cpri.price_year
JOIN czechia_payroll_industry_branch AS cpayib
	ON cpay.industry_branch_code = cpayib.code 
JOIN czechia_price_category AS cpric
	ON cpri.category_code = cpric.code
LEFT JOIN economies AS e 
	ON cpay.payroll_year = e.YEAR
	WHERE e.country = 'Czech Republic'
ORDER BY YEAR;


