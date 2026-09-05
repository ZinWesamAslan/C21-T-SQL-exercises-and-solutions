-- Task: Write a TRY...CATCH block that triggers a conversion error 
-- (for example, trying to convert a non-numeric string to an integer, like SELECT CONVERT(INT, 'ABC');). 
-- Inside the CATCH block, use system error functions (ERROR_MESSAGE, ERROR_NUMBER, and ERROR_LINE) 
-- to display the details of the error.

BEGIN TRY
    -- Deliberate data conversion error
    SELECT CONVERT(INT, 'ABC');
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;
END CATCH