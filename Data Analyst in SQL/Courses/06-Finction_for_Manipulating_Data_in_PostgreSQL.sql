/*
Select all columns from the INFORMATION_SCHEMA.TABLES system database. Limit results that have a public table_schema.

Select all columns from the INFORMATION_SCHEMA.COLUMNS system database. Limit by table_name to actor
*/

 -- Select all columns from the TABLES system database
 SELECT * 
 FROM INFORMATION_SCHEMA.TABLES
 -- Filter by schema
 WHERE table_schema = 'public';


  -- Select all columns from the COLUMNS system database
 SELECT * 
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'actor';

 /*
 Select the column name and data type from the INFORMATION_SCHEMA.COLUMNS system database.
Limit results to only include the customer table.
*/

-- Get the column name and data type
SELECT
 	column_name, 
    data_type
-- From the system database information schema
FROM INFORMATION_SCHEMA.COLUMNS 
-- For the customer table
WHERE table_name = 'customer';

/*
Select the rental date and return date from the rental table.
Add an INTERVAL of 3 days to the rental_date to calculate the expected return date`.
*/

SELECT
 	-- Select the rental and return dates
	rental_date,
	return_date,
 	-- Calculate the expected_return_date
	rental_date + INTERVAL '3 days' AS expected_return_date
FROM rental;

/*
Select the title and special features from the film table and compare the results between the two columns.

Select all films that have a special feature Trailers by filtering on the first index of the special_features ARRAY.

Now let's select all films that have Deleted Scenes in the second index of the special_features ARRAY.
*/

-- Select the title and special features column 
SELECT 
  title, 
  special_features
FROM film;


-- Select the title and special features column 
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[1] = 'Trailers';


-- Select the title and special features column 
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[2] = 'Deleted Scenes';

/*
Match 'Trailers' in any index of the special_features ARRAY regardless of position.
*/

SELECT
  title, 
  special_features 
FROM film 
-- Modify the query to use the ANY function 
WHERE 'Trailers' = ANY(special_features);

/*
Use the contains operator to match the text Deleted Scenes in the special_features column.
*/

SELECT 
  title, 
  special_features 
FROM film 
-- Filter where special_features contains 'Deleted Scenes'
WHERE special_features @> ARRAY['Deleted Scenes'];

/*
Subtract the rental_date from the return_date to calculate the number of days_rented.
Now use the AGE() function to calculate the days_rented.
*/

SELECT f.title, f.rental_duration,
    -- Calculate the number of days rented
    r.return_date - r.rental_date AS days_rented
FROM film AS f
     INNER JOIN inventory AS i ON f.film_id = i.film_id
     INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;


SELECT f.title, f.rental_duration,
    -- Calculate the number of days rented
	AGE(r.return_date, r.rental_date) AS days_rented
FROM film AS f
	INNER JOIN inventory AS i ON f.film_id = i.film_id
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;


/*
Convert rental_duration by multiplying it with a 1 day INTERVAL
Subtract the rental_date from the return_date to calculate the number of days_rented.
Exclude rentals with a NULL value for return_date.
*/

SELECT
	f.title,
 	-- Convert the rental_duration to an interval
    INTERVAL '1' day * f.rental_duration,
 	-- Calculate the days rented as we did previously
    r.return_date - r.rental_date AS days_rented
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
-- Filter the query to exclude outstanding rentals
WHERE r.return_date IS  NOT NULL
ORDER BY f.title;

/*

Convert rental_duration by multiplying it with a 1-day INTERVAL.
Add it to the rental date.
*/

SELECT
    f.title,
	r.rental_date,
    f.rental_duration,
    -- Add the rental duration to the rental date
    INTERVAL '1' day * f.rental_duration + rental_date AS expected_return_date,
    r.return_date
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

/*
Use NOW() to select the current timestamp with timezone.

Select the current date without any time value.

Now, let's use the CAST() function to eliminate the timezone from the current timestamp.

Finally, let's select the current date.
Use CAST() to retrieve the same result from the NOW() function.
*/

-- Select the current timestamp
SELECT NOW();


-- Select the current date
SELECT current_date;

--Select the current timestamp without a timezone
SELECT CAST( NOW() AS timestamp )

