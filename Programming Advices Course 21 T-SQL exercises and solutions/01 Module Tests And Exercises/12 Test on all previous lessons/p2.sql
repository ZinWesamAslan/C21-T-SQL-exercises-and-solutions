-- Business Scenario:
-- Create a Stored Procedure named 'sp_SafeRegisterVehicle' that registers a new vehicle record 
-- while maintaining full 3-tier relational integrity across the hierarchy (Make -> Model -> SubModel -> VehicleDetails).
-- 
-- Requirements:
-- 1. Wrap the entire operation inside a single TRANSACTION with TRY...CATCH error handling.
-- 2. Step 1: Insert a new model record into 'MakeModels' for a given MakeID and capture its generated ID using SCOPE_IDENTITY().
-- 3. Step 2: Insert a new sub-model record into 'SubModels' linked to the newly created ModelID and capture its generated ID using SCOPE_IDENTITY().
-- 4. Step 3: Insert the comprehensive vehicle record into 'VehicleDetails' using both the new ModelID and SubModelID.
-- 5. If all steps succeed, COMMIT the transaction. If any step fails, perform a complete ROLLBACK and print the error message.

-- Solution:
CREATE PROCEDURE sp_SafeRegisterVehicle
    @MakeID INT,
    @ModelName VARCHAR(100),
    @SubModelName VARCHAR(100),
    @BodyID INT,
    @VehicleName VARCHAR(200),
    @Year INT,
    @DriveTypeID INT,
    @FuelTypeID INT,
    @NumDoors INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @NewModelID INT;
        DECLARE @NewSubModelID INT;

        -- Step 1: Insert into MakeModels
        INSERT INTO MakeModels (MakeID, ModelName)
        VALUES (@MakeID, @ModelName);

        SET @NewModelID = SCOPE_IDENTITY();

        -- Step 2: Insert into SubModels linked to the new ModelID
        INSERT INTO SubModels (ModelID, SubModelName)
        VALUES (@NewModelID, @SubModelName);

        SET @NewSubModelID = SCOPE_IDENTITY();

        -- Step 3: Insert into VehicleDetails linking both foreign keys
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
            @MakeID, 
            @NewModelID, 
            @NewSubModelID, 
            @BodyID, 
            @VehicleName, 
            @Year, 
            @DriveTypeID, 
            @FuelTypeID, 
            @NumDoors
        );

        COMMIT TRANSACTION;
        PRINT 'Cascading vehicle registration completed and committed successfully.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Transaction failed and changes were rolled back. Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO