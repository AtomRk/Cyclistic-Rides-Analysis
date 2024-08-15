# Once the statement is executed we don't need to use database name again and again.
Use cyclistic_data;

# Creating a table
## We will create multiple tables using same line of code
### We just need to change the column name

Create table june_2023_ride_data
(ride_id	varchar(40) NOT NULL,
rideable_type	varchar(40) NOT NULL,
started_at	varchar(40) NOT NULL,
ended_at	varchar(40) NOT NULL,
start_station_name	text,
start_station_id	varchar(40),
end_station_name	text,
end_station_id	varchar(40),
start_lat	varchar(40),
start_lng	varchar(40),
end_lat	varchar(40),
end_lng	varchar(40),
member_casual varchar(40) NOT NULL);

# Checking all fields
Select * from june_2023_ride_data;

# Checking if the secure mode is on or not
Select @@secure_file_priv;

# After disabling secure mode, loading csv file
Load Data Infile 'June_2023_tripdata.csv' into table june_2023_ride_data
Fields terminated by ','
Ignore 1 lines;

# Removing "" from Data
UPDATE june_2023_ride_data
SET 
	ride_id = REPLACE(ride_id, '"', ''),
	rideable_type = REPLACE(rideable_type, '"', ''),
	started_at = REPLACE(started_at, '"', ''),
	ended_at = REPLACE(ended_at, '"', ''),
	start_station_name = REPLACE(start_station_name, '"', ''),
	start_station_id = REPLACE(start_station_id, '"', ''),
	end_station_name = REPLACE(end_station_name, '"', ''),
	end_station_id = REPLACE(end_station_id, '"', ''),
	member_casual = REPLACE(member_casual, '"', '');
 
# Coverting string date into date datatype
Update june_2023_ride_data
Set ended_at = str_to_date(ended_at,"%Y-%m-%d %H:%i:%s"),
started_at = str_to_date(started_at,"%Y-%m-%d %H:%i:%s");
 
# Converting the datatype
Alter table june_2023_ride_data
Modify ended_at timestamp NOT NULL,
Modify started_at timestamp NOT NULL;
    
