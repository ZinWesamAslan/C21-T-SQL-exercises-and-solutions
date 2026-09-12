-- Problem Scenario:
-- Generate a report listing Vehicle Display Name, Year, and Fuel Type Name.
-- Include a column showing the total count of vehicles within that specific 
-- Fuel Type overall (without collapsing rows via GROUP BY),
-- and another column showing the running accumulated count of vehicles 
-- per Fuel Type ordered by Year ascending.

-- Solution:

SELECT 
    vd.Vehicle_Display_Name,
    vd.Year,
    ft.FuelTypeName,
    COUNT(*) OVER (PARTITION BY vd.FuelTypeID) AS TotalVehiclesInFuelType,
	-- that is new ...
    COUNT(*) OVER (PARTITION BY vd.FuelTypeID ORDER BY vd.Year ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotalVehicles
FROM VehicleDetails vd
JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID order by ft.FuelTypeID;