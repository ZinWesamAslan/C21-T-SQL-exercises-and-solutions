-- Business Scenario:
-- Refactor a derived table subquery joining 'VehicleDetails', 'Makes', and 'FuelTypes' 
-- into a clean, highly readable CTE structure.

-- CTE Solution:
WITH FuelTypeVehicleStats AS (
    SELECT 
        MakeID,
        FuelTypeID,
        COUNT(ID) AS TotalVehicles
    FROM VehicleDetails
    GROUP BY MakeID, FuelTypeID
)
SELECT 
    m.Make,
    ft.FuelTypeName,
    ftvs.TotalVehicles
FROM FuelTypeVehicleStats ftvs
JOIN Makes m ON ftvs.MakeID = m.MakeID
JOIN FuelTypes ft ON ftvs.FuelTypeID = ft.FuelTypeID
WHERE ftvs.TotalVehicles > 2
ORDER BY m.Make, ftvs.TotalVehicles DESC;