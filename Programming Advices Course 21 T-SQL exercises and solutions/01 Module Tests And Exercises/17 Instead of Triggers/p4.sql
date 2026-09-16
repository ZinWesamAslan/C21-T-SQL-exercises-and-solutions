/*
==================================================================================================
BUSINESS SCENARIO:
Once a vehicle record is registered, its manufacturing 'Year' and 'MakeID' are considered 
immutable (cannot be changed). Create an INSTEAD OF UPDATE trigger on 'VehicleDetails' that 
silently ignores updates attempted on 'Year' or 'MakeID', while allowing modifications 
to all other editable columns (like NumDoors or Vehicle_Display_Name).
==================================================================================================
*/

CREATE TRIGGER trg_InsteadOfUpdate_ProtectImmutableFields
ON VehicleDetails
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Apply updates ONLY to editable fields, keeping original MakeID and Year from Deleted
    UPDATE vd
    SET 
        vd.Vehicle_Display_Name = i.Vehicle_Display_Name,
        vd.BodyID = i.BodyID,
        vd.DriveTypeID = i.DriveTypeID,
        vd.FuelTypeID = i.FuelTypeID,
        vd.NumDoors = i.NumDoors
        -- MakeID and Year are intentionally excluded from the SET clause
    FROM VehicleDetails vd
    JOIN Inserted i ON vd.ID = i.ID;
END;
GO