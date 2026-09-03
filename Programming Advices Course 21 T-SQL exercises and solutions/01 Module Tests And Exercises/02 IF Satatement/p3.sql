-- Task: Declare a variable named @CheckYear INT = 2020 and another @CheckCylinders INT = 4.
-- Write an IF statement to check if there is any vehicle matching BOTH the year and the 4 cylinders using logical operators.
-- If it exists, select the top 5 vehicle names and years; otherwise, print 'No matching vehicles found'.

DECLARE @CheckYear INT = 2020;
DECLARE @CheckCylinders INT = 4;

IF EXISTS 
(
    SELECT 1 
    FROM VehicleDetails 
    WHERE Year = @CheckYear AND Engine_Cylinders = @CheckCylinders
)
	BEGIN
		SELECT TOP 5 Vehicle_Display_Name, Year, Engine_Cylinders
		FROM VehicleDetails
		WHERE Year = @CheckYear AND Engine_Cylinders = @CheckCylinders;
	END
ELSE
	BEGIN
		PRINT 'No matching vehicles found';
	END