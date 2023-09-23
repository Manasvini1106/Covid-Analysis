select * from coviddeaths where continent is not null order by 3,4;
select * from covidvaccinations order by 3,4;
select location, date, total_cases, new_cases, total_deaths, population from coviddeaths order by 1,2;

-- Looking at total cases vs total deaths
-- Likelihood of dying if you contraft covid in your country
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    coviddeaths where location like '%indi%'
ORDER BY 1 , 2;

-- Total cases vs population
-- Shows what percentage of population got covid
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases/ population) * 100 AS PercentPopulationInfected
FROM
    coviddeaths where location like '%indi%'
ORDER BY 1 , 2;

-- Looking at countries with highest infection rate compared to population
SELECT 
    location,
    population,
    max(total_cases) AS HighestInfectionCount,
    max((total_cases/ population))*100 AS PercentPopulationInfected
FROM
    coviddeaths group by population,location
ORDER BY PercentPopulationInfected desc;

-- Show Countries with Hughest Death count per population
SELECT 
    location,
    max(cast(total_deaths as unsigned)) AS TotalDeathCount
FROM coviddeaths where continent is not null group by location
ORDER BY TotalDeathCount desc;

SELECT 
    continent,
    max(cast(total_deaths as unsigned)) AS TotalDeathCount
FROM coviddeaths where continent is not null group by continent
ORDER BY TotalDeathCount desc;

-- Showing the continents with highest death count per population
SELECT 
    continent,
    max(cast(total_deaths as unsigned)) AS TotalDeathCount
FROM coviddeaths where continent is not null group by continent
ORDER BY TotalDeathCount desc;

-- Global Numbers
SELECT 
    sum(new_cases) as total_cases ,sum(new_deaths) as total_deaths,Sum(new_deaths)/sum(new_cases)*100 as NewCasesDeathPercentage
    -- total_cases,total_deaths,(total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    coviddeaths where continent is not null 
    -- group by date
ORDER BY 1 , 2;

select * from covidvaccinations vac join coviddeaths dea on dea.location=vac.location and dea.date=vac.date;

-- Total Population vs vaccinations
-- USE CTE
WITH PopvsVac(continent,location,population,date,new_vaccinations,RollingPeopleVaccinated)
as
(
SELECT 
    dea.continent,
    dea.location,
    dea.population,
    dea.date,
    vac.new_vaccinations, sum(cast(vac.new_vaccinations as unsigned)) 
    over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM
    covidvaccinations vac
        JOIN
    coviddeaths dea ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY 2 , 3
)
select *,(RollingPeopleVaccinated/Population)*100 from PopvsVac;

-- USE Temp Table

Create Temporary Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date date,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);


Insert into PercentPopulationVaccinated 
SELECT 
    dea.continent,
    dea.location,
    cast(dea.date as date),
    dea.population,
    vac.new_vaccinations, sum((vac.new_vaccinations)) 
    over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM
    covidvaccinations vac
        JOIN
    coviddeaths dea ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY 2 , 3;

select *,(RollingPeopleVaccinated/Population)*100 from PercentPopulationVaccinated;

-- create view to store data for later visualizations

Create view ViewPercentPopulationVaccinated as
SELECT 
    dea.continent,
    dea.location,
    cast(dea.date as date),
    dea.population,
    vac.new_vaccinations, sum((vac.new_vaccinations)) 
    over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM
    covidvaccinations vac
        JOIN
    coviddeaths dea ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY 2 , 3;

SELECT * FROM ViewPercentPopulationVaccinated;