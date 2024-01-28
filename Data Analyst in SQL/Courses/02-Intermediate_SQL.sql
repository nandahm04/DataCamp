/*
Count the total number of records in the people table, aliasing the result as count_records.
Count the number of records with a birthdate in the people table, aliasing the result as count_birthdate.
Count the records for languages and countries in the films table; alias as count_languages and count_countries.
*/

-- Count the number of records in the people table
SELECT COUNT(*) AS count_records
FROM people;

-- Count the number of birthdates in the people table
SELECT COUNT(birthdate) AS count_birthdate
FROM people;

-- Count the records for languages and countries represented in the films table
SELECT COUNT (language) AS count_languages, COUNT(country) AS count_countries
FROM films;


/*
Return the unique countries represented in the films table using DISTINCT.
Return the number of unique countries represented in the films table, aliased as count_distinct_countries.

*/

-- Return the unique countries from the films table
SELECT DISTINCT (country)
FROM films;

-- Count the distinct countries from the films table
SELECT COUNT(DISTINCT(country)) AS count_distinct_countries
FROM films;


/*
Debug and fix the SQL query provided.
Find the two errors in this code; the same error has been repeated twice.
Find the two bugs in this final query.
*/


-- Debug this code
SELECT certification
FROM films
LIMIT 5;

-- Debug this code
SELECT film_id,imdb_score, num_votes
FROM reviews;


-- Debug this code
SELECT COUNT(birthdate) AS count_birthdays
FROM people;


/*

Adjust the sample code so that it is in line with standard practices.
*/

-- Rewrite this query
SELECT person_id, role 
FROM roles 
LIMIT 10;


/*

Select the film_id and imdb_score from the reviews table and filter on scores higher than 7.0.
Select the film_id and facebook_likes of the first ten records with less than 1000 likes from the reviews table.
Count how many records have a num_votes of at least 100,000; use the alias films_over_100K_votes.

*/

-- Select film_ids and imdb_score with an imdb_score over 7.0
SELECT film_id, imdb_score
FROM reviews
WHERE imdb_score>7.0;

-- Select film_ids and facebook_likes for ten records with less than 1000 likes 
SELECT film_id, facebook_likes
FROM reviews
WHERE facebook_likes<1000
LIMIT 10;

-- Count the records with at least 100,000 votes
SELECT COUNT(*) AS films_over_100K_votes
FROM reviews
WHERE num_votes >= 100000;


/*
Select the title and release_year for all German-language films released before 2000.
Update the query from the previous step to show German-language films released after 2000 rather than before.
Select all details for German-language films released after 2000 but before 2010 using only WHERE and AND.
*/

-- Select the title and release_year for all German-language films released before 2000
SELECT title, release_year
FROM films
WHERE language='German' AND release_year < 2000;

-- Update the query to see all German-language films released after 2000
SELECT title, release_year
FROM films
WHERE release_year > 2000
	AND language = 'German';


	-- Select all records for German-language films released after 2000 and before 2010
SELECT *
FROM films
WHERE release_year > 2000 AND 
release_year < 2010 AND language = 'German';

/*
Select the title and release_year for films released in 1990 or 1999 using only WHERE and OR.

Filter the records to only include English or Spanish-language films.

Finally, restrict the query to only return films worth more than $2,000,000 gross.
*/

-- Find the title and year of films from the 1990 or 1999
SELECT title, release_year
FROM films
WHERE release_year= 1990 OR release_year=1999;

SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
-- Add a filter to see only English or Spanish-language films
	AND (language= 'English' OR language='Soanish');

	SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
	AND (language = 'English' OR language = 'Spanish')
-- Filter films with more than $2,000,000 gross
AND gross>2000000	;


/*
Select the title and release_year of all films released between 1990 and 2000 (inclusive) using BETWEEN.
*/

-- Select the title and release_year for films released between 1990 and 2000
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000;

/*
Build on your previous query to select only films with a budget over $100 million.
*/
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
-- Narrow down your query to films with budgets > $100 million
	AND budget>100000000;

	/*
	Now, restrict the query to only return Spanish-language films.
	*/

	SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
	AND budget > 100000000
-- Restrict the query to only Spanish-language films
	AND language = 'Spanish';

	/*
	Finally, amend the query to include all Spanish-language or French-language films with the same criteria.
	*/

	SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
	AND budget > 100000000
