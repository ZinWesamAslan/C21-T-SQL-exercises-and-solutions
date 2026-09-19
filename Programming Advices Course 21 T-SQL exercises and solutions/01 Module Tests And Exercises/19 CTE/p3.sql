-- Problem Scenario:
-- Generate a dynamic sequence of production years from 2015 up to 2026 using a Recursive CTE named 'YearSequence'.
-- Output the generated Year along with the total count of vehicles produced in each year by joining with 'VehicleDetails'.

-- Solution:
WITH YearSequence AS (
    -- Anchor Member
    SELECT 2015 AS ProductionYear
    
    UNION ALL
    
    -- Recursive Member
    SELECT ProductionYear + 1
    FROM YearSequence
    WHERE ProductionYear < 2026
)
SELECT 
    ys.ProductionYear,
    COUNT(vd.ID) AS TotalVehicles
FROM YearSequence ys
LEFT JOIN VehicleDetails vd ON ys.ProductionYear = vd.Year
GROUP BY ys.ProductionYear
ORDER BY ys.ProductionYear ASC;