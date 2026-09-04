-- Task: Write a query that groups vehicles by their 'Year' (only for years >= 2020).
-- Use a CASE statement inside a SUM aggregation to count how many vehicles have 
-- exactly 4 cylinders versus other cylinder counts for each year.

SELECT 
    Year,
    SUM(CASE WHEN Engine_Cylinders = 4 THEN 1 ELSE 0 END) AS FourCylinderCount,
    SUM(CASE WHEN Engine_Cylinders <> 4 OR Engine_Cylinders IS NULL THEN 1 ELSE 0 END) AS OtherCylindersCount
FROM VehicleDetails
WHERE Year >= 2020
GROUP BY Year
ORDER BY Year DESC;