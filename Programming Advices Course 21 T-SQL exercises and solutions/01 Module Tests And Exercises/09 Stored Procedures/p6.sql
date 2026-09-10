-- Business Scenario:
-- An enterprise vehicle management system requires a robust, bulletproof Stored Procedure named 'SP_RegisterNewVehicleComplete'.
-- This procedure should handle a complete hierarchical registration workflow in a single atomic transaction:
-- 1. It accepts inputs for: MakeName, ModelName, SubModelName, Vehicle_Display_Name, Year, BodyID, DriveTypeID, FuelTypeID, and NumDoors.
-- 2. It must include an OUTPUT parameter named @NewVehicleID INT OUTPUT to return the newly generated primary key back to the caller.
-- 3. Inside the procedure (wrapped in a TRANSACTION and TRY...CATCH block):
--    - Check if the given MakeName already exists in the Makes table. If it does not exist, insert it and capture its new MakeID. If it exists, use its existing MakeID.
--    - Insert a new record into MakeModels using that MakeID, and capture the new ModelID.
--    - Insert a new record into SubModels using that ModelID, and capture the new SubModelID.
--    - Finally, insert a comprehensive record into VehicleDetails linking all these hierarchical IDs, and capture the final vehicle ID via SCOPE_IDENTITY() into the @NewVehicleID output parameter.
-- 4. If any step fails, roll back the entire transaction and catch/print the error message. Otherwise, commit successfully.

-- SOLUTION CODE:

CREATE PROCEDURE SP_RegisterNewVehicleComplete
    @MakeName VARCHAR(100),
    @ModelName VARCHAR(100),
    @SubModelName VARCHAR(100),
    @Vehicle_Display_Name VARCHAR(200),
    @Year INT,
    @BodyID INT,
    @DriveTypeID INT,
    @FuelTypeID INT,
    @NumDoors INT,
    @NewVehicleID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @CurrentMakeID INT;
        DECLARE @CurrentModelID INT;
        DECLARE @CurrentSubModelID INT;

        -- Step 1: Check or Insert Make
        SELECT @CurrentMakeID = MakeID 
        FROM Makes 
        WHERE Make = @MakeName;

        IF @CurrentMakeID IS NULL
        BEGIN
            INSERT INTO Makes (Make)
            VALUES (@MakeName);
            
            SET @CurrentMakeID = SCOPE_IDENTITY();
        END

        -- Step 2: Insert Model
        INSERT INTO MakeModels (MakeID, ModelName)
        VALUES (@CurrentMakeID, @ModelName);

        SET @CurrentModelID = SCOPE_IDENTITY();

        -- Step 3: Insert SubModel
        INSERT INTO SubModels (ModelID, SubModelName)
        VALUES (@CurrentModelID, @SubModelName);

        SET @CurrentSubModelID = SCOPE_IDENTITY();

        -- Step 4: Insert Vehicle Details and capture output ID
        INSERT INTO VehicleDetails (
            MakeID, 
            ModelID, 
            SubModelID, 
            BodyID, 
            Vehicle_Display_Name, 
            Year, 
            DriveTypeID, 
            FuelTypeID, 
            NumDoors
        )
        VALUES (
            @CurrentMakeID, 
            @CurrentModelID, 
            @CurrentSubModelID, 
            @BodyID, 
            @Vehicle_Display_Name, 
            @Year, 
            @DriveTypeID, 
            @FuelTypeID, 
            @NumDoors
        );

        SET @NewVehicleID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
        PRINT 'Vehicle registration completed successfully. New Vehicle ID: ' + CAST(@NewVehicleID AS VARCHAR(10));

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        SET @NewVehicleID = -1; -- Indicate failure
        PRINT 'Error encountered during vehicle registration. Transaction rolled back.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- How to execute and test this procedure with an OUTPUT parameter:
DECLARE @CreatedVehicleID INT;

EXEC SP_RegisterNewVehicleComplete
    @MakeName = 'Lucid Motors',
    @ModelName = 'Air Sapphire',
    @SubModelName = 'Performance AWD',
    @Vehicle_Display_Name = 'Lucid Air Sapphire 2026',
    @Year = 2026,
    @BodyID = 1,          -- Assuming a valid BodyID exists
    @DriveTypeID = 3,     -- Assuming a valid DriveTypeID exists
    @FuelTypeID = 5,      -- Assuming a valid FuelTypeID exists
    @NumDoors = 4,
    @NewVehicleID = @CreatedVehicleID OUTPUT;

SELECT @CreatedVehicleID AS ReturnedVehicleID;