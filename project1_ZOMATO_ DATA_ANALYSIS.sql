#--PROJECT1
# Project name :Zomato data analysis using SQL

-- In this Zomato data analysis project, we aim to explore and 
-- derive insights from a dataset comprising restaurant information, 
-- including details such as location, cuisine, pricing, 
-- and customer reviews. We will examine factors influencing 
-- restaurant popularity, assess the relationship between 
-- price and customer ratings, and investigate the prevalence 
-- of services like online delivery and table booking. 
--  The project seeks to provide valuable insights into the restaurant 
--  industry and enhance decision-making for both customers and 
--  restaurateurs

-- Description of the dataset:

-- RestaurantID: A unique identifier for each restaurant in the dataset.

-- RestaurantName: The name of the restaurant.

-- CountryCode: A code indicating the country where the restaurant 
-- is located.

-- City: The city in which the restaurant is situated.

-- Address: The specific address of the restaurant.

-- Locality: The locality (neighborhood or district) where the restaurant 
-- is located.

-- LocalityVerbose: A more detailed description or name of the locality.

-- Longitude: The geographical longitude coordinate of the restaurant's 
-- location.

-- Latitude: The geographical latitude coordinate of the restaurant's 
-- location.

-- Cuisines: The types of cuisines or food offerings available at the 
-- restaurant. This may include multiple cuisines separated by commas.

-- Currency: The currency used for pricing in the restaurant.

-- Has_Table_booking: A binary indicator (0 or 1) that shows whether 
-- the restaurant offers table booking.

-- Has_Online_delivery: A binary indicator (0 or 1) that shows 
-- whether the restaurant provides online delivery services.

-- Is_delivering_now: A binary indicator (0 or 1) that indicates 
-- whether the restaurant is currently delivering food.

-- Switch_to_order_menu: A field that might suggest whether customers 
-- can switch to an online menu to place orders.

-- Price_range: A rating or category that indicates the price 
-- range of the restaurant's offerings (e.g., low, medium, high).

-- Votes: The number of votes or reviews that the restaurant has received.

-- Average_Cost_for_two: The average cost for two people to dine 
-- at the restaurant, often used as a measure of affordability.

-- Rating: The rating of the restaurant, possibly on a scale 
-- from 0 to 5 or a similar rating system.

-- Datekey_Opening: The date or key representing the restaurant's 
-- opening date.

-- This dataset seems to be valuable for analyzing and understanding 
-- restaurant-related information, including location, cuisine, 
-- pricing, and customer reviews. You can use it to perform 
-- various analyses, such as finding the most popular cuisines, 
-- exploring the relationship between price and rating, 
-- or identifying trends in restaurant services like 
-- online delivery and table booking.

## in my sql can import just csv json files 

# step-1 data colection/import 
create database project1;
use project1;
select * from rest_data;
select * from country_data;


# step-2 data cleaning
# replace _ by /and conver data type
select * from rest_data;

select datekey_opening from rest_data;
set sql_safe_updates=0;
update rest_data 
set datekey_opening= replace(datekey_opening, '_','/');
select datekey_opening from rest_data;

alter table rest_data modify column datekey_opening date;
desc rest_data;

# 2) chaque unique value from catageriocal columns

select distinct countrycode from rest_data;

# data is availavle for 6 countries

select distinct has_table_booking from rest_data;
select distinct has_online_delivery from rest_data;
select distinct is_delivering_now from rest_data;
select distinct switch_to_order_menu from rest_data;


# 3) rename column country name

alter table country_data
change column `country name` country_name text;

# countries name

select distinct countrycode from rest_data;

select * from country_data where countryid in (select distinct countrycode from rest_data);

 -- 'India
 -- 'Canada'
 -- 'New Zealand'
 -- 'Singapore'
 -- 'United Kingdom'
 -- 'United States of America'

# 4) how many restorunt are registerd

select count(*) from rest_data;
# total 804 restorunts are registerd on zomato

select c2.country_name,count(*) as total from 
rest_data c1 inner join country_data c2
on c1.countrycode=c2.countryid
group by c2.country_name;