SELECT 
	-- Select the current date
	current_date,
    -- CAST the result of the NOW() function to a date
    CAST( NOW() AS date )

/*
Select the current timestamp without timezone and alias it as right_now.
*/
--Select the current timestamp without timezone
SELECT current_timestamp::timestamp AS right_now;

/*
Now select a timestamp five days from now and alias it as five_days_from_now.
*/

SELECT
	CURRENT_TIMESTAMP::timestamp AS right_now,
    INTERVAL '5 days' + CURRENT_TIMESTAMP AS five_days_from_now;

 /*
 Finally, let's use a second-level precision with no fractional digits for both the right_now and five_days_from_now fields.
*/

SELECT
	CURRENT_TIMESTAMP::timestamp AS right_now,
    interval '5 days' + CURRENT_TIMESTAMP AS five_days_from_now;

/*Get the day of the week from the rental_date column.*/

SELECT 
  -- Extract day of week from rental_date
  EXTRACT(dow FROM rental_date) AS dayofweek 
FROM rental 
LIMIT 100;

/*Count the total number of rentals by day of the week.*/

-- Extract day of week from rental_date
SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek, 
  -- Count the number of rentals
  COUNT(*) as rentals 
FROM rental 
GROUP BY 1;

/*
Truncate the rental_date field by year.

Now modify the previous query to truncate the rental_date by month.

Let's see what happens when we truncate by day of the month.

Finally, count the total number of rentals by rental_day and alias it as rentals.
*/

-- Truncate rental_date by year
SELECT DATE_TRUNC('year', rental_date) AS rental_year
FROM rental;

-- Truncate rental_date by month
SELECT DATE_TRUNC('month', rental_date) AS rental_month
FROM rental;

-- Truncate rental_date by day of the month 
SELECT DATE_TRUNC('day' , rental_date) AS rental_day 
FROM rental;

SELECT 
  DATE_TRUNC('day', rental_date) AS rental_day,
  -- Count total number of rentals 
  COUNT(*) AS rentals
FROM rental
GROUP BY 1;

/*Extract the day of the week from the rental_date column using the alias dayofweek.
Use an INTERVAL in the WHERE clause to select records for the 90 day period starting on 5/1/2005.*/

SELECT 
  -- Extract the day of week date part from the rental_date
  EXTRACT(dow FROM rental_date) AS dayofweek,
  AGE(return_date, rental_date) AS rental_days
FROM rental AS r 
WHERE 
  -- Use an INTERVAL for the upper bound of the rental_date 
  rental_date BETWEEN CAST('2005-05-01' AS DATE)
   AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';

/*Finally, use a CASE statement and DATE_TRUNC() to create a new column called past_due which will be TRUE if the rental_days is greater than the rental_duration otherwise, it will be FALSE.*/

SELECT 
  c.first_name || ' ' || c.last_name AS customer_name,
  f.title,
  r.rental_date,
  -- Extract the day of week date part from the rental_date
  EXTRACT(dow FROM r.rental_date) AS dayofweek,
  AGE(r.return_date, r.rental_date) AS rental_days,
  -- Use DATE_TRUNC to get days from the AGE function
  CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > 
  -- Calculate number of d
    f.rental_duration * INTERVAL '1' day 
  THEN TRUE 
  ELSE FALSE END AS past_due 
FROM 
  film AS f 
  INNER JOIN inventory AS i 
  	ON f.film_id = i.film_id 
  INNER JOIN rental AS r 
  	ON i.inventory_id = r.inventory_id 
  INNER JOIN customer AS c 
  	ON c.customer_id = r.customer_id 
WHERE 
  -- Use an INTERVAL for the upper bound of the rental_date 
  r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';

  /*Concatenate the first_name and last_name columns separated by a single space followed by email surrounded by < and >.
Now use the CONCAT() function to do the same operation as the previous step.*/

-- Concatenate the first_name and last_name and email 
SELECT first_name || ' ' || last_name || ' <' || email || '>' AS full_email 
FROM customer


-- Concatenate the first_name and last_name and email
SELECT CONCAT(first_name, ' ', last_name, ' <', email, '>') AS full_email 
FROM customer

