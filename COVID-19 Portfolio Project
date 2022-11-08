SELECT *
FROM [Portfolio Project - SQL]..CovidDeaths
ORDER BY 3, 4

--*THIS SCRIPT REMOVES THE CONTINENT GROUPING FROM OUR DATA

SELECT *
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4

--SELECT *
--FROM [Portfolio Project - SQL]..CovidVaccinations
--ORDER BY 3, 4

--*SELCT DATA THAT WE ARE GOING TO BU USING 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project - SQL]..CovidDeaths
ORDER BY 1, 2

--*LOOKING AT TOTAL CASES VS TOTAL DEATHS
--*SHOWS PROBABILITY OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DEATH_PERCENTAGE
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE location LIKE '%CANADA%'
ORDER BY 1, 2

--*LOOKING AT TOTAL CASES VS POPULATION
--*SHOWS WHAT PERCENTAGE OF THE POPULATION GOT COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 PERCENTAGE_OF_POPULATION_INFECTED
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE location LIKE '%CANADA%'
ORDER BY 1, 2

--*LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT location, population, MAX(total_cases) HIGHEST_INFECTION_COUNT, MAX((total_cases/population))*100 PERCENTAGE_OF_POPULATION_INFECTED
FROM [Portfolio Project - SQL]..CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

--*SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT location, MAX(CAST(total_deaths AS INT)) TOTAL_DEATHS
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TOTAL_DEATHS DESC

--WE WILL BEGIN TO BREAK THINGS DOWN BY CONTINENT

SELECT location, MAX(CAST(total_deaths AS INT)) TOTAL_DEATHS
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TOTAL_DEATHS DESC

SELECT continent, MAX(CAST(total_deaths AS INT)) TOTAL_DEATHS
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TOTAL_DEATHS DESC

--WE WILL BEGIN TO SHOW THE CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

SELECT location, MAX(CAST(total_deaths AS INT)) TOTAL_DEATHS
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TOTAL_DEATHS DESC

SELECT continent, MAX(CAST(total_deaths AS INT)) TOTAL_DEATHS
FROM [Portfolio Project - SQL]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TOTAL_DEATHS DESC

--SHOWING THE GLOBAL NUMBERS

SELECT DATE, SUM(NEW_CASES) AS TOTAL_CASES, SUM(CAST(NEW_DEATHS AS INT)) AS TOTAL_DEATHS, SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 AS DEATH_PERCENTAGE
FROM [Portfolio Project - SQL]..CovidDeaths
--WHERE LOCATION LIKE '%SATES%'
WHERE continent IS NOT NULL
GROUP BY DATE
ORDER BY 1,2

SELECT, SUM(NEW_CASES) AS TOTAL_CASES, SUM(CAST(NEW_DEATHS AS INT)) AS TOTAL_DEATHS, SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 AS DEATH_PERCENTAGE
FROM [Portfolio Project - SQL]..CovidDeaths
--WHERE LOCATION LIKE '%SATES%'
WHERE continent IS NOT NULL
GROUP BY DATE
ORDER BY 1,2

--LOOKING AT TOTAL POPULATION VS VACCINATIONS

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project - SQL]..CovidDeaths dea
Join [Portfolio Project - SQL]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
Order  by 2,3

--WE WILL BE USING CTE's FOR THE ABOVE LINE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project - SQL]..CovidDeaths dea
Join [Portfolio Project - SQL]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--CREATING A TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project - SQL]..CovidDeaths dea
Join [Portfolio Project - SQL]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--CREATING VIEWS TO STORE DATA FOR VISUALIZATIONS

Create View PercentPopulationVaccinated As
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project - SQL]..CovidDeaths dea
Join [Portfolio Project - SQL]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null

-- 1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_Cases)*100 as DeathPercentage
From [Portfolio Project - SQL]..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2

-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project - SQL]..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project - SQL]..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- 4.

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project - SQL]..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

