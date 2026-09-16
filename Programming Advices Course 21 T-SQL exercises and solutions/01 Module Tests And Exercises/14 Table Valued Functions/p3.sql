-- Business Scenario:
-- The reporting module needs to evaluate manufacturer diversity for a specific body style.
-- Write a query that JOINs the 'Makes' table with the ITVF 'fn_GetVehiclesFromYear(2020)' 
-- alongside 'FuelTypes' and 'DriveTypes' lookup tables to display:
-- Make, Vehicle_Display_Name, Year, FuelTypeName, and DriveTypeName for all modern vehicles.

-- Solution:
SELECT 
    m.Make,
    modern.Vehicle_Display_Name,
    modern.Year,
    ft.FuelTypeName,
    dt.DriveTypeName
FROM Makes m
JOIN dbo.fn_GetVehiclesFromYear(2020) modern ON m.MakeID = modern.MakeID
JOIN VehicleDetails vd ON modern.ID = vd.ID
LEFT JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID
LEFT JOIN DriveTypes dt ON vd.DriveTypeID = dt.DriveTypeID
ORDER BY m.Make, modern.Year DESC;