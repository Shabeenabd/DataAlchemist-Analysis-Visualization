-- creating database "football"
create database  football;
use football;

-- creating table "ftbl" 
drop table if exists ftbl;
create table ftbl(
Place integer,	
Team	varchar(30),
GP	integer,
W	integer,
D	integer,
L	integer,
GF	integer,
GA	integer,
GD	integer,
Points	integer,
Year	integer,
League  varchar(30)
);

-- show variables like "local_infile";

-- importing data from external csv file
load data local infile "C:\\Users\\Downloads\\all_tables.csv"
into table ftbl
fields terminated by ','
ignore 1 rows;

-- renaming table name
-- use football;
-- alter table halamadrid
-- rename to ftbl;

-- showing  no of titles in laliga
select team,count(team) as titles
from ftbl 
where league like "s%" and place=1
group by team 
order by titles desc;

-- selecting no of titles in all leagues
select league,team,count(team) as titles
from ftbl 
where  place=1
group by league,team 
order by titles desc;

-- most runner up(second place)
select league,team,count(team) as runner_up
from ftbl 
where  place=2
group by league,team 
order by runner_up desc;


-- most last position
with cte as
(select league,year,max(place) as lastplace
from ftbl
group by league,year)
select c.league,f.team,c.year,f.place,count(f.team) over (partition by f.team) as times_last_position
from 
cte c join ftbl f
on c.lastplace=f.place and c.year=f.year and c.league=f.league
order by league,times_last_position desc;



-- relegated teams each season
with cte as
(select  league,year,max(place) as last_pos
from ftbl 
group by league ,year
order by league desc)
select f.league, f.year,f.team,f.place
from ftbl as f
join cte
on (cte.last_pos-2)<=f.place  and cte.league=f.league and cte.year=f.year;

-- most relegated teams from 2000 - 2021
with cte as
(select  league,year,max(place) as last_pos
from ftbl 
group by league ,year
order by league desc)
select f.league, f.year,f.team,f.place,count(f.team) over (partition by f.team) as no_of_times
from ftbl as f
join cte
on (cte.last_pos-2)<=f.place  and cte.league=f.league and cte.year=f.year
order by no_of_times desc,f.league,f.team,f.year asc;

-- total ,matches of each club between 2000 - 2021
select team,sum(gp) as total_matches,league
from ftbl 
group by team , league
order by total_matches desc;

-- teams with most wins 
select team ,sum(w) as total_wins,league
from ftbl
group by team,league
order by total_wins desc;

-- win percentage of each teams
with cte (team ,total_matches, total_wins,league)
as
(
select team ,sum(gp) as total_matches,sum(w) as total_wins,league
from ftbl
group by team,league
order by total_wins desc)
select team,league,round((total_wins/total_matches)*100,1) as win_percentage
from cte;

-- total losses of each teams
select team ,sum(l) as total_loss,league ,sum(gp) as plays
from ftbl
group by team,league
order by total_loss desc;

-- loss percentage of each team
with cte (team ,total_matches, total_losses,league)
as
(
select team ,sum(gp) as total_matches,sum(l) as total_losses,league
from ftbl
group by team,league
order by total_losses desc)
select team,league,round((total_losses/total_matches)*100,1) as loss_percentage
from cte
order by loss_percentage asc;

-- total draw percentage of each team
select team ,sum(gp) as match_played,sum(d) as total_draw,league ,round((sum(d)/sum(gp))*100 ,1)as draw_percentage
from ftbl
group by team,league
order by draw_percentage asc;

-- total goals for and against of each team
select team ,league,sum(gf) as total_goals,sum(ga) as total_goals_conceaded
from ftbl
group by team,league
order by total_goals desc,total_goals_conceaded asc;

-- total points of each team
select team ,league,sum(points) as total_points,sum(gp) as games_played,sum(points)/sum(gp) as point_received_per_game
from ftbl
group by team,league
order by total_points desc;

-- showing the top 6 leagues
select league, count(distinct(year))
from ftbl
group by league;

-- removing dutch league
select distinct(league)
from ftbl
where league not like "d%" ;

-- showing column name and data type of the table
select column_name,data_type  from information_schema.columns where table_schema="football" and  table_name="halamadrid ";

-- creatimg view
create view most_titles as
select league,team,count(team) as titles
from ftbl 
where  place=1
group by league,team 
order by titles desc;
