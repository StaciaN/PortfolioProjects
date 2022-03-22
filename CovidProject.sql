--------Percent deaths in US

    Select a.location, a.date, a.total_deaths, a.total_cases,
         nullif(total_deaths,0)/Nullif(total_cases,0)*100 as percentdeaths
             from dbo.CovidDeath a 
    Where a.location like'%state%' 
        and date between '1/1/2020' and '12/31/22'
    order by 1,2

 
  ------View----
   Create View  
         PercentUSCovidDeaths as
  Select a.location, a.date, a.total_deaths, a.total_cases,
     nullif(total_deaths,0)/Nullif(total_cases,0)*100 as percentdeaths
        from dbo.CovidDeath a 
  Where a.location like'%state%' 
    and date between '1/1/2020' and '12/31/22'
 --- order by 1,2





 --- total cases vs. Population- percent of population who has gotten covid in US. 

      Select a.location, a.date, a.population, a.total_cases,
       nullif(a.total_cases,0)/Nullif(a.population,0)*100 as percent_deaths
         from dbo.CovidDeath a 
      Where a.location like'%state%' 
        order by 1,2

 --- total cases vs. Population- percent of population who has gotten covid in world

	Select location,  date, population, total_cases,
		 nullif(total_cases,0) /nullif(population,0)*100 
		as PercentPopCovidSick
    from CovidDeath

    **** numbers OK***


	----View---
	 Create View PercentPopCovidSick as
		Select location,  date, population, total_cases,
		 nullif(total_cases,0) /nullif(population,0)*100 
		as PercentPopCovidSick
    from CovidDeath
	   	   


  ----  Country with highest infection/pop

	Select location, population, Max(total_cases) as Highest_Cases,
		 Max(nullif(total_cases,0)/nullif(population,0))* 100 as PercentPopulationInfected
			From CovidDeath
	  Group by location, population
	  Order by PercentPopulationInfected desc

	  --- Numbers OK

	  ----View---
	  Create View PercentPopulationInfected as
		  Select location, population, Max(total_cases) as Highest_Cases,
			 Max(nullif(total_cases,0)/nullif(population,0))* 100 as PercentPopulationInfected
			  From CovidDeath
	  Group by location, population
	  --Order by PercentPopulationInfected desc

	 
	-----Highest Deaths per Population

	Select distinct top 14 location, population, Max (cast(total_deaths as int) )
			as TotalDeaths from CovidDeath	
	Where continent is not null
	Group by location, population
	Order by TotalDeaths desc

	-----Numbers OK

-------- Showing  continents with highest death count
		Select distinct continent, Max (cast(total_deaths as int) )
			as TotalDeaths from CovidDeath	
		Where continent is not null
		Group by continent
		Order by TotalDeaths desc

	---Numbers ?


------  New Cases
	

	Select date, location, new_cases ,new_deaths
		from CovidDeath
	Where new_cases > 10 and new_deaths >10
	Order by date,location, new_cases, new_deaths

	---#OK

	------percent of new 

   
	Select 
		continent, date, sum(nullif(new_cases,0)) as total_cases,
			sum(nullif(new_deaths,0)) as total_deaths,
				sum(nullif(new_deaths,0))/sum(nullif(new_cases,0))*100
		as	Death_Percentages 
				from CovidDeath  
         --Where new_cases > 10 and new_deaths >10 
         Where continent is not null 		 
	Group by  continent, date
	Order by date


	-----#ok---

	

	--------total pop vs. vaccinations

	Select a.date, b.continent, a. location,a.population, b.total_deaths,
			a. new_vaccinations, sum ( a.new_vaccinations)
	 Over(partition by a.location order by a.location, a. date)  as IncreaseVacNumber
			from CovidVac a
		Join coviddeath b on b.location = a. location 
	        and b.date = a.date	
	Where b.continent is not null
		and a.new_vaccinations <>0
	Order by 1,2,3


	----Use CTE	
	
	With Popvsvac (continent, location, date,population, new_vaccinations, IncreaseVacNumber)
	as
	(	Select b.continent,  a.location,a.date , a.population, a. new_vaccinations, 
			sum ( a.new_vaccinations) over 
				(partition by a. new_vaccinations ) as IncreaseVacNumber
					from CovidVac a
				join coviddeath b on b.location =a. location 
				and b.date = a.date
					where b.continent is not null
					 and new_vaccinations <> 0
					 
				Group by b.continent,  a.location,a.date , a.population, a. new_vaccinations
	
					------Order by 	)

	Select *, Nullif(IncreaseVacNumber,0)/nullif(population,0)*100 
		as PercentVac from Popvsvac

		-------#?


	
	