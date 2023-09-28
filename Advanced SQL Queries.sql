--Display the customers that share thesame address (e.g. husband and wife) 

SELECT c1.customer_id,
c1.first_name, c1.last_name,
c1.address_id, c2.customer_id,
c2.first_name, c2.last_name,
c2.address_id
FROM customer c1
JOIN customer c2 
ON c1.address_id = c2.address_id
AND c1.customer_id <> c2.customer_id;

--Name of customer who made the highest total payments

SELECT c.first_name,
c.last_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY c.customer_id,
c.first_name, c.last_name
ORDER BY total_payment DESC LIMIT 1;
	
--what is the name of the movie(s) that was rented the most

SELECT f.title,
COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i on f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC limit 1;

--which movies have been rented so far

SELECT DISTINCT f.title
FROM film f
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id;

--which movies have not been rented so far

SELECT f.title
FROM film f
WHERE f.film_id 
NOT IN (
  SELECT DISTINCT i.film_id
  FROM inventory i
  JOIN rental r 
ON i.inventory_id = r.inventory_id
);

--which customers have not rented any movies so far

SELECT c.customer_id,
c.first_name, c.last_name
FROM customer c
LEFT JOIN rental r 
ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

--Display each movie and the number of times it got rented

SELECT f.title AS movie,
COUNT(r.rental_id) as rentals
FROM film f
JOIN rental r on film_id = r.inventory_id
GROUP BY f.title
ORDER BY rentals DESC;

--Show the first name and the last name and the number of films each actor acted in

SELECT a.first_name,
a.last_name,
COUNT (f.film_id) as films
FROM actor a
JOIN film_actor f
ON a.actor_id = f.actor_id
GROUP BY a.first_name,
a.last_name
ORDER BY films DESC;

--Display the names of the actors that acted in more than 20 movies

SELECT a.first_name,
a.last_name, 
COUNT (film_id)
AS films
FROM actor a
JOIN film_actor f
ON a.actor_id = f.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT (f.film_id) > 20

--For all the movies rated "PG" show the movie and the number of times it got rented

SELECT f.title AS movie,
COUNT(r.rental_id) AS rentals
FROM film f
JOIN rental  r
ON f.film_id = r.inventory_id
WHERE f.rating = 'PG'
GROUP BY f.title
ORDER BY rentals DESC;

--Display the movies offered for rent in store_id 1 and not offered in store_id 2

SELECT f.title AS movie
FROM film f
LEFT JOIN (
  SELECT film_id
  FROM inventory
  WHERE store_id = 1
) i on f.film_id = i.film_id
WHERE i.film_id 
NOT IN (
  SELECT film_id
  FROM inventory
  WHERE store_id = 2
); 

--Display the movies offered for rent in any of the two stores 1 and 2

SELECT f.title AS movie
FROM film f
JOIN (
   SELECT film_id
   FROM inventory
   WHERE store_id 
   IN (1, 2)
) i 
ON f.film_id = i.film_id;

--Display the movie titles of those movies offered in both stores at the same time

SELECT f.title AS movie
from film f
JOIN inventory i
ON f.film_id = i.film_id
GROUP BY f.title
HAVING COUNT (DISTINCT i.store_id) =2;

--Display the movie title for the most rented movie in the store with store_id 1.

SELECT f.title,
COUNT(r.rental_id)
AS rental_count
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE i.store_id = 1
GROUP BY f.title
ORDER BY rental_count DESC 
LIMIT 1;

--How many movies are not offered for rent in the stores yet.There are two stores only 1 and 2.

SELECT s.store_id,
COUNT(f.film_id) AS
missing_count
FROM store s
CROSS JOIN film f
LEFT JOIN inventory i 
ON s.store_id = i.store_id 
AND f.film_id = i.film_id
WHERE i.inventory_id IS NULL
GROUP BY s.store_id;

--show the number of rented movies under each rating

SELECT f.rating,
COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY f.rating;

--show the profit of each of the stores 1 and 2.

SELECT s.store_id,
SUM(p.amount) AS profit
FROM store s
JOIN staff st 
ON s.store_id = st.store_id
JOIN payment p 
ON st.staff_id = p.staff_id
GROUP BY s.store_id;