/*    
Convert the film category name to uppercase.
Convert the first letter of each word in the film's title to upper case.
Concatenate the converted category name and film title separated by a colon.
Convert the description column to lowercase.
*/

SELECT 
  -- Concatenate the category name to coverted to uppercase
  -- to the film title converted to title case
  UPPER(c.name) || ': ' || INITCAP(f.title) AS film_category, 
  -- Convert the description column to lowercase
  LOWER(f.description) AS description
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

 /*Replace all whitespace with an underscore.*/

 SELECT 
  -- Replace whitespace in the film title with an underscore
  REPLACE(title,' ', '_') AS title
FROM film; 

/*
Select the title and description columns from the film table.
Find the number of characters in the description column with the alias desc_len.*/

SELECT 
  -- Select the title and description columns
  title,
  description,
  -- Determine the length of the description column
  LENGTH(description) AS desc_len
FROM film;

/*Select the first 50 characters of the description column with the alias short_desc*/

SELECT 
  -- Select the first 50 characters of description
  LEFT(description, 50) AS short_desc
FROM 
  film AS f; 

 /*Extract only the street address without the street number from the address column.
Use functions to determine the starting and ending position parameters.*/

SELECT 
  -- Select only the street name from the address table
  SUBSTRING(address FROM POSITION(' ' IN address)+1 FOR CHAR_LENGTH(address))
FROM 
  address;

  /*Extract the characters to the left of the @ of the email column in the customer table and alias it as username.
Now use SUBSTRING to extract the characters after the @ of the email column and alias the new derived field as domain.*/

SELECT
  -- Extract the characters to the left of the '@'
  LEFT(email, POSITION('@' IN email)-1) AS username,
  -- Extract the characters to the right of the '@'
  SUBSTRING(email FROM POSITION('@' IN email)+1 FOR LENGTH(email)) AS domain
FROM customer;

/*Add a single space to the end or right of the first_name column using a padding function.
Use the || operator to concatenate the padded first_name to the last_name column.

*/

-- Concatenate the padded first_name and last_name 
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) || last_name AS full_name
FROM customer;

/*Now add a single space to the left or beginning of the last_name column using a different padding function than the first step.
Use the || operator to concatenate the first_name column to the padded last_name.*/

-- Concatenate the first_name and last_name 
SELECT 
	first_name || LPAD(last_name, LENGTH(last_name)+1) AS full_name
FROM customer; 

/*Add a single space to the right or end of the first_name column.
Add the characters < to the right or end of last_name column.
Finally, add the characters > to the right or end of the email column.*/

-- Concatenate the first_name and last_name 
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) 
    || RPAD(last_name, LENGTH(last_name)+2, ' <') 
    || RPAD(email, LENGTH(email)+1, '>') AS full_email
FROM customer; 

/*Convert the film category name to uppercase and use the CONCAT() concatenate it with the title.
Truncate the description to the first 50 characters and make sure there is no leading or trailing whitespace after truncating.

*/

-- Concatenate the uppercase category name and film title
SELECT 
  CONCAT(UPPER(c.name), ': ', f.title) AS film_category, 
  -- Truncate the description remove trailing whitespace
  TRIM(LEFT(description, 50)) AS film_desc
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

 /*
 Get the first 50 characters of the description column
Determine the position of the last whitespace character of the truncated description column and subtract it from the number 50 as the second parameter in the first function above.

*/

SELECT 
  UPPER(c.name) || ': ' || f.title AS film_category, 
  -- Truncate the description without cutting off a word
  LEFT(description, 50 - 
    -- Subtract the position of the first whitespace character
    POSITION(
      ' ' IN REVERSE(LEFT(description, 50))
    )
  ) 
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;


 /*Select all columns for all records that begin with the word GOLD.

Now select all records that end with the word GOLD.

Finally, select all records that contain the word 'GOLD'.*/

-- Select all columns
SELECT *
FROM film
-- Select only records that begin with the word 'GOLD'
WHERE title LIKE 'GOLD%';

SELECT *
FROM film
-- Select only records that end with the word 'GOLD'
WHERE title LIKE '%GOLD';

SELECT *
FROM film
-- Select only records that contain the word 'GOLD'
WHERE title LIKE '%GOLD%';

