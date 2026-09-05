-- Task: Write Nested WHILE Loops to analyze cylinder configurations across specific year milestones.
-- Outer loop iterates through years: 2018, 2019, 2020.
-- Inner loop iterates through cylinder options: 4, 6, 8.
-- Inside the inner loop, count how many vehicles exist for that specific Year AND Cylinder count.
-- If the count is greater than 0, print a detailed formatted message showing the matrix combination and count.

DECLARE @LoopYear INT = 2018;
DECLARE @Cylinders INT;
DECLARE @CombCount INT;

WHILE @LoopYear <= 2020
BEGIN
    SET @Cylinders = 4;
    
    WHILE @Cylinders <= 8
    BEGIN
        -- We only care about standard cylinder types: 4, 6, and 8
        IF @Cylinders IN (4, 6, 8)
        begin
            SELECT @CombCount = COUNT(*)
            FROM VehicleDetails
            WHERE Year = @LoopYear AND Engine_Cylinders = @Cylinders;

            IF @CombCount > 0
            BEGIN
                PRINT 'Year: ' + CAST(@LoopYear AS VARCHAR(4)) + ' | Cylinders: ' + CAST(@Cylinders AS VARCHAR(2)) + ' | Matching Vehicles: ' + CAST(@CombCount AS VARCHAR(10));
            END
        END

        SET @Cylinders = @Cylinders + 2; -- steps through 4, then 6, then 8
    END

    SET @LoopYear = @LoopYear + 1;
END