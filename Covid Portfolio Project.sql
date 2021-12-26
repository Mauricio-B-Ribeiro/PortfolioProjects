Select *
from PortfolioProjects..CovidDeaths
Where continent is not null
order by 3,4


--Select *
--from PortifolioProjects..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
Where continent is not null 
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows Likelíhood of dying if you contract Covid in your country


Select location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 as Death_Percentage
from PortfolioProjects..CovidDeaths
Where location = 'Portugal' 
and continent is not null
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of a certain population got infected by covid


Select location, date, population,total_cases , (total_cases/ population)*100 as Percent_Population_Infect
from PortfolioProjects..CovidDeaths
Where location = 'Portugal'
order by 1,2

-- Looking at Counrtries with Highest Infection Rate compared to Population


Select location, population, MAX(total_cases) as Highest_Infection_Count , MAX((total_cases/ population))*100 as Percent_Population_Infected
from PortfolioProjects..CovidDeaths
--Where location = 'Portugal'
group by location, population
order by Percent_Population_Infected desc

-- Showing Countries with Highest Death Count per Population


Select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProjects..CovidDeaths
--Where location = 'Portugal'
Where continent is not null 
group by location
order by Total_Death_Count desc




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing Contintents with the Highest Death Count per Population


Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProjects..CovidDeaths
--Where location = 'Portugal'
Where continent is not null 
group by continent
order by Total_Death_Count desc


-- GLOBAL NUMBERS

Select  SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths, (SUM(New_deaths)/SUM(new_cases))*100 Death_Percentage
from PortfolioProjects..CovidDeaths
--Where location = 'Portugal' 
Where continent is not null
--group by date
order by 1,2



-- Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/dea.population)*100
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations,Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/dea.population)*100
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)

Select * ,(Rolling_People_Vaccinated/Population)*100
From PopvsVac




-- Creating View to store data for later visualizations

Create View Global_Numbers as
Select  SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths, (SUM(New_deaths)/SUM(new_cases))*100 Death_Percentage
from PortfolioProjects..CovidDeaths
--Where location = 'Portugal' 
Where continent is not null
--group by date

Create View Percent_Population_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/dea.population)*100
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3


Select * 
from Percent_Population_Vaccinated