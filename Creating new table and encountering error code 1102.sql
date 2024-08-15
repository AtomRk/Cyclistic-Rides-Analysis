Use database_name;

# Creating table to store the new output data after cleaning
Create table create_table_name as

Select
	ride_id, 
	rideable_type, 
	member_casual,
    started_at,
    ended_at,
    Time_format(sec_to_time(timestampdiff(Second,started_at,ended_at)), '%H:%i:%s') as ride_length,
    weekday(started_at) as week_day
From 
	table_name_dataset

where timediff(ended_at,started_at) > '00:00:10' and month(ended_at)=month(started_at)
order by ride_length desc;

# Incase of error 1292
## Creating temporary table to store time difference values

create temporary table temporary_table_name as

Select
	ride_id, 
	rideable_type, 
	member_casual,
    started_at,
    ended_at,
    timestampdiff(Second,started_at,ended_at) as ride_length,
    weekday(started_at) as week_day
From 
	table_name_dataset
    
where month(ended_at) = month(started_at)
order by ride_length desc;

# Storing the temporary table data in original table in the database 
create table create_table_name as
select
	ride_id, 
	rideable_type, 
	member_casual,
    started_at,
    ended_at,
	Time_format(sec_to_time(ride_length), '%H:%i:%s') as ride_length,
	week_day
from 
	temporary_table_name
where ride_length>10 ;

# Checking each table
select * from may_2023_ridedata;
select * from june_2023_ridedata;
select * from july_2023_ridedata;
select * from august_2023_ridedata;
select * from september_2023_ridedata;
select * from october_2023_ridedata;
select * from november_2023_ridedata;
select * from december_2023_ridedata;
select * from january_2024_ridedata;
select * from february_2024_ridedata;
select * from march_2024_ridedata;
select * from april_2024_ridedata;
    