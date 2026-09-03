-- Task: Declare a variable named @TargetYear INT and set it to 2022. 
-- Write an IF statement that checks if there are any vehicles manufactured in that year using EXISTS. 
-- If true, print a success message saying 'Vehicles found for this year.'.

DECLARE @TargetYear INT = 2022;

IF EXISTS (SELECT 1 FROM VehicleDetails WHERE Year = @TargetYear)
BEGIN
    PRINT 'Vehicles found for this year.';
END