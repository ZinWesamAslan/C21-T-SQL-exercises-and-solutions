/*
==================================================================================================
BUSINESS SCENARIO:
A core business rule dictates that a vehicle's production year cannot be modified to a year 
earlier than its currently recorded production year. Create an AFTER UPDATE trigger on 'VehicleDetails' 
that compares the new year in 'Inserted' against the old year in 'Deleted'. If a reduction is 
detected, raise an error and roll back the entire transaction.
==================================================================================================
*/

CREATE TRIGGER trg_AfterUpdate_PreventYearReduction
ON VehicleDetails
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Year)
    BEGIN
        -- Check if any updated row has a lower production year than before
        IF EXISTS (
            SELECT 1 
            FROM Inserted i
            JOIN Deleted d ON i.ID = d.ID
            WHERE i.Year < d.Year
        )
        BEGIN
            RAISERROR('Business Rule Violation: Vehicle production year cannot be reduced to an earlier year.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END
END;
GO