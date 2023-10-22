-- Select Data that we are going to be using
--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths$
--ORDER BY 1, 2

--ALTER TABLE CovidDeaths$ ALTER COLUMN total_cases float
--ALTER TABLE CovidDeaths$ ALTER COLUMN total_deaths float

---- Looking at Total Cases vs Total Deaths
---- Shows likelihood of dying
--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--FROM CovidDeaths$
--WHERE location LIKE '%states%' AND total_deaths IS NOT NULL
--ORDER BY 1, 2

---- Look at Total Cases vs Population
--SELECT location, date, total_cases, population, (total_cases/population)*100 as Prct
--FROM CovidDeaths$
--WHERE location LIKE '%united states' AND total_deaths IS NOT NULL
--ORDER BY 1, 2

---- Looking at coutnries with highest infection rate compared to population
--SELECT location, population,
--MAX(total_cases) AS HighestInfectionCount,
--MAX(total_cases/population)*100 AS PrctPopulationInfected
--FROM CovidDeaths$
--WHERE total_deaths IS NOT NULL
--GROUP BY Location, population
--ORDER BY 4 DESC

---- Show countries with highest death count population
--SELECT location,
--MAX(CAST(total_deaths as int)) AS TotalDeathCount
--FROM CovidDeaths$
--WHERE continent IS NULL
--GROUP BY Location
--ORDER BY TotalDeathCount DESC

---- Show continent with highest death count population
--SELECT continent,
--MAX(CAST(total_deaths as int)) AS TotalDeathCount
--FROM CovidDeaths$
--WHERE continent IS NOT NULL --AND continent IN ('Europe', 'Asia')
--GROUP BY continent
--ORDER BY TotalDeathCount DESC

---- GLOBAL NUMBERS
--SELECT SUM(new_cases) as tnew_cases,
--SUM(new_deaths) AS tnew_deaths--, SUM(new_deaths/new_cases)
----tnew_deaths/tnew_cases --, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--FROM CovidDeaths$
--WHERE continent IS NOT NULL and new_cases IS NOT NULL
----GROUP BY date
--ORDER BY 1, 2

---- Looking at Total Population vs Vaccinations
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location,
--dea.date) as RollingPeopleVaccinated 
--FROM CovidDeaths$ dea
--JOIN CovidVaccinations$ vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL --and new_vaccinations IS NOT NULL
--ORDER by 2,3

---- USE CTE
--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location,
--dea.date) as RollingPeopleVaccinated 
--FROM CovidDeaths$ dea
--JOIN CovidVaccinations$ vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL --and new_vaccinations IS NOT NULL
--)
--SELECT *, (RollingPeopleVaccinated/Cast(Population as float))*100
--From PopvsVac

-- Create View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated 
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL --and new_vaccinations IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated