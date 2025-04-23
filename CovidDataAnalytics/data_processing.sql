/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- creating database for covid project

CREATE DATABASE covid_project;

-- use created database

USE covid_project;

-- data is divided into two sheet ;1)covid death and 2) covid vaccinatio
-- importing csv files into two tables; covid_death and covid_vaccination
-- displaying both tables

SELECT * FROM covid_death;
SELECT * FROM covid_vaccination;

-- Select Global Data that we are going to be starting with

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covid_death
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- select covid data of india

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covid_death
WHERE continent IS NOT NULL AND location='india' 
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_death
WHERE location = 'india'
AND continent IS NOT NULL 
ORDER BY 1,3;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT Location, date, Population, total_cases,  (total_cases/population)*100 AS PercentPopulationInfected
FROM covid_death
WHERE location = 'india'
ORDER BY 1,2;

-- total percentage of indian population infected

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM covid_death
WHERE location='india'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM covid_death
WHERE continent<>''
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Death Count per Population

SELECT location ,max( cast(total_deaths as unsigned)) as TotalDeathCount
FROM covid_death
WHERE continent <>''
GROUP BY Location
ORDER BY TotalDeathCount DESC;


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

SELECT continent, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
FROM covid_death
WHERE continent<>''
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Total deaths,total cases and death percentage continent wise

SELECT continent,SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
FROM covid_death
WHERE continent <>''
GROUP BY continent
ORDER BY 1,2;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(v.new_vaccinations,UNSIGNED)) OVER (PARTITION BY d.Location ORDER BY d.location, d.Date) AS  RollingPeopleVaccinated
FROM covid_death d
JOIN covid_vaccination v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent <>''
ORDER BY 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

WITH TotalVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(v.new_vaccinations,UNSIGNED)) OVER (PARTITION BY d.Location ORDER BY d.location, d.Date) AS RollingPeopleVaccinated
FROM covid_death d
JOIN covid_vaccination v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent<>''

)
SELECT *,(RollingPeopleVaccinated/Population)*100 AS vaccinatedPerPopulation
FROM TotalVac;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY Table PercentPopulationVaccinated
(
Continent char(255),
Location char(255),
Date text,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

INSERT INTO PercentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(v.new_vaccinations,unsigned)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
 FROM covid_death d
JOIN covid_vaccination v
	ON v.location = d.location
	AND v.date = d.date
	WHERE d.continent <>'' ;
-- order by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinatedPerPopulation
FROM PercentPopulationVaccinated;


-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(v.new_vaccinations,unsigned)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
FROM covid_death d
JOIN covid_vaccination v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent is not null 


