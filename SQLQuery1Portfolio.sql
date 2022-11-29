select*
from Portofolioproject..CovidDeaths

select*
from PortofolioProject..CovidVaccinations



select location,date , total_cases,new_cases,total_deaths,population
from PortofolioProject..CovidDeaths



--looking at Total Cases vs Total Deaths
-- shows likelihood of dying if you contract covid in your country
select location,date , total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
where location like '%state%'

-- Looking at Total cases vs population
-- Shows what percentage of population got Covid

select continent,date ,Population,total_cases, (total_cases/population)*100 as DeathPercentage
from PortofolioProject..CovidDeaths

--Looking at countries with Highest Infection Rate compared to population

select continent,Population, MAX(total_cases)as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
 from PortofolioProject..CovidDeaths
 Group by continent,Population 
 order by PercentPopulationInfected desc

 -- showing Countries with Highest Death Count Per Population
 
  


 Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
 From PortofolioProject..CovidDeaths
 where continent is not null
 Group by continent
 order by TotalDeathCount desc
 
 --LET'S BREAK THINGS BY CONTINENT

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
 From PortofolioProject..CovidDeaths
 where continent is null
 Group by continent
 order by TotalDeathCount desc
 
 -- showing continents with the highest death count per population

 Select continent , Max (cast(Total_deaths as int)) as Totaldeathcount
 From PortofolioProject..CovidDeaths
-- where location like'%states%'
 where continent is not null
 Group by continent
 order by TotaldeathCount desc

 -- Global NUMBERS

 Select SUM(New_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
--where location like'Burundi'
where continent is not null
--Group By date

select*
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date

--Looking at Total Population vs Vaccinations




select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.Location, Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--USE CTE

With PopvsVac ( continent, Location,Date , Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select* , ( RollingPeopleVaccinated/Population)*100
from PopvsVac

--TEMP TABLE
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select* , ( RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

DROP TABLE IF exists #PercentPopulationVaccinated

Create Table ##PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select* , ( RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

---create View to store data for later visualizations

 Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
select*
from PercentPopulationVaccinated