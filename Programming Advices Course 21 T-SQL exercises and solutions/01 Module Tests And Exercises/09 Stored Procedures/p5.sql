-- Business Scenario:
-- During deployment and debugging, database administrators often need to safely drop existing procedures before recreating them, 
-- or inspect the exact source text of a stored procedure stored on the server without opening the creation script file.
-- Write the T-SQL commands to:
-- 1. Safely drop the procedure 'SP_GetVehiclesByYear' if it exists.
-- 2. Use the system utility command to view the text/definition of an existing procedure like 'SP_AddNewMake'.

-- Solution:
-- 1. Safely drop procedure if it exists
IF OBJECT_ID('SP_GetVehiclesByYear', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE SP_GetVehiclesByYear;
    PRINT 'Procedure dropped successfully.';
END;
GO

-- 2. Inspect the source text definition of a stored procedure using system commands
EXEC sp_helptext 'SP_AddNewMake';