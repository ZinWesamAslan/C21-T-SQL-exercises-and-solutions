-- Business Scenario:
-- An interviewer asks you to compute the ratio/percentage of doors a specific vehicle model has 
-- compared to the overall sum of doors for all vehicles manufactured in that same year.
-- Show how windowed SUM() OVER (PARTITION BY Year) allows you to 
-- compare row-level values against aggregated totals.












-- Solution:
SELECT 
    Vehicle_Display_Name,
    Year,
    NumDoors,
    SUM(NumDoors) OVER (PARTITION BY Year) AS TotalDoorsInYear,
    ROUND(
        (CAST(NumDoors AS FLOAT) / NULLIF(SUM(NumDoors) OVER (PARTITION BY Year), 0)) * 100, 
        2
    ) AS DoorPercentageOfYearTotal
FROM VehicleDetails;