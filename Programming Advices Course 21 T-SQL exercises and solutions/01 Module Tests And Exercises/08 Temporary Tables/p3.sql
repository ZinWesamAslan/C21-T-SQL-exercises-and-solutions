-- Business Problem:
-- Your application has a heavy reporting page that joins three large tables: 
-- VehicleDetails, DriveTypes, and FuelTypes. Because the database is massive, 
-- this query is running very slowly and frustrating users.
-- 
-- Your task is to optimize it using a Temporary Table and an Index:
-- 1. Extract the required data from those joined tables and store it inside a Temporary Table.
-- 2. Since users will constantly filter and group this data by the manufacturing 'Year', 
--    manually create a Non-Clustered Index on the 'Year' column of your temporary table to speed up searches.
-- 3. Run a final SELECT query (such as counting vehicles grouped by Year) against your temporary table 
--    to make sure it leverages the index and runs fast.

SELECT 
    vd.Vehicle_Display_Name, 
    vd.Year, 
    dt.DriveTypeName, 
    ft.FuelTypeName
INTO #IndexedTempVehicles
FROM VehicleDetails vd
JOIN DriveTypes dt ON vd.DriveTypeID = dt.DriveTypeID
JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID;

-- Explicitly create a non-clustered index on the temporary table

-- new idea for us my friends ...
CREATE NONCLUSTERED INDEX IX_TempVehicles_Year 
ON #IndexedTempVehicles (Year);

-- Fast analytical query leveraging the index
SELECT Year, COUNT(*) AS VehicleCount
FROM #IndexedTempVehicles
GROUP BY Year
ORDER BY Year DESC;
