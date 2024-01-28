/*
Begin by selecting all columns from the cities table, using the SQL shortcut that selects all.
*/

-- Select all columns from cities
SELECT *
FROM cities;

/*
Perform an inner join with the cities table on the left and the countries table on the right; do not alias tables here or in the next step.
Identify the relevant column names to join ON by inspecting the cities and countries tabs in the console.
*/
SELECT *
FROM cities
-- Inner join to countries
INNER JOIN countries
-- Match on country codes
ON cities.country_code = countries.code;

/*
Complete the SELECT statement to keep only the name of the city, the name of the country, and the region the country is located in (in the order specified).
Alias the name of the city AS city and the name of the country AS country.
*/
-- Select name fields (with alias) and region 
SELECT cities.name AS city,countries.name AS country,region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

/*
Start with your inner join in line 5; join the tables countries AS c (left) with economies (right), aliasing economies AS e.
Next, use code as your joining field in line 7; do not use the USING command here.
Lastly, select the following columns in order in line 2: code from the countries table (aliased as country_code), name, year, and inflation_rate.
*/

-- Select fields with aliases
SELECT c.code as country_code,c.name,e.year,e.inflation_rate
FROM countries AS c
-- Join to economies (alias e)
INNER JOIN economies AS e
-- Match on code field using table aliases
ON c.code=e.code;

/*
Use the country code field to complete the INNER JOIN with USING; do not change any alias names.
*/

SELECT c.name AS country, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
-- Match using the code column
using(code);

/*
Start with the join statement in line 6; perform an inner join with the countries table as c on the left with the languages table as l on the right.
Make use of the USING keyword to join on code in line 8.
Lastly, in line 2, select the country name, aliased as country, and the language name, aliased as language.
*/
-- Select country and language names, aliased
SELECT c.name AS country, l.name AS language
-- From countries (aliased)
FROM countries AS c
-- Join to languages (aliased)
INNER JOIN languages AS l
-- Use code as the joining field with the USING keyword
USING(code);

/*
Rearrange the SELECT statement so that the language column appears on the left and the country column on the right.
Sort the results by language.
*/
-- Rearrange SELECT statement, keeping aliases
SELECT c.name AS country, l.name AS language
FROM countries AS c
INNER JOIN languages AS l
USING(code)
-- Order the results by language
ORDER BY language;

/*
Perform an inner join of countries AS c (left) with populations AS p (right), on code.
Select name, year and fertility_rate.
Chain another inner join to your query with the economies table AS e, using code.
Select name, and using table aliases, select year and unemployment_rate from economies.
*/
-- Select relevant fields
SELECT name,year,fertility_rate
FROM countries AS c
-- Inner join countries and populations, aliased, on code
INNER JOIN populations AS p
ON c.code = p.country_code;

-- Select fields
SELECT name, p.year, fertility_rate, unemployment_rate,e.year
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
-- Join to economies (as e)
INNER JOIN economies AS e
-- Match on country code
ON c.code=e.code;


/*
Modify your query so that you are joining to economies on year as well as code.
*/
SELECT name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
-- Add an additional joining condition such that you are also joining on year
AND p.year=e.year;


/*
Perform an inner join with cities AS c1 on the left and countries as c2 on the right.
Use code as the field to merge your tables on.
Change the code to perform a LEFT JOIN instead of an INNER JOIN.
After executing this query, have a look at how many records the query result contains.
*/

SELECT 
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
-- Perform an inner join with cities as c1 and countries as c2 on country code
INNER JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;


SELECT 
	c1.name AS city, 
    code, 
    c2.name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
-- Join right table (with alias)
LEFT JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;

/*
Complete the LEFT JOIN with the countries table on the left and the economies table on the right on the code field.
Filter the records from the year 2010.
*/

SELECT name, region, gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
-- Match on code fields
ON c.code = e.code
-- Filter for the year 2010
WHERE year = 2010 ;

/*
To calculate per capita GDP per region, begin by grouping by region.
After your GROUP BY, choose region in your SELECT statement, followed by average GDP per capita using the AVG() function, with AS avg_gdp as your alias.
*/

-- Select region, and average gdp_percapita as avg_gdp
SELECT region,AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
-- Group by region
GROUP BY region;

/*
Order the result set by the average GDP per capita from highest to lowest.
Return only the first 10 records in your result.
*/

SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC
-- Return only first 10 records
LIMIT 10;


/*
Write a new query using RIGHT JOIN that produces an identical result to the LEFT JOIN provided.
*/

-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT countries.name AS country, languages.name AS language, percent
FROM languages
RIGHT JOIN countries
USING(code)
ORDER BY language;

