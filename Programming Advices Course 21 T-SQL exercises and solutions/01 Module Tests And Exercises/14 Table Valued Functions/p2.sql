-- Business Scenario:
-- The analytics dashboard requires an ITVF that summarizes manufacturing volume and door distribution per Make for a given fuel type.
-- Create an ITVF named 'fn_GetMakeSummaryByFuelType' that accepts @FuelTypeID INT.
-- The function should return: MakeID, Make, TotalVehicles (COUNT), AvgDoors (AVG), MinYear (MIN), and MaxYear (MAX).

-- Solution:
CREATE FUNCTION fn_GetMakeSummaryByFuelType
(
    @FuelTypeID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        m.MakeID,
        m.Make,
        COUNT(vd.ID) AS TotalVehicles,
        AVG(CAST(vd.NumDoors AS FLOAT)) AS AvgDoors,
        MIN(vd.Year) AS MinYear,
        MAX(vd.Year) AS MaxYear
    FROM Makes m
    JOIN VehicleDetails vd ON m.MakeID = vd.MakeID
    WHERE vd.FuelTypeID = @FuelTypeID
    GROUP BY m.MakeID, m.Make
);
GO

-- How to call and test it:
SELECT * 
FROM dbo.fn_GetMakeSummaryByFuelType(1); -- Assuming 1 is Gasoline/Gas