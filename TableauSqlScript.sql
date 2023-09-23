-- Tableau Table 1
SELECT 
    sum(new_cases) as total_cases ,sum(new_deaths) as total_deaths,Sum(new_deaths)/sum(new_cases)*100 as NewCasesDeathPercentage
    -- total_cases,total_deaths,(total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    coviddeaths where continent is not null 
    -- group by date
ORDER BY 1 , 2;

-- Tableau Table 2
-- Show Countries with Highest Death count per population
SELECT 
    continent,
    sum(cast(total_deaths as unsigned)) AS TotalDeathCount
FROM coviddeaths where continent is not null group by continent
ORDER BY TotalDeathCount desc;

-- Tableau Table 3
-- Looking at countries with highest infection rate compared to population
SELECT 
    location,
    population,
    max(total_cases) AS HighestInfectionCount,
    max((total_cases/ population))*100 AS PercentPopulationInfected
FROM
    coviddeaths group by population,location
ORDER BY PercentPopulationInfected desc;

-- Tableau Table 4
SELECT 
    location,
    population,
    date,
    max(total_cases) AS HighestInfectionCount,
    max((total_cases/ population))*100 AS PercentPopulationInfected
FROM
    coviddeaths group by population,location,date
ORDER BY PercentPopulationInfected desc;