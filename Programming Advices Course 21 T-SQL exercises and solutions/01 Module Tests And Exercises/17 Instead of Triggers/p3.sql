/*
==================================================================================================
BUSINESS SCENARIO:
When a user updates the 'Make' text column through 'vw_VehicleFullDetails', SQL Server fails 
because 'Make' belongs to the parent 'Makes' table while 'Vehicle_Display_Name' belongs to 
'VehicleDetails'. Create an INSTEAD OF UPDATE trigger on the view to route updates to their 
respective target tables correctly.
==================================================================================================
*/

CREATE TRIGGER trg_InsteadOfUpdate_VehicleView
ON vw_VehicleFullDetails
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update VehicleDetails columns
    IF UPDATE(Vehicle_Display_Name) OR UPDATE(Year) OR UPDATE(NumDoors)
    BEGIN
        UPDATE vd
        SET 
            vd.Vehicle_Display_Name = i.Vehicle_Display_Name,
            vd.Year = i.Year,
            vd.NumDoors = i.NumDoors
        FROM VehicleDetails vd
        JOIN Inserted i ON vd.ID = i.VehicleID;
    END

    -- Update Makes column if modified
    IF UPDATE(Make)
    BEGIN
        UPDATE m
        SET m.Make = i.Make
        FROM Makes m
        JOIN VehicleDetails vd ON m.MakeID = vd.MakeID
        JOIN Inserted i ON vd.ID = i.VehicleID;
    END
END;
GO