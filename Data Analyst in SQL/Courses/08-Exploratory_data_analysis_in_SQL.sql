/*First, figure out how many rows are in fortune500 by counting them.
Subtract the count of the non-NULL ticker values from the total number of rows; alias the difference as missing.
Repeat for the profits_change column.
Repeat for the industry column.*/

-- Select the count of the number of rows
SELECT COUNT(*)
  FROM fortune500;

  -- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - COUNT(ticker) AS missing
  FROM fortune500

  -- Select the count of profits_change, 
-- subtract from total number of rows, and alias as missing
SELECT count(*) - COUNT(profits_change) AS missing
  FROM fortune500

  -- Select the count of industry, 
-- subtract from total number of rows, and alias as missing
SELECT count(*) - COUNT(industry) AS missing
  FROM fortune500

  /*Look at the contents of the company and fortune500 tables. Find a column that they have in common where the values for each company are the same in both tables.
Join the company and fortune500 tables with an INNER JOIN.
Select only company.name for companies that appear in both tables.*/

SELECT company.name
-- Table(s) to select from
  FROM company
       INNER JOIN fortune500
       ON company.ticker =fortune500.ticker;

  /*First, using the tag_type table, count the number of tags with each type.
Order the results to find the most common tag type.*/

-- Count the number of tags with each type
SELECT type, Count(*) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
 GROUP BY type
 -- Order the results with the most common
 -- tag types listed first
 ORDER BY type DESC;

 /*Join the tag_company, company, and tag_type tables, keeping only mutually occurring records.
Select company.name, tag_type.tag, and tag_type.type for tags with the most common type from the previous step.*/

-- Select the 3 columns desired
SELECT company.name, tag_type.tag, tag_type.type
  FROM company
       -- Join to the tag_company table
       INNER JOIN tag_company 
       ON company.Id = tag_company.company_id
       -- Join to the tag_type table
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';


/*Use coalesce() to select the first non-NULL value from industry, sector, or 'Unknown' as a fallback value.
Alias the result of the call to coalesce() as industry2.
Count the number of rows with each industry2 value.
Find the most common value of industry2.*/

-- Use coalesce
SELECT coalesce(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       count(*) 
  FROM fortune500 
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
 ORDER BY   count DESC
-- Limit results to get just the one value you want
 LIMIT 1;


 /*Select profits_change and profits_change cast as integer from fortune500.
Look at how the values were converted.
Compare the results of casting of dividing the integer value 10 by 3 to the result of dividing the numeric value 10 by 3.
Now cast numbers that appear as text as numeric.
Note: 1e3 is scientific notation.*/

-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change AS integer) AS profits_change_int
  FROM fortune500;


-- Divide 10 by 3
SELECT 10/3,
       -- Cast 10 as numeric and divide by 3
       10::numeric/3;


 SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;


 /*Compute revenue per employee by dividing revenues by employees; use casting to produce a numeric result.
Take the average of revenue per employee with avg(); alias this as avg_rev_employee.
Group by sector.
Order by the average revenue per employee.*/

-- Select average revenue per employee by sector
SELECT sector, 
       AVG(revenues/employees::numeric) AS avg_rev_employee
  FROM fortune500
 GROUP BY sector
 -- Use the column alias to order the results
 ORDER BY avg_rev_employee;

 /*Exclude rows where question_count is 0 to avoid a divide by zero error.
Limit the result to 10 rows.*/

-- Divide unanswered_count by question_count
SELECT unanswered_count/question_count::numeric AS computed_pct, 
       -- What are you comparing the above quantity to?
       unanswered_pct
  FROM stackoverflow
 -- Select rows where question_count is not 0
 WHERE question_count != 0
 LIMIT 10;

 /*Compute the min(), avg(), max(), and stddev() of profits.
Now repeat step 1, but summarize profits by sector.
Order the results by the average profits for each sector.*/

-- Select min, avg, max, and stddev of fortune500 profits
SELECT MIN(profits),
       AVG(profits),
       MAX(profits),
       STDDEV(profits)
  FROM fortune500;


  -- Select sector and summary measures of fortune500 profits
SELECT sector,
       MIN(profits),
       AVG(profits),
       MAX(profits),
       STDDEV(profits),
       SUM(profits)
  FROM fortune500
 -- What to group by?
 GROUP BY sector
 -- Order by the average profits
 ORDER BY AVG;


 /*Start by writing a subquery to compute the max() of question_count per tag; alias the subquery result as maxval.
Then compute the standard deviation of maxval with stddev().
Compute the min(), max(), and avg() of maxval too.*/

