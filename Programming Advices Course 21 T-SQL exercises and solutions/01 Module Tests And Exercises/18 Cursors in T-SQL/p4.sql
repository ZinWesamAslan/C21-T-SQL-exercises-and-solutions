-- Problem Scenario:
-- An integration task requires sequential processing of vehicle records from start to end without backward scrolling.
-- Write an optimized FAST_FORWARD (or FORWARD_ONLY) cursor to achieve maximum execution speed and minimal memory overhead.

-- Solution:
DECLARE @VehicleID INT;
DECLARE @NumDoors INT;

-- FAST_FORWARD combines FORWARD_ONLY and READ_ONLY optimization
DECLARE cur_FastForwardVehicles CURSOR FAST_FORWARD FOR
SELECT ID, NumDoors
FROM VehicleDetails;

OPEN cur_FastForwardVehicles;

FETCH NEXT FROM cur_FastForwardVehicles INTO @VehicleID, @NumDoors;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Perform row-by-row batch logic
    IF @NumDoors IS NULL
    BEGIN
        PRINT 'Alert: Vehicle ID ' + CAST(@VehicleID AS VARCHAR(10)) + ' has unassigned door count.';
    END

    FETCH NEXT FROM cur_FastForwardVehicles INTO @VehicleID, @NumDoors;
END;

CLOSE cur_FastForwardVehicles;
DEALLOCATE cur_FastForwardVehicles;