-- Task: Write a T-SQL script using a WHILE loop with a counter variable @Counter starting at 2000 and ending at 2020. 
-- In each iteration, print the current year and the total count of vehicles manufactured in that year using the VehicleDetails table.


DECLARE @Counter INT = 2000;
DECLARE @CountResult INT;

WHILE @Counter <= 2020
BEGIN
    SELECT @CountResult = COUNT(*) 
    FROM VehicleDetails 
    WHERE Year = @Counter;

    PRINT 'Year: ' + CAST(@Counter AS VARCHAR(4)) + ' - Total Vehicles: ' + CAST(@CountResult AS VARCHAR(10));
    
    SET @Counter = @Counter + 1;
END