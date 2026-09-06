-- Task: Write a transaction that performs a cascading multi-table operation considering the correct hierarchy.
-- 1. Insert a new model into MakeModels.
-- 2. Insert a sub-model into SubModels linked to that new model.
-- 3. Insert a vehicle record into VehicleDetails linked to that sub-model.
-- Wrap everything in a TRANSACTION with TRY...CATCH.

BEGIN TRANSACTION;

BEGIN TRY
    DECLARE @NewModelID INT;
    DECLARE @NewSubModelID INT;

    -- Step 1: Insert a new model
    INSERT INTO MakeModels (MakeID, ModelName)
    VALUES (3, 'Acura Test Model');

    SET @NewModelID = SCOPE_IDENTITY();

    -- Step 2: Insert a new sub-model linked to the model
    INSERT INTO SubModels (ModelID, SubModelName)
    VALUES (@NewModelID, 'Acura Test SubModel Base');

    SET @NewSubModelID = SCOPE_IDENTITY();

    -- Step 3: Insert vehicle details linked to the sub-model
    INSERT INTO VehicleDetails (MakeID, ModelID, SubModelID, BodyID, Vehicle_Display_Name, Year, DriveTypeID, FuelTypeID, NumDoors)
    VALUES (3, @NewModelID, @NewSubModelID, 57, 'Acura Test Model 2026 Base', 2026, 20, 14, 4);

    COMMIT TRANSACTION;
    PRINT 'Cascading insertion across all hierarchical tables completed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error encountered. Rolled back changes. Error: ' + ERROR_MESSAGE();
END CATCH;