-- Task: Write a query using a Searched CASE statement to categorize vehicles based on their production 'Year' 
-- into a new column named 'VehicleEra':
-- If Year >= 2020, return 'Modern Era'.
-- If Year >= 2010 and Year < 2020, return 'Recent Era'.
-- Otherwise, return 'Classic Era'.
-- Select the vehicle name and this new category.

SELECT 
    Vehicle_Display_Name,
    Year,
    CASE 
        WHEN Year >= 2020 THEN 'Modern Era'
        WHEN Year >= 2010 AND Year < 2020 THEN 'Recent Era'
        ELSE 'Classic Era'
    END AS VehicleEra
FROM VehicleDetails;