--SELECT *
--FROM Data_Exploration..CovidDeaths
--ORDER BY 3,4

--SELECT *
--FROM Data_Exploration..CovidVaccinations
--ORDER BY 3,4

--Select data for use from 1st Dateset CovidDeaths

--Looking at Total Cases vs Total Deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
FROM Data_Exploration..CovidDeaths
WHERE Location = 'Vietnam'
ORDER BY 1,2


--Looking at Total Cases vs Population
SELECT Location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
FROM Data_Exploration..CovidDeaths
WHERE Location like '%States%'
ORDER BY 1,2


--Looking at Highest Infection Rate of Each Country
SELECT Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationInfectionRate
FROM Data_Exploration..CovidDeaths
GROUP BY Location, Population
ORDER BY PopulationInfectionRate desc


--Looking at Highest Death Count of Each Country per Population
SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM Data_Exploration..CovidDeaths
WHERE Continent is not null  --exclude entire continents from the list, leave only countries
GROUP BY Location
ORDER BY TotalDeathCount desc


--Looking at Highest Death Count by Continent (1st way)
SELECT Continent, Max(cast(total_deaths as int)) as TotalDeathCount
FROM Data_Exploration..CovidDeaths
WHERE Continent is not null  --exclude entire continents from the list, leave only countries
GROUP BY Continent
ORDER BY TotalDeathCount desc
--***North America might only contain US


--Looking at Highest Death Count by Continent (2nd way)
SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM Data_Exploration..CovidDeaths
WHERE Continent is null
GROUP BY Location
ORDER BY TotalDeathCount desc



--GLOBAL NUMBERS

--Total Cases and Total Deaths Worldwide
Select Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, 
		Sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathrate
From Data_Exploration..CovidDeaths
Where Continent is not null


--Total Cases and Total Deaths by Date
Select Date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, 
		Sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathrate
From Data_Exploration..CovidDeaths
Where Continent is not null
Group by Date
Order by Date


--Joining Two Datasets
--Looing at Vaccinations vs Population
Select dea.Continent, dea.Location, dea.date, dea.Population, vac.new_vaccinations,
		Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.Location, dea.Date) as DailyVaccinationCounter
From Data_Exploration..CovidDeaths dea
Join Data_Exploration..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.Continent is not null
Order by 2,3



--Creating Views to Store Data for Visualizations
--Highest Death Count by Continent
Create View ContinentDeathCount as
SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM Data_Exploration..CovidDeaths
WHERE Continent is null
GROUP BY Location


--Looking at the View
Select *
From Data_Exploration..ContinentDeathCount