/*
==================================================================================================
BUSINESS SCENARIO:
The security and compliance team requires an automated audit trail for every new vehicle added to
the database. Whenever a new row is inserted into 'VehicleDetails', a trigger must automatically 
capture the new VehicleID, log the action type as 'INSERT', and record the system user and timestamp 
into an audit table named 'VehicleAuditLog'.
==================================================================================================
*/

-- 1. Create the Audit Log Table
IF OBJECT_ID('VehicleAuditLog', 'U') IS NULL
BEGIN
    CREATE TABLE VehicleAuditLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        VehicleID INT NOT NULL,
        ActionType VARCHAR(20) NOT NULL,
        CreatedBy VARCHAR(100) NOT NULL,
        CreatedDate DATETIME DEFAULT GETDATE()
    );
END;
GO

-- 2. Create the AFTER INSERT Trigger
CREATE TRIGGER trg_AfterInsert_VehicleAudit ON VehicleDetails
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert audit records using the pseudo-table 'Inserted'
    INSERT INTO VehicleAuditLog (VehicleID, ActionType, CreatedBy)
    SELECT 
        i.ID, 
        'INSERT', 
        SYSTEM_USER
    FROM Inserted i;
END;
GO