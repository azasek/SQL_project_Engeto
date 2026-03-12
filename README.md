# SQL_project_Engeto
Repository for final SQL project from Data academy in Engeto. Questions about wages and prices in Czech Republic.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
## Motivace:
Tento projekt vznikl jako výstupní SQL projekt kurzu Datové akademie od Engeta.\
Projekt byl vytvořen v PostgreSQL na základě databáze *data_academy_content@data_academy_2025_09_10*\
Anežka Sekavová\
12.3.2026

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

## Úvod do projektu:
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.\
Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.\
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
## Shrnutí projektu:

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Jednotlivé tabulky a úkoly jsou rozřazeny do samostatných souborů:
- SQL_project_Table1
- SQL_project_Table2
- SQL_project_Task1
- SQL_project_Task2
- SQL_project_Task3
- SQL_project_Task4
- SQL_project_Task5

## Jednotlivé části projektu (zadání - popis - odpověď):

### Tabulka 1 - t_anezka_sekavova_project_SQL_primary_final:
Přes *INNER JOIN* byly přes roky propojeny tabulky *czechia_payroll* a *czechia_price*. Tím byla zajištěna stejná pozorovaná oblast let v obou tabulkách (2006 - 2018).\
Mzdy, které byly rozděleny v původní tabulce na čtvrtletí, byly zprůměrovány za celý rok.\
Mzdy byly použité s *calculation_code = 100 = fyzický*.\
Ceny, které byly rozděleny v původní tabulce na jednotlivé dny, byly zprůměrovány za celý rok pro konkrétní kategorii potravin.\
K tabulce byly připojeny tabulky czechia_payroll_industry_branch a czechia_price_category kvůli lepšímu přehledu v názvech odvětví a kategoriích potravin.\
Nakonec byla připojena tabulka economies kvůli hodnotám HDP v České republice.

### Tabulka 2 - t_anezka_sekavova_project_SQL_secondary_final:
Přes *INNER JOIN* byly propojeny tabulky economies a countries.\
S *country = Evropa* a s daty mezi 2006 a 2018. Což je časová oblast odpovídající tabulce 1.\
Tabulka nebyla dále čištěna, protože není jasné, jaká data z ní budou potřeba, a při čištění by došlo k velké ztrátě dat.\
Ve sloupcích gdp a gini se tedy objevují NULL hodnoty. Díky tomu jsme ale schopní v těchto letech vidět hodnotu populace.\
Spojením přes *INNER JOIN* byly zanedbány státy, které se vyskytují pouze v jedné, nebo druhé tabulce. Ve výsledné tabulce proto chybí údaje o Vatikánu, Severním Irsku a Špicberkách.

### Úkol 1:
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
#### Poznámky:
K přehledu mezd v letech rozčleněných podle odvětví byl přidán sloupec se mzdami z předchozího roku v daném odvětví (funkce *LAG()*).\
A následně sloupec balance, který ukazuje, jestli vzhledem k předchozímu roku platy v odvětví stouply, nebo klesly.\
Řádky z prvního roku v tabulce (2006), kde nejsou data k roku předchozímu nebyly uvažovány.
#### ODPOVĚĎ:
Ve většině odvětví mzdy rostou i klesají.\
Je pět odvětví, kde na datovém vzorku pouze rostou mzdy: Administrativní a podpůrné činnosti, Doprava a skladování, Ostatní činnosti, Zdravotní a sociální péče, Zpracovatelský průmysl.

### Úkol 2:
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
#### Poznámky:
Z tabulky byly použity průměrné mzdy a ceny v letech.\
Byly zanedbány mzdy, které mají NULL v category_branch_name.\
Vyfiltrovány byly pouze kategorie Mléko polotučné pasterované a Chléb konzumní kmínový.\
Výsledek byl vypočten jako mzda/cena v daném roce pro konkrétní kategorii.\
První a poslední období bylo vyfiltrováno pomocí funkce *LIMIT* ve dvou provedeních (pro první a pro poslední rok) a tyto dva výběry byly spojeny přes *UNION ALL*.
#### ODPOVĚĎ:
Za první období (rok 2006) je možné koupit 1262 kg chleba a 1409 l mléka\
Za poslední období (rok 2018) je možné koupit 1319 kg chleba a 1614 l mléka

### Úkol 3:
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
#### Poznámky:
K tabulce s cenami kategorií v letech byl přidán sloupec s cenami za předchozí rok (funkce *LAG()*).\
Z cen za předchozí rok a daný rok byl vypočítán percentuální meziroční nárust.\
Řádky z prvního roku v tabulce (2006), kde nejsou data k roku předchozímu nebyly uvažovány.\
Data byla seřazena podle percentuálního meziročního nárustu.
#### ODPOVĚĎ:
Nejpomaleji zdražovala Rajská jablka červená kulata mezi lety 2006 a 2007. Percentuální nárust -30 %

### Úkol 4:
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
#### Poznámky:
K tabulce s průměrnými mzdami a průměrnými cenami za daný rok byly přidány sloupce mezd a cen za rok předchozí (funkce *LAG()*).\
Pro mzdy a ceny byl vypočítán percentuální meziroční nárůst a přidán sloupec, který ukazuje, jestli byl nárust menší nebo větší než 10 % ('over 10 %' a 'under 10 %').\
Řádky z prvního roku v tabulce (2006), kde nejsou data k roku předchozímu nebyly uvažovány.\
Nakonec byly vyfiltrovány všechny roky, kde byl percentuální meziroční nárůst větší než 10 %.
#### ODPOVĚĎ:
Neexistuje takový rok. Maximální rozdíl v meziročním nárustu cen a mezd je 7%.

### Úkol 5:
Má výška HDP vliv na změny ve mzdách a cenách potravin?\
Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
#### Postup:
Byla vytvořena tabulka s hdp, průměrnými mzdami a průměrnými cenami v letech.\
K ní byly přidány sloupce s hdp z předchozího roku, mzdami z předchozího a následujícího roku a cenami z předchozího a následujícího roku (funkce *LAG()* - pro následující rok by se dala použít i funkce *LEAD()*).\
Pro všechny tyto hodnoty byly vypočítány meziroční percentuální nárusty.\
Výsledky byly vyhodnoceny pomocí funkce na korelaci (*CORR()*).\
Nakonec byla tabulka z formátu 2x4 transponována do 4x2 a výsledky korelace byly klasifikovány jako pozitivní/negativní a žádná/slabá/střední/silná korelace.
#### ODPOVĚĎ:
Silná korelace jde vidět ve mzdách v následujícím roce. Střední korelace je u cen a mezd v aktuálním roce. Žádná závislost není u cen v následujícím roce.\
Tedy:\
	Mzdy reagují se zpožděním – silná korelace příští rok, střední letos.\
	Ceny reagují okamžitě jen částečně – střední korelace letos, nulová příští rok.\
	HDP je tedy lepší indikátor budoucích mezd než budoucích cen.\
	Všechny korelace jsou pozitivní, takže vyšší HDP = vyšší mzdy/ceny, jen síla efektu se liší.