/*Select the film description and convert it to a tsvector data type.

*/

-- Select the film description as a tsvector
SELECT to_tsvector(description) 
FROM film;

/*Select the title and description columns from the film table.
Perform a full-text search on the title column for the word elf.

*/

-- Select the title and description
SELECT title, description
FROM film
-- Convert the title to a tsvector and match it against the tsquery 
WHERE to_tsvector(title) @@ to_tsquery('elf');

/*Create a new enumerated data type called compass_position.
Use the four positions of a compass as the values.*/

-- Create an enumerated data type, compass_position
CREATE TYPE dayofweek AS ENUM (
  	-- Use the four cardinal directions
  	'north', 
  	'south',
  	'east', 
  	'west'
);

/*Verify that the new data type has been created by looking in the pg_type system table.*/

-- Create an enumerated data type, compass_position
CREATE TYPE compass_position AS ENUM (
  	-- Use the four cardinal directions
  	'North', 
  	'South',
  	'East', 
  	'West'
);
-- Confirm the new data type is in the pg_type system table
SELECT pg_type
FROM pg_type
WHERE typname='compass_position';

/*Select the column_name, data_type, udt_name.
Filter for the rating column in the film table.*/

-- Select the column name, data type and udt name columns
SELECT column_name, data_type, udt_name
FROM INFORMATION_SCHEMA.COLUMNS 
-- Filter by the rating column in the film table
WHERE table_name ='film' AND column_name='rating';

/*Select all columns from the pg_type table where the type name is equal to mpaa_rating.*/

SELECT *
FROM pg_type 
WHERE typname ='mpaa_rating'

/*Select the title and inventory_id columns from the film and inventory tables in the database.*/

-- Select the film title and inventory ids
SELECT 
    f.title, 
    i.inventory_id
FROM film AS f 
    -- Join the film table to the inventory table
    INNER JOIN inventory AS i ON f.film_id=i.film_id  

/*inventory_id is currently held by a customer and alias the column as held_by_cust*/

-- Select the film title, rental and inventory ids
SELECT 
    f.title, 
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
    inventory_held_by_customer (i.inventory_id) AS held_by_cust 
FROM film as f 
    -- Join the film table to the inventory table
    INNER JOIN inventory AS i ON f.film_id=i.film_id 

 /*Now filter your query to only return records where the inventory_held_by_customer() function returns a non-null value.*/

 SELECT
    f.title, 
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
    inventory_held_by_customer(i.inventory_id) as held_by_cust
FROM film as f 
    INNER JOIN inventory AS i ON f.film_id=i.film_id 
WHERE
    -- Only include results where the held_by_cust is not null
    inventory_held_by_customer(i.inventory_id) is not null


 /*Enable the pg_trgm extension*/

 -- Enable the pg_trgm extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;


/*Now confirm that both fuzzystrmatch and pg_trgm are enabled by selecting all rows from the appropriate system table.*/

-- Select all rows extensions
SELECT *
FROM pg_extension;

/*Select the film title and description.
Calculate the similarity between the title and description.*/

-- Select the title and description columns
SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(title, description)
FROM 
  film

  /*Select the film title and film description.
Calculate the levenshtein distance for the film title with the string JET NEIGHBOR.

*/

-- Select the title and description columns
SELECT  
  title, 
  description, 
  -- Calculate the levenshtein distance
  levenshtein(title, 'JET NEIGHBOR') AS distance
FROM 
  film
ORDER BY 3

/*Select the title and description for all DVDs from the film table.
Perform a full-text search by converting the description to a tsvector and match it to the phrase 'Astounding & Drama' using a tsquery in the WHERE clause.*/


-- Select the title and description columns
SELECT  
  title, 
  description
FROM 
  film
WHERE 
  -- Match "Astounding Drama" in the description
  to_tsvector(description) @@
  to_tsquery('Astounding & Drama');

  /*Add a new column that calculates the similarity of the description with the phrase 'Astounding Drama'.
Sort the results by the new similarity column in descending order.*/

SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(description, 'Astounding Drama')
FROM 
  film 
WHERE 
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama') 
ORDER BY 
  similarity(description, 'Astounding Drama') DESC;

  


