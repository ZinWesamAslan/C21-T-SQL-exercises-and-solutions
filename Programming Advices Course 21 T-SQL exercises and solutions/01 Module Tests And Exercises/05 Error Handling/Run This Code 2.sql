BEGIN TRY
    PRINT '1. Start of Outer TRY block';

    BEGIN TRY
        PRINT '2. Start of Inner TRY block';
        
        -- Throw an error inside the inner block
        THROW 51000, 'Error from the inner block!', 1;

        PRINT '3. This statement will never execute';
    END TRY

    BEGIN CATCH
        PRINT '4. Error caught in Inner CATCH block';
        PRINT 'Error message: ' + ERROR_MESSAGE();

        -- Re-throw the error to pass it to the outer block
        THROW; 
    END CATCH

    PRINT '5. This statement will not execute due to the re-thrown error';
END TRY
BEGIN CATCH
    PRINT '6. Error caught in Outer CATCH block';
    PRINT 'Final error message: ' + ERROR_MESSAGE();
END CATCH