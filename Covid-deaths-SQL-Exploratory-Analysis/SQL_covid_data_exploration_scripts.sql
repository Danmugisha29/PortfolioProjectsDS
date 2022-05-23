/*
Author : DAN MUGISHA
Project : COVID DATA EXPLORATORY ANALYSIS
Skills used: Joins, CTE's, Temp Tables, Windows Functions,
Aggregate Functions, Views creation, Data Types conversion

*/

-- Query to select all covid deaths data table

SELECT * FROM
Covid_deaths
WHERE continent is not null
order by 3, 4;

---- Query to select all covid vaccinations data table

SELECT * FROM
Covid_Vaccinations
WHERE continent is not null
order by 3, 4;

-- Data that is going to be used

SELECT location,date,total_cases,new_cases,
total_deaths, population  FROM
Covid_deaths
WHERE continent is not null
order by 1,2

--Total cases vs Total deaths
-- New column is created to calculate death rate
-- Likelihood of dying if you contract covid in your country of choice
-- Country of choice : Rwanda

SELECT location,date,total_cases,
total_deaths,(total_deaths/total_cases)*100 as Death_Percentage FROM
Covid_deaths
WHERE location like '%Rwanda%'
order by 1,2

-- Total cases vs Population
-- Highest infection rate compared to Population for each country or location

SELECT location, population,MAX(total_cases) 
AS HighestInfectionCount,
MAX((total_cases/population))*100 as 
PercentPopulationInfected FROM Covid_deaths
WHERE continent is not null
GROUP BY location, population
order by PercentPopulationInfected desc


-- showing countries with Highest death count per population

SELECT location, population ,MAX(cast(total_deaths as int)) AS HighestDeathCount 
FROM Covid_deaths
WHERE continent is not null
GROUP BY location, population
order by HighestDeathCount desc

-------------------------------------------
-------------------------------------------

-- Total cases vs deaths

SELECT location,date,total_cases,
total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
FROM Covid_deaths
WHERE continent is NULL
and location not in ( 'World', 'European Union', 
'International','Upper middle income','Lower middle income', 
'Low income', 'High income')
order by 1,2

-- Highest death count by continent

SELECT location, SUM(cast(new_deaths as int))
AS TotalDeathCount
FROM Covid_deaths
WHERE continent is NULL
and location not in ( 'World', 'European Union', 
'International','Upper middle income','Lower middle income', 
'Low income', 'High income')
GROUP BY location
order by TotalDeathCount desc


--Total cases vs Total deaths globally
-- New column is created to calculate death rate

SELECT SUM(new_cases) as Total_cases,
SUM(cast(new_deaths as int))as Total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 
as Death_Percentage FROM
Covid_deaths
WHERE continent is not null
order by 1,2


--- COVID Total_cases vs total_deaths  on Global spectrum

SELECT SUM(new_cases) as Total_cases,
SUM(cast(new_deaths as int))as Total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 
as Death_Percentage FROM
Covid_deaths
WHERE continent is not null
order by 1,2


--- Joining Covid deaths table and Covid Vaccinations table

SELECT * 
FROM
Covid_deaths dea
join Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date

-- Showing total population vs Vaccinations
-- determine the amount of people that have been vaccinated in the world

SELECT dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations
FROM
Covid_deaths dea
join Covid_Vaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order  by 2,3


-- Showing Total population vs Vaccinations by location or country
-- country of choice : Rwanda

SELECT dea.location, 
dea.date,
dea.population,
vac.new_vaccinations
FROM
Covid_deaths dea
join Covid_Vaccinations vac
    on dea.location = vac.location 
    and dea.date = vac.date
where dea.location like '%Rwanda%'
order  by 2

--- Total population vs vaccinations 
-- New column is created to see the total amount of people vaccinated

SELECT dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint))
OVER 
(Partition by dea.location order by dea.location, dea.date)
as amount_of_people_vaccinated
FROM
Covid_deaths dea
join Covid_Vaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order  by 2,3



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (continent, location, date,population,
new_vaccinations, amount_of_people_vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint))
OVER 
(Partition by dea.location order by dea.location, dea.date)
as amount_of_people_vaccinated
FROM
Covid_deaths dea
join Covid_Vaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order  by 2,3
)
Select *, (amount_of_people_vaccinated/population)*100 as Vac_Percentage
FROM 
PopvsVac

-- TEMP TABLE

DROP TABLE if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
   Continent nvarchar (255),
   Location nvarchar(255),
   Date datetime,
   Population numeric,
   New_Vaccinations numeric,
   amount_of_people_vaccinated numeric
)
   
Insert into PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, 
dea.population,
vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint))
OVER 
(Partition by dea.location order by dea.location, dea.date)
as amount_of_people_vaccinated
FROM
Covid_deaths dea
join Covid_Vaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order  by 2,3

Select *, (amount_of_people_vaccinated/population)*100
as Vac_Percentage
FROM PercentPopulationVaccinated

-- Views creation

-- Covid deaths table view

DROP VIEW if exists Covid_deaths_table
GO
CREATE VIEW  Covid_deaths_table
as
SELECT * FROM
Covid_deaths
WHERE continent is not null
GO

-- Covid vaccinations table view

DROP VIEW if exists Covid_Vaccinations_table
GO
CREATE VIEW  Covid_Vaccinations_table
as
SELECT * FROM
Covid_Vaccinations
WHERE continent is not null
GO

--- Covid deaths and Covid Vaccinations Join view

DROP VIEW if exists Covid_deaths_Covid_vaccinations_Join_View
GO
CREATE VIEW Covid_deaths_Covid_vaccinations_Join_View
as
SELECT 
dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations
FROM
Covid_deaths dea
join Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
GO

-- Percent Population infected view

DROP VIEW if exists Population_infection_rate
GO
CREATE VIEW Population_infection_rate
as
SELECT location,date, population,MAX(total_cases) 
HighestInfectionCount,
MAX((total_cases/population))*100 
as PercentPopulationInfected FROM Covid_deaths
GROUP by location,population,date
GO

--- Highest Infection Count view

DROP VIEW if exists Highest_infection_count_view
GO
CREATE VIEW Highest_infection_count_view
as
SELECT location,date, population,MAX(total_cases) 
HighestInfectionCount,
MAX((total_cases/population))*100 
as PercentPopulationInfected FROM Covid_deaths
GROUP by location,population,date
GO

--- Population percentage vaccinated view
-- Shows amount of people vaccinated compared to the population

DROP VIEW if exists PoPulation_Percentage_Vaccinated 
GO
CREATE VIEW PoPulation_Percentage_Vaccinated 
as
SELECT dea.continent, dea.location, 
dea.date, dea.population,
vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint))
OVER 
(Partition by dea.location order by dea.location, dea.date)
as amount_of_people_vaccinated
FROM
Covid_deaths dea
join Covid_Vaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order  by 2,3
GO

--- Total Death Count by continent view

DROP VIEW if exists Total_Death_Count_View
GO
CREATE VIEW Total_Death_Count_View
as
SELECT location, SUM(cast(new_deaths as int))
AS TotalDeathCount
FROM Covid_deaths
WHERE continent is NULL
and location not in ( 'World', 'European Union', 
'International','Upper middle income','Lower middle income', 
'Low income', 'High income')
GROUP BY location
--order by TotalDeathCount desc
GO

---------------------------------------------------------
----------------------------------------------------------







