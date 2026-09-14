-- Business Scenario:
-- The mobile app interface requires a standardized, clean vehicle label for display cards.
-- Write a Scalar Function named 'fn_GetVehicleDisplayName' that accepts a VehicleID (INT).
-- The function should retrieve the vehicle's Make, ModelName, SubModelName, and Year, 
-- and return a single formatted string in the format: "Make ModelName (SubModelName) - Year".
-- If SubModelName is NULL, it should format it as: "Make ModelName - Year".

-- Solution:
CREATE FUNCTION fn_GetVehicleDisplayName
(
    @VehicleID INT
)
RETURNS VARCHAR(300)
AS
BEGIN
    DECLARE @FormattedName VARCHAR(300);

    SELECT 
        @FormattedName = CONCAT(
            m.Make, ' ', 
            mm.ModelName, 
            IIF(sm.SubModelName IS NOT NULL AND TRIM(sm.SubModelName) <> '', CONCAT(' (', sm.SubModelName, ')'), ''),
            ' - ', 
            vd.Year
        )
    FROM VehicleDetails vd
    JOIN Makes m ON vd.MakeID = m.MakeID
    JOIN MakeModels mm ON vd.ModelID = mm.ModelID
    LEFT JOIN SubModels sm ON vd.SubModelID = sm.SubModelID
    WHERE vd.ID = @VehicleID;

    RETURN @FormattedName;
END;
GO

-- How to call and test it:
SELECT dbo.fn_GetVehicleDisplayName(10) AS StandardVehicleLabel;