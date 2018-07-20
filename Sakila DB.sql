/*Establish Database Connection to Sakila DB*/

USE sakila;

/* Display the first and last names of all actors from the table actor*/

SELECT 
    first_name, last_name
FROM
    actor;

/* Display the first and last name of each actor 
in a single column in upper case letters. Name the column Actor Name*/

SELECT 
    CONCAT(first_name, ' ', last_name) AS 'ACTOR NAME'
FROM
    actor;

/*Find the ID number, first name, and last name of an actor whose first name = Joe */

SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';

/*Find all actors whose last name contain the letters GEN*/

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

/*Find all actors whose last names contain the letters LI. 
Order the rows by last name and first name, in that order:*/

SELECT 
    last_name, first_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

/*Display the country_id and country columns of the following countries: 
Afghanistan, Bangladesh, and China:*/

SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

/*Add a middle_name column to the table actor. 
Position it between first_name and last_name.*/

ALTER TABLE actor
ADD COLUMN `middle_name` VARCHAR(45) NULL AFTER `first_name`;


/* Change the data type of the middle_name column to blobs*/

ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;	

/*Delete the middle_name column*/

ALTER TABLE actor
DROP COLUMN middle_name;	

/*List the last names of actors, as well as how many actors have that last name*/

SELECT 
    last_name, COUNT(last_name) AS total_count
FROM
    actor
GROUP BY last_name
ORDER BY total_count DESC;

/*Fix the actor name from GROUCHO WILLIAMS to HARPO WILLIAMS */

UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

/*Fix the actor name from HARPO WILLIAMS to GROUCHO WILLIAMS*/

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';

/* Query to locate schema of address table */

 SHOW CREATE TABLE address;
 
/*Use JOIN to display the first and last names, as well as the address, of each staff member*/

SELECT 
    s.first_name, s.last_name, a.address
FROM
    staff AS s
        JOIN
    address AS a ON s.address_id = a.address_id;

/*Use JOIN to display the total amount rung up by each staff member in August of 2005*/

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    SUM(amount) AS total_amount
FROM
    staff AS s
        JOIN
    payment AS p ON s.staff_id = p.staff_id
WHERE
    payment_date LIKE '2005-08%'
GROUP BY staff_name;

/*List each film and the number of actors who are listed for that film*/

SELECT 
    title, COUNT(actor_id) AS 'number of actors'
FROM
    film
        JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY title
ORDER BY 2 DESC;

/* How many copies of the film Hunchback Impossible exist in the inventory system?*/

SELECT 
    COUNT(*) AS copies
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');

/*List the total paid by each customer. List the customers alphabetically by last name*/

SELECT 
    first_name, last_name, SUM(amount) AS 'Total Amount Paid'
FROM
    payment
        JOIN
    customer ON payment.customer_id = customer.customer_id
GROUP BY first_name , last_name
ORDER BY last_name;

/*Display the titles of movies starting with the letters K and Q whose language is English*/

SELECT 
    title
FROM
    film
WHERE
    (title LIKE 'K%' OR title LIKE 'Q%')
        AND language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English');


/*Display all actors who appear in the film Alone Trip*/

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));

/* Display names and email addresses of all Canadian customers*/

SELECT 
    first_name, last_name, email
FROM
    customer
        JOIN
    customer_list ON customer.customer_id = customer_list.ID
WHERE
    customer_list.country = 'Canada';

/* Identify all movies categorized as family films*/

SELECT 
    title
FROM
    nicer_but_slower_film_list
WHERE
    category = 'Family';

/*Display the most frequently rented movies in descending order*/
 
SELECT 
    f.title, COUNT(r.inventory_id) AS 'Times Rented'
FROM
    rental AS r
        JOIN
    inventory AS i ON r.inventory_id = i.inventory_id
        JOIN
    film AS f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY 2 DESC;

/* Display how much business, in dollars, each store brought in */

SELECT 
    store_id, SUM(gross) AS 'TOTAL Sales'
FROM
    total_sales
GROUP BY store_id;

/* Display for each store its store ID, city, and country */


SELECT 
    s.store_id, c.city, co.country
FROM
    store s
        INNER JOIN
    address a ON s.address_id = a.address_id
        INNER JOIN
    city c ON a.city_id = c.city_id
        INNER JOIN
    country co ON co.country_id = c.country_id;

/* List the top five genres in gross revenue in descending order */

SELECT 
    name AS 'Film Genre', SUM(payment.amount) AS 'Gross Revenue'
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    inventory ON film_category.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        JOIN
    payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

/* Create View Top five genres by gross revenue */

CREATE VIEW Top_5_Genres_gross_revenues AS 

SELECT 
    name AS FilmGenre, SUM(payment.amount) AS GrossRevenue
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    inventory ON film_category.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        JOIN
    payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

/* Display the view created above - Top_5_Genres_gross_revenues */

SELECT 
    *
FROM
    Top_5_Genres_gross_revenues;

/* Drop the view created above - Top_5_Genres_gross_revenues */

DROP VIEW IF EXISTS Top_5_Genres_gross_revenues;