-- Compute standard deviation of maximum values
SELECT MIN(maxval),
	   -- min
       MAX(maxval),
       -- max
       AVG(maxval),
       -- avg
       STDDEV(maxval)
  -- Subquery to compute max of question_count by tag
  FROM (SELECT MAX(question_count) AS maxval
          FROM stackoverflow
         -- Compute max by...
         GROUP BY tag) AS max_results; -- alias for subquery

  /*Use trunc() to truncate employees to the 100,000s (5 zeros).
Count the number of observations with each truncated value.
Repeat step 1 for companies with < 100,000 employees (most common).
This time, truncate employees to the 10,000s place.*/

-- Truncate employees
SELECT trunc(employees, -5) AS employee_bin,
       -- Count number of companies with each truncated value
       COUNT(*)
  FROM fortune500
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;


 -- Truncate employees
SELECT trunc(employees, -4) AS employee_bin,
       -- Count number of companies with each truncated value
       Count(*)
  FROM fortune500
 -- Limit to which companies?
 WHERE employees < 100000
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;


 /*Compute the correlation between revenues and profits.
Compute the correlation between revenues and assets.
Compute the correlation between revenues and equity.*/


 -- Correlation between revenues and profit
SELECT corr(revenues, profits) AS rev_profits,
        -- Correlation between revenues and assets
       corr(revenues, assets) AS rev_assets,
       -- Correlation between revenues and equity
       corr(revenues, equity) AS rev_equity 
  FROM fortune500;


  /*Create a temporary table called profit80 containing the sector and 80th percentile of profits for each sector.
Alias the percentile column as pct80.*/


-- To clear table if it already exists;
-- fill in name of temp table
DROP TABLE IF EXISTS profit80;


-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    -- What table are you getting the data from?
    FROM fortune500
   -- What do you need to group by?
   GROUP BY sector;
   
-- See what you created: select all columns and rows 
-- from the table you created
SELECT * 
  FROM profit80;

  /*Using the profit80 table you created in step 1, select companies that have profits greater than pct80.
Select the title, sector, profits from fortune500, as well as the ratio of the company's profits to the 80th percentile profit.*/


-- Code from previous step
DROP TABLE IF EXISTS profit80;


CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;


-- Select columns, aliasing as needed
SELECT title, fortune500.sector, 
       profits, profits/pct80 AS ratio
-- What tables do you need to join?  
  FROM fortune500 
       LEFT JOIN profit80
-- How are the tables joined?
       ON fortune500.sector=profit80.sector
-- What rows do you want to select?
 WHERE profits > pct80;


 /*First, create a temporary table called startdates with each tag and the min() date for the tag in stackoverflow.*/

 -- To clear table if it already exists
DROP TABLE IF EXISTS startdates;


-- Create temp table syntax
CREATE TEMP TABLE startdates AS
-- Compute the minimum date for each what?
SELECT tag,
       min(date) AS mindate
  FROM stackoverflow
 -- What do you need to compute the min date for each tag?
  GROUP BY tag;
 
 -- Look at the table you created
 SELECT * 
   FROM startdates;


   /*Join startdates to stackoverflow twice using different table aliases.
For each tag, select mindate, question_count on the mindate, and question_count on 2018-09-25 (the max date).
Compute the change in question_count over time.*/

-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;


CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;
 
-- Select tag (Remember the table name!) and mindate
SELECT startdates.tag, 
       mindate, 
       -- Select question count on the min and max days
     so_min.question_count AS min_date_question_count,
       so_max.question_count AS max_date_question_count,
       -- Compute the change in question_count (max- min)
       so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow with alias so_min
       INNER JOIN stackoverflow AS so_min
          -- What needs to match between tables?
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again with alias so_max
       INNER JOIN stackoverflow AS so_max
          -- Again, what needs to match between tables?
          ON startdates.tag = so_max.tag
         AND so_max.date = '2018-09-25';


   /*Create a temp table correlations.

Compute the correlation between profits and each of the three variables (i.e. correlate profits with profits, profits with profits_change, etc).
Alias columns by the name of the variable for which the correlation with profits is being computed.*/


DROP TABLE IF EXISTS correlations;


