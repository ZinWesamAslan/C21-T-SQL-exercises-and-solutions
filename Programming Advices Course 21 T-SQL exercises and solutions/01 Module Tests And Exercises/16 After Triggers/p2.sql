/*
==================================================================================================
BUSINESS SCENARIO:
To optimize dashboard performance and eliminate expensive COUNT(*) aggregations, the 'Makes' 
table maintains a 'TotalVehiclesCount' column. Create an AFTER INSERT trigger on 'VehicleDetails' 
that dynamically increments the 'TotalVehiclesCount' in the 'Makes' table for every newly added 
vehicle, supporting both single and bulk insert operations seamlessly.
==================================================================================================
*/

-- 1. Add counter column to Makes table if not present
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Makes') AND name = 'TotalVehiclesCount')
BEGIN
    ALTER TABLE Makes ADD TotalVehiclesCount INT DEFAULT 0;
END;
GO

-- 2. Create the AFTER INSERT Trigger
CREATE TRIGGER trg_AfterInsert_UpdateMakeVehicleCount
ON VehicleDetails
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Aggregate inserted counts per MakeID to handle set-based (bulk) inserts
    UPDATE m
    SET m.TotalVehiclesCount = ISNULL(m.TotalVehiclesCount, 0) + i.InsertedCount
    FROM Makes m
    JOIN (
        SELECT MakeID, COUNT(*) AS InsertedCount
        FROM Inserted
        GROUP BY MakeID
    ) i ON m.MakeID = i.MakeID;
END;
GO