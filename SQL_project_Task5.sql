--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SQL projekt - Úkol 5
-- Anežka Sekavová
-- 12.3.2026
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Má výška HDP vliv na změny ve mzdách a cenách potravin?
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- ODPOVĚĎ: Silná korelace jde vidět ve mzdách v následujícím roce. Střední korelace je u cen a mezd v aktuálním roce. Žádná závislost není u cen v následujícím roce.
-- Tedy:
--		Mzdy reagují se zpožděním – silná korelace příští rok, střední letos.
-- 		Ceny reagují okamžitě jen částečně – střední korelace letos, nulová příští rok.
--		HDP je tedy lepší indikátor budoucích mezd než budoucích cen.
--		Všechny korelace jsou pozitivní, takže vyšší HDP = vyšší mzdy/ceny, jen síla efektu se liší.

--	HPD tento rok vs mzdy tento rok: corr 0,4 => střední pozitivní korelace
--	HPD tento rok vs mzdy příští rok: corr 0,7 => silná pozitivní korelace
--	HPD tento rok vs ceny tento rok: corr 0,5 => střední pozitivní korelace
--	HPD tento rok vs ceny příští rok: corr 0,0 => žádná lineární závislost


WITH cte_years_gdp_wages_prices AS (
	SELECT 
		YEAR,
		lag(gdp,1) OVER (ORDER BY YEAR) AS gdp_last_year,
		gdp,
		round((lag(avg(wage),1) OVER (ORDER BY YEAR))::NUMERIC, 2) AS avg_wage_last_year,
		round(avg(wage)::NUMERIC, 2) AS avg_wage,
		round((lag(avg(wage),-1) OVER (ORDER BY YEAR))::NUMERIC, 2) AS avg_wage_next_year,
		round((lag(avg(price),1) OVER (ORDER BY YEAR))::NUMERIC, 2) AS avg_price_last_year,
		round(avg(price)::NUMERIC, 2) AS avg_price,
		round((lag(avg(price),-1) OVER (ORDER BY YEAR))::NUMERIC, 2) AS avg_price_next_year
	FROM t_anezka_sekavova_project_sql_primary_final AS t
	GROUP BY YEAR, gdp
	ORDER BY YEAR 
), cte_years_gdp_wages_prices_last_next_year AS (
	SELECT
		*,
		round((100 * (gdp - gdp_last_year) / gdp_last_year)::NUMERIC, 0) AS gdp_last_now_percentage_increase,
		round((100 * (avg_wage - avg_wage_last_year) / avg_wage_last_year)::NUMERIC, 0) AS wage_last_now_percentage_increase,
		round((100 * (avg_wage_next_year - avg_wage) / avg_wage)::NUMERIC, 0) AS wage_now_next_percentage_increase,
		round((100 * (avg_price - avg_price_last_year) / avg_price_last_year)::NUMERIC, 0) AS price_last_now_percentage_increase,
		round((100 * (avg_price_next_year - avg_price) / avg_price)::NUMERIC, 0) AS price_now_next_percentage_increase
	FROM cte_years_gdp_wages_prices
	WHERE gdp_last_year IS NOT NULL
)
SELECT
	metric,
	correlation,
	CASE
		WHEN correlation < 0 THEN 'negative'
		WHEN correlation > 0 THEN 'positive'
	END AS correlation_pos_neg,
	CASE
		WHEN abs(correlation) BETWEEN 0.7 AND 1.0 THEN 'high'
		WHEN abs(correlation) BETWEEN 0.3 AND 0.7 THEN 'medium'
		WHEN abs(correlation) BETWEEN 0.1 AND 0.3 THEN 'low'
		ELSE 'no linear dependence'
	END AS correlation_effect
FROM (
    SELECT
        round(corr(gdp_last_now_percentage_increase,wage_last_now_percentage_increase)::numeric, 1) AS gdp_now__wage_now,
        round(corr(gdp_last_now_percentage_increase,wage_now_next_percentage_increase)::numeric, 1) AS gdp_now__wage_next_year,
        round(corr(gdp_last_now_percentage_increase,price_last_now_percentage_increase)::numeric, 1) AS gdp_now__price_now,
        round(corr(gdp_last_now_percentage_increase,price_now_next_percentage_increase)::numeric, 1) AS gdp_now__price_next_year
    FROM cte_years_gdp_wages_prices_last_next_year
),
LATERAL (
    VALUES
        ('gdp_now__wage_now', gdp_now__wage_now),
        ('gdp_now__wage_next_year', gdp_now__wage_next_year),
        ('gdp_now__price_now', gdp_now__price_now),
        ('gdp_now__price_next_year', gdp_now__price_next_year)
) AS transpose_results(metric, correlation);
