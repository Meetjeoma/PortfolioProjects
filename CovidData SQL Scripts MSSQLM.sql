  ----#DATA EXPLORATION WITH COVID DATA FROM OUR WORLD IN DATA
  --Select *
  --From PortfolioProject..CovidDeaths
  --order by 3,4

  --Select *
  --From PortfolioProject..CovidVaccinations
  --order by 3,4

SELECT location,date,total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2


--LET'S LOOK AT THE TOTAL CASES IN NIGERIA VS TOTAL DEATHS

SELECT location, date, total_cases total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where Location = 'Nigeria'
and continent is Not Null
order by 1,2



---- NOW LOOKING AT TOTAL CASES VS TOTAL POPULATION IN NIGERIA 

SELECT location,date, total_cases,population, (total_cases/population)*100 as PopulationPercentage
FROM PortfolioProject..CovidDeaths
where Location = 'Nigeria' 
and continent is Not Null
order by 1,2



---- LOOKING AT LOCATION WITH THE HIGHEST INFECTION PERCENTAGE

SELECT location, population, MAX(total_cases)as HighestInfectionCount, MAX(total_cases/population)*100 as PerfecentInfectedPopulation
FROM PortfolioProject..CovidDeaths
Group By Location, population
-- where Location = 'Nigeria'and continent is Not Null
order by PerfecentInfectedPopulation Desc



----THE TOTAL DEATHS PER LOCATION

SELECT location,MAX(total_deaths)as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is Null
Group By Location
order by TotalDeathCount Desc



---- --LOOKING AT DEATH COUNT PER CONTINENT
SELECT Continent,MAX(total_deaths)as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is Null
Group By Continent
order by TotalDeathCount Desc;




---- --BREAKING THINGS DOWN BY CONTINENT
---- Showing continents with highest death count per population

SELECT continent, MAX(total_deaths)as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is Not Null
Group By continent
order by TotalDeathCount Desc



----GLOBAL NUMBERS
SELECT date,SUM(new_cases) as total_cases, SUM(new_deaths) as totaldeaths, SUM(new_deaths)/SUM(New_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--where Location = 'Nigeria'
Where continent IS NOT NULL
GROUP BY date
order by 1,2

----TOTAL POPULATION vs VACCINES
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
ON dea.location = vac.location
And Dea.date = vac.date 
Where Dea.continent is not null
Order by 2, 3


SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER(PARTITION by Dea.location order by Dea.location, Dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
FULL OUTER JOIN PortfolioProject..CovidVaccinations  vac 
  ON dea.location = vac.location
  And Dea.date = vac.date 
Where Dea.continent is not null
Order by 2, 3



----USING CTE TO PERFORM CALCULATIONS ON A PARTITION BY

with PopvsVac as
(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER(PARTITION by Dea.location order by Dea.location, Dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
FULL OUTER JOIN PortfolioProject..CovidVaccinations vac  
  ON dea.location = vac.location
  And Dea.date = vac.date 
Where Dea.continent is not null
--Order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


----Looking at cases in Nigeria
----How many Cases and How many Deaths?
SELECT location, SUM(total_cases) as All_cases, SUM(total_deaths) as All_Death
from PortfolioProject..CovidDeaths
where location = 'Nigeria' and continent is not null
Group by location
order by 2 desc

----Looking at the data, the figures seem inflated. Check back, 185m+ cant be accurate.



----TEMP TABLE TO PERFORM CALCULATIONS ON PARTITION BY

DROP TABLE IF EXISTS #PercentPopulationVaccinated
Create TABLE #PercentPopulationVaccinated
  (continent nvarchar(250),
  location nvarchar(250),
  date datetime,
  Population numeric,
  new_vaccines numeric,
  RollingPeopleVaccinated numeric
  )
 Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

--select *
--from PercentPopulationVaccinated



----CREATE VIEW FOR LATER VISUALISATIONS
--CREATE VIEW CovidData.PercentPopulationVaccinated as
--SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations,
-- SUM(vac.new_vaccinations) OVER(PARTITION by Dea.location order by Dea.location, Dea.date) as RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
-- JOIN PortfolioProject..CovidVaccinations  vac 
--  ON dea.location = vac.location
--  And Dea.date = vac.date 
--Where Dea.continent is not null
--Order by 2, 3
