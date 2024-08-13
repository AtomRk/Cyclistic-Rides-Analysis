# Cyclistic Rides Analysis
Analysing the subscriptions type data in a Cyclistic Ride Bike company.

### Project Overview

The primary objective of this data analysis project is to examine and gain insights into the riding behavior of Cyclistic Bike Share members across different membership types over the past 12 months. By analyzing various aspects of membership type rides, the project aims to identify trends, derive data-driven recommendations, and deepen our understanding of Cyclistic membership type riding behavior.

### Data Source

#### **Cyclistic Data:**

There are 12 datasets used for this project, which are present in the "Cyclistic Data.zip" file. This is a Google Data Analytics case study project. You can use other historical trip data from Cyclistic to analyze and identify trends. The Cyclistic trip data can be downloaded from [here](https://divvy-tripdata.s3.amazonaws.com/index.html).
(Note: The datasets have different names because Cyclistic is a fictional company. The data has been made available by Motivate International Inc. under this [license.](https://divvybikes.com/data-license-agreement))

#### **Final Dataset for Tableau Visualization:**

The dataset provided here is the final result after performing all calculations in MySQL. It has been thoroughly cleaned and prepared, making it ready for direct use in Tableau for data visualization purposes.

#### **MySQL Database File:**

This file enables MySQL users to directly utilize the database file in MySQL. Users who do not have MySQL can import each CSV file individually.

### Tools Used
- MySQL - Data cleaning and analysis
- Tableau - Creating reports and dashboard

### Data Preparation/ Cleaning

In the initial data preparation phase, following tasks were performed:

1. **Data loading and inspection in SQL**

   Each CSV dataset contains 13 columns and a significant number of rows, which could potentially increase data loading time in MySQL. To save loading time, consider the following tasks:
    
    1. **Disable the secure mode.**

       To disable secure mode in MySQL, follow these steps:
       
       1. Navigate to C:\ProgramData\MySQL\MySQL Server 8.0 and find the file named my.
       2. Open the my file and search for the keyword "secure".
       3. Locate the line containing secure_file_priv and comment it out by adding # at the beginning of the line.
       4. Copy the same line (without #) and set its value to secure_file_priv = "".
       5. Open the Start menu, search for "services", and open it.
       6. Locate the MySQL service, stop it, and then start it again to apply the changes.
       
    2. **Copying File**

       To copy all CSV files into your MySQL database's directory, locate the CSV files on your computer, copy them, then navigate to **C:\ProgramData\MySQL\MySQL Server 8.0\Data\database_name** (replace database_name with your database's actual name) and paste them there.

    3. **Create database in SQL**
       
       In order to import the files into MySQL, a database needs to be created first.
       
       ```
       Create Database database_name;
       Use database_name;
       ```
       With the **USE** statement, you will not need to include the database name with the table name in future queries.

    4. **LOAD INFILE command**

       Load CSV files into MySQL using LOAD DATA INFILE statement. Here’s an syntax:
           
       ```
       LOAD DATA INFILE ‘filename.csv' INTO TABLE database_name.table_name
       Fields terminated by ','
       Ignore 1 lines;
       ```
       Replace the placeholders with your specific details:
       
      - **database_name:**  Replace with the name of the MySQL database name.
      - **table_name:** Replace with the name of the MySQL table where you want to import the data.
      - **FIELDS TERMINATED BY ','**: Adjust if your CSV file uses a different delimiter.
      - **IGNORE 1 LINES:** Remove this line if your CSV file does not have a header row.

        You need to run this SQL statement separately for each CSV file you want to import into your MySQL database. Adjust the paths, table names, and options as per your specific setup and CSV file structure.

      5. **Data Cleaning**

         When you import your data, it is not cleaned to check for null or duplicate values. Additionally, the dates in the dataset are not in datetime format. We need some cleaning and formatting of the data to perform further actions. The syntax is as follows:

         ```
            # Removing "" from Data
            UPDATE table_name
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
            Update table_name
            Set
               ended_at = str_to_date(ended_at,"%Y-%m-%d %H:%i:%s"),
               started_at = str_to_date(started_at,"%Y-%m-%d %H:%i:%s");
             
            # Converting the datatype
            Alter table table_name
            Modify ended_at timestamp NOT NULL,
            Modify started_at timestamp NOT NULL;
         ```
         We need to clean and format each dataset using the above syntax, simply by replacing the table name.

1. **Handling null and duplicate values**

   - Run the below code to check null/ blank values

     ```
     # Return null or blank values
     select column_name
     from table_name
     where
           column1_name IS NULL OR column1_name = ""
        OR
           column2_name IS NULL OR column2_name = ""
        OR
           .
           .
           ColumnN_name IS NULL OR columnN_name = "" ; -- Repeat for each column as needed
     ```

     Check each required column in the dataset for null or blank values and delete them, using the following syntax:

     ```
     # Deleting null or blank values
     Delete from table_name
     where
           column1_name IS NULL OR column1_name = ""
        OR
           column2_name IS NULL OR column2_name = ""
        OR
           .
           .
           ColumnN_name IS NULL OR columnN_name = "" ; -- Repeat for each column as needed
     ```

     **Note** - The data will be deleted permanently from the table if the commit statement is not used. Use the COMMIT statement before the DELETE statement.
     
   - Run the below code to check duplicate values

     Checking duplicate values:

     ```
     Select
        column_name,
        count(column_name) as duplicate_value
     from table_name
     group by column_name
     Having count(column_name)>1;
     ```
     In this case, we only need to check for duplicate values of ride_id, and there should be none, as ride_id is unique for all rides. If any duplicates are found, we will remove them in the next step.
   
2. **Data cleaning and formating**

   In this step, we will create a new table that combines data from required columns and performs calculations. Additionally, duplicate values of ride_id will be cleaned. The syntax is as follows:

   ```
   # Before combining, I have created a new table for each dataset with required fields and calculations.
   ## The syntax remains the same for all; you only need to change the table names each time before executing the code.
   ### This is important because with the large volume of data in each dataset and the calculations involved, runtime error may occur when joining the datasets.
   
   Create table create_table_name as
   
   Select
      distinct(ride_id) as ride_id,
      rideable_type,
      member_casual,
      started_at,
      ended_at,
      Time_format(sec_to_time(timestampdiff(Second,started_at,ended_at)), '%H:%i:%s') as ride_length,
   
   From 
   	table_name_dataset
   
   Where
      timediff(ended_at,started_at) > '00:00:10'
   
   And
      month(ended_at) = month(started_at)
   
   Order by ride_length desc;
   ```
   You might encounter an error: **error 1292**. This error is because of time difference in where clause. If this is the case then below syntax will help to tackle that error:

   ```
   # Creating temporary table to store time difference values
   
   create temporary table temporary_table_name as

   Select
      distinct(ride_id) as ride_id,
      rideable_type,
      member_casual,
      started_at,
      ended_at,
      timestampdiff(Second,started_at,ended_at) as ride_length,
   
   From 
   	table_name_dataset
       
   Where
      month(ended_at) = month(started_at)
   
   Order by ride_length desc;

   # Storing the temporary table data in original table in the database
   
   create table create_table_name as
   
   Select
      ride_id,
      rideable_type,
      member_casual,
      started_at,
      ended_at,
      Time_format(sec_to_time(ride_length), '%H:%i:%s') as ride_length,
   
   From 
   	temporary_table_name
   
   Where ride_length>10 ;
   ```
   
   Our newly created datasets now have the required fields and calculations. Our data is ready for data analysis.

### Key Points in Data Cleaning Step

- We have calculated the ride length by subtracting **started_at** values from **ended_at** values.
- The difference between **started_at** and **ended_at** values includes date and time components. Therefore, we convert these difference values into seconds using the **SEC_TO_TIME** function.
- After converting the datetime values into seconds, we arrange these values in HH:MM:SS format using the **TIME_FORMAT** function.
- The ride length is calculated to be more than 10 seconds. This calculation also helps to remove negative values.
- The ride length calculations only include values where rides started and ended in the same month. This is achieved using a **WHERE** clause.

### Exploratory Data Analysis

In EDA process, we will explore the cyclistic data to answer key questions, such as:

- Overall riding behaviour of each member casual.
- Max ride count for each member casual.
- Mean ride lengh of each member casual.
- Max ride lengh of each member casual.
- What is the preferrable bike for each member casual?
- What is the preferrable day for each member casual?

### Data Analysis

This is the step where we analyze our dataset to find useful insights and answer business questions. We will perform all calculations in MySQL. Let's start the process by creating some temporary tables. The following syntax will create temporary tables:

   ```
   # Creating temporary table t1, t2, t3 and t4
   
   Create temporary table t1 AS
   
   Select 
   	*
   From (
   	select  * from may_2023_ridedata
   Union all
   	select  *  from june_2023_ridedata
   Union all
   	select  *  from july_2023_ridedata) as summary;

   Create temporary table t2 AS
   
    Select 
      	*
    From (
      	select  *  from august_2023_ridedata
    Union all	
      	select  *  from september_2023_ridedata
    Union all	   
      	select  *  from october_2023_ridedata
      ) as summary;

   Create temporary table t3 AS

   Select 
   	*
   From (
   	select  *  from december_2023_ridedata
   Union all	
   	select  *  from january_2024_ridedata
   Union all	
   	select  *  from november_2024_ridedata) as summary;

   Create temporary table t4 AS 

   Select 
   	*   
   From ( 
   	select  *  from march_2024_ridedata
   Union all	
   	select  *  from april_2024_ridedata
   Uion all	
   	select  *  from february_2023_ridedata
   ) as summary;
   ```

We have created four temporary tables: `t1`, `t2`, `t3`, and `t4`. Each of these tables contains combined data from all datasets.

After creating the temporary tables, it's time to perform interesting calculations and save them in these temporary tables. These calculations include:

   1. Extracting year, month, and weekday.
   2. Calculating the ride counts.
   3. Calculating the average ride duration.

These calculations will be saved in permanent tables `q1`, `q2`, `q3`, and `q4`. The following syntax will create these permanent tables:

   ```
   # Creating permanent `q1`, `q2`, `q3`, and `q4` tables to store values from temporary tables with the required calculations.
   ## You can create tables using the same syntax by replacing permanent_table_name with `q1`, `q2`, `q3`, and `q4`, and temporary_table_name with `t1`, `t2`, `t3`, and `t4`.
   ### After executing the process, you will have:
   
       # q1 table with t1 calculations,
       # q2 table with t2 calculations, and so on.
   
   Create table permanent_table_name as
   
   Select
      Year(started_at) as year,
      month(started_at) as month,
      weekday(started_at) as weekday,
      count(member_casual) as ride_count,
      member_casual as subscription,
      rideable_type as bike_type,
      Time_format(sec_to_time(Avg(Time_to_sec(ride_length))), '%H:%i:%s') as avg_ride_length
   
   From 
   	temporary_table_name
   
   Group by year, month, weekday,member_casual,rideable_type
   Order by year, month, weekday,member_casual;
 ```
Below is a sample output of one of the permanent tables:

![image](https://github.com/AtomRk/Cyclistic-Rides-Analysis/assets/165159709/385446a7-220d-417f-9c52-fc50d79477df)

There are some calculations that need to be done before joining the tables:

- Converting the month format into the full month name format (e.g., January, February, etc.).
- Converting the weekday format into the full weekday name format (e.g., Monday, Tuesday, etc.).

After performing these calculations, we can join all permanent tables into one table. Below is the syntax for calculations and joining tables:

 ```
   # Now, the final table we created will have all the values combined from q1, q2, q3, and q4.

   Create table final_output_data as
   
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
   ```

Below is the screenshot of the final output of the above SQL expression:

![image](https://github.com/AtomRk/Cyclistic-Rides-Analysis/assets/165159709/ebfec610-1371-4009-9091-f788b520f507)

We will use the Tableau for data visualization to answer key questions.

**Tableau Data Visualization:**

Tableau is a powerful tool for data visualization. Initially, we need to import data from a CSV file. In our case, it is the final data exported from MySQL in CSV format. Then, using Tableau, we have created an interactive dashboard that will help us find the answers to our key questions.

#### Tableau Dashboard:

1. **Data Manipulation:**

   When we import data into Tableau, our data will look like the screenshot below:

   <img src="https://github.com/AtomRk/Cyclistic-Rides-Analysis/assets/165159709/20da1565-1dca-473f-9340-14aac50d909c" width="300" height="300">
   
   The ride length is in date and time format, but we don't want dates with time in our data. Therefore, we will perform some calculations.

   1. Transforming the date and time (average ride length) into seconds.

      - Right-click on the **average ride length** column and click "**Create calculated field.**"
      - Now, enter the formula below:
        
        ```
        (DATETIME([Avg Ride Length]) - DATE([Avg Ride Length]))*86400
        ```
      - A new field will be created with the values in seconds.
      
   2. Transforming seconds into minutes.

      - The same steps will be followed, but this time we will perform calculations in the newly created calculated field.
      - Enter the formula below:

        ```
        [new field name]/60
        ```

   The final output will appear as shown in the screenshot below:

   <img src="https://github.com/AtomRk/Cyclistic-Rides-Analysis/assets/165159709/1fe07fdd-a4bc-44b4-80af-b22cc4eeff5c" width="300" height="300">

   We have successfully added two new columns, and we now have all the data to create an interactive dashboard.

  3. Titles and Headings Formatting:

     **Title Formatting:**

      - Use a bold and slightly larger font size for titles to make them stand out.
      - Choose a clear and readable font type such as Arial, Helvetica, or Times New Roman.
      - Align titles to the center or left-align them for consistency.
   
     **Header Formatting:**

      - Use a smaller font size than titles but larger than regular text for headers.
      - Headers can be in bold or regular weight, depending on the hierarchy of information.
      - Consider using a different color or shading to distinguish headers from the main text.
      - Align headers consistently, typically left-aligned or centered within their section.
        
      **Font Type and Color:**

      - Stick to standard fonts that are easy to read on different devices.
      - Avoid using too many different font types in one document to maintain a professional appearance.
      - Use color sparingly for emphasis or to denote different sections, ensuring readability and accessibility.
        
      **Alignment:**

      - Align titles and headers consistently throughout the document.
      - Left-align or center-align titles and headers for a neat and organized appearance.
      - Ensure alignment complements the overall layout and design of the document.

  5. Charts:

     In this dashboard, I have used 5 different charts to represent data.

     - Pie Chart
     - Line Chart
     - Bar Chart
     - Square Chart
     - Circle Chart

  7. Filters:

     Filters are used to make the dashboard interactive. I have used 2 filters in this dashboard.

     - Weekdays
     - Month

  9. Key Findings:

     Highlights of the data is present at the top of dashboard. Some of the highlights will change as per the filters applied. I have included 7 key findings in this dashboard.

     - Total Ride Count
     - Max Ride Count
     - Average Ride Length
     - Busiest Day
     - Busiest Month
     - Top Choice Bike

**Dashboard**

Below is the screenshot of the dashboard:

![Cyclistic Dashboard](https://github.com/user-attachments/assets/3f018e20-f8e0-4421-842a-7694de1cfd74)


### Key Points

- There were more than 5 million rides taken by bike riders in the last 12 months with Cyclistic.
- Member riders account for 64.21% of the total rides, which is over 3 million rides.
- Casual riders account for 35.79% of the total rides, which is over 2 million rides.
- Member riders have a maximum ride count of 44,924 in a day using classic bikes, while casual riders have a maximum ride count of 37,353 in a day using classic bikes.
- The average ride length for member riders is 13 minutes, while casual riders have an average ride length of 41 minutes.
- The busiest day for member riders is Thursday, with over 500,000 rides, while for casual riders, it is Saturday, with over 400,000 rides.
- The busiest month for member riders is August, with a total ride count of over 400,000 rides. For casual riders, the busiest month is July, with a total ride count of over 300,000 rides.
- The most favored bike for members is the classic bike, with over 1 million rides, while the most favored bike for casual riders is the electric bike, also with over 1 million rides.

### Conclusion

- Both member and casual riders enjoy taking rides most during the summer season.
- Member riders prefer bike rides on weekdays (Monday through Friday).
- Casual riders prefer bike rides on weekends (Saturday and Sunday).
- Casual riders take longer rides compared to member riders.
- Casual riders use all types of bikes, but their first choice is electric bikes.
- Member riders use only classic and electric bikes, with their first choice being the classic bike.
