-- Business Scenario:
-- The inventory reporting module needs to quickly evaluate the market density of specific manufacturers.
-- Create a Scalar Function named 'fn_GetMakeMarketSharePercentage' that accepts a MakeID (INT).
-- The function should calculate and return the percentage (DECIMAL(5,2)) of vehicles belonging to that Make 
-- compared to the total number of vehicles registered in the entire VehicleDetails table.

-- Solution:
CREATE FUNCTION fn_GetMakeMarketSharePercentage
(
    @MakeID INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @MakeCount INT = 0;
    DECLARE @TotalCount INT = 0;
    DECLARE @Percentage DECIMAL(5,2) = 0.00;

    -- Get count for specific Make
    SELECT @MakeCount = COUNT(*)
    FROM VehicleDetails
    WHERE MakeID = @MakeID;

    -- Get total count of all vehicles
    SELECT @TotalCount = COUNT(*)
    FROM VehicleDetails;

    -- Calculate percentage safely avoiding divide-by-zero
    IF @TotalCount > 0
    BEGIN
        SET @Percentage = CAST((CAST(@MakeCount AS FLOAT) / @TotalCount) * 100 AS DECIMAL(5,2));
    END

    RETURN @Percentage;
END;
GO

-- How to call and test it:
SELECT 
    MakeID,
    Make,
    dbo.fn_GetMakeMarketSharePercentage(MakeID) AS MarketSharePercentage
FROM Makes
ORDER BY MarketSharePercentage DESC;