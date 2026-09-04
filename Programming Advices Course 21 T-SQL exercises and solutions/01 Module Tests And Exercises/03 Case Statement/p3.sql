-- Task: Write a query to select vehicle display names, years, and engine liter display.
-- Use a CASE statement inside the ORDER BY clause to perform custom sorting:
-- Prioritize rows where Engine_Liter_Display is greater than or equal to 3.0 first (sort them as 1), 
-- and all other engines as 2. Sort ascending by this custom order.

SELECT 
    Vehicle_Display_Name,
    Year,
    Engine_Liter_Display
FROM VehicleDetails
ORDER BY 
    CASE 
        WHEN Engine_Liter_Display >= 3.0 THEN 1 
        ELSE 2 
    END ASC,
    Year DESC;