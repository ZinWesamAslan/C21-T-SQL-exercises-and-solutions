-- Task: Write a script with a WHILE loop that iterates through years from 1957 to 2020.
-- Inside the loop:
-- 1. If the year is 2012, use CONTINUE to skip the print/processing for that specific year.
-- 2. For all other years, calculate the total number of vehicles manufactured in that year.
-- 3. If the total number of vehicles in that year is less than 130, use BREAK to terminate the loop entirely.
-- Otherwise, print the year and the vehicle count.

DECLARE @TargetYear INT = 1957;
DECLARE @VehiclesCount INT;

WHILE @TargetYear <= 2020
BEGIN
    -- Skip the year 2012 completely using CONTINUE
    IF @TargetYear = 2012
    BEGIN
        SET @TargetYear = @TargetYear + 1;
        CONTINUE;
    END

    -- Get vehicle count for the current year
    SELECT @VehiclesCount = COUNT(*) 
    FROM VehicleDetails 
    WHERE Year = @TargetYear;

    -- Break the loop if a year has fewer than 130 vehicles recorded
    IF @VehiclesCount < 130
    BEGIN
        PRINT 'Terminating loop: Year ' + CAST(@TargetYear AS VARCHAR(4)) + ' has fewer than 130 vehicles (' + CAST(@VehiclesCount AS VARCHAR(10)) + ').';
        BREAK;
    END

    PRINT 'Processed Year: ' + CAST(@TargetYear AS VARCHAR(4)) + ' | Count: ' + CAST(@VehiclesCount AS VARCHAR(10));

    SET @TargetYear = @TargetYear + 1;
END