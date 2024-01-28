/*Select all columns from renting.*/

SELECT * -- Select all
FROM renting;        -- From table renting

/*Now select only those columns from renting which are needed to calculate the average rating per movie.*/

SELECT movie_id,  -- Select all columns needed to compute the average rating per movie
       rating
FROM renting;


/*Select all movies rented on October 9th, 2018.
Select all records of movie rentals between beginning of April 2018 till end of August 2018.
Put the most recent records of movie rentals on top of the resulting table and order them in decreasing order.*/

SELECT *
FROM renting
WHERE date_renting = '2018-10-09'; -- Movies rented on October 9th, 2018


SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31';


SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
ORDER BY rating DESC; -- Order by recency in decreasing order


/*
35 XP
Select all movies which are not dramas.
Select the movies 'Showtime', 'Love Actually' and 'The Fighter'.
Order the movies by increasing renting price.*/


SELECT *
FROM movies
WHERE genre <> 'Drama'; -- All genres except drama


SELECT *
FROM movies
WHERE title IN ('Showtime', 'Love Actually', 'The Fighter'); -- Select all movies with the given titles


SELECT *
FROM movies
ORDER BY renting_price ASC ; -- Order the movies by increasing renting price


/*Select from table renting all movie rentals from 2018.
Filter only those records which have a movie rating.

*/


SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' -- Renting in 2018
AND rating IS NOT NULL; -- Rating exists


/*Count the number of customers born in the 80s.
Count the number of customers from Germany.
Count the number of countries where MovieNow has customers.*/


SELECT COUNT(*) -- Count the total number of customers
FROM customers
WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31'; -- Select customers born between 1980-01-01 and 1989-12-31


SELECT COUNT(*)  -- Count the total number of customers
FROM customers
WHERE country = 'Germany'; -- Select all customers from Germany


SELECT COUNT(distinct country)  -- Count the number of countries
FROM customers;


/*Select all movie rentals of the movie with movie_id 25 from the table renting.
For those records, calculate the minimum, maximum and average rating and count the number of ratings for this movie.*/

SELECT MIN(rating) AS min_rating, -- Calculate the minimum rating and use alias min_rating
       MAX(rating) AS max_rating, -- Calculate the maximum rating and use alias max_rating
       AVG(rating) AS avg_rating, -- Calculate the average rating and use alias avg_rating
       COUNT(rating) AS number_ratings -- Count the number of ratings and use alias number_ratings
FROM renting
WHERE movie_id = 25; -- Select all records of the movie with ID 25


/*First, select all records of movie rentals since January 1st 2019.*/

SELECT * -- Select all records of movie rentals since January 1st 2019
FROM renting
WHERE date_renting >= '2019-01-01'; 

/*Now, count the number of movie rentals and calculate the average rating since the beginning of 2019.*/


SELECT 
    Count(renting_id), -- Count the total number of rented movies
    AVG(rating) -- Add the average rating
FROM renting
WHERE date_renting >= '2019-01-01';

/*Use as alias column names number_renting and average_rating respectively.*/


SELECT 
    COUNT(*) AS number_renting, -- Give it the column name number_renting
    AVG(rating) AS average_rating  -- Give it the column name average_rating
FROM renting
WHERE date_renting >= '2019-01-01';


/*Finally, count how many ratings exist since 2019-01-01.*/


SELECT 
    COUNT(*) AS number_renting,
    AVG(rating) AS average_rating, 
    COUNT(rating) AS number_ratings -- Add the total number of ratings here.
FROM renting
WHERE date_renting >= '2019-01-01';

/*Create a table with a row for each country and columns for the country name and the date when the first customer account was created.
Use the alias first_account for the column with the dates.
Order by date in ascending order.*/