-- Create temp table 
CREATE TEMP TABLE correlations AS
-- Select each correlation
SELECT 'profits'::varchar AS measure,
       -- Compute correlations
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

  /*Insert rows into the correlations table for profits_change and revenues_change.*/

  DROP TABLE IF EXISTS correlations;


CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;


-- Add a row for profits_change
-- Insert into what table?
INSERT INTO correlations
-- Follow the pattern of the select statement above
-- Using profits_change instead of profits
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;


-- Repeat the above, but for revenues_change
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;


  /*Select all rows and columns from the correlations table to view the correlation matrix.

First, you will need to round each correlation to 2 decimal places.
The output of corr() is of type double precision, so you will need to also cast columns to numeric.*/

DROP TABLE IF EXISTS correlations;


CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;


INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;


INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;


-- Select each column, rounding the correlations
SELECT measure, 
       round(profits::numeric, 2) AS profits,
       round(profits_change::numeric, 2) AS profits_change,
       round(revenues_change::numeric, 2) AS revenues_change
  FROM correlations;


  /*How many rows does each priority level have?
How many distinct values of zip appear in at least 100 rows?
How many distinct values of source appear in at least 100 rows?
Select the five most common values of street and the count of each.*/

-- Select the count of each level of priority
SELECT priority, count(*)
  FROM evanston311
 Group by priority;


 -- Find values of zip that appear in at least 100 rows
-- Also get the count of each value
SELECT zip, COUNT(*)
  FROM evanston311
 GROUP BY zip
HAVING COUNT(*) >= 100;


-- Find values of source that appear in at least 100 rows
-- Also get the count of each value
SELECT source, COUNT(*)
  FROM evanston311
 GROUP BY source
HAVING COUNT(*)>=100;


-- Find the 5 most common values of street and the count of each
SELECT street, count(*)
  FROM evanston311
 GROUP BY street
 ORDER BY count(*) DESC
 LIMIT 5;


 /*Trim digits 0-9, #, /, ., and spaces from the beginning and end of street.
Select distinct original street value and the corrected street value.
Order the results by the original street value.

*/


SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;


 /*Concatenate house_num, a space ' ', and street into a single value using the concat().
Use a trim function to remove any spaces from the start of the concatenated value.*/

-- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT trim(concat(house_num,' ',street)) AS address
  FROM evanston311;


  /*Use split_part() to select the first word in street; alias the result as street_name.
Also select the count of each value of street_name.*/

-- Select the first word of the street value
SELECT split_part(street,' ',1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;


 /*Select the first 50 characters of description with '...' concatenated on the end where the length() of the description is greater than 50 characters. Otherwise just select the description as is.

Select only descriptions that begin with the word 'I' and not the letter 'I'.

For example, you would want to select "I like using SQL!", but would not want to select "In this course we use SQL!".

*/


-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN left(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;


 /*Create recode with a standardized column; use split_part() and then rtrim() to remove any remaining whitespace on the result of split_part().*/

 -- Fill in the command below with the name of the temp table
DROP TABLE IF EXISTS recode;


-- Create and name the temporary table
CREATE TEMP TABLE recode AS
-- Write the select query to generate the table 
-- with distinct values of category and standardized values
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    -- What table are you selecting the above values from?
    FROM evanston311;
    
-- Look at a few values before the next step
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';


/*UPDATE standardized values LIKE 'Trash%Cart' to 'Trash Cart'.
UPDATE standardized values of 'Snow Removal/Concerns' and 'Snow/Ice/Hazard Removal' to 'Snow Removal'.*/


-- Code from previous step
DROP TABLE IF EXISTS recode;


CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;


-- Update to group trash cart values
UPDATE recode 
   SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';


-- Update to group snow removal values
UPDATE recode 
   SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
    
-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';


/*UPDATE recode by setting standardized values of 'THIS REQUEST IS INACTIVE…Trash Cart', '(DO NOT USE) Water Bill', 'DO NOT USE Trash', and 'NO LONGER IN USE' to 'UNUSED'.*/


-- Code from previous step
DROP TABLE IF EXISTS recode;


CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;
  
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';


UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';


-- Update to group unused/inactive values
UPDATE recode 
   SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 
               'NO LONGER IN USE');


-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 ORDER BY standardized;


 /*Now, join the evanston311 and recode tables to count the number of requests with each of the standardized values
List the most common standardized values first.*/


-- Code from previous step
DROP TABLE IF EXISTS recode;
CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
  FROM evanston311;
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 'NO LONGER IN USE');


