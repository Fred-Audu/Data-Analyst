--POSTGRESQL June project

--Starting with the SELECT statement

--SELECT FROM STATEMENT
--we use it to select statement to fetch all the columns, multiple columns or a single column from a table

--ALL COLUMNS
--we use '*' after the SELECT statement to fetch all the columns in a table

--let us explore the Actor table
SELECT *
FROM actor;

SELECT *
FROM film;

SELECT *
FROM payment;

--MULTIPLE COLUMNS
-- specify the column names after the select statement

-- for example
SELECT customer_id, payment_id, amount
FROM payment;

SELECT first_name, last_name
FROM actor;

--Challenge 2
-- use a select statement to fetch first and last name of every customer and their email address.
SELECT first_name, last_name, email
FROM customer;

--SINGLE COLUMN
--Just specify the column name after the select statement

-- for example

SELECT title
FROM film;

SELECT actor_id
FROM actor;

--REMOVING DUPLICATE
--To remove duplicate, we use the 'DISTINCT' keyword after the SELECT  statement

--For example;

SELECT *
FROM film;

SELECT rating
FROM film;

SELECT DISTINCT rating
FROM film;

-- Challenge 3
-- what are the release years of movies in the film table

SELECT DISTINCT release_year
FROM film;

--FILTERING RECORDS
--We use the 'WHERE' keyword to filter records
-- we filter with : OPERATORS -- (>, <, =, !=, AND, OR)

-- for example
-- fetch all the info of customers whose forst nameis 'Jamie'

SELECT *
FROM customer;

SELECT *
FROM customer
WHERE first_name = 'Jamie';

-- fetch all the information of customers whose first name is 'Jamie' AND/OR last name is 'Rice'

SELECT *
FROM customer
WHERE first_name = 'Jamie' AND last_name = 'Rice';

SELECT *
FROM customer
WHERE first_name = 'Jamie' OR last_name = 'Rice';

--fetch customers whose paid rental amount us greater than 10

SELECT *
FROM payment;

SELECT customer_id, amount
FROM payment
WHERE amount > 10;

--Challenge 4
--Select the phone column from the the address and use the where clause to condition ('259 Ipoh Drive')

SELECT *
FROM address;

SELECT phone
FROM address
WHERE address = '259 Ipoh Drive';

-- WORKING WITH PREDICATES
--BETWEEN, NOT BETWEEN, IN
--They are used to filter range or values. It is used to replace >=, AND, <=

--For example
--We want the customer_id and amount paid between $8 and $10

SELECT customer_id, amount
FROM payment
WHERE amount BETWEEN 8 AND 10;

--NOT BETWEEN is a negation of between

SELECT customer_id, amount
FROM payment
WHERE amount NOT BETWEEN 8 AND 10;

--IN: it is used to replace multiple = SIGN

--for example;

-- Get all info of customers with id 361, 362 and 363

SELECT *
FROM customer
WHERE customer_id IN (361, 362, 363)

--IF you do not want to use in you would have to use multiple = sign with OR so IN is easier

SELECT *
FROM customer
WHERE customer_id = 361 OR customer_id = 362 OR customer_id = 363 

-- NOT In is a negation of IN

SELECT *
FROM customer
WHERE customer_id NOT IN (361, 362, 363)

-- LIKE : it is used for pattern filtering of records
--it works with two symbols: % ===> wildcard(it means it can be many characters as possible),_ ===>underscore(it means one character at a time)

--for example;
--we want to fetch info of customer with first name starting with 'Jen'

SELECT *
FROM customer
WHERE first_name LIKE 'Jen%';

-- get the names of customers whose last name ends with 'is'

SELECT *
FROM customer
WHERE last_name LIKE '%is';

-- NOTE : Like is case sensitive, to remove the case sensitivity we use this syntax ILIKE

SELECT *
FROM customer
WHERE first_name ILIKE 'JEn%';

--UNDERSCORE(_)
--it is used to match any single character

--for example;
-- find all the records where the first name starts with 'Joh' and ends with any single character

SELECT *
FROM customer
WHERE first_name ILIKE 'Joh_'

SELECT *
FROM film;

--fetch all the films whose title start with 'F' and is followed by any two characters.

