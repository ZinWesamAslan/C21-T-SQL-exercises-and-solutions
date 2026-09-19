-- Problem Scenario:
-- Demonstrate how to chain multiple CTEs together in a single statement.
-- 1. First CTE ('ModernVehicles'): Filter vehicles manufactured in or after 2020.
-- 2. Second CTE ('MakeSummary'): Aggregate the count of modern vehicles per Make.
-- Final Query: Join 'MakeSummary' with the 'Makes' table to return Make name and modern vehicle count.

-- Solution:
WITH ModernVehicles AS (
    SELECT ID, MakeID, Year
    FROM VehicleDetails
    WHERE Year >= 2020
),
MakeSummary AS (
    SELECT MakeID, COUNT(ID) AS ModernCount
    FROM ModernVehicles
    GROUP BY MakeID
)
SELECT 
    m.Make,
    ms.ModernCount
FROM Makes m
JOIN MakeSummary ms ON m.MakeID = ms.MakeID
ORDER BY ms.ModernCount DESC;