-- Select the recoded categories and the count of each
SELECT standardized, count(*)
-- From the original table and table with recoded values
  FROM evanston311 
       LEFT JOIN recode 
       -- What column do they have in common?
       ON evanston311.category = recode.category
 -- What do you need to group by to count?
 GROUP BY standardized
 -- Display the most common val values first
 ORDER BY count(*) DESC;


 /*Create a temp table indicators from evanston311 with three columns: id, email, and phone.

Use LIKE comparisons to detect the email and phone patterns that are in the description, and cast the result as an integer with CAST().

Your phone indicator should use a combination of underscores _ and dashes - to represent a standard 10-digit phone number format.
Remember to start and end your patterns with % so that you can locate the pattern within other text!*/

-- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the indicators temp table
CREATE TEMP TABLE indicators AS
  -- Select id
  SELECT id, 
         -- Create the email indicator (find @)
         CAST (description LIKE '%@%' AS integer) AS email,
         -- Create the phone indicator
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    -- What table contains the data? 
    FROM evanston311;

-- Inspect the contents of the new temp table
SELECT *
  FROM indicators;


  /*Join the indicators table to evanston311, selecting the proportion of reports including an email or phone grouped by priority.
Include adjustments to account for issues arising from integer division.*/


-- To clear table if it already exists
DROP TABLE IF EXISTS indicators;


-- Create the temp table
CREATE TEMP TABLE indicators AS
  SELECT id, 
         CAST (description LIKE '%@%' AS integer) AS email,
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    FROM evanston311;
  
-- Select the column you'll group by
SELECT priority,
       -- Compute the proportion of rows with each indicator
       sum(email)/count(*)::numeric AS email_prop, 
       sum(phone)/count(*)::numeric AS phone_prop
  -- Tables to select from
  FROM evanston311
       LEFT JOIN indicators
       -- Joining condition
       ON evanston311.id=indicators.id
 -- What are you grouping by?
 GROUP BY priority;


 /*Count the number of Evanston 311 requests created on January 31, 2017 by casting date_created to a date.
Count the number of Evanston 311 requests created on February 29, 2016 by using >= and < operators.
Count the number of requests created on March 13, 2017.
Specify the upper bound by adding 1 to the lower bound.*/


-- Count requests created on January 31, 2017
SELECT count(*) 
  FROM evanston311
 WHERE date(date_created)='2017-01-31';



 -- Count requests created on February 29, 2016
SELECT count(*)
  FROM evanston311 
 WHERE date_created >= '2016-02-29' 
   AND date_created < '2016-03-01';



   -- Count requests created on March 13, 2017
SELECT count(*)
  FROM evanston311
 WHERE date_created >= '2017-03-13'
   AND date_created < '2017-03-13'::date + 1;


 /*
Subtract the minimum date_created from the maximum date_created.
Using now(), find out how old the most recent evanston311 request was created.
Add 100 days to the current timestamp.
Select the current timestamp and the current timestamp plus 5 minutes.*/


-- Subtract the min date_created from the max
SELECT max(date_created)-min(date_created)
  FROM evanston311;


  -- How old is the most recent request?
SELECT now()-max(date_created)
  FROM evanston311;


  -- Add 100 days to the current timestamp
SELECT now() +'100 days'::interval;


-- Select the current timestamp, 
-- and the current timestamp + 5 minutes
SELECT now(), now()+'5 minutes'::interval;



/*Compute the average difference between the completion timestamp and the creation timestamp by category.
Order the results with the largest average time to complete the request first.*/


-- Select the category and the average completion time by category
SELECT category, 
       AVG(date_completed - date_created) AS completion_time
  FROM evanston311
 GROUP BY category
-- Order the results
 Order by completion_time DESC;


 /*How many requests are created in each of the 12 months during 2016-2017?
What is the most common hour of the day for requests to be created?
During what hours are requests usually completed? Count requests completed by hour.
Order the results by hour.*/


-- Extract the month from date_created and count requests
SELECT date_part('month', date_created) AS month, 
      COUNT(*)
  FROM evanston311
 -- Limit the date range
 WHERE date_created >= '2016-01-01'
   AND date_created <= '2018-01-01'
 -- Group by what to get monthly counts?
 GROUP BY month;


 -- Get the hour and count requests
SELECT date_part('hour',date_created) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 -- Order results to select most common
 ORDER BY COUNT DESC
 LIMIT 1;


 -- Count requests completed by hour
