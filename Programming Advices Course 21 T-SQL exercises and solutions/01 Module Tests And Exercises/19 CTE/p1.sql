-- Problem Scenario:
-- Calculate the average number of doors per Make, but only for Makes that have more than 5 vehicles registered in total.
-- Instead of using a complex HAVING clause or nested subquery, write a clean CTE named 'MakeDoorStats' 
-- to aggregate the totals first, then query the CTE.

-- Solution:
WITH MakeDoorStats AS (
    SELECT 
        m.MakeID,
        m.Make,
        COUNT(vd.ID) AS TotalVehicles,
        AVG(CAST(vd.NumDoors AS FLOAT)) AS AvgDoors
    FROM Makes m
    JOIN VehicleDetails vd ON m.MakeID = vd.MakeID
    GROUP BY m.MakeID, m.Make
)
SELECT 
    Make,
    TotalVehicles,
    ROUND(AvgDoors, 2) AS AvgDoorsFormatted
FROM MakeDoorStats
WHERE TotalVehicles > 5
ORDER BY TotalVehicles DESC;