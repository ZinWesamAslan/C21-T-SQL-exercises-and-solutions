/*
==================================================================================================
BUSINESS SCENARIO:
To comply with data privacy regulations, physical SQL DELETE statements executed against 
'VehicleDetails' must not remove rows from the disk. Create an INSTEAD OF DELETE trigger that 
intercepts delete commands and turns them into a Soft Delete by setting 'IsActive = 0' 
and recording a 'DeletedDate'.
==================================================================================================
*/

-- 1. Add Soft Delete tracking columns
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('VehicleDetails') AND name = 'IsActive')
BEGIN
    ALTER TABLE VehicleDetails ADD IsActive BIT DEFAULT 1, DeletedDate DATETIME NULL;
END;
GO

-- 2. Create the INSTEAD OF DELETE Trigger
CREATE TRIGGER trg_InsteadOfDelete_SoftDelete
ON VehicleDetails
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Intercept physical DELETE and execute UPDATE instead
    UPDATE vd
    SET 
        vd.IsActive = 0,
        vd.DeletedDate = GETDATE()
    FROM VehicleDetails vd
    JOIN Deleted d ON vd.ID = d.ID;
END;
GO