#Lab | SQL Subqueries
use sakila;

#1. How many copies of the film Hunchback Impossible exist in the inventory system?
select inventory_id, film_id from inventory
where film_id in (
	select film_id from film
    where title='Hunchback Impossible');
    
select count(inventory_id), film_id from inventory
where film_id in (
	select film_id from film
    where title='Hunchback Impossible')
group by film_id;

#2. List all films whose length is longer than the average of all the films.
select avg(length) from film; #115
Select* from film
where length > (select avg(length) from film)
order by length asc;

#3.Use subqueries to display all actors who appear in the film Alone Trip.
select film_id from film where title='Alone Trip';
select film_id, actor_id from film_actor
where film_id in (select film_id from film where title='Alone Trip');

#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
select title from film
where film_id in (
	select film_id from film_category
		where category_id in (
		select category_id from category where name="family"));
        
#5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
#Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
#that will help you get the relevant information.
select first_name, last_name, email from customer
where address_id in (
select address_id from address
where city_id in (
	select city_id from city
	where country_id in (
		select country_id from country
        where country = "Canada")));
        
select c.first_name, c.last_name, c.email, co.country from customer as c
join address as a
on c.address_id=a.address_id
join city as ci
on a.city_id=ci.city_id
join country as co
on ci.country_id=co.country_id
where co.country="Canada";

#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.;

#validation 42 films
select count(actor_id) as n_films from film_actor
group by actor_id
order by n_films desc
limit 1;

select title from film
where film_id in (
	select film_id from film_actor
    where actor_id in (SELECT actor_id from(
			select actor_id, count(film_id) AS total from film_actor
			GROUP BY actor_id
            Order by total desc
            LIMIT 1) as sub1 ));

#inner inner query
SELECT actor_id from(
			select actor_id, count(film_id) AS total from film_actor
			GROUP BY actor_id
            Order by total desc
            LIMIT 1) as sub1;
            
#7.Films rented by most profitable customer. 
#You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
use sakila;
select*from customer;
select*from payment;

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            inventory
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    rental
                WHERE
                    rental_id IN (SELECT 
                            rental_id
                        FROM
                            payment
                        WHERE
                            customer_id = (SELECT 
                                    customer_id
                                FROM
                                    payment
                                GROUP BY customer_id
                                ORDER BY SUM(amount) DESC
                                LIMIT 1))));

#8.Customers who spent more than the average payments.
#inner inner query
SELECT customer_id, sum(amount) as sum_amount FROM payment
			GROUP BY customer_id
			ORDER BY SUM(amount) DESC;
            
#inner query 
select avg(sum_amount) from 
			(SELECT customer_id, sum(amount) as sum_amount FROM payment
			GROUP BY customer_id
			ORDER BY SUM(amount) DESC);#112.54

SELECT customer_id, sum(amount) as total_amount FROM payment
GROUP BY customer_id
Having total_amount>(select avg(sum_amount) from 
			(SELECT customer_id, sum(amount) as sum_amount FROM payment
			GROUP BY customer_id
			ORDER BY SUM(amount) DESC) as sub1)
order by total_amount;

#LAB 2
#List each pair of actors that have worked together.


#For each film, list actor that has acted in more films.


