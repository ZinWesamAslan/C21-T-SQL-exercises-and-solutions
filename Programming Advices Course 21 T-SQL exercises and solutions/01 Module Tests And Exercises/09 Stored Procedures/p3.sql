-- Business Scenario:
-- An administrative panel requires a procedure to update the number of doors for a specific vehicle.
-- Write a Stored Procedure named 'SP_UpdateVehicleDoors' that takes the Vehicle ID and the new door count as parameters, 
-- performs the update, and checks if any row was actually affected.

-- Solution:
CREATE PROCEDURE SP_UpdateVehicleDoors
    @VehicleID INT,
    @NewDoors INT
AS
BEGIN
    UPDATE VehicleDetails
    SET NumDoors = @NewDoors
    WHERE ID = @VehicleID;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Warning: No vehicle found with the specified ID.';
    END
    ELSE
    BEGIN
        PRINT 'Vehicle doors updated successfully.';
    END
END;
GO

-- How to execute it:
EXEC SP_UpdateVehicleDoors @VehicleID = 5, @NewDoors = 4;