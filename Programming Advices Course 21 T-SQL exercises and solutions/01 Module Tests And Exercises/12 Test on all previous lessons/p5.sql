-- Business Scenario:
-- An interviewer asks: Write a script demonstrating the staging of small 
-- reference lookup data into a Table Variable (@DriveTypeLookup)
-- and joining it with VehicleDetails to calculate total vehicles per DriveType where Year >= 2018.

-- Solution:
DECLARE @DriveTypeLookup TABLE (
    DriveTypeID INT PRIMARY KEY,
    DriveTypeName VARCHAR(50)
);

-- Populate table variable from permanent lookup table
INSERT INTO @DriveTypeLookup (DriveTypeID, DriveTypeName)
SELECT DriveTypeID, DriveTypeName
FROM DriveTypes;

-- Fast join with stage table variable
SELECT 
    dt.DriveTypeName,
    COUNT(vd.ID) AS VehicleCount
FROM VehicleDetails vd
JOIN @DriveTypeLookup dt ON vd.DriveTypeID = dt.DriveTypeID
WHERE vd.Year >= 2018
GROUP BY dt.DriveTypeName;