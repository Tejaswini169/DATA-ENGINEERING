--creating database;
create database BurgerBash;

--create table runner orders
CREATE TABLE runner_orders(
   order_id     INTEGER  NOT NULL PRIMARY KEY
  ,runner_id    INTEGER  NOT NULL
  ,pickup_time  DATETIME
  ,distance     VARCHAR(7)
  ,duration     VARCHAR(10)
  ,cancellation VARCHAR(23)
);

--insert values into runner orders
INSERT INTO runner_orders VALUES (1,1,'2021-01-01 18:15:34','20km','32 minutes',NULL);
INSERT INTO runner_orders VALUES (2,1,'2021-01-01 19:10:54','20km','27 minutes',NULL);
INSERT INTO runner_orders VALUES (3,1,'2021-01-03 00:12:37','13.4km','20 mins',NULL);
INSERT INTO runner_orders VALUES (4,2,'2021-01-04 13:53:03','23.4','40',NULL);
INSERT INTO runner_orders VALUES (5,3,'2021-01-08 21:10:57','10','15',NULL);
INSERT INTO runner_orders VALUES (6,3,NULL,NULL,NULL,'Restaurant Cancellation');
INSERT INTO runner_orders VALUES (7,2,'2021-01-08 21:30:45','25km','25mins',NULL);
INSERT INTO runner_orders VALUES (8,2,'2021-01-10 00:15:02','23.4 km','15 minute',NULL);
INSERT INTO runner_orders VALUES (9,2,NULL,NULL,NULL,'Customer Cancellation');
INSERT INTO runner_orders VALUES (10,1,'2021-01-11 18:50:20','10km','10minutes',NULL);

--create customer order
CREATE TABLE customer_orders(
   order_id    INTEGER  NOT NULL 
  ,customer_id INTEGER  NOT NULL
  ,burger_id    INTEGER  NOT NULL
  ,exclusions  VARCHAR(4)
  ,extras      VARCHAR(4)
  ,order_time  DATETIME NOT NULL
);

