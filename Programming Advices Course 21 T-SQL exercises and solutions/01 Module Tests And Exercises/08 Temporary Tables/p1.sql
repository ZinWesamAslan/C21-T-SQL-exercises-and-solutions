-- Business Scenario: Isolate core dataset for vehicles manufactured from 2020 onwards 
-- into an intermediate scratch storage table (#ModernVehicles) for safe reporting.

-- new idea to create a temp table ...
SELECT 
    vd.Vehicle_Display_Name, 
    vd.Year, 
    m.Make, 
    mm.ModelName
INTO #ModernVehicles
FROM VehicleDetails vd
JOIN MakeModels mm ON vd.ModelID = mm.ModelID
JOIN Makes m ON vd.MakeID = m.MakeID
WHERE vd.Year >= 2020;

-- Query the isolated temporary table safely
SELECT * FROM #ModernVehicles;