SELECT date_part('hour',date_completed) AS hour,
       COUNT(*)
  FROM evanston311
 GROUP BY hour
 ORDER BY hour;


 /*Select the name of the day of the week the request was created (date_created) as day.
Select the mean time between the request completion (date_completed) and request creation as duration.
Group by day (the name of the day of the week) and the integer value for the day of the week (use a function).
Order by the integer value of the day of the week using the same function used in GROUP BY.*/


-- Select name of the day of the week the request was created 
SELECT to_char(date_created, 'day') AS day, 
       -- Select avg time between request creation and completion
       AVG(date_completed - date_created) AS duration
  FROM evanston311 
 -- Group by the name of the day of the week and 
 -- integer value of day of week the request was created
 GROUP BY day, EXTRACT(DOW FROM date_created)
 -- Order by integer value of the day of the week 
 -- the request was created
 ORDER BY EXTRACT(DOW FROM date_created);


 /*Write a subquery to count the number of requests created per day.
Select the month and average count per month from the daily_count subquery.*/


-- Aggregate daily counts by month
SELECT date_trunc('month', day) AS month,
       AVG(count)
  -- Subquery to compute daily counts
  FROM (SELECT date_trunc('day',date_created) AS day,
               count(*) AS count
          FROM evanston311
         GROUP BY day) AS daily_count
 GROUP BY month
 ORDER BY month;


 /*Write a subquery using generate_series() to get all dates between the min() and max() date_created in evanston311.
Write another subquery to select all values of date_created as dates from evanston311.
Both subqueries should produce values of type date (look for the ::).
Select dates (day) from the first subquery that are NOT IN the results of the second subquery. This gives you days that are not in date_created.*/



SELECT day
-- 1) Subquery to generate all dates
-- from min to max date_created
  FROM (SELECT generate_series(min(date_created),
                               max(date_created),
                               '1 day')::date AS day
          -- What table is date_created in?
          FROM evanston311) AS all_dates
-- 4) Select dates (day from above) that are NOT IN the subquery
 WHERE day NOT IN 
       -- 2) Subquery to select all date_created values as dates
       (SELECT date_created::date
          FROM evanston311);


/*Use generate_series() to create bins of 6 month intervals. Recall that the upper bin values are exclusive, so the values need to be one day greater than the last day to be included in the bin.

Notice how in the sample code, the first bin value of the upper bound is July 1st, and not June 30th.
Use the same approach when creating the last bin values of the lower and upper bounds (i.e. for 2018).*/


-- Generate 6 month bins covering 2016-01-01 to 2018-06-30


-- Create lower bounds of bins
SELECT generate_series('2016-01-01',  -- First bin lower value
                       '2018-01-01',  -- Last bin lower value
                       '6 months'::interval) AS lower,
-- Create upper bounds of bins
       generate_series('2016-07-01',  -- First bin upper value
                       '2018-12-30',  -- Last bin upper value
                       '6 months'::interval) AS upper;


/*Count the number of requests created per day. Remember to not count *, or you will risk counting NULL values.

Include days with no requests by joining evanston311 to a daily series from 2016-01-01 to 2018-06-30.

- Note that because we are not generating bins, you can use June 30th as your series end date.*/


-- Count number of requests made per day
SELECT day, COUNT(date_created) AS count
-- Use a daily series from 2016-01-01 to 2018-06-30 
-- to include days with no requests
  FROM (SELECT generate_series('2016-01-01',  -- series start date
                               '2018-06-30',  -- series end date
                               '1 day'::interval)::date AS day) AS daily_series
       LEFT JOIN evanston311
       -- match day from above (which is a date) to date_created
       ON day = date_created::date
 GROUP BY day;


 /*Assign each daily count to a single 6 month bin by joining bins to daily_counts.
Compute the median value per bin using percentile_disc().*/


-- Bins from Step 1
WITH bins AS (
      SELECT generate_series('2016-01-01',
                            '2018-01-01',
                            '6 months'::interval) AS lower,
            generate_series('2016-07-01',
                            '2018-07-01',
                            '6 months'::interval) AS upper),
-- Daily counts from Step 2
     daily_counts AS (
     SELECT day, count(date_created) AS count
       FROM (SELECT generate_series('2016-01-01',
                                    '2018-06-30',
                                    '1 day'::interval)::date AS day) AS daily_series
            LEFT JOIN evanston311
            ON day = date_created::date
      GROUP BY day)
