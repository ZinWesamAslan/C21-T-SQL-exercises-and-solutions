-- Business Scenario:
-- Write a Stored Procedure 'sp_DeleteVehicleByID' that accepts @VehicleID INT and 
-- an OUTPUT parameter @DeletedVehicleName VARCHAR(200) OUTPUT.
-- The SP should fetch the display name into the output variable before deleting the record.
-- Use the RETURN statement to return 1 if successful, or 0 if the VehicleID was not found.

-- Solution:
CREATE PROCEDURE sp_DeleteVehicleByID
    @VehicleID INT,
    @DeletedVehicleName VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check existence
    IF NOT EXISTS (SELECT 1 FROM VehicleDetails WHERE ID = @VehicleID)
    BEGIN
        SET @DeletedVehicleName = NULL;
        RETURN 0; -- Failed / Not Found
    END

    -- Retrieve name before deletion
    SELECT @DeletedVehicleName = Vehicle_Display_Name
    FROM VehicleDetails
    WHERE ID = @VehicleID;

    -- Perform deletion
    DELETE FROM VehicleDetails
    WHERE ID = @VehicleID;

    RETURN 1; -- Success
END;
GO