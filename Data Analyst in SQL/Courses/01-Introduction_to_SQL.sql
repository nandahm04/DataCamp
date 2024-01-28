/*
Use SQL to return a result set of all book titles included in the books table.
Select both the title and author fields from books.
Select all fields from the books table.
*/


-- Return all titles from the books table
SELECT *
FROM books;

-- Select title and author from the books table
SELECT title, author
FROM books;

-- Select all fields from the books table
SELECT *
FROM books;


/*
Write SQL code that returns a result set with just one column listing the unique authors in the books table.
Update the code to return the unique author and genre combinations in the books table.

*/

-- Select unique authors from the books table
SELECT DISTINCT author
FROM books;

-- Select unique authors and genre combinations from the books table
SELECT DISTINCT author,genre
FROM books;


/*
Add a single line of code that saves the results of the written query as a view called library_authors.

Check that the view was created by selecting all columns from library_authors.
*/

-- Save the results of this query as a view called library_authors
CREATE VIEW library_authors AS
SELECT DISTINCT author AS unique_author
FROM books;

-- Your code to create the view:
CREATE VIEW library_authors AS
SELECT DISTINCT author AS unique_author
FROM books;

-- Select all columns from library_authors
SELECT *
FROM library_authors;


/*

Using PostgreSQL, select the genre field from the books table; limit the number of results to 10.

*/

-- Select the first 10 genres from books using PostgreSQL
SELECT genre
FROM books
LIMIT 10;