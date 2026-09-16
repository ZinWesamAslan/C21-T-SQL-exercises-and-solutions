/*
==================================================================================================
BUSINESS SCENARIO:
Direct INSERT operations on complex Views that join multiple tables are blocked by SQL Server.
Create an INSTEAD OF INSERT trigger on the 'vw_VehicleFullDetails' view. When a client application
inserts a record into this view, the trigger intercepts the operation, checks/inserts the 'Makes' 
table if necessary, and then inserts the vehicle record into 'VehicleDetails'.
==================================================================================================
*/

-- 1. Create a multi-table view
IF OBJECT_ID('vw_VehicleFullDetails', 'V') IS NOT NULL DROP VIEW vw_VehicleFullDetails;
GO

CREATE VIEW vw_VehicleFullDetails AS
SELECT 
    vd.ID AS VehicleID,
    m.Make,
    vd.Vehicle_Display_Name,
    vd.Year,
    vd.NumDoors
FROM VehicleDetails vd
JOIN Makes m ON vd.MakeID = m.MakeID;
GO

-- 2. Create the INSTEAD OF INSERT Trigger on the View
CREATE TRIGGER trg_InsteadOfInsert_VehicleView
ON vw_VehicleFullDetails
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Intercept insert, resolve MakeID, and insert into underlying base table
    INSERT INTO VehicleDetails (MakeID, Vehicle_Display_Name, Year, NumDoors)
    SELECT 
        ISNULL(m.MakeID, 1), -- Fallback to Default MakeID if not matched
        i.Vehicle_Display_Name,
        i.Year,
        i.NumDoors
    FROM Inserted i
    LEFT JOIN Makes m ON i.Make = m.Make;
END;
GO