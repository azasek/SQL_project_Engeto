--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SQL projekt - Tabulka 2
-- Anežka Sekavová
-- 12.3.2026
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR
-- t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).

CREATE TABLE t_anezka_sekavova_project_SQL_secondary_final AS
SELECT
	c.continent,
	e.country,
	e."year" ,
	e.gdp,
	e.gini,
	e.population
FROM economies AS e 
JOIN countries AS c 
	ON e.country = c.country
WHERE c.continent = 'Europe'
	AND e."year" BETWEEN 2006 AND 2018
ORDER BY e.country , e."year";

