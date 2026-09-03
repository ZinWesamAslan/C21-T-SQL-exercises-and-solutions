-- Task: Declare an integer variable named @TotalCount. 
-- Store the total number of vehicles that have an Engine_Cylinders equal to 8. 
-- Use an IF...ELSE statement: if the count is greater than 100, print 'Large V8 inventory'; otherwise, print 'Limited V8 inventory'.

DECLARE @TotalCount INT;

SELECT @TotalCount = COUNT(*) 
FROM VehicleDetails 
WHERE Engine_Cylinders = 8;

IF @TotalCount > 100
    PRINT 'Large V8 inventory';
ELSE
    PRINT 'Limited V8 inventory';