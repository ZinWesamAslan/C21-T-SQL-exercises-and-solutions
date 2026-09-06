-- Task: Write a transaction that attempts to update vehicle data, but includes a business rule validation. 
-- Update the number of doors to 4 for a specific vehicle ID (e.g., ID = 2). 
-- Use an IF condition to check if an unexpected condition occurs (or simulate checking a condition), 
-- and if so, manually trigger a ROLLBACK TRANSACTION and throw/print a custom error message. Otherwise, COMMIT TRANSACTION.

BEGIN TRANSACTION;

BEGIN TRY
    -- Perform an update
    UPDATE VehicleDetails
    SET NumDoors = 4
    WHERE ID = 2;

    -- Business logic check: simulate a rule where NumDoors cannot be 4 for a specific check (or check affected rows)
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No vehicle found to update.', 16, 1);
    END

    COMMIT TRANSACTION;
    PRINT 'Business validation passed, transaction committed.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
    END
    PRINT 'Business rule failed or error occurred. Transaction rolled back: ' + ERROR_MESSAGE();
END CATCH;
