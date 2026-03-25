--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SQL projekt - Úkol 3
-- Anežka Sekavová
-- 12.3.2026
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
--ODPOVED: Nejpomaleji zdražovala Rajská jablka červená kulata mezi lety 2006 a 2007. Percentuální nárust -30 %

WITH cte_food_over_year_balance AS (
	SELECT 
		category_name,
		"year",
		price,
		lag(price,1) OVER (PARTITION BY category_name ORDER BY year) AS price_year_before
	FROM t_anezka_sekavova_project_sql_primary_final AS t
	GROUP BY category_name, YEAR, price
	ORDER BY category_name
)
SELECT 
	*,
	round((100 * (price - price_year_before) / price_year_before)::NUMERIC ,0) AS percentage_increase
FROM cte_food_over_year_balance
WHERE price_year_before NOTNULL 
ORDER BY percentage_increase ASC;
