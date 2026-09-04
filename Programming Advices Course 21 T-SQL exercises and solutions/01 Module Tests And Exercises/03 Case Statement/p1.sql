-- Task: Write a query that selects the vehicle display name and year from VehicleDetails.
-- Use a Simple CASE statement on the 'Engine_Cylinders' column to create a new column named 'CylinderSizeCategory':
-- If cylinders = 4, return '4-Cylinder'.
-- If cylinders = 6, return '6-Cylinder'.
-- If cylinders = 8, return 'V8 Engine'.
-- Otherwise, return 'Other'.

SELECT 
    Vehicle_Display_Name,
    Year,
    Engine_Cylinders,
    CASE Engine_Cylinders
        WHEN 4 THEN '4-Cylinder'
        WHEN 6 THEN '6-Cylinder'
        WHEN 8 THEN 'V8 Engine'
        ELSE 'Other'
    END AS CylinderSizeCategory
FROM VehicleDetails;