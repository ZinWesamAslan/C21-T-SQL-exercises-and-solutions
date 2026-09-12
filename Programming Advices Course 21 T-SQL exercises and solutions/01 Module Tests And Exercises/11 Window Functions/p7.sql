-- Problem Scenario:
-- Show each vehicle's display name, year, and door count. 
-- Add a calculated window column showing the average door count for all vehicles produced in that same manufacturing year, 
-- and another column showing the difference between the individual vehicle's door count and that year's average.

-- Solution:
SELECT 
    Vehicle_Display_Name,
    Year,
    NumDoors,
    AVG(CAST(NumDoors AS FLOAT)) OVER (PARTITION BY Year) AS AvgDoorsForYear,
    NumDoors - AVG(CAST(NumDoors AS FLOAT)) OVER (PARTITION BY Year) AS DiffFromYearAvg
FROM VehicleDetails;