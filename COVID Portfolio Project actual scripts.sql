Select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
-- show likelihood of dying if you contact covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2


--- Looking at total cases vs population
-- show percentage of population go covid

Select Location, date,population, total_cases, (total_cases/population)*100 as PercentpopulationInfected 
from CovidDeaths
--where location like '%states%'
order by 1,2


--Looking at countries with highest infection rate compared to population
Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
--where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc


-- showing countries with Highest Death Count per population
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount  -- cast is converting an nvarcher to interger 
from CovidDeaths
--where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc


--Let's break things down by continent
Select location, Max(cast(total_deaths as int)) as TotalDeathCount  -- cast is converting an nvarcher to interger 
from CovidDeaths
--where location like '%states%'
where continent is null
Group by location
order by TotalDeathCount desc

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount  -- cast is converting an nvarcher to interger 
from CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--showing the continent with Highest Death Count per population
Select location, Max(cast(total_deaths as int)) as TotalDeathCount  -- cast is converting an nvarcher to interger 
from CovidDeaths
--where location like '%states%'
where continent is null
Group by location
order by TotalDeathCount desc


-- Global Numbers

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) 
from CovidDeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--Project 1 

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) as DeathPercentage 
from CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

--Join table
select * 
from CovidDeaths dea
Join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date

--Looking total population vs vaccinations
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location) 
as RollingPeoplevaccinated
--sum(convert(int, vac.new_vaccinations)) over (partition by dea.location) same way with cast function
from CovidDeaths dea
Join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE
with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location) 
as RollingPeoplevaccinated
--sum(convert(int, vac.new_vaccinations)) over (partition by dea.location) same way with cast function
from CovidDeaths dea
Join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population) * 100
from PopvsVac


--Temp Table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location) 
as RollingPeoplevaccinated
--sum(convert(int, vac.new_vaccinations)) over (partition by dea.location) same way with cast function
from CovidDeaths dea
Join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population) * 100
from #PercentPopulationVaccinated



--Creating View to store data for later vizualizations

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location) 
as RollingPeoplevaccinated
--sum(convert(int, vac.new_vaccinations)) over (partition by dea.location) same way with cast function
from CovidDeaths dea
Join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated