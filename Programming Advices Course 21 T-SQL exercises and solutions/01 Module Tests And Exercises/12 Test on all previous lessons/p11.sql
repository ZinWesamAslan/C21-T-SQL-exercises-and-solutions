/*
====================================================================================================
QUESTION / TASK REQUIREMENTS:
====================================================================================================
Create a T-SQL Stored Procedure named 'sp_FlexRegisterVehicle' to register a new vehicle record 
with flexible entity resolution, dynamic lookup, and strict transaction management.

REQUIREMENTS:
1. Flexible Entity Resolution (Make, Model, SubModel):
   - Accept either an explicit ID (@MakeID, @ModelID, @SubModelID) OR a Name (@MakeName, @ModelName, @SubModelName).
   - If an ID is missing, search for the corresponding record by Name within its parent scope:
     * Make is resolved globally.
     * Model is resolved under the resolved MakeID.
     * SubModel is resolved under the resolved ModelID.
   - If the name does not exist in the database, insert it as a new record and capture its generated ID.
   - If neither an ID nor a Name is provided for any entity level, raise a custom error (Severity 16).

2. Vehicle Registration:
   - Insert the vehicle record into the 'VehicleDetails' table using the resolved IDs and required attributes 
     (Vehicle_Display_Name, Year, BodyID, DriveTypeID, FuelTypeID, NumDoors).

3. Transaction & Error Management:
   - Wrap the entire operation in an explicit TRANSACTION to guarantee atomicity.
   - Implement TRY...CATCH error handling:
     * On Failure: Roll back all changes (ROLLBACK TRANSACTION), output an error message, and set @NewVehicleID = -1.
     * On Success: Commit the transaction, print a confirmation message, and return the newly generated VehicleID via the @NewVehicleID OUTPUT parameter.
====================================================================================================
*/

CREATE PROCEDURE sp_FlexRegisterVehicle
    -- Optional ID inputs (Pass NULL if you want to use/insert by Name)
    @MakeID INT = NULL,
    @ModelID INT = NULL,
    @SubModelID INT = NULL,

    -- Optional Name inputs (Pass NULL if you supplied the ID directly)
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
        ----------------------------------------------------
        -- STEP 1: Resolve Make (ID or Name Upsert)
        ----------------------------------------------------
        IF @MakeID IS NULL
        BEGIN
            IF @MakeName IS NULL
            BEGIN
                RAISERROR('Either @MakeID or @MakeName must be provided.', 16, 1);
            END

            -- Check if Make exists by Name
            SELECT @MakeID = MakeID 
            FROM Makes 
            WHERE Make = @MakeName;

            -- Insert if it does not exist
            IF @MakeID IS NULL
            BEGIN
                INSERT INTO Makes (Make)
                VALUES (@MakeName);

                SET @MakeID = SCOPE_IDENTITY();
            END
        END

        ----------------------------------------------------
        -- STEP 2: Resolve Model (ID or Name Upsert under Make)
        ----------------------------------------------------
        IF @ModelID IS NULL
        BEGIN
            IF @ModelName IS NULL
            BEGIN
                RAISERROR('Either @ModelID or @ModelName must be provided.', 16, 1);
            END

            -- Check if Model exists by Name under the resolved MakeID
            SELECT @ModelID = ModelID 
            FROM MakeModels 
            WHERE MakeID = @MakeID AND ModelName = @ModelName;

            -- Insert if it does not exist
            IF @ModelID IS NULL
            BEGIN
                INSERT INTO MakeModels (MakeID, ModelName)
                VALUES (@MakeID, @ModelName);

                SET @ModelID = SCOPE_IDENTITY();
            END
        END

        ----------------------------------------------------
        -- STEP 3: Resolve SubModel (ID or Name Upsert under Model)
        ----------------------------------------------------
        IF @SubModelID IS NULL
        BEGIN
            IF @SubModelName IS NULL
            BEGIN
                RAISERROR('Either @SubModelID or @SubModelName must be provided.', 16, 1);
            END

            -- Check if SubModel exists by Name under the resolved ModelID
            SELECT @SubModelID = SubModelID 
            FROM SubModels 
            WHERE ModelID = @ModelID AND SubModelName = @SubModelName;

            -- Insert if it does not exist
            IF @SubModelID IS NULL
            BEGIN
                INSERT INTO SubModels (ModelID, SubModelName)
                VALUES (@ModelID, @SubModelName);

                SET @SubModelID = SCOPE_IDENTITY();
            END
        END

        ----------------------------------------------------
        -- STEP 4: Insert Final Vehicle Details Record
        ----------------------------------------------------
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

        COMMIT TRANSACTION;
        PRINT 'Vehicle successfully registered with ID: ' + CAST(@NewVehicleID AS VARCHAR(10));

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewVehicleID = -1;
        PRINT 'Registration Failed. Transaction rolled back.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH
END;
GO