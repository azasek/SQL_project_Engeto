--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SQL projekt - Úkol 2
-- Anežka Sekavová
-- 12.3.2026
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- Byly zanedbány mzdy, které mají NULL v category_branch_name.
-- ODPOVĚĎ:
-- Za první období (rok 2006) je možné koupit 1262 kg chleba a 1409 l mléka
-- Za poslední období (rok 2018) je možné koupit 1319 kg chleba a 1614 l mléka

WITH cte_avg_wage AS (
	SELECT
		YEAR,
		round(avg(wage)::NUMERIC, 2) AS avg_wage
	FROM t_anezka_sekavova_project_SQL_primary_final 
	GROUP BY YEAR 
	ORDER BY YEAR
)
(
SELECT 
	t.category_code,
	t.category_name,
	t.YEAR,
	t.price,
	t.price_value,
	t.price_unit,
	cteaw.avg_wage,
	round(cteaw.avg_wage/t.price::NUMERIC, 0) AS goods_for_wage
FROM t_anezka_sekavova_project_SQL_primary_final AS t
LEFT JOIN cte_avg_wage AS cteaw
	ON t.YEAR = cteaw.YEAR
WHERE t.category_code IN (114201,111301)
GROUP BY t.YEAR, t.category_code, t.price, t.category_name, cteaw.avg_wage, t.price_value, t.price_unit
ORDER BY t.YEAR ASC, category_code
LIMIT 2
)
UNION ALL
(
SELECT 
	t.category_code,
	t.category_name,
	t.YEAR,
	t.price,
	t.price_value,
	t.price_unit,
	cteaw.avg_wage,
	round(cteaw.avg_wage/t.price::NUMERIC, 0) AS goods_for_wage
FROM t_anezka_sekavova_project_SQL_primary_final AS t
LEFT JOIN cte_avg_wage AS cteaw
	ON t.YEAR = cteaw.YEAR
WHERE t.category_code IN (114201,111301)
GROUP BY t.YEAR, t.category_code, t.price, t.category_name, cteaw.avg_wage, t.price_value, t.price_unit
ORDER BY t.YEAR DESC, category_code
LIMIT 2
)
;