-- Amend the query to include Spanish or French-language films
	AND (language = 'Spanish' OR language ='French');


	/*
	Select the names of all people whose names begin with 'B'.
Select the names of people whose names have 'r' as the second letter.
Select the names of people whose names don't start with 'A'.
*/

-- Select the names that start with B
SELECT name
FROM people
WHERE name LIKE 'B%'

SELECT name
FROM people
-- Select the names that have r as the second letter
WHERE name LIKE '_r%';

SELECT name
FROM people
-- Select names that don't start with A
WHERE name NOT LIKE 'A%';


/*
Select the title and release_year of all films released in 1990 or 2000 that were longer than two hours.
Select the title and language of all films in English, Spanish, or French using IN.
Select the title, certification and language of all films certified NC-17 or R that are in English, Italian, or Greek.
*/

-- Find the title and release_year for all films over two hours in length released in 1990 and 2000
SELECT title,release_year
FROM films
WHERE release_year IN (1990,2000) AND duration > 120;

-- Find the title and language of all films in English, Spanish, and French
SELECT title, language
FROM films
WHERE language IN ('English','Spanish','French');

-- Find the title, certification, and language all films certified NC-17 or R that are in English, Italian, or Greek
SELECT title, certification,language
FROM films
WHERE certification IN ('NC-17','R') AND language IN ('English','Italian','Greek');


/*
Count the unique titles from the films database and use the alias provided.
Filter to include only movies with a release_year from 1990 to 1999, inclusive.
Add another filter narrowing your query down to English-language films.
Add a final filter to select only films with 'G', 'PG', 'PG-13' certifications.
*/
-- Count the unique titles
SELECT COUNT (DISTINCT(title)) AS nineties_english_films_for_teens
FROM films
-- Filter to release_years to between 1990 and 1999
WHERE release_year BETWEEN 1990 AND 1999
-- Filter to English-language films
	AND language='English'
-- Narrow it down to G, PG, and PG-13 certifications
	AND Certification IN ('G','PG','PG-13') ;


	/*
	Select the title of every film that doesn't have a budget associated with it and use the alias no_budget_info.
Count the number of films with a language associated with them and use the alias count_language_known.
*/

-- List all film titles with missing budgets
SELECT title AS no_budget_info
FROM films
WHERE budget IS NULL;

-- Count the number of films we have language data for
SELECT COUNT(language) AS count_language_known
FROM films;


/*
Use the SUM() function to calculate the total duration of all films and alias with total_duration.
Calculate the average duration of all films and alias with average_duration.
Find the most recent release_year in the films table, aliasing as latest_year.
Find the duration of the shortest film and use the alias shortest_film.
*/

-- Query the sum of film durations
  SELECT SUM(duration) AS total_duration
  FROM films;

  -- Calculate the average duration of all films
SELECT AVG(duration) AS average_duration
FROM films;

-- Find the latest release_year
SELECT MAX(release_year) AS latest_year
FROM films;

-- Find the duration of the shortest film
SELECT MIN(duration) AS shortest_film
FROM films;

/*
Use SUM() to calculate the total gross for all films made in the year 2000 or later, and use the alias total_gross.
Calculate the average amount grossed by all films whose titles start with the letter 'A' and alias with avg_gross_A.
Calculate the lowest gross film in 1994 and use the alias lowest_gross.
Calculate the highest gross film between 2000 and 2012, inclusive, and use the alias highest_gross.
*/

-- Calculate the sum of gross from the year 2000 or later
SELECT SUM(gross) AS total_gross
FROM films
WHERE release_year >= 2000;

-- Calculate the average gross of films that start with A
SELECT AVG (gross) AS avg_gross_A
FROM films
WHERE title LIKE 'A%';

-- Calculate the lowest gross film in 1994
SELECT MIN(gross) AS lowest_gross
FROM films
WHERE release_year=1994;

-- Calculate the highest gross film released between 2000-2012
SELECT MAX(gross) AS highest_gross
FROM films
WHERE release_year BETWEEN 2000 AND 2012;


/*
Calculate the average facebook_likes to one decimal place and assign to the alias, avg_facebook_likes.
*/

-- Round the average number of facebook_likes to one decimal place
SELECT ROUND(AVG(facebook_likes),1) AS avg_facebook_likes
FROM reviews;

/*
Calculate the average budget from the films table, aliased as avg_budget_thousands, and round to the nearest thousand.

*/

