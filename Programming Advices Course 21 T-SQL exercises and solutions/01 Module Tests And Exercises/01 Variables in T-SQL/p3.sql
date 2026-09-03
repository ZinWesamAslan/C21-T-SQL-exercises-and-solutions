-- Task: Declare a variable named @SearchFuelType VARCHAR(50) and set it to 'GAS'. 
-- Write a report query using this variable to join VehicleDetails with FuelTypes to list the vehicle names, years, and fuel type names where the fuel type matches the variable.

DECLARE @SearchFuelType VARCHAR(50) = 'GAS';

SELECT 
    vd.Vehicle_Display_Name, 
    vd.Year, 
    ft.FuelTypeName
FROM VehicleDetails vd
JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID
WHERE ft.FuelTypeName LIKE '%' + @SearchFuelType + '%';