-- Task: Declare a table variable named @TopMakes with two columns: MakeID (INT) and MakeName (VARCHAR(100)).
-- Insert the first 5 records from the Makes table into this table variable.
-- Finally, write a SELECT statement to retrieve all records from @TopMakes ordered by MakeID.

DECLARE @TopMakes TABLE (
    MakeID INT,
    MakeName VARCHAR(100)
);

INSERT INTO @TopMakes (MakeID, MakeName)
SELECT TOP 5 MakeID, Make 
FROM Makes 
ORDER BY MakeID;

SELECT MakeID, MakeName 
FROM @TopMakes 
ORDER BY MakeID;