/*Project Part-2*/

alter table AQS_Sites
add GeoLocation geography 

alter table AQS_Sites
add GEOCODE_LATITUDE geography 

alter table AQS_Sites
add GEOCODE_LONGITUDE geography 

go
if not exists(
    select *from sys.columns where Name = N'GeoLocation'and Object_ID = Object_ID(N'AQS_Sites'))
begin
    ALTER TABLE AQS_Sites ADD GeoLocation Geography NULL
end
go

UPDATE [dbo].[AQS_Sites]
SET [GeoLocation] = geography::Point([Latitude], [Longitude], 4326)

select geoLocation from aqs_Sites

declare @maryland geography
select @maryland = geoLocation from aqs_sites where State_Name = 'Maryland'

select distinct City_Name, State_Name, (geoLocation.STDistance(@maryland)/80000 ) as Distance
	from aqs_sites a
	where State_Name = 'New Jersey'

set quoted_identifier on
go
drop procedure if EXISTS [dbo].[as4283_Spring2023_calc_geo_distance]
go
create procedure [dbo].[as4283_Spring2023_calc_geo_distance] (
@longitude nvarchar(255),
@latitude  nvarchar(255),
@State	    varchar(255),
@rownum	    integer
)
AS
begin
declare @h geography
SET @h = geography::Point(@latitude, @longitude, 4326)
select top (@rownum) Site_Number,
	(Case When Local_Site_Name is null Then Site_Number + ' ' + City_Name ELSE
		(Case When Local_Site_Name = '' Then Site_Number + ' ' + City_Name ELSE
			Local_Site_Name end)end) as Local_Site_Name,
	address, City_Name, State_Name, Zip_Code, (geoLocation.STDistance(@h)) as "distance in meters", Latitude, Longitude, (geoLocation.STDistance(@h)*0.000621371)/55 as "Hours of Travel"
from [AQS_Sites]
where ([LATITUDE] <> '' and Site_Number = 0001 and State_Name = @State)
order BY Local_Site_Name
end
go


EXEC as4283_Spring2023_calc_geo_distance 
@latitude = '36.778261',
@longitude = '-119.417932',  
@State = 'California', 
@rownum = 30
go

EXEC as4283_Spring2023_calc_geo_distance 
@latitude = '44.963826',
@longitude = '-90.22855',  
@State = 'New Jersey', 
@rownum = 20