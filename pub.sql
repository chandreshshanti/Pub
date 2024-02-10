/*
CREATE TABLE pubs (
pub_id INT PRIMARY KEY,
pub_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50)
);
--------------------
-- Create the 'beverages' table
CREATE TABLE beverages (
beverage_id INT PRIMARY KEY,
beverage_name VARCHAR(50),
category VARCHAR(50),
alcohol_content FLOAT,
price_per_unit DECIMAL(8, 2)
);
--------------------
-- Create the 'sales' table
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
pub_id INT,
beverage_id INT,
quantity INT,
transaction_date DATE,
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id),
FOREIGN KEY (beverage_id) REFERENCES beverages(beverage_id)
);
--------------------
-- Create the 'ratings' table 
CREATE TABLE ratings ( rating_id INT PRIMARY KEY, pub_id INT, 
					  customer_name VARCHAR(50), rating FLOAT, 
		review TEXT, FOREIGN KEY (pub_id) REFERENCES pubs(pub_id) );
--------------------
-- Insert sample data into the 'pubs' table
INSERT INTO pubs (pub_id, pub_name, city, state, country)
VALUES
(1, 'The Red Lion', 'London', 'England', 'United Kingdom'),
(2, 'The Dubliner', 'Dublin', 'Dublin', 'Ireland'),
(3, 'The Cheers Bar', 'Boston', 'Massachusetts', 'United States'),
(4, 'La Cerveceria', 'Barcelona', 'Catalonia', 'Spain');
--------------------
-- Insert sample data into the 'beverages' table
INSERT INTO beverages (beverage_id, beverage_name, category, alcohol_content,
					   price_per_unit)
VALUES
(1, 'Guinness', 'Beer', 4.2, 5.99),
(2, 'Jameson', 'Whiskey', 40.0, 29.99),
(3, 'Mojito', 'Cocktail', 12.0, 8.99),
(4, 'Chardonnay', 'Wine', 13.5, 12.99),
(5, 'IPA', 'Beer', 6.8, 4.99),
(6, 'Tequila', 'Spirit', 38.0, 24.99);
--------------------
INSERT INTO sales (sale_id, pub_id, beverage_id, quantity, transaction_date)
VALUES
(1, 1, 1, 10, '2023-05-01'),
(2, 1, 2, 5, '2023-05-01'),
(3, 2, 1, 8, '2023-05-01'),
(4, 3, 3, 12, '2023-05-02'),
(5, 4, 4, 3, '2023-05-02'),
(6, 4, 6, 6, '2023-05-03'),
(7, 2, 3, 6, '2023-05-03'),
(8, 3, 1, 15, '2023-05-03'),
(9, 3, 4, 7, '2023-05-03'),
(10, 4, 1, 10, '2023-05-04'),
(11, 1, 3, 5, '2023-05-06'),
(12, 2, 2, 3, '2023-05-09'),
(13, 2, 5, 9, '2023-05-09'),
(14, 3, 6, 4, '2023-05-09'),
(15, 4, 3, 7, '2023-05-09'),
(16, 4, 4, 2, '2023-05-09'),
(17, 1, 4, 6, '2023-05-11'),
(18, 1, 6, 8, '2023-05-11'),
(19, 2, 1, 12, '2023-05-12'),
(20, 3, 5, 5, '2023-05-13');
--------------------
-- Insert sample data into the 'ratings' table
INSERT INTO ratings (rating_id, pub_id, customer_name, rating, review)
VALUES
(1, 1, 'John Smith', 4.5, 'Great pub with a wide selection of beers.'),
(2, 1, 'Emma Johnson', 4.8, 'Excellent service and cozy atmosphere.'),
(3, 2, 'Michael Brown', 4.2, 'Authentic atmosphere and great beers.'),
(4, 3, 'Sophia Davis', 4.6, 'The cocktails were amazing! Will definitely come back.'),
(5, 4, 'Oliver Wilson', 4.9, 'The wine selection here is outstanding.'),
(6, 4, 'Isabella Moore', 4.3, 'Had a great time trying different spirits.'),
(7, 1, 'Sophia Davis', 4.7, 'Loved the pub food! Great ambiance.'),
(8, 2, 'Ethan Johnson', 4.5, 'A good place to hang out with friends.'),
(9, 2, 'Olivia Taylor', 4.1, 'The whiskey tasting experience was fantastic.'),
(10, 3, 'William Miller', 4.4, 'Friendly staff and live music on weekends.');
--------------------
*/

-- Q1. How many pubs are located in each country?

select 
country,
count(*) as number_of_pubs
from pubs
group by country;

-- Q2. What is the total sales amount for each pub, including the beverage 
-- price and quantity sold?

select 
pub_id,
pub_name,
sum(round(price_per_unit * quantity,1) )as sales
FROM beverages b
join sales s 
using(beverage_id)
join pubs p
using(pub_id)
group by pub_id
order by sales desc;

-- Q3. Which pub has the highest average rating?

select 
pub_id,pub_name,
round(avg(rating),2) as avg_rating
from ratings
join pubs 
using(pub_id)
group by pub_id
order by avg_rating desc;

-- Q4. What are the top 5 beverages by sales quantity across all pubs?

select 
beverage_id,
category,
beverage_name,
sum( quantity)  as total_purchased_quantity
from beverages
join sales
using (beverage_id)
group by beverage_id,
beverage_name
order by total_purchased_quantity desc
limit 5 ;

-- Q5. How many sales transactions occurred on each date?

select count(sale_id) as sales_transaction,
transaction_date
from sales
group by transaction_date;

-- Q6. Find the name of someone that had cocktails and which pub they had it in.
select distinct customer_name,
pub_name,
beverage_name,
category
from beverages
join sales
using(beverage_id)
join pubs
using(pub_id)
join ratings
using(pub_id)
where category ='Cocktail';

-- Q7. What is the average price per unit for each category of beverages,
-- excluding the category 'Spirit'? 

select 
category,
avg(price_per_unit )
from beverages
join sales
using(beverage_id)
join pubs
using(pub_id)
join ratings
using(pub_id)
where category != 'spirit'
group by category;

-- Q8. Which pubs have a rating higher than the average rating of all pubs?

select pub_name,
rating
from pubs
join ratings
using(pub_id)
where rating > 
(select avg(rating)
from ratings);

-- Q9. What is the running total of sales amount for each pub, ordered by the 
-- transaction date?

select pub_name,
sum(price_per_unit*quantity) as sales,
transaction_date
from sales
join pubs
using(pub_id)
join beverages
using(beverage_id)
group by pub_name,transaction_date
order by transaction_date;

