-- Problem Scenario:
-- Write a SCROLL cursor over the 'Makes' table to demonstrate bi-directional navigation.
-- Perform the following fetches sequentially:
-- 1. Fetch the LAST record.
-- 2. Fetch the PRIOR record.
-- 3. Fetch the 3rd record using ABSOLUTE positioning.
-- 4. Move 2 rows forward from current position using RELATIVE positioning.
SELECT MakeID, Make
FROM Makes
ORDER BY MakeID ASC;
-- Solution:
DECLARE @MakeID INT;
DECLARE @MakeName VARCHAR(100);

-- Declare a SCROLL cursor to allow non-sequential fetching
DECLARE cur_ScrollMakes CURSOR SCROLL FOR
SELECT MakeID, Make
FROM Makes
ORDER BY MakeID ASC;

OPEN cur_ScrollMakes;

-- 1. Fetch LAST
FETCH LAST FROM cur_ScrollMakes INTO @MakeID, @MakeName;
PRINT '1. LAST Row: ' + CAST(@MakeID AS VARCHAR(10)) + ' - ' + @MakeName;

-- 2. Fetch PRIOR
FETCH PRIOR FROM cur_ScrollMakes INTO @MakeID, @MakeName;
PRINT '2. PRIOR Row: ' + CAST(@MakeID AS VARCHAR(10)) + ' - ' + @MakeName;

-- 3. Fetch ABSOLUTE 3
FETCH ABSOLUTE 3 FROM cur_ScrollMakes INTO @MakeID, @MakeName;
PRINT '3. ABSOLUTE 3rd Row: ' + CAST(@MakeID AS VARCHAR(10)) + ' - ' + @MakeName;

-- 4. Fetch RELATIVE 2
FETCH RELATIVE 2 FROM cur_ScrollMakes INTO @MakeID, @MakeName;
PRINT '4. RELATIVE +2 Rows: ' + CAST(@MakeID AS VARCHAR(10)) + ' - ' + @MakeName;

CLOSE cur_ScrollMakes;
DEALLOCATE cur_ScrollMakes;