-- Problem Scenario:
-- You need to process a row-by-row batch operation on 'VehicleDetails' where the underlying table might receive 
-- concurrent UPDATEs during execution. Declare a STATIC cursor to ensure the processing works on a fixed temporary copy (snapshot) 
-- of the data created at cursor open time, ignoring any external database changes made during iteration.

-- Solution:
DECLARE @VehicleID INT;
DECLARE @DisplayName VARCHAR(200);

-- STATIC cursor creates a copy in tempdb
DECLARE cur_StaticVehicles CURSOR STATIC FOR
SELECT ID, Vehicle_Display_Name
FROM VehicleDetails
WHERE Year >= 2024;

OPEN cur_StaticVehicles;

FETCH NEXT FROM cur_StaticVehicles INTO @VehicleID, @DisplayName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Processing Static Snapshot Record ID: ' + CAST(@VehicleID AS VARCHAR(10)) + ' - ' + @DisplayName;
    
    FETCH NEXT FROM cur_StaticVehicles INTO @VehicleID, @DisplayName;
END;

CLOSE cur_StaticVehicles;
DEALLOCATE cur_StaticVehicles;