-- Business Scenario:
-- The compliance department needs a reusable function to check whether a vehicle qualifies as a "Classic Vehicle".
-- Write a Scalar Function named 'fn_IsClassicVehicle' that accepts a VehicleID (INT).
-- The function should calculate the vehicle's age relative to the current year. 
-- If the vehicle is 25 years old or older, return BIT value 1 (True); otherwise, return BIT value 0 (False).

-- Solution:
CREATE FUNCTION fn_IsClassicVehicle
(
    @VehicleID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsClassic BIT = 0;
    DECLARE @VehicleYear INT;

    SELECT @VehicleYear = Year
    FROM VehicleDetails
    WHERE ID = @VehicleID;

    IF (YEAR(GETDATE()) - @VehicleYear) >= 25
    BEGIN
        SET @IsClassic = 1;
    END

    RETURN @IsClassic;
END;
GO

-- How to call and test it inside a SELECT query:
SELECT 
    ID,
    Vehicle_Display_Name,
    Year,
    dbo.fn_IsClassicVehicle(ID) AS IsClassic
FROM VehicleDetails
WHERE Year <= 2005;