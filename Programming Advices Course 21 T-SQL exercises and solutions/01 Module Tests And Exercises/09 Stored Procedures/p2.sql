-- Business Scenario:
-- Performance and security requirements dictate that front-end applications should not run ad-hoc queries. 
-- Create a Stored Procedure named 'SP_GetVehiclesByYear' that takes a manufacturing Year as an input parameter 
-- and returns all vehicle display names and door counts manufactured in that year.

-- Solution:
CREATE PROCEDURE SP_GetVehiclesByYear
    @ManufacturingYear INT
AS
BEGIN
    SELECT 
        Vehicle_Display_Name, 
        NumDoors, 
        Year
    FROM VehicleDetails
    WHERE Year = @ManufacturingYear;
END;
GO

-- How to execute it:
EXEC SP_GetVehiclesByYear @ManufacturingYear = 2022;