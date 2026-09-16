/*
==================================================================================================
BUSINESS SCENARIO:
The inventory management team needs to track modifications made to vehicle door counts. 
Create an AFTER UPDATE trigger on 'VehicleDetails' that inspects whether the 'NumDoors' column 
was updated. If a change occurs, it must log the VehicleID, the old value (from 'Deleted'), 
the new value (from 'Inserted'), the user who modified it, and the execution timestamp into 'VehicleHistoryLog'.
==================================================================================================
*/

-- 1. Create the History Log Table
IF OBJECT_ID('VehicleHistoryLog', 'U') IS NULL
BEGIN
    CREATE TABLE VehicleHistoryLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        VehicleID INT NOT NULL,
        OldNumDoors INT,
        NewNumDoors INT,
        ModifiedBy VARCHAR(100) NOT NULL,
        ModifiedDate DATETIME DEFAULT GETDATE()
    );
END;
GO

-- 2. Create the AFTER UPDATE Trigger
CREATE TRIGGER trg_AfterUpdate_TrackDoorChanges
ON VehicleDetails
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Optimize execution by verifying if 'NumDoors' was actually modified
    IF UPDATE(NumDoors)
    BEGIN
        INSERT INTO VehicleHistoryLog (VehicleID, OldNumDoors, NewNumDoors, ModifiedBy)
        SELECT 
            i.ID,
            d.NumDoors AS OldNumDoors,
            i.NumDoors AS NewNumDoors,
            SYSTEM_USER
        FROM Inserted i
        JOIN Deleted d ON i.ID = d.ID
        WHERE i.NumDoors <> d.NumDoors; -- Log only actual value changes
    END
END;
GO