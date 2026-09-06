-- Task: Write a T-SQL transaction block using TRY...CATCH to update the Year of a vehicle in the VehicleDetails table. 
-- For example, update the Year to 2024 where ID = 1. 
-- Ensure that if the operation succeeds, it commits, and if an error occurs, it rolls back.

BEGIN TRY
	BEGIN TRANSACTION;
		UPDATE VehicleDetails
		SET Year = 2024
		WHERE ID = 1;

    COMMIT TRANSACTION;
		PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Transaction rolled back due to an error: ' + ERROR_MESSAGE();
END CATCH;
