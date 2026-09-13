-- ===============================================================================================
-- STEP 1: Helper Procedure - Resolve Make (ID or Name Upsert)
-- ===============================================================================================
IF OBJECT_ID('sp_GetOrInsertMake', 'P') IS NOT NULL DROP PROCEDURE sp_GetOrInsertMake;
GO

CREATE PROCEDURE sp_GetOrInsertMake
    @MakeID INT OUTPUT,
    @MakeName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF @MakeID IS NULL
    BEGIN
        IF @MakeName IS NULL OR TRIM(@MakeName) = ''
        BEGIN
            RAISERROR('Either MakeID or MakeName must be provided.', 16, 1);
            RETURN;
        END

        SELECT @MakeID = MakeID 
        FROM Makes 
        WHERE Make = @MakeName;

        IF @MakeID IS NULL
        BEGIN
            INSERT INTO Makes (Make)
            VALUES (@MakeName);

            SET @MakeID = SCOPE_IDENTITY();
        END
    END
END;
GO


-- ===============================================================================================
-- STEP 2: Helper Procedure - Resolve Model (ID or Name Upsert under Make)
-- ===============================================================================================
IF OBJECT_ID('sp_GetOrInsertModel', 'P') IS NOT NULL DROP PROCEDURE sp_GetOrInsertModel;
GO

CREATE PROCEDURE sp_GetOrInsertModel
    @ModelID INT OUTPUT,
    @MakeID INT,
    @ModelName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF @ModelID IS NULL
    BEGIN
        IF @ModelName IS NULL OR TRIM(@ModelName) = ''
        BEGIN
            RAISERROR('Either ModelID or ModelName must be provided.', 16, 1);
            RETURN;
        END

        SELECT @ModelID = ModelID 
        FROM MakeModels 
        WHERE MakeID = @MakeID AND ModelName = @ModelName;

        IF @ModelID IS NULL
        BEGIN
            INSERT INTO MakeModels (MakeID, ModelName)
            VALUES (@MakeID, @ModelName);

            SET @ModelID = SCOPE_IDENTITY();
        END
    END
END;
GO


-- ===============================================================================================
-- STEP 3: Helper Procedure - Resolve SubModel (ID or Name Upsert under Model)
-- ===============================================================================================
IF OBJECT_ID('sp_GetOrInsertSubModel', 'P') IS NOT NULL DROP PROCEDURE sp_GetOrInsertSubModel;
GO

CREATE PROCEDURE sp_GetOrInsertSubModel
    @SubModelID INT OUTPUT,
    @ModelID INT,
    @SubModelName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF @SubModelID IS NULL
    BEGIN
        IF @SubModelName IS NULL OR TRIM(@SubModelName) = ''
        BEGIN
            RAISERROR('Either SubModelID or SubModelName must be provided.', 16, 1);
            RETURN;
        END

        SELECT @SubModelID = SubModelID 
        FROM SubModels 
        WHERE ModelID = @ModelID AND SubModelName = @SubModelName;

        IF @SubModelID IS NULL
        BEGIN
            INSERT INTO SubModels (ModelID, SubModelName)
            VALUES (@SubModelID, @SubModelName);

            SET @SubModelID = SCOPE_IDENTITY();
        END
    END
END;
GO


-- ===============================================================================================
-- STEP 4: Helper Procedure - Insert Final Vehicle Details
-- ===============================================================================================
IF OBJECT_ID('sp_InsertVehicleDetails', 'P') IS NOT NULL DROP PROCEDURE sp_InsertVehicleDetails;
GO

CREATE PROCEDURE sp_InsertVehicleDetails
    @MakeID INT,
    @ModelID INT,
    @SubModelID INT,
    @BodyID INT,
    @Vehicle_Display_Name VARCHAR(200),
    @Year INT,
    @DriveTypeID INT,
    @FuelTypeID INT,
    @NumDoors INT,
    @NewVehicleID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

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
        @ModelID, 
        @SubModelID, 
        @BodyID, 
        @Vehicle_Display_Name, 
        @Year, 
        @DriveTypeID, 
        @FuelTypeID, 
        @NumDoors
    );

    SET @NewVehicleID = SCOPE_IDENTITY();
END;
GO


-- ===============================================================================================
-- STEP 5: Main Orchestrator Procedure - FlexRegisterVehicle
-- ===============================================================================================
IF OBJECT_ID('sp_FlexRegisterVehicle', 'P') IS NOT NULL DROP PROCEDURE sp_FlexRegisterVehicle;
GO

CREATE PROCEDURE sp_FlexRegisterVehicle
    -- Optional IDs
    @MakeID INT = NULL,
    @ModelID INT = NULL,
    @SubModelID INT = NULL,

    -- Optional Names
    @MakeName VARCHAR(100) = NULL,
    @ModelName VARCHAR(100) = NULL,
    @SubModelName VARCHAR(100) = NULL,

    -- Required Vehicle Details
    @Vehicle_Display_Name VARCHAR(200),
    @Year INT,
    @BodyID INT,
    @DriveTypeID INT,
    @FuelTypeID INT,
    @NumDoors INT,

    -- Output Parameter
    @NewVehicleID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Step 1: Resolve Make
        EXEC sp_GetOrInsertMake 
            @MakeID = @MakeID OUTPUT, 
            @MakeName = @MakeName;

        -- Step 2: Resolve Model
        EXEC sp_GetOrInsertModel 
            @ModelID = @ModelID OUTPUT, 
            @MakeID = @MakeID, 
            @ModelName = @ModelName;

        -- Step 3: Resolve SubModel
        EXEC sp_GetOrInsertSubModel 
            @SubModelID = @SubModelID OUTPUT, 
            @ModelID = @ModelID, 
            @SubModelName = @SubModelName;

        -- Step 4: Insert Final Vehicle Record
        EXEC sp_InsertVehicleDetails 
            @MakeID = @MakeID,
            @ModelID = @ModelID,
            @SubModelID = @SubModelID,
            @BodyID = @BodyID,
            @Vehicle_Display_Name = @Vehicle_Display_Name,
            @Year = @Year,
            @DriveTypeID = @DriveTypeID,
            @FuelTypeID = @FuelTypeID,
            @NumDoors = @NumDoors,
            @NewVehicleID = @NewVehicleID OUTPUT;

        COMMIT TRANSACTION;
        PRINT 'Vehicle registration completed successfully. Generated ID: ' + CAST(@NewVehicleID AS VARCHAR(10));

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewVehicleID = -1;
        PRINT 'Registration failed. All changes rolled back.';
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- ===============================================================================================
-- TEST EXECUTION BLOCK
-- ===============================================================================================
DECLARE @OutputVehicleID INT;

EXEC sp_FlexRegisterVehicle
    @MakeName = 'Polestar',
    @ModelName = 'Polestar 3',
    @SubModelName = 'Long Range Dual Motor',
    @Vehicle_Display_Name = 'Polestar 3 Long Range 2026',
    @Year = 2026,
    @BodyID = 2,
    @DriveTypeID = 3,
    @FuelTypeID = 4,
    @NumDoors = 5,
    @NewVehicleID = @OutputVehicleID OUTPUT;

SELECT @OutputVehicleID AS NewVehicleDetailsID;