--insert values into customer order
INSERT INTO customer_orders VALUES (1,101,1,NULL,NULL,'2021-01-01 18:05:02');
INSERT INTO customer_orders VALUES (2,101,1,NULL,NULL,'2021-01-01 19:00:52');
INSERT INTO customer_orders VALUES (3,102,1,NULL,NULL,'2021-01-02 23:51:23');
INSERT INTO customer_orders VALUES (3,102,2,NULL,NULL,'2021-01-02 23:51:23');
INSERT INTO customer_orders VALUES (4,103,1,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orders VALUES (4,103,1,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orders VALUES (4,103,2,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orders VALUES (5,104,1,NULL,'1','2021-01-08 21:00:29');
INSERT INTO customer_orders VALUES (6,101,2,NULL,NULL,'2021-01-08 21:03:13');
INSERT INTO customer_orders VALUES (7,105,2,NULL,'1','2021-01-08 21:20:29');
INSERT INTO customer_orders VALUES (8,102,1,NULL,NULL,'2021-01-09 23:54:33');
INSERT INTO customer_orders VALUES (9,103,1,'4','1, 5','2021-01-10 11:22:59');
INSERT INTO customer_orders VALUES (10,104,1,NULL,NULL,'2021-01-11 18:34:49');
INSERT INTO customer_orders VALUES (10,104,1,'2, 6','1, 4','2021-01-11 18:34:49');

--create burger table
CREATE TABLE burger_names(
   burger_id   INTEGER  NOT NULL PRIMARY KEY 
  ,burger_name VARCHAR(10) NOT NULL
);

--insert values into burger table
INSERT INTO burger_names(burger_id,burger_name) VALUES (1,'Meatlovers');
INSERT INTO burger_names(burger_id,burger_name) VALUES (2,'Vegetarian');

--create burger runner
CREATE TABLE burger_runner(
   runner_id   INTEGER  NOT NULL PRIMARY KEY 
  ,registration_date date NOT NULL
);

--insert values into burger runner
INSERT INTO burger_runner VALUES (1,'2021-01-01');
INSERT INTO burger_runner VALUES (2,'2021-01-03');
INSERT INTO burger_runner VALUES (3,'2021-01-08');
INSERT INTO burger_runner VALUES (4,'2021-01-15');

select * from runner_orders;
select * from customer_orders;
select * from burger_names;
select * from burger_runner;

--queries
--1. How many burgers were ordered? 
SELECT COUNT(*) AS total_burgers_ordered
FROM customer_orders;

--2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders;

--3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

--4. How many of each type of burger was delivered?
SELECT runner_id, COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

--5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, burger_name, COUNT(*) AS burger_count
FROM customer_orders
JOIN burger_names ON customer_orders.burger_id = burger_names.burger_id
GROUP BY customer_id, burger_name
ORDER BY customer_id, burger_name;

--6. What was the maximum number of burgers delivered in a single order?
SELECT order_id, COUNT(*) AS burger_count
FROM customer_orders
GROUP BY order_id
ORDER BY burger_count DESC;

--7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?
SELECT 
    customer_orders.customer_id,
    SUM(CASE WHEN (exclusions IS NOT NULL OR extras IS NOT NULL) THEN 1 ELSE 0 END) 
	AS burgers_with_changes,
    SUM(CASE WHEN (exclusions IS NULL AND extras IS NULL) THEN 1 ELSE 0 END) 
	AS burgers_without_changes
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.cancellation IS NULL
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;

--8. What was the total volume of burgers ordered for each hour of the day?
SELECT 
    DATEPART(HOUR, order_time) AS order_hour,
    COUNT(*) AS total_burgers_ordered
FROM customer_orders
GROUP BY DATEPART(HOUR, order_time)
ORDER BY order_hour;

--9. How many runners signed up for each 1 week period?
SELECT 
    DATEPART(YEAR, registration_date) AS signup_year,
    DATEPART(WEEK, registration_date) AS signup_week,
    COUNT(*) AS runners_signed_up
FROM burger_runner
GROUP BY DATEPART(YEAR, registration_date), DATEPART(WEEK, registration_date)
ORDER BY signup_year, signup_week;

--10. What was the average distance travelled for each customer?
SELECT 
    customer_orders.customer_id,
    AVG(CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT)) AS avg_distance_travelled
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.cancellation IS NULL
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id;

-------------------------------Subqueries and Subtotals-----------------------------
--1. Find the customer who ordered the most burgers (GROUP BY, HAVING)
SELECT customer_id, COUNT(*) AS total_burgers_ordered
FROM customer_orders
GROUP BY customer_id
HAVING COUNT(*) = (
    SELECT MAX(burger_count)
    FROM (
        SELECT customer_id, COUNT(*) AS burger_count
        FROM customer_orders
        GROUP BY customer_id
    ) AS subquery
);

--2. Find the total number of cancellations (by customer or restaurant) for each runner (Subqueries)
SELECT runner_id,
       (SELECT COUNT(*) 
        FROM runner_orders 
        WHERE runner_orders.runner_id = burger_runner.runner_id AND cancellation IS NOT NULL) 
		AS total_cancellations
FROM burger_runner;

--3. Find the average distance for each burger type ordered (Meatlovers vs. Vegetarian)
SELECT burger_name,
       AVG(CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT)) AS avg_distance
FROM customer_orders
JOIN burger_names ON customer_orders.burger_id = burger_names.burger_id
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.cancellation IS NULL
GROUP BY burger_name;

--4. List the customers who have ordered the most burgers in a single day.
SELECT customer_id, order_date, MAX(burger_count) AS max_burgers_ordered
FROM (
    SELECT customer_id, CAST(order_time AS DATE) AS order_date, COUNT(*) AS burger_count
    FROM customer_orders
    GROUP BY customer_id, CAST(order_time AS DATE)
) AS subquery
GROUP BY customer_id, order_date;

--5. Find the total number of orders and burgers ordered for each runner
SELECT runner_id,
       (SELECT COUNT(*) FROM runner_orders WHERE runner_orders.runner_id = burger_runner.runner_id) 
	   AS total_orders,
       (SELECT COUNT(*) FROM customer_orders WHERE customer_orders.order_id 
	   IN (SELECT order_id FROM runner_orders WHERE runner_orders.runner_id = burger_runner.runner_id)) 
	   AS total_burgers_ordered
FROM burger_runner;