select c2.country_name,(count(*)/804*100) as total from 
rest_data c1 inner join country_data c2
on c1.countrycode=c2.countryid
group by c2.country_name;


# 8) percentage of restorunts based on "has_online_delivery"

select has_online_delivery,(count(*)/804)*100 from rest_data group by has_online_delivery;
 
 # 94% Resturants has no online delivery option

 # 9)percentage of restorunts based on has_table_booking

select has_table_booking,(count(*)/804)*100 from rest_data group by has_table_booking; 

# 97% Resturants has no table booking  option
# just 3% of Resturants has table booking system

#  10) ass >> data_opening_opening, month...year..quarter

SELECT RestaurantName,
EXTRACT(YEAR FROM Datekey_Opening) AS year,
EXTRACT(MONTH FROM Datekey_Opening) AS month,
EXTRACT(QUARTER FROM Datekey_Opening) AS quarter
FROM rest_data
ORDER BY year DESC;
select * from rest_data;
use project1;

# year wise

SELECT YEAR (Datekey_Opening)
,count(*)
FROM rest_data
GROUP BY YEAR (Datekey_Opening)
ORDER BY 1 ASC;

SELECT monthname (Datekey_Opening) as month
,count(*)
FROM rest_data
GROUP month order by 1 desc;

SELECT quarter (Datekey_Opening)
,count(*)
FROM rest_data
GROUP BY quarter (Datekey_Opening)
ORDER BY 1 ASC;

# maximum rsetuarunts open in 2018

# 11) find cmoct common cuisines in dataset

select cuisines from rest_data;

select cuisines,count(*) from rest_data group by cuisines; 

#

# 12) top 5 restuarents who has more number of votes

 
 select RestaurantName , votes from rest_data order by votes desc limit 5;
 
 select c2.country_name,c1.RestaurantName,c1.votes
 from rest_data c1 inner join country_data c2
on c1.countrycode=c2.countryid
order by c1.votes desc
limit 5;

# 13) find the city with higest average cost for two people

select city, avg(Average_Cost_for_two) from rest_data group by city order by 2 desc;

# 14)india citywise res

select c1.city, count(*) from rest_data c1 inner join country_data c2 
on c1.countrycode=c2.countryid where country_name='india ' group by c1.city;

# data is available  for only new delhi

# task 15) find restaurant that are currently delivering

SELECT RestaurantName,city
FROM rest_data
WHERE Is_delivering_now='yes';

# 16) count of restaurents based on average ratings

select  rating, count(*) from rest_data group by rating;

# most of the rest has one star ratings

select 
case when rating <=2 then "0-2" 
     when rating<=3 then "2-3" 
     when rating<=4 then "3-4" 
     when rating<=5 then "4-5" 
     end rating_range, count(*)
from rest_data 
group by  rating_range
order by rating_range;

# 17) price range

SELECT DISTINCT price_range FROM rest_data;

SELECT price_range,min(Average_Cost_for_two),
max(Average_Cost_for_two)
FROM rest_data
GROUP BY price_range;

select 
case when Price_range =3 then "A" 
     when Price_range =2 then "B" 
     when Price_range =1 then "C" 
     when Price_range =4 then "D" 
     end AS 'status',count(*) 
from rest_data 
group by status 
order by status;

# A..price range 3 ...Expensive
# B..price range 2 ...medium
# C..price range 1 ...below medium
# D..price range 4 ...lowest/cheap

#  18) Find the top-voted restaurants from each city

select city, max(votes) from rest_data group by city;

with cte1 as (select *, rank() 
 over(partition by city  order by votes desc)
 as 'rank1' from rest_data)
 select restaurantname,city,rank1 from cte1 where rank1=1;

# 19) Find the countries where the majority of restaurants 
# offer online delivery and table booking.

SELECT  c2.countryname,count(*)
FROM rest_data c1
INNER JOIN country_data c2
ON c1.CountryCode=c2.countryID
WHERE c1.Has_Online_delivery = 'Yes'
AND c1.Has_Table_booking = 'Yes'
GROUP BY c2.countryname;