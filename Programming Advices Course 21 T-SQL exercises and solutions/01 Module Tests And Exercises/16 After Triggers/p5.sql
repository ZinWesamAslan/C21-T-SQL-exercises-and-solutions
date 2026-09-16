/*
==================================================================================================
BUSINESS SCENARIO:
To prevent accidental data loss, deleted vehicle records must be preserved for historical reference. 
Create an AFTER DELETE trigger on 'VehicleDetails' that automatically intercepts deleted rows 
from the 'Deleted' pseudo-table and archives their details into a separate table named 
'VehicleDetailsArchive' along with the deletion user and timestamp.
==================================================================================================
*/

-- 1. Create the Archive Table
IF OBJECT_ID('VehicleDetailsArchive', 'U') IS NULL
BEGIN
    CREATE TABLE VehicleDetailsArchive (
        ArchiveID INT IDENTITY(1,1) PRIMARY KEY,
        OriginalVehicleID INT NOT NULL,
        Vehicle_Display_Name VARCHAR(200),
        Year INT,
        DeletedBy VARCHAR(100) NOT NULL,
        DeletedDate DATETIME DEFAULT GETDATE()
    );
END;
GO

-- 2. Create the AFTER DELETE Trigger
CREATE TRIGGER trg_AfterDelete_ArchiveVehicle
ON VehicleDetails
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO VehicleDetailsArchive (OriginalVehicleID, Vehicle_Display_Name, Year, DeletedBy)
    SELECT 
        d.ID,
        d.Vehicle_Display_Name,
        d.Year,
        SYSTEM_USER
    FROM Deleted d;
END;
GO