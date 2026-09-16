/*
==================================================================================================
BUSINESS SCENARIO:
Prevent users from deleting a manufacturer ('Makes') if it currently has active vehicles registered 
in 'VehicleDetails'. Create an INSTEAD OF DELETE trigger on the 'Makes' table that checks for 
child dependencies. If child records exist, block the operation with an error; otherwise, allow 
the deletion to proceed.
==================================================================================================
*/

CREATE TRIGGER trg_InsteadOfDelete_ValidateMakeDependencies
ON Makes
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if any selected Make has linked vehicles
    IF EXISTS (
        SELECT 1 
        FROM VehicleDetails vd
        JOIN Deleted d ON vd.MakeID = d.MakeID
    )
    BEGIN
        RAISERROR('Cannot delete Make: Active vehicle dependencies exist in VehicleDetails.', 16, 1);
        RETURN;
    END

    -- If no dependencies exist, perform the actual delete
    DELETE FROM Makes
    WHERE MakeID IN (SELECT MakeID FROM Deleted);
END;
GO