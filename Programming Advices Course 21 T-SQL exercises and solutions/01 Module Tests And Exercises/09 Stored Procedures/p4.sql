-- Business Scenario:
-- When deleting a record from a core table (like a submodel), the system needs to report success or failure status back to the calling application.
-- Create a Stored Procedure named 'SP_DeleteSubModel' that accepts a SubModelID, attempts to delete it, 
-- and uses a `RETURN` statement with status codes (e.g., return 1 on success, return 0 if the record doesn't exist).

-- Solution:
CREATE PROCEDURE SP_DeleteSubModel
    @SubModelID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SubModels WHERE SubModelID = @SubModelID)
    BEGIN
        -- Record not found status
        RETURN 0; 
    END

    DELETE FROM SubModels 
    WHERE SubModelID = @SubModelID;

    -- Success status
    RETURN 1;
END;
GO

-- How to execute and check return status:
DECLARE @ResultStatus INT;
EXEC @ResultStatus = SP_DeleteSubModel @SubModelID = 999999;
PRINT 'Execution Status Code: ' + CAST(@ResultStatus AS VARCHAR(10));