/*
Perform a full join with countries (left) and currencies (right).
Filter for the North America region or NULL country names.
Repeat the same query as before, turning your full join into a left join with the currencies table.
Have a look at what has changed in the output by comparing it to the full join result.
Repeat the same query again, this time performing an inner join of countries with currencies.
Have a look at what has changed in the output by comparing it to the full join and left join results!
*/

SELECT name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
FULL JOIN currencies
USING (code)
-- Where region is North America or name is null
WHERE region = 'North America' OR name IS NULL
ORDER BY region;


SELECT name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
LEFT JOIN currencies
USING (code)
WHERE region = 'North America' 
	OR name IS NULL
ORDER BY region;


SELECT name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
INNER JOIN currencies
USING (code)
WHERE region = 'North America' 
	OR name IS NULL
ORDER BY region;


/*
Complete the FULL JOIN with countries as c1 on the left and languages as l on the right, using code to perform this join.
Next, chain this join with another FULL JOIN, placing currencies on the right, joining on code again.

*/

SELECT 
	c1.name AS country, 
    region, 
    l.name AS language,
	basic_unit, 
    frac_unit
FROM countries as c1 
-- Full join with languages (alias as l)
FULL JOIN languages AS l
USING (code)
-- Full join with currencies (alias as c2)
FULL JOIN currencies AS c2
USING (code)
WHERE region LIKE 'M%esia';


/*
Complete the code to perform an INNER JOIN of countries AS c with languages AS l using the code field to obtain the languages currently spoken in the two countries.
*/
SELECT c.name AS country, l.name AS language
-- Inner join countries as c with languages as l on code
FROM languages AS l
INNER JOIN countries AS c
USING (code)
WHERE c.code IN ('PAK','IND')
	AND l.code in ('PAK','IND');


	/*
	Change your INNER JOIN to a different kind of join to look at possible combinations of languages that could have been spoken in the two countries given their history.
Observe the differences in output for both joins.
*/

SELECT c.name AS country, l.name AS language
FROM countries AS c        
-- Perform a cross join to languages (alias as l)
CROSS JOIN languages AS l
WHERE c.code in ('PAK','IND')
	AND l.code in ('PAK','IND');


	/*
	Complete the join of countries AS c with populations as p.
Filter on the year 2010.
Sort your results by life expectancy in ascending order.
Limit the result to five countries.
*/

SELECT 
	c.name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
-- Join to populations (alias as p) using an appropriate join
INNER JOIN populations AS p
ON c.code = p.country_code
-- Filter for only results in the year 2010
WHERE year = 2010
-- Sort by life_exp
ORDER BY life_exp ASC
-- Limit to five records
LIMIT 5;


/*
Perform an inner join of populations with itself ON country_code, aliased p1 and p2 respectively.
Select the country_code from p1 and the size field from both p1 and p2, aliasing p1.size as size2010 and p2.size as size2015 (in that order).
*/

-- Select aliased fields from populations as p1
SELECT p1.country_code, 
       p1.size AS size2010, 
       p2.size AS size2015
-- Join populations as p1 to itself, alias as p2, on country code
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code;


/*
Since you want to compare records from 2010 and 2015, eliminate unwanted records by extending the WHERE statement to include only records where the p1.year matches p2.year - 5.
*/

 SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = 2010
-- Filter such that p1.year is always five years before p2.year
AND p1.year = p2.year-5;

/*
Begin your query by selecting all fields from economies2015.
Create a second query that selects all fields from economies2019.
Perform a set operation to combine the two queries you just created, ensuring you do not return duplicates.
*/

-- Select all fields from economies2015
SELECT *  
FROM economies2015
-- Set operation
UNION
-- Select all fields from economies2019
SELECT *
FROM economies2019
ORDER BY code, year;


/*
Perform an appropriate set operation that determines all pairs of country code and year (in that order) from economies and populations, excluding duplicates.
Order by country code and year.
Amend the query to return all combinations (including duplicates) of country code and year in the economies or the populations tables.
*/

-- Query that determines all pairs of code and year from economies and populations, without duplicates
SELECT code,year
FROM economies
UNION 
SELECT country_code AS code,year
FROM populations
ORDER BY code,year;

SELECT code, year
FROM economies
-- Set theory clause
UNION all
SELECT country_code, year
FROM populations
ORDER BY code, year;


/*
Return all city names that are also country names.
*/

-- Return all cities with the same name as a country
SELECT name
FROM cities
INTERSECT
SELECT name
FROM countries;


/*
Return all cities that do not have the same name as a country.
*/

-- Return all cities that do not have the same name as a country
SELECT name
FROM cities
EXCEPT
SELECT name
FROM countries
ORDER BY name;


/*
Select country code as a single field from the countries table, filtering for countries in the 'Middle East' region.
*/

-- Select country code for countries in the Middle East
SELECT code
FROM countries
WHERE region='Middle East';


