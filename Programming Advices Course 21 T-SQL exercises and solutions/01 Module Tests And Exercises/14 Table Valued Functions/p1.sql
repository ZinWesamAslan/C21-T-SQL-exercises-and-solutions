-- Business Scenario:
-- The search catalog team requires a lightweight, highly efficient reusable object to fetch vehicles 
-- filtered by a minimum production year.
-- Create an Inline Table-Valued Function (ITVF) named 'fn_GetVehiclesFromYear' that accepts @StartYear INT.
-- The function must return a table containing: ID, Vehicle_Display_Name, Year, MakeID, and ModelID 
-- for all vehicles with Year >= @StartYear.

-- Solution:
CREATE FUNCTION fn_GetVehiclesFromYear
(
    @StartYear INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ID,
        Vehicle_Display_Name,
        Year,
        MakeID,
        ModelID
    FROM VehicleDetails
    WHERE Year >= @StartYear
);
GO

-- How to call and test it:
SELECT * 
FROM dbo.fn_GetVehiclesFromYear(2022);