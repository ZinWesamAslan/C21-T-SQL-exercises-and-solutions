-- Business Scenario:
-- Update the 'SP_AddNewMake' procedure so that it checks if the manufacturer name already exists in the Makes table.
-- If it already exists, do not insert it and print a warning message. 
-- If it does not exist, proceed with the insertion.

-- Solution:
CREATE PROCEDURE SP_AddNewMake
    @MakeName VARCHAR(100)
AS
BEGIN
    -- Check if the make already exists
    IF EXISTS (SELECT 1 FROM Makes WHERE Make = @MakeName)
    BEGIN
        PRINT 'The manufacturer "' + @MakeName + '" already exists in the database. Insertion skipped.';
    END
    ELSE
    BEGIN
        INSERT INTO Makes (Make)
        VALUES (@MakeName);
        
        PRINT 'Manufacturer "' + @MakeName + '" added successfully.';
    END
END;
GO

-- How to execute it:
EXEC SP_AddNewMake @MakeName = 'BMW';