SELECT *
FROM film
WHERE title ILIKE 'F__';

--SORTING RECORDS
--ORDER BY ===> IT IS USED TO SORT/ARRANGE RECORDS
--We can sort by ascending : ASCENDING ==>loweste to highest, A - Z, 0 - 10 and DESCENDING ==> Highest to lowest, Z - A, 10 - 0

-- ASC ===> used to sort in ascending order while DESC ===. used to sort in descending order

--for example;

SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC;

SELECT first_name, last_name
FROM customer
ORDER BY first_name DESC;

--LIMITING RECORDS
--LIMIT ===> used to limit record

SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC
LIMIT 5;

SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC
LIMIT 100;

--Challenge
--Get the customer id numbers for the top 10 highest amount

SELECT *
FROM payment;

SELECT customer_id, amount
FROM payment
ORDER BY amount DESC
LIMIT 10;

--ALIASES : these are used to rename a column or a table
--it uses the 'AS' keyword

SELECT first_name, last_name AS surname
FROM customer;

--AGGREGATE
-- are used to perform simple statistical operations. They operate on a column at a time
--they change column name to themselves
--the column to be abbreviated should be within a bracket()
-- They are used after the SELECT statement
--these aggregates are SUM, MAX, MIN,COUNT,AVG

SELECT amount
FROM payment

--MIN ; this returns the minimum value in a column

SELECT MIN(amount) AS min_amount
FROM payment;

--MAX; this returns the maximum value in a column

SELECT MAX(amount) AS max_amount
FROM payment;

--AVG: this returns the average/mean of values in a column

SELECT AVG(amount) AS avg_amount
FROM payment;

--SUM: this sums up all the values in a column

SELECT SUM(amount) AS total_amount
FROM payment;

--COUNT : this returns the frequency of values in a column

SELECT COUNT(amount) AS count_amount
FROM payment;


--NOTE :count(column name) does not countnull values
-- to count null values, we use COUNT(*)

--GROUPING RECORDS
--we use GROUP BY function to group records, it works well with aggregate functions.

--for example:
-- what is the	total amount spent by each customer

SELECT customer_id, SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id;

--how many transactions were performed by each customer

SELECT customer_id, COUNT(amount) AS count_trans
FROM payment
GROUP BY customer_id;

--Challenge 6
--find the total amount of films we have for each rating

SELECT rating, count(film_id) AS count_film
FROM film
GROUP BY rating;

--FILTERING GROUP RECORDS
--HAVING ===> it is used to filetr grouped records, it is very similar to WHERE 	clause.
--it can do everything the WHERE clause does, and you can use it with operators and predicates

--DIFFERENCE BETWEEN HAVING AND WHERE CLAUSE
--HAVING is used to filter grouped records while WHERE is used to filter ungrouped records

--FOR EXAMPLE
--How much has the customers who spent above $200 spent exactly?

SELECT customer_id, SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 200;

--JOINS
--Joins are used to merge two or more tables together
--The tables are joined based on the Primary-foreign key relationship.

--Types of Join
--INNER, LEFT, RIGHT AND FULL

--STEPS FOR JOINING TABLES
--1. Identify the tables to join
--2. Take note of the relationship keys.
--3. Take note of the columns needed and table each column should belong.
--4. Put all the columns in a single SELECT statement.
--5. Add the first table after the FROM statement.
--6. State the joint type.
--7. Introduce the joining condition ===> ON, based on the relationoship

--To prevent ambiguous columns;
--we ALIAS our table names
--we use table.columnname syntax on the ambiguous columns, this specify the tables were the columns are present.

--INNER: This gives what is common to both tables.

-- for example
--we want to know the names of the customers that patronize us.

--tables to join ===> customer, payment
--columns from the customer: customer_id, first name, last_name
--columns from payment: customer_id, payment_id, amount

--Relationship Key ===> customer_id
 
SELECT C.customer_id, first_name, last_name, P.customer_id, payment_id, amount
FROM customer AS C
INNER JOIN payment AS P
ON C.customer_id =  P.customer_id

--LEFT JOIN
--this preserves the record on the columns of the table in the left side
--and only the matching records of the right side is shown
--the unmatching rows would be represented by the NULL values

-- for example
-- Get the names of films and confirm if they are in the inventory table or not

