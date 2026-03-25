--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SQL projekt - Úkol 4
-- Anežka Sekavová
-- 12.3.2026
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
--ODPOVĚĎ: Neexistuje takový rok. Maximální rozdíl v meziročním nárustu cen a mezd je 7%.

WITH cte_avg_prices_wages_in_years AS (
	SELECT 
		"year",
		round(avg(price)::NUMERIC, 2) AS avg_price,
		round((lag(avg(price),1) OVER (ORDER BY YEAR))::NUMERIC, 2) AS avg_price_last_year,
		round(avg(wage)::NUMERIC, 2) AS avg_wage,
		round((lag(avg(wage),1) OVER (ORDER BY YEAR))::NUMERIC, 2) AS avg_wage_last_year
	FROM t_anezka_sekavova_project_sql_primary_final AS t
	GROUP BY YEAR
	ORDER BY YEAR
), cte_avg_prices_wages_in_years_percentage_increase AS (
	SELECT
		*,
		round((100 * (avg_price - avg_price_last_year) / avg_price_last_year)::NUMERIC, 0) AS price_percentage_increase,
		round((100 * (avg_wage - avg_wage_last_year) / avg_wage_last_year)::NUMERIC, 0) AS wage_percentage_increase
	FROM cte_avg_prices_wages_in_years
)
SELECT
	*,
--	price_percentage_increase - wage_percentage_increase AS difference_percentage_increase,
	CASE
		WHEN price_percentage_increase - wage_percentage_increase > 10 THEN 'over 10 %'
		WHEN price_percentage_increase - wage_percentage_increase <= 10 THEN 'under 10 %'
	END AS difference_percentage_increase_10_percent
FROM cte_avg_prices_wages_in_years_percentage_increase
WHERE 1=1
	AND price_percentage_increase - wage_percentage_increase > 10
--ORDER BY difference_percentage_increase desc
;