-- Select bin bounds 
SELECT lower, 
       upper, 
       -- Compute median of count for each bin
       percentile_disc(0.5) WITHIN GROUP (ORDER BY count) AS median
  -- Join bins and daily_counts
  FROM bins
       LEFT JOIN daily_counts
       -- Where the day is between the bin bounds
       ON day >= lower
          AND day < upper
 -- Group by bin bounds
 GROUP BY lower,upper
 ORDER BY lower;



 /*Generate a series of dates from 2016-01-01 to 2018-06-30.
Join the series to a subquery to count the number of requests created per day.
Use date_trunc() to get months from date, which has all dates, NOT day.
Use coalesce() to replace NULL count values with 0. Compute the average of this value.*/


-- generate series with all days from 2016-01-01 to 2018-06-30
WITH all_days AS 
     (SELECT generate_series('2016-01-01',
                             '2018-06-30',
                             '1 day'::interval) AS date),
     -- Subquery to compute daily counts
     daily_count AS 
     (SELECT date_trunc('day', date_created) AS day,
             count(*) AS count
        FROM evanston311
       GROUP BY day)
-- Aggregate daily counts by month using date_trunc
SELECT date_trunc('month', date) AS month,
       -- Use coalesce to replace NULL count values with 0
       avg(coalesce(count, 0)) AS average
  FROM all_days
       LEFT JOIN daily_count
       -- Joining condition
       ON all_days.date=daily_count.day
 GROUP BY month
 ORDER BY month; 


 /*Select date_created and the date_created of the previous request using lead() or lag() as appropriate.
Compute the gap between each request and the previous request.
Select the row with the maximum gap.*/


-- Compute the gaps
WITH request_gaps AS (
        SELECT date_created,
               -- lead or lag
               lag(date_created) OVER (ORDER BY date_created) AS previous,
               -- compute gap as date_created minus lead or lag
               date_created - lag(date_created) OVER (ORDER BY date_created) AS gap
          FROM evanston311)
-- Select the row with the maximum gap
SELECT *
  FROM request_gaps
-- Subquery to select maximum gap from request_gaps
 WHERE gap = (SELECT max(gap)
                FROM request_gaps);


 /*Use date_trunc() to examine the distribution of rat request completion times by number of days.
Compute average completion time per category excluding the longest 5% of requests (outliers).
Get corr() between avg. completion time and monthly requests. EXTRACT(epoch FROM interval) returns seconds in interval.
Select the number of requests created and number of requests completed per month.*/



-- Truncate the time to complete requests to the day
SELECT date_trunc('day',date_completed - date_created) AS completion_time,
-- Count requests with each truncated time
       Count(*)
  FROM evanston311
-- Where category is rats
 WHERE category = 'Rodents- Rats'
-- Group and order by the variable of interest
 GROUP BY completion_time
 ORDER BY completion_time;



 SELECT category, 
       -- Compute average completion time per category
       AVG(date_completed - date_created) AS avg_completion_time
  FROM evanston311
-- Where completion time is less than the 95th percentile value
 WHERE date_completed - date_created < 
-- Compute the 95th percentile of completion time in a subquery
         (SELECT percentile_disc(0.95) WITHIN GROUP (ORDER BY date_completed - date_created)
            FROM evanston311)
 GROUP BY category
-- Order the results
 ORDER BY avg_completion_time DESC;



 -- Compute correlation (corr) between 
-- avg_completion time and count from the subquery
SELECT corr(avg_completion, count)
  -- Convert date_created to its month with date_trunc
  FROM (SELECT date_trunc('month', date_created) AS month, 
               -- Compute average completion time in number of seconds           
               AVG(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, 
               -- Count requests per month
               count(*) AS count
          FROM evanston311
         -- Limit to rodents
         WHERE category='Rodents- Rats' 
         -- Group by month, created above
         GROUP BY month) 
         -- Required alias for subquery 
         AS monthly_avgs;



 -- Compute monthly counts of requests created
WITH created AS (
       SELECT date_trunc('month',date_created) AS month,
              count(*) AS created_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month),
-- Compute monthly counts of requests completed
      completed AS (
       SELECT date_trunc('month',date_completed) AS month,
              count(*) AS completed_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month)
-- Join monthly created and completed counts
SELECT created.month, 
       created_count, 
       completed_count
  FROM created
       INNER JOIN completed
       ON created.month=completed.month
 ORDER BY created.month;






 /*