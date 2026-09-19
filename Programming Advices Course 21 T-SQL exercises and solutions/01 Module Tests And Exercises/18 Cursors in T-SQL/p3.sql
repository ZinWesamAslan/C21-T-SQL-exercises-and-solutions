-- Problem Scenario:
-- Demonstrate the behavior of a DYNAMIC cursor. 
-- Declare a DYNAMIC cursor over 'VehicleDetails' that dynamically reflects real-time row modifications 
-- or order changes made by other concurrent sessions while scrolling through the result set.

-- Solution:
DECLARE @VehicleID INT;
DECLARE @VehicleYear INT;

-- DYNAMIC cursor reflects real-time changes
DECLARE cur_DynamicVehicles CURSOR DYNAMIC FOR
SELECT ID, Year
FROM VehicleDetails
ORDER BY Year DESC;

OPEN cur_DynamicVehicles;

FETCH NEXT FROM cur_DynamicVehicles INTO @VehicleID, @VehicleYear;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Dynamic Fetch - Vehicle ID: ' + CAST(@VehicleID AS VARCHAR(10)) + ' | Year: ' + CAST(@VehicleYear AS VARCHAR(4));
    
    FETCH NEXT FROM cur_DynamicVehicles INTO @VehicleID, @VehicleYear;
END;

CLOSE cur_DynamicVehicles;
DEALLOCATE cur_DynamicVehicles;