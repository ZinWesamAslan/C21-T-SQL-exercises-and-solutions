-- Business Scenario:
-- The reporting module needs a function that takes a manufacturing Year threshold (@MinYear INT) 
-- and returns a table containing VehicleID, VehicleName, Year, and a calculated column 'Category'.
-- The 'Category' must be assigned dynamically using procedural logic inside the function:
--   - 'Modern' if Year >= 2020
--   - 'Mid-Range' if Year between 2010 and 2019
--   - 'Legacy' if Year < 2010
-- Implement this using a Multi-Statement Table-Valued Function named 'fn_GetCategorizedVehicles'.

-- Solution:
CREATE FUNCTION fn_GetCategorizedVehicles
(
    @MinYear INT
)
RETURNS @VehicleReport TABLE
(
    VehicleID INT,
    VehicleName VARCHAR(200),
    ModelYear INT,
    Category VARCHAR(20)
)
AS
BEGIN
    -- Step 1: Populate raw data into return table
    INSERT INTO @VehicleReport (VehicleID, VehicleName, ModelYear)
    SELECT ID, Vehicle_Display_Name, Year
    FROM VehicleDetails
    WHERE Year >= @MinYear;

    -- Step 2: Apply conditional transformations
    UPDATE @VehicleReport
    SET Category = CASE 
        WHEN ModelYear >= 2020 THEN 'Modern'
        WHEN ModelYear BETWEEN 2010 AND 2019 THEN 'Mid-Range'
        ELSE 'Legacy'
    END;

    RETURN;
END;
GO

-- How to call and test it:
SELECT * 
FROM dbo.fn_GetCategorizedVehicles(2005)
ORDER BY ModelYear DESC;