-- Calculate the average budget rounded to the thousands
SELECT ROUND(AVG(budget),-3) AS avg_budget_thousands
FROM films;

/*
Select the title and duration in hours for all films and alias as duration_hours; since the current durations are in minutes, you'll need to divide duration by 60.0.
Calculate the percentage of people who are no longer alive and alias the result as percentage_dead.
Find how many decades (period of ten years) the films table covers by using MIN() and MAX(); alias as number_of_decades.
*/

-- Calculate the title and duration_hours from films
SELECT title, (duration/60.0) AS duration_hours
FROM films;

-- Calculate the percentage of people who are no longer alive
SELECT COUNT(deathdate)* 100.0 / COUNT(*) AS percentage_dead
FROM people;

-- Find the number of decades in the films table
SELECT  (MAX(release_year)-MIN(release_year))/ 10.0 AS number_of_decades
FROM films;

/*
Update the query by adding ROUND() around the calculation and round to two decimal places.
*/

-- Round duration_hours to two decimal places
SELECT title, ROUND(duration / 60.0, 2) AS duration_hours
FROM films;

/*
Select the name of each person in the people table, sorted alphabetically.
Select the title and duration for every film, from longest duration to shortest.
*/

-- Select name from people and sort alphabetically
SELECT name
FROM people
ORDER BY name;


-- Select the title and duration from longest to shortest film
SELECT title,duration
FROM films
ORDER BY duration ASC;

/*

Select the release_year, duration, and title of films ordered by their release year and duration, in that order.
Select the certification, release_year, and title from films ordered first by certification (alphabetically) and second by release year, starting with the most recent year.
*/

-- Select the release year, duration, and title sorted by release year and duration
SELECT release_year, duration, title
FROM films
ORDER BY release_year, duration;

-- Select the certification, release year, and title sorted by certification and release year
SELECT certification, release_year,title
FROM films
ORDER BY certification, release_year DESC;


/*
Select the release_year and count of films released in each year aliased as film_count.
Select the release_year and average duration aliased as avg_duration of all films, grouped by release_year
*/

-- Find the release_year and film_count of each year
SELECT release_year, COUNT(*) AS film_count
FROM films
GROUP BY release_year;

-- Find the release_year and average duration of films for each year
SELECT release_year,AVG(duration) AS avg_duration
FROM films
GROUP BY release_year;

/*
Select the release_year, country, and the maximum budget aliased as max_budget for each year and each country; sort your results by release_year and country.
*/
-- Find the release_year, country, and max_budget, then group and order by release_year and country
SELECT release_year,country,MAX(budget) AS max_budget
FROM films
GROUP BY release_year,country
ORDER BY release_year,country;

/*
Select country from the films table, and get the distinct count of certification aliased as certification_count.
Group the results by country.
Filter the unique count of certifications to only results greater than 10.
*/

-- Select the country and distinct count of certification as certification_count
SELECT country,COUNT(DISTINCT(certification)) AS certification_count
FROM films
-- Group by country
GROUP BY country
-- Filter results to countries with more than 10 different certifications
HAVING COUNT(DISTINCT(certification)) >10;


/*
Select the country and the average budget as average_budget, rounded to two decimal, from films.
Group the results by country.
Filter the results to countries with an average budget of more than one billion (1000000000).
Sort by descending order of the average_budget.
*/

-- Select the country and average_budget from films
SELECT country, ROUND(AVG(budget),2) AS average_budget
FROM films
-- Group by country
GROUP BY country
-- Filter to countries with an average_budget of more than one billion
HAVING AVG(budget)>1000000000
-- Order by descending order of the aggregated budget
ORDER BY average_budget DESC;

/*
Select the release_year for each film in the films table, filter for records released after 1990, and group by release_year.
Modify the query to include the average budget aliased as avg_budget and average gross aliased as avg_gross for the results we have so far.
Modify the query once more so that only years with an average budget of greater than 60 million are included.
Finally, order the results from the highest average gross and limit to one.

*/
-- Select the release_year for films released after 1990 grouped by year
SELECT release_year
FROM films
GROUP BY release_year
HAVING release_year>1990;

-- Modify the query to also list the average budget and average gross
SELECT release_year, AVG(budget) AS avg_budget,AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
-- Modify the query to see only years with an avg_budget of more than 60 million
HAVING AVG(budget)>60000000;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
-- Order the results from highest to lowest average gross and limit to one
ORDER BY avg_gross DESC
LIMIT 1;