SELECT country, -- For each country report the earliest date when an account was created
    MIN(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account ASC;

/*Group the data in the table renting by movie_id and report the ID and the average rating.*/


SELECT movie_id, 
       AVG(rating)    -- Calculate average rating per movie
FROM renting
GROUP BY movie_id;


/*Add two columns for the number of ratings and the number of movie rentals to the results table.
Use alias names avg_rating, number_rating and number_renting for the corresponding columns.*/

SELECT movie_id, 
       AVG(rating) AS avg_rating, -- Use as alias avg_rating
       COUNT(rating) AS number_rating,                -- Add column for number of ratings with alias number_rating
       COUNT(renting_id) AS number_renting            -- Add column for number of movie rentals with alias number_renting
FROM renting
GROUP BY movie_id;

/*Order the rows of the table by the average rating such that it is in decreasing order.
Observe what happens to NULL values.*/


SELECT movie_id, 
       AVG(rating) AS avg_rating,
       COUNT(rating) AS number_ratings,
       COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
ORDER BY avg_rating DESC; -- Order by average rating in decreasing order


/*Group the data in the table renting by customer_id and report the customer_id, the average rating, the number of ratings and the number of movie rentals.
Select only customers with more than 7 movie rentals.
Order the resulting table by the average rating in ascending order.*/


SELECT customer_id, -- Report the customer_id
      AVG(rating),  -- Report the average rating per customer
      COUNT(rating),  -- Report the number of ratings per customer
      COUNT(*)  -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
HAVING COUNT(*) > 7 -- Select only customers with more than 7 movie rentals
ORDER BY AVG(rating); -- Order by the average rating in ascending order

/*Augment the table renting with all columns from the table customers with a LEFT JOIN.
Use as alias' for the tables r and c respectively.*/


SELECT * -- Join renting with customers
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id ;

/*Select only records from customers coming from Belgium.*/

SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country = 'Belgium'; -- Select only records from customers coming from Belgium

/*Average ratings of customers from Belgium.*/

SELECT AVG(r.rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';


/*First, you need to join movies on renting to include the renting_price from the movies table for each renting record.
Use as alias' for the tables m and r respectively.*/

SELECT *
FROM renting AS r
LEFT JOIN movies AS m -- Choose the correct join statment
ON r.movie_id = m.movie_id;

/*Calculate the revenue coming from movie rentals, the number of movie rentals and the number of customers who rented a movie.*/


SELECT 
    SUM(m.renting_price), -- Get the revenue from movie rentals
    COUNT(*), -- Count the number of rentals
    COUNT(DISTINCT r.customer_id) -- Count the number of customers
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id;

/*Now, you can report these values for the year 2018. Calculate the revenue in 2018, the number of movie rentals and the number of active customers in 2018. An active customer is a customer who rented at least one movie in 2018.*/


SELECT 
    SUM(m.renting_price), 
    COUNT(*), 
    COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' ;


/*Create a list of actor names and movie titles in which they act. Make sure that each combination of actor and movie appears only once.
Use as an alias for the table actsin the two letters ai.*/

SELECT m.title, -- Create a list of movie titles and actor names
       a.name
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;


/*Use a join to get the movie title and price for each movie rental.*/

SELECT m.title, -- Use a join to get the movie title and price for each movie rental
       m.renting_price
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id;

/*Report the total income for each movie.
Order the result by decreasing income.*/

SELECT rm.title, -- Report the income from movie rentals for each movie 
       SUM(rm.renting_price) AS income_movie
FROM
       (SELECT m.title, 
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
GROUP BY rm.title
ORDER BY income_movie DESC; -- Order the result by decreasing income


/*Create a subsequent SELECT statements in the FROM clause to get all information about actors from the USA.
Give the subsequent SELECT statement the alias a.
Report for actors from the USA the year of birth of the oldest and the year of birth of the youngest actor and actress.*/

SELECT a.gender, -- Report for male and female actors from the USA 
       Min(a.year_of_birth), -- The year of birth of the oldest actor
       Max(a.year_of_birth) -- The year of birth of the youngest actor
FROM
   (SELECT *
   FROM actors
   WHERE nationality = 'USA') AS a
GROUP BY a.gender;


/*Augment the table renting with customer information and information about the movies.
For each join use the first letter of the table name as alias.*/

SELECT *
FROM renting AS r
LEFT JOIN customers AS c  -- Add customer information
ON r.customer_id = c.customer_id
LEFT JOIN movies AS m   -- Add movie information
ON r.movie_id = m.movie_id;


/*Select only those records of customers born in the 70s.*/
SELECT */

FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'; -- Select customers born in the 70s


/*For each movie, report the number of times it was rented, as well as the average rating. Limit your results to customers born in the 1970s.*/


SELECT m.title, 
COUNT(r.customer_id), -- Report number of views per movie
AVG(r.rating) -- Report the average rating per movie
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title;


/*Remove those movies from the table with only one rental.
Order the result table such that movies with highest rating come first.*/

SELECT m.title, 
COUNT(*),
AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING COUNT(*) > 1 -- Remove movies with only one rental
ORDER BY AVG(r.rating); -- Order with highest rating first


/*Augment the table renting with information about customers and actors.*/

SELECT *
FROM renting as r 
LEFT JOIN customers as c  -- Augment table renting with information about customers 
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai  -- Augment the table renting with the table actsin
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a  -- Augment table renting with information about actors
ON ai.actor_id = a.actor_id;

/*Report the number of movie rentals and the average rating for each actor, separately for male and female customers.
Report only actors with more than 5 movie rentals.*/

SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id


GROUP BY a.name, c.gender -- For each actor, separately for male and female customers
HAVING AVG(r.rating) IS NOT NULL 
  AND COUNT(*) > 5 -- Report only actors with more than 5 movie rentals
ORDER BY avg_rating DESC, number_views DESC;

/*Now, report the favorite actors only for customers from Spain.*/


SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
WHERE c.country = 'Spain' -- Select only customers from Spain
GROUP BY a.name, c.gender
HAVING AVG(r.rating) IS NOT NULL 
  AND COUNT(*) > 5 
ORDER BY avg_rating DESC, number_views DESC;


/*Augment the table renting with information about customers and movies.
Use as alias the first latter of the table name.
Select only records about rentals since beginning of 2019.*/


SELECT *
FROM renting AS r -- Augment the table renting with information about customers
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN movies AS m-- Augment the table renting with information about movies
ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2019-01-01'; -- Select only records about rentals since the beginning of 2019


/*Calculate the number of movie rentals.
Calculate the average rating.
Calculate the revenue from movie rentals.
Report these KPIs for each country.*/


SELECT 
    c.country,                      -- For each country report
    COUNT(*) AS number_renting,   -- The number of movie rentals
    AVG(r.rating) AS average_rating,  -- The average rating
    SUM(m.renting_price) AS revenue  -- The revenue from movie rentals
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
GROUP BY c.country;

/*Select all movie IDs which have more than 5 views.*/

SELECT movie_id -- Select movie IDs with more than 5 views
FROM renting
GROUP BY movie_id
HAVING COUNT(movie_id) > 5

/*Select all information about movies with more than 5 views.*/

SELECT *
FROM movies
GROUP BY movie_id
HAVING movie_id IN  -- Select movie IDs from the inner query
    (SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING COUNT(*) > 5)


/*List all customer information for customers who rented more than 10 movies.*/

SELECT *
FROM customers
GROUP BY customer_id
HAVING customer_id IN          -- Select all customers with more than 10 movie rentals
    (SELECT customer_id
    FROM renting
    GROUP BY customer_id
    HAVING COUNT(*) > 10);



/*Calculate the average over all ratings.*/

SELECT AVG( rating) -- Calculate the total average rating
FROM renting


/*Select movie IDs and calculate the average rating of movies with rating above average.*/

SELECT movie_id, -- Select movie IDs and calculate the average rating 
       AVG(rating)
FROM renting
GROUP BY movie_id
HAVING AVG(rating) >           -- Of movies with rating above average
    (SELECT AVG(rating)
    FROM renting);


    /*The advertising team only wants a list of movie titles. Report the movie titles of all movies with average rating higher than the total average.*/



 SELECT title -- Report the movie titles of all movies with average rating higher than the total average
FROM movies
WHERE movie_id IN
    (SELECT movie_id
     FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) > 
        (SELECT AVG(rating)
         FROM renting));


 /*First, count number of movie rentals for customer with customer_id=45. Give the table renting the alias r.*/


 -- Count movie rentals of customer 45
SELECT COUNT(*)
FROM renting AS r
WHERE customer_id=45;

/*Now select all columns from the customer table where the number of movie rentals is smaller than 5.*/

-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5>
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id);


	/*Calculate the minimum rating of customer with ID 7.*/

-- Calculate the minimum rating of customer with ID 7
SELECT MIN(rating)
FROM renting
WHERE customer_id = 7;

/*Select all customers with a minimum rating smaller than 4. Use the first letter of the table as an alias.*/


SELECT *
FROM customers AS c
WHERE 4 > -- Select all customers with a minimum rating smaller than 4 
    (SELECT MIN(rating)
    FROM renting AS r
    WHERE r.customer_id = c.customer_id);


 /*Select all movies with more than 5 ratings. Use the first letter of the table as an alias.

Select all movies with an average rating higher than 8.*/

SELECT *
FROM movies AS m
WHERE 5 < -- Select all movies with more than 5 ratings
    (SELECT COUNT(rating)
    FROM renting AS r
    WHERE m.movie_id = r.movie_id);


    SELECT *
FROM movies AS m
WHERE 8 < -- Select all movies with an average rating higher than 8
    (SELECT AVG(rating)
    FROM renting AS r
    WHERE r.movie_id = m.movie_id);


 /*Select all records of movie rentals from customer with ID 115.*/

 -- Select all records of movie rentals from customer with ID 115
SELECT *
FROM renting
WHERE customer_id = 115;

/*Select all records of movie rentals from the customer with ID 115 and exclude records with null ratings.*/

SELECT *
FROM renting
WHERE rating IS NOT NULL -- Exclude those with null ratings
AND customer_id = 115;

/*Select all records of movie rentals from the customer with ID 1, excluding null ratings.*/

SELECT *
FROM renting
WHERE rating IS NOT NULL -- Exclude those with null ratings
AND customer_id = 1;


/*Select all customers with at least one rating. Use the first letter of the table as an alias.*/


SELECT *
FROM customers AS c-- Select all customers with at least one rating
WHERE EXISTS
    (SELECT *
    FROM renting AS r
    WHERE rating IS NOT NULL 
    AND r.customer_id = c.customer_id);


/*Select the records from the table actsin of all actors who play in a Comedy. Use the first letter of the table as an alias.*/


SELECT *  -- Select the records of all actors who play in a Comedy
FROM actsin AS ai
LEFT JOIN movies AS m
ON ai.movie_id = m.movie_id
WHERE m.genre = 'Comedy';

/*Make a table of the records of actors who play in a Comedy and select only the actor with ID 1.*/

SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
WHERE m.genre = 'Comedy'
AND ai.actor_id = 1; -- Select only the actor with ID 1

/*Create a list of all actors who play in a Comedy. Use the first letter of the table as an alias.*/


SELECT *
FROM actors AS a
WHERE EXISTS
    (SELECT *
     FROM actsin AS ai
     LEFT JOIN movies AS m
     ON m.movie_id = ai.movie_id
     WHERE m.genre = 'Comedy'
     AND ai.actor_id = a.actor_id);


/*Report the nationality and the number of actors for each nationality.*/


SELECT a.nationality, COUNT(*) -- Report the nationality and the number of actors for each nationality
FROM actors AS a
WHERE EXISTS
    (SELECT ai.actor_id
     FROM actsin AS ai
     LEFT JOIN movies AS m
     ON m.movie_id = ai.movie_id
     WHERE m.genre = 'Comedy'
     AND ai.actor_id = a.actor_id)
GROUP BY a.nationality;


/*Report the name, nationality and the year of birth of all actors who are not from the USA.*/

SELECT name,  -- Report the name, nationality and the year of birth
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'; -- Of all actors who are not from the USA


/*Report the name, nationality and the year of birth of all actors who were born after 1990.*/


SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990; -- Born after 1990


/*Select all actors who are not from the USA and all actors who are born after 1990.*/

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;


/*Select all actors who are not from the USA and who are also born after 1990.*/

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;


/*Select the IDs of all dramas.*/

SELECT movie_id  -- Select the IDs of all dramas
FROM movies
WHERE genre = 'Drama';

/*Select the IDs of all movies with average rating higher than 9.*/

SELECT movie_id -- Select the IDs of all movies with average rating higher than 9
FROM renting
GROUP BY movie_id
HAVING AVG(rating)>9;


/*Select the IDs of all dramas with average rating higher than 9.*/


SELECT movie_id
FROM movies
WHERE genre = 'Drama'
INTERSECT  -- Select the IDs of all dramas with average rating higher than 9
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING AVG(rating)>9;


/*Select all movies of in the drama genre with an average rating higher than 9.*/

SELECT *
FROM movies
WHERE movie_id IN -- Select all movies of genre drama with average rating higher than 9
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);


 /*Create a table with the total number of customers, of all female and male customers, of the number of customers for each country and the number of men and women from each country.*/


 SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
       country,
       COUNT(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;


/*List the number of movies for different genres and the year of release on all aggregation levels by using the CUBE operator.*/


SELECT genre,
       year_of_release,
       COUNT(*)
FROM movies
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release;


/*Augment the records of movie rentals with information about movies and customers, in this order. Use the first letter of the table names as alias.*/

-- Augment the records of movie rentals with information about movies and customers
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;


/*Calculate the average rating for each country.*/

-- Calculate the average rating for each country
SELECT 
    c.country,
    AVG(r.rating)
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY country;


/*Calculate the average rating for all aggregation levels of country and genre.*/

SELECT 
    c.country, 
    m.genre, 
    AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE (c.country, m.genre); -- For all aggregation levels of country and genre


/*Generate a table with the total number of customers, the number of customers for each country, and the number of female and male customers for each country.
Order the result by country and gender.*/

-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
       COUNT(*)
FROM customers
GROUP BY ROLLUP(country, gender)
ORDER BY country, gender; -- Order the result by country and gender


/*Augment the renting records with information about movies and customers.*/

-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;

/*Calculate the average ratings and the number of ratings for each country and each genre. Include the columns country and genre in the SELECT clause.*/


SELECT 
    c.country, -- Select country
    m.genre, -- Select genre
    AVG(r.rating), -- Average ratings
    COUNT(*)  -- Count number of movie rentals
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY (c.country, m.genre) -- Aggregate for each country and each genre
ORDER BY c.country, m.genre;


/*Finally, calculate the average ratings and the number of ratings for each country and genre, as well as an aggregation over all genres for each country and the overall average and total number.*/


-- Group by each county and genre with OLAP extension
SELECT 
    c.country, 
    m.genre, 
    AVG(r.rating) AS avg_rating, 
    COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP (c.country, m.genre)
ORDER BY c.country, m.genre;

/*Count the number of actors in the table actors from each country, the number of male and female actors and the total number of actors.*/


SELECT 
    nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    COUNT(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation


/*Select the columns country, gender, and rating and use the correct join to combine the table renting with customer.

Use GROUP BY to calculate the average rating over country and gender. Order the table by country and gender.

Now, use GROUPING SETS to get the same result, i.e. the average rating over country and gender.

Report all information that is included in a pivot table for country and gender in one SQL table.*/


SELECT 
    c.country, -- Select country, gender and rating
    c.gender,
    r.rating
FROM renting AS r
LEFT JOIN customers AS c -- Use the correct join
ON r.customer_id = c.customer_id;


SELECT 
    c.country, 
    c.gender,
    AVG(r.rating) -- Calculate average rating
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY c.country, c.gender -- Order and group by country and gender
ORDER BY c.country, c.gender;



SELECT 
    c.country, 
    c.gender,
    AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY GROUPING SETS ((country, gender)); -- Group by country and gender with GROUPING SETS


SELECT 
    c.country, 
    c.gender,
    AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY GROUPING SETS ((country, gender), (country),(gender),());


/*Augment the records of movie rentals with information about movies. Use the first letter of the table as alias.*/


SELECT *
FROM renting AS r
LEFT JOIN movies AS m -- Augment the table with information about movies
ON r.movie_id = m.movie_id;


/*Select records of movies with at least 4 ratings, starting from 2018-04-01.*/


SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( -- Select records of movies with at least 4 ratings
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING COUNT(rating) >=4)
AND r.date_renting >= '2018-04-01'; -- Select records of movie rentals since 2018-04-01

/*For each genre, calculate the average rating (use the alias avg_rating), the number of ratings (use the alias n_rating), the number of movie rentals (use the alias n_rentals), and the number of distinct movies (use the alias n_movies).*/


SELECT m.genre, -- For each genre, calculate:
       AVG(r.rating) AS avg_rating, -- The average rating and use the alias avg_rating
       COUNT(r.rating) AS n_rating, -- The number of ratings and use the alias n_rating
       COUNT(*) AS n_rentals,     -- The number of movie rentals and use the alias n_rentals
       COUNT(DISTINCT r.movie_id) AS n_movies -- The number of distinct movies and use the alias n_movies
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING COUNT(rating) >= 3)
AND r.date_renting >= '2018-01-01'
GROUP BY m.genre;


/*Order the table by decreasing average rating.*/


SELECT genre,
       AVG(rating) AS avg_rating,
       COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
       COUNT(DISTINCT m.movie_id) AS n_movies 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY AVG(rating) DESC; -- Order the table by decreasing average rating

/*Join the tables.*/

-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN actsin AS ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id;

/*For each combination of the actors' nationality and gender, calculate the average rating, the number of ratings, the number of movie rentals, and the number of actors.*/

SELECT a.nationality,
       a.gender,
       AVG(r.rating) AS avg_rating, -- The average rating
       COUNT(r.rating) AS n_rating, -- The number of ratings
       COUNT(*) AS n_rentals, -- The number of movie rentals
       COUNT(DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-04-01'
GROUP BY GROUPING SETS ((a.nationality,a.gender)); -- Report results for each combination of the actors' nationality and gender


/*Provide results for all aggregation levels represented in a pivot table.*/


SELECT a.nationality,
       a.gender,
       AVG(r.rating) AS avg_rating,
       COUNT(r.rating) AS n_rating,
       COUNT(*) AS n_rentals,
       COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY CUBE (a.nationality,a.gender ); -- Provide results for all aggregation levels represented in a pivot table


