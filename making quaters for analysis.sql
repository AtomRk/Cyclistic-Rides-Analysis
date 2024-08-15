Use cyclistic_data;

# Creating temporary table for quater 1 or 2 or 3 or 4
create temporary table a1 AS

Select 
	*
From (
	select  * from may_2023_ridedata
union all
	select  *  from june_2023_ridedata
union all
	select  *  from july_2023_ridedata) as summary;
    
create temporary table a2 AS 

Select 
	*
From (
	select  *  from august_2023_ridedata
union all	
	select  *  from september_2023_ridedata
union all	   
	select  *  from october_2023_ridedata
) as summary;

create temporary table a3 AS 

Select 
	*
From (
	select  *  from december_2023_ridedata
union all	
	select  *  from january_2024_ridedata
union all	
	select  *  from february_2024_ridedata) as summary;

create temporary table a4 AS 

Select 
	*   
From ( 
	select  *  from march_2024_ridedata
union all	
	select  *  from april_2024_ridedata
union all	
	select  *  from november_2023_ridedata
) as summary;

# Performing calculations on field in temporary table

Select
	Year(started_at) as year,
	month(started_at) as month,
	weekday(started_at) as weekday,
    Count(member_casual) as ride_count,
	member_casual as subscription,
	rideable_type as bike_type,
	Time_format(sec_to_time(Avg(Time_to_sec(ride_length))), '%H:%i:%s') as avg_ride_length
from 
	temporary_table_name
group by year, month, weekday,member_casual,rideable_type
order by year, month, weekday,member_casual;

# Saving temporary table output in permanent table

create table permanent_table_name as
Select
	Year(started_at) as year,
	month(started_at) as month,
	weekday(started_at) as weekday,
    Count(member_casual) as ride_count,
	member_casual as subscription,
	rideable_type as bike_type,
	Time_format(sec_to_time(Avg(Time_to_sec(ride_length))), '%H:%i:%s') as avg_ride_length
from 
	temporary_table_name
group by year, month, weekday,member_casual,rideable_type
order by year, month, weekday,member_casual;

# Checking each quaters of data
select * from q1;
select * from q2;
select * from q3;
select * from q4;

## Creating final output data

Create table may_2023_to_april_2024_ride_data as
Select 
	year, 
        Case month
        When 1 Then "January"
        When 2 Then "February"
        When 3 Then "March"
        When 4 Then "April"
        When 5 Then "May"
        When 6 Then "June"
        When 7 Then "July"
		When 8 Then "August"
		When 9 Then "September"
		When 10 Then "October"
		When 11 Then "November"
        When 12 Then "December"
	End as month, 
    subscription, 
    Case weekday
		When 0 Then "Monday"
        When 1 Then "Tuesday"
        When 2 Then "Wednesday"
        When 3 Then "Thrusday"
        When 4 Then "Friday"
        When 5 Then "Saturday"
        When 6 Then "Sunday"
	End as weekday, 
    bike_type, 
    ride_count, 
    avg_ride_length
From (
	select  *  from q1
union all
	select  *  from q2
union all
	select  *  from q3
union all
	select  *  from q4) as summary
Order by 
	year, 
    month, 
    weekday, 
    avg_ride_length;
    
# Checking final output
Select * From may_2023_to_april_2024_ride_data;
    
# Optional Cleanining table

Drop Table may_2023_ride_data;
Drop Table june_2023_ride_data;
Drop Table july_2023_ride_data;
Drop Table august_2023_ride_data;
Drop Table september_2023_ride_data;
Drop Table october_2023_ride_data;
Drop Table november_2023_ride_data;
Drop Table december_2023_ride_data;
Drop Table january_2024_ride_data;
Drop Table february_2024_ride_data;
Drop Table march_2024_ride_data;
Drop Table april_2024_ride_data;