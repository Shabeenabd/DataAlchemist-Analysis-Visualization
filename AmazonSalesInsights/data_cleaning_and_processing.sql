-- creating database
create database amazon;
use amazon;
drop table  if exists amz;

-- creating table
create table amz(
indx int,
order_id varchar(30),
date varchar(20),
status varchar(30),
a varchar(30),
b varchar(30),
c varchar(30),
d varchar(30),
e varchar(30),
category varchar(30),
size varchar(5),
f varchar(30),
g varchar(30),
qty smallint,
h varchar(30),
amount float,
city varchar(30),
state varchar (30),
postal_code int,
i varchar(30),
j varchar(30),
k varchar(30),
l varchar(30),
m varchar(30)
);

-- loading data from csv file 
load data local infile 'C:\\Users\\muham\\Desktop\\Amazon Sale Report.csv'
into table amz 
fields terminated by','
ignore 1 rows;

-- showing the table
select * from amz;

-- total orders state-wise
select state,count(order_id) as count 
from amazon.amz
group by state;

-- state and city
select city ,state
from amazon.amz;

-- cleaning data
-- pdating table
-- setting safe update disable
set SQL_SAFE_UPDATES=0;

-- data cleaning
update amz 
set state ='MAHARASHTRA',
 city='Navi Mumbai'
where state  ='Navi Mumbai"';

-- setting safe update enable
set SQL_SAFE_UPDATES=1;

-- no of orders in 'bangalore'
select count(*) from amz
where state = 'Bangalore"';

-- shpwing all states
select distinct(state)
from amz;

select state,count(order_id ) as count
from amz
group by state
order by count desc;

-- category of products based on number of sales
select category,count(category)
from amz
group by category;

-- sales based on sates
select state,count(state) as count
from amz
group by state
order by count desc;

-- sales based in cities
select city,count(city) as count
from amz
group by city
order by count desc;

-- total revenue
select sum(amount) from amz;

-- revenue grouped by category
select category,count(category),sum(amount)
from amz
group by category;

-- statewise revenue
select state,count(state) as count,sum(amount)
from amz
group by state
order by count desc;

-- order status
select status,count(status)
from amz
group by status;

-- product size data
select size,count(size) as c
from amz
group by size
order by c desc;

-- most sold product with size
select category,size,count(size) as c
from amz
group by category,size
order by category desc ,c desc;

-- date wise data
select date ,count(date) as c from amz
group by date
order by c desc;

-- revenue timeline
select date ,sum(amount) as totalrevenue from amz
group by date
order by totalrevenue asc
limit 1;

-- cleaning data
select state ,count(state) as cancel from amz
where status ='cancelled'
group by state
order by cancel desc;

select status,count(order_id)
from amz
group by status;

-- updating table data
set SQL_SAFE_UPDATES=0;

-- changing status value
update amz 
set status ='Returned'
where status  ='Shipped - Returning to Seller';

-- changing status value
update amz 
set status ='shipped'
where status  ='Shipped - picked up';

-- changing status value
update amz 
set status ='delivered'
where status  ='Shipped - delivered';


set SQL_SAFE_UPDATES=1;

-- checking modified data
select count(order_id) from amz where status='Shipped - Returned to Seller'
