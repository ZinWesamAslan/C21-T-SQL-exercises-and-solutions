-- Business Scenario:
-- Write administrative T-SQL commands to:
-- 1. Safely drop the procedure 'sp_SafeRegisterVehicle' if it exists.
-- 2. Inspect the text definition of an existing stored procedure using `sp_helptext`.

-- Solution:
-- 1. Safe Drop Procedure
IF OBJECT_ID('sp_SafeRegisterVehicle', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_SafeRegisterVehicle;
    PRINT 'Procedure sp_SafeRegisterVehicle successfully dropped.';
END;
GO

-- 2. Inspect Source Definition
EXEC sp_helptext 'sp_GetVehiclesPaged';