--Tables ===> film, inventory

--columns in film table : film_id, title
-- columns in inventory table : film_id, inventory_id

--Relationship key : film_id

SELECT F.film_id, title, I.film_id, inventory_id
FROM film AS F
LEFT JOIN inventory AS I
ON F.film_id = I.film_id
 
--DATA DEFINITION LANGUAGES
--These are used to define database objects
--OBJECST ===> Database, Schema, Tables

--CREATE
--this is used to create an object (database or table)

-- To create a database

CREATE DATABASE PostGreSQL_Class_2023;

--To create TABLES

--steps to create TABLES
--1. we use the syntax ===> CREATE TABLE NAME()
--2. we add the column names with the brackets
--3. we add the datatypes to each column
--4. we specify the relationship(PRIMARY or FOREIGN)
--5. we add constraint(unique, not null, autoincrement)

--PRIMARY KEY ===> UNIQUE and NOT NULL

--creating a table

CREATE TABLE July_cohort_2023();

SELECT *
FROM July_cohort_2023;

ALTER TABLE July_cohort_2023
ADD COLUMN student_id INT PRIMARY KEY,
ADD COLUMN student_name VARCHAR(25) NOT NULL,
ADD COLUMN gender CHAR(1) NOT NULL,
ADD COLUMN occupation VARCHAR(25) NOT NULL, 
ADD COLUMN location VARCHAR(25) NOT NULL, 
ADD COLUMN email_address VARCHAR(50) NOT NULL,
ADD COLUMN  phone_number INT;

CREATE TABLE July_cohort_2023(student_id INT PRIMARY KEY,
							  student_name VARCHAR(25) NOT NULL, 
							  gender CHAR(1) NOT NULL, 
							  occupation VARCHAR(25) NOT NULL, 
							  location VARCHAR(25) NOT NULL, 
							  email_address VARCHAR(50) NOT NULL,
							  phone_number INT);
							  
SELECT *
FROM july_cohort_2023

--INSERTING RECORDS INTO THE TABLE

-- THE syntax is INSERT INTO

INSERT INTO table_name (column1, column1, ...)
values (value1, value2, ...), ...

-- Inserting more records into the table: july_cohort_2023

INSERT INTO july_cohort_2023 (student_id, student_name, gender, occupation, location, email_address)
VALUES (3, 'Michael Blake', 'M', 'student', 'Abuja', 'michaelblake@gmail.com'),
(4, 'Pat Jordan', 'F', 'student', 'Ondo', 'patjordan@gmail.com'),
(2, 'IkeGodson', 'M', 'student', 'Lagos', 'ikegodson@gmail.com'),
(1, 'Adesola Tobi', 'F', 'student', 'Ogun', 'adesolatobi@gmail.com');

SELECT *
FROM july_cohort_2023

--UPDATE RECORDS
--we use UPDATE syntax to modify data in a table

UPDATE july_cohort_2023
SET column1 = value1,
column2 = value2,
column3 = value3,.....
WHERE condition;

UPDATE july_cohort_2023 
SET student_name = 'Ike Godson'
WHERE student_name = 'IkeGodson';

--if i want to see only the row i updated
SELECT *
FROM july_cohort_2023 
WHERE student_id = 2;

SELECT *
FROM july_cohort_2023 

UPDATE july_cohort_2023 
SET student_name = 'Ade Tobi'
WHERE student_id = 1;

--Updating with phone numbers
UPDATE july_cohort_2023 
SET phone_number = 0803574294
WHERE student_id = 1;

-- TO RETURN ONLY THE ROWS THAT HAVE BEEN UPDATED
UPDATE july_cohort_2023 
SET phone_number = 0803574294
WHERE student_id = 1
RETURNING *;

--DELETING RECORDS FROM TABLE
--we will use the DELETE STATEMENT which helps to delete one or more rows from the table

DELETE FROM table_name
WHERE condition;

DELETE FROM july_cohort_2023 
WHERE student_id = 4;

SELECT *
FROM july_cohort_2023;

--IF YOU WANT TO DROP/DELETE A TABLE
--use the DROP statement

DROP TABLE ==> this is the syntax
DROP TABLE table_name

DROP TABLE july_cohort_2023;
