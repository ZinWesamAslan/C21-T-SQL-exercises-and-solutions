-- Business Scenario:
-- The executive summary API requires a consolidated breakdown per 
-- Make for a specific body style (@BodyID INT).
-- Write an MSTVF named 'fn_GetMakeBodyStyleSummary' returning a custom table
-- (@ResultTable) with columns:
--   - MakeID (INT), MakeName (VARCHAR(100)), TotalVehicles (INT), 
-- AverageDoors (DECIMAL(4,2)), Status (VARCHAR(50)).
-- Procedure requirements inside the MSTVF:
--   1. Insert aggregated data grouped by Make for the specified BodyID.
--   2. Update the 'Status' column: if TotalVehicles > 10, set status to 
-- 'High Density', otherwise set to 'Low Density'.

-- Solution:
CREATE FUNCTION fn_GetMakeBodyStyleSummary
(
    @BodyID INT
)
RETURNS @ResultTable TABLE
(
    MakeID INT,
    MakeName VARCHAR(100),
    TotalVehicles INT,
    AverageDoors DECIMAL(4,2),
    Status VARCHAR(50)
)
AS
BEGIN
    -- Step 1: Insert aggregated summary into return table variable
    INSERT INTO @ResultTable (MakeID, MakeName, TotalVehicles, AverageDoors)
    SELECT 
        m.MakeID,
        m.Make,
        COUNT(vd.ID),
        AVG(CAST(vd.NumDoors AS DECIMAL(4,2)))
    FROM Makes m
    JOIN VehicleDetails vd ON m.MakeID = vd.MakeID
    WHERE vd.BodyID = @BodyID
    GROUP BY m.MakeID, m.Make;

    -- Step 2: Apply business logic to update Status
    UPDATE @ResultTable
    SET Status = IIF(TotalVehicles > 10, 'High Density', 'Low Density');

    RETURN;
END;
GO

-- How to call and test it:
SELECT * 
FROM dbo.fn_GetMakeBodyStyleSummary(1);