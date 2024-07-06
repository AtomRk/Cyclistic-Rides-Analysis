# Cyclistic Rides Analysis
Analysing the subscriptions type data in a Cyclistic Ride Bike company.

### Project Overview

The primary objective of this data analysis project is to examine and gain insights into the riding behavior of Cyclistic Bike Share members across different membership types over the past 12 months. By analyzing various aspects of membership type rides, the project aims to identify trends, derive data-driven recommendations, and deepen our understanding of Cyclistic membership type riding behavior.

### Data Source

**Cyclistic Data:**
There are 12 datasets used for this project, which are present in the "Cyclistic Data.zip" file. This is a Google Data Analytics case study project. You can use other historical trip data from Cyclistic to analyze and identify trends. The Cyclistic trip data can be downloaded from [here](https://divvy-tripdata.s3.amazonaws.com/index.html).
(Note: The datasets have different names because Cyclistic is a fictional company. The data has been made available by Motivate International Inc. under this [license.](https://divvybikes.com/data-license-agreement))

**Final Dataset for Tableau Visualization:**
The dataset provided here is the final result after performing all calculations in MySQL. It has been thoroughly cleaned and prepared, making it ready for direct use in Tableau for data visualization purposes.

**MySQL Database File:**
This file enables MySQL users to directly utilize the database file in MySQL. Users who do not have MySQL can import each CSV file individually.

### Tools Used
- MySQL - Data cleaning and analysis
- Tableau - Creating reports and dashboard

### Data Preparation/ Cleaning

In the initial data preparation phase, following tasks were performed:
1. Data loading and inspection in SQL

   Each CSV dataset contains 13 columns and a significant number of rows, which could potentially increase data loading time in MySQL. To save loading time, consider the following tasks:
    
    1. **Disable the secure mode.**

       To disable secure mode in MySQL, follow these steps:
       a. Navigate to C:\ProgramData\MySQL\MySQL Server 8.0 and find the file named my.
       b. Open the my file and search for the keyword "secure".
       c. Locate the line containing secure_file_priv and comment it out by adding # at the beginning of the line.
       d. Copy the same line (without #) and set its value to secure_file_priv = "".
       e. Open the Start menu, search for "services", and open it.
       f. Locate the MySQL service, stop it, and then start it again to apply the changes.
       
    3. **Copying File**
       Copy all the csv files and paste in the “C:\Program Data\MySQL\MySQL Server 8.0\Data\ database_name” folder.

    4. **LOAD INFILE command**

4. Handling null and duplicate values
5. Data cleaning and formating





- 
