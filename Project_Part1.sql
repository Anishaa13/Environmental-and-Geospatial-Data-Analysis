/*Project Part-1*/

/*Q1*/
select State_Name, min(Average_Temp) as [Minimum Temp], max(Average_Temp) as [Maximum Temp], avg(cast (Average_Temp as float)) as [Average Temp] 
from Temperature a, AQS_Sites b
where a.State_Code = b.State_Code 
group by State_Name 
order by State_Name asc


/*Q2*/
select State_Name, a.State_Code, a.County_Code, Site_Number, count(Average_Temp) as Num_Bad_Entries
from Temperature a, AQS_Sites b 
where a.State_Code = b.State_Code and Site_Num = Site_Number and (cast(Average_Temp as float) < -39 or cast(Average_Temp as float) > 105)
group by State_Name,a.State_Code, a.County_Code, Site_Number


/*Q3*/
alter table Temperature
alter column average_temp decimal (10,4) null
if OBJECT_ID('Project_view', 'V') is not Null
begin
	drop view dbo.Project_view
end
go
create view dbo.Project_view
with schemabinding
As (
select a.State_Code, a.State_Name, a.County_Code, a.Site_Number, 
		a.City_Name, t.average_temp, t.Date_Local
from dbo.AQS_Sites a, dbo.Temperature t
where a.Site_Number = t.Site_Num and
	a.State_Code = t.State_Code and
	a.County_Code = t.County_Code and
	a.State_Code not in ('CC', '80','78','72','66') and
	Average_Temp > -39 and
	((Average_Temp <= 105.00) or (Average_Temp <= 125.00) and t.State_Code not in (30, 29, 37, 26, 18, 38)))
go
select State_Code, count(Average_Temp) as [row_count]
from dbo.Project_view
group by State_Code
order by State_Code


/*Q4*/
select tp.*, rank() over (order by Average_Temp desc) as State_Rank 
from (select State_Name , min(Average_Temp) as [Minimum_Temp], max(Average_Temp) as [Maximum_Temp], avg(cast (Average_Temp as float)) as [Average_Temp] from Project_view
group by State_Name, State_Code) tp


/*Q6*/
go
with cte as
(select *, rn = row_number() over (partition by State_Code, County_Code, Site_Num, Date_Local order by State_Code)
	from Temperature)
delete from CTE where rn > 1
go
DROP INDEX if exists IDX_Project_view on dbo.Project_view
go
Create unique clustered index
IDX_Project_view
on dbo.Project_view (State_Code, County_Code, Site_Number, Date_Local)


/*Q7*/
go
with 
StateRank as
	(select A.State_Name, avg(cast (Average_Temp as float)) as [State_Avg_Temp], rank() OVER (order by avg(cast (Average_Temp as float)) desc) as State_Rank
	from Project_view A 
	group by A.State_Name),
CityRank as
	(select B.state_Name, B.city_Name, avg(cast (Average_Temp as float)) as [Average_Temp],rank() over (partition by B.State_Name order by avg(cast (Average_Temp as float)) desc) as State_City_Rank 
	from Project_view B 
	group by B.State_Name, B.City_Name)
select StateRank.State_Rank, CityRank.State_Name,  CityRank.State_City_Rank, CityRank.City_Name, CityRank.[Average_Temp] 
from StateRank, CityRank
where StateRank.State_Name = CityRank.State_Name and State_Rank <= 15 
order by StateRank.State_Rank asc


/*Q8*/
if OBJECT_ID('Project_view', 'V') is not Null
begin
	drop view dbo.Project_view
end
go
create view dbo.Project_view
with schemabinding
As (
select a.State_Code, a.State_Name, a.County_Code, a.Site_Number, 
		a.City_Name, t.average_temp, t.Date_Local
from dbo.AQS_Sites a, dbo.Temperature t
where a.Site_Number = t.Site_Num and
	a.State_Code = t.State_Code and
	a.County_Code = t.County_Code and
	a.State_Code not in ('CC', '80','78','72','66') and
	Average_Temp > -39 and
	City_name<> 'Not in a City' and
	((Average_Temp <= 105.00) or (Average_Temp <= 125.00) and t.State_Code not in (30, 29, 37, 26, 18, 38)))


/*Q9*/
go
with
StateRank as
	(select A.State_Name, avg(cast (Average_Temp as float)) as [State_Avg_Temp], rank() over (order by avg(cast (Average_Temp as float)) desc) as State_Rank
	from Project_view A 
	group by A.State_Name),
CityRank as
	(select B.State_Name, B.City_Name, avg(cast (Average_Temp as float)) as [Average_Temp], rank() over (partition by B.State_Name order by avg(cast (Average_Temp as float)) desc) as State_City_Rank
	from Project_view B 
	group by B.State_Name, B.City_Name)
select State_Rank, StateRank.State_Name, State_City_Rank, CityRank.City_Name, CityRank.Average_Temp 
from StateRank, CityRank
where StateRank.State_Name = CityRank.State_Name and CityRank.State_City_Rank <= 2 and State_Rank <= 15 
order by StateRank.State_Rank asc


/*Q10*/
with cte as(
select City_Name,State_Name, datepart(month, Date_Local) as Months, count(*) as No_of_Records, avg(cast (Average_Temp as float)) as [Average_Temp] 
from Project_view
group by City_Name,State_Name, datepart(month, Date_Local))
select * from cte where Average_Temp>70 and No_of_Records>70


/*Q11*/
go
with 
A as
    (select DISTINCT City_Name,State_name, CUME_DIST() over (partition by City_Name order by Average_Temp asc) as Temp_Cume_Dist, 
    avg(cast (Average_Temp as float)) as [Average_Temp] 
    from Project_view group by City_Name,Average_Temp,State_name)
select State_name,City_name, Average_Temp, Temp_Cume_Dist 
from A where TEMP_CUME_DIST < 0.60 and TEMP_CUME_DIST > 0.40  order  by State_name


/*Q12*/
select  Distinct City_Name,State_name,  Percentile_Disc(0.4) within group (order by Average_Temp) over (partition by City_Name) as '40 Percentile Temp',
Percentile_Disc(0.6) within group (order by Average_Temp) over (partition by City_Name) as '60 Percentile Temp'
from Project_view 
order by State_name


/*Q13*/
select A.City_Name, A.[Day of the Year], avg(cast (A.Average_Temp as float)) over (partition by A.City_Name 
order by A.[Day of the Year] rows between 3 preceding and 1 following) as Rolling_Average_Temp
from (select DISTINCT City_Name, datepart(DY, Date_Local) as 'Day of the Year', avg(cast (Average_Temp as float)) as Average_Temp 
from Project_view
group by City_Name, datepart(DY, Date_Local))A

