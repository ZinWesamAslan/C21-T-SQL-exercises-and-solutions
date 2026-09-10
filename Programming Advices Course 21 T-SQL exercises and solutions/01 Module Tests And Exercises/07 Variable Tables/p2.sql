-- Task: Declare a table variable named @YearlyStats with columns: VehicleYear (INT) and TotalVehicles (INT).
-- Populate this table variable by aggregating data from the VehicleDetails table, 
-- calculating the count of vehicles per Year for all years >= 2020.
-- Then, select from the table variable to display only the years where the total vehicles count is greater than 20.

DECLARE @YearlyStats TABLE (
    VehicleYear INT,
    TotalVehicles INT
);

INSERT INTO @YearlyStats (VehicleYear, TotalVehicles)
SELECT Year, COUNT(*)
FROM VehicleDetails
WHERE Year >= 2020
GROUP BY Year;

SELECT VehicleYear, TotalVehicles
FROM @YearlyStats
WHERE TotalVehicles > 20;