TABLEAU LINK
------------
 https://public.tableau.com/app/profile/shabeen.abdul.varis/viz/ZOMATO-SWIGGY_BUSINESS_ANALYSIS/Dashboard1

--------------------------------------
SQL CODE
 ------
use amazon;

drop table if exists swiggy;

create table swiggy(

id int,

Area varchar(30),

City varchar(30),

Restaurant varchar(30),

Price integer,

Avg_ratings float,

Total_ratings int,

Deliverytime varchar(10)


);

load data local infile 'C:\\Users\\Desktop\\swigggy.csv'

into table swg

fields terminated by','

ignore 1 rows  ;



select * from swiggy;



select city,count(city) as c

from swiggy

group by city

order by c desc;




select city,avg(deliverytime) as avgtime

from swiggy

group by city;



select avg(deliverytime) from swiggy where city='surat';



select  city,avg_ratings  from swiggy

group by city,avg_ratings 

order by city,avg_ratings desc;




select city ,avg(avg_ratings) as avgr

from swiggy

group by city

order by avgr





select city ,avg(price) as avgr

from swiggy

group by city

order by avgr


create table zomato(

url varchar(2),

addr varchar(2),

city varchar(30),

cityid int,

loc varchar(2),

lat int,

lon int,

zip int,

co int,

lo varchar(2),

Price integer,

Avg_ratings float,

Total_ratings int,

Deliverytime varchar(10)

);


load data local infile 'C:\\Users\\Desktop\\zomato.csv'

into table swg

fields terminated by','

ignore 1 rows  ;


select city,count(city) as c from swiggy

group by city