/*
Write a second query to SELECT the name of each unique language appearing in the languages table; do not use column aliases here.
Order the result set by name in ascending order.
*/

-- Select country code for countries in the Middle East
SELECT DISTINCT(name)
FROM languages
ORDER BY name ASC;

/*
Create a semi join out of the two queries you've written, which filters unique languages returned in the first query for only those languages spoken in the 'Middle East'.
*/

SELECT DISTINCT name
FROM languages
-- Add syntax to use bracketed subquery below as a filter
WHERE code IN
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;

/*
Begin by writing a query to return the code and name (in order, not aliased) for all countries in the continent of Oceania from the countries table.
Observe the number of records returned and compare this with the provided INNER JOIN, which returns 15 records.
*/

SELECT code,name
FROM countries
WHERE continent = 'Oceania';

/*
Now, build on your query to complete your anti join, by adding an additional filter to return every country code that is not included in the currencies table.
*/

SELECT code, name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
  AND code NOT IN 
    (SELECT code
    FROM currencies);

    /*

    Begin by calculating the average life expectancy from the populations table.
Filter your answer to use records from 2015 only.
*/

-- Select average life_expectancy from the populations table
SELECT AVG(life_expectancy)
FROM populations
-- Filter for the year 2015
WHERE year = 2015;

/*
The answer from your query has now been nested into another query; use this calculation to filter populations for all records where life_expectancy is 1.15 times higher than average.
*/

SELECT *
FROM populations
-- Filter for only those populations where life expectancy is 1.15 times higher than average
WHERE life_expectancy > 1.15 *
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015) 
    AND year = 2015;


    /*
    Return the name, country_code and urbanarea_pop for all capital cities (not aliased).
    */

    -- Select relevant fields from cities table
SELECT name, country_code, urbanarea_pop
FROM cities
-- Filter using a subquery on the countries table
WHERE name in
(SELECT capital
FROM countries)
ORDER BY urbanarea_pop DESC;

/*
Write a LEFT JOIN with countries on the left and the cities on the right, joining on country code.
In the SELECT statement of your join, include country names as country, and count the cities in each country, aliased as cities_num.
Sort by cities_num (descending), and country (ascending), limiting to the first nine records.
*/

-- Find top nine countries with the most cities
SELECT countries.name AS country, COUNT(*) AS cities_num
FROM countries
LEFT JOIN cities
ON countries.code = cities.country_code
-- Order by count of cities as cities_num
GROUP BY country
ORDER BY cities_num DESC, country ASC
LIMIT 9;


/*
Complete the subquery to return a result equivalent to your LEFT JOIN, counting all cities in the cities table as cities_num.
Use the WHERE clause to enable the correct country codes to be matched in the cities and countries columns.

*/

SELECT countries.name AS country, COUNT(*) as cities_num
FROM countries
LEFT JOIN cities
ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country ASC
LIMIT 9;

/*
Begin with a query that groups by each country code from languages, and counts the languages spoken in each country as lang_num.
In your SELECT statement, return code and lang_num (in that order).
*/

-- Select code, and language count as lang_num
SELECT code,COUNT(*) AS lang_num
FROM languages
GROUP BY code;


/*
Select local_name from countries, with the aliased lang_num from your subquery (which has been nested and aliased for you as sub).
Use WHERE to match the code field from countries and sub.
*/

-- Select local_name and lang_num from appropriate tables
SELECT local_name,sub.lang_num
FROM countries,
  (SELECT code, COUNT(*) AS lang_num
  FROM languages
  GROUP BY code) AS sub
-- Where codes match
WHERE countries.code = sub.code
ORDER BY lang_num DESC;

/*

Select country code, inflation_rate, and unemployment_rate from economies.
Filter code for the set of countries which do not contain the words "Republic" or "Monarchy" in their gov_form.

*/

-- Select relevant fields
SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code
  FROM countries
  WHERE gov_form LIKE '%Republic%' OR gov_form LIKE '%Monarch%')
ORDER BY inflation_rate;

/*

From cities, select the city name, country code, proper population, and metro area population, as well as the field city_perc, which calculates the proper population as a percentage of metro area population for each city (using the formula provided).
Filter city name with a subquery that selects capital cities from countries in 'Europe' or continents with 'America' at the end of their name.
Exclude NULL values in metroarea_pop.
Order by city_perc (descending) and return only the first 10 rows.
*/

-- Select fields from cities
SELECT name,country_code, city_proper_pop,metroarea_pop,
city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities
-- Use subquery to filter city name
WHERE name IN
(SELECT capital
FROM countries
WHERE (continent='Europe' OR continent LIKE '%America%'))
-- Add filter condition such that metroarea_pop does not have null values
AND metroarea_pop IS NOT NULL 
-- Sort and limit the result
ORDER BY city_perc DESC
LIMIT 10;



