-- Task: Write a query using Nested CASE statements to classify vehicles based on 'Engine_Cylinders' and 'Year':
-- If cylinders = 8, check the year: if Year >= 2015, return 'Modern V8', else return 'Classic V8'.
-- If cylinders = 4, return 'Fuel Efficient 4-Cylinder'.
-- For all other cases, return 'Standard Vehicle'.
-- Select the vehicle name, cylinders, year, and this nested classification column.

SELECT 
    Vehicle_Display_Name,
    Engine_Cylinders,
    Year,
    CASE 
        WHEN Engine_Cylinders = 8 THEN 
            CASE 
                WHEN Year >= 2015 THEN 'Modern V8'
                ELSE 'Classic V8'
            END
        WHEN Engine_Cylinders = 4 THEN 'Fuel Efficient 4-Cylinder'
            ELSE 'Standard Vehicle'
    END AS DetailedVehicleClassification
FROM VehicleDetails order by year;