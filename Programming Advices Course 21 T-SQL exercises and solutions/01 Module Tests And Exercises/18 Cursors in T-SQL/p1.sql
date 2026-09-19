-- Problem Scenario:
-- Write a basic T-SQL cursor that iterates through all records in the 'Makes' table row-by-row.
-- For each record, fetch the MakeID and Make name into local variables and print them in the format: 
-- "Manufacturer ID: [MakeID] | Name: [Make]". Ensure proper lifecycle management (DECLARE, OPEN, FETCH, CLOSE, DEALLOCATE).

-- Solution:
DECLARE @MakeID INT;
DECLARE @MakeName VARCHAR(100);

-- 1. Declare Cursor
DECLARE cur_Makes CURSOR FOR
SELECT MakeID, Make
FROM Makes;

-- 2. Open Cursor
OPEN cur_Makes;

-- 3. Fetch Initial Row
FETCH NEXT FROM cur_Makes INTO @MakeID, @MakeName;

-- 4. Loop Through Result Set
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Manufacturer ID: ' + CAST(@MakeID AS VARCHAR(10)) + ' | Name: ' + @MakeName;
    
    FETCH NEXT FROM cur_Makes INTO @MakeID, @MakeName;
END;

-- 5. Cleanup
CLOSE cur_Makes;
DEALLOCATE cur_Makes;