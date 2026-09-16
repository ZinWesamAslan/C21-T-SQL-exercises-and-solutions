/*
==================================================================================================
BUSINESS SCENARIO:
To maintain clean database naming conventions, raw text inputs for vehicle display names must 
be automatically trimmed of leading/trailing spaces and converted to UPPERCASE before saving. 
Create an INSTEAD OF INSERT trigger on 'VehicleDetails' that intercepts the insert command, 
normalizes the text fields, checks for duplicates, and inserts clean data.
==================================================================================================
*/

CREATE TRIGGER trg_InsteadOfInsert_NormalizeVehicleData
ON VehicleDetails
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Clean string formatting and prevent duplicate inserts
    INSERT INTO VehicleDetails (
        MakeID, ModelID, SubModelID, BodyID, 
        Vehicle_Display_Name, Year, DriveTypeID, FuelTypeID, NumDoors
    )
    SELECT 
        i.MakeID, i.ModelID, i.SubModelID, i.BodyID,
        UPPER(TRIM(i.Vehicle_Display_Name)), -- Normalization
        i.Year, i.DriveTypeID, i.FuelTypeID, i.NumDoors
    FROM Inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM VehicleDetails vd 
        WHERE vd.MakeID = i.MakeID 
          AND vd.Vehicle_Display_Name = UPPER(TRIM(i.Vehicle_Display_Name))
          AND vd.Year = i.Year
    );
END;
GO