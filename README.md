# Environmental and Crime Data Analysis Project

## Overview
This project involves analyzing environmental data (temperature and geographic information) and its relationship with crime data (gun-related incidents) to uncover trends and insights. The project is divided into three parts:

1. **Environmental Temperature Analysis**: Analyzing temperature data across states and cities, identifying anomalies, and deriving state and city rankings based on average temperatures.
2. **Geospatial Enhancements**: Adding geospatial capabilities to the environmental data using SQL Server's geography data type to calculate distances and travel times.
3. **Crime Data Integration and Analysis**: Incorporating crime data into the analysis to identify correlations between environmental factors and gun crimes within specific geographies.

## Technologies Used
- **Database Management**: Microsoft SQL Server
- **Geospatial Processing**: SQL Server's `geography` data type
- **Data Analysis**: SQL Queries and Views
- **ETL Processes**: Data cleaning and transformation techniques

---

## Process

### Part 1: Environmental Temperature Analysis
- **Objective**: Analyze temperature trends, detect anomalies, and rank states and cities based on temperature metrics.
- **Key Steps**:
  - Grouped and summarized temperature data by state and city.
  - Identified bad data entries and adjusted temperature columns.
  - Created a view to filter and organize clean data, ensuring the exclusion of invalid records.
  - Generated rolling averages, city rankings, and state percentile statistics.
  - Utilized Common Table Expressions (CTEs) and window functions to calculate state rankings and rolling averages.

### Part 2: Geospatial Enhancements
- **Objective**: Incorporate geospatial analysis capabilities into the existing environmental data.
- **Key Steps**:
  - Enhanced the `AQS_Sites` table by adding `GeoLocation`, `Latitude`, and `Longitude` fields as `geography` types.
  - Developed a stored procedure to calculate distances between locations and determine approximate travel times.
  - Executed distance calculations and location comparisons for states like California, New Jersey, and Maryland.

### Part 3: Crime Data Integration and Analysis
- **Objective**: Investigate the relationship between environmental data and gun-related crimes.
- **Key Steps**:
  - Integrated the `GunCrimes` table, adding geospatial fields for spatial analysis.
  - Linked crime data with environmental sites based on proximity using geospatial distance functions.
  - Analyzed trends in gun-related incidents across locations and years.
  - Applied window functions to rank cities by gun crime statistics.

---

## Key Outcomes
- Delivered a clean, organized view of temperature data with insights into trends and anomalies.
- Built robust geospatial data capabilities, supporting advanced analysis and distance-based queries.
- Combined environmental and crime datasets to explore potential correlations, highlighting specific areas for further investigation.

---

## How to Use
1. **Database Setup**: Import the SQL scripts into Microsoft SQL Server. Ensure required tables (`Temperature`, `AQS_Sites`, `GunCrimes`) are preloaded.
2. **Execute Scripts**: Run the scripts in the provided sequence to set up and populate views, stored procedures, and enhanced columns.
3. **Query and Analyze**: Use the provided views and procedures for querying insights and trends.
