-- Task: Write a script with a TRY...CATCH block. 
-- Inside the TRY block, check if a specific vehicle ID (e.g., ModelID = 99999) exists in the MakeModels table. 
-- If it does not exist, use the THROW statement to raise a custom error with a specific error number (e.g., 50001) and message. 
-- Catch the error and print the error message.

BEGIN TRY
    DECLARE @CheckModelID INT = 99999;

    IF NOT EXISTS (SELECT 1 FROM MakeModels WHERE ModelID = @CheckModelID)
    BEGIN
        THROW 50001, 'The specified Model ID does not exist in the database.', 1;
    END
END TRY
BEGIN CATCH
    PRINT 'Caught Custom Error: ' + ERROR_MESSAGE();
END CATCH