-- Problem Scenario:
-- For each car Make, find the single most recently manufactured vehicle details entry based on Year descending.
-- Display the Make, Vehicle Display Name, and Year without dropping rows using traditional GROUP BY.

-- Solution:
WITH RankedVehicles AS (
    SELECT 
        m.Make,
        vd.Vehicle_Display_Name,
        vd.Year,
        ROW_NUMBER() OVER (PARTITION BY vd.MakeID ORDER BY vd.Year DESC, vd.ID DESC) AS RowNum
    FROM VehicleDetails vd
    JOIN Makes m ON vd.MakeID = m.MakeID
)
SELECT Make, Vehicle_Display_Name, Year
FROM RankedVehicles
WHERE RowNum = 1;