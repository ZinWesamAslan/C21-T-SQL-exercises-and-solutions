-- Task: Declare an integer variable named @TargetYear and assign it the value 2020. 
-- Then, declare another variable named @TotalCount and store the total count of vehicles manufactured in that specific year using the first variable. 
-- Finally, select the variable to display the result.

DECLARE @TargetYear INT = 2020;
DECLARE @TotalCount INT;

SELECT @TotalCount = COUNT(*)
FROM VehicleDetails
WHERE Year = @TargetYear;

SELECT @TotalCount AS TotalVehiclesCount;