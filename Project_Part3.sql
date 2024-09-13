/*Project Part-3*/

IF NOT EXISTS(
	SELECT *
    FROM sys.columns
	WHERE Name =  '[dbo].[GunCrimes]'
	AND Object_ID = Object_ID('geolocation'))
UPDATE GunCrimes
SET geolocation = Geography::Point([Latitude], [Longitude], 4326)
select * from dbo.GunCrimes;
SELECT a.* FROM (SELECT Local_Site_Name, City_Or_County as City_Name, datepart(year, date) as Crime_Year, count(distinct(incident_ID)) as Shooting_Count
	FROM GunCrimes a, AQS_Sites b
	WHERE b.State_Name = 'Alaska'
	AND (a.GeoLocation.STDistance(b.GeoLocation)) <= 16000
	AND	a.state = 'Alaska' and Local_Site_Name is not null and Local_Site_Name <> ''
GROUP BY City_Or_County, datepart(year, date), Local_Site_Name) as a
ORDER BY City_Name, Crime_Year


/*Q5*/
SELECT Local_Site_Name, City_Or_County as City_Name, datepart(year, date) as Crime_Year, count((incident_ID)) as Shooting_Count,
	Dense_rank() over (partition by City_Name order by count((incident_ID)) asc) as Rank_Shooting
FROM GunCrimes a, AQS_Sites b
WHERE b.State_Name = 'Alaska'
AND (a.GeoLocation.STDistance(b.GeoLocation)) <= 16000
AND	a.state = 'Alaska' and Local_Site_Name is not null and Local_Site_Name <>''
GROUP BY City_Or_County, datepart(year, date), Local_Site_Name, City_Name
ORDER BY Shooting_Count
